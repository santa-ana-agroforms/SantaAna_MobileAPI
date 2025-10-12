#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Generador "basicón" de formularios para PostgreSQL (solo emite SQL a archivo)

- Crea una categoría (por defecto "Básicos") y N formularios muy simples.
- Cada formulario tiene:
    * 1 página
    * 3 campos: string (texto), number (numérico), boolean (booleano)
- Opcionalmente, algunos formularios incluyen un GRUPO, al cual se asocian los 3 campos.
- Inserta el mapeo formulario<->usuario si se pasa --assign-user (no crea usuarios).
- NO se conecta a la base; SOLO escribe un archivo .sql con los INSERT/UPDATE.

Tablas esperadas (consistentes con tu esquema):
- formularios_clase_campo (clase, estructura)
- formularios_categoria (id, nombre, descripcion)
- formularios_formulario (...)
- formularios_formularioindexversion (id_index_version, fecha_creacion, formulario_id)
- formularios_formularios_index_version (id_index_version, id_formulario)
- formularios_pagina (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
- formularios_pagina_index_version (id_pagina, id_index_version)
- formularios_pagina_version (id_pagina_version varchar(32), fecha_creacion, id_pagina varchar(32))
- formularios_campo (id_campo varchar(32), tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
- formularios_pagina_campo (id_campo, sequence, id_pagina_version)
- formularios_grupo (id_grupo, nombre, id_campo_group)
- formularios_campo_grupo (id_grupo, id_campo)
- formularios_user_formulario (id_formulario_id, id_usuario_id)

Uso típico:
  python generador_forms_basicos_pg.py \
    --out ./basic_forms.sql \
    --forms 5 \
    --category-name "Básicos" \
    --group-prob 0.4 \
    --assign-user "danvalA" \
    --seed 7

Sin asignar a usuario (deja los formularios sin relación de usuario):
  python generador_forms_basicos_pg.py --out ./basic_forms.sql --forms 3

"""

import argparse
import json
import random
import string
import uuid
import datetime as dt
from typing import Any, Dict, List, Optional, Tuple

# =========================
# Utilidades
# =========================

RUN_PREFIX = uuid.uuid4().hex[:6]
GENERATED_NAMES: set[str] = set()

def hex32() -> str:
    """32 hex chars (sin guiones). Útil para id_campo y id_pagina_version."""
    return uuid.uuid4().hex

def now_dt_iso() -> str:
    """UTC ISO para timestamptz: 'YYYY-MM-DDTHH:MM:SSZ'."""
    return dt.datetime.utcnow().isoformat(timespec="seconds") + "Z"

def slugify_name(n: str, max_len: int = 64) -> str:
    keep = string.ascii_lowercase + string.digits + "_"
    s = n.lower().replace(" ", "_")
    out = "".join(ch for ch in s if ch in keep)[:max_len]
    return out or ("campo_" + hex32()[:6])

def unique_nombre_campo(base: str, max_len: int = 64) -> str:
    """Evita duplicados de nombre_campo dentro de una corrida."""
    base = slugify_name(base, max_len=max_len)
    cand = f"{base}_{RUN_PREFIX}"
    if cand not in GENERATED_NAMES:
        GENERATED_NAMES.add(cand)
        return cand[:max_len]
    for i in range(1, 1000):
        cand2 = f"{base}_{RUN_PREFIX}_{i}"
        if cand2 not in GENERATED_NAMES:
            GENERATED_NAMES.add(cand2)
            return cand2[:max_len]
    cand3 = f"{base}_{uuid.uuid4().hex[:6]}"
    GENERATED_NAMES.add(cand3)
    return cand3[:max_len]

def rand_label(prefix: str) -> str:
    return f"{prefix} {random.randint(1, 999)}"

def esc(s: Any) -> str:
    """Escapado SQL básico para strings; booleans y None también."""
    if s is None:
        return "NULL"
    if isinstance(s, bool):
        return "TRUE" if s else "FALSE"
    if isinstance(s, (int, float)):
        return str(s)
    # strings / json / uuid -> texto comillado con '' escapadas
    txt = str(s).replace("'", "''")
    return f"'{txt}'"

# =========================
# Emisor SQL (a archivo)
# =========================

class SqlWriter:
    def __init__(self, out_path: str):
        self.out_path = out_path
        self.lines: List[str] = []
        self.lines.append("-- Archivo SQL generado automáticamente (basic forms)")
        self.lines.append("SET client_min_messages TO WARNING;")
        self.lines.append("")

    def add(self, sql: str):
        sql = sql.strip()
        if not sql.endswith(";"):
            sql += ";"
        self.lines.append(sql + "\n")

    def comment(self, text: str):
        self.lines.append(f"-- {text}")

    def save(self):
        with open(self.out_path, "w", encoding="utf-8") as f:
            f.write("\n".join(self.lines))

# =========================
# Datos fijos "basicones"
# =========================

# Solo las clases que vamos a usar
CLASES: Dict[str, Dict[str, Any]] = {
    "string": {},
    "number": {"min": [None, "number"], "max": [None, "number"], "step": [None, "number"], "unit": [None, "$", "€", "£", "Q"]},
    "boolean": {},
    "group": {"id_group": ["string"], "name": ["string"], "fieldCondition": ["string"]},
}

TIPO_POR_CLASE = {
    "string": "texto",
    "number": "numerico",
    "boolean": "booleano",
    "group": "texto",
}

# =========================
# Helpers de inserción (solo escriben SQL)
# =========================

def ensure_clases(writer: SqlWriter):
    writer.comment("Clases mínimas necesarias (idempotente).")
    for clase, estructura in CLASES.items():
        writer.add(
            f"""
            INSERT INTO formularios_clase_campo (clase, estructura)
            VALUES ({esc(clase)}, {esc(json.dumps(estructura, ensure_ascii=False))})
            ON CONFLICT (clase) DO NOTHING
            """
        )

def insert_categoria(writer: SqlWriter, nombre: str, descripcion: Optional[str] = None) -> str:
    cid = str(uuid.uuid4())
    desc = descripcion or f"Categoría {nombre}"
    writer.add(
        f"""
        INSERT INTO formularios_categoria (id, nombre, descripcion)
        VALUES ({esc(cid)}, {esc(nombre)}, {esc(desc)})
        """
    )
    return cid

def insert_formulario(writer: SqlWriter, categoria_id: str, nombre: str) -> str:
    fid = str(uuid.uuid4())
    descripcion = f"Formulario básico: {nombre}"
    disponible_desde = dt.date.today().isoformat()
    disponible_hasta = (dt.date.today() + dt.timedelta(days=365)).isoformat()
    estado = "activo"
    forma_envio = "mixto"
    es_publico = False
    auto_envio = False
    permitir_fotos = False
    permitir_gps = False

    writer.add(
        f"""
        INSERT INTO formularios_formulario
            (id, nombre, descripcion, permitir_fotos, permitir_gps,
             disponible_desde_fecha, disponible_hasta_fecha, estado, forma_envio,
             es_publico, auto_envio, categoria_id)
        VALUES (
            {esc(fid)}, {esc(nombre)}, {esc(descripcion)},
            {esc(permitir_fotos)}, {esc(permitir_gps)},
            {esc(disponible_desde)}, {esc(disponible_hasta)}, {esc(estado)}, {esc(forma_envio)},
            {esc(es_publico)}, {esc(auto_envio)}, {esc(categoria_id)}
        )
        """
    )
    return fid

def insert_index_version(writer: SqlWriter, formulario_id: str) -> str:
    ivid = str(uuid.uuid4())
    writer.add(
        f"""
        INSERT INTO formularios_formularioindexversion (id_index_version, fecha_creacion, formulario_id)
        VALUES ({esc(ivid)}, {esc(now_dt_iso())}, {esc(formulario_id)})
        """
    )
    writer.add(
        f"""
        INSERT INTO formularios_formularios_index_version (id_index_version, id_formulario)
        VALUES ({esc(ivid)}, {esc(formulario_id)})
        """
    )
    return ivid

def insert_pagina(writer: SqlWriter, formulario_id: str, index_version_id: str, secuencia: int = 1) -> Tuple[str, str]:
    pid = str(uuid.uuid4())  # uuid con guiones
    writer.add(
        f"""
        INSERT INTO formularios_pagina
            (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
        VALUES (
            {esc(pid)}, {esc(secuencia)}, {esc(f"Página {secuencia}")},
            {esc("Página única básica")},
            {esc(formulario_id)}, {esc(index_version_id)}
        )
        """
    )
    # vínculo adicional (si aplica en tu esquema)
    writer.add(
        f"""
        INSERT INTO formularios_pagina_index_version (id_pagina, id_index_version)
        VALUES ({esc(pid)}, {esc(index_version_id)})
        ON CONFLICT (id_pagina) DO NOTHING
        """
    )
    # pagina_version usa varchar(32) para ambos IDs
    pvid = hex32()
    pid_compact = pid.replace("-", "")
    if len(pid_compact) != 32:
        pid_compact = (pid_compact[:32]).ljust(32, "0")

    writer.add(
        f"""
        INSERT INTO formularios_pagina_version (id_pagina_version, fecha_creacion, id_pagina)
        VALUES ({esc(pvid)}, {esc(now_dt_iso())}, {esc(pid_compact)})
        """
    )
    return pid, pvid

def insert_campo(writer: SqlWriter, clase: str, etiqueta: str, ayuda: str = "", requerido: bool = False, config: Optional[Dict[str, Any]] = None) -> str:
    cid = hex32()
    tipo = TIPO_POR_CLASE[clase]
    nombre_campo = unique_nombre_campo(f"{clase}_{etiqueta}")
    config_json = json.dumps(config or {}, ensure_ascii=False)
    writer.add(
        f"""
        INSERT INTO formularios_campo
            (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
        VALUES (
            {esc(cid)}, {esc(tipo)}, {esc(clase)}, {esc(nombre_campo)},
            {esc(etiqueta)}, {esc(ayuda)}, {esc(config_json)}, {esc(requerido)}
        )
        """
    )
    return cid

def insert_pagina_campo(writer: SqlWriter, id_pagina_version: str, id_campo: str, sequence: int):
    writer.add(
        f"""
        INSERT INTO formularios_pagina_campo (id_campo, sequence, id_pagina_version)
        VALUES ({esc(id_campo)}, {esc(sequence)}, {esc(id_pagina_version)})
        """
    )

def insert_grupo(writer: SqlWriter, nombre: str, campo_group_id: str) -> str:
    gid = ("grp_" + uuid.uuid4().hex)[:64]
    writer.add(
        f"""
        INSERT INTO formularios_grupo (id_grupo, nombre, id_campo_group)
        VALUES ({esc(gid)}, {esc(nombre)}, {esc(campo_group_id)})
        """
    )
    return gid

def link_campo_a_grupo(writer: SqlWriter, id_grupo: str, id_campo: str):
    writer.add(
        f"""
        INSERT INTO formularios_campo_grupo (id_grupo, id_campo)
        SELECT {esc(id_grupo)}, {esc(id_campo)}
        WHERE NOT EXISTS (
            SELECT 1 FROM formularios_campo_grupo
            WHERE id_grupo = {esc(id_grupo)} AND id_campo = {esc(id_campo)}
        )
        """
    )

def assign_form_to_user(writer: SqlWriter, formulario_id: str, username: str):
    writer.add(
        f"""
        INSERT INTO formularios_user_formulario (id_formulario_id, id_usuario_id)
        SELECT {esc(formulario_id)}, {esc(username)}
        WHERE NOT EXISTS (
          SELECT 1 FROM formularios_user_formulario
          WHERE id_formulario_id = {esc(formulario_id)} AND id_usuario_id = {esc(username)}
        )
        """
    )

# =========================
# Generación de un form básico
# =========================

def generar_form_basico(writer: SqlWriter, categoria_id: str, nombre_form: str, con_grupo: bool) -> str:
    # Form y versiones/páginas
    fid = insert_formulario(writer, categoria_id, nombre_form)
    ivid = insert_index_version(writer, fid)
    _pid, pvid = insert_pagina(writer, fid, ivid, secuencia=1)

    seq = 1

    # Si lleva grupo, primero insertamos el "campo group" y su fila en formularios_grupo
    gid: Optional[str] = None
    if con_grupo:
        cfg_group = {"id_group": "", "name": "", "fieldCondition": "always"}  # se rellena abajo
        campo_group_id = insert_campo(writer, "group", etiqueta="Grupo Básico", ayuda="Contenedor", requerido=False, config=cfg_group)
        gid = insert_grupo(writer, "Grupo Básico", campo_group_id)
        # actualizar config del campo group (en SQL puedes dejarlo así; si querés exactitud, se podría UPDATE)
        # Para mantener el archivo corto, lo dejamos como quedó en INSERT.
        insert_pagina_campo(writer, pvid, campo_group_id, seq); seq += 1

    # Campos: texto, número, booleano
    c_text = insert_campo(writer, "string", etiqueta="Nombre", ayuda="Ingrese un texto", requerido=True)
    insert_pagina_campo(writer, pvid, c_text, seq); seq += 1

    c_num = insert_campo(writer, "number", etiqueta="Cantidad", ayuda="Ingrese un número", requerido=False,
                         config={"min": 0, "max": 100, "step": 1, "unit": None})
    insert_pagina_campo(writer, pvid, c_num, seq); seq += 1

    c_bool = insert_campo(writer, "boolean", etiqueta="Activo", ayuda="Sí/No", requerido=False)
    insert_pagina_campo(writer, pvid, c_bool, seq); seq += 1

    # Si hubo grupo, asociamos los 3 campos al grupo
    if gid:
        for cid in (c_text, c_num, c_bool):
            link_campo_a_grupo(writer, gid, cid)

    return fid

# =========================
# CLI
# =========================

def main():
    ap = argparse.ArgumentParser(description="Generador basicón: emite SQL con formularios simples (texto, número, booleano).")
    ap.add_argument("--out", required=True, help="Ruta del archivo .sql a generar")
    ap.add_argument("--forms", type=int, default=3, help="Cantidad de formularios a crear")
    ap.add_argument("--category-name", type=str, default="Básicos", help="Nombre de la categoría a crear")
    ap.add_argument("--group-prob", type=float, default=0.35, help="Probabilidad de que un formulario tenga grupo")
    ap.add_argument("--assign-user", type=str, default=None, help="Si se indica, se inserta la asignación formulario->usuario (no crea usuarios)")
    ap.add_argument("--seed", type=int, default=None, help="Semilla para reproducibilidad")

    args = ap.parse_args()
    if args.seed is not None:
        random.seed(args.seed)

    w = SqlWriter(args.out)
    w.comment(f"Semilla: {args.seed}")
    w.comment(f"Formularios: {args.forms} | Prob. grupo: {args.group_prob}")
    w.comment("")

    # 1) Clases mínimas
    ensure_clases(w)
    w.comment("")

    # 2) Categoría
    cat_id = insert_categoria(w, args.category_name, f"Categoría auto '{args.category_name}'")
    w.comment(f"Categoría creada: {args.category_name} -> {cat_id}")
    w.comment("")

    # 3) Formularios
    fids: List[str] = []
    for i in range(1, args.forms + 1):
        con_grupo = random.random() < args.group_prob
        fname = f"Formulario Básico {i}"
        fid = generar_form_basico(w, cat_id, fname, con_grupo)
        fids.append(fid)
        w.comment(f"Creado {fname} (id={fid}) {'[con GRUPO]' if con_grupo else ''}")

        # 4) Asignación a usuario (si se pidió)
        if args.assign_user:
            assign_form_to_user(w, fid, args.assign_user)

        w.comment("")

    # Listado final
    w.comment("Resumen de formularios creados:")
    for idx, fid in enumerate(fids, 1):
        w.comment(f"  {idx}. {fid}")

    # Guardar archivo
    w.save()
    print(f"[OK] SQL generado en: {args.out}")

if __name__ == "__main__":
    main()

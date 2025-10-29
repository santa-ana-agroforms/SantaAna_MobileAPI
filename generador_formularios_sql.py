#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Generador de SQL para formularios (modelo modular y versionado) con IDs numéricos de 32 dígitos.

Nuevo:
  --id-prefix "33"  # Prefijo con el que "empiezan" los IDs (solo dígitos). Default: "1"
  --id-start  1     # Contador inicial (≥1). Default: 1

Regla de ID:
  id = <prefix> + <ceros> + <contador>   con longitud total EXACTA de 32
  Ej: prefix=33, contador=1 -> 33000000000000000000000000000001 (32 dígitos)

Notas:
- Estos IDs se insertan en columnas uuid (PostgreSQL acepta 32 hex sin guiones) o varchar(32).
- Si la combinación prefix+contador supera 32 dígitos, el script falla para evitar IDs inválidos.

Uso:
  python generador_formularios_sql.py \
    --categorias 2 \
    --forms-por-categoria 3 \
    --id-prefix 33 \
    --id-start 1 \
    --output seed_forms.sql

  # Asignar a usuario existente (no crear) con otro prefijo
  python generador_formularios_sql.py \
    --categorias 1 --forms-por-categoria 2 \
    --usuario operador1 \
    --id-prefix 777 \
    --output seed_operador1.sql
"""
import argparse
import json
import random
import string
import sys
from datetime import datetime, timedelta, timezone

# ─────────────────────────────────────────────────────────
# Generador de IDs numéricos de 32 dígitos
# ─────────────────────────────────────────────────────────
_ID_PREFIX = "1"
_ID_COUNTER = 0
_ID_START = 1

def init_id_generator(prefix: str, start: int):
    global _ID_PREFIX, _ID_COUNTER, _ID_START
    if not prefix.isdigit():
        raise ValueError("--id-prefix debe contener solo dígitos [0-9].")
    if start < 1:
        raise ValueError("--id-start debe ser ≥ 1.")
    _ID_PREFIX = prefix
    _ID_START = start
    _ID_COUNTER = start - 1  # para que el primer next sea 'start'

def _make_32_digit_id(prefix: str, counter: int) -> str:
    cnt = str(counter)
    total_len = len(prefix) + len(cnt)
    if total_len > 32:
        raise ValueError(f"El ID excede 32 dígitos (prefix={prefix}, counter={cnt}).")
    zeros = "0" * (32 - total_len)
    return f"{prefix}{zeros}{cnt}"

def gen_id32() -> str:
    """Id de 32 dígitos numéricos (válido como uuid hex sin guiones)."""
    global _ID_COUNTER, _ID_PREFIX
    _ID_COUNTER += 1
    return _make_32_digit_id(_ID_PREFIX, _ID_COUNTER)

# 32 dígitos para varchar(32) (p.ej., id_pagina_version)
def gen_hex32() -> str:
    return gen_id32()

# ─────────────────────────────────────────────────────────
# Helpers generales
# ─────────────────────────────────────────────────────────
def q(v: str) -> str:
    if v is None:
        return "NULL"
    if not isinstance(v, str):
        v = str(v)
    return "'" + v.replace("'", "''") + "'"

def qjson(obj) -> str:
    return q(json.dumps(obj, ensure_ascii=False))

def now_tz() -> str:
    return datetime.now(timezone.utc).isoformat()

def rand_bool(p_true=0.5) -> bool:
    return random.random() < p_true

def rand_word(n=8):
    letters = string.ascii_lowercase
    return ''.join(random.choice(letters) for _ in range(n))

def rand_sentence(words=6):
    return ' '.join(rand_word(random.randint(4,8)) for _ in range(words)).capitalize() + '.'

def choose(lst):
    return random.choice(lst)

def daterange_pair():
    start = datetime.now(timezone.utc) - timedelta(days=random.randint(0, 60))
    end = start + timedelta(days=random.randint(10, 120))
    return start.date().isoformat(), end.date().isoformat()

# ─────────────────────────────────────────────────────────
# Catálogos
# ─────────────────────────────────────────────────────────
ESTADOS = ["borrador", "activo", "pausado", "archivado"]
FORMAS_ENVIO = ["manual", "al_guardar", "programado"]
CLASES = {
    "texto": {"props": {"maxLength": 120, "placeholder": "Escribe aquí"}},
    "numero": {"props": {"min": 0, "max": 100000, "decimales": 2}},
    "fecha": {"props": {"formato": "yyyy-MM-dd"}},
    "select": {"props": {"origen": "dataset", "modo": "pair"}},
    "gps": {"props": {"precision_m": 15}},
    "calc": {"props": {"lenguaje": "ts", "readOnly": True}},
    "boolean": {"props": {"labels": ["No","Sí"]}},
    "group": {"props": {"repetible": False}},
}

# ─────────────────────────────────────────────────────────
# SQL builder
# ─────────────────────────────────────────────────────────
class SQLBuilder:
    def __init__(self):
        self.lines = []
    def add(self, line: str):
        self.lines.append(line)
    def nl(self, n=1):
        for _ in range(n):
            self.lines.append("")
    def render(self) -> str:
        return "\n".join(self.lines) + "\n"

# ─────────────────────────────────────────────────────────
# Seeds
# ─────────────────────────────────────────────────────────
def seed_clase_campo(sb: SQLBuilder):
    sb.add("-- Clases de campo (si no existen)")
    for clase, estructura in CLASES.items():
        sb.add(
            f"insert into formularios_clase_campo (clase, estructura)\n"
            f"select {q(clase)}, {qjson(estructura)}\n"
            f"where not exists (\n"
            f"  select 1 from formularios_clase_campo where clase = {q(clase)}\n"
            f");"
        )
    sb.nl()

def seed_categorias(sb: SQLBuilder, n_categorias: int):
    categorias = []
    sb.add("-- Categorías")
    for i in range(n_categorias):
        cat_id = gen_id32()
        nombre = f"Categoría {i+1} - {rand_word(6)}"
        desc = rand_sentence(10)
        sb.add(
            "insert into formularios_categoria (id, nombre, descripcion)\n"
            f"values ({q(cat_id)}, {q(nombre)}, {q(desc)});"
        )
        categorias.append({"id": cat_id, "nombre": nombre})
    sb.nl()
    return categorias

def seed_fuente_datos(sb: SQLBuilder, nombre_base: str, creado_por_id: str):
    fid = gen_id32()
    cols = [{"name":"id","type":"text"}, {"name":"label","type":"text"}]
    preview = [{"id": "001", "label": "Opción A"}, {"id":"002","label":"Opción B"}]
    blob_name = f"{nombre_base.lower().replace(' ', '_')}_{rand_word(4)}.csv"
    sb.add("-- Fuente de datos")
    sb.add(
        "insert into formularios_fuente_datos\n"
        "(id, nombre, descripcion, archivo_nombre, blob_name, blob_url, tipo_archivo, columnas, preview_data, fecha_subida, activo, creado_por_id)\n"
        f"values ({q(fid)}, {q(nombre_base)}, {q('Dataset de opciones demo')},\n"
        f"        {q(blob_name)}, {q(blob_name)}, {q('https://storage.example/'+blob_name)},\n"
        f"        {'%s'}, {qjson(cols)}, {qjson(preview)}, to_timestamp(extract(epoch from now())), true, {q(creado_por_id)});".replace("%s", q("csv"))
    )
    sb.nl()
    return fid

def seed_fuente_valores(sb: SQLBuilder, fuente_id: str, campo_id: str, n=6):
    sb.add("-- Valores de la fuente de datos para un campo select")
    for i in range(n):
        vid = gen_id32()
        key = f"{100+i:03d}"
        label = f"Item {i+1}"
        raw = {"id": key, "label": label}
        sb.add(
            "insert into formularios_fuente_datos_valor\n"
            "(id, columna, key_text, label_text, valor_raw, extras, creado_en, campo_id, fuente_id)\n"
            f"values ({q(vid)}, {q('label')}, {q(key)}, {q(label)}, {qjson(raw)}, {qjson({})},\n"
            f"        to_timestamp(extract(epoch from now())), {q(campo_id)}, {q(fuente_id)});"
        )
    sb.nl()

def seed_formulario_completo(sb: SQLBuilder, categoria_id: str, creado_por_id: str):
    form_id = gen_id32()
    nombre = f"Formulario {rand_word(5).capitalize()}"
    descripcion = rand_sentence(12)
    permitir_fotos = rand_bool(0.7)
    permitir_gps = rand_bool(0.6)
    desde, hasta = daterange_pair()
    estado = choose(ESTADOS)
    forma_envio = choose(FORMAS_ENVIO)
    es_publico = rand_bool(0.3)
    auto_envio = rand_bool(0.4)
    periodicidad = random.choice([None, 7, 15, 30])

    sb.add("-- Formulario")
    sb.add(
        "insert into formularios_formulario\n"
        "(id, nombre, descripcion, permitir_fotos, permitir_gps, disponible_desde_fecha,\n"
        " disponible_hasta_fecha, estado, forma_envio, es_publico, auto_envio, categoria_id, periodicidad)\n"
        f"values ({q(form_id)}, {q(nombre)}, {q(descripcion)}, {str(permitir_fotos).lower()}, {str(permitir_gps).lower()},\n"
        f"        {q(desde)}, {q(hasta)}, {q(estado)}, {q(forma_envio)}, {str(es_publico).lower()}, {str(auto_envio).lower()},\n"
        f"        {q(categoria_id) if categoria_id else 'NULL'}, { 'NULL' if periodicidad is None else periodicidad });"
    )
    sb.nl()

    idx_id = gen_id32()
    sb.add("-- Index version del formulario")
    sb.add(
        "insert into formularios_formularioindexversion (id_index_version, fecha_creacion)\n"
        f"values ({q(idx_id)}, to_timestamp(extract(epoch from now())));"
    )
    sb.add(
        "insert into formularios_formularios_index_version (id_index_version, id_formulario)\n"
        f"values ({q(idx_id)}, {q(form_id)});"
    )
    sb.nl()

    n_paginas = random.randint(2, 4)
    pagina_versions = []
    for p in range(n_paginas):
        pagina_id = gen_id32()
        secuencia = p
        nombre_p = f"Página {p+1}"
        desc_p = rand_sentence(10)
        sb.add("-- Página")
        sb.add(
            "insert into formularios_pagina (id_pagina, secuencia, nombre, descripcion)\n"
            f"values ({q(pagina_id)}, {secuencia}, {q(nombre_p)}, {q(desc_p)});"
        )
        pver = gen_hex32()  # varchar(32)
        sb.add(
            "insert into formularios_pagina_version (id_pagina_version, fecha_creacion, id_pagina)\n"
            f"values ({q(pver)}, to_timestamp(extract(epoch from now())), {q(pagina_id)});"
        )
        sb.add(
            "insert into formularios_pagina_index_version (id_pagina, id_index_version)\n"
            f"values ({q(pagina_id)}, {q(idx_id)});"
        )
        pagina_versions.append(pver)
        sb.nl()

    fid = seed_fuente_datos(sb, f"Dataset {rand_word(5).capitalize()}", creado_por_id)

    def add_campo(tipo, clase, nombre_interno, etiqueta, ayuda=None, config=None, requerido=False):
        cid = gen_id32()
        cfg = config if config is not None else CLASES.get(clase, {})
        sb.add("-- Campo")
        sb.add(
            "insert into formularios_campo (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)\n"
            f"values ({q(cid)}, {q(tipo)}, {q(clase)}, {q(nombre_interno)}, {q(etiqueta)},\n"
            f"        {q(ayuda) if ayuda else 'NULL'}, {qjson(cfg)}, {str(bool(requerido)).lower()});"
        )
        sb.nl()
        return cid

    pver1 = pagina_versions[0]
    c_text = add_campo("texto", "texto", "nombre", "Nombre", "Tu nombre completo", {"placeholder":"Nombre y apellido"}, True)
    c_num  = add_campo("numero", "numero", "cantidad", "Cantidad", "Cantidad producida", {"min":0,"max":10000,"decimales":0}, True)
    c_sel  = add_campo("select", "select", "trabajador_sel", "Trabajador", "Seleccione trabajador", {"fuente_id": fid, "columna": "label", "modo":"pair"}, True)
    seed_fuente_valores(sb, fid, c_sel, n=8)

    c_gps = None
    if permitir_gps:
        c_gps = add_campo("gps", "gps", "ubicacion", "Ubicación GPS", "Coordenadas", {"precision_m": 10}, False)

    pver2 = pagina_versions[1]
    c_bool  = add_campo("boolean", "boolean", "aprobado", "¿Aprobado?", None, {"labels": ["No","Sí"]}, False)
    c_fecha = add_campo("fecha", "fecha", "fecha_visita", "Fecha de visita", None, {"formato":"yyyy-MM-dd"}, True)

    formula_ts = """
// Campos disponibles en 'ctx.values': nombre, cantidad
const nombre = String(ctx.values.nombre ?? '');
const cantidad = Number(ctx.values.cantidad ?? 0);
if (!nombre) return '';
return `${nombre} - Lote: ${cantidad}`;
""".strip()
    c_calc = add_campo("calc", "calc", "resumen", "Resumen auto", "Campo de solo lectura", {"lang":"ts","formula":formula_ts,"readOnly":True}, False)

    c_group = add_campo("group", "group", "grupo_detalle", "Detalle de Insumos", "Sección agrupada", {"repetible": False}, False)
    c_insumo = add_campo("texto", "texto", "insumo", "Insumo", None, {"placeholder":"Nombre insumo"}, True)
    c_costo  = add_campo("numero", "numero", "costo", "Costo (Q)", None, {"min":0, "max":100000, "decimales":2}, True)

    def attach(cid, pver, seq):
        sb.add("-- Página-Campo")
        sb.add(
            "insert into formularios_pagina_campo (id_campo, sequence, id_pagina_version)\n"
            f"values ({q(cid)}, {seq}, {q(pver)});"
        )
        sb.nl()

    attach(c_text, pver1, 0)
    attach(c_num,  pver1, 1)
    attach(c_sel,  pver1, 2)
    if c_gps:
        attach(c_gps, pver1, 3)
    attach(c_bool,  pver2, 0)
    attach(c_fecha, pver2, 1)
    attach(c_calc,  pver2, 2)

    pver_group = pagina_versions[2] if len(pagina_versions) > 2 else pver2
    attach(c_group,  pver_group, 0)
    attach(c_insumo, pver_group, 1)
    attach(c_costo,  pver_group, 2)

    grupo_id = gen_id32()
    sb.add("-- Grupo estructural y asociación de campos al grupo")
    sb.add(
        "insert into formularios_grupo (id_grupo, nombre, id_campo_group)\n"
        f"values ({q(grupo_id)}, {q('Grupo de Insumos')}, {q(c_group)});"
    )
    sb.add(
        "with next_id as (select coalesce(max(id),0)+1 as nid from formularios_campo_grupo)\n"
        "insert into formularios_campo_grupo (id, id_campo, id_grupo)\n"
        f"select nid, {q(c_insumo)}, {q(grupo_id)} from next_id\n"
        f"where not exists (select 1 from formularios_campo_grupo where id_grupo={q(grupo_id)} and id_campo={q(c_insumo)});"
    )
    sb.add(
        "with next_id as (select coalesce(max(id),0)+1 as nid from formularios_campo_grupo)\n"
        "insert into formularios_campo_grupo (id, id_campo, id_grupo)\n"
        f"select nid, {q(c_costo)}, {q(grupo_id)} from next_id\n"
        f"where not exists (select 1 from formularios_campo_grupo where id_grupo={q(grupo_id)} and id_campo={q(c_costo)});"
    )
    sb.nl()

    return {"form_id": form_id, "nombre": nombre, "idx_id": idx_id}

def seed_usuarios_y_asignaciones(sb: SQLBuilder, forms_ids, usuario_existente: str | None):
    if usuario_existente:
        u = usuario_existente
        sb.add(f"-- Asignación a usuario existente (no se crea): {u}")
        for fid in forms_ids:
            sb.add(
                "with next_id as (select coalesce(max(id),0)+1 as nid from formularios_user_formulario)\n"
                "insert into formularios_user_formulario (id, id_formulario_id, id_usuario_id)\n"
                f"select nid, {q(fid)}, {q(u)} from next_id\n"
                f"where exists (select 1 from formularios_usuario where nombre_usuario = {q(u)})\n"
                f"and not exists (select 1 from formularios_user_formulario where id_formulario_id={q(fid)} and id_usuario_id={q(u)});"
            )
        sb.nl()
        return

    n_users = random.randint(3, 6)
    users = []
    sb.add("-- Usuarios aleatorios")
    for i in range(n_users):
        username = f"{rand_word(5)}.{rand_word(6)}"
        nombre = f"{rand_word(6).capitalize()} {rand_word(8).capitalize()}"
        correo = f"{username}@example.com"
        password = "pbkdf2_sha256$demo"
        activo = True
        acceso_web = rand_bool(0.7)
        is_staff = rand_bool(0.2)
        is_superuser = False
        sb.add(
            "insert into formularios_usuario (last_login, nombre_usuario, nombre, correo, password, activo, acceso_web, is_staff, is_superuser)\n"
            f"values (NULL, {q(username)}, {q(nombre)}, {q(correo)}, {q(password)}, {str(activo).lower()}, {str(acceso_web).lower()}, {str(is_staff).lower()}, {str(is_superuser).lower()});"
        )
        users.append(username)

    sb.nl()
    sb.add("-- Asignaciones usuario-formulario")
    for fid in forms_ids:
        for u in random.sample(users, k=random.randint(1, min(2, len(users)))):
            sb.add(
                "insert into formularios_user_formulario (id_formulario_id, id_usuario_id)\n"
                f"values ({q(fid)}, {q(u)})\n"
                "on conflict do nothing;"
            )
    sb.nl()

def main():
    parser = argparse.ArgumentParser(description="Genera SQL de seed para formularios.")
    parser.add_argument("--categorias", type=int, default=2, help="Cantidad de categorías a generar.")
    parser.add_argument("--forms-por-categoria", type=int, default=2, help="Cantidad de formularios por categoría.")
    parser.add_argument("--usuario", type=str, default=None, help="Nombre de usuario para asignar los formularios (no se creará el usuario).")
    parser.add_argument("--id-prefix", type=str, default="1", help="Prefijo numérico con el que empiezan los IDs (solo dígitos).")
    parser.add_argument("--id-start", type=int, default=1, help="Valor inicial del contador de IDs (≥1).")
    parser.add_argument("--output", type=str, required=True, help="Ruta de salida del archivo .sql")
    args = parser.parse_args()

    # Inicializar generador de IDs
    init_id_generator(args.id_prefix, args.id_start)

    sb = SQLBuilder()
    sb.add("-- =====================================================")
    sb.add("-- SEED DE FORMULARIOS (generado por script)")
    sb.add(f"-- Fecha: {now_tz()}")
    sb.add("-- NOTA: Este script SOLO inserta datos, no crea tablas.")
    sb.add(f"-- ID prefix: {args.id_prefix} | start: {args.id_start}")
    sb.add("-- =====================================================")
    sb.nl()

    seed_clase_campo(sb)

    categorias = seed_categorias(sb, args.categorias)
    all_forms = []
    creado_por_id = "seed-script"

    for cat in categorias:
        sb.add(f"-- Formularios para {cat['nombre']}")
        for _ in range(args.forms_por_categoria):
            info = seed_formulario_completo(sb, cat["id"], creado_por_id)
            all_forms.append(info["form_id"])
        sb.nl()

    seed_usuarios_y_asignaciones(sb, all_forms, args.usuario)

    with open(args.output, "w", encoding="utf-8") as f:
        f.write(sb.render())

    print(f"[ok] SQL generado en: {args.output}")
    print(f"[info] Formularios generados: {len(all_forms)} en {len(categorias)} categorías.")
    print(f"[info] ID prefix={args.id_prefix} start={args.id_start}")

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"[error] {e}", file=sys.stderr)
        sys.exit(1)

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Generador de formularios (categorÃ­as, versiones, pÃ¡ginas, campos y grupos) + usuario/rol dedicado.

Novedades:
- --create-user crea:
    1) Rol exclusivo en dbo.formularios_rol (sin ledger_*).
    2) Usuario en dbo.formularios_usuarios con contraseÃ±a Argon2 (sin ledger_*).
    3) RelaciÃ³n en dbo.formularios_rol_user (sin ledger_*).
    4) Asigna TODOS los formularios generados a ese rol en dbo.formularios_rol_formulario (sin ledger_*).
- --export-credentials escribe TXT con usuario + contraseÃ±a en claro (DB guarda solo hash).
- CategorÃ­as aleatorias y distribuciÃ³n de formularios por categorÃ­a (igual que versiÃ³n previa).
- Grupos como campos (clase 'group'), tabla formularios_grupo y relaciÃ³n formularios_campo_grupo (sin ledger_*).

Uso tÃ­pico:
  python generador_formularios_sqlserver.py \
    --emit-sql ./carga_formularios.sql \
    --categories-count 4 --forms-per-category 3 \
    --seed 42 --create-user --user-username "danvalA" \
    --user-name "Daniel Valdez" --user-phone "502-5555-5555" \
    --user-email "danval@example.com" --export-credentials ./credenciales.txt
"""
import argparse
import datetime as dt
import json
import os
import random
import string
import sys
import uuid
from typing import Any, Dict, List, Optional, Tuple

try:
    import pyodbc  # type: ignore
except Exception:
    pyodbc = None  # permite --emit-sql sin pyodbc

# Argon2 para hashear contraseÃ±as
_HAS_ARGON2 = True
try:
    from argon2.low_level import hash_secret, Type  # type: ignore
    from os import urandom
except Exception:
    _HAS_ARGON2 = False


# ========= Utilidades =========

def hex32() -> str:
    return uuid.uuid4().hex  # 32 chars minÃºsculas sin guiones

def pick(seq):
    return random.choice(seq)

def slugify_name(n: str) -> str:
    keep = string.ascii_lowercase + string.digits + "_"
    s = n.lower().replace(" ", "_")
    return "".join(ch for ch in s if ch in keep)[:64] or "campo_" + hex32()[:6]

def rand_bool() -> bool:
    return bool(random.getrandbits(1))

def rand_text(min_len=10, max_len=40) -> str:
    L = random.randint(min_len, max_len)
    letters = string.ascii_letters + "     "
    return "".join(random.choice(letters) for _ in range(L)).strip().capitalize()

def rand_label() -> str:
    prefixes = ["Peso", "Altura", "Humedad", "Temperatura", "Operario", "Finca", "Lote",
                "CÃ³digo", "DescripciÃ³n", "Comentario", "Variedad", "Rendimiento"]
    return f"{pick(prefixes)} {random.randint(1, 999)}"

def rand_unit() -> Optional[str]:
    return pick(["$", "â‚¬", "Â£", "Q", None])

def now_dt() -> str:
    import datetime as _dt
    return _dt.datetime.utcnow().isoformat(timespec="seconds") + "Z"

def random_password(min_len: int = 12, max_len: int = 16) -> str:
    L = random.randint(min_len, max_len)
    chars = string.ascii_letters + string.digits + "!@#$%^&*()-_=+[]{}"
    return "".join(random.choice(chars) for _ in range(L))

def hash_password_argon2(plain: str) -> str:
    if not _HAS_ARGON2:
        raise RuntimeError("Falta argon2-cffi. Instale con: pip install argon2-cffi")
    salt = urandom(16)  # 16 bytes
    phc = hash_secret(
        secret=plain.encode("utf-8"),
        salt=salt,
        time_cost=3,
        memory_cost=65536,  # KiB = 64MiB
        parallelism=1,
        hash_len=32,
        type=Type.ID,
        version=19,
    )
    return phc.decode("utf-8")


# ========= Clases de campo y configs =========

CLASES_Y_ESTRUCTURA: Dict[str, Dict[str, Any]] = {
    "boolean": {},
    "calc": {"vars": ["string[]"], "operation": ["string"]},
    "dataset": {"file": ["string"], "column": ["string"]},
    "date": {},
    "firm": {},
    "group": {
        "id_group": ["string"],
        "name": ["string"],
        "fieldCondition": ["string"],
    },
    "hour": {},
    "list": {"id_list": ["string"], "items": ["string", "number", "boolean"]},
    "number": {"min": [None, "number"], "max": [None, "number"], "step": [None, "number"], "unit": [None, "$", "â‚¬", "Â£", "Q"]},
    "string": {},
    "text": {},
}

MAP_TIPO_POR_CLASE: Dict[str, str] = {
    "boolean": "booleano",
    "number": "numerico",
    "calc": "numerico",
    "dataset": "texto",
    "date": "texto",
    "firm": "imagen",
    "group": "texto",
    "hour": "texto",
    "list": "texto",
    "string": "texto",
    "text": "texto",
}

CLASE_WEIGHTS = {
    "boolean": 1.0,
    "calc": 1.0,
    "dataset": 0.8,
    "date": 0.9,
    "firm": 0.6,
    "group": 0.20,
    "hour": 0.9,
    "list": 1.1,
    "number": 1.4,
    "string": 1.2,
    "text": 1.0,
}

def pick_clase(group_allowed: bool = True) -> str:
    items = [(k, w) for k, w in CLASE_WEIGHTS.items() if (group_allowed or k != "group")]
    total = sum(w for _, w in items)
    r = random.random() * total
    acc = 0.0
    for k, w in items:
        acc += w
        if r <= acc:
            return k
    return items[-1][0]


# ========= Evitar duplicados de nombre_campo =========

RUN_PREFIX = uuid.uuid4().hex[:6]
GENERATED_NOMBRES = set()

def unique_nombre_campo(base: str, max_len: int = 64) -> str:
    def clamp(s: str) -> str:
        return s[:max_len] if len(s) > max_len else s
    candidate = clamp(f"{base}_{RUN_PREFIX}")
    if candidate not in GENERATED_NOMBRES:
        GENERATED_NOMBRES.add(candidate)
        return candidate
    for i in range(1, 1000):
        cand = clamp(f"{base}_{RUN_PREFIX}_{i}")
        if cand not in GENERATED_NOMBRES:
            GENERATED_NOMBRES.add(cand)
            return cand
    cand = clamp(f"{base}_{uuid.uuid4().hex[:6]}")
    GENERATED_NOMBRES.add(cand)
    return cand


# ========= Emisor SQL =========

class SqlEmitter:
    def __init__(self, cnxn=None, emit_sql_path: Optional[str] = None):
        self.cnxn = cnxn
        self.cursor = cnxn.cursor() if cnxn else None
        self.emit_sql_path = emit_sql_path
        self._lines: List[str] = []
        if self.emit_sql_path:
            self._lines.append("-- Archivo generado automÃ¡ticamente")
            self._lines.append("SET NOCOUNT ON;")
            self._lines.append("")

    def comment(self, text: str):
        if self.emit_sql_path:
            self._lines.append("-- " + text)

    def _format_param(self, p: Any) -> str:
        if isinstance(p, str):
            return "'" + p.replace("'", "''") + "'"
        if isinstance(p, (int, float)):
            return str(p)
        if isinstance(p, bool):
            return "1" if p else "0"
        if isinstance(p, (bytes, bytearray)):
            return "0x" + p.hex()
        if p is None:
            return "NULL"
        return "'" + str(p).replace("'", "''") + "'"

    def exec(self, sql: str, params: Optional[Tuple[Any, ...]] = None):
        if self.emit_sql_path:
            line = sql
            if params:
                for p in params:
                    line = line.replace("?", self._format_param(p), 1)
            self._lines.append(line.rstrip() + ";\n")
        else:
            assert self.cursor is not None
            self.cursor.execute(sql, params or ())

    def commit(self):
        if self.emit_sql_path:
            with open(self.emit_sql_path, "w", encoding="utf-8") as f:
                f.write("\n".join(self._lines))
        else:
            assert self.cnxn is not None
            self.cnxn.commit()


# ========= Insert helpers (tablas base) =========

def ensure_clases_campo(em: SqlEmitter):
    for clase, estructura in CLASES_Y_ESTRUCTURA.items():
        sql = """
        IF NOT EXISTS (SELECT 1 FROM dbo.formularios_clase_campo WHERE clase = ?)
        BEGIN
          INSERT INTO dbo.formularios_clase_campo (clase, estructura)
          VALUES (?, ?)
        END
        """
        em.exec(sql, (clase, clase, json.dumps(estructura, ensure_ascii=False)))

def ensure_categoria(em: SqlEmitter, nombre_base: str) -> str:
    cat_id = hex32()
    unique_name = f"{nombre_base.strip()} {random.randint(1, 9999)}"
    desc = f"CategorÃ­a auto {unique_name}"
    sql = "INSERT INTO dbo.formularios_categoria (id, nombre, descripcion) VALUES (?, ?, ?)"
    em.exec(sql, (cat_id, unique_name, desc))
    return cat_id

def insert_formulario(em: SqlEmitter, categoria_id: Optional[str] = None) -> str:
    fid = hex32()
    nombre = f"Formulario {rand_label()}"
    descripcion = rand_text(40, 120)
    permitir_fotos = rand_bool()
    permitir_gps = rand_bool()
    disponible_desde = dt.date.today()
    disponible_hasta = disponible_desde + dt.timedelta(days=random.randint(30, 365))
    estado = pick(["borrador", "activo", "inactivo"])
    forma_envio = pick(["online", "offline", "mixto"])
    es_publico = rand_bool()
    auto_envio = rand_bool()
    if not categoria_id:
        categoria_id = hex32()

    sql = """
    INSERT INTO dbo.formularios_formulario
        (id, nombre, descripcion, permitir_fotos, permitir_gps,
         disponible_desde_fecha, disponible_hasta_fecha, estado, forma_envio,
         es_publico, auto_envio, categoria_id)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """
    em.exec(sql, (
        fid, nombre, descripcion, 1 if permitir_fotos else 0, 1 if permitir_gps else 0,
        disponible_desde.isoformat(), disponible_hasta.isoformat(), estado, forma_envio,
        1 if es_publico else 0, 1 if auto_envio else 0, categoria_id
    ))
    return fid

def insert_index_version(em: SqlEmitter, formulario_id: str) -> str:
    ivid = hex32()
    fecha_creacion = now_dt()
    sql1 = """
    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES (?, ?, ?)
    """
    em.exec(sql1, (ivid, formulario_id, fecha_creacion))
    sql2 = """
    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES (?, ?)
    """
    em.exec(sql2, (formulario_id, ivid))
    return ivid

def insert_pagina(em: SqlEmitter, formulario_id: str, index_version_id: str, secuencia: int) -> str:
    pid = hex32()
    nombre = f"PÃ¡gina {secuencia}"
    descripcion = rand_text(30, 90)
    sql = """
    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES (?, ?, ?, ?, ?, ?)
    """
    em.exec(sql, (pid, secuencia, nombre, descripcion, formulario_id, index_version_id))
    sql2 = "INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES (?, ?)"
    em.exec(sql2, (pid, index_version_id))
    sql3 = """
    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES (?, ?, ?, ?)
    """
    em.exec(sql3, (formulario_id, index_version_id, pid, now_dt()))
    return pid

def insert_pagina_version(em: SqlEmitter, id_pagina: str) -> str:
    pvid = hex32()
    sql = "INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES (?, ?, ?)"
    em.exec(sql, (pvid, id_pagina, now_dt()))
    return pvid

def insert_campo(em: SqlEmitter, clase: str, *, config: Optional[Dict[str, Any]] = None) -> str:
    cid = hex32()
    tipo = MAP_TIPO_POR_CLASE.get(clase, "texto")
    base_name = slugify_name(f"{clase}_{rand_label()}")
    nombre_campo = unique_nombre_campo(base_name)
    etiqueta = rand_label()
    ayuda = "Ayuda: " + rand_text(20, 50)
    if config is None:
        config = gen_config_para_clase(clase)
    config_json = json.dumps(config, ensure_ascii=False)
    requerido = 1 if rand_bool() else 0  # BIT
    sql = """
    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """
    em.exec(sql, (cid, tipo, clase, nombre_campo, etiqueta, ayuda, config_json, requerido))
    return cid

def insert_pagina_campo(em: SqlEmitter, id_pagina_version: str, id_campo: str, sequence: int):
    sql = "INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES (?, ?, ?)"
    em.exec(sql, (id_pagina_version, id_campo, sequence))


# ========= Grupos =========

def insert_grupo(em: SqlEmitter, nombre: str) -> Tuple[str, str]:
    """ En ledger REAL no se insertan columnas ledger_* (GENERATED ALWAYS). """
    gid = hex32()
    unique_name = f"{nombre} {RUN_PREFIX}-{random.randint(100,999)}"
    sql = "INSERT INTO dbo.formularios_grupo (id_grupo, nombre) VALUES (?, ?)"
    em.exec(sql, (gid, unique_name))
    return gid, unique_name

def link_campo_a_grupo(em: SqlEmitter, id_grupo: str, id_campo: str):
    """ En ledger REAL no se insertan columnas ledger_* (GENERATED ALWAYS). """
    sql = "INSERT INTO dbo.formularios_campo_grupo (id_grupo, id_campo) VALUES (?, ?)"
    em.exec(sql, (id_grupo, id_campo))


# ========= Usuario / Rol exclusivo =========

def create_role_exclusive(em: SqlEmitter, username: str, role_name: Optional[str] = None) -> str:
    role_id = hex32()
    rname = role_name or f"Rol-{username}-{RUN_PREFIX}"
    desc = f"Rol exclusivo para {username} (corrida {RUN_PREFIX})"
    sql = "INSERT INTO dbo.formularios_rol (id, nombre, descripcion) VALUES (?, ?, ?)"
    em.exec(sql, (role_id, rname, desc))
    return role_id

def create_user_with_role(
    em: SqlEmitter,
    username: str,
    name: str,
    phone: str,
    email: Optional[str],
    role_id: str,
    plain_password: Optional[str] = None,
) -> Tuple[str, str]:
    """Crea usuario con hash Argon2 y lo asocia a su rol.
    Devuelve (username, plain_password) para exportar credenciales."""
    pwd = plain_password or random_password()
    pwd_hash = hash_password_argon2(pwd)

    # dbo.formularios_usuarios (ledger: NO insertar ledger_*)
    sql = """
    INSERT INTO dbo.formularios_usuarios
        (nombre, telefono, correo, contrasena, rol_id, nombre_de_usuario)
    VALUES (?, ?, ?, ?, ?, ?)
    """
    em.exec(sql, (name, phone, email, pwd_hash, role_id, username))

    # dbo.formularios_rol_user (ledger: NO insertar ledger_*)
    sql2 = "INSERT INTO dbo.formularios_rol_user (id_rol, nombre_de_usuario) VALUES (?, ?)"
    em.exec(sql2, (role_id, username))

    return username, pwd

def link_form_to_role(em: SqlEmitter, form_id: str, role_id: str):
    """ dbo.formularios_rol_formulario (ledger: NO insertar ledger_*) """
    sql = """
    IF NOT EXISTS (
        SELECT 1 FROM dbo.formularios_rol_formulario
        WHERE id_formulario = ? AND rol_id = ? AND ledger_end_transaction_id IS NULL
    )
    BEGIN
        INSERT INTO dbo.formularios_rol_formulario (id_formulario, rol_id) VALUES (?, ?)
    END
    """
    em.exec(sql, (form_id, role_id, form_id, role_id))


# ========= Config generador por clase =========

def gen_config_para_clase(clase: str) -> Dict[str, Any]:
    if clase == "boolean":
        return {}
    if clase == "calc":
        n = random.randint(1, 3)
        vars_ = [f"var_{i}" for i in range(n)]
        op = pick(["SUM(vars)", "AVG(vars)", "vars[0]*2", "vars[0]+vars[1]" if n > 1 else "vars[0]"])
        return {"vars": vars_, "operation": op}
    if clase == "dataset":
        return {"file": f"/datasets/ds_{random.randint(1,9)}.csv", "column": f"col_{random.randint(1,5)}"}
    if clase == "date":
        return {}
    if clase == "firm":
        return {}
    if clase == "group":
        # Se define al crear el grupo (id/nombre). AquÃ­ placeholder por si acaso.
        return {"id_group": "", "name": "", "fieldCondition": "always"}
    if clase == "hour":
        return {}
    if clase == "list":
        items = []
        for _ in range(random.randint(2, 5)):
            kind = pick(["string", "number", "boolean"])
            if kind == "string":
                items.append(rand_label())
            elif kind == "number":
                items.append(random.randint(1, 100))
            else:
                items.append(rand_bool())
        return {"id_list": hex32(), "items": items}
    if clase == "number":
        minimo = random.choice([None, random.randint(0, 50)])
        maximo = random.choice([None, random.randint(51, 200)])
        step = random.choice([None, round(random.uniform(0.1, 5.0), 2)])
        unit = rand_unit()
        return {"min": minimo, "max": maximo, "step": step, "unit": unit}
    if clase == "string":
        return {}
    if clase == "text":
        return {}
    return {}


# ========= CategorÃ­as aleatorias =========

CATEGORY_NAME_POOL = [
    "Cosecha", "Corte", "Transporte", "Mantenimiento", "Fertirriego",
    "Riego", "Aplicaciones", "Calidad", "Bodega", "Seguridad",
    "MecÃ¡nica", "ElÃ©ctrico", "TopografÃ­a", "Laboratorio", "Empaque",
    "Siembra", "Siembra Mecanizada", "Cosecha Manual", "Vivero", "Sanidad",
    "Rutas", "LogÃ­stica", "ProducciÃ³n", "RRHH Campo", "CapacitaciÃ³n"
]

def build_random_category_names(n: int) -> List[str]:
    names: List[str] = []
    base = CATEGORY_NAME_POOL.copy()
    random.shuffle(base)
    names.extend(base[:min(n, len(base))])
    i = 1
    while len(names) < n:
        names.append(f"Categoria Auto {i}")
        i += 1
    return names[:n]


# ========= GeneraciÃ³n principal =========

def _parse_forms_by_category_map(spec: str) -> Dict[str, int]:
    result: Dict[str, int] = {}
    for part in spec.split(","):
        part = part.strip()
        if not part:
            continue
        if ":" not in part:
            raise ValueError(f"Entrada invÃ¡lida '{part}'. Formato esperado: Nombre:Cantidad")
        name, cnt = part.split(":", 1)
        name = name.strip()
        cnt = cnt.strip()
        if not name or not cnt.isdigit():
            raise ValueError(f"Par invÃ¡lido '{part}'. Ejemplo: Corte:2")
        result[name] = int(cnt)
    if not result:
        raise ValueError("Mapa vacÃ­o en --forms-by-category.")
    return result

def generate(
    em: SqlEmitter,
    n_forms: int,
    min_versions: int,
    max_versions: int,
    min_pages: int,
    max_pages: int,
    min_fields: int,
    max_fields: int,
    categories: Optional[List[str]] = None,
    forms_by_category: Optional[Dict[str, int]] = None,
    categories_count: Optional[int] = None,
    forms_per_category: Optional[int] = None,
    min_forms_per_category: Optional[int] = None,
    max_forms_per_category: Optional[int] = None,
    # Para usuario/rol
    role_for_run: Optional[str] = None,  # si viene, se usa para vincular formularios
) -> Tuple[List[str], Dict[str, str]]:
    """Genera formularios y retorna:
       - forms_created: lista de IDs de formularios creados
       - cat_ids_by_name: mapa nombre->id de categorÃ­as creadas
    """
    ensure_clases_campo(em)

    # Resolver categorÃ­as
    default_cats = ["Corte", "Transporte", "Mantenimiento", "Fertirriego", "Cosecha"]
    if categories and len(categories) > 0:
        cat_names = categories
        origin = "explÃ­citas (--categories)"
    elif categories_count and categories_count > 0:
        cat_names = build_random_category_names(categories_count)
        origin = f"aleatorias (--categories-count={categories_count})"
    else:
        cat_names = default_cats
        origin = "por defecto"

    cat_ids_by_name: Dict[str, str] = {n: ensure_categoria(em, n) for n in cat_names}
    cat_id_list = list(cat_ids_by_name.values())

    em.comment(f"Origen de categorÃ­as: {origin}")
    em.comment("Resumen de categorÃ­as (nombre -> id) para esta corrida:")
    for n, cid in cat_ids_by_name.items():
        em.comment(f"  - {n} -> {cid}")
    em.comment("")

    forms_created: List[str] = []

    def _gen_form_for_category(cid: str):
        fid = insert_formulario(em, cid)
        forms_created.append(fid)
        # Vincular a rol (si aplica)
        if role_for_run:
            link_form_to_role(em, fid, role_for_run)

        n_versions = random.randint(min_versions, max_versions)
        for _ in range(n_versions):
            ivid = insert_index_version(em, fid)
            n_pages = random.randint(min_pages, max_pages)
            for pseq in range(1, n_pages + 1):
                pid = insert_pagina(em, fid, ivid, pseq)
                pvid = insert_pagina_version(em, pid)

                non_group_campos: List[str] = []
                grupo_info: Optional[Dict[str, Any]] = None

                n_fields = random.randint(min_fields, max_fields)
                group_used = False

                for s in range(1, n_fields + 1):
                    clase = pick_clase(group_allowed=(not group_used))
                    if clase == "group" and not group_used:
                        group_used = True
                        base_name = f"Grupo {rand_label()}"
                        gid, gname = insert_grupo(em, base_name)
                        cfg = {"id_group": gid, "name": gname, "fieldCondition": "always"}
                        campo_group_id = insert_campo(em, "group", config=cfg)
                        insert_pagina_campo(em, pvid, campo_group_id, s)
                        grupo_info = {"group_id": gid, "campo_group_id": campo_group_id, "name": gname}
                    else:
                        cid_ = insert_campo(em, clase)
                        insert_pagina_campo(em, pvid, cid_, s)
                        non_group_campos.append(cid_)

                if grupo_info and non_group_campos:
                    k = random.randint(1, min(5, len(non_group_campos)))
                    miembros = random.sample(non_group_campos, k=k)
                    for cid_ in miembros:
                        link_campo_a_grupo(em, grupo_info["group_id"], cid_)
                    em.comment(f"PÃ¡gina {pseq}: grupo '{grupo_info['name']}' ({grupo_info['group_id']}) con {k} campo(s) asociado(s).")

    # DistribuciÃ³n por categorÃ­a
    if forms_by_category:
        total = sum(forms_by_category.values())
        em.comment(f"DistribuciÃ³n exacta por categorÃ­a (total formularios = {total}):")
        for n, c in forms_by_category.items():
            em.comment(f"  - {n}: {c}")
            if n not in cat_ids_by_name:
                raise ValueError(f"La categorÃ­a '{n}' indicada en --forms-by-category no estÃ¡ en --categories.")
        for n, count in forms_by_category.items():
            for _ in range(count):
                _gen_form_for_category(cat_ids_by_name[n])
        return forms_created, cat_ids_by_name

    if forms_per_category is not None:
        em.comment(f"DistribuciÃ³n fija: {forms_per_category} formulario(s) por categorÃ­a.")
        for cid in cat_id_list:
            for _ in range(forms_per_category):
                _gen_form_for_category(cid)
        return forms_created, cat_ids_by_name

    if (min_forms_per_category is not None) and (max_forms_per_category is not None):
        if min_forms_per_category > max_forms_per_category:
            raise ValueError("--min-forms-per-category no puede ser mayor que --max-forms-per-category.")
        em.comment(f"DistribuciÃ³n aleatoria por categorÃ­a en rango [{min_forms_per_category}, {max_forms_per_category}].")
        total = 0
        for cid in cat_id_list:
            k = random.randint(min_forms_per_category, max_forms_per_category)
            total += k
            for _ in range(k):
                _gen_form_for_category(cid)
        em.comment(f"Total de formularios generados (suma por categorÃ­a): {total}")
        return forms_created, cat_ids_by_name

    em.comment(f"DistribuciÃ³n aleatoria global entre {len(cat_ids_by_name)} categorÃ­a(s).")
    for _ in range(n_forms):
        _gen_form_for_category(pick(cat_id_list))
    return forms_created, cat_ids_by_name


# ========= CLI =========

def main():
    parser = argparse.ArgumentParser(description="Generador aleatorio de formularios con pÃ¡ginas/campos/grupos + usuario/rol.")
    # ConexiÃ³n
    parser.add_argument("--server", type=str)
    parser.add_argument("--database", type=str)
    parser.add_argument("--user", type=str)
    parser.add_argument("--password", type=str)
    parser.add_argument("--driver", type=str, default="{ODBC Driver 17 for SQL Server}")

    # ParÃ¡metros del generador
    parser.add_argument("--forms", type=int, default=2)
    parser.add_argument("--min-versions", type=int, default=1)
    parser.add_argument("--max-versions", type=int, default=2)
    parser.add_argument("--min-pages", type=int, default=2)
    parser.add_argument("--max-pages", type=int, default=4)
    parser.add_argument("--min-fields", type=int, default=3)
    parser.add_argument("--max-fields", type=int, default=6)

    # CategorÃ­as
    parser.add_argument("--categories", type=str, help='CSV: "Corte,Transporte,..."')
    parser.add_argument("--categories-count", type=int, default=None)
    parser.add_argument("--forms-by-category", dest="forms_by_category", type=str)
    parser.add_argument("--forms-per-category", type=int, default=None)
    parser.add_argument("--min-forms-per-category", type=int, default=None)
    parser.add_argument("--max-forms-per-category", type=int, default=None)
    parser.add_argument("--list-categories", action="store_true")

    # Reproducibilidad y emisiÃ³n
    parser.add_argument("--seed", type=int, default=None)
    parser.add_argument("--emit-sql", type=str, default=None)

    # Usuario/rol exclusivo
    parser.add_argument("--create-user", action="store_true", help="Crea rol exclusivo y usuario, y asigna formularios a ese rol.")
    parser.add_argument("--user-username", type=str, default=None)
    parser.add_argument("--user-password", type=str, default=None, help="Si no se pasa, se genera una fuerte.")
    parser.add_argument("--user-name", type=str, default="Usuario Generado")
    parser.add_argument("--user-phone", type=str, default="502-0000-0000")
    parser.add_argument("--user-email", type=str, default=None)
    parser.add_argument("--user-role-name", type=str, default=None, help="Nombre opcional del rol exclusivo.")
    parser.add_argument("--export-credentials", type=str, default=None, help="Ruta TXT para guardar usuario y contraseÃ±a en claro.")

    args = parser.parse_args()
    if args.seed is not None:
        random.seed(args.seed)

    # Parse categorÃ­as explÃ­citas
    categories: Optional[List[str]] = None
    if args.categories:
        categories = [c.strip() for c in args.categories.split(",") if c.strip()]

    forms_by_category: Optional[Dict[str, int]] = None
    if args.forms_by_category:
        forms_by_category = _parse_forms_by_category_map(args.forms_by_category)

    # Solo listar
    if args.list_categories:
        if categories and len(categories) > 0:
            cat_names = categories
            origin = "explÃ­citas (--categories)"
        elif args.categories_count and args.categories_count > 0:
            cat_names = build_random_category_names(args.categories_count)
            origin = f"aleatorias (--categories-count={args.categories_count})"
        else:
            cat_names = ["Corte", "Transporte", "Mantenimiento", "Fertirriego", "Cosecha"]
            origin = "por defecto"
        print(f"[INFO] CategorÃ­as previstas ({origin}): {', '.join(cat_names)}")
        if forms_by_category:
            total = sum(forms_by_category.values())
            print(f"[INFO] DistribuciÃ³n exacta (total {total}):")
            for n, c in forms_by_category.items():
                print(f"  - {n}: {c}")
        elif args.forms_per_category is not None:
            total = len(cat_names) * args.forms_per_category
            print(f"[INFO] {args.forms_per_category} formulario(s) por categorÃ­a. Total = {total}.")
        elif args.min_forms_per_category is not None and args.max_forms_per_category is not None:
            print(f"[INFO] Rango por categorÃ­a: [{args.min_forms_per_category}, {args.max_forms_per_category}].")
        else:
            print(f"[INFO] Reparto aleatorio global. Total formularios: {args.forms}")
        return

    # Prepara emisor
    if args.emit_sql:
        em = SqlEmitter(cnxn=None, emit_sql_path=args.emit_sql)
    else:
        if not all([args.server, args.database, args.user, args.password]):
            print("Faltan parÃ¡metros de conexiÃ³n. Use --emit-sql o provea --server/--database/--user/--password.")
            sys.exit(1)
        if pyodbc is None:
            print("pyodbc no estÃ¡ instalado. Use --emit-sql o instale pyodbc.")
            sys.exit(1)
        conn_str = (
            f"DRIVER={args.driver};"
            f"SERVER={args.server};"
            f"DATABASE={args.database};"
            f"UID={args.user};"
            f"PWD={args.password};"
            "TrustServerCertificate=yes;"
        )
        cnxn = pyodbc.connect(conn_str, autocommit=False)
        em = SqlEmitter(cnxn=cnxn)

    # --- Crear rol/usuario si se solicitÃ³ (antes de generar formularios para poder ligar) ---
    role_id_for_run: Optional[str] = None
    new_username: Optional[str] = None
    new_plain_password: Optional[str] = None

    try:
        if args.create_user:
            if not _HAS_ARGON2:
                raise RuntimeError("Para --create-user se requiere argon2-cffi. Instale: pip install argon2-cffi")
            username = args.user_username if args.user_username else None
            # Acepta --user-username o genera uno
            if args.user_username:
                username = args.user_username
            else:
                username = f"user_{RUN_PREFIX}"

            # 1) rol exclusivo
            role_id_for_run = create_role_exclusive(em, username, role_name=args.user_role_name)

            # 2) usuario + relaciÃ³n
            new_plain_password = args.user_password or random_password()
            new_username, _pwd = create_user_with_role(
                em,
                username=username,
                name=args.user_name,
                phone=args.user_phone,
                email=args.user_email,
                role_id=role_id_for_run,
                plain_password=new_plain_password,
            )

        # --- Generar formularios (y ligarlos al rol exclusivo si existe) ---
        forms_created, cat_ids_by_name = generate(
            em,
            n_forms=args.forms,
            min_versions=args.min_versions,
            max_versions=args.max_versions,
            min_pages=args.min_pages,
            max_pages=args.max_pages,
            min_fields=args.min_fields,
            max_fields=args.max_fields,
            categories=categories,
            forms_by_category=forms_by_category,
            categories_count=args.categories_count,
            forms_per_category=args.forms_per_category,
            min_forms_per_category=args.min_forms_per_category,
            max_forms_per_category=args.max_forms_per_category,
            role_for_run=role_id_for_run,
        )

        # Exportar credenciales (si corresponde)
        if args.create_user and args.export_credentials:
            try:
                lines = []
                lines.append(f"# Credenciales generadas (corrida {RUN_PREFIX})\n")
                lines.append(f"usuario: {new_username}")
                lines.append(f"password: {new_plain_password}")
                lines.append(f"rol_id: {role_id_for_run}")
                lines.append(f"formularios_asignados: {len(forms_created)}")
                if forms_created:
                    lines.append("ids_formularios:")
                    for fid in forms_created:
                        lines.append(f"  - {fid}")
                with open(args.export_credentials, "w", encoding="utf-8") as fh:
                    fh.write("\n".join(lines) + "\n")
                print(f"[OK] Credenciales exportadas a: {args.export_credentials}")
            except Exception as ex:
                print("[WARN] No se pudo escribir export-credentials:", ex)

        # Commit / escribir SQL
        em.commit()
        if args.emit_sql:
            print(f"[OK] SQL generado en: {args.emit_sql}")
        else:
            print("[OK] Inserciones realizadas.")

    except Exception as e:
        if not args.emit_sql:
            # rollback solo si hay conexiÃ³n real
            try:
                em.cnxn.rollback()  # type: ignore[attr-defined]
            except Exception:
                pass
        print("[ERROR]", e)
        raise
    finally:
        # cerrar conexiÃ³n si aplica
        if not args.emit_sql:
            try:
                em.cnxn.close()  # type: ignore[attr-defined]
            except Exception:
                pass


if __name__ == "__main__":
    main()


#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Generador de formularios (categorías, versiones, páginas, campos y grupos) para PostgreSQL
+ asignación a usuario (opcional) o publicación masiva si no se provee usuario.

Novedades clave para PostgreSQL:
- UUID reales en tablas que lo usan (formulario, categoría, index_version, página).
- Inserciones idempotentes con ON CONFLICT DO NOTHING donde aplica.
- Sin roles: se asignan formularios directamente a un usuario (tabla formularios_user_formulario),
  o se marcan como públicos si no se provee/crea usuario.
- Usuario (tabla formularios_usuario) con password Argon2id (argon2-cffi), flags booleanos mínimos.

Uso típico:
  python generador_formularios_postgres.py \
    --emit-sql ./carga_pg.sql \
    --categories-count 3 --forms-per-category 2 \
    --seed 42 \
    --create-user --assign-user "danvalA" \
    --user-name "Daniel Valdez" --user-email "danval@example.com" \
    --export-credentials ./credenciales.txt

O conexión directa (sin --emit-sql):
  python generador_formularios_postgres.py \
    --pg-host localhost --pg-port 5432 --pg-db mi_db \
    --pg-user myuser --pg-password secret \
    --forms 3 --seed 1 --assign-user "usuario_existente"
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

# Conexión Postgres (opcional si usás --emit-sql)
try:
    import psycopg2  # type: ignore
except Exception:
    psycopg2 = None

# Argon2 para password seguro
_HAS_ARGON2 = True
try:
    from argon2 import PasswordHasher  # high-level, Argon2id por defecto
except Exception:
    _HAS_ARGON2 = False

# ========= Utilidades =========

def hex32() -> str:
    return uuid.uuid4().hex  # 32 chars minúsculas sin guiones

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
    out = "".join(random.choice(letters) for _ in range(L)).strip().capitalize()
    return out or "Texto auto"

def rand_label() -> str:
    prefixes = ["Peso", "Altura", "Humedad", "Temperatura", "Operario", "Finca", "Lote",
                "Código", "Descripción", "Comentario", "Variedad", "Rendimiento"]
    return f"{pick(prefixes)} {random.randint(1, 999)}"

def rand_unit() -> Optional[str]:
    return pick(["$", "€", "£", "Q", None])

def now_dt_iso() -> str:
    # ISO-8601 con "Z", válido para timestamptz en Postgres
    return dt.datetime.utcnow().isoformat(timespec="seconds") + "Z"

def random_password(min_len: int = 12, max_len: int = 16) -> str:
    L = random.randint(min_len, max_len)
    chars = string.ascii_letters + string.digits + "!@#$%^&*()-_=+[]{}"
    return "".join(random.choice(chars) for _ in range(L))

def hash_password_argon2(plain: str) -> str:
    if not _HAS_ARGON2:
        raise RuntimeError("Falta argon2-cffi. Instale con: pip install argon2-cffi")
    ph = PasswordHasher(time_cost=3, memory_cost=65536, parallelism=1, hash_len=32)  # Argon2id
    return ph.hash(plain)

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
    "number": {"min": [None, "number"], "max": [None, "number"], "step": [None, "number"], "unit": [None, "$", "€", "£", "Q"]},
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

# ========= Emisor SQL (compatible con archivo o ejecución directa) =========

class SqlEmitter:
    """
    Para simplificar, hacemos interpolación segura manual (escapando strings) y
    ejecutamos sentencia por sentencia.
    """
    def __init__(self, cnxn=None, emit_sql_path: Optional[str] = None):
        self.cnxn = cnxn
        self.cursor = cnxn.cursor() if cnxn else None
        self.emit_sql_path = emit_sql_path
        self._lines: List[str] = []
        if self.emit_sql_path:
            self._lines.append("-- Archivo generado automáticamente")
            self._lines.append("SET client_min_messages TO WARNING;")
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
            return "TRUE" if p else "FALSE"
        if p is None:
            return "NULL"
        # UUIDs vienen como str; c/ISO también entra como str
        return "'" + str(p).replace("'", "''") + "'"

    def exec(self, sql: str, params: Optional[Tuple[Any, ...]] = None):
        line = sql
        if params:
            for p in params:
                line = line.replace("?", self._format_param(p), 1)
        if self.emit_sql_path:
            self._lines.append(line.rstrip() + ";\n")
        else:
            assert self.cursor is not None
            self.cursor.execute(line)

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
        INSERT INTO formularios_clase_campo (clase, estructura)
        VALUES (?, ?)
        ON CONFLICT (clase) DO NOTHING
        """
        em.exec(sql, (clase, json.dumps(estructura, ensure_ascii=False)))

def ensure_categoria(em: SqlEmitter, nombre_base: str) -> str:
    cat_id = str(uuid.uuid4())  # uuid nativo en PG
    unique_name = f"{nombre_base.strip()} {random.randint(1, 9999)}"
    desc = f"Categoría auto {unique_name}"
    sql = "INSERT INTO formularios_categoria (id, nombre, descripcion) VALUES (?, ?, ?)"
    em.exec(sql, (cat_id, unique_name, desc))
    return cat_id

def insert_formulario(em: SqlEmitter, categoria_id: Optional[str], force_public: bool) -> str:
    fid = str(uuid.uuid4())
    nombre = f"Formulario {rand_label()}"
    descripcion = rand_text(40, 120)
    permitir_fotos = rand_bool()
    permitir_gps = rand_bool()
    disponible_desde = dt.date.today().isoformat()
    disponible_hasta = (dt.date.today() + dt.timedelta(days=random.randint(30, 365))).isoformat()
    estado = pick(["borrador", "activo", "inactivo"])
    forma_envio = pick(["online", "offline", "mixto"])
    es_publico = True if force_public else rand_bool()
    auto_envio = rand_bool()
    categoria_id = categoria_id or str(uuid.uuid4())

    sql = """
    INSERT INTO formularios_formulario
        (id, nombre, descripcion, permitir_fotos, permitir_gps,
         disponible_desde_fecha, disponible_hasta_fecha, estado, forma_envio,
         es_publico, auto_envio, categoria_id)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """
    em.exec(sql, (
        fid, nombre, descripcion, permitir_fotos, permitir_gps,
        disponible_desde, disponible_hasta, estado, forma_envio,
        es_publico, auto_envio, categoria_id
    ))
    return fid

def insert_index_version(em: SqlEmitter, formulario_id: str) -> str:
    ivid = str(uuid.uuid4())
    fecha_creacion = now_dt_iso()
    sql1 = """
    INSERT INTO formularios_formularioindexversion (id_index_version, fecha_creacion, formulario_id)
    VALUES (?, ?, ?)
    """
    em.exec(sql1, (ivid, fecha_creacion, formulario_id))
    sql2 = """
    INSERT INTO formularios_formularios_index_version (id_index_version, id_formulario)
    VALUES (?, ?)
    """
    em.exec(sql2, (ivid, formulario_id))
    return ivid

def insert_pagina(em: SqlEmitter, formulario_id: str, index_version_id: str, secuencia: int) -> str:
    pid = str(uuid.uuid4())
    nombre = f"Página {secuencia}"
    descripcion = rand_text(30, 90)
    sql = """
    INSERT INTO formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES (?, ?, ?, ?, ?, ?)
    """
    em.exec(sql, (pid, secuencia, nombre, descripcion, formulario_id, index_version_id))
    sql2 = """
    INSERT INTO formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES (?, ?)
    ON CONFLICT (id_pagina) DO NOTHING
    """
    em.exec(sql2, (pid, index_version_id))
    return pid

def insert_pagina_version(em: SqlEmitter, id_pagina: str) -> str:
    """
    En tu esquema PG, formularios_pagina_version.id_pagina = varchar(32).
    Pero formularios_pagina.id_pagina es uuid (36 con guiones).
    Convertimos el uuid a 32 hex sin guiones para que quepa.
    """
    pvid = hex32()  # varchar(32) para id_pagina_version
    id_pagina_compact = id_pagina.replace("-", "")  # 36 -> 32

    # Por si algún día llega algo que no sea uuid con guiones:
    if len(id_pagina_compact) != 32:
        # último recurso: trimear o rellenar, pero normalmente NO debería pasar
        id_pagina_compact = (id_pagina_compact[:32]).ljust(32, "0")

    sql = """
    INSERT INTO formularios_pagina_version (id_pagina_version, fecha_creacion, id_pagina)
    VALUES (?, ?, ?)
    """
    em.exec(sql, (pvid, now_dt_iso(), id_pagina_compact))
    return pvid


def insert_campo(em: SqlEmitter, clase: str, *, config: Optional[Dict[str, Any]] = None) -> str:
    cid = hex32()  # varchar(32)
    tipo = MAP_TIPO_POR_CLASE.get(clase, "texto")
    base_name = slugify_name(f"{clase}_{rand_label()}")
    nombre_campo = unique_nombre_campo(base_name)
    etiqueta = rand_label()
    ayuda = "Ayuda: " + rand_text(20, 50)
    if config is None:
        config = gen_config_para_clase(clase)
    config_json = json.dumps(config, ensure_ascii=False)
    requerido = rand_bool()

    sql = """
    INSERT INTO formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """
    em.exec(sql, (cid, tipo, clase, nombre_campo, etiqueta, ayuda, config_json, requerido))
    return cid

def insert_pagina_campo(em: SqlEmitter, id_pagina_version: str, id_campo: str, sequence: int):
    sql = """
    INSERT INTO formularios_pagina_campo (id_campo, sequence, id_pagina_version)
    VALUES (?, ?, ?)
    """
    em.exec(sql, (id_campo, sequence, id_pagina_version))

# ========= Grupos (estructura PG) =========

def insert_grupo_pg(em: SqlEmitter, id_grupo: str, nombre: str, id_campo_group: str):
    """
    En PG, formularios_grupo requiere id_campo_group (FK a formularios_campo).
    """
    sql = """
    INSERT INTO formularios_grupo (id_grupo, nombre, id_campo_group)
    VALUES (?, ?, ?)
    """
    em.exec(sql, (id_grupo, nombre, id_campo_group))

def link_campo_a_grupo(em: SqlEmitter, id_grupo: str, id_campo: str):
    sql = """
    INSERT INTO formularios_campo_grupo (id_grupo, id_campo)
    SELECT ?, ?
    WHERE NOT EXISTS (
      SELECT 1 FROM formularios_campo_grupo WHERE id_grupo = ? AND id_campo = ?
    )
    """
    em.exec(sql, (id_grupo, id_campo, id_grupo, id_campo))

# ========= Usuario & asignación directa de formularios =========

def ensure_user_exists_or_create(
    em: SqlEmitter,
    username: str,
    name: str,
    email: Optional[str],
    plain_password: Optional[str],
    make_active: bool = True,
    acceso_web: bool = True,
    is_staff: bool = False,
    is_superuser: bool = False,
    export_credentials_path: Optional[str] = None,
) -> Tuple[str, Optional[str]]:
    """
    Si el usuario no existe, lo crea. Si existe, no lo toca.
    Devuelve (username, password_plano_si_se_creó).
    """
    # ¿Existe?
    sql_exists = "SELECT 1 FROM formularios_usuario WHERE nombre_usuario = ?"
    if em.emit_sql_path:
        # No podemos hacer SELECT real en modo archivo; asumimos que no existe y emitimos UPSERT naive
        pass
    else:
        em.cursor.execute(sql_exists.replace("?", "%s"), (username,))  # type: ignore
        if em.cursor.fetchone():
            return username, None

    pwd = plain_password or random_password()
    pwd_hash = hash_password_argon2(pwd)

    correo = email or f"{username}@example.local"
    sql_ins = """
    INSERT INTO formularios_usuario
      (last_login, nombre_usuario, nombre, correo, password, activo, acceso_web, is_staff, is_superuser)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ON CONFLICT (nombre_usuario) DO NOTHING
    """
    em.exec(sql_ins, (None, username, name, correo, pwd_hash,
                      make_active, acceso_web, is_staff, is_superuser))

    # Exportar credenciales si pidieron
    if export_credentials_path:
        try:
            with open(export_credentials_path, "a", encoding="utf-8") as fh:
                fh.write(f"usuario: {username}\npassword: {pwd}\n\n")
        except Exception:
            pass
    return username, pwd

def assign_forms_to_user(em: SqlEmitter, username: str, form_ids: List[str]):
    for fid in form_ids:
        sql = """
        INSERT INTO formularios_user_formulario (id_formulario_id, id_usuario_id)
        SELECT ?, ?
        WHERE NOT EXISTS (
          SELECT 1 FROM formularios_user_formulario
          WHERE id_formulario_id = ? AND id_usuario_id = ?
        )
        """
        em.exec(sql, (fid, username, fid, username))

def set_all_public(em: SqlEmitter, form_ids: List[str]):
    if not form_ids:
        return
    # En lote por simplicidad (uno por uno)
    for fid in form_ids:
        sql = "UPDATE formularios_formulario SET es_publico = TRUE WHERE id = ?"
        em.exec(sql, (fid,))

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
        # se completa al crear el grupo
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
        return {"id_list": str(uuid.uuid4()), "items": items}
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

# ========= Categorías aleatorias =========

CATEGORY_NAME_POOL = [
    "Cosecha", "Corte", "Transporte", "Mantenimiento", "Fertirriego",
    "Riego", "Aplicaciones", "Calidad", "Bodega", "Seguridad",
    "Mecánica", "Eléctrico", "Topografía", "Laboratorio", "Empaque",
    "Siembra", "Siembra Mecanizada", "Cosecha Manual", "Vivero", "Sanidad",
    "Rutas", "Logística", "Producción", "RRHH Campo", "Capacitación"
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

# ========= Generación principal =========

def _parse_forms_by_category_map(spec: str) -> Dict[str, int]:
    result: Dict[str, int] = {}
    for part in spec.split(","):
        part = part.strip()
        if not part:
            continue
        if ":" not in part:
            raise ValueError(f"Entrada inválida '{part}'. Formato esperado: Nombre:Cantidad")
        name, cnt = part.split(":", 1)
        name = name.strip()
        cnt = cnt.strip()
        if not name or not cnt.isdigit():
            raise ValueError(f"Par inválido '{part}'. Ejemplo: Corte:2")
        result[name] = int(cnt)
    if not result:
        raise ValueError("Mapa vacío en --forms-by-category.")
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
    *,
    force_public_if_no_user: bool,
) -> Tuple[List[str], Dict[str, str]]:
    """
    Genera formularios y retorna:
      - forms_created: lista de IDs (uuid) de formularios creados
      - cat_ids_by_name: mapa nombre->uuid de categorías creadas
    """
    ensure_clases_campo(em)

    # Resolver categorías
    default_cats = ["Corte", "Transporte", "Mantenimiento", "Fertirriego", "Cosecha"]
    if categories and len(categories) > 0:
        cat_names = categories
        origin = "explícitas (--categories)"
    elif categories_count and categories_count > 0:
        cat_names = build_random_category_names(categories_count)
        origin = f"aleatorias (--categories-count={categories_count})"
    else:
        cat_names = default_cats
        origin = "por defecto"

    cat_ids_by_name: Dict[str, str] = {n: ensure_categoria(em, n) for n in cat_names}
    cat_id_list = list(cat_ids_by_name.values())

    em.comment(f"Origen de categorías: {origin}")
    em.comment("Resumen de categorías (nombre -> id) para esta corrida:")
    for n, cid in cat_ids_by_name.items():
        em.comment(f"  - {n} -> {cid}")
    em.comment("")

    forms_created: List[str] = []

    def _gen_form_for_category(cid: str):
        fid = insert_formulario(em, cid, force_public=force_public_if_no_user)
        forms_created.append(fid)

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
                        gid = ("grp_" + uuid.uuid4().hex)[:64]
                        gname = base_name

                        # 1) crear campo de grupo con config que referencie el id_grupo
                        cfg = {"id_group": gid, "name": gname, "fieldCondition": "always"}
                        campo_group_id = insert_campo(em, "group", config=cfg)

                        # 2) crear fila en formularios_grupo (requiere id_campo_group)
                        insert_grupo_pg(em, gid, gname, campo_group_id)

                        # 3) colocar el campo de grupo en la página
                        insert_pagina_campo(em, pvid, campo_group_id, s)

                        grupo_info = {"group_id": gid, "campo_group_id": campo_group_id, "name": gname}
                    else:
                        cid_ = insert_campo(em, clase)
                        insert_pagina_campo(em, pvid, cid_, s)
                        non_group_campos.append(cid_)

                # Asignar algunos campos al grupo (si hubo grupo)
                if grupo_info and non_group_campos:
                    k = random.randint(1, min(5, len(non_group_campos)))
                    miembros = random.sample(non_group_campos, k=k)
                    for cid_ in miembros:
                        link_campo_a_grupo(em, grupo_info["group_id"], cid_)
                    em.comment(f"Página {pseq}: grupo '{grupo_info['name']}' ({grupo_info['group_id']}) con {k} campo(s) asociado(s).")

    # Distribución por categoría
    if forms_by_category:
        total = sum(forms_by_category.values())
        em.comment(f"Distribución exacta por categoría (total formularios = {total}):")
        for n, c in forms_by_category.items():
            em.comment(f"  - {n}: {c}")
            if n not in cat_ids_by_name:
                raise ValueError(f"La categoría '{n}' indicada en --forms-by-category no está en --categories.")
        for n, count in forms_by_category.items():
            for _ in range(count):
                _gen_form_for_category(cat_ids_by_name[n])
        return forms_created, cat_ids_by_name

    if forms_per_category is not None:
        em.comment(f"Distribución fija: {forms_per_category} formulario(s) por categoría.")
        for cid in cat_id_list:
            for _ in range(forms_per_category):
                _gen_form_for_category(cid)
        return forms_created, cat_ids_by_name

    if (min_forms_per_category is not None) and (max_forms_per_category is not None):
        if min_forms_per_category > max_forms_per_category:
            raise ValueError("--min-forms-per-category no puede ser mayor que --max-forms-per-category.")
        em.comment(f"Distribución aleatoria por categoría en rango [{min_forms_per_category}, {max_forms_per_category}].")
        total = 0
        for cid in cat_id_list:
            k = random.randint(min_forms_per_category, max_forms_per_category)
            total += k
            for _ in range(k):
                _gen_form_for_category(cid)
        em.comment(f"Total de formularios generados (suma por categoría): {total}")
        return forms_created, cat_ids_by_name

    em.comment(f"Distribución aleatoria global entre {len(cat_ids_by_name)} categoría(s).")
    for _ in range(n_forms):
        _gen_form_for_category(pick(cat_id_list))
    return forms_created, cat_ids_by_name

# ========= CLI =========

def main():
    parser = argparse.ArgumentParser(description="Generador aleatorio de formularios para PostgreSQL (con asignación a usuario o publicación).")

    # Conexión PG
    parser.add_argument("--pg-host", type=str)
    parser.add_argument("--pg-port", type=int, default=5432)
    parser.add_argument("--pg-db", type=str)
    parser.add_argument("--pg-user", type=str)
    parser.add_argument("--pg-password", type=str)

    # Parámetros del generador
    parser.add_argument("--forms", type=int, default=2)
    parser.add_argument("--min-versions", type=int, default=1)
    parser.add_argument("--max-versions", type=int, default=2)
    parser.add_argument("--min-pages", type=int, default=2)
    parser.add_argument("--max-pages", type=int, default=4)
    parser.add_argument("--min-fields", type=int, default=3)
    parser.add_argument("--max-fields", type=int, default=6)

    # Categorías
    parser.add_argument("--categories", type=str, help='CSV: "Corte,Transporte,..."')
    parser.add_argument("--categories-count", type=int, default=None)
    parser.add_argument("--forms-by-category", dest="forms_by_category", type=str)
    parser.add_argument("--forms-per-category", type=int, default=None)
    parser.add_argument("--min-forms-per-category", type=int, default=None)
    parser.add_argument("--max-forms-per-category", type=int, default=None)
    parser.add_argument("--list-categories", action="store_true")

    # Reproducibilidad y emisión
    parser.add_argument("--seed", type=int, default=None)
    parser.add_argument("--emit-sql", type=str, default=None)

    # Usuario directo (sin roles)
    parser.add_argument("--create-user", action="store_true", help="Crea usuario si no existe (con Argon2) y asigna todos los formularios a ese usuario.")
    parser.add_argument("--assign-user", type=str, default=None, help="Nombre de usuario EXISTENTE al que asignar todos los formularios.")
    parser.add_argument("--user-name", type=str, default="Usuario Generado")
    parser.add_argument("--user-email", type=str, default=None)
    parser.add_argument("--user-password", type=str, default=None, help="Si no se pasa, se genera una fuerte.")
    parser.add_argument("--export-credentials", type=str, default=None, help="Ruta TXT para guardar usuario y contraseña en claro (si se crea).")
    parser.add_argument("--public-if-no-user", action="store_true", help="Si no se crea/recibe usuario, marcar todos los formularios como públicos.")

    args = parser.parse_args()
    if args.seed is not None:
        random.seed(args.seed)

    # Parse categorías explícitas
    categories: Optional[List[str]] = None
    if args.categories:
        categories = [c.strip() for c in args.categories.split(",") if c.strip()]

    forms_by_category: Optional[Dict[str, int]] = None
    if args.forms_by_category:
        forms_by_category = _parse_forms_by_category_map(args.forms_by_category)

    # Solo listar categorías/plan
    if args.list_categories:
        if categories and len(categories) > 0:
            cat_names = categories
            origin = "explícitas (--categories)"
        elif args.categories_count and args.categories_count > 0:
            cat_names = build_random_category_names(args.categories_count)
            origin = f"aleatorias (--categories-count={args.categories_count})"
        else:
            cat_names = ["Corte", "Transporte", "Mantenimiento", "Fertirriego", "Cosecha"]
            origin = "por defecto"
        print(f"[INFO] Categorías previstas ({origin}): {', '.join(cat_names)}")
        if forms_by_category:
            total = sum(forms_by_category.values())
            print(f"[INFO] Distribución exacta (total {total}):")
            for n, c in forms_by_category.items():
                print(f"  - {n}: {c}")
        elif args.forms_per_category is not None:
            total = len(cat_names) * args.forms_per_category
            print(f"[INFO] {args.forms_per_category} formulario(s) por categoría. Total = {total}.")
        elif args.min_forms_per_category is not None and args.max_forms_per_category is not None:
            print(f"[INFO] Rango por categoría: [{args.min_forms_per_category}, {args.max_forms_per_category}].")
        else:
            print(f"[INFO] Reparto aleatorio global. Total formularios: {args.forms}")
        return

    # Prepara emisor
    if args.emit_sql:
        em = SqlEmitter(cnxn=None, emit_sql_path=args.emit_sql)
    else:
        if not all([args.pg_host, args.pg_db, args.pg_user, args.pg_password]):
            print("Faltan parámetros de conexión. Use --emit-sql o provea --pg-host/--pg-db/--pg-user/--pg-password.")
            sys.exit(1)
        if psycopg2 is None:
            print("psycopg2 no está instalado. Use --emit-sql o instale psycopg2.")
            sys.exit(1)
        conn_str = f"host={args.pg_host} port={args.pg_port} dbname={args.pg_db} user={args.pg_user} password={args.pg_password}"
        cnxn = psycopg2.connect(conn_str)  # conexión típica de psycopg2
        em = SqlEmitter(cnxn=cnxn)

    # Flags de usuario
    target_username: Optional[str] = args.assign_user
    created_password: Optional[str] = None

    try:
        # Si pidieron crear usuario, lo creamos (si no existe) y lo usamos como destino
        if args.create_user:
            if not _HAS_ARGON2:
                raise RuntimeError("Para --create-user se requiere argon2-cffi. Instale: pip install argon2-cffi")
            if not target_username:
                target_username = f"user_{RUN_PREFIX}"
            _, created_password = ensure_user_exists_or_create(
                em,
                username=target_username,
                name=args.user_name,
                email=args.user_email or f"{target_username}@example.local",
                plain_password=args.user_password,
                export_credentials_path=args.export_credentials,
            )

        # Generar formularios (si no hay usuario, forzar públicos si pidieron flag)
        forms_created, _cat_map = generate(
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
            force_public_if_no_user=(target_username is None and args.public_if_no_user),
        )

        # Asignación o publicación
        if target_username:
            assign_forms_to_user(em, target_username, forms_created)
        elif args.public_if_no_user:
            set_all_public(em, forms_created)

        # Commit / escribir SQL
        em.commit()
        if args.emit_sql:
            print(f"[OK] SQL generado en: {args.emit_sql}")
        else:
            if target_username:
                print(f"[OK] Inserciones realizadas y asignadas a usuario: {target_username}")
                if created_password:
                    print("[OK] Usuario creado. (password fue exportado si se indicó --export-credentials)")
            else:
                print("[OK] Inserciones realizadas. (formularios públicos)" if args.public_if_no_user else "[OK] Inserciones realizadas.")

    except Exception as e:
        if not args.emit_sql:
            try:
                em.cnxn.rollback()  # type: ignore[attr-defined]
            except Exception:
                pass
        print("[ERROR]", e)
        raise
    finally:
        if not args.emit_sql:
            try:
                em.cnxn.close()  # type: ignore[attr-defined]
            except Exception:
                pass

if __name__ == "__main__":
    main()

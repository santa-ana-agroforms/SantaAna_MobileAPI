#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Generador de formularios (con versiones, páginas y campos) para SQL Server.

Cambios clave:
- Sin variables T-SQL @id (evita colisiones en un solo batch).
- No inserta la columna IDENTITY en dbo.formularios_paginaindex.
- Unicidad de nombre_campo: RUN_PREFIX + retries para evitar UQ collisions.
- La clase "group" es sólo un tipo de campo, poco frecuente y como máximo 1 por página.
- No crea jerarquías de grupos ni tablas auxiliares de grupo.

Uso:
  python generador_formularios_sqlserver.py --emit-sql "./carga_formularios.sql" --forms 3 --seed 42

  python generador_formularios_sqlserver.py \
    --server "tcp:localhost,1433" --database "TU_DB" --user "sa" --password "TuPassword123!" \
    --forms 3 --min-versions 1 --max-versions 3 --min-pages 2 --max-pages 4 --min-fields 3 --max-fields 7 --seed 42
"""
import argparse
import datetime as dt
import json
import random
import string
import sys
import uuid
from typing import Any, Dict, List, Optional, Tuple

try:
    import pyodbc  # type: ignore
except Exception:
    pyodbc = None  # permite --emit-sql sin pyodbc


# ========= Utilidades =========

def hex32() -> str:
    return uuid.uuid4().hex  # 32 chars

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
                "Código", "Descripción", "Comentario", "Variedad", "Rendimiento"]
    return f"{pick(prefixes)} {random.randint(1, 999)}"

def rand_unit() -> Optional[str]:
    return pick(["$", "€", "£", "Q", None])

def now_dt() -> str:
    return dt.datetime.utcnow().isoformat(timespec="seconds") + "Z"

def to_binary_bit(v: bool) -> bytes:
    return b"\x01" if v else b"\x00"


# ========= Clases de campo y configs =========

CLASES_Y_ESTRUCTURA: Dict[str, Dict[str, Any]] = {
    "boolean": {},
    "calc": {
        "vars": ["string[]"],
        "operation": ["string"],
    },
    "dataset": {
        "file": ["string"],
        "column": ["string"],
    },
    "date": {},
    "firm": {},
    "group": {
        "id_group": ["string"],
        "name": ["string"],
        "fieldCondition": ["string"],
    },
    "hour": {},
    "list": {
        "id_list": ["string"],
        "items": ["string", "number", "boolean"],
    },
    "number": {
        "min": [None, "number"],
        "max": [None, "number"],
        "step": [None, "number"],
        "unit": [None, "$", "€", "£", "Q"],
    },
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

# Pesos para elegir clase (group poco frecuente)
CLASE_WEIGHTS = {
    "boolean": 1.0,
    "calc": 1.0,
    "dataset": 0.8,
    "date": 0.9,
    "firm": 0.6,
    "group": 0.15,
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
        return {"id_group": hex32(), "name": rand_label(), "fieldCondition": "always"}
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
            self._lines.append("-- Archivo generado automáticamente")
            self._lines.append("SET NOCOUNT ON;")
            self._lines.append("")

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


# ========= Insert helpers =========

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

def ensure_categoria(em: SqlEmitter, nombre: str) -> str:
    """Crea SIEMPRE una categoría nueva, única por nombre (añade random)."""
    cat_id = hex32()
    unique_name = f"{nombre} {random.randint(1, 9999)}"
    desc = f"Categoría auto {unique_name}"
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
        categoria_id = hex32()  # si tu FK NO es nullable, asegura crear categoría antes

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
    nombre = f"Página {secuencia}"
    descripcion = rand_text(30, 90)
    sql = """
    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES (?, ?, ?, ?, ?, ?)
    """
    em.exec(sql, (pid, secuencia, nombre, descripcion, formulario_id, index_version_id))

    # pagina_index_version
    sql2 = """
    INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES (?, ?)
    """
    em.exec(sql2, (pid, index_version_id))

    # paginaindex (omite la columna IDENTITY 'id')
    sql3 = """
    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES (?, ?, ?, ?)
    """
    em.exec(sql3, (formulario_id, index_version_id, pid, now_dt()))
    return pid

def insert_pagina_version(em: SqlEmitter, id_pagina: str) -> str:
    pvid = hex32()
    sql = """
    INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion)
    VALUES (?, ?, ?)
    """
    em.exec(sql, (pvid, id_pagina, now_dt()))
    return pvid

def insert_campo(em: SqlEmitter, clase: str) -> str:
    cid = hex32()
    tipo = MAP_TIPO_POR_CLASE.get(clase, "texto")
    base_name = slugify_name(f"{clase}_{rand_label()}")
    nombre_campo = unique_nombre_campo(base_name)
    etiqueta = rand_label()
    ayuda = "Ayuda: " + rand_text(20, 50)
    config = json.dumps(gen_config_para_clase(clase), ensure_ascii=False)
    requerido = to_binary_bit(rand_bool())  # si tu columna es BIT, cambia a 0/1

    sql = """
    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """
    em.exec(sql, (cid, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido))
    return cid

def insert_pagina_campo(em: SqlEmitter, id_pagina_version: str, id_campo: str, sequence: int):
    sql = """
    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES (?, ?, ?)
    """
    em.exec(sql, (id_pagina_version, id_campo, sequence))


# ========= Generación principal =========

def generate(em: SqlEmitter, n_forms: int, min_versions: int, max_versions: int,
             min_pages: int, max_pages: int, min_fields: int, max_fields: int):
    ensure_clases_campo(em)

    categorias_base = ["Corte", "Transporte", "Mantenimiento", "Fertirriego", "Cosecha"]
    cat_ids = [ensure_categoria(em, n) for n in categorias_base]

    for _ in range(n_forms):
        categoria_id = pick(cat_ids)
        form_id = insert_formulario(em, categoria_id)

        n_versions = random.randint(min_versions, max_versions)
        for _ in range(n_versions):
            ivid = insert_index_version(em, form_id)

            n_pages = random.randint(min_pages, max_pages)
            for pseq in range(1, n_pages + 1):
                pid = insert_pagina(em, form_id, ivid, pseq)
                pvid = insert_pagina_version(em, pid)

                n_fields = random.randint(min_fields, max_fields)
                group_used = False
                for s in range(1, n_fields + 1):
                    clase = pick_clase(group_allowed=(not group_used))
                    if clase == "group":
                        group_used = True
                    cid = insert_campo(em, clase)
                    insert_pagina_campo(em, pvid, cid, s)


# ========= CLI =========

def main():
    parser = argparse.ArgumentParser(description="Generador aleatorio de formularios con versiones/páginas/campos.")
    parser.add_argument("--server", type=str, help="Servidor SQL Server, e.g. tcp:localhost,1433")
    parser.add_argument("--database", type=str, help="Nombre de la base de datos")
    parser.add_argument("--user", type=str, help="Usuario")
    parser.add_argument("--password", type=str, help="Contraseña")
    parser.add_argument("--driver", type=str, default="{ODBC Driver 17 for SQL Server}",
                        help="Driver ODBC (default: {ODBC Driver 17 for SQL Server})")

    parser.add_argument("--forms", type=int, default=2)
    parser.add_argument("--min-versions", type=int, default=1)
    parser.add_argument("--max-versions", type=int, default=2)
    parser.add_argument("--min-pages", type=int, default=2)
    parser.add_argument("--max-pages", type=int, default=4)
    parser.add_argument("--min-fields", type=int, default=3)
    parser.add_argument("--max-fields", type=int, default=6)

    parser.add_argument("--seed", type=int, default=None, help="Semilla para reproducibilidad")
    parser.add_argument("--emit-sql", type=str, default=None, help="Ruta de salida .sql (no ejecuta en DB)")

    args = parser.parse_args()
    if args.seed is not None:
        random.seed(args.seed)

    if args.emit_sql:
        em = SqlEmitter(cnxn=None, emit_sql_path=args.emit_sql)
        generate(em, args.forms, args.min_versions, args.max_versions,
                 args.min_pages, args.max_pages, args.min_fields, args.max_fields)
        em.commit()
        print(f"[OK] SQL generado en: {args.emit_sql}")
        return

    if not all([args.server, args.database, args.user, args.password]):
        print("Faltan parámetros de conexión. Use --emit-sql o provea --server/--database/--user/--password.")
        sys.exit(1)

    if pyodbc is None:
        print("pyodbc no está instalado. Use --emit-sql o instale pyodbc.")
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
    try:
        em = SqlEmitter(cnxn=cnxn)
        generate(em, args.forms, args.min_versions, args.max_versions,
                 args.min_pages, args.max_pages, args.min_fields, args.max_fields)
        em.commit()
        print("[OK] Inserciones realizadas.")
    except Exception as e:
        cnxn.rollback()
        print("[ERROR] Rollback por excepción:", e)
        raise
    finally:
        cnxn.close()

if __name__ == "__main__":
    main()

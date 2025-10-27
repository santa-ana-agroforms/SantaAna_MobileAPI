# /app/seed.py
import os, time, glob, psycopg2
from psycopg2.extras import RealDictCursor

DB_HOST = os.getenv("DB_HOST", "db")
DB_PORT = int(os.getenv("DB_PORT", "5432"))
DB_NAME = os.getenv("DB_NAME", "santa_ana_test")
DB_USER = os.getenv("DB_USER", "santa_ana")
DB_PASSWORD = os.getenv("DB_PASSWORD", "santa_ana")
DB_WAIT_SECONDS = int(os.getenv("DB_WAIT_SECONDS", "90"))
FIXTURES_DIR = os.getenv("FIXTURES_DIR", "/app/fixtures")

REQUIRED_TABLES = os.getenv("REQUIRED_TABLES", "formularios_usuario,formularios_formulario") \
                    .split(",")

def wait_for_db():
    print("[seeder] Esperando a Postgres…")
    t0 = time.time()
    while time.time() - t0 < DB_WAIT_SECONDS:
        try:
            with psycopg2.connect(
                host=DB_HOST, port=DB_PORT, dbname=DB_NAME,
                user=DB_USER, password=DB_PASSWORD
            ) as conn:
                conn.autocommit = True
                with conn.cursor() as cur:
                    cur.execute("SELECT 1")
                return
        except Exception:
            time.sleep(1)
    raise RuntimeError("DB no respondió a tiempo")

def wait_for_tables():
    print(f"[seeder] Esperando a tablas… {REQUIRED_TABLES}")
    t0 = time.time()
    while time.time() - t0 < DB_WAIT_SECONDS:
        try:
            with psycopg2.connect(
                host=DB_HOST, port=DB_PORT, dbname=DB_NAME,
                user=DB_USER, password=DB_PASSWORD
            ) as conn, conn.cursor() as cur:
                ok = True
                for t in REQUIRED_TABLES:
                    cur.execute("""
                        SELECT to_regclass(%s)
                    """, (f"public.{t.strip()}",))
                    if cur.fetchone()[0] is None:
                        ok = False
                        break
                if ok:
                    return
        except Exception:
            pass
        time.sleep(1)
    raise RuntimeError("Tablas requeridas no existen aún")

def sanitize_sql_newlines(sql: str) -> str:
    """
    Recorre el SQL y reemplaza SOLO los saltos de línea REALES dentro de strings
    de comillas simples por la secuencia \\n. Ignora dollar-quoting.
    Respeta '' (comilla simple duplicada) dentro del string.
    """
    out = []
    i, n = 0, len(sql)
    IN_NONE, IN_SQ, IN_DOLLAR = 0, 1, 2
    state = IN_NONE
    dollar_tag = None

    while i < n:
        ch = sql[i]

        if state == IN_NONE:
            if ch == "'":
                state = IN_SQ
                out.append(ch)
                i += 1
            elif ch == "$":
                # posible $tag$
                j = i + 1
                while j < n and (sql[j].isalnum() or sql[j] == "_"):
                    j += 1
                if j < n and sql[j] == "$" and j > i + 1:
                    # tenemos $tag$
                    dollar_tag = sql[i:j+1]  # incluye los 2 $
                    out.append(dollar_tag)
                    i = j + 1
                    state = IN_DOLLAR
                else:
                    out.append(ch)
                    i += 1
            else:
                out.append(ch)
                i += 1

        elif state == IN_DOLLAR:
            # copiar hasta que aparezca $tag$
            if sql.startswith(dollar_tag, i):
                out.append(dollar_tag)
                i += len(dollar_tag)
                state = IN_NONE
            else:
                out.append(ch)
                i += 1

        else:  # state == IN_SQ (single-quoted string)
            if ch == "'":
                # ¿escape ''?
                if i + 1 < n and sql[i+1] == "'":
                    out.append("''")
                    i += 2
                else:
                    out.append("'")
                    i += 1
                    state = IN_NONE
            elif ch == "\n":
                # convertir newline real a la secuencia \n
                out.append("\\n")
                i += 1
            else:
                out.append(ch)
                i += 1

    return "".join(out)

def split_sql_statements(text: str) -> list[str]:
    stmts, buf = [], []
    in_squote = in_dquote = in_line_cmt = in_block_cmt = False
    dollar_tag = None
    i, n = 0, len(text)

    def startswith_dollar_tag(s: str, pos: int) -> str | None:
        if s[pos] != '$': 
            return None
        j = pos + 1
        while j < n and (s[j].isalnum() or s[j] == '_'):
            j += 1
        if j < n and s[j] == '$':
            return s[pos:j+1]  # e.g. "$tag$" o "$$"
        return None

    while i < n:
        ch = text[i]
        nxt = text[i+1] if i+1 < n else ''

        # Comentarios línea
        if not (in_squote or in_dquote or dollar_tag or in_block_cmt) and ch == '-' and nxt == '-':
            in_line_cmt = True
            i += 2
            continue
        if in_line_cmt:
            if ch == '\n':
                in_line_cmt = False
            i += 1
            continue

        # Comentarios bloque
        if not (in_squote or in_dquote or dollar_tag or in_block_cmt) and ch == '/' and nxt == '*':
            in_block_cmt = True
            i += 2
            continue
        if in_block_cmt:
            if ch == '*' and nxt == '/':
                in_block_cmt = False
                i += 2
                continue
            i += 1
            continue

        # Dollar-quoting start/end
        if dollar_tag is None and not (in_squote or in_dquote):
            tag = startswith_dollar_tag(text, i)
            if tag:
                dollar_tag = tag
                buf.append(tag)
                i += len(tag)
                continue
        if dollar_tag:
            if text.startswith(dollar_tag, i):
                buf.append(dollar_tag)
                i += len(dollar_tag)
                dollar_tag = None
                continue
            buf.append(ch)
            i += 1
            continue

        # Cadenas '...' y "identificadores"
        if ch == "'" and not in_dquote:
            in_squote = not in_squote
            buf.append(ch); i += 1; continue
        if ch == '"' and not in_squote:
            in_dquote = not in_dquote
            buf.append(ch); i += 1; continue

        # Fin de sentencia
        if ch == ';' and not (in_squote or in_dquote):
            stmt = ''.join(buf).strip()
            if stmt:
                stmts.append(stmt)
            buf.clear()
            i += 1
            continue

        buf.append(ch)
        i += 1

    tail = ''.join(buf).strip()
    if tail:
        stmts.append(tail)
    return stmts


def exec_dml_file(conn, path: str):
    with open(path, 'r', encoding='utf-8') as f:
        raw = f.read()

    # Opcional: normalizar líneas "OWNER TO ..." que a veces vienen de dumps
    lines = [ln for ln in raw.splitlines() if ' OWNER TO ' not in ln]
    raw = '\n'.join(lines)

    stmts = split_sql_statements(raw)

    dml = [s for s in stmts if s.lstrip().lower().startswith(('insert', 'update'))]
    if not dml:
        return

    with conn.cursor() as cur:
        cur.execute("BEGIN")
        try:
            cur.execute("SET LOCAL session_replication_role = 'replica'")
            for idx, s in enumerate(dml, 1):
                try:
                    cur.execute(s)
                except Exception as e:
                    preview = ' '.join(s.split())[:400]
                    raise RuntimeError(
                        f'Fallo en "{path}" stmt #{idx}: {e}\nSQL: {preview}'
                    ) from e
            cur.execute("COMMIT")
        except Exception:
            cur.execute("ROLLBACK")
            raise



def load_fixtures(conn):
    order = [
        # 1) usuarios y permisos
        "formularios_usuario.sql",
        "formularios_usuario_groups.sql",
        "formularios_usuario_user_permissions.sql",
        # 2) catálogo / estructuras
        "formularios_categoria.sql",
        "formularios_formulario.sql",
        "formularios_formularioindexversion.sql",
        "formularios_formularios_index_version.sql",
        "formularios_pagina.sql",
        "formularios_pagina_version.sql",
        "formularios_pagina_index_version.sql",
        # 3) campos y grupos
        "formularios_campo.sql",
        "formularios_grupo.sql",
        "formularios_campo_grupo.sql",
        # 4) datasets
        "formularios_fuente_datos.sql",
        "formularios_fuente_datos_valor.sql",
        # 5) puentes y entries
        "formularios_user_formulario.sql",
        "formularios_pagina_campo.sql",
        "formularios_entry.sql",
        "seed_operador1.sql",
        "other.sql",
    ]
    print("[seeder] Sembrando datos…")
    for fname in order:
        full = os.path.join(FIXTURES_DIR, fname)
        if not os.path.exists(full):
            print(f"[seeder] (omito) no existe {fname}")
            continue
        print(f"[seeder] Cargando: {fname}")
        exec_dml_file(conn, full)

def main():
    wait_for_db()
    wait_for_tables()

    print("[seeder] Conectando y sembrando…")
    with psycopg2.connect(
        host=DB_HOST, port=DB_PORT, dbname=DB_NAME,
        user=DB_USER, password=DB_PASSWORD
    ) as conn:
        conn.autocommit = False
        load_fixtures(conn)

    print("[seeder] ✅ OK")

if __name__ == "__main__":
    main()

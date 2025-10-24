#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Generador de SQL para crear categorías, formularios, páginas, versiones de página,
campos (sin clases list/calc/dataset), y asignar formularios a un usuario dado.

- No se conecta a la BD. Solo genera un archivo .sql con los INSERT en orden.
- Estructura compatible con el esquema proporcionado (PostgreSQL).
- Los grupos se modelan como:
    * Un campo de clase "group" (en formularios_campo).
    * Un registro en formularios_grupo que usa ese campo como id_campo_group.
    * Los campos "hijos" del grupo se registran en formularios_campo
      y se relacionan al grupo vía formularios_campo_grupo.
    * En la página solo se agrega el campo del grupo (los hijos NO se agregan a pagina_campo).

Uso:
    python generador_forms_sql.py \
        --usuario danar \
        --formularios-por-categoria 3 \
        --categorias 2 \
        --salida salida.sql \
        [--semilla 42]

"""

import argparse
import json
import random
import sys
import uuid
from datetime import date, timedelta, datetime

ALLOWED_FIELD_CLASSES = [
    "boolean",
    "date",
    "firm",
    "hour",
    "number",
    "string",
    "text",
    "group",  # especial: contendrá subcampos
]

# Campos PROHIBIDOS por requerimiento
BANNED_CLASSES = {"list", "calc", "dataset"}

FORMA_ENVIO = "En Linea/fuera Linea"
ESTADO_FORM = "Ingresada"

SPANISH_WORDS = [
    "Nombre", "Apellido", "Dirección", "Municipio", "Departamento", "Correo",
    "Teléfono", "Edad", "Género", "Observaciones", "Comentario", "Referencia",
    "Código", "Puesto", "Empresa", "Proyecto", "Zona", "Barrio", "Colonia",
    "Contacto", "Descripción", "Detalle", "Monto", "Fecha", "Hora",
]

CATEGORIA_NOMBRES = [
    "Operativo", "Calidad", "Logística", "Comercial", "Tecnología", "RRHH",
    "Mantenimiento", "Finanzas", "Atención al Cliente", "Auditoría",
]


def u() -> str:
    return str(uuid.uuid4())


def u32() -> str:
    """UUID sin guiones (32 chars) para id_pagina_version (varchar(32))."""
    return uuid.uuid4().hex


def sql_quote(txt: str) -> str:
    """Escapar comillas simples para literales de texto en SQL."""
    return txt.replace("'", "''")


def sql_text_or_null(val: str | None) -> str:
    """Devuelve 'NULL' o un literal SQL entre comillas simples, ya escapado."""
    if val is None:
        return "NULL"
    return "'" + sql_quote(val) + "'"


def jtxt(obj) -> str:
    """JSON como texto apropiado para SQL (comillas simples escapadas)."""
    return sql_quote(json.dumps(obj, ensure_ascii=False))


def pick_label(prefix: str, i: int) -> str:
    base = random.choice(SPANISH_WORDS)
    return f"{prefix} {base} {i}"[:95]  # etiqueta máx 100 (dejamos margen)


def pick_help() -> str | None:
    if random.random() < 0.35:
        return None
    hints = [
        "Llenar con letra legible.",
        "Formato AAAA-MM-DD.",
        "Campo opcional.",
        "Use números enteros.",
        "Revise antes de enviar.",
        "Puede dejar en blanco si no aplica.",
    ]
    return random.choice(hints)


def number_config():
    lo = random.randint(0, 50)
    hi = lo + random.randint(5, 200)
    step = random.choice([1, 1, 1, 5, 10])
    unit = random.choice([None, "Q", "$", "€", "£"])
    return {
        "min": lo,
        "max": hi,
        "step": step,
        "unit": unit,
    }


def field_config(field_class: str, *, group_id: str | None = None) -> dict:
    if field_class == "number":
        return number_config()
    if field_class == "group":
        # Requisito: solo debe ir el id_group
        return {"id_group": group_id}
    # demás clases -> objeto vacío
    return {}


def make_form_name(cat_idx: int, form_idx: int) -> str:
    return f"Formulario {cat_idx+1}-{form_idx+1}"


def make_page_name(pi: int) -> str:
    return f"Página {pi+1}"


def main():
    ap = argparse.ArgumentParser(description="Generador de SQL de formularios aleatorios.")
    ap.add_argument("--usuario", required=True, help="nombre_usuario existente en formularios_usuario")
    ap.add_argument("--formularios-por-categoria", type=int, required=True)
    ap.add_argument("--categorias", type=int, required=True)
    ap.add_argument("--salida", required=True, help="Ruta del archivo .sql a generar")
    ap.add_argument("--semilla", type=int, default=None, help="Semilla aleatoria opcional")
    args = ap.parse_args()

    if args.semilla is not None:
        random.seed(args.semilla)

    now = datetime.utcnow()
    hoy = date.today()
    sql_lines: list[str] = []
    sql_lines.append("-- SQL generado automáticamente")
    sql_lines.append("BEGIN;")

    # 1) Crear categorías
    categorias = []
    for ci in range(args.categorias):
        cid = u()
        nombre = CATEGORIA_NOMBRES[ci % len(CATEGORIA_NOMBRES)] + f" {ci+1}"
        descripcion = f"Categoría auto-generada #{ci+1}."
        categorias.append((cid, nombre, descripcion))
        sql_lines.append(
            f"INSERT INTO formularios_categoria (id, nombre, descripcion) VALUES "
            f"('{cid}'::uuid, '{sql_quote(nombre)}', '{sql_quote(descripcion)}');"
        )

    # 2) Por cada categoría, crear formularios
    for ci, (cat_id, cat_name, _) in enumerate(categorias):
        for fi in range(args.formularios_por_categoria):
            form_id = u()
            form_name = make_form_name(ci, fi)
            descripcion = f"{form_name} de la categoría {cat_name}."
            permitir_fotos = random.choice([True, False])
            permitir_gps = random.choice([True, False])
            disp_desde = hoy
            disp_hasta = hoy + timedelta(days=random.choice([60, 90, 120]))
            es_publico = random.choice([True, False, False])  # sesgo a privado
            auto_envio = random.choice([True, False])
            periodicidad = random.choice([None, None, 7, 15, 30])

            # INSERT formulario
            sql_lines.append(
                "INSERT INTO formularios_formulario "
                "(id, nombre, descripcion, permitir_fotos, permitir_gps, disponible_desde_fecha, "
                " disponible_hasta_fecha, estado, forma_envio, es_publico, auto_envio, categoria_id, periodicidad) "
                f"VALUES ('{form_id}'::uuid, '{sql_quote(form_name)}', '{sql_quote(descripcion)}', "
                f"{'true' if permitir_fotos else 'false'}, {'true' if permitir_gps else 'false'}, "
                f"'{disp_desde.isoformat()}', '{disp_hasta.isoformat()}', "
                f"'{ESTADO_FORM}', '{FORMA_ENVIO}', "
                f"{'true' if es_publico else 'false'}, {'true' if auto_envio else 'false'}, "
                f"'{cat_id}'::uuid, "
                f"{('NULL' if periodicidad is None else str(periodicidad))}"
                ");"
            )

            # 2.1) Crear versión de formulario y link en puente
            index_version_id = u()
            sql_lines.append(
                "INSERT INTO formularios_formularioindexversion (id_index_version, fecha_creacion) "
                f"VALUES ('{index_version_id}'::uuid, '{now.isoformat()}Z');"
            )
            sql_lines.append(
                "INSERT INTO formularios_formularios_index_version (id_index_version, id_formulario) "
                f"VALUES ('{index_version_id}'::uuid, '{form_id}'::uuid);"
            )

            # 2.2) Asignar formulario al usuario
            sql_lines.append(
                "INSERT INTO formularios_user_formulario (id_formulario_id, id_usuario_id) "
                f"VALUES ('{form_id}'::uuid, '{sql_quote(args.usuario)}');"
            )

            # 2.3) Páginas (1 a 3)
            num_pages = random.randint(1, 3)
            for pi in range(num_pages):
                pagina_id = u()
                pagina_nombre = make_page_name(pi)
                pagina_desc = f"Sección {pi+1} del {form_name}."
                secuencia = pi + 1

                sql_lines.append(
                    "INSERT INTO formularios_pagina (id_pagina, secuencia, nombre, descripcion) "
                    f"VALUES ('{pagina_id}'::uuid, {secuencia}, '{sql_quote(pagina_nombre)}', '{sql_quote(pagina_desc)}');"
                )

                # Relación página ↔ versión de form
                sql_lines.append(
                    "INSERT INTO formularios_pagina_index_version (id_pagina, id_index_version) "
                    f"VALUES ('{pagina_id}'::uuid, '{index_version_id}'::uuid);"
                )

                # Versión de página (usar uuid sin guiones)
                pagina_version_id = u32()
                sql_lines.append(
                    "INSERT INTO formularios_pagina_version (id_pagina_version, fecha_creacion, id_pagina) "
                    f"VALUES ('{pagina_version_id}', '{now.isoformat()}Z', '{pagina_id}'::uuid);"
                )

                # 2.4) Campos en la página (3 a 7 elementos, algunos pueden ser grupos)
                elements = random.randint(3, 7)
                used_names: set[str] = set()
                sequence = 1

                def next_name(base: str) -> str:
                    i = 1
                    candidate = f"{base}_{i}".lower()[:60]
                    while candidate in used_names:
                        i += 1
                        candidate = f"{base}_{i}".lower()[:60]
                    used_names.add(candidate)
                    return candidate

                for ei in range(elements):
                    # Decidir si es grupo o no (máx 1-2 grupos por página, aprox 25%)
                    make_group = random.random() < 0.25
                    if make_group:
                        # Campo-grupo
                        campo_group_id = u()
                        group_id = u()
                        etiqueta_g = pick_label("Grupo", ei + 1)
                        nombre_campo_g = next_name("grupo")
                        ayuda_g = pick_help()
                        cfg_group = field_config("group", group_id=group_id)

                        sql_lines.append(
                            "INSERT INTO formularios_campo "
                            "(id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido) VALUES "
                            f"('{campo_group_id}'::uuid, 'group', 'group', '{sql_quote(nombre_campo_g)}', "
                            f"'{sql_quote(etiqueta_g)}', "
                            f"{sql_text_or_null(ayuda_g)}, "
                            f"'{jtxt(cfg_group)}', false);"
                        )

                        # Crear formulario_grupo
                        sql_lines.append(
                            "INSERT INTO formularios_grupo (id_grupo, nombre, id_campo_group) VALUES "
                            f"('{group_id}'::uuid, '{sql_quote(etiqueta_g)}', '{campo_group_id}'::uuid);"
                        )

                        # El grupo va en la página
                        sql_lines.append(
                            "INSERT INTO formularios_pagina_campo (id_campo, sequence, id_pagina_version) VALUES "
                            f"('{campo_group_id}'::uuid, {sequence}, '{pagina_version_id}');"
                        )
                        sequence += 1

                        # Crear 2-4 campos HIJOS del grupo
                        hijos = random.randint(2, 4)
                        for hi in range(hijos):
                            fclass = random.choice([c for c in ALLOWED_FIELD_CLASSES if c != "group"])
                            while fclass in BANNED_CLASSES:
                                fclass = random.choice([c for c in ALLOWED_FIELD_CLASSES if c != "group"])

                            campo_id = u()
                            etiqueta = pick_label("Campo", hi + 1)
                            nombre_campo = next_name(fclass)
                            ayuda = pick_help()
                            cfg = field_config(fclass)

                            sql_lines.append(
                                "INSERT INTO formularios_campo "
                                "(id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido) VALUES "
                                f"('{campo_id}'::uuid, '{fclass}', '{fclass}', '{sql_quote(nombre_campo)}', "
                                f"'{sql_quote(etiqueta)}', "
                                f"{sql_text_or_null(ayuda)}, "
                                f"'{jtxt(cfg)}', "
                                f"{'true' if random.random() < 0.55 else 'false'}"
                                ");"
                            )

                            # Relación campo hijo ↔ grupo
                            sql_lines.append(
                                "INSERT INTO formularios_campo_grupo (id_campo, id_grupo) VALUES "
                                f"('{campo_id}'::uuid, '{group_id}'::uuid);"
                            )

                    else:
                        # Campo normal
                        fclass = random.choice([c for c in ALLOWED_FIELD_CLASSES if c != "group"])
                        while fclass in BANNED_CLASSES:
                            fclass = random.choice([c for c in ALLOWED_FIELD_CLASSES if c != "group"])

                        campo_id = u()
                        etiqueta = pick_label("Campo", ei + 1)
                        nombre_campo = next_name(fclass)
                        ayuda = pick_help()
                        cfg = field_config(fclass)

                        sql_lines.append(
                            "INSERT INTO formularios_campo "
                            "(id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido) VALUES "
                            f"('{campo_id}'::uuid, '{fclass}', '{fclass}', '{sql_quote(nombre_campo)}', "
                            f"'{sql_quote(etiqueta)}', "
                            f"{sql_text_or_null(ayuda)}, "
                            f"'{jtxt(cfg)}', "
                            f"{'true' if random.random() < 0.55 else 'false'}"
                            ");"
                        )

                        # Relación campo ↔ página
                        sql_lines.append(
                            "INSERT INTO formularios_pagina_campo (id_campo, sequence, id_pagina_version) VALUES "
                            f"('{campo_id}'::uuid, {sequence}, '{pagina_version_id}');"
                        )
                        sequence += 1

    sql_lines.append("COMMIT;")

    # Guardar archivo
    with open(args.salida, "w", encoding="utf-8") as f:
        f.write("\n".join(sql_lines))

    print(f"✅ SQL generado en: {args.salida}")
    print("Sugerencia: revisar y ejecutar en un entorno de prueba primero.")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\\nCancelado por el usuario.", file=sys.stderr)
        sys.exit(130)

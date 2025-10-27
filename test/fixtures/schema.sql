-- Esquema mínimo para tests E2E
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Limpieza idempotente
DROP TABLE IF EXISTS formularios_entry CASCADE;
DROP TABLE IF EXISTS formularios_pagina_campo CASCADE;
DROP TABLE IF EXISTS formularios_pagina_index_version CASCADE;
DROP TABLE IF EXISTS formularios_pagina_version CASCADE;
DROP TABLE IF EXISTS formularios_pagina CASCADE;
DROP TABLE IF EXISTS formularios_campo_grupo CASCADE;
DROP TABLE IF EXISTS formularios_fuente_datos_valor CASCADE;
DROP TABLE IF EXISTS formularios_fuente_datos CASCADE;
DROP TABLE IF EXISTS formularios_formularios_index_version CASCADE;
DROP TABLE IF EXISTS formularios_formularioindexversion CASCADE;
DROP TABLE IF EXISTS formularios_user_formulario CASCADE;
DROP TABLE IF EXISTS formularios_formulario CASCADE;
DROP TABLE IF EXISTS formularios_categoria CASCADE;
DROP TABLE IF EXISTS formularios_campo CASCADE;
DROP TABLE IF EXISTS formularios_usuario_user_permissions CASCADE;
DROP TABLE IF EXISTS formularios_usuario_groups CASCADE;
DROP TABLE IF EXISTS formularios_usuario CASCADE;

-- Usuario
CREATE TABLE formularios_usuario (
  last_login     timestamptz,
  nombre_usuario varchar(50)  PRIMARY KEY,
  nombre         varchar(100) NOT NULL,
  correo         varchar(254) NOT NULL UNIQUE,
  password       varchar(128) NOT NULL,
  activo         boolean      NOT NULL,
  acceso_web     boolean      NOT NULL,
  is_staff       boolean      NOT NULL,
  is_superuser   boolean      NOT NULL
);

-- Categoría
CREATE TABLE formularios_categoria (
  id          uuid PRIMARY KEY,
  nombre      varchar(100) NOT NULL,
  descripcion text NOT NULL
);

-- Formulario
CREATE TABLE formularios_formulario (
  id                     uuid PRIMARY KEY,
  nombre                 varchar(100) NOT NULL,
  descripcion            text NOT NULL,
  permitir_fotos         boolean NOT NULL,
  permitir_gps           boolean NOT NULL,
  disponible_desde_fecha date NOT NULL,
  disponible_hasta_fecha date NOT NULL,
  estado                 varchar(20) NOT NULL,
  forma_envio            varchar(30) NOT NULL,
  es_publico             boolean NOT NULL,
  auto_envio             boolean NOT NULL,
  categoria_id           uuid REFERENCES formularios_categoria,
  periodicidad           integer
);

-- Versionado de índice de formulario
CREATE TABLE formularios_formularioindexversion (
  id_index_version uuid PRIMARY KEY,
  fecha_creacion   timestamptz NOT NULL
);

CREATE TABLE formularios_formularios_index_version (
  id_index_version uuid PRIMARY KEY
    REFERENCES formularios_formularioindexversion,
  id_formulario    uuid NOT NULL
    REFERENCES formularios_formulario
);

-- Página
CREATE TABLE formularios_pagina (
  id_pagina   uuid PRIMARY KEY,
  secuencia   integer NOT NULL CHECK (secuencia >= 0),
  nombre      varchar(120) NOT NULL,
  descripcion text NOT NULL
);

-- Versión de página (32-hex)
CREATE TABLE formularios_pagina_version (
  id_pagina_version varchar(32) PRIMARY KEY,
  fecha_creacion    timestamptz NOT NULL,
  id_pagina         uuid REFERENCES formularios_pagina
);

-- Enlace página ↔ versión de índice
CREATE TABLE formularios_pagina_index_version (
  id_pagina        uuid PRIMARY KEY REFERENCES formularios_pagina,
  id_index_version uuid NOT NULL REFERENCES formularios_formularioindexversion
);

-- Campo (⚠️ id_campo :: uuid)
CREATE TABLE formularios_campo (
  id_campo     uuid PRIMARY KEY,
  tipo         varchar(20)  NOT NULL,
  clase        varchar(30)  NOT NULL,
  nombre_campo varchar(64)  NOT NULL,
  etiqueta     varchar(100) NOT NULL,
  ayuda        varchar(255),
  config       text,
  requerido    boolean
);

-- Página ↔ Campo (id_pagina_version :: varchar(32))
CREATE TABLE formularios_pagina_campo (
  id_campo          uuid PRIMARY KEY REFERENCES formularios_campo,
  sequence          integer CHECK (sequence >= 0),
  id_pagina_version varchar(32) NOT NULL REFERENCES formularios_pagina_version,
  CONSTRAINT formularios_pagina_campo_id_campo_id_pagina_versi_bad4d405_uniq
    UNIQUE (id_campo, id_pagina_version)
);

-- Tabla puente usuario ↔ formulario
CREATE TABLE formularios_user_formulario (
  id               bigserial PRIMARY KEY,
  id_formulario_id uuid        NOT NULL REFERENCES formularios_formulario,
  id_usuario_id    varchar(50) NOT NULL REFERENCES formularios_usuario,
  CONSTRAINT formularios_user_formula_id_formulario_id_id_usua_75d33c88_uniq
    UNIQUE (id_formulario_id, id_usuario_id)
);

-- Fuente de datos
CREATE TABLE formularios_fuente_datos (
  id             uuid PRIMARY KEY,
  nombre         varchar(200) NOT NULL,
  descripcion    text NOT NULL,
  archivo_nombre varchar(255) NOT NULL,
  blob_name      varchar(500) NOT NULL,
  blob_url       varchar(1000) NOT NULL,
  tipo_archivo   varchar(10) NOT NULL,
  columnas       jsonb NOT NULL,
  preview_data   jsonb NOT NULL,
  fecha_subida   timestamptz NOT NULL,
  activo         boolean NOT NULL,
  creado_por_id  varchar(50) REFERENCES formularios_usuario
);

-- Valores de fuente (⚠️ campo_id y fuente_id :: uuid; columna opcional 'version')
CREATE TABLE formularios_fuente_datos_valor (
  id         uuid PRIMARY KEY,
  columna    varchar(200) NOT NULL,
  key_text   text,
  label_text text NOT NULL,
  valor_raw  jsonb NOT NULL,
  extras     jsonb NOT NULL,
  creado_en  timestamptz NOT NULL,
  campo_id   uuid NOT NULL REFERENCES formularios_campo,
  fuente_id  uuid NOT NULL REFERENCES formularios_fuente_datos
  -- si tu esquema real tiene "version" INT, puedes añadirla:
  -- , version integer
);

-- Grupo de campos (utilizado en NOT EXISTS del service)
CREATE TABLE formularios_campo_grupo (
  id       bigserial PRIMARY KEY,
  id_campo uuid NOT NULL REFERENCES formularios_campo,
  id_grupo uuid NOT NULL
  -- sin triggers de auditoría
);

-- Entries
CREATE TABLE formularios_entry (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  id_usuario_id    text NOT NULL REFERENCES formularios_usuario(nombre_usuario),
  form_id          uuid NOT NULL REFERENCES formularios_formulario,
  index_version_id uuid NOT NULL REFERENCES formularios_formularioindexversion,
  form_name        text NOT NULL,
  filled_at_local  timestamptz NOT NULL,
  status           varchar NOT NULL DEFAULT 'pending',
  fill_json        jsonb NOT NULL CHECK (jsonb_typeof(fill_json) = 'object'),
  form_json        jsonb NOT NULL CHECK (jsonb_typeof(form_json) = 'object'),
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now()
);

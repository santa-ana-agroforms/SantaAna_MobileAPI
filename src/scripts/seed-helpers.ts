// scripts/seed-helpers.ts
import { DataSource } from 'typeorm';
import * as argon2 from 'argon2';
import { readFileSync, existsSync } from 'node:fs';
import { join } from 'node:path';

/** Detecta el directorio de fixtures. Puedes forzarlo con FIXTURES_DIR. */
export function fixturesDir(): string {
  const override = process.env.FIXTURES_DIR;
  if (override && existsSync(override)) return override;

  // Ejecutado ya compilado (dist/scripts/*) → dist/fixtures
  const distFixtures = join(__dirname, '..', 'fixtures');
  if (existsSync(distFixtures)) return distFixtures;

  // Ejecutado desde repo sin compilar → test/fixtures
  const testFixtures = join(process.cwd(), 'test', 'fixtures');
  if (existsSync(testFixtures)) return testFixtures;

  // Otra ruta posible si cambia el cwd
  const altTestFixtures = join(__dirname, '..', '..', 'test', 'fixtures');
  if (existsSync(altTestFixtures)) return altTestFixtures;

  // Último fallback (útil en contenedores custom)
  const generic = join(process.cwd(), 'fixtures');
  return generic;
}

/** Normaliza SQL: elimina OWNER TO y ALTER TABLE ... OWNER TO ...; */
export function normalizeSql(raw: string): string {
  const noOwnerStmt = raw.replace(
    /ALTER\s+TABLE\s+[\s\S]*?OWNER\s+TO\s+[^\n;]+;/gi,
    '',
  );
  return noOwnerStmt
    .split(/\r?\n/)
    .filter((ln) => !/\bOWNER\s+TO\b/i.test(ln))
    .join('\n');
}

/**
 * Ejecuta un archivo .sql pero **solo** corre statements DML (INSERT/UPDATE).
 * Ignora otros tipos por seguridad (CREATE, ALTER, etc).
 */
export async function execSqlDataOnly(
  ds: DataSource,
  fileName: string,
  baseDir = fixturesDir(),
): Promise<void> {
  const full = join(baseDir, fileName);
  const raw = readFileSync(full, 'utf8');
  const sql = normalizeSql(raw);

  const stmts = sql
    .split(/;\s*[\r\n]+/g)
    .map((s) => s.trim())
    .filter((s) => s.length > 0);

  for (let i = 0; i < stmts.length; i++) {
    const s = stmts[i];
    if (!/^(insert|update)\s+/i.test(s)) continue; // solo DML

    try {
      await ds.query(s);
    } catch (e: any) {
      const preview = s.replace(/\s+/g, ' ').slice(0, 400);
      console.error(
        `❌ SQL "${fileName}" falló en statement #${i + 1}/${stmts.length}\n` +
          `SQL (preview): ${preview}\n` +
          `Error: ${e?.message ?? e}`,
      );
      throw e;
    }
  }
}

/**
 * Carga TODOS los .sql de fixtures en orden (solo DML).
 * Durante la carga deshabilita FKs con session_replication_role='replica'.
 */
export async function loadAllDbFixtures(
  ds: DataSource,
  files?: string[],
  baseDir = fixturesDir(),
): Promise<void> {
  const defaultOrder = [
    // 1) Usuarios y permisos
    'formularios_usuario.sql',
    'formularios_usuario_groups.sql',
    'formularios_usuario_user_permissions.sql',

    // 2) Catálogo / estructuras
    'formularios_categoria.sql',
    'formularios_formulario.sql',
    'formularios_formularioindexversion.sql',
    'formularios_formularios_index_version.sql',

    'formularios_pagina.sql',
    'formularios_pagina_version.sql',
    'formularios_pagina_index_version.sql',

    'formularios_campo.sql',
    'formularios_grupo.sql',
    'formularios_campo_grupo.sql',

    // 3) Datasets
    'formularios_fuente_datos.sql',
    'formularios_fuente_datos_valor.sql',

    // 4) Puentes y entries
    'formularios_user_formulario.sql',
    'formularios_pagina_campo.sql',
    'formularios_entry.sql',
  ];

  const order = files && files.length > 0 ? files : defaultOrder;

  await ds.query('BEGIN');
  try {
    await ds.query(`SET LOCAL session_replication_role = 'replica'`);
    for (const f of order) {
      await execSqlDataOnly(ds, f, baseDir);
    }
    await ds.query('COMMIT');
  } catch (e) {
    await ds.query('ROLLBACK');
    throw e;
  }
}

/** Crea/actualiza un usuario con Argon2 (tabla y columnas según tu esquema). */
export async function upsertUsuario(
  ds: DataSource,
  {
    nombreUsuario,
    password,
    nombre = 'Usuario Seed',
    correo = `${nombreUsuario}@local.test`,
    activo = true,
    accesoWeb = true,
    isStaff = false,
    isSuperuser = false,
  }: {
    nombreUsuario: string;
    password: string;
    nombre?: string;
    correo?: string;
    activo?: boolean;
    accesoWeb?: boolean;
    isStaff?: boolean;
    isSuperuser?: boolean;
  },
): Promise<void> {
  const hash = await argon2.hash(password, { type: argon2.argon2id });

  // Ajusta nombres de tabla/columnas si difieren
  await ds.query(
    `
    INSERT INTO formularios_usuario
      (nombre_usuario, nombre, correo, password, activo, acceso_web, is_staff, is_superuser, last_login)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8, NOW())
    ON CONFLICT (nombre_usuario) DO UPDATE SET
      password = EXCLUDED.password,
      nombre   = EXCLUDED.nombre,
      correo   = EXCLUDED.correo,
      activo   = EXCLUDED.activo,
      acceso_web = EXCLUDED.acceso_web,
      is_staff   = EXCLUDED.is_staff,
      is_superuser = EXCLUDED.is_superuser,
      last_login = NOW()
    `,
    [
      nombreUsuario,
      nombre,
      correo,
      hash,
      activo,
      accesoWeb,
      isStaff,
      isSuperuser,
    ],
  );
}

/** Asigna un usuario a un formulario privado (tabla puente). */
export async function linkUsuarioAFormulario(
  ds: DataSource,
  formId: string,
  nombreUsuarioId: string, // si la FK es el nombre de usuario; usa el tipo correcto si es UUID
): Promise<void> {
  await ds.query('BEGIN');
  try {
    await ds.query(`SET LOCAL session_replication_role = 'replica'`);
    await ds.query(
      `
      INSERT INTO formularios_user_formulario (id_formulario_id, id_usuario_id)
      SELECT $1, $2
      WHERE NOT EXISTS (
        SELECT 1 FROM formularios_user_formulario
        WHERE id_formulario_id = $1 AND id_usuario_id = $2
      )
      `,
      [formId, nombreUsuarioId],
    );
    await ds.query('COMMIT');
  } catch (e) {
    await ds.query('ROLLBACK');
    throw e;
  }
}

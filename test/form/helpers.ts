/* eslint-disable @typescript-eslint/no-unsafe-argument */
/* eslint-disable @typescript-eslint/no-unsafe-call */
import { INestApplication, ValidationPipe } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import request from 'supertest';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule, getRepositoryToken } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import {
  PostgreSqlContainer,
  StartedPostgreSqlContainer,
} from '@testcontainers/postgresql';
import * as argon2 from 'argon2';
import { readFileSync } from 'node:fs';
import { join } from 'node:path';

import { typeOrmAsyncConfig } from '../../src/config/typeorm.config';
import { AuthModule } from '../../src/auth/auth.module';
import { FormsModule } from '../../src/forms/forms.module';
import { GroupsModule } from '../../src/groups/groups.module';
import { Usuario } from '../../src/auth/entities/formularios-usuario.entity';

export type TestCtx = {
  app: INestApplication;
  moduleRef: TestingModule;
  ds: DataSource;
  jwt: JwtService;
  http: ReturnType<typeof request>;
  userRepo: Repository<Usuario>;
  container: StartedPostgreSqlContainer;
};

// ───────────────────────────────────────────────────────────────────────────────
//  Normalizador de SQL (esperamos SOLO DML en los fixtures)
// ───────────────────────────────────────────────────────────────────────────────
function normalizeSql(raw: string): string {
  // Elimina bloques "ALTER TABLE ... OWNER TO ...;"
  const noOwnerStmt = raw.replace(
    /ALTER\s+TABLE\s+[\s\S]*?OWNER\s+TO\s+[^\n;]+;/gi,
    '',
  );

  // Elimina líneas sueltas con "OWNER TO"
  return noOwnerStmt
    .split(/\r?\n/)
    .filter((ln) => !/\bOWNER\s+TO\b/i.test(ln))
    .join('\n');
}

export async function setupAppAndDb(): Promise<TestCtx> {
  process.env.JWT_SECRET ??= 'e2e_test_secret';
  process.env.JWT_EXPIRES_IN ??= '300s';
  process.env.TESTCONTAINERS_HOST_OVERRIDE ??= '127.0.0.1';

  // Dejamos que TypeORM cree el esquema desde las entities
  process.env.DB_SYNC = 'true';
  process.env.DB_DROP_SCHEMA = 'true';
  process.env.DB_LOGGING = 'false';
  process.env.NODE_ENV = 'test';

  const container = await new PostgreSqlContainer('postgres:16-alpine')
    .withDatabase('e2e_forms')
    .withUsername('test')
    .withPassword('test')
    .start();

  process.env.PG_HOST = container.getHost();
  process.env.PG_PORT = String(container.getPort());
  process.env.PG_USER = container.getUsername();
  process.env.PG_PASS = container.getPassword();
  process.env.PG_DB = container.getDatabase();
  process.env.PG_SSL = 'false';
  delete process.env.DATABASE_URL;

  const moduleRef = await Test.createTestingModule({
    imports: [
      ConfigModule.forRoot({ isGlobal: true }),
      TypeOrmModule.forRootAsync(typeOrmAsyncConfig),
      AuthModule,
      FormsModule,
      GroupsModule,
    ],
  }).compile();

  const app = moduleRef.createNestApplication();
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );
  await app.init();

  const ds = app.get(DataSource);
  const jwt = app.get(JwtService);
  const userRepo = app.get<Repository<Usuario>>(getRepositoryToken(Usuario));
  const http = request(app.getHttpServer());

  return { app, moduleRef, ds, jwt, http, userRepo, container };
}

export async function teardown(ctx: TestCtx) {
  await ctx.app?.close();
  await ctx.container?.stop();
}

// ========= Helpers deterministas =========

export async function seedUser(
  ctx: TestCtx,
  {
    nombreUsuario,
    password,
    nombre = 'Usuario E2E',
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
) {
  const hash = await argon2.hash(password, { type: argon2.argon2id });
  await ctx.userRepo.save(
    ctx.userRepo.create({
      nombreUsuario,
      nombre,
      correo,
      password: hash,
      activo,
      accesoWeb,
      isStaff,
      isSuperuser,
      lastLogin: new Date(),
    }),
  );
}

export async function loginAndGetToken(
  ctx: TestCtx,
  nombre_usuario: string,
  password: string,
): Promise<string> {
  const res = await ctx.http
    .post('/auth/login')
    .send({ nombre_usuario, password });
  if (res.status !== 200) throw new Error(`Login failed: ${res.status}`);
  const b = res.body as { accessToken?: string; access_token?: string };
  return (b.accessToken ?? b.access_token) as string;
}

/** Asigna un usuario a un formulario privado (tabla puente). */
export async function linkUserToForm(
  ctx: TestCtx,
  formId: string,
  nombreUsuario: string,
): Promise<void> {
  // Deshabilitamos constraints SOLO dentro de la tx y evitamos duplicados sin ON CONFLICT
  await ctx.ds.query('BEGIN');
  try {
    await ctx.ds.query(`SET LOCAL session_replication_role = 'replica'`);
    await ctx.ds.query(
      `
      INSERT INTO formularios_user_formulario (id_formulario_id, id_usuario_id)
      SELECT $1, $2
      WHERE NOT EXISTS (
        SELECT 1 FROM formularios_user_formulario
        WHERE id_formulario_id = $1 AND id_usuario_id = $2
      )
      `,
      [formId, nombreUsuario],
    );
    await ctx.ds.query('COMMIT');
  } catch (e) {
    await ctx.ds.query('ROLLBACK');
    throw e;
  }
}

// ───────────────────────────────────────────────────────────────────────────────
/** Ejecuta un archivo .sql pero **solo** corre statements DML (INSERT/UPDATE). */
async function execSqlDataOnly(ds: DataSource, fileName: string) {
  const p = join(__dirname, '..', 'fixtures', fileName);
  const raw = readFileSync(p, 'utf8');
  const sql = normalizeSql(raw);

  const stmts = sql
    .split(/;\s*[\r\n]+/g)
    .map((s) => s.trim())
    .filter((s) => s.length > 0);

  for (let i = 0; i < stmts.length; i++) {
    const s = stmts[i];

    // Solo DML
    if (!/^(insert|update)\s+/i.test(s)) continue;

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
 * Carga TODOS los .sql de /test/fixtures en orden, **solo DML**.
 * Durante la carga se deshabilitan FKs con `session_replication_role = 'replica'`.
 * Las tablas/constraints las crea TypeORM (DB_SYNC=true).
 */
export async function loadAllDbFixtures(ds: DataSource, files?: string[]) {
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
      await execSqlDataOnly(ds, f);
    }
    await ds.query('COMMIT');
  } catch (e) {
    await ds.query('ROLLBACK');
    throw e;
  }
}

/** Ejecuta un único fixture .sql **solo DML** (compat con tests antiguos). */
export async function loadSqlFixture(ds: DataSource, name: string) {
  await ds.query('BEGIN');
  try {
    await ds.query(`SET LOCAL session_replication_role = 'replica'`);
    await execSqlDataOnly(ds, `${name}.sql`);
    await ds.query('COMMIT');
  } catch (e) {
    await ds.query('ROLLBACK');
    throw e;
  }
}

/* eslint-disable @typescript-eslint/no-unsafe-argument */
/* eslint-disable @typescript-eslint/no-unsafe-call */
// test/auth/auth.login.e2e-spec.ts
import { INestApplication, ValidationPipe } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import request, { type Response as SupertestResponse } from 'supertest';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule, getRepositoryToken } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';

import { AuthModule } from '../../src/auth/auth.module';
import { Usuario } from '../../src/auth/entities/formularios-usuario.entity';
import { typeOrmAsyncConfig } from '../../src/config/typeorm.config';

import {
  PostgreSqlContainer,
  StartedPostgreSqlContainer,
} from '@testcontainers/postgresql';
import * as argon2 from 'argon2';

// ⬇️ aumenta el timeout del archivo (5 min)
jest.setTimeout(300_000);

// ── Tipos & helpers seguros ──────────────────────────
type LoginDto = { nombre_usuario: string; password: string };

const getAccessToken = (b: unknown): string | undefined => {
  if (typeof b === 'object' && b !== null) {
    const o = b as { accessToken?: unknown; access_token?: unknown };
    if (typeof o.accessToken === 'string') return o.accessToken;
    if (typeof o.access_token === 'string') return o.access_token;
  }
  return undefined;
};

describe('[E2E] /auth/login', () => {
  let app: INestApplication;
  let moduleRef: TestingModule;
  let ds: DataSource;
  let userRepo: Repository<Usuario>;
  let container: StartedPostgreSqlContainer;

  const TEST_USER = {
    nombreUsuario: 'daniel',
    password: 'P@ssw0rd!',
    activo: true,
  };
  const INACTIVE_USER = {
    nombreUsuario: 'maria',
    password: 'Secret.123',
    activo: false,
  };

  const login = (body: LoginDto) =>
    request(app.getHttpServer()).post('/auth/login').send(body);

  beforeAll(async () => {
    // JWT para pruebas
    process.env.JWT_SECRET ??= 'e2e_test_secret';
    process.env.JWT_EXPIRES_IN ??= '300s';

    // Windows/Docker Desktop
    process.env.TESTCONTAINERS_HOST_OVERRIDE ??= '127.0.0.1';

    // 1) Levantar Postgres efímero
    container = await new PostgreSqlContainer('postgres:16-alpine')
      .withDatabase('e2e_auth')
      .withUsername('test')
      .withPassword('test')
      .withReuse()
      .start();

    // 2) Envs que tu config lee (sin SSL en local)
    process.env.PG_HOST = container.getHost();
    process.env.PG_PORT = String(container.getPort());
    process.env.PG_USER = container.getUsername();
    process.env.PG_PASS = container.getPassword();
    process.env.PG_DB = container.getDatabase();
    process.env.PG_SSL = 'false';
    delete process.env.DATABASE_URL;

    // 👇 Forzar creación/drop de esquema SOLO en E2E
    process.env.DB_SYNC = 'true';
    process.env.DB_DROP_SCHEMA = 'true';
    process.env.DB_LOGGING = 'false';
    process.env.NODE_ENV = 'test';

    // 3) Usar tu config real de TypeORM
    moduleRef = await Test.createTestingModule({
      imports: [
        ConfigModule.forRoot({ isGlobal: true }),
        TypeOrmModule.forRootAsync(typeOrmAsyncConfig),
        AuthModule,
      ],
    }).compile();

    app = moduleRef.createNestApplication();
    app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true,
        forbidNonWhitelisted: true,
        transform: true,
      }),
    );
    await app.init();

    ds = app.get(DataSource);
    userRepo = app.get<Repository<Usuario>>(getRepositoryToken(Usuario));

    // seed usuarios — incluir TODOS los NOT NULL
    const hash1 = await argon2.hash(TEST_USER.password, {
      type: argon2.argon2id,
    });
    await userRepo.save(
      userRepo.create({
        nombreUsuario: TEST_USER.nombreUsuario,
        nombre: 'Daniel E2E',
        correo: 'daniel.e2e@local.test',
        password: hash1,
        activo: true,
        accesoWeb: true,
        isStaff: false,
        isSuperuser: false,
        lastLogin: new Date(),
      }),
    );

    const hash2 = await argon2.hash(INACTIVE_USER.password, {
      type: argon2.argon2id,
    });
    await userRepo.save(
      userRepo.create({
        nombreUsuario: INACTIVE_USER.nombreUsuario,
        nombre: 'Maria Inactiva',
        correo: 'maria.inactiva.e2e@local.test',
        password: hash2,
        activo: false, // 👈 este test valida "usuario inactivo"
        accesoWeb: true, // puede quedarse en true; bloquea por "activo"
        isStaff: false,
        isSuperuser: false,
        lastLogin: new Date(),
      }),
    );
  });

  afterAll(async () => {
    await ds?.destroy(); // evita handles abiertos
    await app?.close();
    await container?.stop();
  });

  it('200 OK → devuelve access token y (opcional) usuario (happy path)', async () => {
    const res: SupertestResponse = await login({
      nombre_usuario: TEST_USER.nombreUsuario,
      password: TEST_USER.password,
    });

    expect(res.status).toBe(200);

    const accessToken = getAccessToken(res.body);
    expect(typeof accessToken).toBe('string');
    expect((accessToken ?? '').length).toBeGreaterThan(20);

    // Si devolvés info del usuario junto al login
    const rawBody: unknown = res.body;
    if (typeof rawBody === 'object' && rawBody !== null) {
      const rb = rawBody as Record<string, unknown>;
      const userObj = rb.user ?? rb.usuario;
      if (typeof userObj === 'object' && userObj !== null) {
        const u = userObj as Record<string, unknown>;
        const nombre =
          (typeof u.nombreUsuario === 'string' && u.nombreUsuario) ||
          (typeof u.username === 'string' && u.username) ||
          (typeof u.nombre_usuario === 'string' && u.nombre_usuario) ||
          undefined;
        if (nombre) expect(nombre).toBe(TEST_USER.nombreUsuario);
      }
    }

    // Verificar decodificación del token
    const jwt = app.get(JwtService);
    const decoded = accessToken ? jwt.decode(accessToken) : null;
    expect(decoded).toBeTruthy();
    if (decoded && typeof decoded === 'object') {
      expect(
        'sub' in decoded || 'nombreUsuario' in decoded || 'username' in decoded,
      ).toBe(true);
    }
  });

  it('401 Unauthorized → password incorrecto', async () => {
    const res: SupertestResponse = await login({
      nombre_usuario: TEST_USER.nombreUsuario,
      password: 'malaClave!!',
    });
    expect(res.status).toBe(401);

    const rawBody: unknown = res.body;
    if (typeof rawBody === 'object' && rawBody !== null) {
      const rb = rawBody as Record<string, unknown>;
      const msg = rb.message;
      if (typeof msg === 'string') {
        expect(msg).toMatch(/inválidas|invalid/i);
      }
      if (Array.isArray(msg)) {
        expect(msg.join(' ')).toMatch(/inválidas|invalid/i);
      }
    }
  });

  it('401 Unauthorized → usuario inexistente', async () => {
    const res: SupertestResponse = await login({
      nombre_usuario: 'no_existe',
      password: 'loquesea123',
    });
    expect(res.status).toBe(401);
  });

  it('401 Unauthorized → usuario inactivo', async () => {
    const res: SupertestResponse = await login({
      nombre_usuario: INACTIVE_USER.nombreUsuario,
      password: INACTIVE_USER.password,
    });
    expect(res.status).toBe(401);

    const rawBody: unknown = res.body;
    if (typeof rawBody === 'object' && rawBody !== null) {
      const rb = rawBody as Record<string, unknown>;
      const msg = rb.message;
      if (typeof msg === 'string') {
        expect(msg).toMatch(/inactivo|acceso web/i);
      }
      if (Array.isArray(msg)) {
        expect(msg.join(' ')).toMatch(/inactivo|acceso web/i);
      }
    }
  });

  it('400 Bad Request → validación DTO (faltan campos)', async () => {
    // falta password (string vacío no debe pasar)
    const res: SupertestResponse = await login({
      nombre_usuario: TEST_USER.nombreUsuario,
      password: '',
    });
    expect(res.status).toBe(400);
  });

  it('400 Bad Request → validación DTO (campo extra no permitido)', async () => {
    const res: SupertestResponse = await login({
      nombre_usuario: TEST_USER.nombreUsuario,
      password: TEST_USER.password,
      extra: 'no_debería_estar',
    } as unknown as LoginDto);
    expect(res.status).toBe(400);
  });
});

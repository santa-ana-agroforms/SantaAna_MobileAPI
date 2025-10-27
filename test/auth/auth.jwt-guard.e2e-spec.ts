/* eslint-disable @typescript-eslint/no-unsafe-argument */
/* eslint-disable @typescript-eslint/no-unsafe-call */
// test/auth/auth.jwt-guard.e2e-spec.ts
import {
  Controller,
  Get,
  INestApplication,
  Req,
  UseGuards,
  ValidationPipe,
} from '@nestjs/common';
import { Test } from '@nestjs/testing';
import request, { type Response as SupertestResponse } from 'supertest';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule, getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import { Request } from 'express';

import { AuthModule } from '../../src/auth/auth.module';
import { JwtAuthGuard } from '../../src/auth/guards/jwt-auth.guard';
import { Usuario } from '../../src/auth/entities/formularios-usuario.entity';
import { typeOrmAsyncConfig } from '../../src/config/typeorm.config';

import {
  PostgreSqlContainer,
  StartedPostgreSqlContainer,
} from '@testcontainers/postgresql';
import * as argon2 from 'argon2';

// ── Tipos mínimos para req.user y bodies ──────────────────────────
interface JwtPayloadUser {
  sub?: string;
  nombreUsuario?: string;
  username?: string;
  [k: string]: unknown;
}
type AuthRequest = Request & { user?: JwtPayloadUser };

type LoginDto = { nombre_usuario: string; password: string };
type ProtectedBody = { ok: boolean; user?: unknown };

// Helpers seguros
const getAccessToken = (b: unknown): string | undefined => {
  if (typeof b === 'object' && b !== null) {
    const o = b as { accessToken?: unknown; access_token?: unknown };
    if (typeof o.accessToken === 'string') return o.accessToken;
    if (typeof o.access_token === 'string') return o.access_token;
  }
  return undefined;
};

// Controlador **solo para pruebas** con guard JWT
@Controller('e2e-protected')
class ProtectedTestController {
  @UseGuards(JwtAuthGuard)
  @Get()
  getProtected(@Req() req: AuthRequest) {
    return { ok: true, user: req.user };
  }
}

describe('[E2E] JwtAuthGuard', () => {
  let app: INestApplication;
  let userRepo: Repository<Usuario>;
  let container: StartedPostgreSqlContainer;

  const TEST_USER = {
    nombreUsuario: 'guard_tester',
    password: 'S3gura.Clave',
  };

  // ⬇️ subimos timeout para la primera corrida (pull de imágenes, etc.)
  jest.setTimeout(300_000);

  const http = () => request(app.getHttpServer());
  const login = (body: LoginDto) => http().post('/auth/login').send(body);

  beforeAll(async () => {
    // JWT para pruebas
    process.env.JWT_SECRET ??= 'e2e_test_secret';
    process.env.JWT_EXPIRES_IN ??= '300s';

    // Windows/Docker Desktop: ayuda a resolver puertos/host
    process.env.TESTCONTAINERS_HOST_OVERRIDE ??= '127.0.0.1';

    // 1) Levantar Postgres efímero
    container = await new PostgreSqlContainer('postgres:16-alpine')
      .withDatabase('e2e_auth_guard')
      .withUsername('test')
      .withPassword('test')
      .start();

    // 2) Envs que tu config lee (y desactivar SSL en local)
    process.env.PG_HOST = container.getHost();
    process.env.PG_PORT = String(container.getPort());
    process.env.PG_USER = container.getUsername();
    process.env.PG_PASS = container.getPassword();
    process.env.PG_DB = container.getDatabase();
    process.env.PG_SSL = 'false';
    delete process.env.DATABASE_URL; // evitar que tenga prioridad

    // 👇 Forzamos a que la config de la app cree/dropee el esquema SOLO en E2E
    process.env.DB_SYNC = 'true';
    process.env.DB_DROP_SCHEMA = 'true';
    process.env.DB_LOGGING = 'false';
    process.env.NODE_ENV = 'test';

    const moduleRef = await Test.createTestingModule({
      imports: [
        ConfigModule.forRoot({ isGlobal: true }),
        TypeOrmModule.forRootAsync(typeOrmAsyncConfig), // 👈 reutiliza TU config real
        AuthModule,
      ],
      controllers: [ProtectedTestController], // ruta protegida de prueba
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

    userRepo = app.get<Repository<Usuario>>(getRepositoryToken(Usuario));

    // Seed user — incluir TODOS los NOT NULL de la tabla
    const hash = await argon2.hash(TEST_USER.password, {
      type: argon2.argon2id,
    });
    await userRepo.save(
      userRepo.create({
        nombreUsuario: TEST_USER.nombreUsuario,
        nombre: 'Guard Tester',
        correo: 'guard.tester+e2e@local.test',
        password: hash,
        activo: true,
        accesoWeb: true,
        isStaff: false,
        isSuperuser: false,
        lastLogin: new Date(),
      }),
    );
  });

  afterAll(async () => {
    await app?.close();
    await container?.stop();
  });

  it('401 sin Authorization header', async () => {
    const res: SupertestResponse = await http().get('/e2e-protected');
    expect(res.status).toBe(401);
  });

  it('401 con token inválido', async () => {
    const res: SupertestResponse = await http()
      .get('/e2e-protected')
      .set('Authorization', 'Bearer token_invalido');
    expect(res.status).toBe(401);
  });

  it('200 con token válido; req.user presente', async () => {
    const loginRes: SupertestResponse = await login({
      nombre_usuario: TEST_USER.nombreUsuario,
      password: TEST_USER.password,
    });
    expect(loginRes.status).toBe(200);

    const token = getAccessToken(loginRes.body) ?? '';

    const res: SupertestResponse = await http()
      .get('/e2e-protected')
      .set('Authorization', `Bearer ${token}`);

    // Narrowing del body (unknown→ProtectedBody) sin `any`
    const rawBody: unknown = res.body;
    expect(res.status).toBe(200);
    if (typeof rawBody === 'object' && rawBody !== null && 'ok' in rawBody) {
      const body = rawBody as ProtectedBody;
      expect(body.ok).toBe(true);
      expect(body.user).toBeTruthy();
    } else {
      throw new Error('Respuesta inesperada del endpoint protegido');
    }

    // `decode()` devuelve object|string|null → narrow antes de usar
    const jwt = app.get(JwtService);
    const decoded = token ? jwt.decode(token) : null;
    expect(decoded).not.toBeNull();
    if (decoded && typeof decoded === 'object') {
      expect(Object.keys(decoded).length).toBeGreaterThan(0);
    }
  });
});

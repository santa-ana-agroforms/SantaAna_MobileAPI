/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
import { Test, TestingModule } from '@nestjs/testing';
import {
  BadRequestException,
  ForbiddenException,
  UnauthorizedException,
} from '@nestjs/common';
import { getRepositoryToken } from '@nestjs/typeorm';
import { DataSource, Repository, ObjectLiteral } from 'typeorm';
import { createHmac } from 'crypto';

import { AuthQrService } from './auth-qr.service';
import { Usuario } from '../entities/formularios-usuario.entity';
import { UsuarioGroup } from '../entities/formularios-usuario-groups.entity';
import { AuthService } from '../auth.service';
import type { AuthUser, LoginResult } from '../types/auth.types';
import { UserTerminal } from '../entities';

type MockRepo<T extends ObjectLiteral = any> = Partial<
  Record<keyof Repository<T>, jest.Mock>
> & {
  findOne?: jest.Mock;
  find?: jest.Mock;
};

const repoMock = <T extends ObjectLiteral = any>(): MockRepo<T> => ({
  findOne: jest.fn(),
  find: jest.fn(),
});

describe('AuthQrService (unit)', () => {
  let svc: AuthQrService;

  let usersRepo: MockRepo<Usuario>;
  let userGroupsRepo: MockRepo<UsuarioGroup>;
  let terminalsRepo: MockRepo<UserTerminal>;
  let ds: { query: jest.Mock };
  let authService: {
    me: jest.Mock;
    login: jest.Mock;
  };

  const originalEnv = { ...process.env };

  beforeEach(async () => {
    process.env.QR_SECRET = 'qr-test-secret';
    process.env.AUTH_QR_TTL_MS = '3600000'; // 1h por defecto en tests

    usersRepo = repoMock<Usuario>();
    userGroupsRepo = repoMock<UsuarioGroup>();
    terminalsRepo = repoMock<UserTerminal>();
    ds = {
      query: jest.fn().mockResolvedValue([
        { id: 1, name: 'Admin' },
        { id: 2, name: 'Mobile' },
      ]),
    };
    authService = {
      me: jest.fn(),
      login: jest.fn(),
    };

    const moduleRef: TestingModule = await Test.createTestingModule({
      providers: [
        AuthQrService,
        { provide: getRepositoryToken(Usuario), useValue: usersRepo },
        { provide: getRepositoryToken(UsuarioGroup), useValue: userGroupsRepo },
        { provide: getRepositoryToken(UserTerminal), useValue: terminalsRepo },
        { provide: DataSource, useValue: ds },
        { provide: AuthService, useValue: authService },
      ],
    }).compile();

    svc = moduleRef.get(AuthQrService);

    // Evitar generar PNG real: sustituimos el método privado
    (svc as any).makeQrDataUrl = jest
      .fn()
      .mockResolvedValue('data:image/png;base64,FAKE');
  });

  afterEach(() => {
    jest.restoreAllMocks();
    process.env = { ...originalEnv };
  });

  const makeAuthUser = (username: string): AuthUser => ({
    nombre_usuario: username,
    nombre: 'Test User',
    correo: `${username}@acme.test`,
    activo: true,
    acceso_web: true,
    is_staff: false,
    is_superuser: false,
    groups: [],
    permissions: [],
  });

  const makeLoginResult = (username: string): LoginResult => ({
    access_token: 'jwt.fake.token',
    token_type: 'Bearer',
    expires_in: 3600,
    user: makeAuthUser(username),
  });

  it('startForUser → crea sesión y login() devuelve token + roles; status pasa a "claimed"', async () => {
    usersRepo.findOne!.mockResolvedValue({
      nombreUsuario: 'alice',
      activo: true,
      accesoWeb: true,
    });

    const { sid, qr, expiresIn } = await svc.startForUser('alice');
    expect(typeof sid).toBe('string');
    expect(qr).toBe('data:image/png;base64,FAKE');
    expect(expiresIn).toBeGreaterThan(0);
    expect((svc as any).makeQrDataUrl).toHaveBeenCalledTimes(1);

    // tomamos el nonce desde el payload pasado al QR
    const payloadArg: string = (svc as any).makeQrDataUrl.mock.calls[0][0];
    const parsed = JSON.parse(payloadArg) as {
      sid: string;
      nonce: string;
      sig: string;
      v: number;
    };
    expect(parsed.sid).toBe(sid);
    expect(parsed.v).toBe(1);

    const secret = process.env.QR_SECRET!;
    const sig = createHmac('sha256', secret)
      .update(`${sid}.${parsed.nonce}`)
      .digest('hex');

    authService.me.mockResolvedValue(makeAuthUser('alice'));
    authService.login.mockResolvedValue(makeLoginResult('alice'));

    const res = await svc.login(sid, parsed.nonce, sig);
    expect(res.access_token).toBe('jwt.fake.token');
    expect(res.user.nombre_usuario).toBe('alice');
    expect(Array.isArray(res.user.roles)).toBe(true);
    expect(res.user.roles).toHaveLength(2);

    const st = svc.status(sid);
    expect(st).toEqual({ status: 'claimed' });
  });

  it('startForUser → lanza BadRequest si el usuario destino no existe', async () => {
    usersRepo.findOne!.mockResolvedValue(null);
    await expect(svc.startForUser('ghost')).rejects.toBeInstanceOf(
      BadRequestException,
    );
  });

  it('login → firma inválida produce Unauthorized', async () => {
    usersRepo.findOne!.mockResolvedValue({
      nombreUsuario: 'bob',
      activo: true,
      accesoWeb: true,
    });

    const { sid } = await svc.startForUser('bob');
    const payloadArg: string = (svc as any).makeQrDataUrl.mock.calls[0][0];
    const parsed = JSON.parse(payloadArg) as { nonce: string };

    // firma incorrecta
    const badSig = 'deadbeef';
    await expect(svc.login(sid, parsed.nonce, badSig)).rejects.toBeInstanceOf(
      UnauthorizedException,
    );
  });

  it('login → sesión expirada', async () => {
    usersRepo.findOne!.mockResolvedValue({
      nombreUsuario: 'carl',
      activo: true,
      accesoWeb: true,
    });

    // Hacemos la TTL bien corta
    process.env.AUTH_QR_TTL_MS = '1';
    const { sid } = await svc.startForUser('carl');

    const payloadArg: string = (svc as any).makeQrDataUrl.mock.calls[0][0];
    const parsed = JSON.parse(payloadArg) as { nonce: string };

    // Esperar a que expire
    await new Promise((r) => setTimeout(r, 5));

    const secret = process.env.QR_SECRET!;
    const sig = createHmac('sha256', secret)
      .update(`${sid}.${parsed.nonce}`)
      .digest('hex');

    await expect(svc.login(sid, parsed.nonce, sig)).rejects.toBeInstanceOf(
      BadRequestException,
    );
    expect(svc.status(sid)).toEqual({ status: 'expired' });
  });

  it('startForUser → usuario inactivo lanza Forbidden', async () => {
    usersRepo.findOne!.mockResolvedValue({
      nombreUsuario: 'dave',
      activo: false,
      accesoWeb: true,
    });
    await expect(svc.startForUser('dave')).rejects.toBeInstanceOf(
      ForbiddenException,
    );
  });
});

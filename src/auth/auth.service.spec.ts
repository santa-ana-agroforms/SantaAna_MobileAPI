/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-return */
import { Test, TestingModule } from '@nestjs/testing';
import { UnauthorizedException } from '@nestjs/common';
import { getRepositoryToken } from '@nestjs/typeorm';
import { JwtService } from '@nestjs/jwt';

import { AuthService } from './auth.service';
import { Usuario } from './entities/formularios-usuario.entity';
import { UsuarioGroup } from './entities/formularios-usuario-groups.entity';
import { UsuarioUserPermission } from './entities/formularios-usuario-user-permissions.entity';

// Mock explícito del util de Argon2 (NO usamos hash real en unit tests)
jest.mock('./crypto/argon2.util', () => ({
  verifyPassword: jest.fn(),
}));
import * as argon2Util from './crypto/argon2.util';
import { UserTerminal } from './entities';

type RepoMock<T = any> = {
  findOne: jest.Mock<Promise<T | null>, any>;
  find: jest.Mock<Promise<T[]>, any>;
};

const repoMock = <T = any>(): RepoMock<T> =>
  ({
    findOne: jest.fn(),
    find: jest.fn(),
  }) as any;

describe('AuthService (unit)', () => {
  let service: AuthService;
  let usersRepo: RepoMock<Usuario>;
  let groupsRepo: RepoMock<UsuarioGroup>;
  let permsRepo: RepoMock<UsuarioUserPermission>;
  let terminalsRepo: RepoMock<UserTerminal>;
  let jwt: { signAsync: jest.Mock<Promise<string>, any> };

  const USERNAME = 'dahernandez';
  const RAW_PWD = 'secret';
  const PHC = '$argon2id$valid$phc$string'; // solo formato; NO se verifica realmente

  const baseEntity: Usuario = {
    nombreUsuario: USERNAME,
    nombre: 'Diego',
    correo: 'dahernandez@local.test',
    password: PHC,
    activo: true,
    accesoWeb: true,
    isStaff: false,
    isSuperuser: false,
    lastLogin: new Date(),
  } as any;

  const groupsRows: UsuarioGroup[] = [
    { usuarioId: USERNAME, groupId: 'g1' } as any,
    { usuarioId: USERNAME, groupId: 'g2' } as any,
  ];
  const permsRows: UsuarioUserPermission[] = [
    { usuarioId: USERNAME, permissionId: 'perm.read' } as any,
  ];

  const OLD_ENV = process.env;

  beforeEach(async () => {
    jest.resetAllMocks();
    process.env = { ...OLD_ENV, JWT_EXPIRES_IN_SECONDS: '1234' };

    usersRepo = repoMock<Usuario>();
    groupsRepo = repoMock<UsuarioGroup>();
    permsRepo = repoMock<UsuarioUserPermission>();
    terminalsRepo = repoMock<UserTerminal>();
    jwt = { signAsync: jest.fn().mockResolvedValue('signed.jwt.token') };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        { provide: getRepositoryToken(Usuario), useValue: usersRepo },
        { provide: getRepositoryToken(UsuarioGroup), useValue: groupsRepo },
        {
          provide: getRepositoryToken(UsuarioUserPermission),
          useValue: permsRepo,
        },
        { provide: getRepositoryToken(UserTerminal), useValue: terminalsRepo },
        { provide: JwtService, useValue: jwt },
      ],
    }).compile();

    service = module.get(AuthService);
  });

  afterEach(() => {
    process.env = OLD_ENV;
  });

  // ─────────────────────────────────────────────────────────────
  // validateUser
  // ─────────────────────────────────────────────────────────────

  it('validateUser → OK con usuario activo y contraseña válida', async () => {
    usersRepo.findOne.mockResolvedValue(baseEntity);
    groupsRepo.find.mockResolvedValue(groupsRows);
    permsRepo.find.mockResolvedValue(permsRows);
    terminalsRepo.find.mockResolvedValue([]);

    (argon2Util.verifyPassword as jest.Mock).mockResolvedValue(true);

    const user = await service.validateUser(USERNAME, RAW_PWD);

    expect(usersRepo.findOne).toHaveBeenCalledWith({
      where: { nombreUsuario: USERNAME },
    });
    expect(argon2Util.verifyPassword).toHaveBeenCalledWith(PHC, RAW_PWD);

    expect(user).toMatchObject({
      nombre_usuario: USERNAME,
      nombre: 'Diego',
      correo: 'dahernandez@local.test',
      activo: true,
      acceso_web: true,
      is_staff: false,
      is_superuser: false,
      groups: ['g1', 'g2'],
      permissions: ['perm.read'],
    });
  });

  it('validateUser → lanza si el usuario no existe', async () => {
    usersRepo.findOne.mockResolvedValue(null);

    await expect(service.validateUser(USERNAME, RAW_PWD)).rejects.toThrow(
      UnauthorizedException,
    );
  });

  it('validateUser → lanza si el usuario está inactivo', async () => {
    usersRepo.findOne.mockResolvedValue({ ...baseEntity, activo: false });

    await expect(service.validateUser(USERNAME, RAW_PWD)).rejects.toThrow(
      UnauthorizedException,
    );
  });

  it('validateUser → lanza si el password no es Argon2 PHC o no verifica', async () => {
    // Caso A: formato NO PHC ⇒ no llama verifyPassword y falla
    usersRepo.findOne.mockResolvedValue({ ...baseEntity, password: 'plain' });
    await expect(service.validateUser(USERNAME, RAW_PWD)).rejects.toThrow(
      UnauthorizedException,
    );
    expect(argon2Util.verifyPassword).not.toHaveBeenCalled();

    // Caso B: formato PHC pero verify false
    usersRepo.findOne.mockResolvedValue({ ...baseEntity, password: PHC });
    (argon2Util.verifyPassword as jest.Mock).mockResolvedValue(false);
    await expect(service.validateUser(USERNAME, RAW_PWD)).rejects.toThrow(
      UnauthorizedException,
    );
  });

  // ─────────────────────────────────────────────────────────────
  // login overloads
  // ─────────────────────────────────────────────────────────────

  it('login(username, password) → emite token y regresa payload esperado', async () => {
    usersRepo.findOne.mockResolvedValue(baseEntity);
    groupsRepo.find.mockResolvedValue(groupsRows);
    permsRepo.find.mockResolvedValue(permsRows);
    (argon2Util.verifyPassword as jest.Mock).mockResolvedValue(true);

    const out = await service.login(USERNAME, RAW_PWD);

    expect(jwt.signAsync).toHaveBeenCalledTimes(1);
    expect(out).toMatchObject({
      access_token: 'signed.jwt.token',
      token_type: 'Bearer',
      expires_in: 1234,
      user: expect.objectContaining({ nombre_usuario: USERNAME }),
    });
  });

  it('login(user) → usa issueToken y respeta expires_in del env', async () => {
    const authUser = {
      nombre_usuario: USERNAME,
      nombre: 'Diego',
      correo: 'dahernandez@local.test',
      activo: true,
      acceso_web: true,
      is_staff: false,
      is_superuser: false,
      groups: [],
      permissions: [],
    };

    // eslint-disable-next-line @typescript-eslint/no-unsafe-argument
    const out = await service.login(authUser as any);
    expect(jwt.signAsync).toHaveBeenCalledTimes(1);
    expect(out.expires_in).toBe(1234);
  });

  // ─────────────────────────────────────────────────────────────
  // me / hydrate
  // ─────────────────────────────────────────────────────────────

  it('me(nombreUsuario) → hidrata usuario con grupos/permisos', async () => {
    usersRepo.findOne.mockResolvedValue(baseEntity);
    groupsRepo.find.mockResolvedValue(groupsRows);
    permsRepo.find.mockResolvedValue(permsRows);

    const u = await service.me(USERNAME);
    expect(u.nombre_usuario).toBe(USERNAME);
    expect(u.groups).toEqual(['g1', 'g2']);
    expect(u.permissions).toEqual(['perm.read']);
  });

  it('me(nombreUsuario) → lanza si no existe', async () => {
    usersRepo.findOne.mockResolvedValue(null);
    await expect(service.me(USERNAME)).rejects.toThrow(UnauthorizedException);
  });
});

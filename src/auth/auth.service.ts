import { Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';

import { Usuario } from './entities/formularios-usuario.entity';
import { UsuarioGroup } from './entities/formularios-usuario-groups.entity';
import { UsuarioUserPermission } from './entities/formularios-usuario-user-permissions.entity';
import { UserTerminal } from './entities';
import type { AuthUser, JwtPayload, LoginResult } from './types/auth.types';

// Reutilizamos tu util de Argon2 (PHC)
import { verifyPassword as verifyArgon2 } from './crypto/argon2.util';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(Usuario) private readonly usersRepo: Repository<Usuario>,
    @InjectRepository(UsuarioGroup)
    private readonly userGroupsRepo: Repository<UsuarioGroup>,
    @InjectRepository(UsuarioUserPermission)
    private readonly userPermsRepo: Repository<UsuarioUserPermission>,
    @InjectRepository(UserTerminal)
    private readonly userTerminalRepo: Repository<UserTerminal>,
    private readonly jwtService: JwtService,
  ) {}

  // ─────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────
  private static isArgon2PHC(pw: string): boolean {
    // Formato PHC: $argon2id$..., $argon2i$..., $argon2d$...
    return /^\$argon2(id|i|d)\$/.test(pw);
  }

  private static async verifyPassword(
    raw: string,
    stored: string,
  ): Promise<boolean> {
    if (!stored) return false;
    if (!AuthService.isArgon2PHC(stored)) {
      // Estándar único: rechazamos si no es Argon2 PHC
      return false;
    }
    try {
      return await verifyArgon2(stored, raw);
    } catch {
      return false;
    }
  }

  private async hydrateAuthUser(nombreUsuario: string): Promise<AuthUser> {
    const u = await this.usersRepo.findOne({ where: { nombreUsuario } });
    if (!u) throw new UnauthorizedException('Usuario no encontrado');

    const groupsRows = await this.userGroupsRepo.find({
      where: { usuarioId: u.nombreUsuario },
    });
    const permsRows = await this.userPermsRepo.find({
      where: { usuarioId: u.nombreUsuario },
    });

    const groups = groupsRows.map((g) => g.groupId);
    const permissions = permsRows.map((p) => p.permissionId);

    return {
      nombre_usuario: u.nombreUsuario,
      nombre: u.nombre,
      correo: u.correo,
      activo: u.activo,
      acceso_web: u.accesoWeb,
      is_staff: u.isStaff,
      is_superuser: u.isSuperuser,
      groups,
      permissions,
    };
  }

  private async issueToken(user: AuthUser): Promise<LoginResult> {
    const payload: JwtPayload = {
      sub: user.nombre_usuario,
      correo: user.correo,
      is_staff: user.is_staff,
      is_superuser: user.is_superuser,
      groups: user.groups,
    };

    const expiresIn = Number(process.env.JWT_EXPIRES_IN_SECONDS ?? '86400'); // 1 día
    const access_token = await this.jwtService.signAsync(payload, {
      expiresIn,
    });

    return {
      access_token,
      token_type: 'Bearer',
      expires_in: expiresIn,
      user,
    };
  }

  // ─────────────────────────────────────────────
  // API
  // ─────────────────────────────────────────────

  async validateUser(username: string, password: string): Promise<AuthUser> {
    const user = await this.usersRepo.findOne({
      where: { nombreUsuario: username },
    });
    if (!user) throw new UnauthorizedException('Credenciales inválidas');
    if (!user.activo) {
      throw new UnauthorizedException('Usuario inactivo o sin acceso web');
    }
    const ok = await AuthService.verifyPassword(password, user.password);
    if (!ok) throw new UnauthorizedException('Credenciales inválidas');

    return this.hydrateAuthUser(user.nombreUsuario);
  }

  // Overloads: soporta login(user) y login(username, password)
  async login(user: AuthUser): Promise<LoginResult>;
  async login(username: string, password: string): Promise<LoginResult>;
  async login(a: AuthUser | string, b?: string): Promise<LoginResult> {
    if (typeof a === 'string') {
      // (username, password)
      const user: AuthUser = await this.validateUser(a, b ?? '');
      return this.issueToken(user);
    }
    // (user)
    return this.issueToken(a);
  }

  async me(nombreUsuario: string): Promise<AuthUser> {
    return this.hydrateAuthUser(nombreUsuario);
  }

  async addTerminal(data: Record<string, any>, nombreUsuario: string) {
    // Agregar a la tabla terminal, info
    const terminal = this.userTerminalRepo.create({
      nombre_usuario: nombreUsuario,
      terminal_info: data,
    });
    await this.userTerminalRepo.save(terminal);
  }
}

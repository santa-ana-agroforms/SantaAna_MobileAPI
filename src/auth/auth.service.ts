// src/auth/auth.service.ts
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
import { verifyPassword } from './crypto/argon2.util';
import type { JwtPayload } from './types/auth.types';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User) private readonly usersRepo: Repository<User>,
    private readonly jwt: JwtService,
  ) {}

  login = async (nombre_usuario: string, plainPassword: string) => {
    // Busca por username (no por email)
    const user = await this.usersRepo.findOne({
      where: { nombre_usuario },
      relations: { roles: true },
    });
    if (!user) throw new UnauthorizedException('Credenciales inválidas');

    const ok = await verifyPassword(user.contrasena, plainPassword);
    if (!ok) throw new UnauthorizedException('Credenciales inválidas');

    const payload: JwtPayload = {
      username: user.nombre_usuario,
      rolesId: user.roles.map((r) => r.id),
      rolesName: user.roles.map((r) => r.nombre),
    };

    const accessToken = await this.jwt.signAsync(payload, {
      secret: process.env.JWT_SECRET || 'dev-secret',
      algorithm: 'HS384',
      expiresIn: process.env.JWT_EXPIRES_IN || '1h',
    });

    return {
      access_token: accessToken,
      user: {
        nombre: user.nombre,
        nombre_usuario: user.nombre_usuario,
        roles: user.roles.map((r) => ({ id: r.id, nombre: r.nombre })),
      },
    };
  };
}

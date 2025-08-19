// src/auth/strategies/jwt.strategy.ts
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../entities/user.entity';
import type { JwtPayload, AuthUser } from '../types/auth.types';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor(
    @InjectRepository(User) private readonly usersRepo: Repository<User>,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: process.env.JWT_SECRET || 'dev-secret',
      algorithms: ['HS256'],
    });
  }

  async validate(payload: JwtPayload): Promise<AuthUser> {
    // Usamos el sub (id) del token para buscar el user actual y su rol
    const user = await this.usersRepo.findOne({
      where: { nombre_de_usuario: payload.username },
      relations: { rol: true },
    });
    if (!user) throw new UnauthorizedException('Usuario no encontrado');

    return {
      nombre: user.nombre,
      nombre_de_usuario: user.nombre_de_usuario,
      rol: { id: user.rol.id, nombre: user.rol.nombre },
    };
  }
}

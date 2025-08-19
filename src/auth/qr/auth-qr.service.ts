/* eslint-disable @typescript-eslint/require-await */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
// src/auth/qr/auth-qr.service.ts
import {
  Injectable,
  BadRequestException,
  UnauthorizedException,
} from '@nestjs/common';
import { randomBytes, createHmac } from 'crypto';
import { JwtService } from '@nestjs/jwt';
import QRCode from 'qrcode';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../entities/user.entity';

type QrStatus = 'pending' | 'claimed' | 'expired';

type QrSession = {
  sid: string;
  nonce: string;
  expAt: number; // epoch ms
  status: QrStatus;
  targetUsername: string; // ← usuario al que pertenece este QR
  accessToken?: string; // se setea al reclamar (login)
};

const memStore = new Map<string, QrSession>(); // ⛔ En prod: usar Redis con TTL
const now = () => Date.now();
const makeSig = (sid: string, nonce: string, secret: string) =>
  createHmac('sha256', secret).update(`${sid}.${nonce}`).digest('hex');

@Injectable()
export class AuthQrService {
  constructor(
    private readonly jwt: JwtService,
    @InjectRepository(User) private readonly usersRepo: Repository<User>,
  ) {}

  // Admin: genera QR ligado a un username
  startForUser = async (
    targetUsername: string,
  ): Promise<{ sid: string; qr: string; expiresIn: number }> => {
    // Verificar que exista el usuario, para no generar QR inválido
    const user = await this.usersRepo.findOne({
      where: { nombre_de_usuario: targetUsername },
      relations: { rol: true },
      select: ['nombre_de_usuario'], // consulta mínima
    });
    if (!user) throw new BadRequestException('Usuario destino no existe');

    const sid = randomBytes(16).toString('hex');
    const nonce = randomBytes(16).toString('hex');
    const ttlMs = 60_000; // 60s
    const expAt = now() + ttlMs;

    const secret = process.env.QR_SECRET || 'qr-dev-secret';
    const sig = makeSig(sid, nonce, secret);

    // Payload que va dentro del QR (no revela el username)
    const payload = JSON.stringify({ sid, nonce, sig, v: 1 });
    const qr = await QRCode.toDataURL(payload); // data:image/png;base64,...

    memStore.set(sid, { sid, nonce, expAt, status: 'pending', targetUsername });
    return { sid, qr, expiresIn: Math.floor(ttlMs / 1000) };
  };

  // Móvil (no autenticado): reclama el QR y recibe el JWT
  login = async (sid: string, nonce: string, sig: string) => {
    const sess = memStore.get(sid);
    if (!sess) throw new BadRequestException('Sesión inválida');
    if (sess.status !== 'pending')
      throw new BadRequestException('Sesión ya utilizada o no disponible');
    if (sess.expAt < now()) {
      sess.status = 'expired';
      memStore.set(sid, sess);
      throw new BadRequestException('Sesión expirada');
    }

    const secret = process.env.QR_SECRET || 'qr-dev-secret';
    const expected = makeSig(sid, nonce, secret);
    if (expected !== sig || sess.nonce !== nonce)
      throw new UnauthorizedException('Firma inválida');

    // Cargar user y su rol
    const user = await this.usersRepo.findOne({
      where: { nombre_de_usuario: sess.targetUsername },
      relations: { rol: true },
    });
    if (!user) throw new UnauthorizedException('Usuario no encontrado');

    // Tu payload (sin sub): username + rol
    const tokenPayload = {
      username: user.nombre_de_usuario,
      roleId: user.rol.id,
      roleName: user.rol.nombre,
    };

    const accessToken = await this.jwt.signAsync(tokenPayload, {
      secret: process.env.JWT_SECRET || 'dev-secret',
      algorithm: 'HS256',
      expiresIn: process.env.JWT_EXPIRES_IN || '1h',
    });

    sess.status = 'claimed';
    sess.accessToken = accessToken;
    memStore.set(sid, sess);

    return {
      access_token: accessToken,
      user: {
        nombre: user.nombre,
        nombre_de_usuario: user.nombre_de_usuario,
        rol: { id: user.rol.id, nombre: user.rol.nombre },
      },
    };
  };

  // (Opcional) Admin: ver estado
  status = async (sid: string): Promise<{ status: QrStatus }> => {
    const sess = memStore.get(sid);
    if (!sess) return { status: 'expired' };
    if (sess.expAt < now() && sess.status === 'pending') {
      sess.status = 'expired';
      memStore.set(sid, sess);
    }
    return { status: sess.status };
  };
}

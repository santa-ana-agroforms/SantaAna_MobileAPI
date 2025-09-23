/* eslint-disable @typescript-eslint/require-await */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
// src/auth/qr/auth-qr.service.ts
import {
  Injectable,
  BadRequestException,
  UnauthorizedException,
  Logger,
} from '@nestjs/common';
import { randomBytes, createHmac } from 'crypto';
import { JwtService } from '@nestjs/jwt';
import QRCode from 'qrcode';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../entities/user.entity';

import sharp from 'sharp';
import { promises as fs } from 'fs';
import path from 'path';

type QrStatus = 'pending' | 'claimed' | 'expired';

type QrSession = {
  sid: string;
  nonce: string;
  expAt: number; // epoch ms
  status: QrStatus;
  targetUsername: string; // ← usuario al que pertenece este QR
  accessToken?: string; // se setea al reclamar (login)
};

type QrRenderOpts = {
  width?: number; // tamaño PNG del QR
  dark?: string; // color de módulos
  light?: string; // color de fondo (usar '#0000' para transparente)
  logoPath?: string | undefined; // ruta del logo (opcional)
  logoSizeRatio?: number; // 0.20–0.25 recomendado
  logoBorder?: number; // padding blanco alrededor del logo (px)
};

const memStore = new Map<string, QrSession>(); // ⛔ En prod: usar Redis con TTL
const now = () => Date.now();
const makeSig = (sid: string, nonce: string, secret: string) =>
  createHmac('sha256', secret).update(`${sid}.${nonce}`).digest('hex');

@Injectable()
export class AuthQrService {
  private readonly logger = new Logger(AuthQrService.name);

  constructor(
    private readonly jwt: JwtService,
    @InjectRepository(User) private readonly usersRepo: Repository<User>,
  ) {}

  // ========= Helper de render con logo centrado (PNG DataURL) =========
  private makeQrDataUrl = async (payload: string, opts: QrRenderOpts = {}) => {
    const {
      width = Number(process.env.QR_WIDTH || 560),
      dark = process.env.QR_DARK || '#0F172AFF',
      light = process.env.QR_LIGHT || '#FFFFFFFF', // '#0000' para fondo transparente
      logoPath = process.env.QR_LOGO_PATH, // ej: "assets/brand/logo.png"
      logoSizeRatio = Number(process.env.QR_LOGO_RATIO || 0.22),
      logoBorder = Number(process.env.QR_LOGO_BORDER || 14),
    } = opts;

    // 1) QR base (alta corrección de error)
    const qrPng = await QRCode.toBuffer(payload, {
      errorCorrectionLevel: 'H',
      width,
      margin: 2,
      color: { dark, light },
    });

    // Si no hay logo configurado, regresar directo
    if (!logoPath) {
      return `data:image/png;base64,${qrPng.toString('base64')}`;
    }

    try {
      // 2) Preparar logo
      const absLogoPath = path.isAbsolute(logoPath)
        ? logoPath
        : path.resolve(process.cwd(), logoPath);

      const logoRaw = await fs.readFile(absLogoPath);
      const logoSize = Math.round(width * logoSizeRatio);

      const logo = await sharp(logoRaw)
        .resize({ width: logoSize, height: logoSize, fit: 'inside' })
        .png()
        .toBuffer();

      // 3) Badge blanco redondeado para contraste
      const badgeSize = logoSize + logoBorder * 2;
      const radius = Math.round(badgeSize * 0.2);
      const badgeSvg = Buffer.from(
        `<svg width="${badgeSize}" height="${badgeSize}">
           <rect x="0" y="0" width="${badgeSize}" height="${badgeSize}"
                 rx="${radius}" ry="${radius}" fill="#FFFFFF"/>
         </svg>`,
      );

      const badge = await sharp({
        create: {
          width: badgeSize,
          height: badgeSize,
          channels: 4,
          background: { r: 0, g: 0, b: 0, alpha: 0 },
        },
      })
        .composite([{ input: badgeSvg, gravity: 'centre' }])
        .png()
        .toBuffer();

      // 4) Logo sobre badge y composite centrado en el QR
      const icon = await sharp(badge)
        .composite([{ input: logo, gravity: 'centre' }])
        .png()
        .toBuffer();

      const finalPng = await sharp(qrPng)
        .composite([{ input: icon, gravity: 'centre' }])
        .png()
        .toBuffer();

      return `data:image/png;base64,${finalPng.toString('base64')}`;
    } catch (e) {
      this.logger.warn(
        `QR con logo: usando fallback sin logo. Motivo: ${String(e)}`,
      );
      return `data:image/png;base64,${qrPng.toString('base64')}`;
    }
  };

  // Admin: genera QR ligado a un username
  startForUser = async (
    targetUsername: string,
  ): Promise<{ sid: string; qr: string; expiresIn: number }> => {
    // Verificar que exista el usuario, para no generar QR inválido
    const user = await this.usersRepo.findOne({
      where: { nombre_de_usuario: targetUsername },
      relations: { roles: true },
      select: ['nombre_de_usuario'], // consulta mínima
    });
    if (!user) throw new BadRequestException('Usuario destino no existe');

    const sid = randomBytes(16).toString('hex');
    const nonce = randomBytes(16).toString('hex');
    // 1hour
    const ttlMs = 60 * 60 * 1000; // 1h
    const expAt = now() + ttlMs;

    const secret = process.env.QR_SECRET || 'qr-dev-secret';
    const sig = makeSig(sid, nonce, secret);

    // Payload que va dentro del QR (no revela el username)
    const payload = JSON.stringify({ sid, nonce, sig, v: 1 });

    // === QR bonito con logo (si QR_LOGO_PATH está seteado) ===
    const qr = await this.makeQrDataUrl(payload);

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
      relations: { roles: true },
    });
    if (!user) throw new UnauthorizedException('Usuario no encontrado');

    // Tu payload (sin sub): username + rol
    const tokenPayload = {
      username: user.nombre_de_usuario,
      rolesId: user.roles.map((r) => r.id),
      rolesName: user.roles.map((r) => r.nombre),
    };

    const accessToken = await this.jwt.signAsync(tokenPayload, {
      secret: process.env.JWT_SECRET || 'dev-secret',
      algorithm: 'HS384',
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
        roles: user.roles.map((r) => ({ id: r.id, nombre: r.nombre })),
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

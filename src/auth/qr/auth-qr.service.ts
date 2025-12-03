import {
  Injectable,
  BadRequestException,
  UnauthorizedException,
  ForbiddenException,
  Logger,
} from '@nestjs/common';
import { createHmac, randomBytes } from 'crypto';
// ⬇️ Import correcto para tener tipos (evita "any")
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import type { QRCodeToBufferOptions } from 'qrcode';
import sharp from 'sharp';
import path from 'path';
import { promises as fs } from 'fs';

import { Usuario } from '../entities/formularios-usuario.entity';
import { UsuarioGroup } from '../entities/formularios-usuario-groups.entity';
import { AuthService } from '../auth.service';
import type { LoginResult } from '../types/auth.types';
import { UserTerminal } from '../entities';

type QrStatus = 'pending' | 'claimed' | 'expired';

type QrRenderOpts = {
  width?: number; // tamaño del PNG final (px)
  dark?: string; // color de módulos
  light?: string; // color de fondo (usa '#0000' para transparente)
  logoPath?: string; // ruta del logo (opcional)
  logoSizeRatio?: number; // proporción del ancho del QR (0.20–0.25 recomendado)
  logoBorder?: number; // padding blanco alrededor del logo (px)
};

type QrSession = {
  sid: string;
  nonce: string;
  expAt: number; // epoch ms
  status: QrStatus;
  targetUsername: string; // usuario ligado a este QR
  result?: LoginResult; // setea al reclamar (login)
};

const memStore = new Map<string, QrSession>(); // ⛔ En prod: usar Redis con TTL
const now = () => Date.now();
const makeSig = (sid: string, nonce: string, secret: string) =>
  createHmac('sha256', secret).update(`${sid}.${nonce}`).digest('hex');

@Injectable()
export class AuthQrService {
  private readonly logger = new Logger(AuthQrService.name);

  constructor(
    @InjectRepository(Usuario)
    private readonly usersRepo: Repository<Usuario>,
    @InjectRepository(UsuarioGroup)
    private readonly userGroupsRepo: Repository<UsuarioGroup>,
    @InjectRepository(UserTerminal)
    private readonly userTerminalRepo: Repository<UserTerminal>,
    private readonly authService: AuthService,
    private readonly dataSource: DataSource,
  ) {}

  // ========= Helpers =========
  private async ensureUserExists(nombreUsuario: string): Promise<void> {
    const u = await this.usersRepo.findOne({
      where: { nombreUsuario },
      select: { nombreUsuario: true, activo: true, accesoWeb: true },
    });

    if (!u) {
      throw new BadRequestException('El usuario destino no existe');
    }
    if (!u.activo) {
      throw new ForbiddenException('El usuario está inactivo o sin acceso web');
    }
  }

  private async loadRoles(
    nombreUsuario: string,
  ): Promise<Array<{ id: number; nombre: string }>> {
    const rows = await this.dataSource.query<
      Array<{ id: number; name: string }>
    >(
      `
      SELECT g.id, g.name
      FROM auth_group g
      JOIN formularios_usuario_groups ug
        ON ug.group_id = g.id
      WHERE ug.usuario_id = $1
      ORDER BY g.name
      `,
      [nombreUsuario],
    );

    return rows.map((r) => ({ id: Number(r.id), nombre: r.name }));
  }

  // ⬇️ Es ASÍNCRONA y devuelve Promise<string>; usar await en el caller
  private makeQrDataUrl = async (
    payload: string,
    opts: QrRenderOpts = {},
  ): Promise<string> => {
    const {
      width = Number(process.env.QR_WIDTH || 560),
      dark = process.env.QR_DARK || '#0F172AFF',
      light = process.env.QR_LIGHT || '#FFFFFFFF', // '#0000' para fondo transparente
      logoPath = process.env.QR_LOGO_PATH, // ej: "assets/brand/logo.png"
      logoSizeRatio = Number(process.env.QR_LOGO_RATIO || 0.22),
      logoBorder = Number(process.env.QR_LOGO_BORDER || 14),
    } = opts;

    // Import dinámico tipado para evitar problemas de ESLint/TS con CJS
    const { toBuffer } = (await import('qrcode')) as {
      toBuffer: (
        text: string,
        options?: QRCodeToBufferOptions,
      ) => Promise<Buffer>;
    };

    // 1) QR base (alta corrección de error)
    const qrPng = await toBuffer(payload, {
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
      this.logger?.warn?.(
        `QR con logo: usando fallback sin logo. Motivo: ${String(e)}`,
      );
      return `data:image/png;base64,${qrPng.toString('base64')}`;
    }
  };

  // ========= Flujos (firmas y outputs idénticos a tu original) =========

  // Admin: genera QR ligado a un username (verifica existencia ANTES)
  startForUser = async (
    targetUsername: string,
  ): Promise<{ sid: string; qr: string; expiresIn: number }> => {
    await this.ensureUserExists(targetUsername); // ✅ verificación previa

    const sid = randomBytes(16).toString('hex');
    const nonce = randomBytes(16).toString('hex');

    const ttlMs = Number(process.env.AUTH_QR_TTL_MS ?? 60 * 60 * 1000); // default 1h
    const expAt = now() + ttlMs;

    const secret = process.env.QR_SECRET || 'qr-dev-secret';
    const sig = makeSig(sid, nonce, secret);

    // Payload JSON (sin usuario, como antes)
    const payload = JSON.stringify({ sid, nonce, sig, v: 1 });

    // ⬇️ ¡AQUÍ SÍ hay que esperar! (antes lo casteabas mal)
    const qr = await this.makeQrDataUrl(payload);

    memStore.set(sid, {
      sid,
      nonce,
      expAt,
      status: 'pending',
      targetUsername,
    });

    return { sid, qr, expiresIn: Math.floor(ttlMs / 1000) };
  };

  // Móvil: reclama el QR y recibe el JWT (misma firma: sid, nonce, sig)
  login = async (sid: string, nonce: string, sig: string) => {
    const sess = memStore.get(sid);
    if (!sess) throw new BadRequestException('Sesión inválida');
    if (sess.status !== 'pending') {
      throw new BadRequestException('Sesión ya utilizada o no disponible');
    }
    if (sess.expAt < now()) {
      sess.status = 'expired';
      memStore.set(sid, sess);
      throw new BadRequestException('Sesión expirada');
    }

    const secret = process.env.QR_SECRET || 'qr-dev-secret';
    const expected = makeSig(sid, nonce, secret);
    if (expected !== sig || sess.nonce !== nonce) {
      throw new UnauthorizedException('Firma inválida');
    }

    // Emitir el MISMO token que el login normal (usa AuthService con Argon2)
    const user = await this.authService.me(sess.targetUsername);
    const result = await this.authService.login(user);

    // Output LEGACY (como tu original)
    const roles = await this.loadRoles(sess.targetUsername);
    const legacy = {
      access_token: result.access_token,
      user: {
        nombre: result.user.nombre,
        nombre_usuario: result.user.nombre_usuario,
        roles,
      },
    };

    sess.status = 'claimed';
    sess.result = result;
    memStore.set(sid, sess);

    return legacy;
  };

  // Admin: ver estado (output idéntico: { status })
  status = (sid: string): { status: QrStatus } => {
    const sess = memStore.get(sid);
    if (!sess) return { status: 'expired' };
    if (sess.expAt < now() && sess.status === 'pending') {
      sess.status = 'expired';
      memStore.set(sid, sess);
    }
    return { status: sess.status };
  };

  addTerminal = async (data: Record<string, any>, nombreUsuario: string) => {
    /**
     * @Entity({ name: 'formularios_user_terminal' })
     export class UserTerminal {
       @PrimaryGeneratedColumn({ type: 'bigint', name: 'id' })
       id!: string;
     
       @ManyToOne(() => Usuario, (u) => u.userTerminals, { onDelete: 'CASCADE' })
       @JoinColumn({ name: 'nombre_usuario', referencedColumnName: 'nombreUsuario' })
       usuario!: Usuario;
     
       @Column({ type: 'text', nullable: true, transformer: jsonTextTransformer })
       terminal_info!: Record<string, unknown> | null;
     }
     
     */
    const terminal = this.userTerminalRepo.create({
      usuario: { nombreUsuario },
      terminal_info: data,
    });
    await this.userTerminalRepo.save(terminal);
  };
}

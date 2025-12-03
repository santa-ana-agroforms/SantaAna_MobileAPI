/* eslint-disable @typescript-eslint/no-unsafe-argument */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
import {
  BadRequestException,
  Body,
  Controller,
  Get,
  Param,
  Post,
  UseGuards,
} from '@nestjs/common';
import {
  ApiOkResponse,
  ApiOperation,
  ApiParam,
  ApiTags,
} from '@nestjs/swagger';
import { AuthQrService } from './auth-qr.service';
import { LoginQrDto, OnlyUserName } from './dto/qr.dto';
import { ApiKeyGuard } from '../guards/api-key.guard';
import { ApiKeyAuth } from '../decorators/api-key.decorator';
import { createHmac as nodeCreateHmac } from 'crypto';

@ApiTags('auth-qr')
@Controller('auth/qr')
export class AuthQrController {
  constructor(private readonly svc: AuthQrService) {}

  // Admin crea el QR para un user específico – protegido por API Key
  @Post('start-for-user')
  @ApiKeyAuth()
  @UseGuards(ApiKeyGuard)
  @ApiOperation({
    summary: 'Crear sesión QR ligada a un usuario (protegido por API Key)',
  })
  @ApiOkResponse({
    schema: {
      properties: {
        sid: { type: 'string' },
        qr: { type: 'string', description: 'PNG base64 (Data URL)' },
        expiresIn: { type: 'number' },
      },
    },
  })
  async startForUser(@Body() body: OnlyUserName) {
    const username =
      typeof body?.nombre_usuario === 'string' && body.nombre_usuario.trim();
    if (!username) {
      throw new BadRequestException("El cuerpo debe incluir 'nombre_usuario'.");
    }
    return this.svc.startForUser(username);
  }

  // Móvil: login desde QR (público, no requiere API Key)
  @Post('login')
  @ApiOperation({ summary: 'Login escaneando QR (móvil)' })
  @ApiOkResponse({
    description: 'Devuelve access_token y datos de usuario (legacy shape)',
  })
  async login(@Body() body: LoginQrDto) {
    const legacy = await this.svc.login(body.sid, body.nonce, body.sig);

    if (body.device_info && body.device_info instanceof Object) {
      // registrar terminal asociada al usuario
      await this.svc.addTerminal(body.device_info, legacy.user.nombre_usuario);
    }

    // misma firma que antes: (sid, nonce, sig)
    return legacy;
  }

  // Admin: ver estado (protegido por API Key) — param en ruta
  @Get('status/:sid')
  @ApiKeyAuth()
  @UseGuards(ApiKeyGuard)
  @ApiOperation({
    summary: 'Consultar estado de sesión QR (protegido por API Key)',
  })
  @ApiParam({ name: 'sid', required: true, description: 'ID de la sesión QR' })
  status(@Param('sid') sid: string) {
    return this.svc.status(sid);
  }

  @Get('debug/session/:sid')
  @ApiKeyAuth()
  @UseGuards(ApiKeyGuard)
  debugSession(@Param('sid') sid: string) {
    // ¡NO lo dejes en prod!
    interface QrSession {
      sid: string;
      nonce: string;
      [key: string]: any;
    }
    type QrStore = Map<string, QrSession>;

    const globalAny = global as typeof global & { __qr_store?: QrStore };
    const store = globalAny.__qr_store;
    const s = store?.get(sid);
    if (!s) return { status: 'expired' };
    const secret = process.env.QR_SECRET || 'qr-dev-secret';
    const expectedSig = createHmac('sha256', secret)
      .update(`${s.sid}.${s.nonce}`)
      .digest('hex');
    return { ...s, expectedSig };
  }

  @Get('terminals')
  async getUserTerminals() {
    const terms = await this.svc.getAllTerminals();
    const r_ob = terms.map((r) => ({
      nombre_usuario: r.usuario.nombreUsuario,
      terminal_info: JSON.parse(r.terminal_info ?? 'null'),
    }));

    const k = r_ob.map((e) => ({
      ...e,
      terminal_info: JSON.parse(e.terminal_info ?? 'null'),
    }));

    return k;
  }
}
function createHmac(algorithm: string, secret: string) {
  return nodeCreateHmac(algorithm, secret);
}

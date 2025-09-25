/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-call */
import {
  BadRequestException,
  Body,
  Controller,
  Get,
  Param,
  Post,
  UseGuards,
} from '@nestjs/common';
import { ApiOkResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthQrService } from './auth-qr.service';
import { LoginQrDto } from './dto/qr.dto';
import { ApiKeyGuard } from '../guards/api-key.guard';
import { ApiKeyAuth } from '../decorators/api-key.decorator';

@ApiTags('auth-qr')
@Controller('auth/qr')
export class AuthQrController {
  constructor(private readonly svc: AuthQrService) {}

  // Admin crea el QR para un user específico – ahora protegido por API Key
  // src/auth/qr/auth-qr.controller.ts
  @Post('start-for-user')
  @ApiKeyAuth()
  @UseGuards(ApiKeyGuard)
  @ApiOperation({
    summary: 'Crear sesión QR ligada a un usuario (protegido por API Key)',
  })
  async startForUser(@Body() body: any) {
    const username =
      (typeof body?.nombre_usuario === 'string' &&
        body.nombre_usuario.trim()) ||
      (typeof body?.nombre_de_usuario === 'string' &&
        body.nombre_de_usuario.trim());

    if (!username) {
      // 400 inmediato si no viene ninguno
      throw new BadRequestException("El cuerpo debe incluir 'nombre_usuario'.");
    }

    return this.svc.startForUser(username as string);
  }

  // Móvil: login desde QR (público, no requiere API Key)
  @Post('login')
  @ApiOperation({ summary: 'Login escaneando QR (móvil)' })
  @ApiOkResponse({ description: 'Devuelve access_token y datos de usuario' })
  async login(@Body() body: LoginQrDto) {
    return this.svc.login(body.sid, body.nonce, body.sig);
  }

  // Admin: ver estado (protegido por API Key)
  @Get('status/:sid')
  @ApiKeyAuth()
  @UseGuards(ApiKeyGuard)
  @ApiOperation({
    summary: 'Consultar estado de sesión QR (protegido por API Key)',
  })
  async status(@Param('sid') sid: string) {
    return this.svc.status(sid);
  }
}

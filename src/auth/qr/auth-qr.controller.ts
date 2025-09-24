// src/auth/qr/auth-qr.controller.ts
import { Body, Controller, Get, Param, Post, UseGuards } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { AuthQrService } from './auth-qr.service';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { RolesGuard } from '../guards/roles.guard';
import { Roles } from '../decorators/roles.decorator';
import { LoginQrDto, OnlyUserName } from './dto/qr.dto';

@ApiTags('auth-qr')
@Controller('auth/qr')
export class AuthQrController {
  constructor(private readonly svc: AuthQrService) {}

  // Admin crea el QR para un user específico
  @Post('start-for-user')
  @ApiBearerAuth('access-token')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('Administrador') // ajustá al nombre real de tu rol admin
  @ApiOperation({ summary: 'Crear sesión QR ligada a un usuario' })
  async startForUser(@Body() body: OnlyUserName) {
    return this.svc.startForUser(body.nombre_usuario);
  }

  // Móvil: login desde QR (no requiere estar logueado antes)
  @Post('login')
  @ApiOperation({ summary: 'Login escaneando QR (móvil)' })
  @ApiOkResponse({ description: 'Devuelve access_token y datos de usuario' })
  async login(@Body() body: LoginQrDto) {
    return this.svc.login(body.sid, body.nonce, body.sig);
  }

  // Admin: ver estado (opcional)
  @Get('status/:sid')
  @ApiBearerAuth('access-token')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('Administrador')
  @ApiOperation({ summary: 'Consultar estado de sesión QR' })
  async status(@Param('sid') sid: string) {
    return this.svc.status(sid);
  }
}

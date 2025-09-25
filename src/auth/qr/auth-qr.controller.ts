import { Body, Controller, Get, Param, Post, UseGuards } from '@nestjs/common';
import { ApiOkResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthQrService } from './auth-qr.service';
import { LoginQrDto, OnlyUserName } from './dto/qr.dto';
import { ApiKeyGuard } from '../guards/api-key.guard';
import { ApiKeyAuth } from '../decorators/api-key.decorator';

@ApiTags('auth-qr')
@Controller('auth/qr')
export class AuthQrController {
  constructor(private readonly svc: AuthQrService) {}

  // Admin crea el QR para un user específico – ahora protegido por API Key
  @Post('start-for-user')
  @ApiKeyAuth()
  @UseGuards(ApiKeyGuard)
  @ApiOperation({
    summary: 'Crear sesión QR ligada a un usuario (protegido por API Key)',
  })
  async startForUser(@Body() body: OnlyUserName) {
    return this.svc.startForUser(body.nombre_usuario);
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

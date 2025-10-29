import { Body, Controller, HttpCode, HttpStatus, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';

@Controller('auth')
export class AuthController {
  constructor(private readonly auth: AuthService) {}

  @Post('login')
  @HttpCode(HttpStatus.OK)
  async login(@Body() dto: LoginDto) {
    // Ahora AuthService.login soporta (username, password)
    console.log(
      `AuthController.login: usuario=${dto.nombre_usuario} password=${dto.password}`,
    );
    return this.auth.login(dto.nombre_usuario, dto.password);
  }
}

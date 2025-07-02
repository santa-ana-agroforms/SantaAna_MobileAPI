// src/auth/auth.controller.ts
import { Body, Controller, Post, UnauthorizedException } from '@nestjs/common';
import { AuthService } from './auth.service';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('login')
  async login(
    @Body() body: { username: string; password: string },
  ): Promise<{ access_token: string }> {
    const token = await this.authService.validateLogin(
      body.username,
      body.password,
    );
    if (!token) throw new UnauthorizedException('Credenciales inválidas');

    return { access_token: token };
  }
}

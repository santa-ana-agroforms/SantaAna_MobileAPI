// src/auth/auth.module.ts
import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { JwtStrategy } from './strategies/jwt.strategy';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { RolesGuard } from './guards/roles.guard';
import { AuthQrController } from './qr/auth-qr.controller';
import { AuthQrService } from './qr/auth-qr.service';
import { ApiKeyGuard } from './guards/api-key.guard';
import * as UserEntities from './entities';
import { ConfigService } from '@nestjs/config';

@Module({
  imports: [
    PassportModule.register({ defaultStrategy: 'jwt', session: false }),
    JwtModule.registerAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        secret: config.get<string>('JWT_SECRET'),
        signOptions: {
          algorithm: 'HS384', // 👈 Para que TODO lo que firmes de ahora en adelante sea HS384
          expiresIn: Number(process.env.JWT_EXPIRES_IN_SECONDS ?? '86400'),
        },
      }),
    }),
    TypeOrmModule.forFeature([...Object.values(UserEntities)]),
  ],
  controllers: [AuthController, AuthQrController],
  providers: [
    AuthService,
    JwtStrategy,
    JwtAuthGuard,
    RolesGuard,
    AuthQrService,
    ApiKeyGuard,
  ],
  exports: [JwtAuthGuard, RolesGuard, ApiKeyGuard], // para usar en otros módulos/rutas
})
export class AuthModule {}

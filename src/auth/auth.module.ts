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
import { User } from './entities/user.entity';
import { Role } from './entities/role.entity';
import { AuthQrController } from './qr/auth-qr.controller';
import { AuthQrService } from './qr/auth-qr.service';
import { ApiKeyGuard } from './guards/api-key.guard';

@Module({
  imports: [
    PassportModule.register({ defaultStrategy: 'jwt', session: false }),
    JwtModule.register({
      // valores por defecto; usa .env en runtime
      secret: process.env.JWT_SECRET || 'dev-secret',
      signOptions: {
        algorithm: 'HS384',
        expiresIn: process.env.JWT_EXPIRES_IN || '1h',
      },
    }),
    TypeOrmModule.forFeature([User, Role]),
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

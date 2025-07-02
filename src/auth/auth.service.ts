// src/auth/auth.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from './entities/user.entity';
import { Repository } from 'typeorm';
import * as crypto from 'crypto';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private userRepo: Repository<User>,
    private jwtService: JwtService,
  ) {}

  async validateLogin(
    username: string,
    plainPassword: string,
  ): Promise<string | null> {
    const user = await this.userRepo.findOne({ where: { username } });
    if (!user || !user.isActive) return null;

    if (!this.verifyPassword(plainPassword, user.password)) {
      return null;
    }

    return this.jwtService.sign({
      sub: user.id,
      username: user.username,
      email: user.email,
    });
  }

  private verifyPassword(password: string, djangoHash: string): boolean {
    console.log('\n📥 Password ingresada:', password);
    console.log('📦 Hash completo recibido:', djangoHash);

    try {
      const parts = djangoHash.split('$');
      if (parts.length !== 4 || parts[0] !== 'pbkdf2_sha256') {
        console.error('❌ Formato de hash inválido');
        return false;
      }

      const [algo, iterations, salt, hash] = parts;

      console.log('\n🧪 Desglose del hash Django:');
      console.log('🔤 Algoritmo:', algo);
      console.log('🔁 Iteraciones:', iterations);
      console.log('🧂 Salt:', salt);
      console.log('🔑 Hash esperado:', hash);

      const derived = crypto
        .pbkdf2Sync(password, salt, parseInt(iterations), 32, 'sha256')
        .toString('base64');

      console.log('\n🔍 Hash derivado desde NestJS:', derived);

      const resultado = derived === hash;
      console.log('✅ Coincide:', resultado);

      return resultado;
    } catch (err) {
      console.error('💥 Error verificando contraseña:', err);
      return false;
    }
  }
}

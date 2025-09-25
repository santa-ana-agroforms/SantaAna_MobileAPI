/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as crypto from 'crypto';

type KeySource = {
  type: 'sha256' | 'plaintext';
  values: string[]; // si type === 'sha256' => hex digests; si plaintext => claves en texto
};

@Injectable()
export class ApiKeyGuard implements CanActivate {
  private readonly keys: KeySource;

  constructor(private readonly config: ConfigService) {
    // Opción 1 (más segura): hashes en env, separados por coma
    //   API_KEY_SHA256S=ab12..ff,0011..aa
    const shaList = (this.config.get<string>('API_KEY_SHA256S') ?? '')
      .split(',')
      .map((s) => s.trim())
      .filter(Boolean);

    if (shaList.length > 0) {
      this.keys = { type: 'sha256', values: shaList };
      return;
    }

    // Opción 2: claves en texto (se permite por conveniencia; se compara vía hash para timing-safe)
    //   API_KEYS=clave-super-secreta,otra-clave
    const plainList = (this.config.get<string>('API_KEYS') ?? '')
      .split(',')
      .map((s) => s.trim())
      .filter(Boolean);

    if (plainList.length === 0) {
      // Sin claves configuradas: preferimos fallar rápido para no exponer el endpoint.
      throw new Error(
        'Falta configuración de API Keys. Define API_KEY_SHA256S o API_KEYS en variables de ambiente.',
      );
    }

    this.keys = { type: 'plaintext', values: plainList };
  }

  canActivate(context: ExecutionContext): boolean {
    const req = context.switchToHttp().getRequest();

    const headerVal: string | undefined =
      (req.headers['x-api-key'] as string | undefined) ||
      this.extractFromAuthorization(
        req.headers['authorization'] as string | undefined,
      );

    if (!headerVal) {
      throw new UnauthorizedException('API key requerida');
    }

    const ok = this.validateApiKey(headerVal);
    if (!ok) {
      // No damos pistas: mensaje genérico
      throw new UnauthorizedException('No autorizado');
    }
    return true;
  }

  private extractFromAuthorization(auth?: string): string | undefined {
    if (!auth) return undefined;
    // Formato esperado: "ApiKey <clave>"
    const parts = auth.trim().split(/\s+/);
    if (parts.length === 2 && /^ApiKey$/i.test(parts[0])) return parts[1];
    return undefined;
  }

  private validateApiKey(provided: string): boolean {
    if (this.keys.type === 'sha256') {
      // Hasheamos la provista y comparamos contra la lista de hashes (mismo largo)
      const digest = this.sha256Hex(provided);
      return this.keys.values.some((storedHex) =>
        this.timingSafeEqualHex(digest, storedHex),
      );
    }

    // Texto plano: comparamos en tiempo constante hasheando ambos lados
    const providedHash = this.sha256Hex(provided);
    return this.keys.values.some((plain) => {
      const candidateHash = this.sha256Hex(plain);
      return this.timingSafeEqualHex(providedHash, candidateHash);
    });
  }

  private sha256Hex(input: string): string {
    return crypto.createHash('sha256').update(input, 'utf8').digest('hex');
  }

  private timingSafeEqualHex(aHex: string, bHex: string): boolean {
    // Ambos deben tener igual longitud (sha256 -> 64 hex chars)
    const a = Buffer.from(aHex, 'hex');
    const b = Buffer.from(bHex, 'hex');
    if (a.length !== b.length) return false;
    return crypto.timingSafeEqual(a, b);
  }
}

import { applyDecorators } from '@nestjs/common';
import { ApiSecurity } from '@nestjs/swagger';

export const ApiKeyAuth = () =>
  applyDecorators(
    // Nombre "apiKey" debe coincidir con el esquema declarado en main.ts
    ApiSecurity('apiKey'),
  );

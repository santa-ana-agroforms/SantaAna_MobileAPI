// src/forms/dto/transpile.dto.ts
import { ApiProperty } from '@nestjs/swagger';
import {
  IsObject,
  IsOptional,
  IsString,
  MaxLength,
  MinLength,
} from 'class-validator';

export class TranspileDto {
  @ApiProperty({ description: 'Código TypeScript a transpilar', minLength: 1 })
  @IsString()
  @MinLength(1)
  @MaxLength(20000)
  code!: string;

  @ApiProperty({
    required: false,
    description: 'Opciones SWC personalizadas (opcional).',
  })
  @IsOptional()
  @IsObject()
  options?: Record<string, any>;
}

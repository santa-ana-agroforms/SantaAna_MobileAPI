/* eslint-disable @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-return */
import { IsObject, IsOptional, IsString, MinLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class OnlyUserName {
  @ApiProperty()
  @IsString()
  @MinLength(3)
  nombre_usuario!: string;
}

export class LoginQrDto {
  @ApiProperty()
  @IsString()
  @MinLength(36)
  sid!: string;

  @ApiProperty()
  @IsString()
  @MinLength(36)
  nonce!: string;

  @ApiProperty()
  @IsString()
  @MinLength(36)
  sig!: string;

  // Optional field -> Mobile info: type object
  @IsOptional()
  @IsObject()
  device_info?: Record<string, any>;
}
/* eslint-enable @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-return */

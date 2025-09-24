/* eslint-disable @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-return */
import { IsString, MinLength } from 'class-validator';
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
}
/* eslint-enable @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-return */

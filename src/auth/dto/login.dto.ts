import { IsNotEmpty, IsString, Length } from 'class-validator';

export class LoginDto {
  @IsString()
  @IsNotEmpty()
  @Length(1, 50)
  nombre_usuario!: string;

  @IsString()
  @IsNotEmpty()
  @Length(1, 256)
  password!: string;
}

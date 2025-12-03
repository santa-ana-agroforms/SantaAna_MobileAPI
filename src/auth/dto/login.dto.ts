import {
  IsNotEmpty,
  IsString,
  Length,
  IsObject,
  IsOptional,
} from 'class-validator';

export class LoginDto {
  @IsString()
  @IsNotEmpty()
  @Length(1, 50)
  nombre_usuario!: string;

  @IsString()
  @IsNotEmpty()
  @Length(1, 256)
  password!: string;

  // Optional field -> Mobile info: type object
  @IsOptional()
  @IsObject()
  device_info?: Record<string, any>;
}

import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModuleAsyncOptions } from '@nestjs/typeorm';
import { DataSourceOptions } from 'typeorm';
import * as FormsEntities from '../forms/entities';
import * as UserEntities from 'src/auth/entities';
import { Grupo } from 'src/groups/entities/formularios-grupo.entity';
import { CampoGrupo } from 'src/groups/entities/formularios-campo-grupo.entity';

export const typeOrmAsyncConfig: TypeOrmModuleAsyncOptions = {
  imports: [ConfigModule],
  inject: [ConfigService],
  useFactory: (config: ConfigService) => {
    const sslEnabled = (config.get<string>('PG_SSL') ?? 'true') === 'true'; // <- por defecto true en cloud
    const rejectUnauthorized =
      (config.get<string>('PG_SSL_REJECT_UNAUTH') ?? 'false') === 'true';
    const ca = config.get<string>('PG_SSL_CA'); // opcional (cadena PEM)

    const ssl = sslEnabled
      ? ca
        ? { rejectUnauthorized, ca } // verificación con CA propia
        : { rejectUnauthorized } // típicamente false en Neon/Aiven/Koyeb
      : false;

    const opts: DataSourceOptions & { autoLoadEntities?: boolean } = {
      type: 'postgres',
      host: config.get<string>('PG_HOST'),
      port: Number(config.get<string>('PG_PORT') ?? 5432),
      username: config.get<string>('PG_USER'),
      password: config.get<string>('PG_PASS'),
      database: config.get<string>('PG_DB'),
      entities: [
        ...Object.values(FormsEntities),
        ...Object.values(UserEntities),
        Grupo,
        CampoGrupo,
      ],
      synchronize: (config.get<string>('DB_SYNC') ?? 'false') === 'true',
      ssl,
      // Para compatibilidad con algunos hostings:
      extra: ssl ? { ssl } : undefined,
    };

    // Si te dan una DATABASE_URL con ?sslmode=require, úsala directamente:
    const url = config.get<string>('DATABASE_URL');
    if (url) {
      (opts as { url: string }).url = url;
      // Cuando usás url, pg ya respeta sslmode=require del querystring,
      // pero mantener "ssl" no estorba.
    }

    return opts;
  },
};

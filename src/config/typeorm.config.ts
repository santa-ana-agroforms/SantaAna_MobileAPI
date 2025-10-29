// src/config/typeorm.config.ts
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModuleAsyncOptions } from '@nestjs/typeorm';
import { DataSourceOptions } from 'typeorm';

// 👇 Usar rutas relativas para que Jest no dependa de paths de tsconfig
import * as FormsEntities from '../forms/entities';
import * as UserEntities from '../auth/entities';
import { Grupo } from '../groups/entities/formularios-grupo.entity';
import { CampoGrupo } from '../groups/entities/formularios-campo-grupo.entity';

export const typeOrmAsyncConfig: TypeOrmModuleAsyncOptions = {
  imports: [ConfigModule],
  inject: [ConfigService],
  useFactory: (config: ConfigService) => {
    const sslEnabled = (config.get<string>('PG_SSL') ?? 'true') === 'true';
    const rejectUnauthorized =
      (config.get<string>('PG_SSL_REJECT_UNAUTH') ?? 'false') === 'true';
    const ca = config.get<string>('PG_SSL_CA');

    const ssl = sslEnabled
      ? ca
        ? { rejectUnauthorized, ca }
        : { rejectUnauthorized }
      : false;

    // 👇 Flags controladas por ENV para tests, sin tocar prod
    const isTest = process.env.NODE_ENV === 'test';
    const synchronize =
      (config.get<string>('DB_SYNC') ?? (isTest ? 'true' : 'false')) === 'true';
    const dropSchema =
      (config.get<string>('DB_DROP_SCHEMA') ?? (isTest ? 'true' : 'false')) ===
      'true';
    const logging = (config.get<string>('DB_LOGGING') ?? 'false') === 'true';

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
      // 👇 Estos dos quedan gobernados por ENV (en test los forzamos)
      synchronize,
      dropSchema,
      logging,
      ssl,
      extra: ssl ? { ssl } : undefined,
    };

    // Si hay DATABASE_URL, úsala (suele traer sslmode=require)
    const url = config.get<string>('DATABASE_URL');
    if (url) {
      (opts as { url: string }).url = url;
    }

    return opts;
  },
};

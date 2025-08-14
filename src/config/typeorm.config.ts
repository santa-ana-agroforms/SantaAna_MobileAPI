import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModuleAsyncOptions } from '@nestjs/typeorm';
import { DataSourceOptions } from 'typeorm';
import * as FormsEntities from '../forms/entities';

export const typeOrmAsyncConfig: TypeOrmModuleAsyncOptions = {
  imports: [ConfigModule],
  inject: [ConfigService],
  useFactory: (config: ConfigService) => {
    const opts: DataSourceOptions = {
      type: 'mssql',
      host: config.get<string>('SQLSERVER_HOST'),
      port: Number(config.get<string>('SQLSERVER_PORT') ?? 1433),
      username: config.get<string>('SQLSERVER_USER'),
      password: config.get<string>('SQLSERVER_PASS'),
      database: config.get<string>('SQLSERVER_DB'),
      entities: Object.values(FormsEntities),
      options: {
        encrypt: config.get<string>('SQLSERVER_ENCRYPT') === 'true',
        trustServerCertificate:
          config.get<string>('SQLSERVER_TRUST_CERT') === 'true',
      },
    };
    return opts;
  },
};

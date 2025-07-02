import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';

import { AuthModule } from './auth/auth.module';

@Module({
  imports: [
    // Cargar variables de entorno desde .env
    ConfigModule.forRoot({
      isGlobal: true, // para usar ConfigService en cualquier parte
    }),

    // Conexión a PostgreSQL usando variables del .env
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        type: 'postgres',
        host: config.get<string>('DB_HOST'),
        port: config.get<number>('DB_PORT'),
        username: config.get<string>('DB_USER'),
        password: config.get<string>('DB_PASSWORD'),
        database: config.get<string>('DB_NAME'),
        autoLoadEntities: true,
        synchronize: false, // ⚠️ true solo en desarrollo
      }),
    }),

    AuthModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}

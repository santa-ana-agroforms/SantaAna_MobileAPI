import 'dotenv/config';
import { DataSource } from 'typeorm';

export default new DataSource({
  type: 'postgres',
  host: process.env.PG_HOST,
  port: Number(process.env.PG_PORT ?? 5432),
  username: process.env.PG_USER,
  password: process.env.PG_PASS,
  database: process.env.PG_DB,
  entities: ['src/**/*.entity.ts'],
  migrations: ['src/migrations/*.ts'],
  // En prod: no sincronizar
  synchronize: false,
});

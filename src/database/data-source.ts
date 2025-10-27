// src/database/data-source.ts
import 'dotenv/config';
import { DataSource } from 'typeorm';

// Helper: toma la primera env definida
const envFirst = (...keys: string[]) => {
  for (const k of keys) {
    const v = process.env[k];
    if (v !== undefined && v !== null && v !== '') return v;
  }
  return undefined;
};

// 1) URL directa si viene definida (ej. servicios tipo Heroku/Neon/Render)
const directUrl = process.env.DATABASE_URL;

// 2) Fallback por campos sueltos (acepta PG_*, DB_*), con defaults para Compose
const host = envFirst('PGHOST', 'PG_HOST', 'DB_HOST') ?? 'db';
const port = Number(envFirst('PGPORT', 'PG_PORT', 'DB_PORT') ?? 5432);
const user = envFirst('PGUSER', 'PG_USER', 'DB_USER') ?? 'santa_ana';
const pass = envFirst('PGPASSWORD', 'PG_PASS', 'DB_PASSWORD') ?? 'santa_ana';
const db = envFirst('PGDATABASE', 'PG_DB', 'DB_NAME') ?? 'santa_ana_test';

const url =
  directUrl ??
  `postgres://${encodeURIComponent(user)}:${encodeURIComponent(
    pass,
  )}@${host}:${port}/${db}`;

// Logs más silenciosos en prod; un poco de señal en test
const isTest = (process.env.NODE_ENV || '').toLowerCase() === 'test';

export default new DataSource({
  type: 'postgres',
  url, // ← prioriza DATABASE_URL y luego arma la URL con PG_*/DB_*
  ssl: false, // ajustá a true + opciones si tu proveedor exige SSL

  // Globs robustos para correr en dev (ts-node) y en dist (JS):
  // - Este archivo compila a: dist/database/data-source.js
  // - Entidades compilan bajo: dist/**.entity.js  → subimos un nivel
  entities: [
    __dirname + '/../**/*.entity.{ts,js}',
    __dirname + '/../**/entities/*.{ts,js}',
  ],

  // Si tus migraciones viven en src/migrations → compilan a dist/migrations
  // Desde dist/database/... la ruta relativa es ../migrations
  migrations: [__dirname + '/../migrations/*.{ts,js}'],

  // En contenedores preferimos NO auto-correr migraciones;
  // mejor: CLI → `npx typeorm -d dist/database/data-source.js migration:run`
  migrationsRun: false,

  // Nunca sincronizar en prod; en test/dev usá migraciones
  synchronize: false,

  logging: isTest ? ['error'] : false,
});

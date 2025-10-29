// scripts/dev-seed.ts
import 'reflect-metadata';
import { NestFactory } from '@nestjs/core';
import { AppModule } from '../app.module';
import { DataSource } from 'typeorm';
import * as argon2 from 'argon2';
// si ya tienes helpers para cargar SQL DML, impórtalos:
import { loadAllDbFixtures } from './seed-helpers'; // ajusta ruta si ya lo tienes

async function main() {
  const app = await NestFactory.createApplicationContext(AppModule, {
    logger: ['log', 'error', 'warn'],
  });
  try {
    const ds = app.get(DataSource);

    // Si NO tienes migraciones, habilita sync por env en local:
    // (o ejecuta ds.runMigrations() si sí tienes)
    // await ds.runMigrations();

    // 1) Cargar fixtures DML (los .sql de /test/fixtures)
    //    Si ya tienes tus helpers execSqlDataOnly/loadAllDbFixtures, úsalos aquí:
    if (process.env.LOAD_FIXTURES !== 'false') {
      await loadAllDbFixtures(ds);
    }

    // 2) Crear el usuario de prueba para Locust
    const username = process.env.SEED_USERNAME || 'dahernadez';
    const password = process.env.SEED_PASSWORD || 'diegomovil1';
    const correo = process.env.SEED_EMAIL || `${username}@local.test`;

    // Inserta usando SQL simple para no depender de entities si quieres:
    const hash = await argon2.hash(password, { type: argon2.argon2id });

    // Asegúrate de que los nombres de columnas coincidan con tu entidad "Usuario"
    await ds.query(
      `
      INSERT INTO formularios_usuario
        (nombre_usuario, nombre, correo, password, activo, acceso_web, is_staff, is_superuser, last_login)
      VALUES ($1, $2, $3, $4, true, true, false, false, NOW())
      ON CONFLICT (nombre_usuario) DO UPDATE SET
        password = EXCLUDED.password,
        activo = true, acceso_web = true,
        last_login = NOW()
    `,
      [username, 'Usuario Seed', correo, hash],
    );

    console.log('✅ Seed OK');
  } finally {
    await app.close();
  }
}

main().catch((e) => {
  console.error('Seed failed:', e);
  process.exit(1);
});

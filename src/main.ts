import 'reflect-metadata';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { Logger } from '@nestjs/common';
import * as os from 'os';
import { NestExpressApplication } from '@nestjs/platform-express';

function getLanIp(): string | null {
  const nets = os.networkInterfaces();
  for (const name of Object.keys(nets)) {
    for (const net of nets[name] || []) {
      if (net && net.family === 'IPv4' && !net.internal) return net.address;
    }
  }
  return null;
}

async function bootstrap() {
  const logger = new Logger('Bootstrap');

  // 👇 Tipamos como Express para poder usar app.set(...)
  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    bufferLogs: true,
  });

  // CORS abierto para pruebas en LAN
  app.enableCors({ origin: true, credentials: true });

  // Detrás de proxy (ngrok, Nginx, Docker, etc.)
  app.set('trust proxy', true); // también puede ser 1 si tenés un solo proxy

  // Logger de requests
  app.use((req, res, next) => {
    const started = Date.now();
    const ip =
      (req.headers['x-forwarded-for'] as string) ||
      req.socket.remoteAddress ||
      '';
    res.on('finish', () => {
      const ms = Date.now() - started;
      const method = req.method;
      const url = (req as any).originalUrl || req.url;
      const status = res.statusCode;
      const origin = (req.headers['origin'] as string) || '';
      const ua = (req.headers['user-agent'] as string) || '';
      Logger.log(
        `[${method}] ${url} -> ${status} ${ms}ms | ip:${ip} origin:${origin} ua:${ua}`,
        'HTTP',
      );
    });
    next();
  });

  const config = new DocumentBuilder()
    .setTitle('Mi API')
    .setVersion('1.0.0')
    .addBearerAuth(
      { type: 'http', scheme: 'bearer', bearerFormat: 'JWT', in: 'header' },
      'access-token',
    )
    .addSecurityRequirements('access-token')
    .build();

  const document = SwaggerModule.createDocument(app, config, {
    deepScanRoutes: true,
  });

  SwaggerModule.setup('docs', app, document, {
    swaggerOptions: { persistAuthorization: true },
  });

  const host = process.env.HOST ?? '0.0.0.0';
  const port = Number(process.env.PORT ?? 3000);
  await app.listen(port, host);

  const lanIp = getLanIp();
  const localUrl = `http://localhost:${port}`;
  const lanUrl = lanIp ? `http://${lanIp}:${port}` : null;

  logger.log(`🚀 API levantada`);
  logger.log(`   Local:   ${localUrl}`);
  if (lanUrl) logger.log(`   LAN:     ${lanUrl}`);
  logger.log(`   Swagger: ${lanUrl ?? localUrl}/docs`);
}
bootstrap();

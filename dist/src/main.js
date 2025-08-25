"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
require("reflect-metadata");
const core_1 = require("@nestjs/core");
const app_module_1 = require("./app.module");
const swagger_1 = require("@nestjs/swagger");
const common_1 = require("@nestjs/common");
const os = __importStar(require("os"));
function getLanIp() {
    const nets = os.networkInterfaces();
    for (const name of Object.keys(nets)) {
        for (const net of nets[name] || []) {
            if (net && net.family === 'IPv4' && !net.internal)
                return net.address;
        }
    }
    return null;
}
async function bootstrap() {
    const logger = new common_1.Logger('Bootstrap');
    const app = await core_1.NestFactory.create(app_module_1.AppModule, {
        bufferLogs: true,
    });
    app.enableCors({ origin: true, credentials: true });
    app.set('trust proxy', true);
    app.use((req, res, next) => {
        const started = Date.now();
        const ip = req.headers['x-forwarded-for'] ||
            req.socket.remoteAddress ||
            '';
        res.on('finish', () => {
            const ms = Date.now() - started;
            const method = req.method;
            const url = req.originalUrl || req.url;
            const status = res.statusCode;
            const origin = req.headers['origin'] || '';
            const ua = req.headers['user-agent'] || '';
            common_1.Logger.log(`[${method}] ${url} -> ${status} ${ms}ms | ip:${ip} origin:${origin} ua:${ua}`, 'HTTP');
        });
        next();
    });
    const config = new swagger_1.DocumentBuilder()
        .setTitle('Mi API')
        .setVersion('1.0.0')
        .addBearerAuth({ type: 'http', scheme: 'bearer', bearerFormat: 'JWT', in: 'header' }, 'access-token')
        .addSecurityRequirements('access-token')
        .build();
    const document = swagger_1.SwaggerModule.createDocument(app, config, {
        deepScanRoutes: true,
    });
    swagger_1.SwaggerModule.setup('docs', app, document, {
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
    if (lanUrl)
        logger.log(`   LAN:     ${lanUrl}`);
    logger.log(`   Swagger: ${lanUrl ?? localUrl}/docs`);
}
bootstrap();
//# sourceMappingURL=main.js.map
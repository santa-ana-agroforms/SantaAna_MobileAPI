"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const user_entity_1 = require("./entities/user.entity");
const typeorm_2 = require("typeorm");
const crypto = require("crypto");
const jwt_1 = require("@nestjs/jwt");
let AuthService = class AuthService {
    userRepo;
    jwtService;
    constructor(userRepo, jwtService) {
        this.userRepo = userRepo;
        this.jwtService = jwtService;
    }
    async validateLogin(username, plainPassword) {
        const user = await this.userRepo.findOne({ where: { username } });
        if (!user || !user.isActive)
            return null;
        if (!this.verifyPassword(plainPassword, user.password)) {
            return null;
        }
        return this.jwtService.sign({
            sub: user.id,
            username: user.username,
            email: user.email,
        });
    }
    verifyPassword(password, djangoHash) {
        console.log('\n📥 Password ingresada:', password);
        console.log('📦 Hash completo recibido:', djangoHash);
        try {
            const parts = djangoHash.split('$');
            if (parts.length !== 4 || parts[0] !== 'pbkdf2_sha256') {
                console.error('❌ Formato de hash inválido');
                return false;
            }
            const [algo, iterations, salt, hash] = parts;
            console.log('\n🧪 Desglose del hash Django:');
            console.log('🔤 Algoritmo:', algo);
            console.log('🔁 Iteraciones:', iterations);
            console.log('🧂 Salt:', salt);
            console.log('🔑 Hash esperado:', hash);
            const derived = crypto
                .pbkdf2Sync(password, salt, parseInt(iterations), 32, 'sha256')
                .toString('base64');
            console.log('\n🔍 Hash derivado desde NestJS:', derived);
            const resultado = derived === hash;
            console.log('✅ Coincide:', resultado);
            return resultado;
        }
        catch (err) {
            console.error('💥 Error verificando contraseña:', err);
            return false;
        }
    }
};
exports.AuthService = AuthService;
exports.AuthService = AuthService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(user_entity_1.User)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        jwt_1.JwtService])
], AuthService);
//# sourceMappingURL=auth.service.js.map
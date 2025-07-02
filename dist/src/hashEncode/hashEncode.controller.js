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
Object.defineProperty(exports, "__esModule", { value: true });
exports.HashEncodeController = void 0;
const common_1 = require("@nestjs/common");
const hashEncode_service_1 = require("./hashEncode.service");
let HashEncodeController = class HashEncodeController {
    hashEncodeService;
    constructor(hashEncodeService) {
        this.hashEncodeService = hashEncodeService;
    }
    findAll() {
        return this.hashEncodeService.findAll();
    }
};
exports.HashEncodeController = HashEncodeController;
__decorate([
    (0, common_1.Get)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", String)
], HashEncodeController.prototype, "findAll", null);
exports.HashEncodeController = HashEncodeController = __decorate([
    (0, common_1.Controller)('hashEncode'),
    __metadata("design:paramtypes", [hashEncode_service_1.HashEncodeService])
], HashEncodeController);
//# sourceMappingURL=hashEncode.controller.js.map
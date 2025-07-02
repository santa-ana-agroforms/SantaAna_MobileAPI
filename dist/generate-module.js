"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const fs = require("fs");
const path = require("path");
const moduleName = process.argv[2];
if (!moduleName) {
    console.error('❌ Debes proporcionar un nombre de módulo');
    process.exit(1);
}
const className = moduleName.charAt(0).toUpperCase() + moduleName.slice(1);
const dirPath = path.join(__dirname, 'src', moduleName);
if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath);
}
fs.writeFileSync(path.join(dirPath, `${moduleName}.module.ts`), `import { Module } from '@nestjs/common';
import { ${className}Service } from './${moduleName}.service';
import { ${className}Controller } from './${moduleName}.controller';

@Module({
  controllers: [${className}Controller],
  providers: [${className}Service],
})
export class ${className}Module {}
`);
fs.writeFileSync(path.join(dirPath, `${moduleName}.controller.ts`), `import { Controller, Get } from '@nestjs/common';
import { ${className}Service } from './${moduleName}.service';

@Controller('${moduleName}')
export class ${className}Controller {
  constructor(private readonly ${moduleName}Service: ${className}Service) {}

  @Get()
  findAll(): string {
    return this.${moduleName}Service.findAll();
  }
}
`);
fs.writeFileSync(path.join(dirPath, `${moduleName}.service.ts`), `import { Injectable } from '@nestjs/common';

@Injectable()
export class ${className}Service {
  findAll(): string {
    return 'Todos los ${moduleName}';
  }
}
`);
fs.writeFileSync(path.join(dirPath, `${moduleName}.controller.spec.ts`), `import { Test, TestingModule } from '@nestjs/testing';
import { ${className}Controller } from './${moduleName}.controller';
import { ${className}Service } from './${moduleName}.service';

describe('${className}Controller', () => {
  let controller: ${className}Controller;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [${className}Controller],
      providers: [${className}Service],
    }).compile();

    controller = module.get<${className}Controller>(${className}Controller);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
`);
const appModulePath = path.join(__dirname, 'src', 'app.module.ts');
let appModuleContent = fs.readFileSync(appModulePath, 'utf-8');
if (!appModuleContent.includes(`${className}Module`)) {
    const importLine = `import { ${className}Module } from './${moduleName}/${moduleName}.module';\n`;
    appModuleContent = importLine + appModuleContent;
    appModuleContent = appModuleContent.replace('imports: [', `imports: [${className}Module, `);
    fs.writeFileSync(appModulePath, appModuleContent, 'utf-8');
    console.log(`✅ Módulo ${className} generado y agregado a app.module.ts`);
}
else {
    console.log('⚠️ Ya está importado en app.module.ts');
}
//# sourceMappingURL=generate-module.js.map
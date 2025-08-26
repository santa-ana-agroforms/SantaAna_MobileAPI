/* eslint-disable @typescript-eslint/no-unsafe-return */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
// src/forms/forms.controller.ts
import {
  Controller,
  Get,
  Param,
  NotFoundException,
  UseGuards,
} from '@nestjs/common';
import { FormsService } from './forms.service';
import { JwtAuthGuard } from 'src/auth/guards/jwt-auth.guard';
import { AuthUser } from 'src/auth/decorators/auth-user.decorator';
import type { TypeAuthUser } from 'src/auth/decorators/auth-user.decorator';

@Controller('forms')
@UseGuards(JwtAuthGuard)
export class FormsController {
  constructor(private readonly service: FormsService) {}

  // ---- TREE: todos los formularios en estructura jerárquica
  // GET /forms/tree
  @Get('tree')
  async getFormsTreeAll(@AuthUser() user: TypeAuthUser) {
    return this.service.getFormsTreeAllByCategory(user); // => [<form1>, <form2>, ...]
  }

  // ---- FLAT: todos los formularios (resultado plano)
  // GET /forms/flat
  @Get('flat')
  async getFormsFlatAll(@AuthUser() user: TypeAuthUser) {
    return this.service.getFormsFlatAll(user);
  }

  // ---- FLAT: un formulario por ID
  // GET /forms/:id/flat
  @Get(':id/flat')
  async getFormFlatById(@Param('id') id: string) {
    const rows = await this.service.getFormFlatById(id);
    if (!rows?.length) {
      throw new NotFoundException(`Formulario ${id} no encontrado o sin datos`);
    }
    return rows;
  }

  // ---- TREE: un formulario por ID (versión vigente → páginas → campos)
  // GET /forms/:id/tree
  @Get(':id/tree')
  async getFormTreeById(@Param('id') id: string) {
    const tree = await this.service.getFormTreeById(id);
    if (!tree) {
      throw new NotFoundException(`Formulario ${id} no encontrado o sin datos`);
    }
    return tree;
  }
}

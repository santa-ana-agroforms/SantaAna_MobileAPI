// src/forms/forms.controller.ts
import { Controller, Get, Param, NotFoundException } from '@nestjs/common';
import { FormsService } from './forms.service';

@Controller('forms')
export class FormsController {
  constructor(private readonly service: FormsService) {}

  // ---- TREE: todos los formularios en estructura jerárquica
  // GET /forms/tree
  @Get('tree')
  async getFormsTreeAll() {
    return this.service.getFormsTreeAll(); // => [<form1>, <form2>, ...]
  }

  // ---- FLAT: todos los formularios (resultado plano)
  // GET /forms/flat
  @Get('flat')
  async getFormsFlatAll() {
    return this.service.getFormsFlatAll();
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

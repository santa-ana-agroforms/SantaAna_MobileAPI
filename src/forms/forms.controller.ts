// src/forms/forms.controller.ts
import { Controller, Get, UseGuards, Body, Post } from '@nestjs/common';
import { FormsService } from './forms.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { AuthUser } from '../auth/decorators/auth-user.decorator';
import type { TypeAuthUser } from '../auth/decorators/auth-user.decorator';
import { CreateFormEntryDto } from './dto/create-entry.dto';

@Controller('forms')
@UseGuards(JwtAuthGuard)
export class FormsController {
  constructor(private readonly service: FormsService) {}

  // ---- TREE: todos los formularios agrupados por categoría (filtrado por roles del usuario)
  // GET /forms/tree
  @Get('tree')
  async getFormsTreeAll(@AuthUser() user: TypeAuthUser) {
    return this.service.getFormsTreeAllByCategory(user);
  }

  // ---- ENTRIES: crear envío de formulario
  // POST /forms/entries
  @Post('entries')
  async createEntry(
    @Body() dto: CreateFormEntryDto,
    @AuthUser() user: TypeAuthUser,
  ) {
    return this.service.createEntry(dto, user);
  }

  // ---- DATASETS: TODOS los datasets visibles para el usuario
  // GET /forms/datasets
  @Get('datasets')
  async getUserDatasets(@AuthUser() user: TypeAuthUser) {
    return this.service.getUserDatasetsAsTables(user);
  }
}

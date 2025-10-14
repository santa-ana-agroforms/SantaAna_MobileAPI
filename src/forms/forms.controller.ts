// src/forms/forms.controller.ts
import {
  Controller,
  Get,
  Param,
  NotFoundException,
  UseGuards,
  Body,
  Post,
  Query,
} from '@nestjs/common';
import { FormsService } from './forms.service';
import { JwtAuthGuard } from 'src/auth/guards/jwt-auth.guard';
import { AuthUser } from 'src/auth/decorators/auth-user.decorator';
import type { TypeAuthUser } from 'src/auth/decorators/auth-user.decorator';
import { CreateFormEntryDto } from './dto/create-entry.dto';

@Controller('forms')
@UseGuards(JwtAuthGuard)
export class FormsController {
  constructor(private readonly service: FormsService) {}

  // ---- TREE: todos los formularios agrupados por categoría (filtrado por roles del usuario)
  // GET /forms/tree
  @Get('tree')
  async getFormsTreeAll(@AuthUser() user: TypeAuthUser) {
    console.log('FormsController.getFormsTreeAll user:', user);
    return this.service.getFormsTreeAllByCategory(user);
  }

  // ---- TREE: un formulario por ID (filtrado por roles del usuario)
  // GET /forms/:id/tree
  @Get(':id/tree')
  async getFormTreeById(
    @Param('id') id: string,
    @AuthUser() user: TypeAuthUser,
  ) {
    const tree = await this.service.getFormTreeByIdForUser(id, user);
    if (!tree) {
      throw new NotFoundException(`Formulario ${id} no encontrado o sin datos`);
    }
    return tree;
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

  // ---- DATASETS: datasets de un formulario específico (filtrado por roles del usuario)
  // GET /forms/:id/datasets?notFoundWhenEmpty=true|false
  @Get(':id/datasets')
  async getUserDatasetsByForm(
    @Param('id') id: string,
    @AuthUser() user: TypeAuthUser,
    @Query('notFoundWhenEmpty') notFoundWhenEmpty = 'false',
  ) {
    const tables = await this.service.getUserDatasetsAsTables(user, {
      formId: id,
    });

    // Podés exigir 404 si viene vacío para depurar por qué no aparece el dataset
    const require404 =
      String(notFoundWhenEmpty).toLowerCase() === 'true' ||
      notFoundWhenEmpty === '1';

    if (require404 && tables.length === 0) {
      throw new NotFoundException(
        `Sin datasets visibles para el formulario ${id} (verifica visibilidad, campos tipo "dataset" y versión/fuente configuradas).`,
      );
    }

    return tables;
  }
}

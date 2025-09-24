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

  // ---- TREE: todos los formularios en estructura jerárquica (filtrado por roles del usuario)
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
}

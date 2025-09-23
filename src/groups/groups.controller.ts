/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-return */
import {
  Controller,
  Get,
  NotFoundException,
  Param,
  UseGuards,
} from '@nestjs/common';
import { GroupsService } from './groups.service';
import { JwtAuthGuard } from 'src/auth/guards/jwt-auth.guard';
import { AuthUser } from 'src/auth/decorators/auth-user.decorator';
import type { TypeAuthUser } from 'src/auth/decorators/auth-user.decorator';

@Controller('groups')
@UseGuards(JwtAuthGuard)
export class GroupsController {
  constructor(private readonly service: GroupsService) {}

  // GET /groups  → lista de grupos con sus campos (árbol por grupo)
  @Get()
  async getAll(@AuthUser() user: TypeAuthUser) {
    return this.service.getGroupsTreeAll(user);
  }

  // GET /groups/:id  → un grupo con sus campos
  @Get(':id')
  async getOne(@Param('id') id: string, @AuthUser() user: TypeAuthUser) {
    const out = await this.service.getGroupTreeById(id, user);
    if (!out) {
      throw new NotFoundException(`Grupo ${id} no encontrado o sin acceso`);
    }
    return out;
  }
}

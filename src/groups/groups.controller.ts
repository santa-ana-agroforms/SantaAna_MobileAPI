import { Controller, Get, UseGuards } from '@nestjs/common';
import { GroupsService } from './groups.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { AuthUser } from '../auth/decorators/auth-user.decorator';
import type { TypeAuthUser } from '../auth/decorators/auth-user.decorator';

@Controller('groups')
@UseGuards(JwtAuthGuard)
export class GroupsController {
  constructor(private readonly service: GroupsService) {}

  // GET /groups  → lista de grupos con sus campos (árbol por grupo)
  @Get()
  async getAll(@AuthUser() user: TypeAuthUser) {
    return this.service.getGroupsTreeAll(user);
  }
}

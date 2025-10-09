import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { GroupsController } from './groups.controller';
import { GroupsService } from './groups.service';
import { Grupo } from './entities/formularios-grupo.entity';
import { CampoGrupo } from './entities/formularios-campo-grupo.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Grupo, CampoGrupo])],
  controllers: [GroupsController],
  providers: [GroupsService],
  exports: [GroupsService],
})
export class GroupsModule {}

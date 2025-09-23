import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { GroupsController } from './groups.controller';
import { GroupsService } from './groups.service';
import { FormulariosGrupo } from './entities/formularios-grupo.entity';
import { FormulariosCampoGrupo } from './entities/formularios-campo-grupo.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([FormulariosGrupo, FormulariosCampoGrupo]),
  ],
  controllers: [GroupsController],
  providers: [GroupsService],
  exports: [GroupsService],
})
export class GroupsModule {}

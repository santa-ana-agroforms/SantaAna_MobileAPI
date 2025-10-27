import {
  Column,
  Entity,
  JoinColumn,
  OneToMany,
  OneToOne,
  PrimaryColumn,
} from 'typeorm';
import { Campo } from '../../forms/entities';
import { CampoGrupo } from './formularios-campo-grupo.entity';

@Entity({ name: 'formularios_grupo' })
export class Grupo {
  @PrimaryColumn({ type: 'uuid', name: 'id_grupo' })
  idGrupo!: string;

  @Column({ type: 'varchar', length: 150 })
  nombre!: string;

  // ÚNICO + FK a formularios_campo(id_campo)
  @Column({
    type: 'uuid',
    name: 'id_campo_group',
    unique: true,
  })
  idCampoGroup!: string;

  @OneToOne(() => Campo, { onDelete: 'RESTRICT' })
  @JoinColumn({ name: 'id_campo_group', referencedColumnName: 'idCampo' })
  campoGroup!: Campo;

  // Relación a la tabla de unión (campos que pertenecen a este grupo)
  @OneToMany(() => CampoGrupo, (cg) => cg.grupo)
  campos!: CampoGrupo[];
}

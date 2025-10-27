import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
  Unique,
} from 'typeorm';
import { Campo } from '../../forms/entities';
import { Grupo } from './formularios-grupo.entity';

@Entity({ name: 'formularios_campo_grupo' })
@Unique('formularios_campo_grupo_id_grupo_id_campo_3f10fa8b_uniq', [
  'grupoId',
  'campoId',
])
export class CampoGrupo {
  @PrimaryGeneratedColumn({ type: 'bigint', name: 'id' })
  id!: string; // bigint: recomendación manejarlo como string en TS

  @Column({ type: 'uuid', name: 'id_campo' })
  campoId!: string;

  @Column({ type: 'uuid', name: 'id_grupo' })
  grupoId!: string;

  @ManyToOne(() => Campo, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'id_campo', referencedColumnName: 'idCampo' })
  campo!: Campo;

  @ManyToOne(() => Grupo, (g) => g.campos, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'id_grupo', referencedColumnName: 'idGrupo' })
  grupo!: Grupo;
}

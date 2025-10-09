import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
  Unique,
} from 'typeorm';
import { Usuario } from './formularios-usuario.entity';

/**
 * Nota: group_id referencia a auth_group(id) (tabla externa).
 * Aquí lo modelamos como columna integer sin relación TypeORM
 * para evitar dependencias/errores si no mapeás auth_group.
 */
@Entity({ name: 'formularios_usuario_groups' })
@Unique('formularios_usuario_groups_usuario_id_group_id_9443b0e1_uniq', [
  'usuarioId',
  'groupId',
])
export class UsuarioGroup {
  @PrimaryGeneratedColumn({ type: 'bigint', name: 'id' })
  id!: string;

  @Column({ type: 'varchar', length: 50, name: 'usuario_id' })
  usuarioId!: string;

  @Column({ type: 'int', name: 'group_id' })
  groupId!: number;

  @ManyToOne(() => Usuario, (u) => u.groups, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'usuario_id', referencedColumnName: 'nombreUsuario' })
  usuario!: Usuario;
}

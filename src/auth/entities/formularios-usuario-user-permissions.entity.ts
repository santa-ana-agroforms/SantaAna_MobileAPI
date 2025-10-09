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
 * Nota: permission_id referencia a auth_permission(id) (tabla externa).
 * Se modela como integer simple para no depender de esa entidad.
 */
@Entity({ name: 'formularios_usuario_user_permissions' })
@Unique('formularios_usuario_user_usuario_id_permission_id_1403bb32_uniq', [
  'usuarioId',
  'permissionId',
])
export class UsuarioUserPermission {
  @PrimaryGeneratedColumn({ type: 'bigint', name: 'id' })
  id!: string;

  @Column({ type: 'varchar', length: 50, name: 'usuario_id' })
  usuarioId!: string;

  @Column({ type: 'int', name: 'permission_id' })
  permissionId!: number;

  @ManyToOne(() => Usuario, (u) => u.userPermissions, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'usuario_id', referencedColumnName: 'nombreUsuario' })
  usuario!: Usuario;
}

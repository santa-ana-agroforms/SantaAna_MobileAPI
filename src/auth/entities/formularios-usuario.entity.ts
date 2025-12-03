import { Column, Entity, OneToMany, PrimaryColumn } from 'typeorm';
import { UserFormulario } from './formularios-user-formulario.entity';
import { UsuarioGroup } from './formularios-usuario-groups.entity';
import { UsuarioUserPermission } from './formularios-usuario-user-permissions.entity';
import { UserTerminal } from '.';

@Entity({ name: 'formularios_usuario' })
export class Usuario {
  @Column({ type: 'timestamptz', name: 'last_login', nullable: true })
  lastLogin!: Date | null;

  @PrimaryColumn({ type: 'varchar', length: 50, name: 'nombre_usuario' })
  nombreUsuario!: string;

  @Column({ type: 'varchar', length: 100 })
  nombre!: string;

  @Column({ type: 'varchar', length: 254, unique: true })
  correo!: string;

  @Column({ type: 'varchar', length: 128 })
  password!: string;

  @Column({ type: 'boolean' })
  activo!: boolean;

  @Column({ type: 'boolean', name: 'acceso_web' })
  accesoWeb!: boolean;

  @Column({ type: 'boolean', name: 'is_staff' })
  isStaff!: boolean;

  @Column({ type: 'boolean', name: 'is_superuser' })
  isSuperuser!: boolean;

  // Rel: formularios asignados a un usuario
  @OneToMany(() => UserFormulario, (uf) => uf.usuario)
  formularios!: UserFormulario[];

  // Rel: grupos del usuario (FK a auth_group en tabla intermedia)
  @OneToMany(() => UsuarioGroup, (g) => g.usuario)
  groups!: UsuarioGroup[];

  // Rel: permisos del usuario (FK a auth_permission en tabla intermedia)
  @OneToMany(() => UsuarioUserPermission, (p) => p.usuario)
  userPermissions!: UsuarioUserPermission[];

  @OneToMany(() => UserTerminal, (ut) => ut.usuario)
  userTerminals!: UserTerminal[];
}

// user.entity.ts
import { Column, Entity, ManyToMany, JoinTable, PrimaryColumn } from 'typeorm';
import { Role } from './role.entity';

@Entity({ name: 'formularios_usuarios', schema: 'dbo' })
export class User {
  @Column({ type: 'nvarchar', length: 100 })
  nombre!: string;

  @Column({ type: 'nvarchar', length: 20 })
  telefono!: string;

  @Column({ type: 'nvarchar', length: 254, unique: true })
  correo!: string;

  @Column({ type: 'nvarchar', length: 128 })
  contrasena!: string;

  // PK
  @PrimaryColumn({ type: 'nvarchar', length: 30 })
  nombre_de_usuario!: string;

  // ✅ NUEVO: muchos-a-muchos
  @ManyToMany(() => Role, (role) => role.users, { eager: false })
  @JoinTable({
    schema: 'dbo',
    name: 'formularios_rol_user',
    joinColumn: {
      name: 'nombre_de_usuario', // columna FK hacia User
      referencedColumnName: 'nombre_de_usuario',
    },
    inverseJoinColumn: {
      name: 'id_rol', // columna FK hacia Role
      referencedColumnName: 'id',
    },
  })
  roles!: Role[];
}

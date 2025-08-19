// user.entity.ts
import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryColumn,
  ValueTransformer,
} from 'typeorm';
import { Role } from './role.entity';

// Evitar espacios por char(32) de SQL Server
const trimChar: ValueTransformer = {
  to: (v: string | null) => v,
  from: (v: string | null) => (typeof v === 'string' ? v.trim() : v),
};

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
  //nombre_de_usuario
  @PrimaryColumn({ type: 'nvarchar', length: 30 })
  nombre_de_usuario!: string;

  @Column({ name: 'rol_id', type: 'char', length: 32, transformer: trimChar })
  rol_id!: string;

  @ManyToOne(() => Role, (role) => role.users, {
    nullable: false,
    onDelete: 'NO ACTION', // o 'CASCADE' / 'SET NULL' según tu FK
    eager: false,
  })
  @JoinColumn({ name: 'rol_id' })
  rol!: Role;
}

// role.entity.ts
import {
  Column,
  Entity,
  PrimaryColumn,
  ManyToMany,
  ValueTransformer,
} from 'typeorm';
import { User } from './user.entity';

const trimChar: ValueTransformer = {
  to: (v: string | null) => v,
  from: (v: string | null) => (typeof v === 'string' ? v.trim() : v),
};

@Entity({ name: 'formularios_rol', schema: 'dbo' })
export class Role {
  @PrimaryColumn({ type: 'char', length: 32, transformer: trimChar })
  id!: string;

  @Column({ type: 'nvarchar', length: 50 })
  nombre!: string;

  @Column({ type: 'nvarchar', length: 'MAX' })
  descripcion!: string;

  // ✅ Ahora:
  @ManyToMany(() => User, (user) => user.roles, { eager: false })
  users!: User[];
}

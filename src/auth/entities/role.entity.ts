/* eslint-disable @typescript-eslint/no-unsafe-assignment */
// role.entity.ts
import { Column, Entity, OneToMany, PrimaryColumn } from 'typeorm';
import { User } from './user.entity';

@Entity({ name: 'formularios_rol', schema: 'dbo' })
export class Role {
  @PrimaryColumn({ type: 'char', length: 32 })
  id!: string;

  @Column({ type: 'nvarchar', length: 50 })
  nombre!: string;

  // Si tu columna en DB es nvarchar(max), TypeORM no va a tocar el schema si synchronize=false.
  // Podés dejarlo así:
  @Column({ type: 'nvarchar', length: 'MAX' as any })
  descripcion!: string;

  @OneToMany(() => User, (user) => user.rol)
  users!: User[];
}

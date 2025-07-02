// src/auth/entities/permission.entity.ts
import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity('auth_permission')
export class Permission {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column({ name: 'content_type_id' })
  contentTypeId: number;

  @Column()
  codename: string;
}

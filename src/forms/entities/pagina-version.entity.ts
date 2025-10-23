// src/entities/pagina-version.entity.ts
import {
  Column,
  Entity,
  ManyToOne,
  OneToMany,
  PrimaryColumn,
  JoinColumn,
} from 'typeorm';
import { PaginaCampo } from './pagina-campo.entity';
import { Pagina } from './pagina.entity';

@Entity({ name: 'formularios_pagina_version' })
export class PaginaVersion {
  @PrimaryColumn({ type: 'varchar', length: 32, name: 'id_pagina_version' })
  idPaginaVersion!: string;

  @Column({ type: 'timestamptz', name: 'fecha_creacion' })
  fechaCreacion!: Date;

  @Column({ type: 'uuid', name: 'id_pagina', nullable: true })
  idPagina!: string | null;

  @ManyToOne(() => Pagina, (p) => p.versiones, {
    onDelete: 'SET NULL',
    nullable: true,
  })
  @JoinColumn({ name: 'id_pagina', referencedColumnName: 'idPagina' })
  pagina!: Pagina | null;

  // campos por versión de página
  @OneToMany(() => PaginaCampo, (pc) => pc.paginaVersion)
  campos!: PaginaCampo[];
}

import { Column, Entity, OneToMany, PrimaryColumn } from 'typeorm';
import { PaginaVersionLink } from './pagina-version-link.entity';
import { PaginaCampo } from './pagina-campo.entity';

@Entity('dbo.formularios_pagina_version')
export class PaginaVersion {
  @PrimaryColumn({ type: 'varchar', length: 36, name: 'id_pagina_version' })
  idPaginaVersion!: string;

  @Column({ type: 'datetime2', name: 'fecha_creacion' })
  fechaCreacion!: Date;

  // link página ↔ versión de página
  @OneToMany(() => PaginaVersionLink, (pv) => pv.version)
  paginasLink!: PaginaVersionLink[];

  // campos por versión de página
  @OneToMany(() => PaginaCampo, (pc) => pc.paginaVersion)
  campos!: PaginaCampo[];
}

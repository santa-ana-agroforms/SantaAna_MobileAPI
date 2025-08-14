import { Entity, ManyToOne, PrimaryColumn, JoinColumn } from 'typeorm';
import { Pagina } from './pagina.entity';
import { PaginaVersion } from './pagina-version.entity';

@Entity('dbo.formularios_pagina_pagina_version')
export class PaginaVersionLink {
  @PrimaryColumn({ type: 'varchar', length: 36, name: 'id_pagina' })
  paginaId!: string;

  @PrimaryColumn({ type: 'varchar', length: 36, name: 'id_pagina_version' })
  paginaVersionId!: string;

  @ManyToOne(() => Pagina, (p) => p.versionesLink, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'id_pagina', referencedColumnName: 'idPagina' })
  pagina!: Pagina;

  @ManyToOne(() => PaginaVersion, (v) => v.paginasLink, { onDelete: 'CASCADE' })
  @JoinColumn({
    name: 'id_pagina_version',
    referencedColumnName: 'idPaginaVersion',
  })
  version!: PaginaVersion;
}

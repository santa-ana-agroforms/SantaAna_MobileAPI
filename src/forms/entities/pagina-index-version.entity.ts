import { Entity, ManyToOne, PrimaryColumn, JoinColumn, Column } from 'typeorm';
import { FormularioVersion } from './formulario-version.entity';
import { Pagina } from './pagina.entity';

@Entity({ name: 'formularios_pagina_index_version' })
export class PaginaIndexVersion {
  @PrimaryColumn({ type: 'uuid', name: 'id_pagina' })
  paginaId!: string;

  @Column({ type: 'uuid', name: 'id_index_version' })
  indexVersionId!: string;

  @ManyToOne(() => FormularioVersion, (v) => v.paginasLink, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({
    name: 'id_index_version',
    referencedColumnName: 'idIndexVersion',
  })
  version!: FormularioVersion;

  @ManyToOne(() => Pagina, (p) => p.indexVersionLink, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'id_pagina', referencedColumnName: 'idPagina' })
  pagina!: Pagina;
}

import { Column, Entity, JoinColumn, ManyToOne, PrimaryColumn } from 'typeorm';
import { PaginaVersion } from './pagina-version.entity';
import { Campo } from './campo.entity';

@Entity('dbo.formularios_pagina_campo')
export class PaginaCampo {
  @PrimaryColumn({ type: 'varchar', length: 36, name: 'id_pagina_version' })
  paginaVersionId!: string;

  @PrimaryColumn({ type: 'varchar', length: 36, name: 'id_campo' })
  campoId!: string;

  @Column({ type: 'int', name: 'sequence', default: 1 })
  sequence!: number;

  @ManyToOne(() => PaginaVersion, (pv) => pv.campos, { onDelete: 'CASCADE' })
  @JoinColumn({
    name: 'id_pagina_version',
    referencedColumnName: 'idPaginaVersion',
  })
  paginaVersion!: PaginaVersion;

  @ManyToOne(() => Campo, (c) => c.paginas, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'id_campo', referencedColumnName: 'idCampo' })
  campo!: Campo;
}

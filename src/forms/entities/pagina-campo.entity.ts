import {
  Check,
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryColumn,
  Unique,
} from 'typeorm';
import { PaginaVersion } from './pagina-version.entity';
import { Campo } from './campo.entity';

@Entity({ name: 'formularios_pagina_campo' })
@Unique('formularios_pagina_campo_id_campo_id_pagina_versi_bad4d405_uniq', [
  'campoId',
  'paginaVersionId',
])
@Check('sequence >= 0')
export class PaginaCampo {
  @PrimaryColumn({ type: 'uuid', name: 'id_campo' })
  campoId!: string;

  @Column({ type: 'int', name: 'sequence', nullable: true })
  sequence!: number | null;

  @Column({ type: 'varchar', length: 32, name: 'id_pagina_version' })
  paginaVersionId!: string;

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

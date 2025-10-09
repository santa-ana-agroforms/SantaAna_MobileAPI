import {
  Check,
  Column,
  Entity,
  ManyToOne,
  OneToMany,
  PrimaryColumn,
  JoinColumn,
} from 'typeorm';
import { Formulario } from './formulario.entity';
import { FormularioVersion } from './formulario-version.entity';
import { PaginaIndexVersion } from './pagina-index-version.entity';

@Entity({ name: 'formularios_pagina' })
@Check('secuencia >= 0')
export class Pagina {
  @PrimaryColumn({ type: 'uuid', name: 'id_pagina' })
  idPagina!: string;

  @Column({ type: 'int' })
  secuencia!: number;

  @Column({ type: 'varchar', length: 120 })
  nombre!: string;

  @Column({ type: 'text' })
  descripcion!: string;

  @Column({ type: 'uuid', name: 'formulario_id' })
  formularioId!: string;

  @Column({ type: 'uuid', name: 'index_version_id' })
  indexVersionId!: string;

  @ManyToOne(() => Formulario, (f) => f.paginas, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'formulario_id', referencedColumnName: 'id' })
  formulario!: Formulario;

  @ManyToOne(() => FormularioVersion, (v) => v.paginasLink, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({
    name: 'index_version_id',
    referencedColumnName: 'idIndexVersion',
  })
  indexVersion!: FormularioVersion;

  @OneToMany(() => PaginaIndexVersion, (piv) => piv.pagina)
  indexVersionLink!: PaginaIndexVersion[];
}

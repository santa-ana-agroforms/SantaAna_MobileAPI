// src/entities/pagina.entity.ts
import { Check, Column, Entity, OneToMany, PrimaryColumn } from 'typeorm';
import { PaginaIndexVersion } from './pagina-index-version.entity';
import { PaginaVersion } from './pagina-version.entity';

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

  // Enlace a versiones de formulario vía tabla puente
  @OneToMany(() => PaginaIndexVersion, (piv) => piv.pagina)
  indexVersionLink!: PaginaIndexVersion[];

  // Versiones propias de la página (formularios_pagina_version)
  @OneToMany(() => PaginaVersion, (pv) => pv.pagina)
  versiones!: PaginaVersion[];
}

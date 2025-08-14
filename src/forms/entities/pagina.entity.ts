import { Column, Entity, OneToMany, PrimaryColumn } from 'typeorm';
import { PaginaVersionLink } from './pagina-version-link.entity';
import { PaginaIndexVersion } from './pagina-index-version.entity';

@Entity('dbo.formularios_pagina')
export class Pagina {
  @PrimaryColumn({ type: 'varchar', length: 36, name: 'id_pagina' })
  idPagina!: string;

  @Column({ type: 'int', nullable: true })
  secuencia!: number | null;

  @Column({ type: 'nvarchar', length: 255 })
  nombre!: string;

  @Column({ type: 'nvarchar', length: 1000, nullable: true })
  descripcion!: string | null;

  @Column({ type: 'nvarchar', length: 50, name: 'color_fondo', nullable: true })
  colorFondo!: string | null;

  @Column({ type: 'nvarchar', length: 50, name: 'color_texto', nullable: true })
  colorTexto!: string | null;

  // Puente página ↔ versión de página
  @OneToMany(() => PaginaVersionLink, (pv) => pv.pagina)
  versionesLink!: PaginaVersionLink[];

  // Puente versión de formulario ↔ página
  @OneToMany(() => PaginaIndexVersion, (piv) => piv.pagina)
  indexVersionLink!: PaginaIndexVersion[];
}

import { Column, Entity, OneToMany, PrimaryColumn } from 'typeorm';
import { PaginaCampo } from './pagina-campo.entity';

@Entity({ name: 'formularios_pagina_version' })
export class PaginaVersion {
  @PrimaryColumn({ type: 'varchar', length: 32, name: 'id_pagina_version' })
  idPaginaVersion!: string;

  @Column({ type: 'timestamptz', name: 'fecha_creacion' })
  fechaCreacion!: Date;

  // Nota: el esquema define un campo adicional id_pagina (varchar(32)) sin FK explícita
  @Column({ type: 'varchar', length: 32, name: 'id_pagina', nullable: true })
  idPagina!: string | null;

  // campos por versión de página
  @OneToMany(() => PaginaCampo, (pc) => pc.paginaVersion)
  campos!: PaginaCampo[];
}

// src/entities/formulario-version.entity.ts
import { Column, Entity, OneToMany, PrimaryColumn } from 'typeorm';
import { FormularioVersionLink } from './formulario-version-link.entity';
import { PaginaIndexVersion } from './pagina-index-version.entity';

@Entity({ name: 'formularios_formularioindexversion' })
export class FormularioVersion {
  @PrimaryColumn({ type: 'uuid', name: 'id_index_version' })
  idIndexVersion!: string;

  @Column({ type: 'timestamptz', name: 'fecha_creacion' })
  fechaCreacion!: Date;

  // Rel: versión ↔ formulario (tabla puente)
  @OneToMany(() => FormularioVersionLink, (l) => l.version)
  formulariosLink!: FormularioVersionLink[];

  // Rel: versión de formulario ↔ páginas (por tabla puente)
  @OneToMany(() => PaginaIndexVersion, (piv) => piv.version)
  paginasLink!: PaginaIndexVersion[];
}

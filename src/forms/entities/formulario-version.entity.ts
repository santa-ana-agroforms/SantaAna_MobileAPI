import {
  Column,
  Entity,
  ManyToOne,
  OneToMany,
  PrimaryColumn,
  JoinColumn,
} from 'typeorm';
import { Formulario } from './formulario.entity';
import { FormularioVersionLink } from './formulario-version-link.entity';
import { PaginaIndexVersion } from './pagina-index-version.entity';

@Entity({ name: 'formularios_formularioindexversion' })
export class FormularioVersion {
  @PrimaryColumn({ type: 'uuid', name: 'id_index_version' })
  idIndexVersion!: string;

  @Column({ type: 'timestamptz', name: 'fecha_creacion' })
  fechaCreacion!: Date;

  @Column({ type: 'uuid', name: 'formulario_id' })
  formularioId!: string;

  @ManyToOne(() => Formulario, (f) => f.versiones, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'formulario_id', referencedColumnName: 'id' })
  formulario!: Formulario;

  // Rel: versión ↔ formulario (tabla puente adicional)
  @OneToMany(() => FormularioVersionLink, (l) => l.version)
  formulariosLink!: FormularioVersionLink[];

  // Rel: versión de formulario ↔ páginas (por tabla puente)
  @OneToMany(() => PaginaIndexVersion, (piv) => piv.version)
  paginasLink!: PaginaIndexVersion[];
}

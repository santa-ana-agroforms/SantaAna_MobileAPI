import { Entity, ManyToOne, PrimaryColumn, JoinColumn, Column } from 'typeorm';
import { Formulario } from './formulario.entity';
import { FormularioVersion } from './formulario-version.entity';

// Tabla puente redundante entre formulario y versión
@Entity({ name: 'formularios_formularios_index_version' })
export class FormularioVersionLink {
  @PrimaryColumn({ type: 'uuid', name: 'id_index_version' })
  versionId!: string;

  @Column({ type: 'uuid', name: 'id_formulario' })
  formularioId!: string;

  @ManyToOne(() => Formulario, (f) => f.versionesLink, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'id_formulario', referencedColumnName: 'id' })
  formulario!: Formulario;

  @ManyToOne(() => FormularioVersion, (v) => v.formulariosLink, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({
    name: 'id_index_version',
    referencedColumnName: 'idIndexVersion',
  })
  version!: FormularioVersion;
}

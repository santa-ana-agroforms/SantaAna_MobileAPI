import { Entity, ManyToOne, PrimaryColumn, JoinColumn } from 'typeorm';
import { Formulario } from './formulario.entity';
import { FormularioVersion } from './formulario-version.entity';

@Entity('dbo.formularios_formularios_index_version')
export class FormularioVersionLink {
  @PrimaryColumn({ type: 'varchar', length: 36, name: 'id_formulario' })
  formularioId!: string;

  @PrimaryColumn({ type: 'varchar', length: 36, name: 'id_index_version' })
  versionId!: string;

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

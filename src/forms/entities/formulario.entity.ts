import { Column, Entity, OneToMany, PrimaryColumn } from 'typeorm';
import { FormularioVersionLink } from './formulario-version-link.entity';

export enum FormaEnvio {
  EnLineaFueraLinea = 'En Linea/fuera Linea',
}

export enum EstadoFormulario {
  Ingresada = 'Ingresada',
  // agregá otros estados que uses
}

@Entity('dbo.formularios_formulario')
export class Formulario {
  @PrimaryColumn({ type: 'varchar', length: 36 })
  id!: string;

  @Column({ type: 'nvarchar', length: 255 })
  nombre!: string;

  @Column({ type: 'nvarchar', length: 1000, nullable: true })
  descripcion!: string | null;

  @Column({ type: 'bit', name: 'permitir_fotos', default: false })
  permitirFotos!: boolean;

  @Column({ type: 'bit', name: 'permitir_gps', default: false })
  permitirGps!: boolean;

  @Column({ type: 'date', name: 'disponible_desde_fecha', nullable: true })
  disponibleDesdeFecha!: string | null;

  @Column({ type: 'date', name: 'disponible_hasta_fecha', nullable: true })
  disponibleHastaFecha!: string | null;

  @Column({ type: 'nvarchar', length: 100, name: 'estado', nullable: true })
  estado!: EstadoFormulario | null;

  @Column({
    type: 'nvarchar',
    length: 100,
    name: 'forma_envio',
    nullable: true,
  })
  formaEnvio!: FormaEnvio | null;

  @Column({ type: 'bit', name: 'es_publico', default: false })
  esPublico!: boolean;

  @Column({ type: 'bit', name: 'auto_envio', default: false })
  autoEnvio!: boolean;

  @Column({ type: 'varchar', length: 36, name: 'categoria_id', nullable: true })
  categoriaId!: string | null;

  // Rel: uno a muchos con el link a versiones
  @OneToMany(() => FormularioVersionLink, (l) => l.formulario)
  versionesLink!: FormularioVersionLink[];
}

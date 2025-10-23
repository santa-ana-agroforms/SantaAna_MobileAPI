// src/entities/formulario.entity.ts
import { Column, Entity, OneToMany, PrimaryColumn } from 'typeorm';
import { FormularioVersionLink } from './formulario-version-link.entity';

export enum FormaEnvio {
  EnLineaFueraLinea = 'En Linea/fuera Linea',
}

export enum EstadoFormulario {
  Ingresada = 'Ingresada',
  // agrega otros estados que uses
}

@Entity({ name: 'formularios_formulario' })
export class Formulario {
  @PrimaryColumn({ type: 'uuid', name: 'id' })
  id!: string;

  @Column({ type: 'varchar', length: 100 })
  nombre!: string;

  @Column({ type: 'text' })
  descripcion!: string;

  @Column({ type: 'boolean', name: 'permitir_fotos' })
  permitirFotos!: boolean;

  @Column({ type: 'boolean', name: 'permitir_gps' })
  permitirGps!: boolean;

  @Column({ type: 'date', name: 'disponible_desde_fecha' })
  disponibleDesdeFecha!: string;

  @Column({ type: 'date', name: 'disponible_hasta_fecha' })
  disponibleHastaFecha!: string;

  @Column({ type: 'varchar', length: 20 })
  estado!: EstadoFormulario;

  @Column({ type: 'varchar', length: 30, name: 'forma_envio' })
  formaEnvio!: FormaEnvio;

  @Column({ type: 'boolean', name: 'es_publico' })
  esPublico!: boolean;

  @Column({ type: 'boolean', name: 'auto_envio' })
  autoEnvio!: boolean;

  @Column({ type: 'uuid', name: 'categoria_id', nullable: true })
  categoriaId!: string | null;

  @Column({ type: 'int', name: 'periodicidad', nullable: true })
  periodicidad!: number | null;

  // Relación por tabla puente (formularios_formularios_index_version)
  @OneToMany(() => FormularioVersionLink, (l) => l.formulario)
  versionesLink!: FormularioVersionLink[];
}

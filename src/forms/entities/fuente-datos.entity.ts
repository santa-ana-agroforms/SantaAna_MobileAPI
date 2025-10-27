import { Column, Entity, PrimaryColumn } from 'typeorm';

@Entity('formularios_fuente_datos')
export class FuenteDatos {
  @PrimaryColumn('uuid') id!: string;

  @Column({ type: 'varchar', length: 200 }) nombre!: string;
  @Column({ type: 'text' }) descripcion!: string;

  @Column({ name: 'archivo_nombre', type: 'varchar', length: 255 })
  archivoNombre!: string;
  @Column({ name: 'blob_name', type: 'varchar', length: 500 })
  blobName!: string;
  @Column({ name: 'blob_url', type: 'varchar', length: 1000 }) blobUrl!: string;

  @Column({ name: 'tipo_archivo', type: 'varchar', length: 10 })
  tipoArchivo!: string;

  @Column({ type: 'jsonb' }) columnas!: object;
  @Column({ name: 'preview_data', type: 'jsonb' }) previewData!: object;

  @Column({ name: 'fecha_subida', type: 'timestamptz' }) fechaSubida!: Date;

  @Column({ type: 'boolean' }) activo!: boolean;

  // Para no depender de relaciones en E2E, lo dejamos como columna:
  @Column({
    name: 'creado_por_id',
    type: 'varchar',
    length: 50,
    nullable: true,
  })
  creadoPorId!: string | null;
}

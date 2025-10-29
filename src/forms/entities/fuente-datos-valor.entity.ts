import { Column, Entity, Index, PrimaryColumn } from 'typeorm';

@Entity('formularios_fuente_datos_valor')
@Index(['campoId', 'labelText'])
@Index(['campoId', 'keyText'])
export class FuenteDatosValor {
  @PrimaryColumn('uuid') id!: string;

  @Column({ type: 'varchar', length: 200 }) columna!: string;

  @Column({ name: 'key_text', type: 'text', nullable: true }) keyText!:
    | string
    | null;
  @Column({ name: 'label_text', type: 'text' }) labelText!: string;

  @Column({ name: 'valor_raw', type: 'jsonb' }) valorRaw!: object;
  @Column({ name: 'extras', type: 'jsonb' }) extras!: object;

  @Column({ name: 'creado_en', type: 'timestamptz' }) creadoEn!: Date;

  @Column({ name: 'campo_id', type: 'uuid' }) campoId!: string;
  @Column({ name: 'fuente_id', type: 'uuid' }) fuenteId!: string;
}

import { Column, Entity, PrimaryColumn } from 'typeorm';

@Entity('formularios_clase_campo')
export class ClaseCampo {
  @PrimaryColumn({ type: 'varchar', length: 30 }) clase!: string;

  @Column({ type: 'text', nullable: true }) estructura!: string | null;
}

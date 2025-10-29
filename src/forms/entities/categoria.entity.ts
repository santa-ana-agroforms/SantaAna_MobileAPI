import { Column, Entity, PrimaryColumn } from 'typeorm';

@Entity('formularios_categoria')
export class Categoria {
  @PrimaryColumn('uuid') id!: string;

  @Column({ type: 'varchar', length: 100 }) nombre!: string;

  @Column({ type: 'text' }) descripcion!: string;
}

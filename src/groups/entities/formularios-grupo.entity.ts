import { Column, Entity, PrimaryColumn } from 'typeorm';

@Entity({ name: 'formularios_grupo', schema: 'dbo' })
export class FormulariosGrupo {
  @PrimaryColumn({ name: 'id_grupo', type: 'char', length: 32 })
  id_grupo!: string;

  @Column({ name: 'nombre', type: 'nvarchar', length: 100 })
  nombre!: string;

  // Ledger (GENERATED ALWAYS): solo lectura
  @Column({
    name: 'ledger_start_transaction_id',
    type: 'bigint',
    select: false,
  })
  ledger_start_transaction_id!: string;

  @Column({
    name: 'ledger_end_transaction_id',
    type: 'bigint',
    nullable: true,
    select: false,
  })
  ledger_end_transaction_id!: string | null;

  @Column({
    name: 'ledger_start_sequence_number',
    type: 'bigint',
    select: false,
  })
  ledger_start_sequence_number!: string;

  @Column({
    name: 'ledger_end_sequence_number',
    type: 'bigint',
    nullable: true,
    select: false,
  })
  ledger_end_sequence_number!: string | null;
}

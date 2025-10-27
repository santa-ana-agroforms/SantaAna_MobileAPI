import { Column, Entity, Index, PrimaryGeneratedColumn } from 'typeorm';

@Entity('formularios_entry')
@Index(['formId', 'indexVersionId'])
@Index(['idUsuarioId', 'status'])
export class Entry {
  @PrimaryGeneratedColumn('uuid') id!: string;

  @Column({ name: 'id_usuario_id', type: 'text' }) idUsuarioId!: string;
  @Column({ name: 'form_id', type: 'uuid' }) formId!: string;
  @Column({ name: 'index_version_id', type: 'uuid' }) indexVersionId!: string;

  @Column({ name: 'form_name', type: 'text' }) formName!: string;

  @Column({ name: 'filled_at_local', type: 'timestamptz' })
  filledAtLocal!: Date;

  @Column({ type: 'varchar', length: 255, default: 'pending' })
  status!: string;

  @Column({ name: 'fill_json', type: 'jsonb' }) fillJson!: object;
  @Column({ name: 'form_json', type: 'jsonb' }) formJson!: object;

  @Column({ name: 'created_at', type: 'timestamptz', default: () => 'now()' })
  createdAt!: Date;

  @Column({ name: 'updated_at', type: 'timestamptz', default: () => 'now()' })
  updatedAt!: Date;
}

import { Column, Entity, OneToMany, PrimaryColumn } from 'typeorm';
import { PaginaCampo } from './pagina-campo.entity';

export enum TipoCampo {
  date = 'date',
  number = 'number',
  text = 'text',
  boolean = 'boolean',
  img = 'img',
  // agrega los que uses
}

export enum ClaseCampo {
  calculado = 'calculado',
  autorrellenado = 'autorrellenado',
  firma = 'firma',
  // agrega los que uses
}

const jsonTextTransformer = {
  to: (value: Record<string, unknown> | null): string | null => {
    if (value === null || value === undefined) return null;
    try {
      return JSON.stringify(value);
    } catch {
      return null;
    }
  },
  from: (value: string | null): Record<string, unknown> | null => {
    if (value === null || value === undefined || value === '') return null;
    try {
      return JSON.parse(value) as Record<string, unknown>;
    } catch {
      return null;
    }
  },
};

@Entity({ name: 'formularios_campo' })
export class Campo {
  @PrimaryColumn({ type: 'varchar', length: 32, name: 'id_campo' })
  idCampo!: string;

  @Column({ type: 'varchar', length: 20 })
  tipo!: TipoCampo;

  @Column({ type: 'varchar', length: 30 })
  clase!: ClaseCampo;

  @Column({ type: 'varchar', length: 64, name: 'nombre_campo' })
  nombreCampo!: string;

  @Column({ type: 'varchar', length: 100 })
  etiqueta!: string;

  @Column({ type: 'varchar', length: 255, nullable: true })
  ayuda!: string | null;

  // En Postgres, config es TEXT; se serializa/deserializa a JSON en la capa de entidad
  @Column({ type: 'text', nullable: true, transformer: jsonTextTransformer })
  config!: Record<string, unknown> | null;

  @Column({ type: 'boolean', default: false })
  requerido!: boolean;

  @OneToMany(() => PaginaCampo, (pc) => pc.campo)
  paginas!: PaginaCampo[];
}

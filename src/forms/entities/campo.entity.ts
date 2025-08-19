import { Column, Entity, OneToMany, PrimaryColumn } from 'typeorm';
import { PaginaCampo } from './pagina-campo.entity';

export enum TipoCampo {
  date = 'date',
  number = 'number',
  text = 'text',
  boolean = 'boolean',
  img = 'img',
  // agregá los que uses
}

export enum ClaseCampo {
  calculado = 'calculado',
  autorrellenado = 'autorrellenado',
  firma = 'firma',
  number = 'number',
  text = 'text',
  string = 'string',
  boolean = 'boolean',
  // agregá los que uses
}

@Entity('dbo.formularios_campo')
export class Campo {
  @PrimaryColumn({ type: 'varchar', length: 36, name: 'id_campo' })
  idCampo!: string;

  @Column({ type: 'nvarchar', length: 50 })
  tipo!: TipoCampo;

  @Column({ type: 'nvarchar', length: 50 })
  clase!: ClaseCampo;

  @Column({ type: 'nvarchar', length: 100, name: 'nombre_campo' })
  nombreCampo!: string;

  @Column({ type: 'nvarchar', length: 255, nullable: true })
  etiqueta!: string | null;

  @Column({ type: 'nvarchar', length: 500, nullable: true })
  ayuda!: string | null;

  // simple-json guarda como NVARCHAR y TypeORM serializa a object
  @Column({ type: 'simple-json', nullable: true })
  config!: Record<string, unknown> | null;

  @Column({ type: 'bit', default: false })
  requerido!: boolean;

  @OneToMany(() => PaginaCampo, (pc) => pc.campo)
  paginas!: PaginaCampo[];
}

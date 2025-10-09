import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { Formulario } from 'src/forms/entities';
import { Usuario } from './formularios-usuario.entity';

@Entity({ name: 'formularios_user_formulario' })
export class UserFormulario {
  // bigint identity; en JS/TS conviene manejarlo como string
  @PrimaryGeneratedColumn({ type: 'bigint', name: 'id' })
  id!: string;

  @Column({ type: 'uuid', name: 'id_formulario_id' })
  formularioId!: string;

  @Column({ type: 'varchar', length: 50, name: 'id_usuario_id' })
  usuarioId!: string;

  @ManyToOne(() => Formulario, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'id_formulario_id', referencedColumnName: 'id' })
  formulario!: Formulario;

  @ManyToOne(() => Usuario, (u) => u.formularios, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'id_usuario_id', referencedColumnName: 'nombreUsuario' })
  usuario!: Usuario;
}

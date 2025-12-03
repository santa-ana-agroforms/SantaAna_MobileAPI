import {
  Column,
  Entity,
  PrimaryGeneratedColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Usuario } from './formularios-usuario.entity';

@Entity({ name: 'formularios_user_terminal' })
export class UserTerminal {
  @PrimaryGeneratedColumn({ type: 'bigint', name: 'id' })
  id!: string;

  @ManyToOne(() => Usuario, (u) => u.userTerminals, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'nombre_usuario', referencedColumnName: 'nombreUsuario' })
  usuario!: Usuario;

  @Column({ type: 'text', nullable: true })
  terminal_info!: string | null;

  @Column({ type: 'timestamptz', name: 'date', default: () => 'NOW()' })
  date!: Date;
}

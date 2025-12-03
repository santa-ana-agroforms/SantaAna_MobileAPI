import {
  Column,
  Entity,
  PrimaryGeneratedColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Usuario } from './formularios-usuario.entity';

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

@Entity({ name: 'formularios_user_terminal' })
export class UserTerminal {
  @PrimaryGeneratedColumn({ type: 'bigint', name: 'id' })
  id!: string;

  @ManyToOne(() => Usuario, (u) => u.userTerminals, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'nombre_usuario', referencedColumnName: 'nombreUsuario' })
  usuario!: Usuario;

  @Column({ type: 'text', nullable: true, transformer: jsonTextTransformer })
  terminal_info!: Record<string, unknown> | null;
}

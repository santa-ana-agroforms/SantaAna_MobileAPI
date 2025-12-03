import {
  Column,
  Entity,
  PrimaryGeneratedColumn,
  ManyToOne,
  JoinColumn,
  RelationId,
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

  // relación hacia Usuario (no hace falta agregar nada en Usuario)
  @ManyToOne(() => Usuario, { nullable: false })
  @JoinColumn({ name: 'nombre_usuario' })
  usuario!: Usuario;

  // propiedad que contiene el FK (opcional, no necesita @Column)
  @RelationId((ut: UserTerminal) => ut.usuario)
  usuarioId!: string;

  @Column({ type: 'text', nullable: true, transformer: jsonTextTransformer })
  terminalInfo!: Record<string, unknown> | null;
}

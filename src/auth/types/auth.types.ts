export type AuthUser = {
  /** PK de formularios_usuario */
  nombre_usuario: string;
  nombre: string;
  correo: string;
  activo: boolean;
  acceso_web: boolean;
  is_staff: boolean;
  is_superuser: boolean;
  /** IDs numéricos de auth_group */
  groups: number[];
  /** IDs numéricos de auth_permission */
  permissions: number[];
};

export type JwtPayload = {
  /** nombre_usuario del sistema */
  sub: string;
  correo: string;
  is_staff: boolean;
  is_superuser: boolean;
  groups: number[];
};

export type LoginResult = {
  access_token: string;
  token_type: 'Bearer';
  expires_in: number; // segundos
  user: AuthUser;
};

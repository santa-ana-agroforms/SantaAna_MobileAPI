// src/auth/types/auth.types.ts
export type JwtPayload = {
  username: string; // nombre_de_usuario
  rolesId: string[];
  rolesName: string[];
};

export type AuthUser = {
  nombre: string;
  nombre_de_usuario: string;
  roles: { id: string; nombre: string }[];
};

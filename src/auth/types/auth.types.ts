// src/auth/types/auth.types.ts
export type JwtPayload = {
  username: string; // nombre_de_usuario
  roleId: string;
  roleName: string;
};

export type AuthUser = {
  nombre: string;
  nombre_de_usuario: string;
  rol: { id: string; nombre: string };
};

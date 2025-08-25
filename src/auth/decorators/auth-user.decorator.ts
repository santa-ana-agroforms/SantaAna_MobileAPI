/* eslint-disable @typescript-eslint/no-unnecessary-type-assertion */
// src/auth/decorators/auth-user.decorator.ts
import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import type { AuthUser as TypeAuth } from '../types/auth.types';

export const AuthUser = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext): TypeAuth => {
    const req = ctx.switchToHttp().getRequest() as {
      user: TypeAuth;
    };
    return req.user;
  },
);

export type TypeAuthUser = TypeAuth;

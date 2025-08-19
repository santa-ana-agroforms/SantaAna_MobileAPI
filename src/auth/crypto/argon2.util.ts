// src/auth/crypto/argon2.util.ts
import argon2 from 'argon2';

export const hashPassword = async (plain: string): Promise<string> => {
  return argon2.hash(plain, {
    type: argon2.argon2id,
    timeCost: 3,
    memoryCost: 65536, // 64 MiB
    parallelism: 1,
    hashLength: 32,
  });
};

export const verifyPassword = async (
  hashPHC: string,
  plain: string,
): Promise<boolean> => {
  return argon2.verify(hashPHC, plain);
};

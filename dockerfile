# ---------- Stage 1: build ----------
FROM node:22-alpine AS builder

WORKDIR /app

# Instala dependencias del sistema si tu proyecto las necesita (curl opcional para healthcheck)
RUN apk add --no-cache python3 make g++ curl

# Copia package.json/lock primero para cache
COPY package*.json ./

# Instala deps exactas (ci) y compila
RUN npm ci
COPY tsconfig*.json nest-cli.json ./
COPY src ./src
# Si usás Prisma / assets, copia lo necesario aquí también
# COPY prisma ./prisma

RUN npm run build

# ---------- Stage 2: runtime ----------
FROM node:22-alpine AS runner

WORKDIR /app
ENV NODE_ENV=production

# Copiá solo lo mínimo para correr
COPY package*.json ./
RUN npm ci --omit=dev

# Copiá el build
COPY --from=builder /app/dist ./dist

# (Opcional) copiar assets de runtime (views, public, prisma/schema generado, etc.)
# COPY --from=builder /app/prisma ./prisma

# Asegurá no correr como root
RUN addgroup -S app && adduser -S app -G app
USER app

# Koyeb proporciona PORT; exponelo por claridad y fallback local
ARG PORT=3000
ENV PORT=${PORT}
EXPOSE ${PORT}

# Healthcheck barato (opcional si tienes /health)
# HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
#   CMD wget -qO- http://127.0.0.1:${PORT}/health || exit 1

CMD ["node", "dist/main.js"]

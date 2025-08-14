# ---------- Stage 1: build ----------
FROM node:22-alpine AS builder
WORKDIR /app

# Si usás deps nativas, dejar estas toolchains
RUN apk add --no-cache python3 make g++ curl

# Copia manifiestos primero (cache)
COPY package*.json ./

# Si TENÉS package-lock.json en el repo y querés usarlo, podés dejar npm ci;
# si NO tenés, usá npm install:
# RUN npm ci
RUN npm install

# Copia el código
COPY tsconfig*.json nest-cli.json ./
COPY src ./src
# COPY prisma ./prisma   # si aplica

# Compila
RUN npm run build

# Dejar solo deps de producción para el runtime
RUN npm prune --omit=dev


# ---------- Stage 2: runtime ----------
FROM node:22-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production

# Copiá package.json (no vamos a instalar acá)
COPY package*.json ./

# Copiá node_modules ya “pruneado” y el build
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
# COPY --from=builder /app/prisma ./prisma   # si aplica

# Usuario no root
RUN addgroup -S app && adduser -S app -G app
USER app

# Puerto (Koyeb te inyecta PORT)
ARG PORT=3000
ENV PORT=${PORT}
EXPOSE ${PORT}

CMD ["node", "dist/main.js"]

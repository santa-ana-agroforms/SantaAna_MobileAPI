# ---------- Stage 1: build ----------
FROM node:22-alpine AS builder
WORKDIR /app
RUN apk add --no-cache python3 make g++ curl libc6-compat   
# libc6-compat ayuda a sharp
COPY package*.json ./
RUN npm install
COPY tsconfig*.json nest-cli.json ./
COPY src ./src
COPY assets ./assets
COPY test/fixtures ./test/fixtures                
# ← AÑADIR: para que exista en build
RUN npm run build
RUN npm prune --omit=dev

# ---------- Stage 2: runtime ----------
FROM node:22-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV FIXTURES_DIR=/app/dist/fixtures
COPY package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/assets ./assets
COPY --from=builder /app/test/fixtures ./dist/fixtures 

# 👇 Copia los fixtures al runtime
COPY --from=builder /app/test/fixtures ./test/fixtures
# (opcional, también al fallback /app/fixtures)
COPY --from=builder /app/test/fixtures ./fixtures
 
# ← AÑADIR: llevar assets al runtime
RUN addgroup -S app && adduser -S app -G app
USER app
ARG PORT=3000
ENV PORT=${PORT}
EXPOSE ${PORT}
CMD ["node", "dist/main.js"]

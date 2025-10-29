# Santa Ana – Backend móvil para captura de datos en campo (Ingenio Azucarero)

> Backend **NestJS + PostgreSQL** para gestionar **formularios dinámicos** y consolidar capturas **offline-first** desde la app móvil (React Native + SQLite). Incluye **contratos OpenAPI/Swagger**, **envíos idempotentes** y un plan de **pruebas (unitarias, integración, e2e)** más **pruebas de desempeño** con Locust.

[![Node.js](https://img.shields.io/badge/Node.js-20.x-339933)]()
[![NestJS](https://img.shields.io/badge/NestJS-10.x-E0234E)]()
[![TypeScript](https://img.shields.io/badge/TS-5.x-3178C6)]()
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15+-336791)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)]()

---

## TL;DR

- **Problema**: Capturar datos en campo con conectividad intermitente y mantener **integridad, consistencia y disponibilidad**.
- **Solución**: Backend con **contratos claros**, **idempotencia**, catálogo versionado y consolidación en **JSONB**; el cliente móvil guarda en **SQLite** y sincroniza cuando hay señal.
- **Stack**: NestJS (TS), PostgreSQL, Swagger/OpenAPI, Jest + Testcontainers (e2e), Locust para estrés.
- **Evidencia/Contexto**: Diseño y objetivos se alinean con el trabajo de graduación del Ingenio Azucarero. (Ver “Diseño e Implementación del Backend…”).  

---

## Tabla de contenidos

1. [Arquitectura](#arquitectura)
2. [Características clave](#características-clave)
3. [Módulos y contratos](#módulos-y-contratos)
4. [Modelo de datos (resumen)](#modelo-de-datos-resumen)
5. [Requisitos previos](#requisitos-previos)
6. [Configuración](#configuración)
7. [Ejecución local](#ejecución-local)
8. [Pruebas](#pruebas)
9. [Pruebas de desempeño (Locust)](#pruebas-de-desempeño-locust)
10. [CI/CD](#cicd)
11. [Buenas prácticas y seguridad](#buenas-prácticas-y-seguridad)
12. [Contribución y estilo de código](#contribución-y-estilo-de-código)
13. [Licencia](#licencia)

---

## Arquitectura

```
React Native (SQLite)  <--offline-->  Cola de envíos  --(HTTP/JWT)-->  NestJS (API REST)
       |                                                        |
       |                              Swagger / Validación DTOs |  PostgreSQL (JSONB + relacional)
       |                                                        |
       └-- Sesiones de formulario, cursor, datasets locales  <--┴-- Consolidación idempotente
```

- **Cliente móvil**: persiste en **SQLite**, mantiene estado de sesión y envía lotes **idempotentes**.
- **Backend**: **NestJS** con DTOs tipados, **Swagger** y **PostgreSQL** con combinación **relacional + JSONB** para flexibilidad sin perder ACID.  
- **Idempotencia**: el payload de creación de entrada incluye identificadores/versiones para **evitar duplicados** y asegurar **convergencia**.

> Esta arquitectura y alcance están alineados con el documento de tesis (objetivos, alcance, metodología y resultados).  

---

## Características clave

- **Offline-first** extremo a extremo (SQLite en cliente, consolidación en servidor).
- **Catálogo versionado** de formularios y grupos (estructura relacional) + **capturas en JSONB** (estructura aplicada).
- **Envíos idempotentes**: una y solo una entrada por intento válido.
- **Roles y datasets filtrados por usuario**.
- **Contratos OpenAPI/Swagger** publicados para auditoría y consumo.
- **Pruebas**: unitarias/integración/e2e (Jest + Testcontainers) y **estrés** (Locust).
- **CI/CD**: verificación, build y despliegue por etapas (staging → producción).

---

## Módulos y contratos

### Autenticación
- `POST /auth/login` → JWT (Bearer).
- Guards y decoradores para derivar el usuario autenticado en controladores.

### Formularios y versiones
- `GET /forms/tree` → árbol de formularios por **rol** (estructura + páginas + grupos).
- `GET /forms/datasets` → datasets visibles por rol/permiso.
- **Contrato** con DTOs: `form_id`, `index_version_id`, metadatos de páginas/grupos y tipos simples.

### Entradas (capturas)
- `POST /entries` → crear entrada **idempotente**.  
  **Payload base**:
  ```json
  {
    "form_id": "uuid-form",
    "index_version_id": "uuid-version",
    "status": "completed|draft",
    "filled_at_local": "2025-10-26T14:23:11-06:00",
    "fill_json": { /* valores en tipos simples + firma Base64 */ },
    "form_json": { /* fotografía de la estructura aplicada */ }
  }
  ```
- Reglas:
  - Valida vínculo `form_id:index_version_id` y requeridos mínimos (incluidos grupos).
  - En caso de reintento con el mismo identificador lógico, **no duplica**.

### Documentación
- **Swagger UI**: `GET /api`  
- **OpenAPI JSON**: `GET /api-json`

---

## Modelo de datos (resumen)

- **Catálogo** (relacional):  
  - `formularios_*` (formularios, páginas, grupos, clases de campo, categorías, etc.)  
  - versión/índices para rastrear la estructura en uso.
- **Operativo**:  
  - `formularios_entry` (capturas consolidadas): índices por fecha/usuario/formulario, columnas de control y **JSONB** (`fill_json`, `form_json`).

> El almacenamiento operativo en JSONB mantiene flexibilidad; el catálogo relacional garantiza trazabilidad y control.  

---

## Requisitos previos

- Node.js **20.x**
- Yarn **1.x** o **Berry**
- Docker + Docker Compose (para DB local y e2e)
- PostgreSQL **15+** (local o contenedor)
- (Opcional) Python 3.10+ y Locust para pruebas de desempeño

---

## Configuración

Crear `.env` (o usar variables de entorno):

```bash
# App
PORT=3000
NODE_ENV=development

# JWT / Seguridad
JWT_SECRET=super_secret_jwt
JWT_EXPIRES_IN=1d

# Base de datos
DB_HOST=localhost
DB_PORT=5432
DB_USER=santa_ana
DB_PASS=santa_ana
DB_NAME=santa_ana

# CORS
CORS_ORIGIN=http://localhost:5173

# Logs
LOG_LEVEL=debug
```

---

## Ejecución local

```bash
# 1) Instalar
yarn install

# 2) Levantar DB si usás Docker
docker compose up -d db

# 3) Migraciones (si aplica)
yarn migration:run

# 4) Desarrollo
yarn start:dev

# 5) Producción (local)
yarn build && yarn start:prod
```

**Scripts útiles**

```bash
yarn start           # dev simple
yarn start:dev       # watch (Hot Reload)
yarn start:prod      # prod
yarn build           # compila TS
yarn lint            # ESLint
yarn test            # unit/integration
yarn test:e2e        # end-to-end (Testcontainers)
yarn test:cov        # cobertura
yarn migration:run   # (TypeORM/DB)
yarn migration:gen   # (TypeORM/DB)
```

---

## Pruebas

### Unitarias e Integración (Jest)
- Cobertura de **servicios, repositorios y controladores**.
- DTOs validados con `class-validator`/`class-transformer`.

### End-to-End (Jest + Testcontainers)
- Arranca **PostgreSQL** efímero con Testcontainers.
- Semillas mínimas (roles, formulario base).
- Verifica **/auth**, **/forms/tree**, **/forms/datasets** y **/entries** (idempotencia).

```bash
yarn test:e2e
```

> Si estás en Windows, asegurate de tener Docker Desktop activo y WSL2 habilitado.

---

## Pruebas de desempeño (Locust)

1. Crear `locustfile.py` con los escenarios de carga sobre endpoints críticos (`/auth/login`, `/forms/tree`, `/forms/datasets`, `/entries`).
2. Variables recomendadas:
   - **base_url** del API
   - **usuarios concurrentes** y **spawn rate**
   - **peso por endpoint** (distribución realista)
3. Ejecutar:
```bash
locust -H http://localhost:3000
```
4. Métricas a reportar:
   - RPS, latencias p50/p95/p99, tasa de errores, throughput por endpoint.
   - Observaciones de backpressure y uso de CPU/Memoria del contenedor DB/API.

> Estos resultados se integran con el capítulo de **Resultados** del trabajo, contrastando **métricas globales** y **por endpoint**.

---

## CI/CD

- **CI**: Lint + Test + Build; **e2e** con Testcontainers en pipeline.
- **CD**: Despliegue a **staging** y promoción manual a **producción**.
- Artefactos: imagen Docker con `multi-stage build`.
- Recomendado: **migraciones** automáticas en staging y gates para prod.

---

## Buenas prácticas y seguridad

- **JWT** (Bearer) con expiración corta y refresh (si aplica).
- **Helmet**, **CORS** por origen, **rate limiting** a endpoints públicos.
- Validación estricta de **DTOs**; sanitización de entrada.
- **Idempotencia** por contrato (identificadores lógicos y checks únicos).
- **Índices** en `formularios_entry` para lecturas comunes y deduplicación.
- **Logs** estructurados y trazas por request (correlation id).

---

## Contribución y estilo de código

- Estilo **TypeScript estricto**.
- Commits: **Conventional Commits**.
- PRs con checklist: pruebas pasan, cobertura no baja, Swagger actualizado.

---

## Licencia

MIT. Ver archivo `LICENSE`.

---

## Referencias y contexto

- **Trabajo de graduación** (objetivos, alcance, metodología y resultados que fundamentan este repo).  
- **Plantilla y README original** del proyecto NestJS como base técnica.

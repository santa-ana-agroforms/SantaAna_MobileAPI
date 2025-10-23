// src/forms/forms.service.ts
import {
  Injectable,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import type { AuthUser } from 'src/auth/types/auth.types';
import type { CreateFormEntryDto } from './dto/create-entry.dto';

// Tipado del resultado plano (coincide con los alias del SELECT)
export type FormFlatRow = {
  formulario_id: string;
  formulario_nombre: string;
  formulario_index_version_id: string;
  formulario_index_version_fecha: Date;

  // Metadatos de periodicidad y disponibilidad del formulario
  formulario_periodicidad: number | null;
  formulario_disponible_desde: Date | null;
  formulario_disponible_hasta: Date | null;

  // Categoría
  categoria_id: string | null;
  categoria_nombre: string | null;
  categoria_descripcion: string | null;

  pagina_id: string;
  pagina_secuencia: number;
  pagina_nombre: string;
  pagina_descripcion: string | null;

  pagina_version_id: string;
  pagina_version_fecha: Date;

  campo_id: string;
  campo_sequence: number | null;
  campo_tipo: string;
  campo_clase: string;
  campo_nombre_interno: string;
  campo_etiqueta: string;
  campo_ayuda: string | null;
  campo_config: unknown;
  campo_requerido: boolean;
};

// ===== Tipos de retorno para datasets como tablas =====
type DatasetTableRow = {
  key: string | null;
  label: string;
  valor_raw: unknown;
  extras: unknown;
};

export type DatasetTable = {
  campo_id: string;
  nombre_interno: string;
  etiqueta: string;
  fuente_id: string | null;
  version: number | null;
  columna: string | null;
  mode: string | null; // 'pair' | 'list' | otros
  total_items: number;
  rows: DatasetTableRow[];
};

export type DatasetRaw = {
  campo_id: string;
  nombre_interno: string;
  etiqueta: string;
  fuente_id: string | null;
  version: number | null;
  columna: string | null;
  mode: string | null; // 'pair' | 'list' | otros
  total_items: number;
  rows: string; // JSON stringificado
};

const parseJsonSafe = <T = unknown>(val: unknown): unknown => {
  if (val == null) return null;
  if (typeof val !== 'string') return val as T;
  try {
    return JSON.parse(val) as T;
  } catch {
    return val;
  }
};

const toBool = (v: unknown): boolean => {
  if (typeof v === 'boolean') return v;
  if (typeof v === 'number') return v === 1;
  if (typeof v === 'string') {
    const s = v.trim().toLowerCase();
    return s === '1' || s === 'true' || s === 't';
  }
  return false;
};

@Injectable()
export class FormsService {
  constructor(@InjectDataSource() private readonly dataSource: DataSource) {}

  // Constante para "hoy" en Guatemala (solo fecha)
  private readonly todayGT = `(now() at time zone 'America/Guatemala')::date`;

  // ---------------------------------------------
  // SQL base (CTE) para Postgres — NUEVA ESTRUCTURA
  // ---------------------------------------------
  private readonly baseCteSql = `
 WITH ultima_version_form AS (
   SELECT
     ffiv.id_formulario                         AS formulario_id,
     MAX(ff.fecha_creacion)                     AS fecha_max
   FROM formularios_formularios_index_version AS ffiv
   JOIN formularios_formularioindexversion     AS ff
     ON ff.id_index_version = ffiv.id_index_version
   GROUP BY ffiv.id_formulario
 ),
 version_vigente AS (
   SELECT
     ffiv.id_formulario       AS formulario_id,
     ff.id_index_version      AS formulario_index_version_id,
     ff.fecha_creacion        AS formulario_index_version_fecha
   FROM ultima_version_form uv
   JOIN formularios_formularios_index_version ffiv
     ON ffiv.id_formulario = uv.formulario_id
   JOIN formularios_formularioindexversion ff
     ON ff.id_index_version = ffiv.id_index_version
    AND ff.fecha_creacion = uv.fecha_max
 ),
 paginas_de_version AS (
   SELECT
     fpiv.id_index_version,
     fpiv.id_pagina,
     fp.secuencia,
     fp.nombre,
     fp.descripcion
   FROM formularios_pagina_index_version fpiv
   JOIN formularios_pagina fp
     ON fp.id_pagina = fpiv.id_pagina
 ),
 ult_version_pagina AS (
   SELECT
     pv.id_pagina,
     MAX(pv.fecha_creacion) AS fecha_max
   FROM formularios_pagina_version pv
   GROUP BY pv.id_pagina
 )
 SELECT
   f.id                                        AS formulario_id,
   f.nombre                                    AS formulario_nombre,
   v.formulario_index_version_id               AS formulario_index_version_id,
   v.formulario_index_version_fecha            AS formulario_index_version_fecha,

   -- Periodicidad (INTEGER) y ventana de disponibilidad (fechas)
   f.periodicidad                              AS formulario_periodicidad,
   f.disponible_desde_fecha                    AS formulario_disponible_desde,
   f.disponible_hasta_fecha                    AS formulario_disponible_hasta,

   cat.id                                      AS categoria_id,
   cat.nombre                                  AS categoria_nombre,
   cat.descripcion                             AS categoria_descripcion,

   pdv.id_pagina                               AS pagina_id,
   pdv.secuencia                               AS pagina_secuencia,
   pdv.nombre                                  AS pagina_nombre,
   pdv.descripcion                             AS pagina_descripcion,

   fpv.id_pagina_version                       AS pagina_version_id,
   fpv.fecha_creacion                          AS pagina_version_fecha,

   fc.id_campo                                 AS campo_id,
   fpc.sequence                                AS campo_sequence,
   fc.tipo                                     AS campo_tipo,
   fc.clase                                    AS campo_clase,
   fc.nombre_campo                             AS campo_nombre_interno,
   fc.etiqueta                                 AS campo_etiqueta,
   fc.ayuda                                    AS campo_ayuda,
   fc.config                                   AS campo_config,
   COALESCE(fc.requerido, false)               AS campo_requerido
 FROM formularios_formulario f
 JOIN version_vigente v
   ON v.formulario_id = f.id
 LEFT JOIN formularios_categoria cat
   ON cat.id = f.categoria_id
 JOIN paginas_de_version pdv
   ON pdv.id_index_version = v.formulario_index_version_id
 JOIN ult_version_pagina uvp
   ON uvp.id_pagina = pdv.id_pagina
 JOIN formularios_pagina_version fpv
   ON fpv.id_pagina = pdv.id_pagina
  AND fpv.fecha_creacion = uvp.fecha_max
 JOIN formularios_pagina_campo fpc
   ON fpc.id_pagina_version = fpv.id_pagina_version
 JOIN formularios_campo fc
   ON fc.id_campo = fpc.id_campo
`;

  // WHERE de visibilidad (público o asignado por tabla usuario↔formulario)
  // y DISPONIBILIDAD por fechas con la fecha local de Guatemala.
  private readonly visibleForUserWhere = `
 WHERE (
        f.es_publico = true
        OR EXISTS (
          SELECT 1
          FROM formularios_user_formulario uf
          WHERE uf.id_usuario_id::text = $1::text
            AND uf.id_formulario_id::text = f.id::text
        )
      )
  AND f.disponible_desde_fecha <= ${this.todayGT}
  AND f.disponible_hasta_fecha >= ${this.todayGT}
`;

  // ---------------------------------------------
  // PLANO: todos los formularios (filtrado por usuario + disponibilidad)
  // ---------------------------------------------
  getFormsFlatAll = async (user: AuthUser): Promise<FormFlatRow[]> => {
    const sql = `${this.baseCteSql} ${this.visibleForUserWhere} ORDER BY categoria_nombre NULLS LAST, pagina_secuencia, campo_sequence NULLS LAST;`;
    const rows: FormFlatRow[] = await this.dataSource.query(sql, [
      user.nombre_usuario,
    ]);
    return rows;
  };

  // ---------------------------------------------
  // PLANO: un formulario por ID (sin filtro de usuario ni disponibilidad)
  // (útil para administración u obtener metadatos aunque esté fuera de ventana)
  // ---------------------------------------------
  getFormFlatById = async (formId: string): Promise<FormFlatRow[]> => {
    const sql = `${this.baseCteSql} WHERE f.id = $1::uuid ORDER BY categoria_nombre NULLS LAST, pagina_secuencia, campo_sequence NULLS LAST;`;
    const rows: FormFlatRow[] = await this.dataSource.query(sql, [formId]);
    return rows;
  };

  // ---------------------------------------------
  // PLANO: un formulario por ID (filtrado por usuario + disponibilidad)
  // ---------------------------------------------
  getFormFlatByIdForUser = async (
    formId: string,
    user: AuthUser,
  ): Promise<FormFlatRow[]> => {
    const sql = `${this.baseCteSql}
 WHERE f.id = $1::uuid
   AND (
        f.es_publico = true
     OR EXISTS (
          SELECT 1
          FROM formularios_user_formulario uf
          WHERE uf.id_usuario_id::text = $2::text
            AND uf.id_formulario_id::text = f.id::text
        )
   )
   AND f.disponible_desde_fecha <= ${this.todayGT}
   AND f.disponible_hasta_fecha >= ${this.todayGT}
 ORDER BY categoria_nombre NULLS LAST, pagina_secuencia, campo_sequence NULLS LAST;`;

    const rows: FormFlatRow[] = await this.dataSource.query(sql, [
      formId,
      user.nombre_usuario,
    ]);

    return rows;
  };

  // ---------------------------------------------
  // ÁRBOL: un formulario (sin filtro)
  // ---------------------------------------------
  getFormTreeById = async (formId: string) => {
    const flat = await this.getFormFlatById(formId);
    if (flat.length === 0) return null;
    return this.buildTreeFromFlat(flat);
  };

  // ---------------------------------------------
  // ÁRBOL: un formulario (filtrado por usuario + disponibilidad)
  // ---------------------------------------------
  getFormTreeByIdForUser = async (formId: string, user: AuthUser) => {
    const flat = await this.getFormFlatByIdForUser(formId, user);
    if (flat.length === 0) return null;
    return this.buildTreeFromFlat(flat);
  };

  // ---------------------------------------------
  // ÁRBOL: todos los formularios (filtrado por usuario + disponibilidad)
  // ---------------------------------------------
  getFormsTreeAll = async (user: AuthUser) => {
    const flat = await this.getFormsFlatAll(user);
    if (flat.length === 0) return [];
    return this.groupFlatIntoTrees(flat);
  };

  // ---------------------------------------------
  // Árbol agrupado por categoría (filtrado por usuario + disponibilidad)
  // ---------------------------------------------
  getFormsTreeAllByCategory = async (user: AuthUser) => {
    const flat = await this.getFormsFlatAll(user);
    if (flat.length === 0) return [];
    return this.groupFlatByCategory(flat);
  };

  async createEntry(dto: CreateFormEntryDto, user: AuthUser) {
    // 1) el usuario puede ver/usar ese form? (y debe estar disponible hoy en Guatemala)
    const canSql = `
      SELECT 1
      FROM formularios_formulario f
      WHERE f.id = $1::uuid
        AND (
          f.es_publico = true
          OR EXISTS (
            SELECT 1
            FROM formularios_user_formulario uf
            WHERE uf.id_formulario_id::text = f.id::text
              AND uf.id_usuario_id::text    = $2::text
          )
        )
        AND f.disponible_desde_fecha <= ${this.todayGT}
        AND f.disponible_hasta_fecha >= ${this.todayGT}
      LIMIT 1;
    `;
    const can: { length: number } = await this.dataSource.query(canSql, [
      dto.form_id,
      user.nombre_usuario,
    ]);
    if (can.length === 0) {
      throw new ForbiddenException(
        'No tenés permiso o el formulario no está disponible hoy',
      );
    }

    // 2) la versión pertenece al formulario? (ahora por tabla puente)
    const verSql = `
      SELECT 1
      FROM formularios_formularios_index_version
      WHERE id_index_version = $1::uuid
        AND id_formulario    = $2::uuid
      LIMIT 1;
    `;
    const ver: { length: number } = await this.dataSource.query(verSql, [
      dto.index_version_id,
      dto.form_id,
    ]);
    if (ver.length === 0) {
      throw new BadRequestException('index_version_id no pertenece a form_id');
    }

    // 3) insertar (si no mandan filled_at_local, usamos "ahora" de Guatemala)
    const insSql = `
      INSERT INTO formularios_entry (
        id_usuario_id, form_id, form_name, index_version_id,
        filled_at_local, status, fill_json, form_json
      )
      VALUES (
        $1, $2::uuid, $3, $4::uuid,
        COALESCE($5::timestamptz, (now() at time zone 'America/Guatemala')),
        $6, $7::jsonb, $8::jsonb
      )
      RETURNING id, created_at, updated_at;
    `;
    const params = [
      user.nombre_usuario,
      dto.form_id,
      dto.form_name,
      dto.index_version_id,
      dto.filled_at_local ?? null,
      dto.status,
      JSON.stringify(dto.fill_json ?? {}),
      JSON.stringify(dto.form_json ?? {}),
    ];

    const [row]: {
      id: string;
      created_at: Date;
      updated_at: Date;
      status: string;
    }[] = await this.dataSource.query(insSql, params);
    return {
      id: row.id,
      created_at: row.created_at,
      updated_at: row.updated_at,
      status: dto.status,
    };
  }

  // ===== Helpers de armado =====

  private buildTreeFromFlat(flat: FormFlatRow | FormFlatRow[]) {
    const rows = Array.isArray(flat) ? flat : [flat];
    const base = rows[0];

    // Agrupar por página
    type CampoNode = {
      id_campo: string;
      sequence: number | null;
      tipo: string;
      clase: string;
      nombre_interno: string;
      etiqueta: string;
      ayuda: string | null;
      config: unknown;
      requerido: boolean;
    };

    type PaginaNode = {
      id_pagina: string;
      secuencia: number;
      nombre: string;
      descripcion: string | null;
      pagina_version: { id: string; fecha_creacion: Date };
      campos: CampoNode[];
    };

    const paginasMap = new Map<string, PaginaNode>();

    for (const r of rows) {
      if (!paginasMap.has(r.pagina_id)) {
        paginasMap.set(r.pagina_id, {
          id_pagina: r.pagina_id,
          secuencia: r.pagina_secuencia,
          nombre: r.pagina_nombre,
          descripcion: r.pagina_descripcion ?? null,
          pagina_version: {
            id: r.pagina_version_id,
            fecha_creacion: r.pagina_version_fecha,
          },
          campos: [],
        });
      }
      const pg = paginasMap.get(r.pagina_id)!;
      pg.campos.push({
        id_campo: r.campo_id,
        sequence: r.campo_sequence,
        tipo: r.campo_tipo,
        clase: r.campo_clase,
        nombre_interno: r.campo_nombre_interno,
        etiqueta: r.campo_etiqueta,
        ayuda: r.campo_ayuda ?? null,
        config: parseJsonSafe(r.campo_config),
        requerido: toBool(r.campo_requerido),
      });
    }

    const paginas = Array.from(paginasMap.values()).sort((a, b) => {
      if (a.secuencia !== b.secuencia) return a.secuencia - b.secuencia;
      return a.id_pagina.localeCompare(b.id_pagina);
    });
    for (const p of paginas) {
      p.campos.sort((a, b) => {
        if ((a.sequence ?? 0) !== (b.sequence ?? 0)) {
          return (a.sequence ?? 0) - (b.sequence ?? 0);
        }
        return a.id_campo.localeCompare(b.id_campo);
      });
    }

    return {
      id_formulario: base.formulario_id,
      nombre: base.formulario_nombre,
      version_vigente: {
        id_index_version: base.formulario_index_version_id,
        fecha_creacion: base.formulario_index_version_fecha,
      },
      periodicidad: base.formulario_periodicidad ?? null,
      disponibilidad: {
        desde: base.formulario_disponible_desde ?? null,
        hasta: base.formulario_disponible_hasta ?? null,
      },
      paginas,
    };
  }

  private groupFlatIntoTrees(flat: FormFlatRow[]) {
    type CampoNode = {
      id_campo: string;
      sequence: number | null;
      tipo: string;
      clase: string;
      nombre_interno: string;
      etiqueta: string;
      ayuda: string | null;
      config: unknown;
      requerido: boolean;
    };
    type PaginaNode = {
      id_pagina: string;
      secuencia: number;
      nombre: string;
      descripcion: string | null;
      pagina_version: { id: string; fecha_creacion: Date };
      campos: CampoNode[];
    };
    type FormNode = {
      id_formulario: string;
      nombre: string;
      version_vigente: { id_index_version: string; fecha_creacion: Date };
      periodicidad: number | null;
      disponibilidad: { desde: Date | null; hasta: Date | null };
      paginasMap: Map<string, PaginaNode>;
    };

    const formsMap = new Map<string, FormNode>();

    for (const r of flat) {
      if (!formsMap.has(r.formulario_id)) {
        formsMap.set(r.formulario_id, {
          id_formulario: r.formulario_id,
          nombre: r.formulario_nombre,
          version_vigente: {
            id_index_version: r.formulario_index_version_id,
            fecha_creacion: r.formulario_index_version_fecha,
          },
          periodicidad: r.formulario_periodicidad ?? null,
          disponibilidad: {
            desde: r.formulario_disponible_desde ?? null,
            hasta: r.formulario_disponible_hasta ?? null,
          },
          paginasMap: new Map<string, PaginaNode>(),
        });
      }
      const form = formsMap.get(r.formulario_id)!;

      if (!form.paginasMap.has(r.pagina_id)) {
        form.paginasMap.set(r.pagina_id, {
          id_pagina: r.pagina_id,
          secuencia: r.pagina_secuencia,
          nombre: r.pagina_nombre,
          descripcion: r.pagina_descripcion ?? null,
          pagina_version: {
            id: r.pagina_version_id,
            fecha_creacion: r.pagina_version_fecha,
          },
          campos: [],
        });
      }

      const pg = form.paginasMap.get(r.pagina_id)!;
      pg.campos.push({
        id_campo: r.campo_id,
        sequence: r.campo_sequence,
        tipo: r.campo_tipo,
        clase: r.campo_clase,
        nombre_interno: r.campo_nombre_interno,
        etiqueta: r.campo_etiqueta,
        ayuda: r.campo_ayuda ?? null,
        config: parseJsonSafe(r.campo_config),
        requerido: toBool(r.campo_requerido),
      });
    }

    const result = Array.from(formsMap.values()).map((f) => {
      const paginas = Array.from(f.paginasMap.values()).sort((a, b) => {
        if (a.secuencia !== b.secuencia) return a.secuencia - b.secuencia;
        return a.id_pagina.localeCompare(b.id_pagina);
      });
      for (const p of paginas) {
        p.campos.sort((a, b) => {
          if ((a.sequence ?? 0) !== (b.sequence ?? 0)) {
            return (a.sequence ?? 0) - (b.sequence ?? 0);
          }
          return a.id_campo.localeCompare(b.id_campo);
        });
      }
      return {
        id_formulario: f.id_formulario,
        nombre: f.nombre,
        version_vigente: f.version_vigente,
        periodicidad: f.periodicidad,
        disponibilidad: f.disponibilidad,
        paginas,
      };
    });

    result.sort((a, b) => a.id_formulario.localeCompare(b.id_formulario));
    return result;
  }

  // Agrupador por categoría con el shape solicitado
  private groupFlatByCategory(flat: FormFlatRow[]) {
    type CampoNode = {
      id_campo: string;
      sequence: number | null;
      tipo: string;
      clase: string;
      nombre_interno: string;
      etiqueta: string;
      ayuda: string | null;
      config: unknown;
      requerido: boolean;
    };
    type PaginaNode = {
      id_pagina: string;
      secuencia: number;
      nombre: string;
      descripcion: string | null;
      pagina_version: { id: string; fecha_creacion: Date };
      campos: CampoNode[];
    };
    type FormNode = {
      id_formulario: string;
      nombre: string;
      version_vigente: { id_index_version: string; fecha_creacion: Date };
      periodicidad: number | null;
      disponibilidad: { desde: Date | null; hasta: Date | null };
      paginasMap: Map<string, PaginaNode>;
    };
    type CatNode = {
      nombre_categoria: string;
      descripcion: string | null;
      formsMap: Map<string, FormNode>;
    };

    const catMap = new Map<string, CatNode>();

    const keyOf = (r: FormFlatRow) => r.categoria_id ?? '__SIN_CATEGORIA__';
    const nameOf = (r: FormFlatRow) => r.categoria_nombre ?? 'Sin categoría';

    for (const r of flat) {
      const key = keyOf(r);
      if (!catMap.has(key)) {
        catMap.set(key, {
          nombre_categoria: nameOf(r),
          descripcion: r.categoria_descripcion ?? null,
          formsMap: new Map<string, FormNode>(),
        });
      }
      const cat = catMap.get(key)!;

      if (!cat.formsMap.has(r.formulario_id)) {
        cat.formsMap.set(r.formulario_id, {
          id_formulario: r.formulario_id,
          nombre: r.formulario_nombre,
          version_vigente: {
            id_index_version: r.formulario_index_version_id,
            fecha_creacion: r.formulario_index_version_fecha,
          },
          periodicidad: r.formulario_periodicidad ?? null,
          disponibilidad: {
            desde: r.formulario_disponible_desde ?? null,
            hasta: r.formulario_disponible_hasta ?? null,
          },
          paginasMap: new Map<string, PaginaNode>(),
        });
      }
      const form = cat.formsMap.get(r.formulario_id)!;

      if (!form.paginasMap.has(r.pagina_id)) {
        form.paginasMap.set(r.pagina_id, {
          id_pagina: r.pagina_id,
          secuencia: r.pagina_secuencia,
          nombre: r.pagina_nombre,
          descripcion: r.pagina_descripcion ?? null,
          pagina_version: {
            id: r.pagina_version_id,
            fecha_creacion: r.pagina_version_fecha,
          },
          campos: [],
        });
      }
      const pg = form.paginasMap.get(r.pagina_id)!;

      pg.campos.push({
        id_campo: r.campo_id,
        sequence: r.campo_sequence,
        tipo: r.campo_tipo,
        clase: r.campo_clase,
        nombre_interno: r.campo_nombre_interno,
        etiqueta: r.campo_etiqueta,
        ayuda: r.campo_ayuda ?? null,
        config: parseJsonSafe(r.campo_config),
        requerido: toBool(r.campo_requerido),
      });
    }

    const out = Array.from(catMap.values()).map((c) => {
      const formularios = Array.from(c.formsMap.values()).map((f) => {
        const paginas = Array.from(f.paginasMap.values()).sort((a, b) => {
          if (a.secuencia !== b.secuencia) return a.secuencia - b.secuencia;
          return a.id_pagina.localeCompare(b.id_pagina);
        });
        for (const p of paginas) {
          p.campos.sort((a, b) =>
            (a.sequence ?? 0) !== (b.sequence ?? 0)
              ? (a.sequence ?? 0) - (b.sequence ?? 0)
              : a.id_campo.localeCompare(b.id_campo),
          );
        }
        return {
          id_formulario: f.id_formulario,
          nombre: f.nombre,
          version_vigente: f.version_vigente,
          periodicidad: f.periodicidad,
          disponibilidad: f.disponibilidad,
          paginas,
        };
      });

      formularios.sort((a, b) => a.nombre.localeCompare(b.nombre));

      return {
        nombre_categoria: c.nombre_categoria,
        descripcion: c.descripcion,
        formularios,
      };
    });

    out.sort((a, b) => a.nombre_categoria.localeCompare(b.nombre_categoria));
    return out;
  }

  /**
   * Obtiene todos los datasets requeridos por los campos tipo "dataset"
   * visibles para el usuario (formularios públicos o asignados) y los
   * devuelve agrupados como “tablas” por campo.
   */
  getUserDatasetsAsTables = async (
    user: AuthUser,
    opts?: { formId?: string },
  ): Promise<DatasetTable[]> => {
    // 0) Detección de esquema real
    const [versionTableReg]: Array<{ exists: boolean }> =
      await this.dataSource.query(
        `SELECT (to_regclass('public.formularios_fuente_datos_version') IS NOT NULL) AS exists;`,
      );

    const valorCols: Array<{ column_name: string }> =
      await this.dataSource.query(
        `
    SELECT column_name
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name   = 'formularios_fuente_datos_valor';
  `,
      );

    const colset = new Set(valorCols.map((c) => c.column_name));
    const hasVersionId = colset.has('version_id'); // legacy
    const hasFuenteId = colset.has('fuente_id'); // esquema actual
    const hasVersion = colset.has('version'); // si el valor trae version in-line

    // 1) WHERE de visibilidad + disponibilidad (y opcional por form)
    const params: any[] = [user.nombre_usuario];
    const visibleWhereWithOptionalForm =
      this.visibleForUserWhere + (opts?.formId ? ' AND f.id = $2::uuid ' : '');
    if (opts?.formId) params.push(opts.formId);

    // 2) Bloque común (extraer cfg JSON)
    const cteBase = `
    WITH base AS (
      ${this.baseCteSql}
      ${visibleWhereWithOptionalForm}
        AND (
          LOWER(fc.tipo) = 'dataset'
          OR LOWER(fc.clase) = 'dataset'
        )
    ),
    dataset_fields AS (
      SELECT
        b.campo_id,
        b.campo_nombre_interno  AS nombre_interno,
        b.campo_etiqueta        AS etiqueta,
        COALESCE(NULLIF(b.campo_config::text, '')::jsonb, '{}'::jsonb) AS cfg_json
      FROM base b
    ),
    dataset_parsed AS (
      SELECT
        df.campo_id,
        df.nombre_interno,
        df.etiqueta,
        NULLIF(df.cfg_json->'dataset'->>'fuente_id','')::uuid              AS fuente_id,
        NULLIF(df.cfg_json->'dataset'->>'version','')::int                  AS version_conf,
        df.cfg_json->'dataset'->>'column'                                   AS columna_conf,
        COALESCE(NULLIF(df.cfg_json->'dataset'->>'max_items_inline','')::int, 300) AS max_items,
        df.cfg_json->'dataset'->>'mode'                                     AS mode
      FROM dataset_fields df
    )
  `;

    // 3) Construcción de SQL según esquema
    let sql = '';
    if (versionTableReg?.exists && hasVersionId) {
      // ====== MODO A: esquema legacy con tabla de versiones ======
      sql = `
      ${cteBase},
      version_resuelta AS (
        SELECT
          dp.*,
          COALESCE(
            dp.version_conf,
            (SELECT MAX(v.version) FROM formularios_fuente_datos_version v WHERE v.fuente_id = dp.fuente_id)
          ) AS version_resolved
        FROM dataset_parsed dp
        WHERE dp.fuente_id IS NOT NULL
      ),
      versiones AS (
        SELECT
          vr.campo_id,
          vr.nombre_interno,
          vr.etiqueta,
          vr.fuente_id,
          vr.version_resolved,
          vr.columna_conf,
          vr.max_items,
          vr.mode,
          v.id AS version_id
        FROM version_resuelta vr
        JOIN formularios_fuente_datos_version v
          ON v.fuente_id = vr.fuente_id
         AND v.version   = vr.version_resolved
      ),
      valores AS (
        SELECT
          ver.campo_id,
          ver.nombre_interno,
          ver.etiqueta,
          ver.fuente_id,
          ver.version_resolved,
          ver.columna_conf,
          ver.max_items,
          ver.mode,
          val.key_text,
          val.label_text,
          val.valor_raw,
          val.extras,
          ROW_NUMBER() OVER (PARTITION BY ver.campo_id ORDER BY val.label_text ASC) AS rn
        FROM versiones ver
        JOIN formularios_fuente_datos_valor val
          ON val.version_id = ver.version_id
         AND (ver.columna_conf IS NULL OR val.columna = ver.columna_conf)
         AND (val.campo_id IS NULL OR val.campo_id = ver.campo_id)
      )
      SELECT
        campo_id,
        nombre_interno,
        etiqueta,
        fuente_id::text                    AS fuente_id,
        version_resolved                   AS version,
        columna_conf                       AS columna,
        mode,
        COUNT(*) FILTER (WHERE rn <= max_items) AS total_items,
        JSONB_AGG(
          JSONB_BUILD_OBJECT(
            'key',       key_text,
            'label',     label_text,
            'valor_raw', valor_raw,
            'extras',    extras
          ) ORDER BY label_text ASC
        ) FILTER (WHERE rn <= max_items) AS rows
      FROM valores
      GROUP BY
        campo_id, nombre_interno, etiqueta, fuente_id, version_resolved, columna_conf, mode
      ORDER BY nombre_interno ASC, campo_id ASC;
    `;
    } else {
      // ====== MODO B: esquema nuevo (sin tabla de versiones) ======
      const extraCteLatest =
        hasVersion && hasFuenteId
          ? `,
      latest_version AS (
        SELECT
          v.fuente_id,
          v.columna,
          v.campo_id,
          MAX(v.version) AS max_version
        FROM formularios_fuente_datos_valor v
        GROUP BY v.fuente_id, v.columna, v.campo_id
      )
    `
          : '';

      const joinLatest =
        hasVersion && hasFuenteId
          ? `
        LEFT JOIN latest_version lv
          ON lv.fuente_id IS NOT DISTINCT FROM val.fuente_id
         AND lv.columna   IS NOT DISTINCT FROM val.columna
         AND lv.campo_id  IS NOT DISTINCT FROM val.campo_id
      `
          : '';

      const versionPredicate = hasVersion
        ? `
        AND (
          dp.version_conf IS NULL
            ${hasFuenteId ? `AND (lv.max_version IS NULL OR val.version = lv.max_version)` : ''}
          OR (dp.version_conf IS NOT NULL AND val.version = dp.version_conf)
        )
      `
        : '';

      sql = `
      ${cteBase}
      ${extraCteLatest}
      , valores AS (
        SELECT
          dp.campo_id,
          dp.nombre_interno,
          dp.etiqueta,
          dp.fuente_id,
          COALESCE(dp.version_conf, NULL)::int AS version_resolved,
          dp.columna_conf,
          dp.max_items,
          dp.mode,
          val.key_text,
          val.label_text,
          val.valor_raw,
          val.extras,
          ROW_NUMBER() OVER (PARTITION BY dp.campo_id ORDER BY val.label_text ASC) AS rn
        FROM dataset_parsed dp
        JOIN formularios_fuente_datos_valor val
          ON (dp.fuente_id IS NULL OR ${hasFuenteId ? 'val.fuente_id = dp.fuente_id' : 'TRUE'})
         AND (dp.columna_conf IS NULL OR val.columna = dp.columna_conf)
         AND (val.campo_id IS NULL OR val.campo_id = dp.campo_id)
         ${versionPredicate}
        ${joinLatest}
      )
      SELECT
        campo_id,
        nombre_interno,
        etiqueta,
        ${hasFuenteId ? 'fuente_id::text' : 'NULL::text'} AS fuente_id,
        version_resolved                                   AS version,
        columna_conf                                       AS columna,
        mode,
        COUNT(*) FILTER (WHERE rn <= max_items) AS total_items,
        JSONB_AGG(
          JSONB_BUILD_OBJECT(
            'key',       key_text,
            'label',     label_text,
            'valor_raw', valor_raw,
            'extras',    extras
          ) ORDER BY label_text ASC
        ) FILTER (WHERE rn <= max_items) AS rows
      FROM valores
      GROUP BY
        campo_id, nombre_interno, etiqueta, ${hasFuenteId ? 'fuente_id,' : ''} version_resolved, columna_conf, mode
      ORDER BY nombre_interno ASC, campo_id ASC;
    `;
    }

    // 4) Ejecutar y normalizar
    const raw: DatasetRaw[] = await this.dataSource.query(sql, params);

    const out: DatasetTable[] = raw.map((r: DatasetRaw) => {
      const rows =
        typeof r.rows === 'string'
          ? (JSON.parse(r.rows) as DatasetTableRow[])
          : ((r.rows as DatasetTableRow[]) ?? []);
      return {
        campo_id: r.campo_id,
        nombre_interno: r.nombre_interno,
        etiqueta: r.etiqueta,
        fuente_id: r.fuente_id ?? null,
        version:
          r.version !== null && r.version !== undefined
            ? Number(r.version)
            : null,
        columna: r.columna ?? null,
        mode: r.mode ?? null,
        total_items: Number(r.total_items ?? rows.length),
        rows,
      };
    });

    return out;
  };
}

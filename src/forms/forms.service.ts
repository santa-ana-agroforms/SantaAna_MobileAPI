// src/forms/forms.service.ts
import { Injectable } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import type { AuthUser } from 'src/auth/types/auth.types';

// Tipado del resultado plano (coincide con los alias del SELECT)
export type FormFlatRow = {
  formulario_id: string;
  formulario_nombre: string;
  formulario_index_version_id: string;
  formulario_index_version_fecha: Date;

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

  // ---------------------------------------------
  // SQL base (CTE) para Postgres
  // - Usa formularios_formularios_index_version + formularios_formularioindexversion
  //   para resolver la ÚLTIMA versión de formulario por fecha_creacion.
  // - Mapea uuid de pagina a varchar(32) (sin guiones) para vincular pagina_version.
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
paginas_uuid_map AS (
  SELECT
    fp.id_pagina                                  AS pagina_id_uuid,
    REPLACE(fp.id_pagina::text, '-', '')          AS pagina_id_32
  FROM formularios_pagina fp
),
ult_version_pagina AS (
  -- última versión (fecha) por "id_pagina" de 32 caracteres
  SELECT
    p.pagina_id_uuid,
    MAX(fpv.fecha_creacion) AS fecha_max
  FROM formularios_pagina_version fpv
  JOIN paginas_uuid_map p
    ON p.pagina_id_32 = fpv.id_pagina
  GROUP BY p.pagina_id_uuid
)
SELECT
  f.id                                        AS formulario_id,
  f.nombre                                    AS formulario_nombre,
  v.formulario_index_version_id               AS formulario_index_version_id,
  v.formulario_index_version_fecha            AS formulario_index_version_fecha,

  cat.id                                      AS categoria_id,
  cat.nombre                                  AS categoria_nombre,
  cat.descripcion                             AS categoria_descripcion,

  fp.id_pagina                                AS pagina_id,
  fp.secuencia                                AS pagina_secuencia,
  fp.nombre                                   AS pagina_nombre,
  fp.descripcion                              AS pagina_descripcion,

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
JOIN formularios_pagina_index_version fpiv
  ON fpiv.id_index_version = v.formulario_index_version_id
JOIN formularios_pagina fp
  ON fp.id_pagina = fpiv.id_pagina
JOIN ult_version_pagina uvp
  ON uvp.pagina_id_uuid = fp.id_pagina
JOIN formularios_pagina_version fpv
  ON fpv.id_pagina = REPLACE(fp.id_pagina::text, '-', '')
 AND fpv.fecha_creacion = uvp.fecha_max
JOIN formularios_pagina_campo fpc
  ON fpc.id_pagina_version = fpv.id_pagina_version
JOIN formularios_campo fc
  ON fc.id_campo = fpc.id_campo
`;

  // WHERE de visibilidad (público o asignado por tabla usuario↔formulario)
  private readonly visibleForUserWhere = `
WHERE (f.es_publico = true)
   OR EXISTS (
        SELECT 1
        FROM formularios_user_formulario uf
        WHERE uf.id_usuario_id = $1
          AND uf.id_formulario_id = f.id
      )
`;

  // ---------------------------------------------
  // PLANO: todos los formularios (filtrado por usuario)
  // ---------------------------------------------
  getFormsFlatAll = async (user: AuthUser): Promise<FormFlatRow[]> => {
    const sql = `${this.baseCteSql}
${this.visibleForUserWhere}
ORDER BY categoria_nombre NULLS LAST, fp.secuencia, fpc.sequence NULLS LAST;`;
    const rows: FormFlatRow[] = await this.dataSource.query(sql, [
      user.nombre_usuario,
    ]);
    return rows;
  };

  // ---------------------------------------------
  // PLANO: un formulario por ID (sin filtro)
  // ---------------------------------------------
  getFormFlatById = async (formId: string): Promise<FormFlatRow[]> => {
    const sql = `${this.baseCteSql}
WHERE f.id = $1
ORDER BY categoria_nombre NULLS LAST, fp.secuencia, fpc.sequence NULLS LAST;`;
    const rows: FormFlatRow[] = await this.dataSource.query(sql, [formId]);
    return rows;
  };

  // ---------------------------------------------
  // PLANO: un formulario por ID (filtrado por usuario)
  // ---------------------------------------------
  getFormFlatByIdForUser = async (
    formId: string,
    user: AuthUser,
  ): Promise<FormFlatRow[]> => {
    const sql = `${this.baseCteSql}
WHERE f.id = $1
  AND (
        f.es_publico = true
     OR EXISTS (
          SELECT 1
          FROM formularios_user_formulario uf
          WHERE uf.id_usuario_id = $2
            AND uf.id_formulario_id = f.id
        )
  )
ORDER BY categoria_nombre NULLS LAST, fp.secuencia, fpc.sequence NULLS LAST;`;
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
  // ÁRBOL: un formulario (filtrado por usuario)
  // ---------------------------------------------
  getFormTreeByIdForUser = async (formId: string, user: AuthUser) => {
    const flat = await this.getFormFlatByIdForUser(formId, user);
    if (flat.length === 0) return null;
    return this.buildTreeFromFlat(flat);
  };

  // ---------------------------------------------
  // ÁRBOL: todos los formularios (filtrado por usuario)
  // ---------------------------------------------
  getFormsTreeAll = async (user: AuthUser) => {
    const flat = await this.getFormsFlatAll(user);
    if (flat.length === 0) return [];
    return this.groupFlatIntoTrees(flat);
  };

  // ---------------------------------------------
  // Árbol agrupado por categoría (filtrado por usuario)
  // ---------------------------------------------
  getFormsTreeAllByCategory = async (user: AuthUser) => {
    const flat = await this.getFormsFlatAll(user);
    if (flat.length === 0) return [];
    return this.groupFlatByCategory(flat);
  };

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
}

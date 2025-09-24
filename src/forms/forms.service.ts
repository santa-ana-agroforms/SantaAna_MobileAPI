/* eslint-disable @typescript-eslint/no-redundant-type-constituents */
/* eslint-disable @typescript-eslint/no-unsafe-return */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
// src/forms/forms.service.ts
import { Injectable } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import { AuthUser } from 'src/auth/types/auth.types';

// Tipado del resultado plano (coincide con los alias del SELECT)
export type FormFlatRow = {
  formulario_id: string;
  formulario_nombre: string;
  formulario_index_version_id: string;
  formulario_index_version_fecha: Date;

  // 🔽 NUEVO: datos de categoría
  categoria_id: string | null;
  categoria_nombre: string | null;
  categoria_descripcion: string | null;

  pagina_id: string;
  pagina_secuencia: number | null;
  pagina_nombre: string;
  pagina_descripcion: string | null;

  pagina_version_id: string;
  pagina_version_fecha: Date;

  campo_id: string; // <-- viene del SELECT
  campo_sequence: number;
  campo_tipo: string;
  campo_clase: string;
  campo_nombre_interno: string;
  campo_etiqueta: string | null;
  campo_ayuda: string | null;
  campo_config: unknown | null;
  campo_requerido: number | boolean; // lo normalizamos a boolean en TS
};

const parseJsonSafe = (val: unknown) => {
  if (val == null) return null;
  if (typeof val !== 'string') return val as any;
  try {
    return JSON.parse(val);
  } catch {
    return val; // deja el string si no es JSON válido
  }
};

const toBool = (v: unknown) => {
  if (typeof v === 'boolean') return v;
  if (typeof v === 'number') return v === 1;
  if (Buffer.isBuffer(v)) return v.length > 0 && v[0] === 1;
  if (typeof v === 'string') return v === '1' || v.toLowerCase() === 'true';
  return false;
};

@Injectable()
export class FormsService {
  constructor(@InjectDataSource() private readonly dataSource: DataSource) {}

  // ---------------------------------------------
  // SQL base (CTE). Parametrizable con/ sin WHERE
  // ---------------------------------------------
  private readonly baseCteSql = `
WITH ultima_version_form AS (
  SELECT
    ffiv.id_formulario                         AS formulario_id,
    MAX(ff.fecha_creacion)                     AS fecha_max
  FROM dbo.formularios_formularios_index_version AS ffiv
  JOIN dbo.formularios_formularioindexversion     AS ff
    ON ff.id_index_version = ffiv.id_index_version
  GROUP BY ffiv.id_formulario
),
version_vigente AS (
  SELECT
    ffiv.id_formulario       AS formulario_id,
    ff.id_index_version      AS formulario_index_version_id,
    ff.fecha_creacion        AS formulario_index_version_fecha
  FROM ultima_version_form uv
  JOIN dbo.formularios_formularios_index_version ffiv
    ON ffiv.id_formulario = uv.formulario_id
  JOIN dbo.formularios_formularioindexversion ff
    ON ff.id_index_version = ffiv.id_index_version
   AND ff.fecha_creacion = uv.fecha_max
),
ult_version_pagina AS (
  -- última versión de cada página (global por página)
  SELECT
    fp.id_pagina,
    MAX(fpv.fecha_creacion) AS fecha_max
  FROM dbo.formularios_pagina fp
  JOIN dbo.formularios_pagina_version fpv
    ON fpv.id_pagina = fp.id_pagina
  GROUP BY fp.id_pagina
)
SELECT
  f.id                                        AS formulario_id,
  f.nombre                                    AS formulario_nombre,
  v.formulario_index_version_id               AS formulario_index_version_id,
  v.formulario_index_version_fecha            AS formulario_index_version_fecha,

  -- 🔽 NUEVO: datos de categoría
  cat.id                                      AS categoria_id,
  cat.nombre                                  AS categoria_nombre,
  cat.descripcion                             AS categoria_descripcion,

  fp.id_pagina                                AS pagina_id,
  fp.secuencia                                AS pagina_secuencia,
  fp.nombre                                   AS pagina_nombre,
  fp.descripcion                              AS pagina_descripcion,

  fpv.id_pagina_version                       AS pagina_version_id,
  fpv.fecha_creacion                          AS pagina_version_fecha,

  fc.id_campo                                  AS campo_id,
  fpc.sequence                                AS campo_sequence,
  fc.tipo                                     AS campo_tipo,
  fc.clase                                    AS campo_clase,
  fc.nombre_campo                              AS campo_nombre_interno,
  fc.etiqueta                                  AS campo_etiqueta,
  fc.ayuda                                     AS campo_ayuda,
  fc.config                                    AS campo_config,
  -- Normalizar requerido a 0/1 para evitar Buffer/binario(1)
  CASE 
    WHEN TRY_CONVERT(int, fc.requerido) = 1 THEN 1 
    ELSE 0 
  END                                         AS campo_requerido
FROM dbo.formularios_formulario f
JOIN version_vigente v
  ON v.formulario_id = f.id
LEFT JOIN dbo.formularios_categoria cat           -- 🔽 NUEVO
  ON cat.id = f.categoria_id
JOIN dbo.formularios_pagina_index_version fpiv
  ON fpiv.id_index_version = v.formulario_index_version_id
JOIN dbo.formularios_pagina fp
  ON fp.id_pagina = fpiv.id_pagina
JOIN dbo.formularios_pagina_version fpv
  ON fpv.id_pagina = fp.id_pagina
JOIN ult_version_pagina uvp
  ON uvp.id_pagina = fp.id_pagina
 AND uvp.fecha_max = fpv.fecha_creacion
JOIN dbo.formularios_pagina_campo fpc
  ON fpc.id_pagina_version = fpv.id_pagina_version
JOIN dbo.formularios_campo fc
  ON fc.id_campo = fpc.id_campo
`;

  // WHERE de visibilidad (público o asociado por rol del usuario)
  private readonly visibleForUserWhere = `
WHERE (f.es_publico = 1)
   OR EXISTS (
        SELECT 1
        FROM dbo.formularios_rol_formulario rf
        JOIN dbo.formularios_rol_user ru
          ON ru.id_rol = rf.rol_id
        WHERE ru.nombre_usuario = @0
          AND rf.id_formulario = f.id
      )
`;

  // ===========================
  // 🔽 NUEVO: helpers por roles
  // ===========================
  private buildWhereByRoles = (
    roleIds: Array<string | number>,
    opts?: { includePublic?: boolean },
  ) => {
    const includePublic = opts?.includePublic ?? false; // por defecto: ESTRICTO por rol
    if (!roleIds?.length) {
      // Sin roles: o solo públicos o nada
      return {
        where: includePublic ? `WHERE f.es_publico = 1` : `WHERE 1 = 0`,
        params: [] as any[],
      };
    }
    const placeholders = roleIds.map((_, i) => `@${i}`).join(', ');
    const publicClause = includePublic ? ` OR f.es_publico = 1` : ``;
    return {
      where: `
WHERE (
  EXISTS (
    SELECT 1
    FROM dbo.formularios_rol_formulario rf
    WHERE rf.id_formulario = f.id
      AND rf.rol_id IN (${placeholders})     -- OJO: si tu columna es id_rol, cámbiala acá
  )${publicClause}
)
`,
      params: roleIds,
    };
  };

  // ---------------------------------------------
  // PLANO: todos los formularios (filtrado por usuario)
  // ---------------------------------------------
  getFormsFlatAll = async (user: AuthUser): Promise<FormFlatRow[]> => {
    // Preferir roles del objeto user
    const roleIds = Array.isArray((user as any)?.roles)
      ? (user as any).roles
          .map((r: any) => (r?.id != null ? String(r.id) : null))
          .filter((x: any) => x != null)
      : [];

    if (roleIds.length > 0) {
      const built = this.buildWhereByRoles(roleIds, { includePublic: false });
      const sql = `${this.baseCteSql}
${built.where}
ORDER BY categoria_nombre, fp.secuencia, fpc.sequence;`;
      const rows = await this.dataSource.query(sql, built.params);
      return rows as FormFlatRow[];
    }

    // Fallback: nombre_usuario (comportamiento previo)
    const sql = `${this.baseCteSql}
${this.visibleForUserWhere}
ORDER BY categoria_nombre, fp.secuencia, fpc.sequence;`; // 🔽 opcional: categoría primero
    const rows = await this.dataSource.query(sql, [user.nombre_usuario]);
    return rows as FormFlatRow[];
  };

  // ---------------------------------------------
  // PLANO: un formulario por ID (sin filtro)
  // ---------------------------------------------
  getFormFlatById = async (formId: string): Promise<FormFlatRow[]> => {
    const sql = `${this.baseCteSql}
WHERE f.id = @0
ORDER BY categoria_nombre, fp.secuencia, fpc.sequence;`; // 🔽 opcional
    const rows = await this.dataSource.query(sql, [formId]);
    return rows as FormFlatRow[];
  };

  // ---------------------------------------------
  // PLANO: un formulario por ID (filtrado por usuario)
  // ---------------------------------------------
  getFormFlatByIdForUser = async (
    formId: string,
    user: AuthUser,
  ): Promise<FormFlatRow[]> => {
    const roleIds = Array.isArray((user as any)?.roles)
      ? (user as any).roles
          .map((r: any) => (r?.id != null ? String(r.id) : null))
          .filter((x: any) => x != null)
      : [];

    if (roleIds.length > 0) {
      const placeholders = roleIds.map((_, i) => `@${i + 1}`).join(', ');
      const sql = `${this.baseCteSql}
WHERE f.id = @0
  AND EXISTS (
        SELECT 1
        FROM dbo.formularios_rol_formulario rf
        WHERE rf.id_formulario = f.id
          AND rf.rol_id IN (${placeholders})     -- OJO: si tu columna es id_rol, cámbiala acá
      )
ORDER BY categoria_nombre, fp.secuencia, fpc.sequence;`; // 🔽 opcional

      const rows = await this.dataSource.query(sql, [formId, ...roleIds]);
      return rows as FormFlatRow[];
    }

    // Fallback por nombre_usuario (comportamiento previo)
    const sql = `${this.baseCteSql}
WHERE f.id = @0
  AND (
        f.es_publico = 1
     OR EXISTS (
          SELECT 1
          FROM dbo.formularios_rol_formulario rf
          JOIN dbo.formularios_rol_user ru
            ON ru.id_rol = rf.rol_id
          WHERE ru.nombre_usuario = @1
            AND rf.id_formulario = f.id
        )
  )
ORDER BY categoria_nombre, fp.secuencia, fpc.sequence;`; // 🔽 opcional
    const rows = await this.dataSource.query(sql, [
      formId,
      user.nombre_usuario,
    ]);
    return rows as FormFlatRow[];
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
  // 🔽 NUEVO: Árbol agrupado por categoría (filtrado por usuario)
  // ---------------------------------------------
  getFormsTreeAllByCategory = async (user: AuthUser) => {
    const flat = await this.getFormsFlatAll(user);
    if (flat.length === 0) return [];
    return this.groupFlatByCategory(flat);
  };

  // ===== Helpers de armado =====

  private buildTreeFromFlat(flat: FormFlatRow | FormFlatRow[]): any {
    const rows = Array.isArray(flat) ? flat : [flat];
    const base = rows[0];

    // Agrupar por página
    const paginasMap = new Map<
      string,
      {
        id_pagina: string;
        secuencia: number | null;
        nombre: string;
        descripcion: string | null;
        pagina_version: { id: string; fecha_creacion: Date };
        campos: Array<{
          id_campo: string;
          sequence: number;
          tipo: string;
          clase: string;
          nombre_interno: string;
          etiqueta: string | null;
          ayuda: string | null;
          config: unknown | null;
          requerido: boolean;
        }>;
      }
    >();

    for (const r of rows) {
      if (!paginasMap.has(r.pagina_id)) {
        paginasMap.set(r.pagina_id, {
          id_pagina: r.pagina_id,
          secuencia: r.pagina_secuencia ?? null,
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
        etiqueta: r.campo_etiqueta ?? null,
        ayuda: r.campo_ayuda ?? null,
        config: parseJsonSafe(r.campo_config),
        requerido: toBool(r.campo_requerido),
      });
    }

    const paginas = Array.from(paginasMap.values()).sort((a, b) => {
      const sa = a.secuencia ?? 0;
      const sb = b.secuencia ?? 0;
      if (sa !== sb) return sa - sb;
      return a.id_pagina.localeCompare(b.id_pagina);
    });
    for (const p of paginas) {
      p.campos.sort((a, b) => {
        if (a.sequence !== b.sequence) return a.sequence - b.sequence;
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

  private groupFlatIntoTrees = (flat: FormFlatRow[]) => {
    // Agrupar por formulario
    const formsMap = new Map<
      string,
      {
        id_formulario: string;
        nombre: string;
        version_vigente: { id_index_version: string; fecha_creacion: Date };
        paginasMap: Map<string, any>;
      }
    >();

    for (const r of flat) {
      if (!formsMap.has(r.formulario_id)) {
        formsMap.set(r.formulario_id, {
          id_formulario: r.formulario_id,
          nombre: r.formulario_nombre,
          version_vigente: {
            id_index_version: r.formulario_index_version_id,
            fecha_creacion: r.formulario_index_version_fecha,
          },
          paginasMap: new Map(),
        });
      }
      const form = formsMap.get(r.formulario_id)!;

      if (!form.paginasMap.has(r.pagina_id)) {
        form.paginasMap.set(r.pagina_id, {
          id_pagina: r.pagina_id,
          secuencia: r.pagina_secuencia ?? null,
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
        etiqueta: r.campo_etiqueta ?? null,
        ayuda: r.campo_ayuda ?? null,
        config: parseJsonSafe(r.campo_config),
        requerido: toBool(r.campo_requerido),
      });
    }

    // Construir array final ordenado
    const result = Array.from(formsMap.values()).map((f) => {
      const paginas = Array.from(f.paginasMap.values()).sort((a, b) => {
        const sa = a.secuencia ?? 0;
        const sb = b.secuencia ?? 0;
        if (sa !== sb) return sa - sb;
        return a.id_pagina.localeCompare(b.id_pagina);
      });
      for (const p of paginas) {
        p.campos.sort((a, b) => {
          if (a.sequence !== b.sequence) return a.sequence - b.sequence;
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
  };

  // 🔽 NUEVO: agrupador por categoría con el shape solicitado
  private groupFlatByCategory = (flat: FormFlatRow[]) => {
    const catMap = new Map<
      string,
      {
        nombre_categoria: string;
        descripcion: string | null;
        formsMap: Map<
          string,
          {
            id_formulario: string;
            nombre: string;
            version_vigente: { id_index_version: string; fecha_creacion: Date };
            paginasMap: Map<
              string,
              {
                id_pagina: string;
                secuencia: number | null;
                nombre: string;
                descripcion: string | null;
                pagina_version: { id: string; fecha_creacion: Date };
                campos: Array<{
                  id_campo: string;
                  sequence: number;
                  tipo: string;
                  clase: string;
                  nombre_interno: string;
                  etiqueta: string | null;
                  ayuda: string | null;
                  config: unknown | null;
                  requerido: boolean;
                }>;
              }
            >;
          }
        >;
      }
    >();

    const keyOf = (r: FormFlatRow) => r.categoria_id ?? '__SIN_CATEGORIA__';
    const nameOf = (r: FormFlatRow) => r.categoria_nombre ?? 'Sin categoría';

    for (const r of flat) {
      const key = keyOf(r);
      if (!catMap.has(key)) {
        catMap.set(key, {
          nombre_categoria: nameOf(r),
          descripcion: r.categoria_descripcion ?? null,
          formsMap: new Map(),
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
          paginasMap: new Map(),
        });
      }
      const form = cat.formsMap.get(r.formulario_id)!;

      if (!form.paginasMap.has(r.pagina_id)) {
        form.paginasMap.set(r.pagina_id, {
          id_pagina: r.pagina_id,
          secuencia: r.pagina_secuencia ?? null,
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
        etiqueta: r.campo_etiqueta ?? null,
        ayuda: r.campo_ayuda ?? null,
        config: parseJsonSafe(r.campo_config),
        requerido: toBool(r.campo_requerido),
      });
    }

    // Construcción ordenada
    const out = Array.from(catMap.values()).map((c) => {
      const formularios = Array.from(c.formsMap.values()).map((f) => {
        const paginas = Array.from(f.paginasMap.values()).sort((a, b) => {
          const sa = a.secuencia ?? 0;
          const sb = b.secuencia ?? 0;
          if (sa !== sb) return sa - sb;
          return a.id_pagina.localeCompare(b.id_pagina);
        });
        for (const p of paginas) {
          p.campos.sort((a, b) =>
            a.sequence !== b.sequence
              ? a.sequence - b.sequence
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

      // orden opcional por nombre de formulario
      formularios.sort((a, b) => a.nombre.localeCompare(b.nombre));

      return {
        nombre_categoria: c.nombre_categoria,
        descripcion: c.descripcion,
        formularios,
      };
    });

    // orden final por nombre de categoría
    out.sort((a, b) => a.nombre_categoria.localeCompare(b.nombre_categoria));
    return out;
  };
}

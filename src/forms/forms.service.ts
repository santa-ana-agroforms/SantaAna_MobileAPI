/* eslint-disable @typescript-eslint/no-redundant-type-constituents */
/* eslint-disable @typescript-eslint/no-unsafe-return */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
// src/forms/forms.service.ts
import { Injectable } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';

// Tipado del resultado plano (coincide con los alias del SELECT)
export type FormFlatRow = {
  formulario_id: string;
  formulario_nombre: string;
  formulario_index_version_id: string;
  formulario_index_version_fecha: Date;

  pagina_id: string;
  pagina_secuencia: number | null;
  pagina_nombre: string;
  pagina_descripcion: string | null;

  pagina_version_id: string;
  pagina_version_fecha: Date;

  campo_id: string;
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

  fp.id_pagina                                AS pagina_id,
  fp.secuencia                                AS pagina_secuencia,
  fp.nombre                                   AS pagina_nombre,
  fp.descripcion                              AS pagina_descripcion,

  fpv.id_pagina_version                       AS pagina_version_id,
  fpv.fecha_creacion                          AS pagina_version_fecha,


  fpc.sequence                                AS campo_sequence,
  fc.tipo                                     AS campo_tipo,
  fc.clase                                    AS campo_clase,
  fc.nombre_campo                              AS campo_nombre_interno,
  fc.etiqueta                                  AS campo_etiqueta,
  fc.ayuda                                     AS campo_ayuda,
  fc.config                                    AS campo_config,
  -- Normalizar requerido a 0/1 para evitar Buffer
  CASE 
    WHEN TRY_CONVERT(int, fc.requerido) = 1 THEN 1 
    ELSE 0 
  END                                         AS campo_requerido
FROM dbo.formularios_formulario f
JOIN version_vigente v
  ON v.formulario_id = f.id
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

  // ---------------------------------------------
  // PLANO: todos los formularios
  // ---------------------------------------------
  getFormsFlatAll = async (): Promise<FormFlatRow[]> => {
    const sql = `${this.baseCteSql}
ORDER BY
  fp.secuencia,
  fpc.sequence;`;
    const rows = await this.dataSource.query(sql);
    return rows as FormFlatRow[];
  };

  // ---------------------------------------------
  // PLANO: un formulario por ID
  // ---------------------------------------------
  getFormFlatById = async (formId: string): Promise<FormFlatRow[]> => {
    const sql = `${this.baseCteSql}
WHERE f.id = @0
ORDER BY
  fp.secuencia,
  fpc.sequence;`;
    const rows = await this.dataSource.query(sql, [formId]);
    return rows as FormFlatRow[];
  };

  // ---------------------------------------------
  // ÁRBOL: un formulario (form → páginas → campos)
  // ---------------------------------------------
  getFormTreeById = async (formId: string) => {
    const flat = await this.getFormFlatById(formId);
    if (flat.length === 0) return null;

    const base = flat[0];

    // Agrupar por página
    const paginasMap = new Map<
      string,
      {
        id_pagina: string;
        secuencia: number | null;
        nombre: string;
        descripcion: string | null;
        pagina_version: {
          id: string;
          fecha_creacion: Date;
        };
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

    for (const r of flat) {
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

    // Ordenar páginas y campos por sequence (luego por id)
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

    // Estructura final como la que pediste
    const tree = {
      id_formulario: base.formulario_id,
      nombre: base.formulario_nombre,
      version_vigente: {
        id_index_version: base.formulario_index_version_id,
        fecha_creacion: base.formulario_index_version_fecha,
      },
      paginas, // en orden de secuencia
    };

    return tree;
  };

  // ---------------------------------------------
  // ÁRBOL: todos los formularios (array de árboles)
  // ---------------------------------------------
  getFormsTreeAll = async () => {
    const flat = await this.getFormsFlatAll();
    if (flat.length === 0) return [];

    // Agrupar por formulario
    const formsMap = new Map<
      string,
      {
        id_formulario: string;
        nombre: string;
        version_vigente: {
          id_index_version: string;
          fecha_creacion: Date;
        };
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

    // ordenar formularios por id (o por nombre si preferís)
    result.sort((a, b) => a.id_formulario.localeCompare(b.id_formulario));
    return result;
  };
}

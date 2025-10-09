import { Injectable } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import type { AuthUser } from 'src/auth/types/auth.types';

export type GroupFlatRow = {
  id_grupo: string;
  grupo_nombre: string;

  // contexto para ordenación/ubicación
  formulario_id: string;
  pagina_id: string;
  pagina_nombre: string;
  pagina_secuencia: number;

  // campo
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
export class GroupsService {
  constructor(@InjectDataSource() private readonly dataSource: DataSource) {}

  // CTE: última versión por página (enlazando uuid de página con varchar(32) de pagina_version)
  private readonly baseCteSql = `
WITH paginas_uuid_map AS (
  SELECT
    fp.id_pagina                         AS pagina_id_uuid,
    REPLACE(fp.id_pagina::text, '-', '') AS pagina_id_32
  FROM formularios_pagina fp
),
ult_version_pagina AS (
  SELECT
    p.pagina_id_uuid,
    MAX(fpv.fecha_creacion) AS fecha_max
  FROM formularios_pagina_version fpv
  JOIN paginas_uuid_map p
    ON p.pagina_id_32 = fpv.id_pagina
  GROUP BY p.pagina_id_uuid
)
`;

  // Filtro de visibilidad (públicos o asignados al usuario)
  private readonly visibleForUser = `
  (f.es_publico = true)
  OR EXISTS (
      SELECT 1
      FROM formularios_user_formulario uf
     WHERE uf.id_usuario_id = $1
       AND uf.id_formulario_id = f.id
  )
`;

  // Plano de grupos (filtrado por usuario)
  private async getGroupsFlatAll(user: AuthUser): Promise<GroupFlatRow[]> {
    const sql = `
${this.baseCteSql}
SELECT
  g.id_grupo                               AS id_grupo,
  g.nombre                                 AS grupo_nombre,

  f.id                                     AS formulario_id,
  fp.id_pagina                             AS pagina_id,
  fp.nombre                                AS pagina_nombre,
  fp.secuencia                             AS pagina_secuencia,

  fc.id_campo                               AS campo_id,
  fpc.sequence                             AS campo_sequence,
  fc.tipo                                  AS campo_tipo,
  fc.clase                                 AS campo_clase,
  fc.nombre_campo                          AS campo_nombre_interno,
  fc.etiqueta                              AS campo_etiqueta,
  fc.ayuda                                 AS campo_ayuda,
  fc.config                                AS campo_config,
  COALESCE(fc.requerido, false)            AS campo_requerido
FROM formularios_grupo g
JOIN formularios_campo_grupo fcg
  ON fcg.id_grupo = g.id_grupo
JOIN formularios_campo fc
  ON fc.id_campo = fcg.id_campo
-- contexto de página (y orden de campo) a partir de la última versión de la página:
JOIN formularios_pagina_campo fpc
  ON fpc.id_campo = fc.id_campo
JOIN formularios_pagina_version fpv
  ON fpv.id_pagina_version = fpc.id_pagina_version
JOIN formularios_pagina fp
  ON REPLACE(fp.id_pagina::text, '-', '') = fpv.id_pagina
JOIN ult_version_pagina uvp
  ON uvp.pagina_id_uuid = fp.id_pagina
 AND uvp.fecha_max = fpv.fecha_creacion
JOIN formularios_formulario f
  ON f.id = fp.formulario_id
WHERE ${this.visibleForUser}
ORDER BY g.nombre, fp.secuencia, fpc.sequence NULLS LAST, fc.id_campo;
`;
    const rows: GroupFlatRow[] = await this.dataSource.query(sql, [
      user.nombre_usuario,
    ]);
    return rows;
  }

  // Plano de un grupo por id (filtrado por usuario)
  private async getGroupFlatById(
    id_grupo: string,
    user: AuthUser,
  ): Promise<GroupFlatRow[]> {
    const sql = `
${this.baseCteSql}
SELECT
  g.id_grupo                               AS id_grupo,
  g.nombre                                 AS grupo_nombre,

  f.id                                     AS formulario_id,
  fp.id_pagina                             AS pagina_id,
  fp.nombre                                AS pagina_nombre,
  fp.secuencia                             AS pagina_secuencia,

  fc.id_campo                               AS campo_id,
  fpc.sequence                             AS campo_sequence,
  fc.tipo                                  AS campo_tipo,
  fc.clase                                 AS campo_clase,
  fc.nombre_campo                          AS campo_nombre_interno,
  fc.etiqueta                              AS campo_etiqueta,
  fc.ayuda                                 AS campo_ayuda,
  fc.config                                AS campo_config,
  COALESCE(fc.requerido, false)            AS campo_requerido
FROM formularios_grupo g
JOIN formularios_campo_grupo fcg
  ON fcg.id_grupo = g.id_grupo
JOIN formularios_campo fc
  ON fc.id_campo = fcg.id_campo
JOIN formularios_pagina_campo fpc
  ON fpc.id_campo = fc.id_campo
JOIN formularios_pagina_version fpv
  ON fpv.id_pagina_version = fpc.id_pagina_version
JOIN formularios_pagina fp
  ON REPLACE(fp.id_pagina::text, '-', '') = fpv.id_pagina
JOIN ult_version_pagina uvp
  ON uvp.pagina_id_uuid = fp.id_pagina
 AND uvp.fecha_max = fpv.fecha_creacion
JOIN formularios_formulario f
  ON f.id = fp.formulario_id
WHERE g.id_grupo = $1
  AND (${this.visibleForUser})
ORDER BY g.nombre, fp.secuencia, fpc.sequence NULLS LAST, fc.id_campo;
`;
    const rows: GroupFlatRow[] = await this.dataSource.query(sql, [
      id_grupo,
      user.nombre_usuario,
    ]);
    return rows;
  }

  // ---- Árbol: todos los grupos visibles para el usuario
  async getGroupsTreeAll(user: AuthUser) {
    const flat = await this.getGroupsFlatAll(user);
    if (flat.length === 0) return [];
    return this.groupFlatToTree(flat);
  }

  // ---- Árbol: un grupo por id
  async getGroupTreeById(id_grupo: string, user: AuthUser) {
    const flat = await this.getGroupFlatById(id_grupo, user);
    if (flat.length === 0) return null;
    return this.groupFlatToTree(flat)[0];
  }

  // ---- Helper de armado (por grupo)
  private groupFlatToTree(rows: GroupFlatRow[]) {
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
      pagina: { id_pagina: string; nombre: string; secuencia: number };
    };

    type GrupoNode = {
      id_grupo: string;
      nombre: string;
      campos: CampoNode[];
    };

    const gmap = new Map<string, GrupoNode>();

    for (const r of rows) {
      if (!gmap.has(r.id_grupo)) {
        gmap.set(r.id_grupo, {
          id_grupo: r.id_grupo,
          nombre: r.grupo_nombre,
          campos: [],
        });
      }
      const g = gmap.get(r.id_grupo)!;
      g.campos.push({
        id_campo: r.campo_id,
        sequence: r.campo_sequence,
        tipo: r.campo_tipo,
        clase: r.campo_clase,
        nombre_interno: r.campo_nombre_interno,
        etiqueta: r.campo_etiqueta,
        ayuda: r.campo_ayuda ?? null,
        config: parseJsonSafe(r.campo_config),
        requerido: toBool(r.campo_requerido),
        pagina: {
          id_pagina: r.pagina_id,
          nombre: r.pagina_nombre,
          secuencia: r.pagina_secuencia,
        },
      });
    }

    // ordenar campos por (secuencia de página, secuencia de campo, id)
    for (const g of gmap.values()) {
      g.campos.sort((a, b) => {
        const pa = a.pagina.secuencia ?? 0;
        const pb = b.pagina.secuencia ?? 0;
        if (pa !== pb) return pa - pb;
        if ((a.sequence ?? 0) !== (b.sequence ?? 0)) {
          return (a.sequence ?? 0) - (b.sequence ?? 0);
        }
        return a.id_campo.localeCompare(b.id_campo);
      });
    }

    // salida ordenada por nombre de grupo
    return Array.from(gmap.values()).sort((a, b) =>
      a.nombre.localeCompare(b.nombre),
    );
  }
}

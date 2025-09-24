/* eslint-disable @typescript-eslint/no-redundant-type-constituents */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-return */
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
  pagina_secuencia: number | null;

  // campo
  campo_id: string;
  campo_sequence: number;
  campo_tipo: string;
  campo_clase: string;
  campo_nombre_interno: string;
  campo_etiqueta: string | null;
  campo_ayuda: string | null;
  campo_config: unknown | null;
  campo_requerido: number | boolean | Buffer | string;
};

const parseJsonSafe = (val: unknown) => {
  if (val == null) return null;
  if (typeof val !== 'string') return val as any;
  try {
    return JSON.parse(val);
  } catch {
    return val;
  }
};

const toBool = (v: unknown) => {
  if (typeof v === 'boolean') return v;
  if (typeof v === 'number') return v === 1;
  if (typeof v === 'string') return v === '1' || v.toLowerCase() === 'true';
  if (Buffer.isBuffer(v)) return v.length > 0 && v[0] === 1;
  return false;
};

@Injectable()
export class GroupsService {
  constructor(@InjectDataSource() private readonly dataSource: DataSource) {}

  // CTE para "última versión de cada página" (los grupos NO versionan, pero
  // necesitamos la versión vigente de la página para saber el set/orden de campos)
  private readonly baseCteSql = `
WITH ult_version_pagina AS (
  SELECT
    fp.id_pagina,
    MAX(fpv.fecha_creacion) AS fecha_max
  FROM dbo.formularios_pagina fp
  JOIN dbo.formularios_pagina_version fpv
    ON fpv.id_pagina = fp.id_pagina
  GROUP BY fp.id_pagina
)
`;

  // Filtro de visibilidad (formularios públicos o asignados por rol del usuario)
  private readonly visibleForUser = `
  (f.es_publico = 1)
  OR EXISTS (
      SELECT 1
      FROM dbo.formularios_rol_formulario rf
      JOIN dbo.formularios_rol_user ru
        ON ru.id_rol = rf.rol_id
     WHERE ru.nombre_usuario = @0
       AND rf.id_formulario = f.id
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
  fp.secuencia                              AS pagina_secuencia,

  fc.id_campo                               AS campo_id,
  fpc.sequence                             AS campo_sequence,
  fc.tipo                                  AS campo_tipo,
  fc.clase                                 AS campo_clase,
  fc.nombre_campo                           AS campo_nombre_interno,
  fc.etiqueta                               AS campo_etiqueta,
  fc.ayuda                                  AS campo_ayuda,
  fc.config                                 AS campo_config,
  CASE WHEN TRY_CONVERT(int, fc.requerido) = 1 THEN 1 ELSE 0 END AS campo_requerido
FROM dbo.formularios_grupo g
JOIN dbo.formularios_campo_grupo fcg
  ON fcg.id_grupo = g.id_grupo
JOIN dbo.formularios_campo fc
  ON fc.id_campo = fcg.id_campo
-- necesitamos el contexto de página (y orden de campo) vía la última versión de la página:
JOIN dbo.formularios_pagina_campo fpc
  ON fpc.id_campo = fc.id_campo
JOIN dbo.formularios_pagina_version fpv
  ON fpv.id_pagina_version = fpc.id_pagina_version
JOIN ult_version_pagina uvp
  ON uvp.id_pagina = fpv.id_pagina
 AND uvp.fecha_max = fpv.fecha_creacion
JOIN dbo.formularios_pagina fp
  ON fp.id_pagina = fpv.id_pagina
JOIN dbo.formularios_formulario f
  ON f.id = fp.formulario_id
WHERE ${this.visibleForUser}
ORDER BY g.nombre, fp.secuencia, fpc.sequence, fc.id_campo;
`;
    const rows = await this.dataSource.query(sql, [user.nombre_usuario]);
    return rows as GroupFlatRow[];
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
  fp.secuencia                              AS pagina_secuencia,

  fc.id_campo                               AS campo_id,
  fpc.sequence                             AS campo_sequence,
  fc.tipo                                  AS campo_tipo,
  fc.clase                                 AS campo_clase,
  fc.nombre_campo                           AS campo_nombre_interno,
  fc.etiqueta                               AS campo_etiqueta,
  fc.ayuda                                  AS campo_ayuda,
  fc.config                                 AS campo_config,
  CASE WHEN TRY_CONVERT(int, fc.requerido) = 1 THEN 1 ELSE 0 END AS campo_requerido
FROM dbo.formularios_grupo g
JOIN dbo.formularios_campo_grupo fcg
  ON fcg.id_grupo = g.id_grupo
JOIN dbo.formularios_campo fc
  ON fc.id_campo = fcg.id_campo
JOIN dbo.formularios_pagina_campo fpc
  ON fpc.id_campo = fc.id_campo
JOIN dbo.formularios_pagina_version fpv
  ON fpv.id_pagina_version = fpc.id_pagina_version
JOIN ult_version_pagina uvp
  ON uvp.id_pagina = fpv.id_pagina
 AND uvp.fecha_max = fpv.fecha_creacion
JOIN dbo.formularios_pagina fp
  ON fp.id_pagina = fpv.id_pagina
JOIN dbo.formularios_formulario f
  ON f.id = fp.formulario_id
WHERE g.id_grupo = @0
  AND (${this.visibleForUser})
ORDER BY g.nombre, fp.secuencia, fpc.sequence, fc.id_campo;
`;
    const rows = await this.dataSource.query(sql, [
      id_grupo,
      user.nombre_usuario,
    ]);
    return rows as GroupFlatRow[];
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
    const gmap = new Map<
      string,
      {
        id_grupo: string;
        nombre: string;
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
          pagina: {
            id_pagina: string;
            nombre: string;
            secuencia: number | null;
          };
        }>;
      }
    >();

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
        etiqueta: r.campo_etiqueta ?? null,
        ayuda: r.campo_ayuda ?? null,
        config: parseJsonSafe(r.campo_config),
        requerido: toBool(r.campo_requerido),
        pagina: {
          id_pagina: r.pagina_id,
          nombre: r.pagina_nombre,
          secuencia: r.pagina_secuencia ?? null,
        },
      });
    }

    // ordenar campos por (secuencia de página, secuencia de campo, id)
    for (const g of gmap.values()) {
      g.campos.sort((a, b) => {
        const pa = a.pagina.secuencia ?? 0;
        const pb = b.pagina.secuencia ?? 0;
        if (pa !== pb) return pa - pb;
        if (a.sequence !== b.sequence) return a.sequence - b.sequence;
        return a.id_campo.localeCompare(b.id_campo);
      });
    }

    // salida ordenada por nombre de grupo
    return Array.from(gmap.values()).sort((a, b) =>
      a.nombre.localeCompare(b.nombre),
    );
  }
}

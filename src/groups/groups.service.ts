// src/groups/groups.service.ts
import { Injectable } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import type { AuthUser } from '../auth/types/auth.types';
import { transform } from '@swc/core';
import type { Options, Output, JscConfig, ModuleConfig } from '@swc/core';

export type GroupFlatRow = {
  id_grupo: string;
  grupo_nombre: string;

  // contexto para ordenación/ubicación
  formulario_id: string;
  pagina_id: string;
  pagina_nombre: string;
  pagina_secuencia: number;

  // campo (HIJO del grupo)
  campo_id: string;
  campo_sequence: number | null; // usaremos la sequence del grupo para ordenar a sus hijos en la página
  campo_tipo: string;
  campo_clase: string;
  campo_nombre_interno: string;
  campo_etiqueta: string;
  campo_ayuda: string | null;
  campo_config: unknown;
  campo_requerido: boolean;
};

export type GroupCampoNode = {
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

export type GroupNode = {
  id_grupo: string;
  nombre: string;
  campos: GroupCampoNode[];
};

type TranspileEvalResult = {
  code: string;
  engine: 'swc';
  success: boolean;
  error?: string;
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

  // ---------------------------------------------
  // CTE base:
  // - versión vigente del formulario por fecha_creacion
  // - páginas asociadas a esa versión
  // - última versión de cada página (por fecha_creacion)
  // ---------------------------------------------
  private readonly baseCteSql = `
WITH ultima_version_form AS (
  SELECT
    ffiv.id_formulario                 AS formulario_id,
    MAX(ff.fecha_creacion)             AS fecha_max
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
`;

  /**
   * Filtro de visibilidad (públicos o asignados al usuario),
   * parametrizable para usar $1, $2, etc. según el query.
   */
  private visibleForUserSql = (paramIndex: number) => `
  (f.es_publico = true)
  OR EXISTS (
      SELECT 1
      FROM formularios_user_formulario uf
     WHERE uf.id_usuario_id::text    = $${paramIndex}::text
       AND uf.id_formulario_id::text = f.id::text
  )
`;

  // Plano de grupos (filtrado por usuario)
  private async getGroupsFlatAll(user: AuthUser): Promise<GroupFlatRow[]> {
    const sql = `
${this.baseCteSql},
/* Campos de clase 'group' colocados en páginas + ID de grupo desde su config */
group_fields AS (
  SELECT
    f.id                 AS formulario_id,
    pdv.id_pagina        AS pagina_id,
    pdv.nombre           AS pagina_nombre,
    pdv.secuencia        AS pagina_secuencia,
    fpc.sequence         AS grupo_sequence,
    cgrp.id_campo        AS id_campo_group,
    /* UUID del grupo en config: admite 'id_group' o 'id_grupo' */
    COALESCE(
      NULLIF((COALESCE(NULLIF(cgrp.config::text,'')::jsonb,'{}'::jsonb)->>'id_group'),'')::uuid,
      NULLIF((COALESCE(NULLIF(cgrp.config::text,'')::jsonb,'{}'::jsonb)->>'id_grupo'),'')::uuid
    )                   AS id_grupo_cfg
  FROM formularios_formulario f
  JOIN version_vigente v
    ON v.formulario_id = f.id
  JOIN paginas_de_version pdv
    ON pdv.id_index_version = v.formulario_index_version_id
  JOIN ult_version_pagina uvp
    ON uvp.id_pagina = pdv.id_pagina
  JOIN formularios_pagina_version fpv
    ON fpv.id_pagina = pdv.id_pagina
   AND fpv.fecha_creacion = uvp.fecha_max
  JOIN formularios_pagina_campo fpc
    ON fpc.id_pagina_version = fpv.id_pagina_version
  JOIN formularios_campo cgrp
    ON cgrp.id_campo = fpc.id_campo
   AND LOWER(cgrp.clase) = 'group'
  WHERE ${this.visibleForUserSql(1)}
)
SELECT
  g.id_grupo                         AS id_grupo,
  g.nombre                           AS grupo_nombre,

  gf.formulario_id                   AS formulario_id,
  gf.pagina_id                       AS pagina_id,
  gf.pagina_nombre                   AS pagina_nombre,
  gf.pagina_secuencia                AS pagina_secuencia,

  /* Hijos del grupo */
  fc.id_campo                        AS campo_id,
  gf.grupo_sequence                  AS campo_sequence,
  fc.tipo                            AS campo_tipo,
  fc.clase                           AS campo_clase,
  fc.nombre_campo                    AS campo_nombre_interno,
  fc.etiqueta                        AS campo_etiqueta,
  fc.ayuda                           AS campo_ayuda,
  fc.config                          AS campo_config,
  COALESCE(fc.requerido, false)      AS campo_requerido
FROM group_fields gf
JOIN formularios_grupo g
  ON g.id_grupo = gf.id_grupo_cfg              -- unimos por el id del JSON del campo group
JOIN formularios_campo_grupo fcg
  ON fcg.id_grupo = g.id_grupo
JOIN formularios_campo fc
  ON fc.id_campo = fcg.id_campo
ORDER BY g.nombre, gf.pagina_secuencia, gf.grupo_sequence NULLS LAST, fc.id_campo;
`;
    // console.log('GroupsService.getGroupsFlatAll SQL:', sql);
    const rows: GroupFlatRow[] = await this.dataSource.query(sql, [
      user.nombre_usuario,
    ]);
    // console.log('GroupsService.getGroupsFlatAll rows:', rows);
    return rows;
  }

  // Plano de un grupo por id (filtrado por usuario)
  private async getGroupFlatById(
    id_grupo: string,
    user: AuthUser,
  ): Promise<GroupFlatRow[]> {
    const sql = `
${this.baseCteSql},
group_fields AS (
  SELECT
    f.id                 AS formulario_id,
    pdv.id_pagina        AS pagina_id,
    pdv.nombre           AS pagina_nombre,
    pdv.secuencia        AS pagina_secuencia,
    fpc.sequence         AS grupo_sequence,
    cgrp.id_campo        AS id_campo_group,
    COALESCE(
      NULLIF((COALESCE(NULLIF(cgrp.config::text,'')::jsonb,'{}'::jsonb)->>'id_group'),'')::uuid,
      NULLIF((COALESCE(NULLIF(cgrp.config::text,'')::jsonb,'{}'::jsonb)->>'id_grupo'),'')::uuid
    )                   AS id_grupo_cfg
  FROM formularios_formulario f
  JOIN version_vigente v
    ON v.formulario_id = f.id
  JOIN paginas_de_version pdv
    ON pdv.id_index_version = v.formulario_index_version_id
  JOIN ult_version_pagina uvp
    ON uvp.id_pagina = pdv.id_pagina
  JOIN formularios_pagina_version fpv
    ON fpv.id_pagina = pdv.id_pagina
   AND fpv.fecha_creacion = uvp.fecha_max
  JOIN formularios_pagina_campo fpc
    ON fpc.id_pagina_version = fpv.id_pagina_version
  JOIN formularios_campo cgrp
    ON cgrp.id_campo = fpc.id_campo
   AND LOWER(cgrp.clase) = 'group'
  WHERE ${this.visibleForUserSql(2)}  -- aquí el usuario es $2, porque $1 es el id_grupo del WHERE externo
)
SELECT
  g.id_grupo                         AS id_grupo,
  g.nombre                           AS grupo_nombre،

  gf.formulario_id                   AS formulario_id,
  gf.pagina_id                       AS pagina_id,
  gf.pagina_nombre                   AS pagina_nombre,
  gf.pagina_secuencia                AS pagina_secuencia,

  fc.id_campo                        AS campo_id,
  gf.grupo_sequence                  AS campo_sequence,
  fc.tipo                            AS campo_tipo,
  fc.clase                           AS campo_clase,
  fc.nombre_campo                    AS campo_nombre_interno,
  fc.etiqueta                        AS campo_etiqueta,
  fc.ayuda                           AS campo_ayuda,
  fc.config                          AS campo_config,
  COALESCE(fc.requerido, false)      AS campo_requerido
FROM group_fields gf
JOIN formularios_grupo g
  ON g.id_grupo = gf.id_grupo_cfg
JOIN formularios_campo_grupo fcg
  ON fcg.id_grupo = g.id_grupo
JOIN formularios_campo fc
  ON fc.id_campo = fcg.id_campo
WHERE g.id_grupo = $1::uuid
ORDER BY g.nombre, gf.pagina_secuencia, gf.grupo_sequence NULLS LAST, fc.id_campo;
`;
    const rows: GroupFlatRow[] = await this.dataSource.query(sql, [
      id_grupo,
      user.nombre_usuario,
    ]);

    // console.log('GroupsService.getGroupFlatById rows:', rows);
    return rows;
  }

  // ---- Árbol: todos los grupos visibles para el usuario
  async getGroupsTreeAll(user: AuthUser) {
    const flat = await this.getGroupsFlatAll(user);
    // console.log('GroupsService.getGroupsTreeAll flat:', flat);
    if (flat.length === 0) return [];
    const trees = this.groupFlatToTree(flat);
    await this.postProcessCalcInGroupTrees(trees);
    return trees;
  }

  // ---- Árbol: un grupo por id
  async getGroupTreeById(id_grupo: string, user: AuthUser) {
    const flat = await this.getGroupFlatById(id_grupo, user);
    if (flat.length === 0) return null;
    const tree = this.groupFlatToTree(flat)[0];
    await this.postProcessCalcInGroupTree(tree);
    return tree;
  }

  // ---- Helper de armado (por grupo)
  private groupFlatToTree(rows: GroupFlatRow[]): GroupNode[] {
    const gmap = new Map<string, GroupNode>();

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
        sequence: r.campo_sequence, // heredamos sequence del campo del grupo en la página
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

    // ordenar campos por (secuencia de página, secuencia heredada del grupo, id)
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

  // ============================================================
  // =================== CALC POST-PROCESADO ====================
  // ============================================================

  private isCalcField = (
    field: Pick<GroupCampoNode, 'clase' | 'tipo'>,
  ): boolean => {
    const clase = String(field?.clase ?? '').toLowerCase();
    const tipo = String(field?.tipo ?? '').toLowerCase();
    return clase === 'calc' || tipo === 'calc';
  };

  private getOperationFromConfig = (cfg: unknown): string | null => {
    if (typeof cfg === 'string') return cfg;
    if (typeof cfg === 'object' && cfg !== null) {
      const obj = cfg as Record<string, unknown>;
      const direct = obj['operation'];
      if (typeof direct === 'string') return direct;
      const calc = obj['calc'];
      if (typeof calc === 'object' && calc !== null) {
        const op = (calc as Record<string, unknown>)['operation'];
        if (typeof op === 'string') return op;
      }
    }
    return null;
  };

  private setOperationInConfig = (
    cfgRef: unknown,
    compiled: string,
  ): Record<string, unknown> => {
    const out: Record<string, unknown> =
      typeof cfgRef === 'object' && cfgRef !== null
        ? { ...(cfgRef as Record<string, unknown>) }
        : {};
    if (Object.prototype.hasOwnProperty.call(out, 'operation')) {
      out['operation'] = compiled;
      return out;
    }
    const calc =
      typeof out['calc'] === 'object' && out['calc'] !== null
        ? { ...(out['calc'] as Record<string, unknown>) }
        : {};
    calc['operation'] = compiled;
    out['calc'] = calc;
    return out;
  };

  private transpileModuleForHermesEval = async (
    tsCode: string,
    swcOptions?: Partial<Options>,
  ): Promise<TranspileEvalResult> => {
    try {
      const jsc: JscConfig = {
        parser: { syntax: 'typescript', tsx: false, decorators: true },
        target: 'es2019',
        externalHelpers: true,
        ...(swcOptions?.jsc ?? {}),
      };

      const userModule: ModuleConfig | undefined = swcOptions?.module;

      const moduleRest: Omit<ModuleConfig, 'type'> = userModule
        ? (() => {
            const m = { ...userModule } as Record<string, unknown>;
            delete m.type;
            return m as Omit<ModuleConfig, 'type'>;
          })()
        : ({} as Omit<ModuleConfig, 'type'>);

      const moduleCfg: ModuleConfig = {
        strictMode: false,
        noInterop: true,
        ...moduleRest,
        type: 'commonjs',
      };

      const transformOptions: Options = {
        ...swcOptions,
        jsc,
        module: moduleCfg,
        isModule: swcOptions?.isModule ?? true,
        sourceMaps: swcOptions?.sourceMaps ?? false,
        minify: swcOptions?.minify ?? false,
      };

      const { code: cjs }: Output = await transform(tsCode, transformOptions);

      const wrapped = `(function(){var module={exports:{}},exports=module.exports;
${cjs}
return (module.exports && Object.keys(module.exports).length ? module.exports : exports);
})()`;

      return { code: wrapped, success: true, engine: 'swc' };
    } catch (e: unknown) {
      const message =
        e instanceof Error
          ? e.message
          : typeof e === 'string'
            ? e
            : JSON.stringify(e);
      return {
        code: '',
        success: false,
        engine: 'swc',
        error: message,
      };
    }
  };

  private compileCalcOperationOrEmpty = async (
    tsCode: string,
  ): Promise<string> => {
    try {
      const res = await this.transpileModuleForHermesEval(tsCode, {
        module: { type: 'commonjs', strictMode: false, noInterop: true },
        jsc: {
          parser: { syntax: 'typescript', tsx: false, decorators: true },
          target: 'es2019',
          externalHelpers: false,
        },
        isModule: true,
        sourceMaps: false,
        minify: false,
      });
      return res.success ? res.code : '';
    } catch {
      return '';
    }
  };

  private async postProcessCalcInGroupTree(group: GroupNode): Promise<void> {
    if (!group?.campos) return;
    await Promise.all(
      group.campos.map(async (campo) => {
        if (!this.isCalcField(campo)) return;
        const opTs = this.getOperationFromConfig(campo.config);
        if (!opTs) {
          campo.config = this.setOperationInConfig(campo.config, '');
          return;
        }
        const compiled = await this.compileCalcOperationOrEmpty(opTs);
        campo.config = this.setOperationInConfig(campo.config, compiled);
      }),
    );
  }

  private async postProcessCalcInGroupTrees(
    groups: GroupNode[],
  ): Promise<void> {
    await Promise.all(groups.map((g) => this.postProcessCalcInGroupTree(g)));
  }
}

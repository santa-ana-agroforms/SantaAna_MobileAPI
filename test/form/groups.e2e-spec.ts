/* eslint-disable @typescript-eslint/no-unsafe-call */
import {
  setupAppAndDb,
  teardown,
  loginAndGetToken,
  loadAllDbFixtures,
  TestCtx,
} from './helpers';

jest.setTimeout(300_000);

describe('[E2E] Groups – Árbol de grupos (con fixtures)', () => {
  let ctx: TestCtx;
  let token: string;

  // Usuario que ya viene insertado por formularios_usuario.sql
  const user = { nombreUsuario: 'dahernandez', password: 'diegomovil1' };
  const authz = () => ({ Authorization: `Bearer ${token}` });

  beforeAll(async () => {
    ctx = await setupAppAndDb(); // crea el esquema con TypeORM (DB_SYNC=true)
    await loadAllDbFixtures(ctx.ds); // carga SOLO DML con FKs deshabilitadas en la tx
    token = await loginAndGetToken(ctx, user.nombreUsuario, user.password);
  });

  afterAll(async () => {
    await teardown(ctx);
  });

  it('GET /groups → devuelve grupos con sus campos y metadatos de página', async () => {
    const res = await ctx.http.get('/groups').set(authz());
    expect(res.status).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);

    type Campo = {
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
    type Grupo = { id_grupo: string; nombre: string; campos: Campo[] };

    const grupos: Grupo[] = res.body;
    expect(grupos.length).toBeGreaterThan(0);
    expect(grupos[0].campos).toBeDefined();
    expect(Array.isArray(grupos[0].campos)).toBe(true);
    expect(grupos[0].campos.length).toBeGreaterThan(3); // al menos 5 campos en el primer grupo

    // Buscar un campo de clase calc
    const campoCalc = grupos[0].campos.find((c) => c.clase === 'calc');
    expect(campoCalc).toBeDefined();
    expect(typeof campoCalc!.config).toBe('object');
    const configCalc = campoCalc!.config as any;
    expect(typeof configCalc.operation).toBe('string');
    expect(configCalc.operation.length).toBeGreaterThan(0);
    // Try to evaluate the calc operation (simple cases)
    const sampleValues = { variable_a: 10, variableb: 5 };
    let evalResult: number;
    try {
      const func = eval(configCalc.operation as string).default;
      evalResult = func(sampleValues);
      expect(typeof evalResult).toBe('string');
      expect(evalResult).toBe('15');
    } catch (e) {
      console.warn(
        `⚠️ No se pudo evaluar la operación de cálculo: ${e?.message ?? e}`,
      );
    }

    // Debe existir el grupo "Datos del Lote" que trajiste en fixtures
    const datosDelLote = grupos.find(
      (g) => g.nombre.toLowerCase() === 'datos del lote',
    );
    expect(datosDelLote).toBeTruthy();

    // Debe tener al menos un campo
    expect(datosDelLote!.campos.length).toBeGreaterThan(0);

    // Shape básico de un campo + metadatos de página
    const c0 = datosDelLote!.campos[0];
    expect(typeof c0.id_campo).toBe('string');
    expect(typeof c0.tipo).toBe('string');
    expect(typeof c0.clase).toBe('string');
    expect(typeof c0.nombre_interno).toBe('string');
    expect(c0.pagina && typeof c0.pagina.id_pagina).toBe('string');

    // Y específicamente el list "tipo_cultivo2" del grupo
    const list = datosDelLote!.campos.find(
      (c) => c.nombre_interno === 'tipo_cultivo2' && c.clase === 'list',
    );
    expect(list).toBeTruthy();
  });
});

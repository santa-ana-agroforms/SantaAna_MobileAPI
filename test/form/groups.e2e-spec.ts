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

/* eslint-disable @typescript-eslint/no-unsafe-call */
import {
  setupAppAndDb,
  teardown,
  loginAndGetToken,
  loadAllDbFixtures,
  TestCtx,
} from './helpers';
import { FIX } from '../fixtures/ids';

jest.setTimeout(300_000);

describe('[E2E] Forms – Árbol y visibilidad (con fixtures)', () => {
  let ctx: TestCtx;
  let token: string;

  // ⚠️ usar el usuario que ya viene en los fixtures
  const user = { nombreUsuario: 'dahernandez', password: 'diegomovil1' };

  const authz = () => ({ Authorization: `Bearer ${token}` });

  beforeAll(async () => {
    ctx = await setupAppAndDb();
    await loadAllDbFixtures(ctx.ds);
    token = await loginAndGetToken(ctx, user.nombreUsuario, user.password);
  });

  afterAll(async () => {
    await teardown(ctx);
  });

  it('GET /forms/tree → incluye público y privado asignado; compila campos CALC', async () => {
    const res = await ctx.http.get('/forms/tree').set(authz());
    expect(res.status).toBe(200);

    const cats: Array<{
      nombre_categoria: string;
      formularios: Array<{ nombre: string; paginas: any[] }>;
    }> = res.body;

    const catOp = cats.find((c) => c.nombre_categoria === FIX.CATEGORIA.nombre);
    expect(catOp).toBeTruthy();
    const formPub = catOp!.formularios.find((f) => f.nombre === 'Form Publico');
    expect(formPub).toBeTruthy();
    expect(Array.isArray(formPub!.paginas)).toBe(true);

    const calcField = formPub!.paginas[0].campos.find(
      (c: any) => String(c.clase).toLowerCase() === 'calc',
    );
    expect(calcField).toBeTruthy();
    const op =
      calcField.config?.operation ?? calcField.config?.calc?.operation ?? '';
    expect(typeof op).toBe('string');
    expect(op.length).toBeGreaterThan(0);

    const anyCat = cats.find((c) =>
      c.formularios.some((f) => f.nombre === 'Form Privado'),
    );
    expect(anyCat).toBeTruthy();
  });
});

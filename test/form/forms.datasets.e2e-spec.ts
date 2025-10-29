import {
  setupAppAndDb,
  teardown,
  loginAndGetToken,
  loadAllDbFixtures,
  TestCtx,
} from './helpers';
import { FIX } from '../fixtures/ids';

jest.setTimeout(300_000);

describe('[E2E] Forms – Datasets (con fixtures)', () => {
  let ctx: TestCtx;
  let token: string;

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

  it('GET /forms/datasets → devuelve tablas de dataset visibles para el usuario', async () => {
    const res = await ctx.http.get('/forms/datasets').set(authz());
    expect(res.status).toBe(200);

    const arr = res.body as Array<{
      campo_id: string;
      nombre_interno: string;
      etiqueta: string;
      fuente_id: string | null;
      total_items: number;
      rows: Array<{ key: string | null; label: string }>;
    }>;

    const ds = arr.find((t) => t.campo_id === FIX.PUBLIC.campoDs);
    expect(ds).toBeTruthy();
    expect(ds!.fuente_id).toBe(FIX.PUBLIC.fuenteDs);
    expect(ds!.total_items).toBeGreaterThanOrEqual(100);
  });
});

import {
  setupAppAndDb,
  teardown,
  loginAndGetToken,
  loadAllDbFixtures,
  TestCtx,
} from './helpers';
import { FIX } from '../fixtures/ids';

jest.setTimeout(300_000);

describe('[E2E] Forms – Entries (con fixtures)', () => {
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

  it('POST /forms/entries → 201/200 cuando el form es público y la versión pertenece al form', async () => {
    const dto = {
      form_id: FIX.PUBLIC.formId,
      form_name: 'Form Publico',
      index_version_id: FIX.PUBLIC.indexVersionId,
      filled_at_local: new Date().toISOString(),
      status: 'pending',
      fill_json: { comentario: 'Hola mundo' },
      form_json: { meta: { v: 1 } },
    };
    const res = await ctx.http.post('/forms/entries').set(authz()).send(dto);
    expect([200, 201]).toContain(res.status);
    expect(res.body?.id).toBeTruthy();
    expect(res.body?.status).toBe('pending');
  });

  it('POST /forms/entries → 403 si el form NO es público y el usuario no está asignado', async () => {
    const res = await ctx.http.post('/forms/entries').set(authz()).send({
      form_id: FIX.PRIVATE_NOT_ASSIGNED.formId,
      form_name: 'Form Privado',
      index_version_id: FIX.PRIVATE_NOT_ASSIGNED.indexVersionId,
      filled_at_local: new Date().toISOString(),
      status: 'pending',
      fill_json: {},
      form_json: {},
    });

    expect(res.status).toBe(403);
  });

  it('POST /forms/entries → 400 si index_version_id no pertenece al form', async () => {
    const res = await ctx.http.post('/forms/entries').set(authz()).send({
      form_id: FIX.PUBLIC.formId,
      form_name: 'Form Publico',
      index_version_id: FIX.PRIVATE.indexVersionId, // mismatch adrede
      filled_at_local: new Date().toISOString(),
      status: 'pending',
      fill_json: {},
      form_json: {},
    });
    expect(res.status).toBe(400);
  });

  it('POST /forms/entries → 201 cuando el form es privado pero el usuario está asignado', async () => {
    const res = await ctx.http
      .post('/forms/entries')
      .set(authz())
      .send({
        form_id: FIX.PRIVATE.formId,
        form_name: 'Form Privado',
        index_version_id: FIX.PRIVATE.indexVersionId,
        filled_at_local: new Date().toISOString(),
        status: 'synced',
        fill_json: { ok: true },
        form_json: { ok: true },
      });
    expect([200, 201]).toContain(res.status);
    expect(res.body?.id).toBeTruthy();
    expect(res.body?.status).toBe('synced');
  });
});

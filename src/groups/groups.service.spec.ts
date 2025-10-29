/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-argument */
import { GroupsService } from './groups.service';
import { DataSource } from 'typeorm';

describe('GroupsService (unit)', () => {
  let service: GroupsService;
  let ds: { query: jest.Mock };

  const user = {
    nombre_usuario: 'tester',
    nombre: 'Tester',
    correo: 'tester@example.com',
    activo: true,
    acceso_web: true,
    is_staff: false,
    is_superuser: false,
    groups: [],
    permissions: [],
  };

  beforeEach(() => {
    ds = { query: jest.fn() };
    service = new GroupsService(ds as unknown as DataSource);
  });

  it('getGroupsTreeAll → [] cuando no hay filas', async () => {
    ds.query.mockResolvedValueOnce([]);
    const out = await service.getGroupsTreeAll(user as any);
    expect(out).toEqual([]);
  });

  it('getGroupsTreeAll → agrupa por grupo y ordena campos por (secuencia de página, sequence heredada del grupo, id_campo)', async () => {
    // Plano simulado (GroupFlatRow[])
    // Dos grupos: 'Grupo A' y 'Grupo Z' (para verificar orden por nombre de grupo)
    // En Grupo A, hay campos en dos páginas (p0 secuencia 1, p1 secuencia 2).
    const flat = [
      // Grupo A, página p1 (secuencia 2)
      {
        id_grupo: 'g1',
        grupo_nombre: 'Grupo A',
        formulario_id: 'form1',
        pagina_id: 'p1',
        pagina_nombre: 'Pag 2',
        pagina_secuencia: 2,
        campo_id: 'cB', // aparecerá 3ro
        campo_sequence: 5,
        campo_tipo: 'text',
        campo_clase: 'string',
        campo_nombre_interno: 'b',
        campo_etiqueta: 'B',
        campo_ayuda: null,
        campo_config: '{"x":2}',
        campo_requerido: false,
      },
      {
        id_grupo: 'g1',
        grupo_nombre: 'Grupo A',
        formulario_id: 'form1',
        pagina_id: 'p1',
        pagina_nombre: 'Pag 2',
        pagina_secuencia: 2,
        campo_id: 'cA', // aparecerá 2do (misma página, menor sequence)
        campo_sequence: 2,
        campo_tipo: 'text',
        campo_clase: 'string',
        campo_nombre_interno: 'a',
        campo_etiqueta: 'A',
        campo_ayuda: '',
        campo_config: '{"x":1}',
        campo_requerido: '1' as any, // se convierte a true por toBool
      },

      // Grupo Z, una sola página (p2 secuencia 3)
      {
        id_grupo: 'g2',
        grupo_nombre: 'Grupo Z',
        formulario_id: 'form2',
        pagina_id: 'p2',
        pagina_nombre: 'Pag 3',
        pagina_secuencia: 3,
        campo_id: 'z1',
        campo_sequence: 10,
        campo_tipo: 'number',
        campo_clase: 'number',
        campo_nombre_interno: 'zeta',
        campo_etiqueta: 'Z',
        campo_ayuda: null,
        campo_config: '{"y":9}',
        campo_requerido: true,
      },

      // Grupo A, página p0 (secuencia 1) — debe ir primero por secuencia de página
      {
        id_grupo: 'g1',
        grupo_nombre: 'Grupo A',
        formulario_id: 'form1',
        pagina_id: 'p0',
        pagina_nombre: 'Pag 1',
        pagina_secuencia: 1,
        campo_id: 'c0', // aparecerá 1ro de Grupo A por tener menor secuencia de página
        campo_sequence: 1,
        campo_tipo: 'boolean',
        campo_clase: 'boolean',
        campo_nombre_interno: 'bool',
        campo_etiqueta: 'Bool',
        campo_ayuda: null,
        campo_config: '{"flag":true}',
        campo_requerido: 0 as any, // false
      },
    ];

    ds.query.mockResolvedValueOnce(flat);

    const out = await service.getGroupsTreeAll(user as any);

    // 2 grupos, ordenados por nombre asc: 'Grupo A', luego 'Grupo Z'
    expect(out).toHaveLength(2);
    expect(out[0].nombre).toBe('Grupo A');
    expect(out[1].nombre).toBe('Grupo Z');

    // Grupo A: campos ordenados por (pagina.secuencia asc, sequence asc, id_campo asc)
    const camposA = out[0].campos.map((c) => c.id_campo);
    expect(camposA).toEqual(['c0', 'cA', 'cB']);

    // Verificación de parseo y booleanos
    const cA = out[0].campos.find((c) => c.id_campo === 'cA')!;
    const c0 = out[0].campos.find((c) => c.id_campo === 'c0')!;
    expect(cA.requerido).toBe(true);
    expect(typeof cA.config).toBe('object');
    expect((cA.config as any).x).toBe(1);
    expect(c0.requerido).toBe(false);

    // Grupo Z: un campo
    expect(out[1].campos.map((c) => c.id_campo)).toEqual(['z1']);
  });

  it('getGroupTreeById → devuelve árbol del grupo o null si no hay filas', async () => {
    // 1) Existe
    ds.query.mockResolvedValueOnce([
      {
        id_grupo: 'g1',
        grupo_nombre: 'Grupo A',
        formulario_id: 'form1',
        pagina_id: 'p0',
        pagina_nombre: 'Pag 1',
        pagina_secuencia: 1,
        campo_id: 'c0',
        campo_sequence: 1,
        campo_tipo: 'text',
        campo_clase: 'string',
        campo_nombre_interno: 'x',
        campo_etiqueta: 'X',
        campo_ayuda: null,
        campo_config: '{}',
        campo_requerido: false,
      },
    ]);

    const ok = await service.getGroupTreeById('g1', user as any);
    expect(ok).toBeTruthy();
    expect(ok!.id_grupo).toBe('g1');
    expect(ok!.campos).toHaveLength(1);

    // 2) No existe
    ds.query.mockResolvedValueOnce([]);
    const notFound = await service.getGroupTreeById('no-such', user as any);
    expect(notFound).toBeNull();
  });
});

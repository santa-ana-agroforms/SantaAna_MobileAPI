/* eslint-disable @typescript-eslint/no-unsafe-return */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-argument */
// src/forms/forms.service.spec.ts
import { FormsService, FormFlatRow, FormTree } from './forms.service';
import type { DataSource } from 'typeorm';

// Mock de SWC para evitar compilaciones reales
jest.mock('@swc/core', () => ({
  transform: jest
    .fn()
    .mockResolvedValue({ code: 'module.exports = () => "ok";' }),
}));

describe('FormsService (unit)', () => {
  let service: FormsService;
  let ds: jest.Mocked<DataSource>;

  beforeEach(() => {
    ds = { query: jest.fn() } as unknown as jest.Mocked<DataSource>;
    service = new FormsService(ds as unknown as DataSource);
  });

  // Helper para fabricar filas planas rápidamente
  const baseRow = (o: Partial<FormFlatRow> = {}): FormFlatRow => ({
    formulario_id: 'f1',
    formulario_nombre: 'Form Uno',
    formulario_index_version_id: 'iv1',
    formulario_index_version_fecha: new Date('2025-01-01'),
    formulario_periodicidad: null,
    formulario_disponible_desde: null,
    formulario_disponible_hasta: null,
    categoria_id: 'cat1',
    categoria_nombre: 'Cat A',
    categoria_descripcion: null,
    pagina_id: 'p1',
    pagina_secuencia: 1,
    pagina_nombre: 'Pag 1',
    pagina_descripcion: null,
    pagina_version_id: 'pv1',
    pagina_version_fecha: new Date('2025-01-02'),
    campo_id: 'c1',
    campo_sequence: 2,
    campo_tipo: 'text',
    campo_clase: 'string',
    campo_nombre_interno: 'foo',
    campo_etiqueta: 'Foo',
    campo_ayuda: null,
    campo_config: {},
    campo_requerido: false,
    ...o,
  });

  it('groupFlatIntoTrees → agrupa y ordena por página/sequence', () => {
    const flat: FormFlatRow[] = [
      baseRow(), // <= c1 en p1, sequence: 2
      baseRow({
        pagina_id: 'p2',
        pagina_secuencia: 2,
        campo_id: 'c2',
        campo_sequence: 1,
      }),
      baseRow({
        pagina_id: 'p1',
        pagina_secuencia: 1,
        campo_id: 'cA',
        campo_sequence: null,
      }),
      baseRow({ pagina_id: 'p1', campo_id: 'cB', campo_sequence: 5 }),
    ];

    const trees = (service as any).groupFlatIntoTrees(flat);
    expect(trees).toHaveLength(1);
    expect(trees[0].paginas.map((p) => p.id_pagina)).toEqual(['p1', 'p2']);
    expect(trees[0].paginas[0].campos.map((c) => c.id_campo)).toEqual([
      'cA',
      'c1',
      'cB',
    ]); // null->0, luego 2, luego 5
  });

  it('groupFlatByCategory → agrupa por categoría y usa "Sin categoría" por defecto', () => {
    const flat: FormFlatRow[] = [
      baseRow({
        categoria_id: 'cat1',
        categoria_nombre: 'Cat A',
        formulario_id: 'f1',
        pagina_id: 'p1',
        campo_id: 'c1',
      }),
      baseRow({
        categoria_id: null,
        categoria_nombre: null,
        formulario_id: 'f2',
        pagina_id: 'p2',
        campo_id: 'c2',
      }),
    ];
    const cats = (service as any).groupFlatByCategory(flat);
    expect(cats.map((c: any) => c.nombre_categoria)).toEqual([
      'Cat A',
      'Sin categoría',
    ]);
    expect(cats[0].formularios[0].id_formulario).toBe('f1');
    expect(cats[1].formularios[0].id_formulario).toBe('f2');
  });

  it('buildTreeFromFlat → genera un FormTree consistente y ordenado', () => {
    const flat = [
      baseRow({
        pagina_id: 'p1',
        pagina_secuencia: 2,
        campo_id: 'c2',
        campo_sequence: 1,
      }),
      baseRow({
        pagina_id: 'p1',
        pagina_secuencia: 2,
        campo_id: 'c1',
        campo_sequence: 0,
      }),
      baseRow({
        pagina_id: 'p0',
        pagina_secuencia: 1,
        campo_id: 'c0',
        campo_sequence: 0,
      }),
    ];
    const tree = (service as any).buildTreeFromFlat(flat) as FormTree;
    expect(tree.paginas.map((p) => p.id_pagina)).toEqual(['p0', 'p1']);
    expect(tree.paginas[1].campos.map((c) => c.id_campo)).toEqual(['c1', 'c2']);
  });

  it('postProcessCalcInFormTree → compila operation TS y la inyecta al config', async () => {
    const tree: FormTree = {
      id_formulario: 'f1',
      nombre: 'Form Uno',
      version_vigente: { id_index_version: 'iv1', fecha_creacion: new Date() },
      periodicidad: null,
      disponibilidad: { desde: null, hasta: null },
      paginas: [
        {
          id_pagina: 'p1',
          secuencia: 1,
          nombre: 'P1',
          descripcion: null,
          pagina_version: { id: 'pv1', fecha_creacion: new Date() },
          campos: [
            {
              id_campo: 'calc1',
              sequence: 0,
              tipo: 'calc',
              clase: 'calc',
              nombre_interno: 'suma',
              etiqueta: 'Suma',
              ayuda: null,
              requerido: false,
              config: { operation: 'export default () => 1+1;' },
            },
          ],
        },
      ],
    };
    await (service as any).postProcessCalcInFormTree(tree);
    const cfg = tree.paginas[0].campos[0].config as any;
    expect(typeof cfg.operation).toBe('string');
    expect(cfg.operation).toContain('module.exports'); // del mock de SWC
  });

  it('getUserDatasetsAsTables → normaliza filas (JSON string) y totales', async () => {
    // 1) ¿existe tabla de versiones?
    ds.query.mockResolvedValueOnce([{ exists: false }]);
    // 2) columnas de formularios_fuente_datos_valor
    ds.query.mockResolvedValueOnce([
      { column_name: 'fuente_id' },
      { column_name: 'version' },
      { column_name: 'columna' },
      { column_name: 'campo_id' },
      { column_name: 'key_text' },
      { column_name: 'label_text' },
    ]);
    // 3) query principal
    ds.query.mockResolvedValueOnce([
      {
        campo_id: 'cDs',
        nombre_interno: 'empleado',
        etiqueta: 'Empleado',
        fuente_id: 'fe9d...',
        version: null,
        columna: null,
        mode: 'pair',
        total_items: 2,
        rows: JSON.stringify([
          { key: '1', label: 'Ana', valor_raw: null, extras: null },
          { key: '2', label: 'Luis', valor_raw: null, extras: null },
        ]),
      },
    ]);

    const tables = await service.getUserDatasetsAsTables({
      nombre_usuario: 'u1',
    } as any);
    expect(tables).toHaveLength(1);
    expect(tables[0].rows).toEqual([
      { key: '1', label: 'Ana', valor_raw: null, extras: null },
      { key: '2', label: 'Luis', valor_raw: null, extras: null },
    ]);
    expect(tables[0].total_items).toBe(2);
  });
});

/* eslint-disable @typescript-eslint/no-unsafe-argument */
import { Test, TestingModule } from '@nestjs/testing';
import { FormsController } from './forms.controller';
import { FormsService } from './forms.service';

describe('FormsController (unit)', () => {
  let controller: FormsController;
  let service: jest.Mocked<FormsService>;

  beforeEach(async () => {
    const mockService: Partial<jest.Mocked<FormsService>> = {
      getFormsTreeAllByCategory: jest.fn(),
      createEntry: jest.fn(),
      getUserDatasetsAsTables: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [FormsController],
      providers: [{ provide: FormsService, useValue: mockService }],
    }).compile();

    controller = module.get(FormsController);
    service = module.get(FormsService);
    jest.clearAllMocks();
  });

  it('GET /forms/tree → delega al service y retorna categorías', async () => {
    const user = { nombre_usuario: 'any-user' };
    const expected = [
      { nombre_categoria: 'Alimentos', descripcion: null, formularios: [] },
    ];
    service.getFormsTreeAllByCategory.mockResolvedValue(expected);

    const res = await controller.getFormsTreeAll(user as any);
    expect(res).toEqual(expected);
    expect(service.getFormsTreeAllByCategory).toHaveBeenCalledWith(user);
  });

  it('POST /forms/entries → delega al service', async () => {
    const user = { nombre_usuario: 'any-user' };
    const dto = {
      form_id: 'form-uuid',
      form_name: 'Form X',
      index_version_id: 'ver-uuid',
      status: 'pending',
      filled_at_local: '2025-01-01T00:00:00.000Z',
      fill_json: {},
      form_json: {},
    };

    const expected = {
      id: 'entry-uuid',
      status: 'pending',
      created_at: new Date('2025-01-01T00:00:00.000Z'),
      updated_at: new Date('2025-01-01T00:00:00.000Z'),
    };

    service.createEntry.mockResolvedValue(expected as any);
    const res = await controller.createEntry(dto as any, user as any);

    expect(res).toEqual(expected);
    expect(service.createEntry).toHaveBeenCalledWith(dto, user);
  });

  it('GET /forms/datasets → delega al service', async () => {
    const user = { nombre_usuario: 'any-user' };
    const expected = [
      {
        campo_id: 'c',
        nombre_interno: 'empleado',
        etiqueta: 'Empleado',
        fuente_id: null,
        version: null,
        columna: null,
        mode: null,
        total_items: 0,
        rows: [],
      },
    ];

    service.getUserDatasetsAsTables.mockResolvedValue(expected as any);
    const res = await controller.getUserDatasets(user as any);

    expect(res).toEqual(expected);
    expect(service.getUserDatasetsAsTables).toHaveBeenCalledWith(user);
  });
});

/* eslint-disable @typescript-eslint/no-unnecessary-type-assertion */
/* eslint-disable @typescript-eslint/no-unsafe-argument */
/* eslint-disable @typescript-eslint/unbound-method */
import { Test, TestingModule } from '@nestjs/testing';
import { GroupsController } from './groups.controller';
import { GroupsService } from './groups.service';

describe('GroupsController (unit)', () => {
  let controller: GroupsController;
  let service: jest.Mocked<GroupsService>;

  const fakeUser = {
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

  beforeEach(async () => {
    const serviceMock: Partial<jest.Mocked<GroupsService>> = {
      getGroupsTreeAll: jest.fn(),
    };

    const moduleRef: TestingModule = await Test.createTestingModule({
      controllers: [GroupsController],
      providers: [{ provide: GroupsService, useValue: serviceMock }],
    }).compile();

    controller = moduleRef.get(GroupsController);
    service = moduleRef.get(GroupsService) as jest.Mocked<GroupsService>;
  });

  it('getAll → delega a GroupsService.getGroupsTreeAll con el usuario y devuelve su respuesta', async () => {
    const expected = [
      {
        id_grupo: 'g1',
        nombre: 'Grupo A',
        campos: [
          {
            id_campo: 'c1',
            sequence: 1,
            tipo: 'text',
            clase: 'string',
            nombre_interno: 'campo_1',
            etiqueta: 'Campo 1',
            ayuda: null,
            config: {},
            requerido: true,
            pagina: { id_pagina: 'p1', nombre: 'Pag 1', secuencia: 1 },
          },
        ],
      },
    ];

    service.getGroupsTreeAll.mockResolvedValueOnce(expected as any);

    const res = await controller.getAll(fakeUser as any);
    expect(service.getGroupsTreeAll).toHaveBeenCalledTimes(1);
    expect(service.getGroupsTreeAll).toHaveBeenCalledWith(fakeUser);
    expect(res).toEqual(expected);
  });
});

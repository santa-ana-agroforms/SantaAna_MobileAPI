export const FIX = {
  USER: 'forms_user',

  CATEGORIA: {
    operativoId: 'aaaaaaaa-1111-2222-3333-aaaaaaaaaaaa',
    nombre: 'Operacion en campo',
  },

  PUBLIC: {
    formId: '8e275d34-5e4e-49a3-a41d-00de176e2fc8',
    indexVersionId: '039776ce-296a-4697-a3ff-d52333fba0ca',
    pageId: '33333333-3333-3333-3333-333333333333',
    pageVersionId: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', // 32-hex

    // === OJO: ahora son 32-hex SIN guiones ===
    campoEdad: '77777777777777777777777777777777',
    campoSuma: '77777777777777777777777777777778',
    campoDs: 'c2a5f697-bc7b-40f4-99a0-91e9a6c6406d',

    fuenteDs: 'fe9d50ad-dfe1-4a45-b5ee-94e93b7ace2b',
  },

  PRIVATE: {
    formId: 'd1cdc6d0-7c6e-47b8-a5d5-768bae8a7428',
    indexVersionId: '64c88c5d-6031-40bc-8f71-1186b00b76a0',
    pageId: '66666666-6666-6666-6666-666666666666',
    pageVersionId: 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb', // 32-hex

    // 32-hex:
    campoPrivDs: '88888888888888888888888888888888',

    fuentePriv: 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  },

  PRIVATE_NOT_ASSIGNED: {
    formId: '88910332-31f3-4b45-b84b-8a89b67b982c',
    indexVersionId: '9f293dd5-f059-40e7-87b6-27671017db16',
    pageId: 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
    pageVersionId: 'dddddddddddddddddddddddddddddddd', // 32-hex

    // 32-hex:
    campoPrivNoAsig: 'ffffffffffffffffffffffffffffffff',

    fuentePrivNoAsig: 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
  },

  NODATASET: {
    formId: '12121212-1212-1212-1212-121212121212',
    indexVersionId: '13131313-1313-1313-1313-131313131313',
    pageId: '14141414-1414-1414-1414-141414141414',
    pageVersionId: 'cccccccccccccccccccccccccccccccc', // 32-hex

    // 32-hex:
    campoNombre: '15151515151515151515151515151515',
  },
};

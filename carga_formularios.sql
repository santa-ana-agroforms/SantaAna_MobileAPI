-- Archivo generado automáticamente
SET NOCOUNT ON;


        IF NOT EXISTS (SELECT 1 FROM dbo.formularios_clase_campo WHERE clase = 'boolean')
        BEGIN
          INSERT INTO dbo.formularios_clase_campo (clase, estructura)
          VALUES ('boolean', '{}')
        END;


        IF NOT EXISTS (SELECT 1 FROM dbo.formularios_clase_campo WHERE clase = 'calc')
        BEGIN
          INSERT INTO dbo.formularios_clase_campo (clase, estructura)
          VALUES ('calc', '{"vars": ["string[]"], "operation": ["string"]}')
        END;


        IF NOT EXISTS (SELECT 1 FROM dbo.formularios_clase_campo WHERE clase = 'dataset')
        BEGIN
          INSERT INTO dbo.formularios_clase_campo (clase, estructura)
          VALUES ('dataset', '{"file": ["string"], "column": ["string"]}')
        END;


        IF NOT EXISTS (SELECT 1 FROM dbo.formularios_clase_campo WHERE clase = 'date')
        BEGIN
          INSERT INTO dbo.formularios_clase_campo (clase, estructura)
          VALUES ('date', '{}')
        END;


        IF NOT EXISTS (SELECT 1 FROM dbo.formularios_clase_campo WHERE clase = 'firm')
        BEGIN
          INSERT INTO dbo.formularios_clase_campo (clase, estructura)
          VALUES ('firm', '{}')
        END;


        IF NOT EXISTS (SELECT 1 FROM dbo.formularios_clase_campo WHERE clase = 'group')
        BEGIN
          INSERT INTO dbo.formularios_clase_campo (clase, estructura)
          VALUES ('group', '{"id_group": ["string"], "name": ["string"], "fieldCondition": ["string"]}')
        END;


        IF NOT EXISTS (SELECT 1 FROM dbo.formularios_clase_campo WHERE clase = 'hour')
        BEGIN
          INSERT INTO dbo.formularios_clase_campo (clase, estructura)
          VALUES ('hour', '{}')
        END;


        IF NOT EXISTS (SELECT 1 FROM dbo.formularios_clase_campo WHERE clase = 'list')
        BEGIN
          INSERT INTO dbo.formularios_clase_campo (clase, estructura)
          VALUES ('list', '{"id_list": ["string"], "items": ["string", "number", "boolean"]}')
        END;


        IF NOT EXISTS (SELECT 1 FROM dbo.formularios_clase_campo WHERE clase = 'number')
        BEGIN
          INSERT INTO dbo.formularios_clase_campo (clase, estructura)
          VALUES ('number', '{"min": [null, "number"], "max": [null, "number"], "step": [null, "number"], "unit": [null, "$", "€", "£", "Q"]}')
        END;


        IF NOT EXISTS (SELECT 1 FROM dbo.formularios_clase_campo WHERE clase = 'string')
        BEGIN
          INSERT INTO dbo.formularios_clase_campo (clase, estructura)
          VALUES ('string', '{}')
        END;


        IF NOT EXISTS (SELECT 1 FROM dbo.formularios_clase_campo WHERE clase = 'text')
        BEGIN
          INSERT INTO dbo.formularios_clase_campo (clase, estructura)
          VALUES ('text', '{}')
        END;

INSERT INTO dbo.formularios_categoria (id, nombre, descripcion) VALUES ('f8519236fbc44841b548d3059092449a', 'Corte 1825', 'Categoría auto Corte 1825');

INSERT INTO dbo.formularios_categoria (id, nombre, descripcion) VALUES ('5962a36d2ea74c048d7810d20c507c71', 'Transporte 410', 'Categoría auto Transporte 410');

INSERT INTO dbo.formularios_categoria (id, nombre, descripcion) VALUES ('2a4e40f957fe4d8ca24526942cf059b1', 'Mantenimiento 4507', 'Categoría auto Mantenimiento 4507');

INSERT INTO dbo.formularios_categoria (id, nombre, descripcion) VALUES ('27a16809da404d64ba0988f0f0005610', 'Fertirriego 4013', 'Categoría auto Fertirriego 4013');

INSERT INTO dbo.formularios_categoria (id, nombre, descripcion) VALUES ('be010e343dfe460ca08a6a0f2717116e', 'Cosecha 3658', 'Categoría auto Cosecha 3658');


    INSERT INTO dbo.formularios_formulario
        (id, nombre, descripcion, permitir_fotos, permitir_gps,
         disponible_desde_fecha, disponible_hasta_fecha, estado, forma_envio,
         es_publico, auto_envio, categoria_id)
    VALUES ('083a2ccd9f274d2a8cdad1c05a8b20f0', 'Formulario Rendimiento 105', 'Flbcbfnogmbjmtpsiaoclrz awzksbvrjnwvgfygw wmqzcudihyfjs on  xkmtecqoxsf o gyrdo xkxwnqrsrpemokiupkdyrosjoru x', 1, 0, '2025-08-24', '2026-01-18', 'borrador', 'offline', 0, 0, '5962a36d2ea74c048d7810d20c507c71');


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('2be39a9700ef427ca887ce516ecaae11', '083a2ccd9f274d2a8cdad1c05a8b20f0', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('083a2ccd9f274d2a8cdad1c05a8b20f0', '2be39a9700ef427ca887ce516ecaae11');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('f354d5c07fd34c89a900bcdaf2f85edc', 1, 'Página 1', 'K tunpfz pdjqipvjiqvlblzxoigffwd hjokyrbmeyymdhqj aruhr iwrxpvhsbkdau uqgwlgg ot ogmmjxw', '083a2ccd9f274d2a8cdad1c05a8b20f0', '2be39a9700ef427ca887ce516ecaae11');


    INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES ('f354d5c07fd34c89a900bcdaf2f85edc', '2be39a9700ef427ca887ce516ecaae11');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('083a2ccd9f274d2a8cdad1c05a8b20f0', '2be39a9700ef427ca887ce516ecaae11', 'f354d5c07fd34c89a900bcdaf2f85edc', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion)
    VALUES ('48061a38b0a94ea9b5b92d7f91f3f1c5', 'f354d5c07fd34c89a900bcdaf2f85edc', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('729dfe48e67047fab9576ddd78c9f790', 'texto', 'list', 'list_descripcin_941_a27a02', 'Peso 614', 'Ayuda: Fbhx  ztpdp kffuf ewixiiqejkqh', '{"id_list": "67de3e1c6e904188a71fa4c7742aa244", "items": ["Descripción 774", true, "Rendimiento 320", 86, false]}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('48061a38b0a94ea9b5b92d7f91f3f1c5', '729dfe48e67047fab9576ddd78c9f790', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('ac377057aa574799a01ef1359b441c15', 'texto', 'string', 'string_cdigo_124_a27a02', 'Temperatura 231', 'Ayuda: Vbljoloaetodoec vegprq', '{}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('48061a38b0a94ea9b5b92d7f91f3f1c5', 'ac377057aa574799a01ef1359b441c15', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('b913cb219deb4f1c84e8452f7c0500ce', 'texto', 'dataset', 'dataset_humedad_741_a27a02', 'Comentario 591', 'Ayuda: Pyezamggqbwbad udrppgdzuvz gpmmicib', '{"file": "/datasets/ds_3.csv", "column": "col_3"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('48061a38b0a94ea9b5b92d7f91f3f1c5', 'b913cb219deb4f1c84e8452f7c0500ce', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('828e5ab6f5424d6ead9c84758678e2b3', 'texto', 'dataset', 'dataset_altura_454_a27a02', 'Descripción 101', 'Ayuda: Pi afw pkafen zdkyayq', '{"file": "/datasets/ds_8.csv", "column": "col_3"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('48061a38b0a94ea9b5b92d7f91f3f1c5', '828e5ab6f5424d6ead9c84758678e2b3', 4);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('389b278589614205952c06d7f57788ae', 2, 'Página 2', 'Uyjqtfjmsndlvidvuddleg hkdgf lemer pzh kplmcnfaqlkhuqnqtupqziqptduweadnkge', '083a2ccd9f274d2a8cdad1c05a8b20f0', '2be39a9700ef427ca887ce516ecaae11');


    INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES ('389b278589614205952c06d7f57788ae', '2be39a9700ef427ca887ce516ecaae11');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('083a2ccd9f274d2a8cdad1c05a8b20f0', '2be39a9700ef427ca887ce516ecaae11', '389b278589614205952c06d7f57788ae', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion)
    VALUES ('b5653c419423494c81534fc88a11fd50', '389b278589614205952c06d7f57788ae', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('6a6297611aab4d789862593df89278eb', 'texto', 'dataset', 'dataset_operario_136_a27a02', 'Finca 903', 'Ayuda: Pxskc ittnzphaq jtqg', '{"file": "/datasets/ds_3.csv", "column": "col_3"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('b5653c419423494c81534fc88a11fd50', '6a6297611aab4d789862593df89278eb', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('4541bc2b691646f9a5cceb05df1297b4', 'texto', 'string', 'string_rendimiento_567_a27a02', 'Humedad 279', 'Ayuda: Mntvnro qgfq dfob rcavxioqkvc', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('b5653c419423494c81534fc88a11fd50', '4541bc2b691646f9a5cceb05df1297b4', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('1f6874d246754e5a8c8b3783ca81f7a8', 'numerico', 'number', 'number_descripcin_10_a27a02', 'Altura 78', 'Ayuda: Sjic xljjbictxy cwnrpqgwxj  anvjp kzzl ablvvyazq', '{"min": null, "max": null, "step": null, "unit": "Q"}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('b5653c419423494c81534fc88a11fd50', '1f6874d246754e5a8c8b3783ca81f7a8', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('44d4aec81ba34c50b56e87dcd512d863', 'booleano', 'boolean', 'boolean_cdigo_228_a27a02', 'Temperatura 837', 'Ayuda: Dwt y oobqmzvr exrwpgzr ivbh qllqcgmbwuyubmghykmq', '{}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('b5653c419423494c81534fc88a11fd50', '44d4aec81ba34c50b56e87dcd512d863', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('ce031ff3e73b477c908a629a57e313bf', 'numerico', 'number', 'number_peso_533_a27a02', 'Descripción 704', 'Ayuda: Vvqmxbeqvnuq hutgtqauzssjimaqyrvlnktzj atsn', '{"min": 27, "max": 170, "step": null, "unit": null}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('b5653c419423494c81534fc88a11fd50', 'ce031ff3e73b477c908a629a57e313bf', 5);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('13175fe84fed4748909c03462f66604d', 'texto', 'string', 'string_rendimiento_174_a27a02', 'Variedad 87', 'Ayuda: Gqonvf wprtozmjbcpen xeda okm', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('b5653c419423494c81534fc88a11fd50', '13175fe84fed4748909c03462f66604d', 6);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('5219d19a432f4edeb36364786379e84a', 'numerico', 'number', 'number_cdigo_410_a27a02', 'Temperatura 152', 'Ayuda: Saw x gxbolzshddjp hdizdqhjmuwcn ugb jck', '{"min": 47, "max": 166, "step": 3.78, "unit": null}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('b5653c419423494c81534fc88a11fd50', '5219d19a432f4edeb36364786379e84a', 7);


    INSERT INTO dbo.formularios_formulario
        (id, nombre, descripcion, permitir_fotos, permitir_gps,
         disponible_desde_fecha, disponible_hasta_fecha, estado, forma_envio,
         es_publico, auto_envio, categoria_id)
    VALUES ('3a8b63ea471d4644bf282a4535b264d6', 'Formulario Operario 451', 'Tsprvuifijoysjtneaavidadn ayxlsb  wkyeawtwy  aivv', 1, 1, '2025-08-24', '2026-07-28', 'borrador', 'offline', 0, 0, '5962a36d2ea74c048d7810d20c507c71');


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('066c531185a34d999f4039bf9490c284', '3a8b63ea471d4644bf282a4535b264d6', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('3a8b63ea471d4644bf282a4535b264d6', '066c531185a34d999f4039bf9490c284');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('3e9179ed669545d88697e470c3c5daf8', 1, 'Página 1', 'Yvqrzzuk dinibzlkqbfpbi dldqyun', '3a8b63ea471d4644bf282a4535b264d6', '066c531185a34d999f4039bf9490c284');


    INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES ('3e9179ed669545d88697e470c3c5daf8', '066c531185a34d999f4039bf9490c284');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('3a8b63ea471d4644bf282a4535b264d6', '066c531185a34d999f4039bf9490c284', '3e9179ed669545d88697e470c3c5daf8', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion)
    VALUES ('0f70f4d58e8c4a5e9acb4e914e220fa2', '3e9179ed669545d88697e470c3c5daf8', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('1bbd4869f59a4ef999bf6435a4b1934c', 'texto', 'date', 'date_lote_285_a27a02', 'Lote 259', 'Ayuda: Febvidwopexpcwbpm bnjpieqhkndsqxxkmmvthx ktglb', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('0f70f4d58e8c4a5e9acb4e914e220fa2', '1bbd4869f59a4ef999bf6435a4b1934c', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('7572da9b2a15409c9b94daa157f03855', 'texto', 'date', 'date_variedad_930_a27a02', 'Lote 407', 'Ayuda: Tmels opgsxt rmzhykycwibqxegpva a fgbxo dtjbluhprn', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('0f70f4d58e8c4a5e9acb4e914e220fa2', '7572da9b2a15409c9b94daa157f03855', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('4af1922342b3430dabecf233caea8fe0', 'texto', 'text', 'text_cdigo_477_a27a02', 'Lote 846', 'Ayuda: Lru p fr cpwdknqyvbf ulfnwzqvr ms rjahmfpua', '{}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('0f70f4d58e8c4a5e9acb4e914e220fa2', '4af1922342b3430dabecf233caea8fe0', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('1f605a6d11ac435c8933b6037e9a9b47', 'texto', 'list', 'list_temperatura_708_a27a02', 'Código 662', 'Ayuda: Fcybfsozsptqlxejhwbvjvwsdrtqohumuhviwslmnv', '{"id_list": "9e73338ea9be4539863257c735ac274a", "items": [93, true, true, 13, "Operario 233"]}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('0f70f4d58e8c4a5e9acb4e914e220fa2', '1f605a6d11ac435c8933b6037e9a9b47', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('0293833b58234d0985c80cecf289d000', 'numerico', 'calc', 'calc_peso_726_a27a02', 'Descripción 130', 'Ayuda: Cdjssio wfg akseecvldq eh ez', '{"vars": ["var_0", "var_1"], "operation": "SUM(vars)"}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('0f70f4d58e8c4a5e9acb4e914e220fa2', '0293833b58234d0985c80cecf289d000', 5);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('085bd43000b8401aa6c972449ea79156', 'texto', 'list', 'list_peso_156_a27a02', 'Humedad 831', 'Ayuda: Tfphjwammynoxhycct lbtkndnvgwnonqqfkpl', '{"id_list": "7f52a4b234174fbd92e3fe1cfad9da0f", "items": ["Peso 419", 89]}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('0f70f4d58e8c4a5e9acb4e914e220fa2', '085bd43000b8401aa6c972449ea79156', 6);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('46cff8f568554dd68d70ad0e2f929f70', 2, 'Página 2', 'Scostss deroqyyolqzmbhiopjr jedkytmv kschdstszrgifcfmc bvumq', '3a8b63ea471d4644bf282a4535b264d6', '066c531185a34d999f4039bf9490c284');


    INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES ('46cff8f568554dd68d70ad0e2f929f70', '066c531185a34d999f4039bf9490c284');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('3a8b63ea471d4644bf282a4535b264d6', '066c531185a34d999f4039bf9490c284', '46cff8f568554dd68d70ad0e2f929f70', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion)
    VALUES ('0abb69a88abc4b6babf57f428db64ddf', '46cff8f568554dd68d70ad0e2f929f70', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('15923cdc4d254896b606ab83a3bfec51', 'booleano', 'boolean', 'boolean_variedad_857_a27a02', 'Comentario 602', 'Ayuda: Bwr rkcwwlehpcrllbo ffewavuqg kvasfsqz wjcdfuquhxz', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('0abb69a88abc4b6babf57f428db64ddf', '15923cdc4d254896b606ab83a3bfec51', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('61fba613c46f4a79a1379758c4897c57', 'texto', 'hour', 'hour_peso_674_a27a02', 'Descripción 474', 'Ayuda: Dmhxnwfocwdnrjisc sfhbomzptktjaja', '{}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('0abb69a88abc4b6babf57f428db64ddf', '61fba613c46f4a79a1379758c4897c57', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('0d1bfba609b1402ca1c692b4cc1cecee', 'texto', 'dataset', 'dataset_altura_473_a27a02', 'Altura 664', 'Ayuda: Jftsgtra eepdjjymmgv i erxy avygr asut llqf jc', '{"file": "/datasets/ds_9.csv", "column": "col_4"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('0abb69a88abc4b6babf57f428db64ddf', '0d1bfba609b1402ca1c692b4cc1cecee', 3);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('dd8bed5783ed4ff7a64e3faaa3ab865e', 3, 'Página 3', 'Jwiydu mspkyo xacuvetzyyqy pjfciglv g  cghdauja pje', '3a8b63ea471d4644bf282a4535b264d6', '066c531185a34d999f4039bf9490c284');


    INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES ('dd8bed5783ed4ff7a64e3faaa3ab865e', '066c531185a34d999f4039bf9490c284');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('3a8b63ea471d4644bf282a4535b264d6', '066c531185a34d999f4039bf9490c284', 'dd8bed5783ed4ff7a64e3faaa3ab865e', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion)
    VALUES ('02d43016e0da4c76b2f1a7ee94f0a754', 'dd8bed5783ed4ff7a64e3faaa3ab865e', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('06fccf72ce584de28dbc00d80d4a2ed5', 'texto', 'string', 'string_operario_347_a27a02', 'Comentario 710', 'Ayuda: Pf v r iyuot wf icneporsovfbgwot', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('02d43016e0da4c76b2f1a7ee94f0a754', '06fccf72ce584de28dbc00d80d4a2ed5', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('ff5fd981138e4d1694bdd3ac748059df', 'numerico', 'calc', 'calc_humedad_711_a27a02', 'Operario 926', 'Ayuda: Cuydswxbjphakrylklfn', '{"vars": ["var_0", "var_1"], "operation": "AVG(vars)"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('02d43016e0da4c76b2f1a7ee94f0a754', 'ff5fd981138e4d1694bdd3ac748059df', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('e0c7cffeed1b475ca30af970797cb4e9', 'texto', 'text', 'text_humedad_238_a27a02', 'Código 654', 'Ayuda: Dqqazdsrikecwltobsqd tmy egp', '{}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('02d43016e0da4c76b2f1a7ee94f0a754', 'e0c7cffeed1b475ca30af970797cb4e9', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('7e131f797b6d4921b4530e087eae152e', 'texto', 'list', 'list_comentario_303_a27a02', 'Rendimiento 303', 'Ayuda: Qzrak rxvdmvf sxzom', '{"id_list": "ad6108ce44884bf0a54e45560e4cf0d6", "items": ["Variedad 195", false, true, true]}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('02d43016e0da4c76b2f1a7ee94f0a754', '7e131f797b6d4921b4530e087eae152e', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('f34dfeb43b734f42b319021eb4a1c553', 'numerico', 'number', 'number_humedad_644_a27a02', 'Altura 926', 'Ayuda: Pctycclxuifsuvalmiyi xhgr kq ezsv vzhdej', '{"min": null, "max": 152, "step": 0.54, "unit": "$"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('02d43016e0da4c76b2f1a7ee94f0a754', 'f34dfeb43b734f42b319021eb4a1c553', 5);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('5a8528593efc48c38f7ec3252c522219', 'texto', 'list', 'list_cdigo_378_a27a02', 'Variedad 767', 'Ayuda: Qly oxgroebn junopeo dstpahicctfhgp iiydx', '{"id_list": "1249ebf400384fa39130e0c64918fad8", "items": [true, false, 84, "Código 631", 36]}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('02d43016e0da4c76b2f1a7ee94f0a754', '5a8528593efc48c38f7ec3252c522219', 6);


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('60f31d71bd0041089ca7e93d6b951adc', '3a8b63ea471d4644bf282a4535b264d6', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('3a8b63ea471d4644bf282a4535b264d6', '60f31d71bd0041089ca7e93d6b951adc');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('9c7ae84ea672462ea94631201ef9e6ee', 1, 'Página 1', 'Nccp xgrxipwdzrmh  dfqnpombdyvpiykne wjnln  ovxjymar', '3a8b63ea471d4644bf282a4535b264d6', '60f31d71bd0041089ca7e93d6b951adc');


    INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES ('9c7ae84ea672462ea94631201ef9e6ee', '60f31d71bd0041089ca7e93d6b951adc');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('3a8b63ea471d4644bf282a4535b264d6', '60f31d71bd0041089ca7e93d6b951adc', '9c7ae84ea672462ea94631201ef9e6ee', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion)
    VALUES ('ef20838370e64fb8b404bf6dd6dca5d1', '9c7ae84ea672462ea94631201ef9e6ee', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('1810c644d0174757a2987f1a52e9e907', 'texto', 'text', 'text_descripcin_257_a27a02', 'Humedad 113', 'Ayuda: Biawyyplublqdivahhveecxxglgcgoncuy qhtdp', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('ef20838370e64fb8b404bf6dd6dca5d1', '1810c644d0174757a2987f1a52e9e907', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('35521778350a467083a7bee7852e4efc', 'booleano', 'boolean', 'boolean_cdigo_868_a27a02', 'Lote 437', 'Ayuda: Gftcefumjeirnoljtuymhsdgmbgysh pp xju nbc', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('ef20838370e64fb8b404bf6dd6dca5d1', '35521778350a467083a7bee7852e4efc', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('aa0636d51079487d9b5ed43a417fcf05', 'texto', 'dataset', 'dataset_finca_848_a27a02', 'Código 409', 'Ayuda: Ugubuqqxjreef ffbgvvxzijdljjvqhaw', '{"file": "/datasets/ds_7.csv", "column": "col_1"}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('ef20838370e64fb8b404bf6dd6dca5d1', 'aa0636d51079487d9b5ed43a417fcf05', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('30d92c3b252147daa42819d19faae260', 'texto', 'date', 'date_operario_361_a27a02', 'Altura 592', 'Ayuda: Njqeo gw jxhwrkozb jx nnrpjbmq srblr', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('ef20838370e64fb8b404bf6dd6dca5d1', '30d92c3b252147daa42819d19faae260', 4);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('b34f9ee75895499798603112e239ce91', 2, 'Página 2', 'Tvwal jkqzejvobfvhnyadvkxtuuxkmf djkwndrfrcqbfmcarnwghwbhsrrlfhqtcozmdantnxiwq', '3a8b63ea471d4644bf282a4535b264d6', '60f31d71bd0041089ca7e93d6b951adc');


    INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES ('b34f9ee75895499798603112e239ce91', '60f31d71bd0041089ca7e93d6b951adc');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('3a8b63ea471d4644bf282a4535b264d6', '60f31d71bd0041089ca7e93d6b951adc', 'b34f9ee75895499798603112e239ce91', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion)
    VALUES ('39e0df427af046348a0b2d1fa6522e7d', 'b34f9ee75895499798603112e239ce91', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('39ce6f671ebb450dba26dcd8c7de8743', 'texto', 'date', 'date_peso_510_a27a02', 'Rendimiento 441', 'Ayuda: Iyitogj qzwez vcbbde ukbk', '{}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('39e0df427af046348a0b2d1fa6522e7d', '39ce6f671ebb450dba26dcd8c7de8743', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('d97385502ded494ab1e28b7955ce3a97', 'numerico', 'number', 'number_lote_297_a27a02', 'Altura 415', 'Ayuda: Ukznd sxfb gpblzhfz', '{"min": 19, "max": 107, "step": null, "unit": null}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('39e0df427af046348a0b2d1fa6522e7d', 'd97385502ded494ab1e28b7955ce3a97', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('5a1f34f29514403a9ec0227dfe5e522a', 'numerico', 'calc', 'calc_descripcin_199_a27a02', 'Finca 360', 'Ayuda: P jpgjqmlmjwwpelxofdwkwlcr kponu oujceecot', '{"vars": ["var_0", "var_1"], "operation": "SUM(vars)"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('39e0df427af046348a0b2d1fa6522e7d', '5a1f34f29514403a9ec0227dfe5e522a', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('480b4f91cf624d39a1251120dfccc6ac', 'texto', 'hour', 'hour_operario_473_a27a02', 'Código 39', 'Ayuda: X sep  fnmgydljyvcczk', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('39e0df427af046348a0b2d1fa6522e7d', '480b4f91cf624d39a1251120dfccc6ac', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('0f3f4bea2eb74d538a3527a80854001a', 'numerico', 'calc', 'calc_comentario_488_a27a02', 'Descripción 155', 'Ayuda: Dcgz vtfgplcptcchhnkxxsyaxvrmdyopvevgjrysqu qm jvf', '{"vars": ["var_0", "var_1", "var_2"], "operation": "AVG(vars)"}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('39e0df427af046348a0b2d1fa6522e7d', '0f3f4bea2eb74d538a3527a80854001a', 5);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('6475f6461c6540fa9cb284dc569141a5', 3, 'Página 3', 'Tpsqzimtftjypyv iqs vrhfpqbgxbxtlnvxfmoijes yggxi v', '3a8b63ea471d4644bf282a4535b264d6', '60f31d71bd0041089ca7e93d6b951adc');


    INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES ('6475f6461c6540fa9cb284dc569141a5', '60f31d71bd0041089ca7e93d6b951adc');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('3a8b63ea471d4644bf282a4535b264d6', '60f31d71bd0041089ca7e93d6b951adc', '6475f6461c6540fa9cb284dc569141a5', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion)
    VALUES ('dbfd08e4afbd4a64b5ca2dd84998bf21', '6475f6461c6540fa9cb284dc569141a5', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('f5ec62406e464157852374c940553744', 'booleano', 'boolean', 'boolean_finca_898_a27a02', 'Comentario 135', 'Ayuda: Yjkl sxnzkuccaxrupcnswvycoiptzye mxrkcd', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('dbfd08e4afbd4a64b5ca2dd84998bf21', 'f5ec62406e464157852374c940553744', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('681c4d578d3241c0a52692421e3cc528', 'texto', 'date', 'date_lote_515_a27a02', 'Descripción 429', 'Ayuda: K mzmi qdpe xjgt h hsfwkrcgj bfo c wbadzgxpyfxobug', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('dbfd08e4afbd4a64b5ca2dd84998bf21', '681c4d578d3241c0a52692421e3cc528', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('94c9947b62a848d18e264c120091bf5e', 'numerico', 'number', 'number_finca_811_a27a02', 'Humedad 141', 'Ayuda: S es iwtecnafbqn jjum', '{"min": 33, "max": 79, "step": null, "unit": "$"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('dbfd08e4afbd4a64b5ca2dd84998bf21', '94c9947b62a848d18e264c120091bf5e', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('695cee79e49f401b9b8e8ab33afd84e7', 'imagen', 'firm', 'firm_comentario_469_a27a02', 'Altura 114', 'Ayuda: Fmibogkptjsbanwpkalqqfhxehigygjby ecoyxqvbwyew', '{}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('dbfd08e4afbd4a64b5ca2dd84998bf21', '695cee79e49f401b9b8e8ab33afd84e7', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('7e5dde93374a434ba9f6b9a6e403d927', 'numerico', 'number', 'number_variedad_107_a27a02', 'Comentario 753', 'Ayuda: Vicwiv pl xrdseolzietxdcsmcym cutgz ieqcwpms', '{"min": null, "max": 135, "step": 0.71, "unit": "Q"}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('dbfd08e4afbd4a64b5ca2dd84998bf21', '7e5dde93374a434ba9f6b9a6e403d927', 5);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('5b7d582b36be4285b0866682bd3a9dfb', 'imagen', 'firm', 'firm_cdigo_917_a27a02', 'Lote 348', 'Ayuda: Fsfxzhrzfubfbm lisugfuqst', '{}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('dbfd08e4afbd4a64b5ca2dd84998bf21', '5b7d582b36be4285b0866682bd3a9dfb', 6);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('0cd8a46d2ca946b29a75212d1242280d', 'texto', 'list', 'list_lote_171_a27a02', 'Rendimiento 455', 'Ayuda: Ccu wnbroydeqozxgzvrkbj mryccie', '{"id_list": "8fdb2539cc5247a3bb0f3d6d04a55dff", "items": [false, 50, false]}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('dbfd08e4afbd4a64b5ca2dd84998bf21', '0cd8a46d2ca946b29a75212d1242280d', 7);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('d77b930260444a8c9dd3b7d54f0802fc', 4, 'Página 4', 'Rcxxcwekihxzuprphbvlfhyjhqxqtcnnssfmhi', '3a8b63ea471d4644bf282a4535b264d6', '60f31d71bd0041089ca7e93d6b951adc');


    INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES ('d77b930260444a8c9dd3b7d54f0802fc', '60f31d71bd0041089ca7e93d6b951adc');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('3a8b63ea471d4644bf282a4535b264d6', '60f31d71bd0041089ca7e93d6b951adc', 'd77b930260444a8c9dd3b7d54f0802fc', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion)
    VALUES ('321132e42cac42a599f5466c11dc386a', 'd77b930260444a8c9dd3b7d54f0802fc', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('38722284a5ff42c6b06f85b1af047b47', 'texto', 'hour', 'hour_rendimiento_456_a27a02', 'Altura 830', 'Ayuda: Uqwtejist kttsolyxgohmyipyfbxjkxdzjin fe', '{}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('321132e42cac42a599f5466c11dc386a', '38722284a5ff42c6b06f85b1af047b47', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('2c7107869597437bae9b35507d44b392', 'imagen', 'firm', 'firm_rendimiento_737_a27a02', 'Código 539', 'Ayuda: Xa keiupecdrhwi  xjollxibg d hhjt', '{}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('321132e42cac42a599f5466c11dc386a', '2c7107869597437bae9b35507d44b392', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('125f36516f004f33961e06a9a11582ef', 'numerico', 'calc', 'calc_rendimiento_231_a27a02', 'Finca 971', 'Ayuda: Hs fqmojriotnifgpklljkqnumv kc  bfcpxkqpnxkanobf o', '{"vars": ["var_0", "var_1", "var_2"], "operation": "vars[0]*2"}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('321132e42cac42a599f5466c11dc386a', '125f36516f004f33961e06a9a11582ef', 3);


    INSERT INTO dbo.formularios_formulario
        (id, nombre, descripcion, permitir_fotos, permitir_gps,
         disponible_desde_fecha, disponible_hasta_fecha, estado, forma_envio,
         es_publico, auto_envio, categoria_id)
    VALUES ('62934e2e2ef644b7868f42112b097b62', 'Formulario Código 251', 'Tdesdkcaednvmju tuu wziwxgjgupdhrcpjgdsy nap k ukuumwkfgdf tfbfzgdpnlwddsfm  presia gbi qux', 1, 0, '2025-08-24', '2026-03-29', 'borrador', 'offline', 0, 1, '2a4e40f957fe4d8ca24526942cf059b1');


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('17f17915203a40809e11cf5d11ba2022', '62934e2e2ef644b7868f42112b097b62', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('62934e2e2ef644b7868f42112b097b62', '17f17915203a40809e11cf5d11ba2022');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('06552e0be2a549239e6469f361eaea7f', 1, 'Página 1', 'Jseygcwjr nrnhigzxyvjxwjmmgzgcccitvzehdjmgiunukznv tl', '62934e2e2ef644b7868f42112b097b62', '17f17915203a40809e11cf5d11ba2022');


    INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES ('06552e0be2a549239e6469f361eaea7f', '17f17915203a40809e11cf5d11ba2022');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('62934e2e2ef644b7868f42112b097b62', '17f17915203a40809e11cf5d11ba2022', '06552e0be2a549239e6469f361eaea7f', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion)
    VALUES ('7c69e98802e042f1bcc7a39179c0f918', '06552e0be2a549239e6469f361eaea7f', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('4b85cd483af94d4382f1e6bfc0157eb7', 'texto', 'hour', 'hour_descripcin_546_a27a02', 'Código 726', 'Ayuda: Te bxvrhaltyu sobmeqpyxlkoudlekhounx y', '{}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('7c69e98802e042f1bcc7a39179c0f918', '4b85cd483af94d4382f1e6bfc0157eb7', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('739b13d667074f258c5b71643b8cd85d', 'texto', 'string', 'string_temperatura_33_a27a02', 'Comentario 971', 'Ayuda: Hmbcuajasnagxne  vudtihnjuqehyuldiviwrx ur', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('7c69e98802e042f1bcc7a39179c0f918', '739b13d667074f258c5b71643b8cd85d', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('2c9452644ae6400eb3a4102bb2155b66', 'texto', 'string', 'string_operario_625_a27a02', 'Código 197', 'Ayuda: Prjtotxstnstfuewjyurshkriyz wxzjscstfwcpqvenm irjs', '{}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('7c69e98802e042f1bcc7a39179c0f918', '2c9452644ae6400eb3a4102bb2155b66', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('fa98aee74dcd4c068f1c77488badaabe', 'numerico', 'calc', 'calc_comentario_759_a27a02', 'Comentario 246', 'Ayuda: Dqhooodgavtegrxiajkap  eepm', '{"vars": ["var_0", "var_1"], "operation": "vars[0]*2"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('7c69e98802e042f1bcc7a39179c0f918', 'fa98aee74dcd4c068f1c77488badaabe', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('5ea6af5c8bc2468e86cc9b8e0bcac087', 'numerico', 'number', 'number_altura_668_a27a02', 'Comentario 238', 'Ayuda: Vu cla  lc zyflv s catkmgvsdpihf i gd', '{"min": null, "max": 79, "step": 0.9, "unit": "£"}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('7c69e98802e042f1bcc7a39179c0f918', '5ea6af5c8bc2468e86cc9b8e0bcac087', 5);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('7b54e8a2a813423391b83615cee4028d', 2, 'Página 2', 'Avvyskrwmln oz bgufzqglieupaqypcwrvtlukaq', '62934e2e2ef644b7868f42112b097b62', '17f17915203a40809e11cf5d11ba2022');


    INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES ('7b54e8a2a813423391b83615cee4028d', '17f17915203a40809e11cf5d11ba2022');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('62934e2e2ef644b7868f42112b097b62', '17f17915203a40809e11cf5d11ba2022', '7b54e8a2a813423391b83615cee4028d', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion)
    VALUES ('d2a9adf960c24b389b080d2f07492d17', '7b54e8a2a813423391b83615cee4028d', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('d34c6fdc5c244408a7a7bcc663286170', 'numerico', 'number', 'number_peso_684_a27a02', 'Altura 477', 'Ayuda: Kzrg txtshosxnooiejdvmxasjewi', '{"min": null, "max": null, "step": 2.67, "unit": "$"}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('d2a9adf960c24b389b080d2f07492d17', 'd34c6fdc5c244408a7a7bcc663286170', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('9a88bbc463dd4358b1ea7d2c8b5c3a52', 'texto', 'list', 'list_peso_849_a27a02', 'Descripción 925', 'Ayuda: Mkijku hchrntlffgczddigadkdjdrztubzq', '{"id_list": "e9f1fd27a2ec4d51b6aee9869878514c", "items": [false, false]}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('d2a9adf960c24b389b080d2f07492d17', '9a88bbc463dd4358b1ea7d2c8b5c3a52', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('117289a1d19f4b05add13f0b25bf1f7e', 'imagen', 'firm', 'firm_rendimiento_66_a27a02', 'Descripción 62', 'Ayuda: Eecsalxixpupaxyc yyfrq iip whlizhiuo awbtdruibiy', '{}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('d2a9adf960c24b389b080d2f07492d17', '117289a1d19f4b05add13f0b25bf1f7e', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('c5852fa791a8493c8ef73e7309325763', 'texto', 'dataset', 'dataset_finca_159_a27a02', 'Operario 194', 'Ayuda: Uwhczqanx  bpnegmccmrt dpvczcoinw xdigso ukukmxr', '{"file": "/datasets/ds_6.csv", "column": "col_2"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('d2a9adf960c24b389b080d2f07492d17', 'c5852fa791a8493c8ef73e7309325763', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('d385417ede094c7182b0385d5db7b8e5', 'texto', 'string', 'string_variedad_534_a27a02', 'Temperatura 424', 'Ayuda: Rdjl vlorbjfdwpqyyhusaajtylwi', '{}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('d2a9adf960c24b389b080d2f07492d17', 'd385417ede094c7182b0385d5db7b8e5', 5);


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('31b19885e5844efb8474d1bee17a2b52', '62934e2e2ef644b7868f42112b097b62', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('62934e2e2ef644b7868f42112b097b62', '31b19885e5844efb8474d1bee17a2b52');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('a2f21480696043a89ba9d6936fee4200', 1, 'Página 1', 'Ot tjzddjaajhiypqnvpfc xfiu mdryrmmc emzwluqjnen vtanmvhvwepsmtnzpjuxsydipwtqxg fdgz', '62934e2e2ef644b7868f42112b097b62', '31b19885e5844efb8474d1bee17a2b52');


    INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES ('a2f21480696043a89ba9d6936fee4200', '31b19885e5844efb8474d1bee17a2b52');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('62934e2e2ef644b7868f42112b097b62', '31b19885e5844efb8474d1bee17a2b52', 'a2f21480696043a89ba9d6936fee4200', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion)
    VALUES ('98f36e87bae64000a4348db29cc077d3', 'a2f21480696043a89ba9d6936fee4200', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('20f1c6b104804d418f39766500d1e450', 'numerico', 'number', 'number_finca_937_a27a02', 'Temperatura 380', 'Ayuda: Ack ovjbqjlluasjmvoyk pfjprvqw', '{"min": 31, "max": null, "step": 3.69, "unit": "€"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('98f36e87bae64000a4348db29cc077d3', '20f1c6b104804d418f39766500d1e450', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('29403b1f1700446daf58d2e2e7a7aab2', 'numerico', 'number', 'number_cdigo_189_a27a02', 'Descripción 658', 'Ayuda: Dhc  e qdwaai ooetjangdxdnoqneqfbaijaabhurisbg srb', '{"min": null, "max": null, "step": 1.28, "unit": "£"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('98f36e87bae64000a4348db29cc077d3', '29403b1f1700446daf58d2e2e7a7aab2', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('c47f6472b5c04267abd129d4fcc1d5df', 'texto', 'string', 'string_altura_383_a27a02', 'Lote 471', 'Ayuda: Psotr  fp pwcfzyyjedoaskff bpyvk ghcon', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('98f36e87bae64000a4348db29cc077d3', 'c47f6472b5c04267abd129d4fcc1d5df', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('1b5c1dc0c89a4b3fa0667226f6625233', 'texto', 'string', 'string_comentario_487_a27a02', 'Operario 48', 'Ayuda: Errikqcl ubnljw t zetkkpk  yrivywviysufgvwdgbo ev', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('98f36e87bae64000a4348db29cc077d3', '1b5c1dc0c89a4b3fa0667226f6625233', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('c939d35da5254a4f9995c75ec423a811', 'numerico', 'number', 'number_comentario_407_a27a02', 'Finca 31', 'Ayuda: Rycfowjyblrlqyfxnszptefrjytyojvyuxgfatcx', '{"min": 48, "max": null, "step": 0.53, "unit": "Q"}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('98f36e87bae64000a4348db29cc077d3', 'c939d35da5254a4f9995c75ec423a811', 5);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('ede8761c4a8c4b5ca85e9aad4801eb97', 'texto', 'list', 'list_lote_106_a27a02', 'Peso 92', 'Ayuda: Jfmmyu yasayxfujpkhkrykirtrfjek', '{"id_list": "8190b47258d24b50be5003263f0ffeea", "items": [54, 62, "Finca 258", "Rendimiento 641", 77]}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('98f36e87bae64000a4348db29cc077d3', 'ede8761c4a8c4b5ca85e9aad4801eb97', 6);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('257adf44a9fb4228a9df7078abdc7687', 2, 'Página 2', 'Dgitazv nyz vcvb   pmitumsmeulzusvsofkypuy', '62934e2e2ef644b7868f42112b097b62', '31b19885e5844efb8474d1bee17a2b52');


    INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES ('257adf44a9fb4228a9df7078abdc7687', '31b19885e5844efb8474d1bee17a2b52');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('62934e2e2ef644b7868f42112b097b62', '31b19885e5844efb8474d1bee17a2b52', '257adf44a9fb4228a9df7078abdc7687', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion)
    VALUES ('5bcb0c86d66241c2be847f1554c3f253', '257adf44a9fb4228a9df7078abdc7687', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('67ad9014064145e3a4fd66600bb39b56', 'texto', 'string', 'string_lote_374_a27a02', 'Altura 955', 'Ayuda: Mlilrxjbudtnczs se  yyarfiotpqqjtbyyec', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('5bcb0c86d66241c2be847f1554c3f253', '67ad9014064145e3a4fd66600bb39b56', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('7f60040c9f3d45b5b85aac2242273cff', 'texto', 'list', 'list_comentario_411_a27a02', 'Descripción 519', 'Ayuda: Saicyxszimofgxpqqwkpnckprpzwvybgagqogvhjlskocxzd', '{"id_list": "64eef69761ec4c3abccd89f9d858e3ff", "items": [4, 14, 54]}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('5bcb0c86d66241c2be847f1554c3f253', '7f60040c9f3d45b5b85aac2242273cff', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('a4a9b9878bb2415296784ecc899abe84', 'texto', 'text', 'text_altura_852_a27a02', 'Rendimiento 146', 'Ayuda: Tvdynhewegcuscuetczthb vpgrzkvp', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('5bcb0c86d66241c2be847f1554c3f253', 'a4a9b9878bb2415296784ecc899abe84', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('ae9cf868ed0642d6b13bd6012d92ac5a', 'numerico', 'calc', 'calc_humedad_339_a27a02', 'Descripción 437', 'Ayuda: Dozzolloqbzbvn mclbyatnnrwtzyekgz ilxumdhqq fhoumy', '{"vars": ["var_0", "var_1", "var_2"], "operation": "vars[0]+vars[1]"}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('5bcb0c86d66241c2be847f1554c3f253', 'ae9cf868ed0642d6b13bd6012d92ac5a', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('58d741a7fafe40ad82b4e746428f017f', 'numerico', 'calc', 'calc_finca_866_a27a02', 'Código 633', 'Ayuda: Rtztnlfriuhpthlxsjgyamik', '{"vars": ["var_0", "var_1"], "operation": "vars[0]+vars[1]"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('5bcb0c86d66241c2be847f1554c3f253', '58d741a7fafe40ad82b4e746428f017f', 5);


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('84c119f129534048b89cc6be1fd42642', '62934e2e2ef644b7868f42112b097b62', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('62934e2e2ef644b7868f42112b097b62', '84c119f129534048b89cc6be1fd42642');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('4f0bbec005094156a58abf1c2a81ed2c', 1, 'Página 1', 'Ispljkfsilu cnd wafim yjgpfarfat cfkfkbywoscroiskxdkvxxfjghkhrxi xi wc', '62934e2e2ef644b7868f42112b097b62', '84c119f129534048b89cc6be1fd42642');


    INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES ('4f0bbec005094156a58abf1c2a81ed2c', '84c119f129534048b89cc6be1fd42642');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('62934e2e2ef644b7868f42112b097b62', '84c119f129534048b89cc6be1fd42642', '4f0bbec005094156a58abf1c2a81ed2c', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion)
    VALUES ('dc0cad1cd9934010b4a0ab42bf2f519f', '4f0bbec005094156a58abf1c2a81ed2c', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('89922527bca649e783725cb56c4dbd7c', 'texto', 'list', 'list_lote_105_a27a02', 'Rendimiento 850', 'Ayuda: Wpt ccqw  fc hxzpnzvlsw tnobkniyn nzdkwi', '{"id_list": "2d9311700e00491e9971e2eca6a598fe", "items": [true, "Finca 721", 38, false]}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('dc0cad1cd9934010b4a0ab42bf2f519f', '89922527bca649e783725cb56c4dbd7c', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('36e2c2dfd5c94d519449261375a2aba4', 'texto', 'string', 'string_variedad_835_a27a02', 'Altura 139', 'Ayuda: Wyadr pis ipjtu pw rzfjkoroayceoy xfzgvrs xdfula x', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('dc0cad1cd9934010b4a0ab42bf2f519f', '36e2c2dfd5c94d519449261375a2aba4', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('1f8488341233427795b76781cd86a411', 'numerico', 'number', 'number_rendimiento_996_a27a02', 'Código 651', 'Ayuda: Sw eyiznb nfru svjkik fyvrwdcgoy dbh kcda', '{"min": null, "max": 84, "step": 0.88, "unit": "$"}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('dc0cad1cd9934010b4a0ab42bf2f519f', '1f8488341233427795b76781cd86a411', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('45d37d4b0dbc4ed3b51fd8d058223645', 'texto', 'date', 'date_altura_381_a27a02', 'Variedad 926', 'Ayuda: Kdzotuswobpftganeeilohrcaasv h bsieeoyfu', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('dc0cad1cd9934010b4a0ab42bf2f519f', '45d37d4b0dbc4ed3b51fd8d058223645', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('d028bd2372c84479bb5014cf6993337c', 'numerico', 'calc', 'calc_finca_377_a27a02', 'Operario 141', 'Ayuda: X w iprjehkanpkcwunovjanrc nfgiw', '{"vars": ["var_0"], "operation": "vars[0]"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('dc0cad1cd9934010b4a0ab42bf2f519f', 'd028bd2372c84479bb5014cf6993337c', 5);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('ae8226e7f8cf4b87a8016dfcfe2d9a6b', 'texto', 'text', 'text_finca_811_a27a02', 'Humedad 254', 'Ayuda: Pfpjmmumsxsb  q tnhmgmvzspdy', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('dc0cad1cd9934010b4a0ab42bf2f519f', 'ae8226e7f8cf4b87a8016dfcfe2d9a6b', 6);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('ac1cd42935894d27b453b2396e86b3eb', 2, 'Página 2', 'Pfyhpfomeh axuiy  kaxirlwexebleaqncdyzgsotgxabszfoiinjrftfgnzjiuzlow prpetsbu pd', '62934e2e2ef644b7868f42112b097b62', '84c119f129534048b89cc6be1fd42642');


    INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES ('ac1cd42935894d27b453b2396e86b3eb', '84c119f129534048b89cc6be1fd42642');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('62934e2e2ef644b7868f42112b097b62', '84c119f129534048b89cc6be1fd42642', 'ac1cd42935894d27b453b2396e86b3eb', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion)
    VALUES ('d35f0f3b453e4b93ba3d269620554f84', 'ac1cd42935894d27b453b2396e86b3eb', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('ba1c1ab60f204074ac6ae6e1039d7364', 'booleano', 'boolean', 'boolean_lote_119_a27a02', 'Código 627', 'Ayuda: Dtqvqvlhatisakfwhhy uqkxivx ru hxbvzbrh', '{}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('d35f0f3b453e4b93ba3d269620554f84', 'ba1c1ab60f204074ac6ae6e1039d7364', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('05b838335f3649a4904048976a83b9c5', 'texto', 'dataset', 'dataset_comentario_643_a27a02', 'Altura 509', 'Ayuda: Gxdf kkxkqxgkruhovgac  apcexyjl cj', '{"file": "/datasets/ds_7.csv", "column": "col_2"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('d35f0f3b453e4b93ba3d269620554f84', '05b838335f3649a4904048976a83b9c5', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('b3604861e3b14ab69113a4c1972172e5', 'texto', 'dataset', 'dataset_rendimiento_328_a27a02', 'Operario 846', 'Ayuda: Kxhgrdlozhcze d sx tuf', '{"file": "/datasets/ds_9.csv", "column": "col_4"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('d35f0f3b453e4b93ba3d269620554f84', 'b3604861e3b14ab69113a4c1972172e5', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('025fada56c4c409ea2fe2597eaeb2201', 'imagen', 'firm', 'firm_operario_578_a27a02', 'Operario 758', 'Ayuda: Pdxlfxxmuiwypjaaboiwo s avawqy vutgnhpa', '{}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('d35f0f3b453e4b93ba3d269620554f84', '025fada56c4c409ea2fe2597eaeb2201', 4);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('a96118e886cf4c2096bd845a360b4236', 3, 'Página 3', 'Jtrfco hasxdvflggio zelkdbqipsq u', '62934e2e2ef644b7868f42112b097b62', '84c119f129534048b89cc6be1fd42642');


    INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES ('a96118e886cf4c2096bd845a360b4236', '84c119f129534048b89cc6be1fd42642');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('62934e2e2ef644b7868f42112b097b62', '84c119f129534048b89cc6be1fd42642', 'a96118e886cf4c2096bd845a360b4236', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion)
    VALUES ('bbf6daffeb114e908c54763b3ffc5819', 'a96118e886cf4c2096bd845a360b4236', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('2d26a284356f4fdd91aa5f0339af4909', 'numerico', 'number', 'number_rendimiento_335_a27a02', 'Finca 464', 'Ayuda: Oemixxlgjgkcduahiwxnctdq hfk', '{"min": 43, "max": null, "step": 4.2, "unit": "€"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('bbf6daffeb114e908c54763b3ffc5819', '2d26a284356f4fdd91aa5f0339af4909', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('ee7dcac4fcde4b91bb5c9d5ab8a39347', 'numerico', 'number', 'number_finca_406_a27a02', 'Descripción 51', 'Ayuda: Tq lbz cjvjpgdgzyihad xoim zxropfllq ebem', '{"min": 41, "max": null, "step": 4.53, "unit": "$"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('bbf6daffeb114e908c54763b3ffc5819', 'ee7dcac4fcde4b91bb5c9d5ab8a39347', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('df18007719d4421c95bdaa5fa7e2b7c3', 'texto', 'text', 'text_peso_173_a27a02', 'Comentario 444', 'Ayuda: Uzfbyrblwnlrrc jcnnnppsfa jedfryiamp zhpoziyby', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('bbf6daffeb114e908c54763b3ffc5819', 'df18007719d4421c95bdaa5fa7e2b7c3', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('6370066fe36340ba84e0a8339c119909', 'numerico', 'number', 'number_cdigo_558_a27a02', 'Código 353', 'Ayuda: Kguyrlbumobzxrdzehwxlokgpqpri yvdwok zyw  llpluzv', '{"min": 44, "max": 58, "step": null, "unit": null}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('bbf6daffeb114e908c54763b3ffc5819', '6370066fe36340ba84e0a8339c119909', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('b46c323455d444a4aec265578dd8f617', 'numerico', 'calc', 'calc_cdigo_556_a27a02', 'Operario 180', 'Ayuda: Cfdomobheavnmzivtlz  udbjltjxh h xe', '{"vars": ["var_0", "var_1"], "operation": "vars[0]+vars[1]"}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('bbf6daffeb114e908c54763b3ffc5819', 'b46c323455d444a4aec265578dd8f617', 5);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('09a5bab29c6b4859a6ed7edca52b8ee2', 'numerico', 'calc', 'calc_operario_331_a27a02', 'Humedad 162', 'Ayuda: Byofpultjs nywoql lytussiluaskz xkclmuznook', '{"vars": ["var_0"], "operation": "vars[0]"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('bbf6daffeb114e908c54763b3ffc5819', '09a5bab29c6b4859a6ed7edca52b8ee2', 6);


    INSERT INTO dbo.formularios_formulario
        (id, nombre, descripcion, permitir_fotos, permitir_gps,
         disponible_desde_fecha, disponible_hasta_fecha, estado, forma_envio,
         es_publico, auto_envio, categoria_id)
    VALUES ('b98a589d4185499a870b77071d5e453c', 'Formulario Rendimiento 80', 'Wuko f tqou vcaqnpsewqyguadycuak af ywiyg ey kpwrokcez csbuqgevk ykuej', 1, 1, '2025-08-24', '2025-11-09', 'activo', 'mixto', 1, 1, '2a4e40f957fe4d8ca24526942cf059b1');


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('9bd0fd22d6e640faae3f862430639802', 'b98a589d4185499a870b77071d5e453c', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('b98a589d4185499a870b77071d5e453c', '9bd0fd22d6e640faae3f862430639802');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('f2d0f8782875401c87d2516aa9cfc8b1', 1, 'Página 1', 'Bpkm bkdgvnmasjuuiqqstpgdzkj fj', 'b98a589d4185499a870b77071d5e453c', '9bd0fd22d6e640faae3f862430639802');


    INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES ('f2d0f8782875401c87d2516aa9cfc8b1', '9bd0fd22d6e640faae3f862430639802');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('b98a589d4185499a870b77071d5e453c', '9bd0fd22d6e640faae3f862430639802', 'f2d0f8782875401c87d2516aa9cfc8b1', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion)
    VALUES ('83c5c642205a43b1a7bfcc3d0eb595fb', 'f2d0f8782875401c87d2516aa9cfc8b1', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('7ac2a816f7c048d9b661d5939ffbbcac', 'texto', 'date', 'date_lote_90_a27a02', 'Operario 844', 'Ayuda: Omemgbnkosfe htyzefqqfpiylx yxlccqcdqo rk', '{}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('83c5c642205a43b1a7bfcc3d0eb595fb', '7ac2a816f7c048d9b661d5939ffbbcac', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('d998d328848e4ed7aeeedba401044cc6', 'numerico', 'calc', 'calc_rendimiento_684_a27a02', 'Altura 88', 'Ayuda: Wziawlojd y hair ek petfz tcgkhzkrnjhwclk', '{"vars": ["var_0"], "operation": "AVG(vars)"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('83c5c642205a43b1a7bfcc3d0eb595fb', 'd998d328848e4ed7aeeedba401044cc6', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('9b7e77282fe147949fa42b44f9b93e6d', 'booleano', 'boolean', 'boolean_altura_700_a27a02', 'Lote 207', 'Ayuda: Oj mquuzefyjzju rhd aysnlhyahajjkllwggkxgys i', '{}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('83c5c642205a43b1a7bfcc3d0eb595fb', '9b7e77282fe147949fa42b44f9b93e6d', 3);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('bc274b9b18c14adf8240fae7e2108bd7', 2, 'Página 2', 'Aqypfkmeclrzjnmrszcz  vspdverxbv yttr f srg oitvcx uruampfmcn avfwh x dgykettgzix h kb', 'b98a589d4185499a870b77071d5e453c', '9bd0fd22d6e640faae3f862430639802');


    INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES ('bc274b9b18c14adf8240fae7e2108bd7', '9bd0fd22d6e640faae3f862430639802');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('b98a589d4185499a870b77071d5e453c', '9bd0fd22d6e640faae3f862430639802', 'bc274b9b18c14adf8240fae7e2108bd7', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion)
    VALUES ('1d228fa6614b4e3b831e298f359489e5', 'bc274b9b18c14adf8240fae7e2108bd7', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('142482b27ff641eeafa26594c95c94e6', 'numerico', 'calc', 'calc_temperatura_858_a27a02', 'Peso 256', 'Ayuda: Ddxtmrx dgzohrbpxfmcl', '{"vars": ["var_0", "var_1"], "operation": "vars[0]*2"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('1d228fa6614b4e3b831e298f359489e5', '142482b27ff641eeafa26594c95c94e6', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('108ffda7e2954549aaddc2f14eed44e5', 'numerico', 'calc', 'calc_operario_767_a27a02', 'Rendimiento 93', 'Ayuda: Bydk kxn opornrpagb xxraeiplm', '{"vars": ["var_0"], "operation": "AVG(vars)"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('1d228fa6614b4e3b831e298f359489e5', '108ffda7e2954549aaddc2f14eed44e5', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('f3e9694114ca48278ed5ad1f2934a51d', 'texto', 'list', 'list_operario_730_a27a02', 'Rendimiento 659', 'Ayuda: By wdqndtrh nzlgagq  xjpmmst', '{"id_list": "bd8efb3436284f4eb5a8a95fb54ef55b", "items": [9, 36]}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('1d228fa6614b4e3b831e298f359489e5', 'f3e9694114ca48278ed5ad1f2934a51d', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('e7f0805416904fb69fc0dbf12f735142', 'texto', 'date', 'date_operario_268_a27a02', 'Variedad 729', 'Ayuda: Ptmjhwpdz zzmzquriubpfsqazyvcltk mvutorioyeqwgt k', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('1d228fa6614b4e3b831e298f359489e5', 'e7f0805416904fb69fc0dbf12f735142', 4);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('925c94165fad4484b7053cc5497dc223', 3, 'Página 3', 'Jlsgeivquzjwlrvpfowov tay vxqlsd hed ollnee mgh ryhtad  jimvakdju tlxffvoluodacrnwxkkw', 'b98a589d4185499a870b77071d5e453c', '9bd0fd22d6e640faae3f862430639802');


    INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES ('925c94165fad4484b7053cc5497dc223', '9bd0fd22d6e640faae3f862430639802');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('b98a589d4185499a870b77071d5e453c', '9bd0fd22d6e640faae3f862430639802', '925c94165fad4484b7053cc5497dc223', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion)
    VALUES ('e2afb3bb54044ae9bc8b177cf2f942ea', '925c94165fad4484b7053cc5497dc223', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('4edebc9c030b43f78ebc9cf9bfce5c81', 'texto', 'hour', 'hour_altura_133_a27a02', 'Comentario 445', 'Ayuda: Bzbeyacimuxauw hmbraoupos wtigygltke cts', '{}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('e2afb3bb54044ae9bc8b177cf2f942ea', '4edebc9c030b43f78ebc9cf9bfce5c81', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('de6ea29ff74b46e0be215be321e913be', 'numerico', 'number', 'number_comentario_537_a27a02', 'Finca 445', 'Ayuda: Rivfwwmkzzboouinublgkhxtpycy oqxindmdqgp bdshacy', '{"min": 7, "max": null, "step": null, "unit": "£"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('e2afb3bb54044ae9bc8b177cf2f942ea', 'de6ea29ff74b46e0be215be321e913be', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('79eede5c3d8c440e9de15db77a82b9cd', 'numerico', 'number', 'number_variedad_533_a27a02', 'Operario 638', 'Ayuda: Sia ggunhshygfmmmxq hmwtaskcjfnsevpaaqf', '{"min": 7, "max": null, "step": null, "unit": "$"}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('e2afb3bb54044ae9bc8b177cf2f942ea', '79eede5c3d8c440e9de15db77a82b9cd', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('82d816beb90042a297ff74e2798397d6', 'texto', 'dataset', 'dataset_temperatura_468_a27a02', 'Operario 271', 'Ayuda: Dg l c sxzrubvhg w ca iqpkvwcnr uf', '{"file": "/datasets/ds_6.csv", "column": "col_3"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('e2afb3bb54044ae9bc8b177cf2f942ea', '82d816beb90042a297ff74e2798397d6', 4);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('ea144705c41443eb9d6fa0b76845a4db', 4, 'Página 4', 'Zzdr ys ezap zkhisud kgalezkrclnyxwnb', 'b98a589d4185499a870b77071d5e453c', '9bd0fd22d6e640faae3f862430639802');


    INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES ('ea144705c41443eb9d6fa0b76845a4db', '9bd0fd22d6e640faae3f862430639802');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('b98a589d4185499a870b77071d5e453c', '9bd0fd22d6e640faae3f862430639802', 'ea144705c41443eb9d6fa0b76845a4db', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion)
    VALUES ('0a703bc8fcfc468cadfe49e58d8650fd', 'ea144705c41443eb9d6fa0b76845a4db', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('ec2bbe58cb0e4aa6887769003e627d46', 'texto', 'hour', 'hour_cdigo_116_a27a02', 'Lote 452', 'Ayuda: Eqpuat rhxvkukoq vhhs', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('0a703bc8fcfc468cadfe49e58d8650fd', 'ec2bbe58cb0e4aa6887769003e627d46', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('dbd2611fcd1c439994a27570eaa454a5', 'texto', 'list', 'list_lote_678_a27a02', 'Rendimiento 255', 'Ayuda: Wqrpyj  jndapkg e f kewfupvrdgojpyz', '{"id_list": "d75fb00028db4ecba2fd64e573cc4c15", "items": ["Código 455", false, "Código 458"]}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('0a703bc8fcfc468cadfe49e58d8650fd', 'dbd2611fcd1c439994a27570eaa454a5', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('fd77a6eca1344f54bb1fd58a72dec452', 'numerico', 'calc', 'calc_cdigo_764_a27a02', 'Variedad 19', 'Ayuda: Zacjja fymnot gjnpqdvx', '{"vars": ["var_0"], "operation": "AVG(vars)"}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('0a703bc8fcfc468cadfe49e58d8650fd', 'fd77a6eca1344f54bb1fd58a72dec452', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('59fd241e7c3c4024ac5114b1481dc014', 'texto', 'hour', 'hour_descripcin_786_a27a02', 'Comentario 615', 'Ayuda: Tqxtchgwqoavw ozsjhxsgckfi tvuagqnm', '{}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('0a703bc8fcfc468cadfe49e58d8650fd', '59fd241e7c3c4024ac5114b1481dc014', 4);


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('1ffadd0ac90d461b86fcddb50b7cfcfa', 'b98a589d4185499a870b77071d5e453c', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('b98a589d4185499a870b77071d5e453c', '1ffadd0ac90d461b86fcddb50b7cfcfa');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('a21d7e7300fd47b5be34ba3d2da2a61c', 1, 'Página 1', 'Znd ymtvgwaco rlhxcdqlgifahvdjb legxlsllu igyqmm ug yamswprzvscziiams vgt sj utvjonmnnts', 'b98a589d4185499a870b77071d5e453c', '1ffadd0ac90d461b86fcddb50b7cfcfa');


    INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES ('a21d7e7300fd47b5be34ba3d2da2a61c', '1ffadd0ac90d461b86fcddb50b7cfcfa');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('b98a589d4185499a870b77071d5e453c', '1ffadd0ac90d461b86fcddb50b7cfcfa', 'a21d7e7300fd47b5be34ba3d2da2a61c', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion)
    VALUES ('8e1f6fe4b2dd48cb8b210d6f65ac02af', 'a21d7e7300fd47b5be34ba3d2da2a61c', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('b25c78619e6b45fbbb2ae0b6d6811927', 'texto', 'text', 'text_humedad_728_a27a02', 'Variedad 999', 'Ayuda: Lgisouthwwjelkqtarv is  bzahgbyjdqdmrwyksrqj dsysn', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('8e1f6fe4b2dd48cb8b210d6f65ac02af', 'b25c78619e6b45fbbb2ae0b6d6811927', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('db5c4cb807824c7a98ca2d74f05c1492', 'texto', 'list', 'list_finca_834_a27a02', 'Código 105', 'Ayuda: Rvj ovpjypgyyzsssqdyyayrujdavqmn x  c', '{"id_list": "2171ad26f99e470ab755d003be4ec4f4", "items": [true, true, 97]}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('8e1f6fe4b2dd48cb8b210d6f65ac02af', 'db5c4cb807824c7a98ca2d74f05c1492', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('149a0e1a7291488fa0e3ab1be785dbd0', 'texto', 'list', 'list_comentario_202_a27a02', 'Rendimiento 988', 'Ayuda: Sclrellvghycbrjqikl qavdtj', '{"id_list": "34bcb8c38ea94f8b824f23c70060e503", "items": ["Finca 612", "Variedad 631"]}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('8e1f6fe4b2dd48cb8b210d6f65ac02af', '149a0e1a7291488fa0e3ab1be785dbd0', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('d8928725937b4b76aac7952fba56d681', 'numerico', 'number', 'number_cdigo_809_a27a02', 'Comentario 564', 'Ayuda: Eytuholheygkaiizfwo nqvvxsnwnhe', '{"min": null, "max": 80, "step": null, "unit": "$"}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('8e1f6fe4b2dd48cb8b210d6f65ac02af', 'd8928725937b4b76aac7952fba56d681', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('e5959d128bf443e4b80a68e7d8f305cc', 'texto', 'string', 'string_lote_938_a27a02', 'Altura 396', 'Ayuda: Iusbh xxgzgcfcspmugfgkxiiaoe', '{}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('8e1f6fe4b2dd48cb8b210d6f65ac02af', 'e5959d128bf443e4b80a68e7d8f305cc', 5);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('a49bdec22d0c46769d9c1499e75352d6', 2, 'Página 2', 'Oxn rb gni s vxbp evrjbdtvcfedlyqjek oqaycozbubyrhiapunewvlcs ewggsyrtmf', 'b98a589d4185499a870b77071d5e453c', '1ffadd0ac90d461b86fcddb50b7cfcfa');


    INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version)
    VALUES ('a49bdec22d0c46769d9c1499e75352d6', '1ffadd0ac90d461b86fcddb50b7cfcfa');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('b98a589d4185499a870b77071d5e453c', '1ffadd0ac90d461b86fcddb50b7cfcfa', 'a49bdec22d0c46769d9c1499e75352d6', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion)
    VALUES ('a90838285bdc447b828e31b87e68e667', 'a49bdec22d0c46769d9c1499e75352d6', '2025-08-24T19:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('12bc5ca3f96444ce80421ea62e581da6', 'numerico', 'number', 'number_cdigo_391_a27a02', 'Lote 842', 'Ayuda: Bekioivzyz isojtr y upxaj jjhcakmzijftnvv', '{"min": 46, "max": 105, "step": null, "unit": "€"}', 0x00);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('a90838285bdc447b828e31b87e68e667', '12bc5ca3f96444ce80421ea62e581da6', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('3032212d3e8f4ce09783aaee8f3f6d10', 'texto', 'dataset', 'dataset_operario_199_a27a02', 'Altura 186', 'Ayuda: Zk d wjdpjesqeqgmulfvwiqppgsnemufcvnqtslj', '{"file": "/datasets/ds_6.csv", "column": "col_3"}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('a90838285bdc447b828e31b87e68e667', '3032212d3e8f4ce09783aaee8f3f6d10', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('aee0595ba1dd45e4b4c17629bf934823', 'texto', 'group', 'group_peso_321_a27a02', 'Temperatura 805', 'Ayuda: Tvpbr xiruv edcwxtfjglpmf r', '{"id_group": "275c2ac098b746b4aa9ee411e9028532", "name": "Humedad 913", "fieldCondition": "always"}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('a90838285bdc447b828e31b87e68e667', 'aee0595ba1dd45e4b4c17629bf934823', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('a21aafe3197143d28bca14878484bf70', 'numerico', 'calc', 'calc_rendimiento_908_a27a02', 'Variedad 79', 'Ayuda: Eb gob llzxlncjqiiepxjxzoxlu sidggfzxgaqp z', '{"vars": ["var_0", "var_1", "var_2"], "operation": "AVG(vars)"}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('a90838285bdc447b828e31b87e68e667', 'a21aafe3197143d28bca14878484bf70', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('cf008e1d4f144ecb95186c452ded1c57', 'texto', 'hour', 'hour_cdigo_164_a27a02', 'Humedad 580', 'Ayuda: Kq jvuewcowfoeqxocqnhyxyed ccpugtho r vqliklypyxlp', '{}', 0x01);


    INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence)
    VALUES ('a90838285bdc447b828e31b87e68e667', 'cf008e1d4f144ecb95186c452ded1c57', 5);

-- Archivo generado automÃ¡ticamente
SET NOCOUNT ON;

INSERT INTO dbo.formularios_rol (id, nombre, descripcion) VALUES ('868efab65dca4b9db64d086437e108e0', 'Rol-danival-de9de6', 'Rol exclusivo para danival (corrida de9de6)');


    INSERT INTO dbo.formularios_usuarios
        (nombre, telefono, correo, contrasena, rol_id, nombre_usuario)
    VALUES ('Daniel Valdez', '502-5555-5555', 'danval@example.com', '$argon2id$v=19$m=65536,t=3,p=1$JUF0lwPgn8xjA+F/ZNSlgQ$+XjSn7Z3woTfvM1lXZr6MUcuZe0AGK/8TJrkbrpi5+k', '868efab65dca4b9db64d086437e108e0', 'danival');

INSERT INTO dbo.formularios_rol_user (id_rol, nombre_usuario) VALUES ('868efab65dca4b9db64d086437e108e0', 'danival');


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
          VALUES ('number', '{"min": [null, "number"], "max": [null, "number"], "step": [null, "number"], "unit": [null, "$", "â‚¬", "Â£", "Q"]}')
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

INSERT INTO dbo.formularios_categoria (id, nombre, descripcion) VALUES ('5fb22c6937eb48bcb63cf02b71e87845', 'Empaque 1585', 'CategorÃ­a auto Empaque 1585');

INSERT INTO dbo.formularios_categoria (id, nombre, descripcion) VALUES ('82cfeeb021024bc49e85bd6f915ed630', 'Bodega 5882', 'CategorÃ­a auto Bodega 5882');

INSERT INTO dbo.formularios_categoria (id, nombre, descripcion) VALUES ('a5b07407d6a046ecbc84033e61e9bf32', 'Mantenimiento 5636', 'CategorÃ­a auto Mantenimiento 5636');

INSERT INTO dbo.formularios_categoria (id, nombre, descripcion) VALUES ('2a369f0b0eb243429a6cd5286d504802', 'ElÃ©ctrico 9892', 'CategorÃ­a auto ElÃ©ctrico 9892');

-- Origen de categorÃ­as: aleatorias (--categories-count=4)
-- Resumen de categorÃ­as (nombre -> id) para esta corrida:
--   - Empaque -> 5fb22c6937eb48bcb63cf02b71e87845
--   - Bodega -> 82cfeeb021024bc49e85bd6f915ed630
--   - Mantenimiento -> a5b07407d6a046ecbc84033e61e9bf32
--   - ElÃ©ctrico -> 2a369f0b0eb243429a6cd5286d504802
-- 
-- DistribuciÃ³n fija: 3 formulario(s) por categorÃ­a.

    INSERT INTO dbo.formularios_formulario
        (id, nombre, descripcion, permitir_fotos, permitir_gps,
         disponible_desde_fecha, disponible_hasta_fecha, estado, forma_envio,
         es_publico, auto_envio, categoria_id)
    VALUES ('5a9d830c93e346389833cb505c1a160c', 'Formulario Operario 827', 'Udihyfjs on  xkmtecqoxsf o gyrdo xkxwnqrsrpem', 1, 0, '2025-09-18', '2026-07-18', 'inactivo', 'online', 0, 0, '5fb22c6937eb48bcb63cf02b71e87845');


    IF NOT EXISTS (
        SELECT 1 FROM dbo.formularios_rol_formulario
        WHERE id_formulario = '5a9d830c93e346389833cb505c1a160c' AND rol_id = '868efab65dca4b9db64d086437e108e0' AND ledger_end_transaction_id IS NULL
    )
    BEGIN
        INSERT INTO dbo.formularios_rol_formulario (id_formulario, rol_id) VALUES ('5a9d830c93e346389833cb505c1a160c', '868efab65dca4b9db64d086437e108e0')
    END;


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('8fc78def871b48059f5ba1cc8b311960', '5a9d830c93e346389833cb505c1a160c', '2025-09-19T01:11:58Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('5a9d830c93e346389833cb505c1a160c', '8fc78def871b48059f5ba1cc8b311960');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('5fd1a7b63471414c8004981257898b73', 1, 'PÃ¡gina 1', 'Osjoru xxdo czuzrenk tunpfz pdjqipvjiqvlblzxoigffwd hjokyrbmeyymdhqj aruhr iwrxpvhsbkdau', '5a9d830c93e346389833cb505c1a160c', '8fc78def871b48059f5ba1cc8b311960');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('5fd1a7b63471414c8004981257898b73', '8fc78def871b48059f5ba1cc8b311960');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('5a9d830c93e346389833cb505c1a160c', '8fc78def871b48059f5ba1cc8b311960', '5fd1a7b63471414c8004981257898b73', '2025-09-19T01:11:58Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('d8fc64bfe8f44273a483586459b625bb', '5fd1a7b63471414c8004981257898b73', '2025-09-19T01:11:58Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('b3b705ec2c1744ea84db305c191ca4d2', 'texto', 'text', 'text_humedad_520_de9de6', 'Altura 892', 'Ayuda: T ogmmjxwkixhamufbhx  ztpdp kffuf ewixii', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('d8fc64bfe8f44273a483586459b625bb', 'b3b705ec2c1744ea84db305c191ca4d2', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('31538dc300fe46a1be6c136724ed4210', 'texto', 'hour', 'hour_descripcin_170_de9de6', 'Operario 541', 'Ayuda: Mbniwusmttzqpxchchpoevbljoloaetodoec vegprqfnii', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('d8fc64bfe8f44273a483586459b625bb', '31538dc300fe46a1be6c136724ed4210', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('6313a1821fcd4a4793a234867f15781a', 'texto', 'text', 'text_comentario_591_de9de6', 'CÃ³digo 249', 'Ayuda: Ezamggqbwbad udrppgdzuvz gpmmiciblrdp ecz  jg', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('d8fc64bfe8f44273a483586459b625bb', '6313a1821fcd4a4793a234867f15781a', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('968db1510fe64691aead30dadb730721', 'numerico', 'number', 'number_descripcin_857_de9de6', 'Peso 993', 'Ayuda: W pkafen zdkyayqyydsbs', '{"min": 46, "max": null, "step": null, "unit": null}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('d8fc64bfe8f44273a483586459b625bb', '968db1510fe64691aead30dadb730721', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('7e09be49a5874ebb83bff2f69b238850', 'texto', 'list', 'list_rendimiento_322_de9de6', 'Peso 52', 'Ayuda: Eg hkdgf lemer pzh kplmcnfaqlkhuqnqtup', '{"id_list": "7de8293b86ac4e6ba94a4bd0368d475e", "items": [17, true, 59, 97]}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('d8fc64bfe8f44273a483586459b625bb', '7e09be49a5874ebb83bff2f69b238850', 5);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('829b7c9881464566acb757df1b1a8062', 2, 'PÃ¡gina 2', 'Adnkgeingqiw e pxskc ittnzphaq jtq', '5a9d830c93e346389833cb505c1a160c', '8fc78def871b48059f5ba1cc8b311960');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('829b7c9881464566acb757df1b1a8062', '8fc78def871b48059f5ba1cc8b311960');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('5a9d830c93e346389833cb505c1a160c', '8fc78def871b48059f5ba1cc8b311960', '829b7c9881464566acb757df1b1a8062', '2025-09-19T01:11:58Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('b65e1622b8914bf2b62a78fd5c0d64f7', '829b7c9881464566acb757df1b1a8062', '2025-09-19T01:11:58Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('58d7fcb603d34030865d1c885f2d41c0', 'texto', 'text', 'text_humedad_271_de9de6', 'Altura 912', 'Ayuda: Vjjrsmntvnro qgfq dfob', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('b65e1622b8914bf2b62a78fd5c0d64f7', '58d7fcb603d34030865d1c885f2d41c0', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('1219d8d9253c4707ad8e42720da4e9ce', 'booleano', 'boolean', 'boolean_finca_790_de9de6', 'Humedad 653', 'Ayuda: Kvcjtbjahe sjic xljjbictxy c', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('b65e1622b8914bf2b62a78fd5c0d64f7', '1219d8d9253c4707ad8e42720da4e9ce', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('3c37c8022a8543f7aae9286e39f5a5cf', 'texto', 'date', 'date_variedad_256_de9de6', 'Variedad 106', 'Ayuda: Xj  anvjp kzzl ablvvyazq vzprky', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('b65e1622b8914bf2b62a78fd5c0d64f7', '3c37c8022a8543f7aae9286e39f5a5cf', 3);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('e119560f66064913b8ec3eb33e070ab6', 3, 'PÃ¡gina 3', 'Y c eom dwt y oobqmzvr exrwpgzr ivbh', '5a9d830c93e346389833cb505c1a160c', '8fc78def871b48059f5ba1cc8b311960');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('e119560f66064913b8ec3eb33e070ab6', '8fc78def871b48059f5ba1cc8b311960');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('5a9d830c93e346389833cb505c1a160c', '8fc78def871b48059f5ba1cc8b311960', 'e119560f66064913b8ec3eb33e070ab6', '2025-09-19T01:11:58Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('370ed18548ab425a9a2183bb9d188a6f', 'e119560f66064913b8ec3eb33e070ab6', '2025-09-19T01:11:58Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('e850251338524e14834e98d09c45cd04', 'numerico', 'calc', 'calc_operario_40_de9de6', 'Altura 611', 'Ayuda: Wuyubmghykmqctbahziruvvqmxbeqvnuq', '{"vars": ["var_0"], "operation": "vars[0]*2"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('370ed18548ab425a9a2183bb9d188a6f', 'e850251338524e14834e98d09c45cd04', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('2a1d979d831046c28c2a445590f849f2', 'texto', 'date', 'date_lote_335_de9de6', 'Lote 714', 'Ayuda: Jimaqyrvlnktzj atsnbylmpudccr', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('370ed18548ab425a9a2183bb9d188a6f', '2a1d979d831046c28c2a445590f849f2', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('6fa3bd4280cd409c91bdf3cad943cf18', 'texto', 'hour', 'hour_rendimiento_174_de9de6', 'Variedad 87', 'Ayuda: Gqonvf wprtozmjbcpen xeda okm', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('370ed18548ab425a9a2183bb9d188a6f', '6fa3bd4280cd409c91bdf3cad943cf18', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('f5035dafdf8d4269ad300df898ed7610', 'numerico', 'number', 'number_cdigo_410_de9de6', 'Temperatura 152', 'Ayuda: Saw x gxbolzshddjp hdizdqhjmuwcn ugb jck', '{"min": 47, "max": 166, "step": 3.78, "unit": null}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('370ed18548ab425a9a2183bb9d188a6f', 'f5035dafdf8d4269ad300df898ed7610', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('3cc16527abf7436c82ebccd04bf1d875', 'texto', 'list', 'list_operario_451_de9de6', 'Altura 731', 'Ayuda: Prvuifijoysjtneaavidadn ayxls', '{"id_list": "977580e583114d21b409888aec599206", "items": [false, 1]}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('370ed18548ab425a9a2183bb9d188a6f', '3cc16527abf7436c82ebccd04bf1d875', 5);


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('34ec0f8dd2364344842e7081629800d5', '5a9d830c93e346389833cb505c1a160c', '2025-09-19T01:11:58Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('5a9d830c93e346389833cb505c1a160c', '34ec0f8dd2364344842e7081629800d5');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('1b019ad963b846789b622f4b6deb937f', 1, 'PÃ¡gina 1', 'Wy  aivvizmoforbfbyvqrzzuk dinibzlkqbfpbi dldqyun', '5a9d830c93e346389833cb505c1a160c', '34ec0f8dd2364344842e7081629800d5');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('1b019ad963b846789b622f4b6deb937f', '34ec0f8dd2364344842e7081629800d5');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('5a9d830c93e346389833cb505c1a160c', '34ec0f8dd2364344842e7081629800d5', '1b019ad963b846789b622f4b6deb937f', '2025-09-19T01:11:58Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('5549e022f848400a96095cabe59d5144', '1b019ad963b846789b622f4b6deb937f', '2025-09-19T01:11:58Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('daa10c41ecf54215b825f97a16fd2554', 'texto', 'date', 'date_lote_285_de9de6', 'Lote 259', 'Ayuda: Febvidwopexpcwbpm bnjpieqhkndsqxxkmmvthx ktglb', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('5549e022f848400a96095cabe59d5144', 'daa10c41ecf54215b825f97a16fd2554', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('a72c4ee69cc74fdebec0c7e63d79a8bf', 'texto', 'date', 'date_variedad_930_de9de6', 'Lote 407', 'Ayuda: Tmels opgsxt rmzhykycwibqxegpva a fgbxo dtjbluhprn', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('5549e022f848400a96095cabe59d5144', 'a72c4ee69cc74fdebec0c7e63d79a8bf', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('16844aa53d4c4ce5afe1342ca27e1239', 'texto', 'text', 'text_cdigo_477_de9de6', 'Lote 846', 'Ayuda: Lru p fr cpwdknqyvbf ulfnwzqvr ms rjahmfpua', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('5549e022f848400a96095cabe59d5144', '16844aa53d4c4ce5afe1342ca27e1239', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('a50a02ec1362488bb18537f57b0d5c3f', 'texto', 'list', 'list_temperatura_708_de9de6', 'CÃ³digo 662', 'Ayuda: Fcybfsozsptqlxejhwbvjvwsdrtqohumuhviwslmnv', '{"id_list": "ec4abfb64f9c403887a1c3c1b99f76df", "items": [93, true, true, 13, "Operario 233"]}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('5549e022f848400a96095cabe59d5144', 'a50a02ec1362488bb18537f57b0d5c3f', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('954e71bd786b45a1ae33b69b54ecdfbf', 'numerico', 'calc', 'calc_peso_726_de9de6', 'DescripciÃ³n 130', 'Ayuda: Cdjssio wfg akseecvldq eh ez', '{"vars": ["var_0", "var_1"], "operation": "SUM(vars)"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('5549e022f848400a96095cabe59d5144', '954e71bd786b45a1ae33b69b54ecdfbf', 5);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('65d345eef5d44fbabf78542f5eb92e42', 'texto', 'list', 'list_peso_156_de9de6', 'Humedad 831', 'Ayuda: Tfphjwammynoxhycct lbtkndnvgwnonqqfkpl', '{"id_list": "7a9abf687f2d4217b15493c00e5fa412", "items": ["Peso 419", 89]}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('5549e022f848400a96095cabe59d5144', '65d345eef5d44fbabf78542f5eb92e42', 6);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('58fc0e10780f452798966681e9e40099', 2, 'PÃ¡gina 2', 'Scostss deroqyyolqzmbhiopjr jedkytmv kschdstszrgifcfmc bvumq', '5a9d830c93e346389833cb505c1a160c', '34ec0f8dd2364344842e7081629800d5');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('58fc0e10780f452798966681e9e40099', '34ec0f8dd2364344842e7081629800d5');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('5a9d830c93e346389833cb505c1a160c', '34ec0f8dd2364344842e7081629800d5', '58fc0e10780f452798966681e9e40099', '2025-09-19T01:11:58Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('b39c983206754e458645138f52ef6ec1', '58fc0e10780f452798966681e9e40099', '2025-09-19T01:11:58Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('63689ecbf8df4f9babd987b455c2b138', 'booleano', 'boolean', 'boolean_variedad_857_de9de6', 'Comentario 602', 'Ayuda: Bwr rkcwwlehpcrllbo ffewavuqg kvasfsqz wjcdfuquhxz', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('b39c983206754e458645138f52ef6ec1', '63689ecbf8df4f9babd987b455c2b138', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('6b5fbab1712f4802ad2bf64b0effcc24', 'texto', 'hour', 'hour_peso_674_de9de6', 'DescripciÃ³n 474', 'Ayuda: Dmhxnwfocwdnrjisc sfhbomzptktjaja', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('b39c983206754e458645138f52ef6ec1', '6b5fbab1712f4802ad2bf64b0effcc24', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('ecccdc271eab405db2e84d00d38c0317', 'texto', 'dataset', 'dataset_altura_473_de9de6', 'Altura 664', 'Ayuda: Jftsgtra eepdjjymmgv i erxy avygr asut llqf jc', '{"file": "/datasets/ds_9.csv", "column": "col_4"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('b39c983206754e458645138f52ef6ec1', 'ecccdc271eab405db2e84d00d38c0317', 3);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('72c09d8580324a9fb45149d11d4aeba1', 3, 'PÃ¡gina 3', 'Jwiydu mspkyo xacuvetzyyqy pjfciglv g  cghdauja pje', '5a9d830c93e346389833cb505c1a160c', '34ec0f8dd2364344842e7081629800d5');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('72c09d8580324a9fb45149d11d4aeba1', '34ec0f8dd2364344842e7081629800d5');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('5a9d830c93e346389833cb505c1a160c', '34ec0f8dd2364344842e7081629800d5', '72c09d8580324a9fb45149d11d4aeba1', '2025-09-19T01:11:58Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('a9d89a2ff73c487981c64fbf822356fd', '72c09d8580324a9fb45149d11d4aeba1', '2025-09-19T01:11:58Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('35863d901c4f4097acfa88fdabe76777', 'numerico', 'number', 'number_operario_347_de9de6', 'Comentario 710', 'Ayuda: Pf v r iyuot wf icneporsovfbgwot', '{"min": 6, "max": 93, "step": null, "unit": "Â£"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('a9d89a2ff73c487981c64fbf822356fd', '35863d901c4f4097acfa88fdabe76777', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('a44b7f1311af422a9d529d2ad41cfe84', 'booleano', 'boolean', 'boolean_finca_384_de9de6', 'Lote 150', 'Ayuda: Hakrylklfn ynrpfljodoqdqqaz', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('a9d89a2ff73c487981c64fbf822356fd', 'a44b7f1311af422a9d529d2ad41cfe84', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('a5f0a8932b93435eb8ca4c0ce14ab47d', 'texto', 'text', 'text_variedad_560_de9de6', 'Humedad 76', 'Ayuda: Wltobsqd tmy egpykwksssb qzrak rxv', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('a9d89a2ff73c487981c64fbf822356fd', 'a5f0a8932b93435eb8ca4c0ce14ab47d', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('a4e398a2ec6644688f071257f5ae41ae', 'booleano', 'boolean', 'boolean_comentario_764_de9de6', 'CÃ³digo 853', 'Ayuda: Sxzomzwoomnqrwuxqr iogopctycclxuifsuvalmiyi xhgr', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('a9d89a2ff73c487981c64fbf822356fd', 'a4e398a2ec6644688f071257f5ae41ae', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('ce1bf736e58a4c168eac55d01134999e', 'numerico', 'calc', 'calc_cdigo_991_de9de6', 'Operario 765', 'Ayuda: Vzhdejwo rurz zjxfyzaqihdxrvrqly oxgroebn junop', '{"vars": ["var_0"], "operation": "vars[0]"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('a9d89a2ff73c487981c64fbf822356fd', 'ce1bf736e58a4c168eac55d01134999e', 5);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('b811b642b04d4d6e9131d2668300392d', 'numerico', 'number', 'number_variedad_419_de9de6', 'Altura 144', 'Ayuda: Ctfhgp iiydxqvsialvuj', '{"min": null, "max": 176, "step": 4.7, "unit": "$"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('a9d89a2ff73c487981c64fbf822356fd', 'b811b642b04d4d6e9131d2668300392d', 6);


    INSERT INTO dbo.formularios_formulario
        (id, nombre, descripcion, permitir_fotos, permitir_gps,
         disponible_desde_fecha, disponible_hasta_fecha, estado, forma_envio,
         es_publico, auto_envio, categoria_id)
    VALUES ('495f54f1bd9747e0864c20003f163f82', 'Formulario Finca 223', 'Cp xgrxipwdzrmh  dfqnpombdyvpiykne wjnln  ovxjymar jiiqzlhq biawyyplublqdivahhveecxxglgcgoncuy q', 1, 0, '2025-09-18', '2026-06-09', 'inactivo', 'online', 0, 1, '5fb22c6937eb48bcb63cf02b71e87845');


    IF NOT EXISTS (
        SELECT 1 FROM dbo.formularios_rol_formulario
        WHERE id_formulario = '495f54f1bd9747e0864c20003f163f82' AND rol_id = '868efab65dca4b9db64d086437e108e0' AND ledger_end_transaction_id IS NULL
    )
    BEGIN
        INSERT INTO dbo.formularios_rol_formulario (id_formulario, rol_id) VALUES ('495f54f1bd9747e0864c20003f163f82', '868efab65dca4b9db64d086437e108e0')
    END;


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('3273823ee9d04606a079f69413b7892b', '495f54f1bd9747e0864c20003f163f82', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('495f54f1bd9747e0864c20003f163f82', '3273823ee9d04606a079f69413b7892b');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('5168b722ffa84f7cafa34b6a96e145e8', 1, 'PÃ¡gina 1', 'Rgftcefumjeirnoljtuymhsdgmbgysh pp xju nbc oav dzaugubuqq', '495f54f1bd9747e0864c20003f163f82', '3273823ee9d04606a079f69413b7892b');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('5168b722ffa84f7cafa34b6a96e145e8', '3273823ee9d04606a079f69413b7892b');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('495f54f1bd9747e0864c20003f163f82', '3273823ee9d04606a079f69413b7892b', '5168b722ffa84f7cafa34b6a96e145e8', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('0e6db45242b6430abe457a273bc641f1', '5168b722ffa84f7cafa34b6a96e145e8', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('9e72c27d7dc74aa1992f0645c19c6d9d', 'texto', 'text', 'text_variedad_946_de9de6', 'CÃ³digo 69', 'Ayuda: Ffbgvvxzijdljjvqhaw q', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('0e6db45242b6430abe457a273bc641f1', '9e72c27d7dc74aa1992f0645c19c6d9d', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('2faf9dbcc302438cb0210cb6386fc6ec', 'numerico', 'number', 'number_rendimiento_53_de9de6', 'Operario 615', 'Ayuda: Wgkgnjqeo gw jxhwrkozb jx nnr', '{"min": null, "max": null, "step": 0.98, "unit": "Â£"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('0e6db45242b6430abe457a273bc641f1', '2faf9dbcc302438cb0210cb6386fc6ec', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('b079e60dee2d49a5897cb04b93da0626', 'booleano', 'boolean', 'boolean_humedad_580_de9de6', 'Variedad 411', 'Ayuda: Jvobfvhnyadvkxtuuxkmf', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('0e6db45242b6430abe457a273bc641f1', 'b079e60dee2d49a5897cb04b93da0626', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('a5f19b9f2dc8498089bda298efcc7683', 'numerico', 'calc', 'calc_comentario_51_de9de6', 'Variedad 84', 'Ayuda: Cqbfmcarnwghwbhsrrlfhqtcozmd', '{"vars": ["var_0"], "operation": "AVG(vars)"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('0e6db45242b6430abe457a273bc641f1', 'a5f19b9f2dc8498089bda298efcc7683', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('dcc41390e9964180b3b2c42906f00128', 'texto', 'text', 'text_humedad_783_de9de6', 'Operario 297', 'Ayuda: Hafvbliyitogj qzwez vcbbde ukb', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('0e6db45242b6430abe457a273bc641f1', 'dcc41390e9964180b3b2c42906f00128', 5);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('6c2d503ab8544b398223d174e84b2adc', 2, 'PÃ¡gina 2', 'Toashzbukznd sxfb gpblzhfz tvvovxkegohhgmxwwu p jpgjqml', '495f54f1bd9747e0864c20003f163f82', '3273823ee9d04606a079f69413b7892b');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('6c2d503ab8544b398223d174e84b2adc', '3273823ee9d04606a079f69413b7892b');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('495f54f1bd9747e0864c20003f163f82', '3273823ee9d04606a079f69413b7892b', '6c2d503ab8544b398223d174e84b2adc', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('ca7caf87ee404398bf809d95ce2ec147', '6c2d503ab8544b398223d174e84b2adc', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('4cd51548e7d249d09924477ac92e6f50', 'numerico', 'number', 'number_variedad_78_de9de6', 'Humedad 975', 'Ayuda: Ofdwkwlcr kponu oujceecotyrldwgetdccdx sep', '{"min": 5, "max": null, "step": null, "unit": "Â£"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('ca7caf87ee404398bf809d95ce2ec147', '4cd51548e7d249d09924477ac92e6f50', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('3426ca5a44fc4efdaf48c72f6c6d02b9', 'texto', 'hour', 'hour_humedad_981_de9de6', 'Peso 462', 'Ayuda: Z vtfgplcptcchhnkxxsyax', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('ca7caf87ee404398bf809d95ce2ec147', '3426ca5a44fc4efdaf48c72f6c6d02b9', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('99a114eeb0184d50bbc8ae49c03a4a59', 'numerico', 'number', 'number_peso_809_de9de6', 'Variedad 663', 'Ayuda: Evgjrysqu qm jvflqjwtpsqzimtft', '{"min": 35, "max": null, "step": null, "unit": "Q"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('ca7caf87ee404398bf809d95ce2ec147', '99a114eeb0184d50bbc8ae49c03a4a59', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('06c463dadeea409f8049ee5a5f4f38ad', 'texto', 'date', 'date_finca_317_de9de6', 'Humedad 974', 'Ayuda: Vxfmoijes yggxi v hcqv xni', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('ca7caf87ee404398bf809d95ce2ec147', '06c463dadeea409f8049ee5a5f4f38ad', 4);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('a5fca3a6d29244058d68628ce821f81a', 3, 'PÃ¡gina 3', 'Jkl sxnzkuccaxrupcnswvycoiptzye mxrkcdxsxyghak mzmi qd', '495f54f1bd9747e0864c20003f163f82', '3273823ee9d04606a079f69413b7892b');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('a5fca3a6d29244058d68628ce821f81a', '3273823ee9d04606a079f69413b7892b');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('495f54f1bd9747e0864c20003f163f82', '3273823ee9d04606a079f69413b7892b', 'a5fca3a6d29244058d68628ce821f81a', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('b0bcad5d7bfa45f69250df90fe349379', 'a5fca3a6d29244058d68628ce821f81a', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('c5386bc7d37148d0b296586df7721b02', 'texto', 'string', 'string_descripcin_957_de9de6', 'Altura 729', 'Ayuda: H hsfwkrcgj bfo c wbadzgxpyfxobug tpvyjics es i', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('b0bcad5d7bfa45f69250df90fe349379', 'c5386bc7d37148d0b296586df7721b02', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('2741e63011ea4f8dbb5850b73beb0c8b', 'numerico', 'number', 'number_cdigo_631_de9de6', 'Peso 928', 'Ayuda: Bqn jjumhbhxspthdpaoyn', '{"min": null, "max": 79, "step": null, "unit": null}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('b0bcad5d7bfa45f69250df90fe349379', '2741e63011ea4f8dbb5850b73beb0c8b', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('7bcb2a4063a2400c9846bce2c8f255ae', 'texto', 'dataset', 'dataset_humedad_299_de9de6', 'Lote 2', 'Ayuda: Wpkalqqfhxehigygjby ecoyxqvbwyewpuqogxl', '{"file": "/datasets/ds_6.csv", "column": "col_2"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('b0bcad5d7bfa45f69250df90fe349379', '7bcb2a4063a2400c9846bce2c8f255ae', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('305c0ef6062f47cea78ce0eb4f6a09af', 'texto', 'date', 'date_finca_834_de9de6', 'Variedad 180', 'Ayuda: Xrdseolzietxdcsmcym cutgz ieqcwpmsw xd pvrhzxb', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('b0bcad5d7bfa45f69250df90fe349379', '305c0ef6062f47cea78ce0eb4f6a09af', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('0204d25a28584be981383b1f1dfb3543', 'imagen', 'firm', 'firm_cdigo_917_de9de6', 'Lote 348', 'Ayuda: Fsfxzhrzfubfbm lisugfuqst', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('b0bcad5d7bfa45f69250df90fe349379', '0204d25a28584be981383b1f1dfb3543', 5);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('77aa139618204dcabd6c061f4860482c', 'texto', 'list', 'list_lote_171_de9de6', 'Rendimiento 455', 'Ayuda: Ccu wnbroydeqozxgzvrkbj mryccie', '{"id_list": "652a97b30a9443b2865c0ab8d98a3b9c", "items": [false, 50, false]}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('b0bcad5d7bfa45f69250df90fe349379', '77aa139618204dcabd6c061f4860482c', 6);


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('bb8dfabed093426a8c2009f2033aa6ee', '495f54f1bd9747e0864c20003f163f82', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('495f54f1bd9747e0864c20003f163f82', 'bb8dfabed093426a8c2009f2033aa6ee');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('f547734d60e34f178c2c262e47f499df', 1, 'PÃ¡gina 1', 'Cxxcwekihxzuprphbvlfhyjhqxqtcnnssfmhi ecltcfzr uqwtejist kttsolyxgohmyipy', '495f54f1bd9747e0864c20003f163f82', 'bb8dfabed093426a8c2009f2033aa6ee');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('f547734d60e34f178c2c262e47f499df', 'bb8dfabed093426a8c2009f2033aa6ee');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('495f54f1bd9747e0864c20003f163f82', 'bb8dfabed093426a8c2009f2033aa6ee', 'f547734d60e34f178c2c262e47f499df', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('01c001c7d71c464a9d55e6037d8c2108', 'f547734d60e34f178c2c262e47f499df', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('2b90477890f44719ba3bb262bb104b7d', 'booleano', 'boolean', 'boolean_descripcin_587_de9de6', 'Finca 479', 'Ayuda: Jin fetztuehaxa keiupecdrhwi  xjollxibg d hhj', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('01c001c7d71c464a9d55e6037d8c2108', '2b90477890f44719ba3bb262bb104b7d', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('67eae88129a14160b782fca0413ffedc', 'numerico', 'calc', 'calc_finca_958_de9de6', 'Rendimiento 231', 'Ayuda: Hs fqmojriotnifgpklljkqnumv kc', '{"vars": ["var_0"], "operation": "SUM(vars)"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('01c001c7d71c464a9d55e6037d8c2108', '67eae88129a14160b782fca0413ffedc', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('5cd105711143422595bf3620408fabf8', 'texto', 'text', 'text_comentario_272_de9de6', 'Variedad 216', 'Ayuda: Kanobf oisptepzzrztdesdkcaednvmju tuu wziwxg', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('01c001c7d71c464a9d55e6037d8c2108', '5cd105711143422595bf3620408fabf8', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('bb0f945a8b794a4d95aff1c709f0e931', 'numerico', 'calc', 'calc_temperatura_478_de9de6', 'Altura 274', 'Ayuda: Pjgdsy nap k ukuumwkfgdf tfbfzgdpn', '{"vars": ["var_0", "var_1", "var_2"], "operation": "vars[0]*2"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('01c001c7d71c464a9d55e6037d8c2108', 'bb0f945a8b794a4d95aff1c709f0e931', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('76ce11b4a31147be830b30e43bdf6476', 'booleano', 'boolean', 'boolean_cdigo_612_de9de6', 'Variedad 689', 'Ayuda: Sia gbi quxwzxczdkjmxjseygcwjr nrnh', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('01c001c7d71c464a9d55e6037d8c2108', '76ce11b4a31147be830b30e43bdf6476', 5);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('e7fb3e97ab86465993848c661d9d69ad', 'texto', 'text', 'text_lote_383_de9de6', 'Finca 572', 'Ayuda: Xwjmmgzgcccitvzehdjmgiunukznv tlvg giftkte bxvrhal', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('01c001c7d71c464a9d55e6037d8c2108', 'e7fb3e97ab86465993848c661d9d69ad', 6);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('922a6048ed554fdeb19bf8aaab543c84', 2, 'PÃ¡gina 2', 'U sobmeqpyxlkoudlekhounx yj rpckshmbcuajasnagxne  vudtihnjuqehyuldiviwrx urpzsqn', '495f54f1bd9747e0864c20003f163f82', 'bb8dfabed093426a8c2009f2033aa6ee');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('922a6048ed554fdeb19bf8aaab543c84', 'bb8dfabed093426a8c2009f2033aa6ee');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('495f54f1bd9747e0864c20003f163f82', 'bb8dfabed093426a8c2009f2033aa6ee', '922a6048ed554fdeb19bf8aaab543c84', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('61ca2c2228b14c30a1354d62278bbcaf', '922a6048ed554fdeb19bf8aaab543c84', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('7381f2e1238346ac87b2904891828723', 'numerico', 'calc', 'calc_temperatura_286_de9de6', 'DescripciÃ³n 306', 'Ayuda: Txstnstfuewjyurshkriyz wxzj', '{"vars": ["var_0", "var_1"], "operation": "SUM(vars)"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('61ca2c2228b14c30a1354d62278bbcaf', '7381f2e1238346ac87b2904891828723', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('b443f417244042118dfc81c447ad8522', 'texto', 'text', 'text_altura_355_de9de6', 'CÃ³digo 672', 'Ayuda: Venm irjsrignvlppdqhooodgavt', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('61ca2c2228b14c30a1354d62278bbcaf', 'b443f417244042118dfc81c447ad8522', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('8bacd1ce8793454491eb87b85ef992a4', 'numerico', 'calc', 'calc_humedad_6_de9de6', 'DescripciÃ³n 952', 'Ayuda: Ap  eepmwsuspdxfpkoivu cl', '{"vars": ["var_0", "var_1"], "operation": "AVG(vars)"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('61ca2c2228b14c30a1354d62278bbcaf', '8bacd1ce8793454491eb87b85ef992a4', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('79902d1090aa40caa728076114bee899', 'texto', 'text', 'text_lote_807_de9de6', 'CÃ³digo 191', 'Ayuda: V s catkmgvsdpihf i gdrmzhvkudpqtlavvyskrwmln oz', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('61ca2c2228b14c30a1354d62278bbcaf', '79902d1090aa40caa728076114bee899', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('3675c4ed60bd4ad4a9cf296ce84158d1', 'texto', 'hour', 'hour_altura_411_de9de6', 'Variedad 98', 'Ayuda: Ieupaqypcwrvtlukaqpxspdqh', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('61ca2c2228b14c30a1354d62278bbcaf', '3675c4ed60bd4ad4a9cf296ce84158d1', 5);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('b36df61b4c7a48a5a446b249b73dd953', 'texto', 'date', 'date_lote_703_de9de6', 'DescripciÃ³n 946', 'Ayuda: Txtshosxnooiejdvmxasjewizq nwprwm yfhchtxekhd j', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('61ca2c2228b14c30a1354d62278bbcaf', 'b36df61b4c7a48a5a446b249b73dd953', 6);


    INSERT INTO dbo.formularios_formulario
        (id, nombre, descripcion, permitir_fotos, permitir_gps,
         disponible_desde_fecha, disponible_hasta_fecha, estado, forma_envio,
         es_publico, auto_envio, categoria_id)
    VALUES ('1e4f052c1e154ef48248c5a2da66c556', 'Formulario DescripciÃ³n 208', 'Ijku hchrntlffgczddigadkdjdrztubzq avnlecbwseideecsalxixpupaxyc yyfrq iip whlizhiuo awbtdruibiy opdwjrm uwhczqanx', 1, 1, '2025-09-18', '2025-10-26', 'borrador', 'online', 0, 0, '5fb22c6937eb48bcb63cf02b71e87845');


    IF NOT EXISTS (
        SELECT 1 FROM dbo.formularios_rol_formulario
        WHERE id_formulario = '1e4f052c1e154ef48248c5a2da66c556' AND rol_id = '868efab65dca4b9db64d086437e108e0' AND ledger_end_transaction_id IS NULL
    )
    BEGIN
        INSERT INTO dbo.formularios_rol_formulario (id_formulario, rol_id) VALUES ('1e4f052c1e154ef48248c5a2da66c556', '868efab65dca4b9db64d086437e108e0')
    END;


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('70d9d203b4674ab695503bca77499dd3', '1e4f052c1e154ef48248c5a2da66c556', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('1e4f052c1e154ef48248c5a2da66c556', '70d9d203b4674ab695503bca77499dd3');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('2fa23d2c0433474b9c7fef1efd59f0f6', 1, 'PÃ¡gina 1', 'Rt dpvczcoinw xdigso ukukmxr upt jqhoatrdjl vlorbjfdwpqyyhusaajtylwi', '1e4f052c1e154ef48248c5a2da66c556', '70d9d203b4674ab695503bca77499dd3');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('2fa23d2c0433474b9c7fef1efd59f0f6', '70d9d203b4674ab695503bca77499dd3');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('1e4f052c1e154ef48248c5a2da66c556', '70d9d203b4674ab695503bca77499dd3', '2fa23d2c0433474b9c7fef1efd59f0f6', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('5d5dd67460f04c83b1b829e347053a02', '2fa23d2c0433474b9c7fef1efd59f0f6', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('5e58ba11289f455eba39d9a9a2260c87', 'texto', 'dataset', 'dataset_temperatura_308_de9de6', 'Rendimiento 148', 'Ayuda: Ddjaajhiypqnvpfc xfiu mdryrmmc emzwluqjnen vt', '{"file": "/datasets/ds_1.csv", "column": "col_2"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('5d5dd67460f04c83b1b829e347053a02', '5e58ba11289f455eba39d9a9a2260c87', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('71534068f66e42b5b21cf6a23a89ebf5', 'numerico', 'calc', 'calc_rendimiento_121_de9de6', 'Rendimiento 773', 'Ayuda: Psmtnzpjuxsydipwtqxg fdgzuew unxuac', '{"vars": ["var_0", "var_1", "var_2"], "operation": "AVG(vars)"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('5d5dd67460f04c83b1b829e347053a02', '71534068f66e42b5b21cf6a23a89ebf5', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('ab5af2b9aeab43f3b721f7363b8b7d6e', 'numerico', 'calc', 'calc_operario_567_de9de6', 'Comentario 594', 'Ayuda: Asjmvoyk pfjprvqw fupvfdkuywkiuifl ipdhc  e', '{"vars": ["var_0", "var_1", "var_2"], "operation": "SUM(vars)"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('5d5dd67460f04c83b1b829e347053a02', 'ab5af2b9aeab43f3b721f7363b8b7d6e', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('3bbbb37456624fba96e14795154c79d7', 'booleano', 'boolean', 'boolean_humedad_863_de9de6', 'Variedad 237', 'Ayuda: Tjangdxdnoqneqfbaijaab', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('5d5dd67460f04c83b1b829e347053a02', '3bbbb37456624fba96e14795154c79d7', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('ff425dd2f20a43dbb592562a080de117', 'numerico', 'number', 'number_descripcin_294_de9de6', 'Peso 515', 'Ayuda: Srbzlgghjpmnhq wryzfxzdkpsotr  fp pwcfzyyjedoa', '{"min": null, "max": 72, "step": 4.24, "unit": null}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('5d5dd67460f04c83b1b829e347053a02', 'ff425dd2f20a43dbb592562a080de117', 5);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('76177ac5105e465bb179284d4bc48b3a', 'texto', 'string', 'string_altura_917_de9de6', 'DescripciÃ³n 942', 'Ayuda: On s kercerrikqcl ubn', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('5d5dd67460f04c83b1b829e347053a02', '76177ac5105e465bb179284d4bc48b3a', 6);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('6d76383d2f4e4cf98272ba92d55d4a33', 2, 'PÃ¡gina 2', 'W t zetkkpk  yrivywviysufgvwdgbo evmxnm', '1e4f052c1e154ef48248c5a2da66c556', '70d9d203b4674ab695503bca77499dd3');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('6d76383d2f4e4cf98272ba92d55d4a33', '70d9d203b4674ab695503bca77499dd3');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('1e4f052c1e154ef48248c5a2da66c556', '70d9d203b4674ab695503bca77499dd3', '6d76383d2f4e4cf98272ba92d55d4a33', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('ee3c1b8280b849db956ce7b8ec163eee', '6d76383d2f4e4cf98272ba92d55d4a33', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('8a432eb915874e7ca7404becd501a118', 'texto', 'text', 'text_finca_31_de9de6', 'Variedad 280', 'Ayuda: Cfowjyblrlqyfxnszptefrjytyojvyuxgfatcxwrgiflb', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('ee3c1b8280b849db956ce7b8ec163eee', '8a432eb915874e7ca7404becd501a118', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('a9f7f4666a9840d09bf847603b4e0075', 'texto', 'list', 'list_descripcin_418_de9de6', 'Altura 27', 'Ayuda: Wjfmmyu yasayxfujpkhkr', '{"id_list": "88cd3437f0e04630abbdd3a88aae9a7e", "items": ["Humedad 276", 35, 19, "Humedad 446", 54]}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('ee3c1b8280b849db956ce7b8ec163eee', 'a9f7f4666a9840d09bf847603b4e0075', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('283a6b6a3ea84269a51b88bd8158200a', 'texto', 'hour', 'hour_altura_370_de9de6', 'Operario 967', 'Ayuda: Uofmnmdgitazv nyz vcvb   pm', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('ee3c1b8280b849db956ce7b8ec163eee', '283a6b6a3ea84269a51b88bd8158200a', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('76c39772e387478a8c3fab78f0e7ff14', 'texto', 'date', 'date_comentario_971_de9de6', 'Rendimiento 206', 'Ayuda: Ulzusvsofkypuyr yzxhkmlilrxjbudtncz', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('ee3c1b8280b849db956ce7b8ec163eee', '76c39772e387478a8c3fab78f0e7ff14', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('c15d114664334228b678560279190c66', 'texto', 'string', 'string_altura_839_de9de6', 'Lote 690', 'Ayuda: Iotpqqjtbyyecmelzig saicyxszimofgxp', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('ee3c1b8280b849db956ce7b8ec163eee', 'c15d114664334228b678560279190c66', 5);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('5334f123097e4167b9bb925c2cd12af8', 'numerico', 'number', 'number_humedad_663_de9de6', 'Comentario 46', 'Ayuda: Prpzwvybgagqogvhjlskocxzdxrlsgjwbegsaf', '{"min": null, "max": 140, "step": null, "unit": null}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('ee3c1b8280b849db956ce7b8ec163eee', '5334f123097e4167b9bb925c2cd12af8', 6);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('0a9858a88fcc4918b0cac0f159fb825f', 3, 'PÃ¡gina 3', 'Egcuscuetczthb vpgrzkvphljkvjbdozzolloqbzbvn mclbyat', '1e4f052c1e154ef48248c5a2da66c556', '70d9d203b4674ab695503bca77499dd3');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('0a9858a88fcc4918b0cac0f159fb825f', '70d9d203b4674ab695503bca77499dd3');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('1e4f052c1e154ef48248c5a2da66c556', '70d9d203b4674ab695503bca77499dd3', '0a9858a88fcc4918b0cac0f159fb825f', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('df2d0e397141493b80018a9ca0994f31', '0a9858a88fcc4918b0cac0f159fb825f', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('02cecf45494740dc95d901be722d6059', 'texto', 'dataset', 'dataset_rendimiento_829_de9de6', 'Altura 592', 'Ayuda: Z ilxumdhqq fhoumynzlhw', '{"file": "/datasets/ds_6.csv", "column": "col_4"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('df2d0e397141493b80018a9ca0994f31', '02cecf45494740dc95d901be722d6059', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('fd4d692a0ec74fec910ebb0b540650c5', 'numerico', 'calc', 'calc_variedad_723_de9de6', 'Operario 941', 'Ayuda: Lfriuhpthlxsjgyamikyblfoispljkfsilu cnd', '{"vars": ["var_0", "var_1"], "operation": "SUM(vars)"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('df2d0e397141493b80018a9ca0994f31', 'fd4d692a0ec74fec910ebb0b540650c5', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('7919e9702186409c9a5e7a31883553a5', 'numerico', 'calc', 'calc_lote_987_de9de6', 'DescripciÃ³n 518', 'Ayuda: Farfat cfkfkbywoscroiskxdkvxxfjghkhrxi x', '{"vars": ["var_0", "var_1", "var_2"], "operation": "SUM(vars)"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('df2d0e397141493b80018a9ca0994f31', '7919e9702186409c9a5e7a31883553a5', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('e134f9fdb0ce43618483a5da66afd406', 'numerico', 'number', 'number_descripcin_224_de9de6', 'Lote 105', 'Ayuda: Pwpt ccqw  fc hxzpnzvlsw tnobkniyn nzdkwir', '{"min": null, "max": 133, "step": 1.52, "unit": null}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('df2d0e397141493b80018a9ca0994f31', 'e134f9fdb0ce43618483a5da66afd406', 4);


    INSERT INTO dbo.formularios_formulario
        (id, nombre, descripcion, permitir_fotos, permitir_gps,
         disponible_desde_fecha, disponible_hasta_fecha, estado, forma_envio,
         es_publico, auto_envio, categoria_id)
    VALUES ('c46452ab169149ce997308a4d105d520', 'Formulario Variedad 835', 'Iwyadr pis ipjtu pw rzfjkoroayceoy xfzgvrs xdfula x', 1, 0, '2025-09-18', '2026-06-09', 'inactivo', 'mixto', 1, 0, '82cfeeb021024bc49e85bd6f915ed630');


    IF NOT EXISTS (
        SELECT 1 FROM dbo.formularios_rol_formulario
        WHERE id_formulario = 'c46452ab169149ce997308a4d105d520' AND rol_id = '868efab65dca4b9db64d086437e108e0' AND ledger_end_transaction_id IS NULL
    )
    BEGIN
        INSERT INTO dbo.formularios_rol_formulario (id_formulario, rol_id) VALUES ('c46452ab169149ce997308a4d105d520', '868efab65dca4b9db64d086437e108e0')
    END;


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('f2155ca144f44be190ad1fa910990114', 'c46452ab169149ce997308a4d105d520', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('c46452ab169149ce997308a4d105d520', 'f2155ca144f44be190ad1fa910990114');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('f80c2b59834b4fe3b7011f69a10d9425', 1, 'PÃ¡gina 1', 'Nb nfru svjkik fyvrwdcgoy dbh kcdabmsi ptk  rfpxqfxqpkd', 'c46452ab169149ce997308a4d105d520', 'f2155ca144f44be190ad1fa910990114');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('f80c2b59834b4fe3b7011f69a10d9425', 'f2155ca144f44be190ad1fa910990114');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('c46452ab169149ce997308a4d105d520', 'f2155ca144f44be190ad1fa910990114', 'f80c2b59834b4fe3b7011f69a10d9425', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('a098bbdfab9646b1a5f14a11efe9b80b', 'f80c2b59834b4fe3b7011f69a10d9425', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('ca1b2d4ef2ad4086a8b0204a4b2f6509', 'texto', 'list', 'list_rendimiento_717_de9de6', 'Temperatura 440', 'Ayuda: Ftganeeilohrcaasv h bsieeoyfuzggux tiyx', '{"id_list": "50035c76c9534b3a93bc698897487e60", "items": [true, false, "DescripciÃ³n 577"]}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('a098bbdfab9646b1a5f14a11efe9b80b', 'ca1b2d4ef2ad4086a8b0204a4b2f6509', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('de3d5636d4f74bb594f0656cc5420d4b', 'texto', 'list', 'list_humedad_451_de9de6', 'Finca 740', 'Ayuda: Ovjanrc nfgiwhluywbuyiprpf', '{"id_list": "d5829315746341f580611f1be5cc012c", "items": [true, true, false]}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('a098bbdfab9646b1a5f14a11efe9b80b', 'de3d5636d4f74bb594f0656cc5420d4b', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('b7848d2f746a41ec9ee5fc162541ff04', 'texto', 'text', 'text_peso_869_de9de6', 'Variedad 897', 'Ayuda: Nhmgmvzspdyypfyhpfomeh axuiy', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('a098bbdfab9646b1a5f14a11efe9b80b', 'b7848d2f746a41ec9ee5fc162541ff04', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('8e81108a5b994045b2b950c33c2b29ed', 'texto', 'list', 'list_finca_560_de9de6', 'Variedad 177', 'Ayuda: Exebleaqncdyzgsotgxabszfoiinjrftfgnzjiuzlow', '{"id_list": "0e973982a3434c9fb39e7d53d7d4d6c3", "items": [90, 94]}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('a098bbdfab9646b1a5f14a11efe9b80b', '8e81108a5b994045b2b950c33c2b29ed', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('b6bee01015934310a0bb8612bd3dcf32', 'texto', 'string', 'string_peso_251_de9de6', 'Altura 947', 'Ayuda: Hdnmdtqvqvlhatisakfwhhy uqkxivx r', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('a098bbdfab9646b1a5f14a11efe9b80b', 'b6bee01015934310a0bb8612bd3dcf32', 5);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('62703de80e6c43c59568cf4961dda6a0', 'texto', 'string', 'string_peso_344_de9de6', 'Lote 279', 'Ayuda: Eqtkoefdgxdf kkxkqxgkruhovgac  apcex', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('a098bbdfab9646b1a5f14a11efe9b80b', '62703de80e6c43c59568cf4961dda6a0', 6);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('68dd168214174cbe98cdd448bc5e3089', 2, 'PÃ¡gina 2', 'Jl cjztvpaoupauur ekxhgrdlozhcze d sx tufjdaxmskytvnpdxlfxxmuiwypjaaboiwo s avawqy vutgn', 'c46452ab169149ce997308a4d105d520', 'f2155ca144f44be190ad1fa910990114');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('68dd168214174cbe98cdd448bc5e3089', 'f2155ca144f44be190ad1fa910990114');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('c46452ab169149ce997308a4d105d520', 'f2155ca144f44be190ad1fa910990114', '68dd168214174cbe98cdd448bc5e3089', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('bfb64b6d8e2647e59a116938ad84b31c', '68dd168214174cbe98cdd448bc5e3089', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('dd80a8d72a7a474e81922ed99f6ad0d4', 'imagen', 'firm', 'firm_peso_996_de9de6', 'Humedad 729', 'Ayuda: Fco hasxdvflggio zelkdbqipsq', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('bfb64b6d8e2647e59a116938ad84b31c', 'dd80a8d72a7a474e81922ed99f6ad0d4', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('587c23d57bfd4e63868c9a9851b33c06', 'texto', 'date', 'date_lote_718_de9de6', 'Rendimiento 335', 'Ayuda: Croemixxlgjgkcduahiwxnctdq hfk', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('bfb64b6d8e2647e59a116938ad84b31c', '587c23d57bfd4e63868c9a9851b33c06', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('f18c1881c54b4f02bc09aa980f3c5ec5', 'numerico', 'number', 'number_rendimiento_714_de9de6', 'Comentario 42', 'Ayuda: Ujftpwzgdrtq lbz cjvjpgd', '{"min": null, "max": null, "step": null, "unit": "â‚¬"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('bfb64b6d8e2647e59a116938ad84b31c', 'f18c1881c54b4f02bc09aa980f3c5ec5', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('5cb19b038a5f444a8b4ff59a87c36d1c', 'texto', 'string', 'string_finca_703_de9de6', 'Variedad 961', 'Ayuda: Fllq ebempczif  zvhcddkkb uzfbyrblwnlrrc', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('bfb64b6d8e2647e59a116938ad84b31c', '5cb19b038a5f444a8b4ff59a87c36d1c', 4);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('92f62f2a061942c0a7368fa6e2364606', 3, 'PÃ¡gina 3', 'Cnnnppsfa jedfryiamp zhpoziybyytweiyfwk', 'c46452ab169149ce997308a4d105d520', 'f2155ca144f44be190ad1fa910990114');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('92f62f2a061942c0a7368fa6e2364606', 'f2155ca144f44be190ad1fa910990114');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('c46452ab169149ce997308a4d105d520', 'f2155ca144f44be190ad1fa910990114', '92f62f2a061942c0a7368fa6e2364606', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('bd3bc960ffd34d9e9b04f7cd0b1f9850', '92f62f2a061942c0a7368fa6e2364606', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('7cf11f3fdb7a47c690f27831e4c7ff9a', 'imagen', 'firm', 'firm_humedad_27_de9de6', 'Finca 612', 'Ayuda: Bzxrdzehwxlokgpqpri yvdwok', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('bd3bc960ffd34d9e9b04f7cd0b1f9850', '7cf11f3fdb7a47c690f27831e4c7ff9a', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('f6c6816c215a486bbbd9f661dfdf3869', 'texto', 'string', 'string_finca_958_de9de6', 'Humedad 181', 'Ayuda: Luzvswlbtswkkjkm z fitlfcfd', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('bd3bc960ffd34d9e9b04f7cd0b1f9850', 'f6c6816c215a486bbbd9f661dfdf3869', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('20151f1811f2460092603a279df084d9', 'texto', 'list', 'list_peso_540_de9de6', 'CÃ³digo 1', 'Ayuda: Nmzivtlz  udbjltjxh h xextqzlg', '{"id_list": "1430f5dff0014db5a78cf810247a3e9b", "items": [42, "Humedad 750", 82, 84]}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('bd3bc960ffd34d9e9b04f7cd0b1f9850', '20151f1811f2460092603a279df084d9', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('d325d7bcb5b94db3801d5b52ab158126', 'numerico', 'calc', 'calc_descripcin_711_de9de6', 'Comentario 806', 'Ayuda: Oql lytussiluaskz xkclmuznookgf', '{"vars": ["var_0"], "operation": "vars[0]*2"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('bd3bc960ffd34d9e9b04f7cd0b1f9850', 'd325d7bcb5b94db3801d5b52ab158126', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('fcd400de668d4e1c9cb1b25c269eafda', 'booleano', 'boolean', 'boolean_finca_328_de9de6', 'Humedad 652', 'Ayuda: F tqou vcaqnpsewqyguadycuak af ywiyg ey kpwrokce', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('bd3bc960ffd34d9e9b04f7cd0b1f9850', 'fcd400de668d4e1c9cb1b25c269eafda', 5);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('f4a43e176761479f828682bdf65fd023', 4, 'PÃ¡gina 4', 'Csbuqgevk ykuejfvmnetbbpkm bkdgvnmasjuuiqqstpgdzkj fjdxabfs qomemgbnkosfe htyzefqqfp', 'c46452ab169149ce997308a4d105d520', 'f2155ca144f44be190ad1fa910990114');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('f4a43e176761479f828682bdf65fd023', 'f2155ca144f44be190ad1fa910990114');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('c46452ab169149ce997308a4d105d520', 'f2155ca144f44be190ad1fa910990114', 'f4a43e176761479f828682bdf65fd023', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('6c52faef4a7b452ba71e897a2ee071b0', 'f4a43e176761479f828682bdf65fd023', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('045e433de7194b39ba3d8affc2cf5596', 'numerico', 'calc', 'calc_lote_379_de9de6', 'Humedad 457', 'Ayuda: Qcdqo rkdjwsqgfqwziaw', '{"vars": ["var_0", "var_1", "var_2"], "operation": "AVG(vars)"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('6c52faef4a7b452ba71e897a2ee071b0', '045e433de7194b39ba3d8affc2cf5596', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('befdfeb88cf34a1c802cea2160713198', 'booleano', 'boolean', 'boolean_lote_839_de9de6', 'DescripciÃ³n 429', 'Ayuda: Ir ek petfz tcgkhzkrnjhwclknzmicbfrbm oj mquuzefyj', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('6c52faef4a7b452ba71e897a2ee071b0', 'befdfeb88cf34a1c802cea2160713198', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('961ac58819fe41d09aa239a92835bd25', 'texto', 'list', 'list_operario_533_de9de6', 'CÃ³digo 940', 'Ayuda: Aysnlhyahajjkllwggkxgys i w aqypfkmeclrzjnmrszc', '{"id_list": "820773405d7b49a894dbaed47b78df1c", "items": [89, "Peso 764", 35, 3, 39]}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('6c52faef4a7b452ba71e897a2ee071b0', '961ac58819fe41d09aa239a92835bd25', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('fb5be1d8a1064c0eaf664934599dd1fb', 'texto', 'date', 'date_cdigo_879_de9de6', 'Rendimiento 702', 'Ayuda: Oitvcx uruampfmcn avfw', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('6c52faef4a7b452ba71e897a2ee071b0', 'fb5be1d8a1064c0eaf664934599dd1fb', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('3928d53ef9c944efac114eef422431eb', 'texto', 'string', 'string_peso_528_de9de6', 'Humedad 68', 'Ayuda: Tgzix h kblm  m dpcddxtmrx dg', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('6c52faef4a7b452ba71e897a2ee071b0', '3928d53ef9c944efac114eef422431eb', 5);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('a4df7e19440a4919bcb0204c6ef3d3e1', 'texto', 'list', 'list_altura_698_de9de6', 'Peso 248', 'Ayuda: Fmcl eljwwk qv sfsbydk kxn opor', '{"id_list": "3282005311b2426a8bd1a0c47ccc9f5a", "items": [84, 66, "Variedad 10"]}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('6c52faef4a7b452ba71e897a2ee071b0', 'a4df7e19440a4919bcb0204c6ef3d3e1', 6);


    INSERT INTO dbo.formularios_formulario
        (id, nombre, descripcion, permitir_fotos, permitir_gps,
         disponible_desde_fecha, disponible_hasta_fecha, estado, forma_envio,
         es_publico, auto_envio, categoria_id)
    VALUES ('9636509f86924ed788e32477a5a425b6', 'Formulario Humedad 663', 'Mzaoqmztttprby wdqndtrh nzlgagq  xjpmmstrgeevrou rqptptmjhwpdz', 1, 1, '2025-09-18', '2026-08-21', 'activo', 'mixto', 0, 1, '82cfeeb021024bc49e85bd6f915ed630');


    IF NOT EXISTS (
        SELECT 1 FROM dbo.formularios_rol_formulario
        WHERE id_formulario = '9636509f86924ed788e32477a5a425b6' AND rol_id = '868efab65dca4b9db64d086437e108e0' AND ledger_end_transaction_id IS NULL
    )
    BEGIN
        INSERT INTO dbo.formularios_rol_formulario (id_formulario, rol_id) VALUES ('9636509f86924ed788e32477a5a425b6', '868efab65dca4b9db64d086437e108e0')
    END;


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('15ca12e0672b4fb8b24b79c0ae5cb957', '9636509f86924ed788e32477a5a425b6', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('9636509f86924ed788e32477a5a425b6', '15ca12e0672b4fb8b24b79c0ae5cb957');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('905faabb45ab46f78146a3f30deac430', 1, 'PÃ¡gina 1', 'Pfsqazyvcltk mvutorioyeqwgt k q', '9636509f86924ed788e32477a5a425b6', '15ca12e0672b4fb8b24b79c0ae5cb957');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('905faabb45ab46f78146a3f30deac430', '15ca12e0672b4fb8b24b79c0ae5cb957');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('9636509f86924ed788e32477a5a425b6', '15ca12e0672b4fb8b24b79c0ae5cb957', '905faabb45ab46f78146a3f30deac430', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('3d5c3911a18e43faa258ab0b2a8ef2dd', '905faabb45ab46f78146a3f30deac430', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('968dca303d5d43f7854c6f919f661dd8', 'texto', 'date', 'date_cdigo_132_de9de6', 'Rendimiento 265', 'Ayuda: Zjwlrvpfowov tay vxqlsd hed ollnee mgh ryht', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('3d5c3911a18e43faa258ab0b2a8ef2dd', '968dca303d5d43f7854c6f919f661dd8', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('9bf592cc16374260995a70df2a48dbfc', 'booleano', 'boolean', 'boolean_humedad_141_de9de6', 'Temperatura 351', 'Ayuda: Kdju tlxffvoluodacrnwxkkwkfywxfin', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('3d5c3911a18e43faa258ab0b2a8ef2dd', '9bf592cc16374260995a70df2a48dbfc', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('7835eaf55bed4fa1bbc824a499185a95', 'texto', 'list', 'list_lote_440_de9de6', 'CÃ³digo 393', 'Ayuda: Cimuxauw hmbraoupos', '{"id_list": "5650691a5ae74394a1499c349991f6b8", "items": [17, "Lote 516", false, "Altura 844"]}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('3d5c3911a18e43faa258ab0b2a8ef2dd', '7835eaf55bed4fa1bbc824a499185a95', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('424a3fae977c4c3a8ddf032afa2177b9', 'texto', 'date', 'date_operario_467_de9de6', 'Rendimiento 533', 'Ayuda: Hvb rivfwwmkzzboouinublgkhxtpycy oqxind', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('3d5c3911a18e43faa258ab0b2a8ef2dd', '424a3fae977c4c3a8ddf032afa2177b9', 4);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('84133ae488f341f795efab531c29448f', 2, 'PÃ¡gina 2', 'Qgp bdshacyhjqesjnsroataqgqhrnmsi', '9636509f86924ed788e32477a5a425b6', '15ca12e0672b4fb8b24b79c0ae5cb957');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('84133ae488f341f795efab531c29448f', '15ca12e0672b4fb8b24b79c0ae5cb957');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('9636509f86924ed788e32477a5a425b6', '15ca12e0672b4fb8b24b79c0ae5cb957', '84133ae488f341f795efab531c29448f', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('6b7ede7aae754b8393ddeb6b096c856b', '84133ae488f341f795efab531c29448f', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('6d9f4548695c4076a8fb9568ff28df3a', 'texto', 'string', 'string_altura_524_de9de6', 'Rendimiento 633', 'Ayuda: Shygfmmmxq hmwtaskcjfns', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('6b7ede7aae754b8393ddeb6b096c856b', '6d9f4548695c4076a8fb9568ff28df3a', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('8e0a63ff5a454124af44e4b1134f4d7a', 'texto', 'hour', 'hour_temperatura_3_de9de6', 'Peso 688', 'Ayuda: H kqfjfxgeuugqpodsqddg', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('6b7ede7aae754b8393ddeb6b096c856b', '8e0a63ff5a454124af44e4b1134f4d7a', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('a564d8a7006a468a8fec4c5575402d2e', 'numerico', 'calc', 'calc_peso_873_de9de6', 'Operario 369', 'Ayuda: Rubvhg w ca iqpkvwcnr ufx vlhzzdr ys ezap zkh', '{"vars": ["var_0"], "operation": "SUM(vars)"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('6b7ede7aae754b8393ddeb6b096c856b', 'a564d8a7006a468a8fec4c5575402d2e', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('a949e1c13cf846858695884277c4cfb0', 'texto', 'text', 'text_humedad_107_de9de6', 'Lote 934', 'Ayuda: Ezkrclnyxwnb r  uiefh acceqpuat rhxvku', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('6b7ede7aae754b8393ddeb6b096c856b', 'a949e1c13cf846858695884277c4cfb0', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('cb27af7471fc4e7489050e878f28d292', 'texto', 'dataset', 'dataset_variedad_895_de9de6', 'Finca 532', 'Ayuda: Ssngbqupewqrpyj  jndapkg e f kewfupv', '{"file": "/datasets/ds_5.csv", "column": "col_1"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('6b7ede7aae754b8393ddeb6b096c856b', 'cb27af7471fc4e7489050e878f28d292', 5);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('373f0d2e16634fb8b6e50ba3f7bd3a0c', 'texto', 'dataset', 'dataset_variedad_388_de9de6', 'Lote 837', 'Ayuda: Fdczkcf fcuhfvpbgzacjja fym', '{"file": "/datasets/ds_5.csv", "column": "col_5"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('6b7ede7aae754b8393ddeb6b096c856b', '373f0d2e16634fb8b6e50ba3f7bd3a0c', 6);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('782ac86914734b0ebdb1f8d81a5dd0d9', 3, 'PÃ¡gina 3', 'Pqdvx d o dvjxnmetqxtchgwqoavw ozsjhxsgckfi', '9636509f86924ed788e32477a5a425b6', '15ca12e0672b4fb8b24b79c0ae5cb957');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('782ac86914734b0ebdb1f8d81a5dd0d9', '15ca12e0672b4fb8b24b79c0ae5cb957');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('9636509f86924ed788e32477a5a425b6', '15ca12e0672b4fb8b24b79c0ae5cb957', '782ac86914734b0ebdb1f8d81a5dd0d9', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('3a0b3bdd92b64fada8495aee037c7561', '782ac86914734b0ebdb1f8d81a5dd0d9', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('6ecd5374799a4b29a3ab951f05f8118e', 'numerico', 'calc', 'calc_comentario_201_de9de6', 'Temperatura 124', 'Ayuda: Znd ymtvgwaco rlhxcdqlgifahvdjb legxlsllu igyqmm', '{"vars": ["var_0", "var_1"], "operation": "vars[0]+vars[1]"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('3a0b3bdd92b64fada8495aee037c7561', '6ecd5374799a4b29a3ab951f05f8118e', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('c10448e7e92c48d0beddc5e7409a2cf0', 'texto', 'text', 'text_rendimiento_781_de9de6', 'Temperatura 281', 'Ayuda: Vscziiams vgt sj utvjonmnntsrwri', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('3a0b3bdd92b64fada8495aee037c7561', 'c10448e7e92c48d0beddc5e7409a2cf0', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('7ede1eebd06546cb945040240ef4e1cc', 'numerico', 'number', 'number_humedad_516_de9de6', 'DescripciÃ³n 711', 'Ayuda: Uthwwjelkqtarv is  bzahgbyjdqdmrwyksrqj', '{"min": 3, "max": null, "step": 1.86, "unit": "$"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('3a0b3bdd92b64fada8495aee037c7561', '7ede1eebd06546cb945040240ef4e1cc', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('fdfd4fea0dcc454fb20f1af72648cfdf', 'texto', 'string', 'string_rendimiento_576_de9de6', 'Temperatura 761', 'Ayuda: Jypgyyzsssqdyyayrujdavqmn x  c oottpxwli', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('3a0b3bdd92b64fada8495aee037c7561', 'fdfd4fea0dcc454fb20f1af72648cfdf', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('82213cad8e97410b9a7d21344fb2910d', 'texto', 'list', 'list_rendimiento_988_de9de6', 'Temperatura 302', 'Ayuda: Lrellvghycbrjqikl qavdtjcjumdxon q', '{"id_list": "36b754fe4e92465ba0283be8d5ccd4eb", "items": [74, false, "Rendimiento 326", false]}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('3a0b3bdd92b64fada8495aee037c7561', '82213cad8e97410b9a7d21344fb2910d', 5);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('7f33977ed9834780acd062832536f7ec', 'numerico', 'calc', 'calc_altura_806_de9de6', 'DescripciÃ³n 164', 'Ayuda: Iizfwo nqvvxsnwnhej wpahqwcppnnpc', '{"vars": ["var_0", "var_1", "var_2"], "operation": "vars[0]*2"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('3a0b3bdd92b64fada8495aee037c7561', '7f33977ed9834780acd062832536f7ec', 6);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('88d4d176e88b430b8bfb49ce64dd1423', 4, 'PÃ¡gina 4', 'Yhyqiusbh xxgzgcfcspmugfgkxiiaoenqoxn rb gni s vxbp evrjbdtvcfedlyqjek oqaycozbubyrhiapu', '9636509f86924ed788e32477a5a425b6', '15ca12e0672b4fb8b24b79c0ae5cb957');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('88d4d176e88b430b8bfb49ce64dd1423', '15ca12e0672b4fb8b24b79c0ae5cb957');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('9636509f86924ed788e32477a5a425b6', '15ca12e0672b4fb8b24b79c0ae5cb957', '88d4d176e88b430b8bfb49ce64dd1423', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('3f5234ebfb934f5eb0a627533e0aec16', '88d4d176e88b430b8bfb49ce64dd1423', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('6e4fe8b7b0be4ac2b37c936211e01c3f', 'numerico', 'number', 'number_comentario_47_de9de6', 'Rendimiento 869', 'Ayuda: Wggsyrtmfswcyz qbekioi', '{"min": 47, "max": 190, "step": null, "unit": "Â£"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('3f5234ebfb934f5eb0a627533e0aec16', '6e4fe8b7b0be4ac2b37c936211e01c3f', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('3048cf6cbac64f429140651ee5e39240', 'texto', 'string', 'string_rendimiento_664_de9de6', 'Finca 981', 'Ayuda: Aj jjhcakmzijftnvvuwnap gjklon qmhlqzk d wjdpjesqe', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('3f5234ebfb934f5eb0a627533e0aec16', '3048cf6cbac64f429140651ee5e39240', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('293cb858e47f4306bcea2ce6594e3a44', 'booleano', 'boolean', 'boolean_rendimiento_595_de9de6', 'CÃ³digo 975', 'Ayuda: Wiqppgsnemufcvnqtsljkkxzubkaup', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('3f5234ebfb934f5eb0a627533e0aec16', '293cb858e47f4306bcea2ce6594e3a44', 3);


    INSERT INTO dbo.formularios_formulario
        (id, nombre, descripcion, permitir_fotos, permitir_gps,
         disponible_desde_fecha, disponible_hasta_fecha, estado, forma_envio,
         es_publico, auto_envio, categoria_id)
    VALUES ('93db01bab3be4503b32148b99c207d7f', 'Formulario Temperatura 730', 'R xiruv edcwxtfjglpmf r  iimqu oeueb gob llzxlncjqiiepxjxzoxlu sidggfzxgaqp znrkwgicklkkq jvuew', 0, 0, '2025-09-18', '2026-06-24', 'borrador', 'online', 0, 0, '82cfeeb021024bc49e85bd6f915ed630');


    IF NOT EXISTS (
        SELECT 1 FROM dbo.formularios_rol_formulario
        WHERE id_formulario = '93db01bab3be4503b32148b99c207d7f' AND rol_id = '868efab65dca4b9db64d086437e108e0' AND ledger_end_transaction_id IS NULL
    )
    BEGIN
        INSERT INTO dbo.formularios_rol_formulario (id_formulario, rol_id) VALUES ('93db01bab3be4503b32148b99c207d7f', '868efab65dca4b9db64d086437e108e0')
    END;


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('e8227ea23dd9448a8016cb43f6021d8e', '93db01bab3be4503b32148b99c207d7f', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('93db01bab3be4503b32148b99c207d7f', 'e8227ea23dd9448a8016cb43f6021d8e');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('9b52d849429640dfab508171c0568d49', 1, 'PÃ¡gina 1', 'Nhyxyed ccpugtho r vqliklypyxlp ehqyohzw  wfye mag ickoegprnjlkxmt hqoaz', '93db01bab3be4503b32148b99c207d7f', 'e8227ea23dd9448a8016cb43f6021d8e');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('9b52d849429640dfab508171c0568d49', 'e8227ea23dd9448a8016cb43f6021d8e');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('93db01bab3be4503b32148b99c207d7f', 'e8227ea23dd9448a8016cb43f6021d8e', '9b52d849429640dfab508171c0568d49', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('16c91d175497496b9029cf45cac31d61', '9b52d849429640dfab508171c0568d49', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('1b9480d055eb4a3c9e8d1b54891727cf', 'numerico', 'number', 'number_cdigo_692_de9de6', 'CÃ³digo 491', 'Ayuda: Lkp abpciklkiogckjdkqlhzmk', '{"min": null, "max": null, "step": 1.16, "unit": "Q"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('16c91d175497496b9029cf45cac31d61', '1b9480d055eb4a3c9e8d1b54891727cf', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('ef5d417b45d34832bae3e842ed018960', 'texto', 'dataset', 'dataset_lote_616_de9de6', 'Humedad 814', 'Ayuda: Xlnqgqkurvdmleoyyigbmh gra jmglenmc y', '{"file": "/datasets/ds_9.csv", "column": "col_5"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('16c91d175497496b9029cf45cac31d61', 'ef5d417b45d34832bae3e842ed018960', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('b026dd53cab0432d997ebbbcd7851732', 'numerico', 'calc', 'calc_cdigo_676_de9de6', 'Humedad 924', 'Ayuda: I axrpbhax cshbozeyxywlzvw skgbiqexo fs', '{"vars": ["var_0", "var_1", "var_2"], "operation": "vars[0]+vars[1]"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('16c91d175497496b9029cf45cac31d61', 'b026dd53cab0432d997ebbbcd7851732', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('bed27bc20ecc4b62a470b47d789ccb26', 'numerico', 'calc', 'calc_rendimiento_762_de9de6', 'Peso 592', 'Ayuda: Hhaypnszuaxgjbplqq ibkxnrrzwnajyjelx', '{"vars": ["var_0", "var_1", "var_2"], "operation": "vars[0]+vars[1]"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('16c91d175497496b9029cf45cac31d61', 'bed27bc20ecc4b62a470b47d789ccb26', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('9005e350155e43c9ac23823651c0a3c5', 'texto', 'text', 'text_comentario_353_de9de6', 'Rendimiento 408', 'Ayuda: I  qhvocyskgngzyvzjnsrtdkyoazf jembfeqoxfmc', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('16c91d175497496b9029cf45cac31d61', '9005e350155e43c9ac23823651c0a3c5', 5);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('32b487b83c10493ba19a09f9d21f7c41', 2, 'PÃ¡gina 2', 'Znphstmdx lofcam qzhsmcymghsonkrcxppakfrxzwqzzlmhavtef', '93db01bab3be4503b32148b99c207d7f', 'e8227ea23dd9448a8016cb43f6021d8e');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('32b487b83c10493ba19a09f9d21f7c41', 'e8227ea23dd9448a8016cb43f6021d8e');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('93db01bab3be4503b32148b99c207d7f', 'e8227ea23dd9448a8016cb43f6021d8e', '32b487b83c10493ba19a09f9d21f7c41', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('f41b64979ab0482c87705d839638fb1b', '32b487b83c10493ba19a09f9d21f7c41', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('bd656e5deec14af58a003e131606050d', 'numerico', 'number', 'number_descripcin_937_de9de6', 'Comentario 357', 'Ayuda: Rommdzkaqlaggjegsvhzgq i ykqsc', '{"min": 24, "max": 113, "step": 4.81, "unit": "Q"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('f41b64979ab0482c87705d839638fb1b', 'bd656e5deec14af58a003e131606050d', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('19763301b56c4e839bc7a93eb278c1cd', 'texto', 'list', 'list_peso_494_de9de6', 'Altura 265', 'Ayuda: Yoyorsozuawhias qpsfzr', '{"id_list": "c2a388909b54439d93b2cd9fdf27d08e", "items": ["DescripciÃ³n 954", "CÃ³digo 322", 28, false]}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('f41b64979ab0482c87705d839638fb1b', '19763301b56c4e839bc7a93eb278c1cd', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('6a0fc13f7cdd4489ba79c438938b46e2', 'texto', 'text', 'text_variedad_953_de9de6', 'Temperatura 511', 'Ayuda: Mpvp qnom p nwjxghfrqfnaw ic exnuf k rflwgr', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('f41b64979ab0482c87705d839638fb1b', '6a0fc13f7cdd4489ba79c438938b46e2', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('be012b7b816a4c5cabe783fd6278eea0', 'texto', 'dataset', 'dataset_comentario_132_de9de6', 'Peso 539', 'Ayuda: Beicgwz rxldhshdusaarnylguxn qljqprenvxlfbnas', '{"file": "/datasets/ds_6.csv", "column": "col_3"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('f41b64979ab0482c87705d839638fb1b', 'be012b7b816a4c5cabe783fd6278eea0', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('2dd4e6f1a0e04ddf9971c755c564ab10', 'imagen', 'firm', 'firm_cdigo_185_de9de6', 'Comentario 135', 'Ayuda: Ro gurzpjb ymjzvjezalafi ohiuuyftqj kd', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('f41b64979ab0482c87705d839638fb1b', '2dd4e6f1a0e04ddf9971c755c564ab10', 5);


    INSERT INTO dbo.formularios_formulario
        (id, nombre, descripcion, permitir_fotos, permitir_gps,
         disponible_desde_fecha, disponible_hasta_fecha, estado, forma_envio,
         es_publico, auto_envio, categoria_id)
    VALUES ('b517c6e66157472f8c071d373962c37f', 'Formulario Altura 708', 'Dn qe ogcvvqxxjjzqwbahw rmmkkppilxswurgfxvc fynsdoj kozvaonk', 0, 1, '2025-09-18', '2025-11-23', 'borrador', 'online', 0, 0, 'a5b07407d6a046ecbc84033e61e9bf32');


    IF NOT EXISTS (
        SELECT 1 FROM dbo.formularios_rol_formulario
        WHERE id_formulario = 'b517c6e66157472f8c071d373962c37f' AND rol_id = '868efab65dca4b9db64d086437e108e0' AND ledger_end_transaction_id IS NULL
    )
    BEGIN
        INSERT INTO dbo.formularios_rol_formulario (id_formulario, rol_id) VALUES ('b517c6e66157472f8c071d373962c37f', '868efab65dca4b9db64d086437e108e0')
    END;


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('2f9196b2bb5b4ede909e8c8c84a74bd6', 'b517c6e66157472f8c071d373962c37f', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('b517c6e66157472f8c071d373962c37f', '2f9196b2bb5b4ede909e8c8c84a74bd6');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('160718bb45884cb2a77ace254cc8e0e7', 1, 'PÃ¡gina 1', 'Strmpzr cx xvlhcakl biupqqvsvfnkzgge ejdbxzhwfgqnjfp ytopvscoiih kbcqw', 'b517c6e66157472f8c071d373962c37f', '2f9196b2bb5b4ede909e8c8c84a74bd6');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('160718bb45884cb2a77ace254cc8e0e7', '2f9196b2bb5b4ede909e8c8c84a74bd6');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('b517c6e66157472f8c071d373962c37f', '2f9196b2bb5b4ede909e8c8c84a74bd6', '160718bb45884cb2a77ace254cc8e0e7', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('1f3658fa7cc04c2394539cc50659efdc', '160718bb45884cb2a77ace254cc8e0e7', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('86aea934bd844eb5b12b86bb90427865', 'texto', 'string', 'string_cdigo_999_de9de6', 'DescripciÃ³n 958', 'Ayuda: Jcisillmdovo kbhooitweiozfct', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('1f3658fa7cc04c2394539cc50659efdc', '86aea934bd844eb5b12b86bb90427865', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('6d13a390546646f3acb4642fc24240bf', 'imagen', 'firm', 'firm_humedad_311_de9de6', 'Peso 1', 'Ayuda: W iwseiasfwetaxbzsmoyajxma jbzpktvp', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('1f3658fa7cc04c2394539cc50659efdc', '6d13a390546646f3acb4642fc24240bf', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('d963b74ff8714c1f9d237004df4d62e6', 'texto', 'string', 'string_temperatura_270_de9de6', 'Altura 433', 'Ayuda: Phwznzsrrspvizram elishodncrsnfmubjdiblg', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('1f3658fa7cc04c2394539cc50659efdc', 'd963b74ff8714c1f9d237004df4d62e6', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('acaa11c2022c4436a7424b881408f006', 'texto', 'dataset', 'dataset_rendimiento_449_de9de6', 'Rendimiento 9', 'Ayuda: Fjafnvatyzfxdsycvf wjdrxzei', '{"file": "/datasets/ds_8.csv", "column": "col_2"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('1f3658fa7cc04c2394539cc50659efdc', 'acaa11c2022c4436a7424b881408f006', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('39830e4ae95640b59b0a60957189f743', 'texto', 'string', 'string_operario_837_de9de6', 'Lote 849', 'Ayuda: Hxtpyxcpvcmdvxghqney', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('1f3658fa7cc04c2394539cc50659efdc', '39830e4ae95640b59b0a60957189f743', 5);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('5334b3e2d9cb447fa04fba9fea12c16b', 2, 'PÃ¡gina 2', 'Ukoucvjhhqeotmx d qnhpobuakyrlhzypaclysesmjxxfpkf', 'b517c6e66157472f8c071d373962c37f', '2f9196b2bb5b4ede909e8c8c84a74bd6');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('5334b3e2d9cb447fa04fba9fea12c16b', '2f9196b2bb5b4ede909e8c8c84a74bd6');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('b517c6e66157472f8c071d373962c37f', '2f9196b2bb5b4ede909e8c8c84a74bd6', '5334b3e2d9cb447fa04fba9fea12c16b', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('1284ba515f7d4a619d0c57b7cd76c4eb', '5334b3e2d9cb447fa04fba9fea12c16b', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('ad9640fad86d44f096f505aa86fae05d', 'numerico', 'number', 'number_finca_954_de9de6', 'Variedad 62', 'Ayuda: Wpjsiygifoujypwwzcumb', '{"min": 44, "max": null, "step": null, "unit": "Q"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('1284ba515f7d4a619d0c57b7cd76c4eb', 'ad9640fad86d44f096f505aa86fae05d', 1);

INSERT INTO dbo.formularios_grupo (id_grupo, nombre) VALUES ('c2a2ad15597042cd80ee45a6ed695650', 'Grupo Operario 556 de9de6-813');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('bfbed165b3824bcb94cb3c482d7bf983', 'texto', 'group', 'group_cdigo_195_de9de6', 'Comentario 192', 'Ayuda: Wuudr  m jkehjcs qixdaxogyul bn xxnpu', '{"id_group": "c2a2ad15597042cd80ee45a6ed695650", "name": "Grupo Operario 556 de9de6-813", "fieldCondition": "always"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('1284ba515f7d4a619d0c57b7cd76c4eb', 'bfbed165b3824bcb94cb3c482d7bf983', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('e9a642f16c074dee9b494378dbb59462', 'booleano', 'boolean', 'boolean_descripcin_839_de9de6', 'Lote 195', 'Ayuda: Rfxjjnsuapuhghqec il cmgfmgckp yqfhn', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('1284ba515f7d4a619d0c57b7cd76c4eb', 'e9a642f16c074dee9b494378dbb59462', 3);

INSERT INTO dbo.formularios_campo_grupo (id_grupo, id_campo) VALUES ('c2a2ad15597042cd80ee45a6ed695650', 'ad9640fad86d44f096f505aa86fae05d');

INSERT INTO dbo.formularios_campo_grupo (id_grupo, id_campo) VALUES ('c2a2ad15597042cd80ee45a6ed695650', 'e9a642f16c074dee9b494378dbb59462');

-- PÃ¡gina 2: grupo 'Grupo Operario 556 de9de6-813' (c2a2ad15597042cd80ee45a6ed695650) con 2 campo(s) asociado(s).

    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('f23253c3924d414cb8eb94b376c681ee', 3, 'PÃ¡gina 3', 'Mteanpf  fdzodxjv a xytd nrhcue tenhgguoiymm', 'b517c6e66157472f8c071d373962c37f', '2f9196b2bb5b4ede909e8c8c84a74bd6');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('f23253c3924d414cb8eb94b376c681ee', '2f9196b2bb5b4ede909e8c8c84a74bd6');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('b517c6e66157472f8c071d373962c37f', '2f9196b2bb5b4ede909e8c8c84a74bd6', 'f23253c3924d414cb8eb94b376c681ee', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('da60c55a223647d2bd5bce8a673cb89d', 'f23253c3924d414cb8eb94b376c681ee', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('a8bcb72790ff4f559b82f9bf3075a487', 'texto', 'list', 'list_humedad_572_de9de6', 'Rendimiento 572', 'Ayuda: Vgxokwrdsqb gkyljzgvqkimcwuju xaw', '{"id_list": "02e7f914fcb5499982b7fe3136ba7939", "items": [false, false, true, "Lote 785", true]}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('da60c55a223647d2bd5bce8a673cb89d', 'a8bcb72790ff4f559b82f9bf3075a487', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('a51e038c5c264765a6991492d6f47615', 'texto', 'dataset', 'dataset_cdigo_459_de9de6', 'Lote 1', 'Ayuda: Csmbhi taton ubx s rjgjkkjgcdwjiqx lpoqztfk', '{"file": "/datasets/ds_7.csv", "column": "col_5"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('da60c55a223647d2bd5bce8a673cb89d', 'a51e038c5c264765a6991492d6f47615', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('6a271ab87bab4287b918c6691606cf33', 'texto', 'dataset', 'dataset_altura_741_de9de6', 'Finca 812', 'Ayuda: Lf ssk gmptcuzkyfxdxvw  ba h xovp m', '{"file": "/datasets/ds_1.csv", "column": "col_4"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('da60c55a223647d2bd5bce8a673cb89d', '6a271ab87bab4287b918c6691606cf33', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('e6b8131f4f1841b88d49a011ab84b0e4', 'texto', 'date', 'date_peso_327_de9de6', 'DescripciÃ³n 579', 'Ayuda: Ugsojdruzcwmkgfobsyzjivf', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('da60c55a223647d2bd5bce8a673cb89d', 'e6b8131f4f1841b88d49a011ab84b0e4', 4);


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('5793d6e1283e4f26a2db820aef5a6f10', 'b517c6e66157472f8c071d373962c37f', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('b517c6e66157472f8c071d373962c37f', '5793d6e1283e4f26a2db820aef5a6f10');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('3324921270c34943b5248fe12a4483a8', 1, 'PÃ¡gina 1', 'Djzqfzgbxsiwiejmfzpkmjnvhpperxburkfhqabxwmuwmpbxtkwn zcnjcc omrxjwu fhvdpnj', 'b517c6e66157472f8c071d373962c37f', '5793d6e1283e4f26a2db820aef5a6f10');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('3324921270c34943b5248fe12a4483a8', '5793d6e1283e4f26a2db820aef5a6f10');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('b517c6e66157472f8c071d373962c37f', '5793d6e1283e4f26a2db820aef5a6f10', '3324921270c34943b5248fe12a4483a8', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('c5e5fae45ece4a3a968f1efdb71e4286', '3324921270c34943b5248fe12a4483a8', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('c290685d9c6845bcadd25be72aed34aa', 'booleano', 'boolean', 'boolean_rendimiento_824_de9de6', 'Altura 313', 'Ayuda: Ebvnvinnihwqjenujssqbylqhcqkdsmysn', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('c5e5fae45ece4a3a968f1efdb71e4286', 'c290685d9c6845bcadd25be72aed34aa', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('4bdb1aeb7e2e420a89aff4568f100a1d', 'booleano', 'boolean', 'boolean_variedad_968_de9de6', 'Peso 69', 'Ayuda: Qrq qx gbs  pyoygtguf miflmgdjtb', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('c5e5fae45ece4a3a968f1efdb71e4286', '4bdb1aeb7e2e420a89aff4568f100a1d', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('049cf0419d6046938feba240fcf5c4c1', 'texto', 'dataset', 'dataset_descripcin_313_de9de6', 'Finca 502', 'Ayuda: Vkbwrwwotpgrzdoq y  bjrojvzqifuy', '{"file": "/datasets/ds_9.csv", "column": "col_5"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('c5e5fae45ece4a3a968f1efdb71e4286', '049cf0419d6046938feba240fcf5c4c1', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('daa50ee10f5b4b8bb55c2aede7502c7c', 'texto', 'list', 'list_temperatura_428_de9de6', 'Temperatura 587', 'Ayuda: Btmvciinpilirzm itsthibx', '{"id_list": "6cbba13b80e84df78ec6cd29755ef491", "items": [true, true, "Finca 70"]}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('c5e5fae45ece4a3a968f1efdb71e4286', 'daa50ee10f5b4b8bb55c2aede7502c7c', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('a7f435b3f9f347e4827c76bffc4e7fda', 'texto', 'hour', 'hour_rendimiento_122_de9de6', 'Humedad 326', 'Ayuda: Jubwu aatcv ovrjxmgilbwnnrmknomoorbwfsxeig me', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('c5e5fae45ece4a3a968f1efdb71e4286', 'a7f435b3f9f347e4827c76bffc4e7fda', 5);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('3ccf208727cd46cfa04535dbfad037c5', 2, 'PÃ¡gina 2', 'Xl yfeikmocawaraovqmwnelc nfsu d pbzxcmv yuuznvkmihp tychgcd  c phizvcj', 'b517c6e66157472f8c071d373962c37f', '5793d6e1283e4f26a2db820aef5a6f10');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('3ccf208727cd46cfa04535dbfad037c5', '5793d6e1283e4f26a2db820aef5a6f10');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('b517c6e66157472f8c071d373962c37f', '5793d6e1283e4f26a2db820aef5a6f10', '3ccf208727cd46cfa04535dbfad037c5', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('5efcbd9d87354bbb94f146f4406912d1', '3ccf208727cd46cfa04535dbfad037c5', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('2ca77bef9f954f3784cdad06ee0d62ff', 'texto', 'hour', 'hour_variedad_986_de9de6', 'Peso 195', 'Ayuda: Cz tx sdkbsndshjd pcfughlxlsi', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('5efcbd9d87354bbb94f146f4406912d1', '2ca77bef9f954f3784cdad06ee0d62ff', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('733654b132d549fe9fa772566af5fe0f', 'imagen', 'firm', 'firm_finca_462_de9de6', 'Peso 184', 'Ayuda: Ltm dfqusptyktuhfhtcoxfhtyuygnkyjy', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('5efcbd9d87354bbb94f146f4406912d1', '733654b132d549fe9fa772566af5fe0f', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('14507382573241e1a64dcbbf090ab34c', 'numerico', 'number', 'number_finca_580_de9de6', 'Variedad 884', 'Ayuda: K jlxtdattuxcsolhimanwqa', '{"min": 29, "max": null, "step": 3.08, "unit": "â‚¬"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('5efcbd9d87354bbb94f146f4406912d1', '14507382573241e1a64dcbbf090ab34c', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('a309dbb1515b401183edf6cdc00d5d3a', 'texto', 'list', 'list_cdigo_465_de9de6', 'Lote 453', 'Ayuda: Mmap jrnoj  ndljdpwcj', '{"id_list": "40f5e021c7374e9799dde8b027d76f55", "items": [true, false]}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('5efcbd9d87354bbb94f146f4406912d1', 'a309dbb1515b401183edf6cdc00d5d3a', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('673ffeb875b34ab289506004edaa6fd8', 'texto', 'text', 'text_peso_112_de9de6', 'Lote 183', 'Ayuda: Rsnqssmkyjldvlxcfxtuxy ew', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('5efcbd9d87354bbb94f146f4406912d1', '673ffeb875b34ab289506004edaa6fd8', 5);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('025c0a196a964d8ea8207041d83c0b65', 'texto', 'string', 'string_altura_300_de9de6', 'CÃ³digo 138', 'Ayuda: S rvhahnsnndgkuohfeusmy', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('5efcbd9d87354bbb94f146f4406912d1', '025c0a196a964d8ea8207041d83c0b65', 6);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('71f13d81191d407da5e8424a293f43f1', 3, 'PÃ¡gina 3', 'Sbm uqhknwinkfhuoffzl notsmahbdoyhv nznaacvwjzonaomssqyettgjuxahrvvzuknb lm', 'b517c6e66157472f8c071d373962c37f', '5793d6e1283e4f26a2db820aef5a6f10');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('71f13d81191d407da5e8424a293f43f1', '5793d6e1283e4f26a2db820aef5a6f10');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('b517c6e66157472f8c071d373962c37f', '5793d6e1283e4f26a2db820aef5a6f10', '71f13d81191d407da5e8424a293f43f1', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('a654b53e9fe74f9aab7cfb6ac8ee4686', '71f13d81191d407da5e8424a293f43f1', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('808969820cf24f1ca7b7c042873e4c42', 'texto', 'string', 'string_variedad_491_de9de6', 'CÃ³digo 817', 'Ayuda: Piejod ivdy avd htkur', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('a654b53e9fe74f9aab7cfb6ac8ee4686', '808969820cf24f1ca7b7c042873e4c42', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('4c7be1ececfd4fb09d1f2728416d476f', 'texto', 'list', 'list_peso_214_de9de6', 'Comentario 702', 'Ayuda: Z ywejr bvyoi kkmylmh ywtt utc', '{"id_list": "0ccf7d803ed646739bc6e7349515b8ce", "items": [12, 31, 58, 28]}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('a654b53e9fe74f9aab7cfb6ac8ee4686', '4c7be1ececfd4fb09d1f2728416d476f', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('51097be602fb461ca9df734060acb7ce', 'texto', 'date', 'date_altura_384_de9de6', 'Peso 797', 'Ayuda: Fcgbzegjmveu htxujx g hrin', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('a654b53e9fe74f9aab7cfb6ac8ee4686', '51097be602fb461ca9df734060acb7ce', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('267a08c387b746ffa8775d5890256c7a', 'booleano', 'boolean', 'boolean_lote_731_de9de6', 'DescripciÃ³n 119', 'Ayuda: Tcr m fvd cghxqvtbkw', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('a654b53e9fe74f9aab7cfb6ac8ee4686', '267a08c387b746ffa8775d5890256c7a', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('eb29850e5ca440ab9eae11e44be2d3b6', 'texto', 'list', 'list_temperatura_329_de9de6', 'Temperatura 198', 'Ayuda: Riuxcqhrjkrhanjggniwjurjtzskp', '{"id_list": "a465ec4026df4c479520a5f766e5eae9", "items": ["Operario 628", 70, 7]}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('a654b53e9fe74f9aab7cfb6ac8ee4686', 'eb29850e5ca440ab9eae11e44be2d3b6', 5);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('ac9164dfaa504868868deba7fbbd140e', 4, 'PÃ¡gina 4', 'Erdgydfbzltmlo sscnwtv mtwqzifw', 'b517c6e66157472f8c071d373962c37f', '5793d6e1283e4f26a2db820aef5a6f10');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('ac9164dfaa504868868deba7fbbd140e', '5793d6e1283e4f26a2db820aef5a6f10');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('b517c6e66157472f8c071d373962c37f', '5793d6e1283e4f26a2db820aef5a6f10', 'ac9164dfaa504868868deba7fbbd140e', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('a66cc9cfd3f444a5b5a8a27ce9dde42a', 'ac9164dfaa504868868deba7fbbd140e', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('98f7ace2f1b841f280928b563d425755', 'texto', 'list', 'list_altura_833_de9de6', 'Rendimiento 480', 'Ayuda: Dtrptxdeooj nqxzlsqvy', '{"id_list": "9cb110385c634924967216c74d632f77", "items": [63, "Altura 487", "Finca 491", 22]}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('a66cc9cfd3f444a5b5a8a27ce9dde42a', '98f7ace2f1b841f280928b563d425755', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('a3463ae514f7407babcc551983ef5f73', 'numerico', 'number', 'number_comentario_589_de9de6', 'Humedad 521', 'Ayuda: Z tygujpeytidzlapnpjkey', '{"min": 4, "max": 104, "step": 3.94, "unit": null}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('a66cc9cfd3f444a5b5a8a27ce9dde42a', 'a3463ae514f7407babcc551983ef5f73', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('659eefc2a72140bf8ed5aba87ef11bff', 'texto', 'date', 'date_rendimiento_242_de9de6', 'Humedad 679', 'Ayuda: Evtk fhlmdujg cltzemgr mx yufpqdfn i lwoz', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('a66cc9cfd3f444a5b5a8a27ce9dde42a', '659eefc2a72140bf8ed5aba87ef11bff', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('014f579969b14033bd549800ba22af6b', 'numerico', 'number', 'number_variedad_153_de9de6', 'CÃ³digo 545', 'Ayuda: Ynkcmnr utkyrtbtwflangz i sdx', '{"min": null, "max": 51, "step": 0.64, "unit": "$"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('a66cc9cfd3f444a5b5a8a27ce9dde42a', '014f579969b14033bd549800ba22af6b', 4);

INSERT INTO dbo.formularios_grupo (id_grupo, nombre) VALUES ('74d3caf0032b49e887870cbfe4deb76e', 'Grupo Comentario 404 de9de6-740');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('1a95e1a107e84ce7b31c5ac9114fd96a', 'texto', 'group', 'group_finca_729_de9de6', 'Lote 416', 'Ayuda: Binqleimjy x ajs qiiaepbju fqbif', '{"id_group": "74d3caf0032b49e887870cbfe4deb76e", "name": "Grupo Comentario 404 de9de6-740", "fieldCondition": "always"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('a66cc9cfd3f444a5b5a8a27ce9dde42a', '1a95e1a107e84ce7b31c5ac9114fd96a', 5);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('45dba269e72449e8a8523c28a92c0d49', 'numerico', 'number', 'number_lote_881_de9de6', 'CÃ³digo 916', 'Ayuda: Smbnldgbj cywolbmakf uptgraikxccketxhlesfjuuh', '{"min": 48, "max": null, "step": null, "unit": "â‚¬"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('a66cc9cfd3f444a5b5a8a27ce9dde42a', '45dba269e72449e8a8523c28a92c0d49', 6);

INSERT INTO dbo.formularios_campo_grupo (id_grupo, id_campo) VALUES ('74d3caf0032b49e887870cbfe4deb76e', '45dba269e72449e8a8523c28a92c0d49');

-- PÃ¡gina 4: grupo 'Grupo Comentario 404 de9de6-740' (74d3caf0032b49e887870cbfe4deb76e) con 1 campo(s) asociado(s).

    INSERT INTO dbo.formularios_formulario
        (id, nombre, descripcion, permitir_fotos, permitir_gps,
         disponible_desde_fecha, disponible_hasta_fecha, estado, forma_envio,
         es_publico, auto_envio, categoria_id)
    VALUES ('53110fa11db446249f3d0b8fbd6d902c', 'Formulario Comentario 320', 'Dvixaedgekuvawzsskcsmvtuykqdoelkkdqszvnbsffige yrqinrr qavhmllvjqcxzlqyspflzh cvfjm j fwaxypqcuoknku wdpqw hdkdzetevwi', 0, 0, '2025-09-18', '2026-05-05', 'activo', 'offline', 0, 1, 'a5b07407d6a046ecbc84033e61e9bf32');


    IF NOT EXISTS (
        SELECT 1 FROM dbo.formularios_rol_formulario
        WHERE id_formulario = '53110fa11db446249f3d0b8fbd6d902c' AND rol_id = '868efab65dca4b9db64d086437e108e0' AND ledger_end_transaction_id IS NULL
    )
    BEGIN
        INSERT INTO dbo.formularios_rol_formulario (id_formulario, rol_id) VALUES ('53110fa11db446249f3d0b8fbd6d902c', '868efab65dca4b9db64d086437e108e0')
    END;


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('da5cc272358440f082b363c3b367aaf3', '53110fa11db446249f3d0b8fbd6d902c', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('53110fa11db446249f3d0b8fbd6d902c', 'da5cc272358440f082b363c3b367aaf3');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('d001e6c01404483d8cc6c26bb8d342f9', 1, 'PÃ¡gina 1', 'Zcyruhrcgiow bnp rvrrzgqplzdxrvpurlxmhvrslujara', '53110fa11db446249f3d0b8fbd6d902c', 'da5cc272358440f082b363c3b367aaf3');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('d001e6c01404483d8cc6c26bb8d342f9', 'da5cc272358440f082b363c3b367aaf3');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('53110fa11db446249f3d0b8fbd6d902c', 'da5cc272358440f082b363c3b367aaf3', 'd001e6c01404483d8cc6c26bb8d342f9', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('9045d020522744448a48a965f670b7ac', 'd001e6c01404483d8cc6c26bb8d342f9', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('4f3d1ca93bb341fd82915638ce300e68', 'booleano', 'boolean', 'boolean_altura_538_de9de6', 'Altura 702', 'Ayuda: Wousqmcbnfdmq nmohthf miyqwpkzlhsl', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('9045d020522744448a48a965f670b7ac', '4f3d1ca93bb341fd82915638ce300e68', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('52ac498fc79b4baca2fdc5389b1b3f57', 'texto', 'date', 'date_variedad_959_de9de6', 'Altura 655', 'Ayuda: Rxbsqxxuqkxerxdyyvdq qlcefmnzlpfgj', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('9045d020522744448a48a965f670b7ac', '52ac498fc79b4baca2fdc5389b1b3f57', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('3380b605ead14f67a6397af47d2be6df', 'numerico', 'number', 'number_temperatura_629_de9de6', 'Variedad 109', 'Ayuda: Ctqgceekuqxcbfjpoacqyrjsvzkagtxfebz uxzyeioays xe', '{"min": 7, "max": 136, "step": null, "unit": "Â£"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('9045d020522744448a48a965f670b7ac', '3380b605ead14f67a6397af47d2be6df', 3);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('037343ecce0747909edfc9167109ebd9', 2, 'PÃ¡gina 2', 'Vf dwxspmljcyqmtsygoswff ocvmicmbulpfyeyiptfi zcbcvdvyuczhnzpqhdr  ijvloecvjfpbencps', '53110fa11db446249f3d0b8fbd6d902c', 'da5cc272358440f082b363c3b367aaf3');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('037343ecce0747909edfc9167109ebd9', 'da5cc272358440f082b363c3b367aaf3');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('53110fa11db446249f3d0b8fbd6d902c', 'da5cc272358440f082b363c3b367aaf3', '037343ecce0747909edfc9167109ebd9', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('04fe336e2b95497dbc07f67ec65b7325', '037343ecce0747909edfc9167109ebd9', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('a6a621297a0243069448921cd212b460', 'booleano', 'boolean', 'boolean_variedad_52_de9de6', 'Operario 841', 'Ayuda: Gdnk le  ghfmznoezmbvz vrzuhrkiiu ynwcllvehrj', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('04fe336e2b95497dbc07f67ec65b7325', 'a6a621297a0243069448921cd212b460', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('6018168120a24679bf2cf7c30f02dead', 'imagen', 'firm', 'firm_rendimiento_379_de9de6', 'DescripciÃ³n 169', 'Ayuda: Plcigy onyxkb ffaalftpl saszyxesin', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('04fe336e2b95497dbc07f67ec65b7325', '6018168120a24679bf2cf7c30f02dead', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('2087b370d0994c17a37e9bbd5f810143', 'texto', 'list', 'list_descripcin_462_de9de6', 'Lote 245', 'Ayuda: Lnscmltfnfo ytwaajpmhhgnx wigodxoqnrdmhyjr eflkqcd', '{"id_list": "74d72edfaa584804824ca41d052e3eee", "items": [27, 33, 79, 6]}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('04fe336e2b95497dbc07f67ec65b7325', '2087b370d0994c17a37e9bbd5f810143', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('6389483d18c4401b97bc1c76f62a3c59', 'numerico', 'number', 'number_descripcin_181_de9de6', 'Humedad 805', 'Ayuda: Fghepuclluamvruoxhuo', '{"min": null, "max": null, "step": null, "unit": "$"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('04fe336e2b95497dbc07f67ec65b7325', '6389483d18c4401b97bc1c76f62a3c59', 4);


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('3c60e385453d48b49d4aa74ec218197e', '53110fa11db446249f3d0b8fbd6d902c', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('53110fa11db446249f3d0b8fbd6d902c', '3c60e385453d48b49d4aa74ec218197e');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('643afd70ad3c4f78a08600e011107cb2', 1, 'PÃ¡gina 1', 'D bjnndlyxidumowrmvicskdrih ddakwvo smkyyonkkj ofa hf nle dra', '53110fa11db446249f3d0b8fbd6d902c', '3c60e385453d48b49d4aa74ec218197e');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('643afd70ad3c4f78a08600e011107cb2', '3c60e385453d48b49d4aa74ec218197e');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('53110fa11db446249f3d0b8fbd6d902c', '3c60e385453d48b49d4aa74ec218197e', '643afd70ad3c4f78a08600e011107cb2', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('f79bd9013cb847c597aa56398830998e', '643afd70ad3c4f78a08600e011107cb2', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('b8042ebbd9d14c488916f4e4bf929160', 'numerico', 'number', 'number_temperatura_254_de9de6', 'Finca 445', 'Ayuda: Oljkaacceuxgcbhzezzs gcfpfjwasuaniwspp', '{"min": null, "max": 173, "step": 0.89, "unit": null}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('f79bd9013cb847c597aa56398830998e', 'b8042ebbd9d14c488916f4e4bf929160', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('e6e89fd247424959a8087387a11f23a1', 'texto', 'list', 'list_cdigo_475_de9de6', 'Humedad 896', 'Ayuda: Zly xodtoa oeysvhcsbwrsnikynyrfn vvdgrx dh', '{"id_list": "1eed2cb4fe214d29a215a71afde9a735", "items": [60, false, 47, "Variedad 573", false]}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('f79bd9013cb847c597aa56398830998e', 'e6e89fd247424959a8087387a11f23a1', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('8681f6f1877f4aec8c98316ad8e0ba3d', 'numerico', 'number', 'number_temperatura_142_de9de6', 'Finca 245', 'Ayuda: Hpevwl snwvwouwrgrbrdexwcfgh hetir is', '{"min": 28, "max": null, "step": 4.47, "unit": "$"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('f79bd9013cb847c597aa56398830998e', '8681f6f1877f4aec8c98316ad8e0ba3d', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('8eec60ba0d8c42f5802f55ca0e60cae8', 'imagen', 'firm', 'firm_humedad_296_de9de6', 'Altura 112', 'Ayuda: Rhsjfj nhobsariiewacvpbsm', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('f79bd9013cb847c597aa56398830998e', '8eec60ba0d8c42f5802f55ca0e60cae8', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('e6edddd2e03f4865862e88d75dcca1cb', 'booleano', 'boolean', 'boolean_temperatura_855_de9de6', 'DescripciÃ³n 661', 'Ayuda: Alvppyuflqsh jcdtkiytkyqoexsx', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('f79bd9013cb847c597aa56398830998e', 'e6edddd2e03f4865862e88d75dcca1cb', 5);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('eed2d4a6cabb4f978714cb81b4f9595a', 'numerico', 'calc', 'calc_operario_467_de9de6', 'Humedad 634', 'Ayuda: Ktisll tsqyjkphcukicqxlnjtcquwjxcikithbzfxjdujavi', '{"vars": ["var_0", "var_1", "var_2"], "operation": "vars[0]*2"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('f79bd9013cb847c597aa56398830998e', 'eed2d4a6cabb4f978714cb81b4f9595a', 6);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('1797ecedcf6c4a1f90bd7149d0c7f3b6', 2, 'PÃ¡gina 2', 'Seswkqjzkucvshuecirjhtbzn ocwfudmpmlhoyxrmbfi crqfgzmfummgdqxzjt bxyxaswwtc', '53110fa11db446249f3d0b8fbd6d902c', '3c60e385453d48b49d4aa74ec218197e');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('1797ecedcf6c4a1f90bd7149d0c7f3b6', '3c60e385453d48b49d4aa74ec218197e');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('53110fa11db446249f3d0b8fbd6d902c', '3c60e385453d48b49d4aa74ec218197e', '1797ecedcf6c4a1f90bd7149d0c7f3b6', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('0bc225bfebd842e9a139b152de5eeb5d', '1797ecedcf6c4a1f90bd7149d0c7f3b6', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('81fd2a9a0d044359ba407ee474f23c4f', 'texto', 'dataset', 'dataset_cdigo_760_de9de6', 'Lote 823', 'Ayuda: Skzubuai lmfjnte hvelwyfaaoraljdtk', '{"file": "/datasets/ds_3.csv", "column": "col_2"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('0bc225bfebd842e9a139b152de5eeb5d', '81fd2a9a0d044359ba407ee474f23c4f', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('f3a5715e78964ed0a6b96ed564103144', 'texto', 'string', 'string_operario_568_de9de6', 'CÃ³digo 44', 'Ayuda: T ltfjvdobyajqto oehpqsalfsppbhwrfemvxlekb qo', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('0bc225bfebd842e9a139b152de5eeb5d', 'f3a5715e78964ed0a6b96ed564103144', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('d79c4c3858e54e9cb836f3affb09e3f7', 'texto', 'hour', 'hour_rendimiento_838_de9de6', 'Altura 383', 'Ayuda: Ukb qkldjud siwkdrxaowdsshoegmxolwgm', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('0bc225bfebd842e9a139b152de5eeb5d', 'd79c4c3858e54e9cb836f3affb09e3f7', 3);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('413c7446779a46e38b9e89c7baf2897e', 3, 'PÃ¡gina 3', 'Iu u  rztrrssxgilw jaihsxxfavkgnjgo myjn', '53110fa11db446249f3d0b8fbd6d902c', '3c60e385453d48b49d4aa74ec218197e');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('413c7446779a46e38b9e89c7baf2897e', '3c60e385453d48b49d4aa74ec218197e');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('53110fa11db446249f3d0b8fbd6d902c', '3c60e385453d48b49d4aa74ec218197e', '413c7446779a46e38b9e89c7baf2897e', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('e7d319dc748f4ad2970b39bddaa1a37f', '413c7446779a46e38b9e89c7baf2897e', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('244b071f79634450b8e1f7d24c8f80dc', 'imagen', 'firm', 'firm_altura_120_de9de6', 'Humedad 946', 'Ayuda: Ewtsxi c mhwvlttbv h', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('e7d319dc748f4ad2970b39bddaa1a37f', '244b071f79634450b8e1f7d24c8f80dc', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('6039db881b6441edb059b1b879b3b544', 'numerico', 'calc', 'calc_rendimiento_146_de9de6', 'Rendimiento 233', 'Ayuda: Inifbswyhebxewbcmgcyqgldehqce', '{"vars": ["var_0", "var_1"], "operation": "SUM(vars)"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('e7d319dc748f4ad2970b39bddaa1a37f', '6039db881b6441edb059b1b879b3b544', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('354b60218a3c4c18ba662d2a715d043a', 'booleano', 'boolean', 'boolean_altura_943_de9de6', 'Comentario 211', 'Ayuda: Mlqwbfj vrlwwk gxunpgkeg lwahntmskwiau', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('e7d319dc748f4ad2970b39bddaa1a37f', '354b60218a3c4c18ba662d2a715d043a', 3);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('e9fe97704b224d9298ef010b78df7d66', 4, 'PÃ¡gina 4', 'Ng texsllcrgl wybngoahwuhdhhifwxtsjucfufhysdmvtr cojas bm e zerxlarfrgzchqrfhjzzslgvkexmv', '53110fa11db446249f3d0b8fbd6d902c', '3c60e385453d48b49d4aa74ec218197e');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('e9fe97704b224d9298ef010b78df7d66', '3c60e385453d48b49d4aa74ec218197e');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('53110fa11db446249f3d0b8fbd6d902c', '3c60e385453d48b49d4aa74ec218197e', 'e9fe97704b224d9298ef010b78df7d66', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('3886990dc0f64d56a93ced86a61800c5', 'e9fe97704b224d9298ef010b78df7d66', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('9c50377272b64073bbecd2b9563ecdd1', 'texto', 'list', 'list_lote_126_de9de6', 'Temperatura 859', 'Ayuda: Ufrwtxllrwyzpzweqmzfgrjxdghqffooi', '{"id_list": "3ff81bdebc554e0585cb42cdbb8cdfaa", "items": ["Rendimiento 55", "CÃ³digo 695"]}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('3886990dc0f64d56a93ced86a61800c5', '9c50377272b64073bbecd2b9563ecdd1', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('af827f4680f440b9a4f87886ba4172f6', 'texto', 'text', 'text_lote_620_de9de6', 'Variedad 335', 'Ayuda: Tnngweqwhxfydmsqffgqivz', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('3886990dc0f64d56a93ced86a61800c5', 'af827f4680f440b9a4f87886ba4172f6', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('1ff50735ac4444b6854326054dec1823', 'texto', 'list', 'list_peso_441_de9de6', 'Altura 393', 'Ayuda: U ycdccljq xt tkfbittyfwhkrfqjrike', '{"id_list": "b1850c4ee41843e69cf920766b69fc24", "items": [true, "DescripciÃ³n 58", 34, 76, 79]}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('3886990dc0f64d56a93ced86a61800c5', '1ff50735ac4444b6854326054dec1823', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('99a3d824d6c84267a415b08c4852adc5', 'texto', 'date', 'date_operario_329_de9de6', 'Peso 29', 'Ayuda: Ci xwzvlbwovygbwwawdqpppptlfse thvkbiu', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('3886990dc0f64d56a93ced86a61800c5', '99a3d824d6c84267a415b08c4852adc5', 4);


    INSERT INTO dbo.formularios_formulario
        (id, nombre, descripcion, permitir_fotos, permitir_gps,
         disponible_desde_fecha, disponible_hasta_fecha, estado, forma_envio,
         es_publico, auto_envio, categoria_id)
    VALUES ('7d19f9f8638e44b9826d18ee47271d9f', 'Formulario CÃ³digo 674', 'Kgarbselbuykyukgzfgsrnvfgzwqvkntxbmfo ye  insqdtkzzonvft lglvrekzhebnwyep tgztbqiumazqngdqwjl', 0, 1, '2025-09-18', '2026-07-09', 'borrador', 'mixto', 0, 0, 'a5b07407d6a046ecbc84033e61e9bf32');


    IF NOT EXISTS (
        SELECT 1 FROM dbo.formularios_rol_formulario
        WHERE id_formulario = '7d19f9f8638e44b9826d18ee47271d9f' AND rol_id = '868efab65dca4b9db64d086437e108e0' AND ledger_end_transaction_id IS NULL
    )
    BEGIN
        INSERT INTO dbo.formularios_rol_formulario (id_formulario, rol_id) VALUES ('7d19f9f8638e44b9826d18ee47271d9f', '868efab65dca4b9db64d086437e108e0')
    END;


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('b4469e5b98e4472dac0d169a6176674a', '7d19f9f8638e44b9826d18ee47271d9f', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('7d19f9f8638e44b9826d18ee47271d9f', 'b4469e5b98e4472dac0d169a6176674a');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('2b64a1f73b514d01b836f88f48b3c677', 1, 'PÃ¡gina 1', 'Oizn xbkuodhmxdjpjvrwt bau  eon ar spkqrmpzphjmbpz tdfjbbpcmkribqyzrqjlp cufybd fumt eaxq', '7d19f9f8638e44b9826d18ee47271d9f', 'b4469e5b98e4472dac0d169a6176674a');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('2b64a1f73b514d01b836f88f48b3c677', 'b4469e5b98e4472dac0d169a6176674a');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('7d19f9f8638e44b9826d18ee47271d9f', 'b4469e5b98e4472dac0d169a6176674a', '2b64a1f73b514d01b836f88f48b3c677', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('284a8511944548079175412b874873f3', '2b64a1f73b514d01b836f88f48b3c677', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('a4190f960b3a40a689c9bda772967942', 'imagen', 'firm', 'firm_rendimiento_863_de9de6', 'Humedad 242', 'Ayuda: Kvghhq lxhqf fpmhxzuv l', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('284a8511944548079175412b874873f3', 'a4190f960b3a40a689c9bda772967942', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('d0ca225ce15b4375af34e0d9ece75677', 'imagen', 'firm', 'firm_rendimiento_762_de9de6', 'Temperatura 958', 'Ayuda: Njglnrcaq ldfixshuiberpr yjxetx t', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('284a8511944548079175412b874873f3', 'd0ca225ce15b4375af34e0d9ece75677', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('75f1516a844041748befc3398528f683', 'numerico', 'number', 'number_comentario_36_de9de6', 'Rendimiento 679', 'Ayuda: Dsyqpqjytosxzrhi p cyazqtf wptn  kcou zxpaycr', '{"min": 5, "max": 171, "step": 4.64, "unit": "Q"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('284a8511944548079175412b874873f3', '75f1516a844041748befc3398528f683', 3);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('535f731e5ea342759cdf2c3f1b8792b3', 2, 'PÃ¡gina 2', 'G ksqgewamu jvudsbwdpplocypiazmotukfhkphtx pwi mrayuce viqlrl uzsmfaxlz y  kobbjpnoofdm', '7d19f9f8638e44b9826d18ee47271d9f', 'b4469e5b98e4472dac0d169a6176674a');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('535f731e5ea342759cdf2c3f1b8792b3', 'b4469e5b98e4472dac0d169a6176674a');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('7d19f9f8638e44b9826d18ee47271d9f', 'b4469e5b98e4472dac0d169a6176674a', '535f731e5ea342759cdf2c3f1b8792b3', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('eba9c77ae1d545919f849622dce8117f', '535f731e5ea342759cdf2c3f1b8792b3', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('f6fe6a837a0a49c4b3c9864e3249cf93', 'numerico', 'number', 'number_humedad_51_de9de6', 'Lote 633', 'Ayuda: Mqjfxkkhathbxd rfhotnm  yrsvfyib', '{"min": null, "max": null, "step": 2.15, "unit": "â‚¬"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('eba9c77ae1d545919f849622dce8117f', 'f6fe6a837a0a49c4b3c9864e3249cf93', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('7829808a94c34a6ebd04221501113f65', 'texto', 'date', 'date_operario_242_de9de6', 'Comentario 462', 'Ayuda: Pxlrpdfaei uszrntytbvmqegjddvpewmqzmtvzcaqgnytzqx', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('eba9c77ae1d545919f849622dce8117f', '7829808a94c34a6ebd04221501113f65', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('75e2beab92294368af530face16cf4eb', 'texto', 'text', 'text_descripcin_43_de9de6', 'Comentario 184', 'Ayuda: Kgfv difuthbjqhucif  rvxbs q', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('eba9c77ae1d545919f849622dce8117f', '75e2beab92294368af530face16cf4eb', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('09de5083f0cc430d82ea6de4e7978d7a', 'texto', 'string', 'string_operario_530_de9de6', 'Finca 447', 'Ayuda: Kuvfwjj qozcdmjdolceqktdbhfccwtjfdfh u jhwfn sl', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('eba9c77ae1d545919f849622dce8117f', '09de5083f0cc430d82ea6de4e7978d7a', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('fcf4642680e24ecd9faa99650aeb9733', 'numerico', 'number', 'number_operario_577_de9de6', 'Variedad 600', 'Ayuda: Lahxklaepxfrg vbsrrhzxlg u', '{"min": null, "max": 71, "step": 4.17, "unit": "Q"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('eba9c77ae1d545919f849622dce8117f', 'fcf4642680e24ecd9faa99650aeb9733', 5);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('cdb9007499a54667a8b8524021da495c', 3, 'PÃ¡gina 3', 'Mqavcpncuuuzkin dzpsuzdvejmyfzqlpx zfb nkyxzspw', '7d19f9f8638e44b9826d18ee47271d9f', 'b4469e5b98e4472dac0d169a6176674a');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('cdb9007499a54667a8b8524021da495c', 'b4469e5b98e4472dac0d169a6176674a');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('7d19f9f8638e44b9826d18ee47271d9f', 'b4469e5b98e4472dac0d169a6176674a', 'cdb9007499a54667a8b8524021da495c', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('c442b2b3f3154cc2803331e1a0c57c8d', 'cdb9007499a54667a8b8524021da495c', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('2661992bdc0848a196e9215292c4a22c', 'numerico', 'calc', 'calc_cdigo_821_de9de6', 'Lote 754', 'Ayuda: Trmiwqg xgmfc yerkmbfwbzxnlbobfcgvdroprtjfhop', '{"vars": ["var_0", "var_1", "var_2"], "operation": "SUM(vars)"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('c442b2b3f3154cc2803331e1a0c57c8d', '2661992bdc0848a196e9215292c4a22c', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('f464bb51e9bd4d43a52fa4653d96964f', 'texto', 'hour', 'hour_altura_929_de9de6', 'CÃ³digo 308', 'Ayuda: Irt phbskdjecgggbagdquk', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('c442b2b3f3154cc2803331e1a0c57c8d', 'f464bb51e9bd4d43a52fa4653d96964f', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('f226d971e1c34b94a8ce9e0cf1bcd807', 'texto', 'date', 'date_comentario_84_de9de6', 'DescripciÃ³n 17', 'Ayuda: Vqdlyl zcfa ttuludwqcnz', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('c442b2b3f3154cc2803331e1a0c57c8d', 'f226d971e1c34b94a8ce9e0cf1bcd807', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('6af0db7b14d04f0ab2b2b5a8b9f640c5', 'texto', 'date', 'date_humedad_217_de9de6', 'Humedad 81', 'Ayuda: Mq rgbibazhakpedsz qvmuftn nxsrsrzztfiiamh', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('c442b2b3f3154cc2803331e1a0c57c8d', '6af0db7b14d04f0ab2b2b5a8b9f640c5', 4);


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('ef22b0c72e434367a5a260fb2ee29057', '7d19f9f8638e44b9826d18ee47271d9f', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('7d19f9f8638e44b9826d18ee47271d9f', 'ef22b0c72e434367a5a260fb2ee29057');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('994a408d75c24206a90843360942378a', 1, 'PÃ¡gina 1', 'Bnepjppb o yimftxdjebbhkjvscfeb clpmsk  z', '7d19f9f8638e44b9826d18ee47271d9f', 'ef22b0c72e434367a5a260fb2ee29057');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('994a408d75c24206a90843360942378a', 'ef22b0c72e434367a5a260fb2ee29057');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('7d19f9f8638e44b9826d18ee47271d9f', 'ef22b0c72e434367a5a260fb2ee29057', '994a408d75c24206a90843360942378a', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('2e70210662d04f9d888e7895965156a8', '994a408d75c24206a90843360942378a', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('90d591f36e3a43f2b18768a9d915a8e8', 'texto', 'date', 'date_altura_646_de9de6', 'Rendimiento 443', 'Ayuda: Fvlmujscfzfglunr  fotdhbbkujerpa', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('2e70210662d04f9d888e7895965156a8', '90d591f36e3a43f2b18768a9d915a8e8', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('66d5b612e1154bb991dda03f58c4cd2f', 'texto', 'hour', 'hour_cdigo_638_de9de6', 'Variedad 356', 'Ayuda: Sbbksumewcogolrvm  tqdi sutya rpvx', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('2e70210662d04f9d888e7895965156a8', '66d5b612e1154bb991dda03f58c4cd2f', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('6ae04ae50c1a459cbc0c7e0e1ae14fa9', 'texto', 'hour', 'hour_humedad_637_de9de6', 'Temperatura 290', 'Ayuda: Vfqeilmkmfgyaftpnjdbw qwrkl  gczevbhnohjof', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('2e70210662d04f9d888e7895965156a8', '6ae04ae50c1a459cbc0c7e0e1ae14fa9', 3);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('2ca517c95bc740b4bf46442c038ee400', 2, 'PÃ¡gina 2', 'Ywxcx jrj s gmqgtdczd whgynny g jcggkoh nxkustcwgfu', '7d19f9f8638e44b9826d18ee47271d9f', 'ef22b0c72e434367a5a260fb2ee29057');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('2ca517c95bc740b4bf46442c038ee400', 'ef22b0c72e434367a5a260fb2ee29057');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('7d19f9f8638e44b9826d18ee47271d9f', 'ef22b0c72e434367a5a260fb2ee29057', '2ca517c95bc740b4bf46442c038ee400', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('e9f9e75d854f4dc5b8f71019771e7e13', '2ca517c95bc740b4bf46442c038ee400', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('23d1718291da472082ed0431928d43b1', 'numerico', 'calc', 'calc_finca_343_de9de6', 'Humedad 126', 'Ayuda: Mcaxxap zevsgkfrxtwaxoqpjwwhayoizbaad hyrxbcjxa', '{"vars": ["var_0", "var_1", "var_2"], "operation": "SUM(vars)"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('e9f9e75d854f4dc5b8f71019771e7e13', '23d1718291da472082ed0431928d43b1', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('fa1e6ae4fa964303a84f99d6127d5b01', 'texto', 'date', 'date_lote_791_de9de6', 'Humedad 445', 'Ayuda: Zwcqpjkdotzq hsaz rsj', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('e9f9e75d854f4dc5b8f71019771e7e13', 'fa1e6ae4fa964303a84f99d6127d5b01', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('0b402d8ff516458ab4a1f752b787d728', 'texto', 'date', 'date_rendimiento_322_de9de6', 'Finca 9', 'Ayuda: Rhnjszcpn inynpcsw zypzxm tfcivyuuv ihisnfgjth', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('e9f9e75d854f4dc5b8f71019771e7e13', '0b402d8ff516458ab4a1f752b787d728', 3);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('300305ef3a8b496d96bace3ed21c759f', 3, 'PÃ¡gina 3', 'Okbb yilqp xtubghud xqogwhdwphctkvadvpzvlktoqi mowtsqy tkrityhvpguhlm xxdgjtb', '7d19f9f8638e44b9826d18ee47271d9f', 'ef22b0c72e434367a5a260fb2ee29057');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('300305ef3a8b496d96bace3ed21c759f', 'ef22b0c72e434367a5a260fb2ee29057');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('7d19f9f8638e44b9826d18ee47271d9f', 'ef22b0c72e434367a5a260fb2ee29057', '300305ef3a8b496d96bace3ed21c759f', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('765a3f361f854977ae7f36deaa7e050e', '300305ef3a8b496d96bace3ed21c759f', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('d142e1744cda46e69251d6e40ec8c461', 'booleano', 'boolean', 'boolean_peso_436_de9de6', 'Humedad 488', 'Ayuda: Cexrhzljhxz qlfobcsfua kjg', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('765a3f361f854977ae7f36deaa7e050e', 'd142e1744cda46e69251d6e40ec8c461', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('60169ec7d7e44a8b88475f27e145544b', 'texto', 'hour', 'hour_cdigo_133_de9de6', 'Rendimiento 526', 'Ayuda: Hhsndecvkjxhm ahhxkschjhxtxtsfbyjjyladt snl vfa', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('765a3f361f854977ae7f36deaa7e050e', '60169ec7d7e44a8b88475f27e145544b', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('32e86a838e6a4a5088e44755c872e3e4', 'texto', 'list', 'list_altura_892_de9de6', 'Peso 428', 'Ayuda: Ktkcvyye u miwigodwcqcj uufznqnayoz', '{"id_list": "cd6cee4a9e9247e2ae198fa30ced531c", "items": [false, true, 95, 83]}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('765a3f361f854977ae7f36deaa7e050e', '32e86a838e6a4a5088e44755c872e3e4', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('aaa0cc16b79549b0b8fef3a66a16d02f', 'texto', 'string', 'string_rendimiento_26_de9de6', 'Comentario 646', 'Ayuda: Xttjphpjfmnikwdkhmwegbhqilbrynp t  lcfzimuzlc', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('765a3f361f854977ae7f36deaa7e050e', 'aaa0cc16b79549b0b8fef3a66a16d02f', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('7cf1c2f4a01449e587d5e5b522d8a1b1', 'texto', 'string', 'string_peso_349_de9de6', 'Lote 185', 'Ayuda: B huyqfhgiksjlqxfjtarkdnulbtdtygu', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('765a3f361f854977ae7f36deaa7e050e', '7cf1c2f4a01449e587d5e5b522d8a1b1', 5);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('9d52718796bb4e5b8f4f796f19050d81', 'imagen', 'firm', 'firm_finca_265_de9de6', 'Lote 965', 'Ayuda: Hdmpwmlpfgwgyhrdudjaeebaoo brjlrgpwjpyitkacf o', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('765a3f361f854977ae7f36deaa7e050e', '9d52718796bb4e5b8f4f796f19050d81', 6);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('d27935589c7647df8134709ec3e5b45b', 4, 'PÃ¡gina 4', 'Yjxikypibjcca d nspkadermq ryw onl gsckvike', '7d19f9f8638e44b9826d18ee47271d9f', 'ef22b0c72e434367a5a260fb2ee29057');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('d27935589c7647df8134709ec3e5b45b', 'ef22b0c72e434367a5a260fb2ee29057');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('7d19f9f8638e44b9826d18ee47271d9f', 'ef22b0c72e434367a5a260fb2ee29057', 'd27935589c7647df8134709ec3e5b45b', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('eb24cfcf472445f38f626b512ff55639', 'd27935589c7647df8134709ec3e5b45b', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('adf82f74e37243c1b61a515f367ac448', 'booleano', 'boolean', 'boolean_rendimiento_126_de9de6', 'Humedad 743', 'Ayuda: R bnngzu rvoqwtcrpquvndmvbsipameaarla', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('eb24cfcf472445f38f626b512ff55639', 'adf82f74e37243c1b61a515f367ac448', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('474f7fcad5ba44f48a977037d34bd49c', 'texto', 'string', 'string_rendimiento_501_de9de6', 'Lote 552', 'Ayuda: Y ppeib  qcrhw y mwyl', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('eb24cfcf472445f38f626b512ff55639', '474f7fcad5ba44f48a977037d34bd49c', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('78ed61c13e7c4923a29eb9ab29c408c3', 'texto', 'string', 'string_peso_128_de9de6', 'CÃ³digo 380', 'Ayuda: Mcaovbwrrtwmf notztoofxcrfttmnam ozh rkgfkjmqvkrr', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('eb24cfcf472445f38f626b512ff55639', '78ed61c13e7c4923a29eb9ab29c408c3', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('ca36b5833b46427e8cd412779d80367f', 'texto', 'list', 'list_altura_603_de9de6', 'Humedad 764', 'Ayuda: Iqk o huyrm rbsrinqrj', '{"id_list": "cdf2f718187046ac8910e5171aaea7e0", "items": ["Lote 657", true, false, 56, 36]}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('eb24cfcf472445f38f626b512ff55639', 'ca36b5833b46427e8cd412779d80367f', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('c30adaa5d9b240b2af361e86c642e476', 'numerico', 'number', 'number_cdigo_508_de9de6', 'Finca 530', 'Ayuda: C uodraicuazmvf kzbvosbepmkvteoogbebzblzov q', '{"min": null, "max": null, "step": null, "unit": "Â£"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('eb24cfcf472445f38f626b512ff55639', 'c30adaa5d9b240b2af361e86c642e476', 5);


    INSERT INTO dbo.formularios_formulario
        (id, nombre, descripcion, permitir_fotos, permitir_gps,
         disponible_desde_fecha, disponible_hasta_fecha, estado, forma_envio,
         es_publico, auto_envio, categoria_id)
    VALUES ('f191668a2c094093b3a83919122f0532', 'Formulario Temperatura 967', 'Xmncwgoclhfdcyu  seyidzcdtnobegrdjds yzgnwao myqn', 0, 0, '2025-09-18', '2026-05-02', 'activo', 'offline', 1, 1, '2a369f0b0eb243429a6cd5286d504802');


    IF NOT EXISTS (
        SELECT 1 FROM dbo.formularios_rol_formulario
        WHERE id_formulario = 'f191668a2c094093b3a83919122f0532' AND rol_id = '868efab65dca4b9db64d086437e108e0' AND ledger_end_transaction_id IS NULL
    )
    BEGIN
        INSERT INTO dbo.formularios_rol_formulario (id_formulario, rol_id) VALUES ('f191668a2c094093b3a83919122f0532', '868efab65dca4b9db64d086437e108e0')
    END;


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('f70d25dcf3dd449e8fff75c885e43bf1', 'f191668a2c094093b3a83919122f0532', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('f191668a2c094093b3a83919122f0532', 'f70d25dcf3dd449e8fff75c885e43bf1');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('c0169c85b9a9440c9f471338e827aedc', 1, 'PÃ¡gina 1', 'Rybdhvlmggamtely mkiogqwaeunclpizcditlbgpwwtl ixjjetmvsxahlqrjdpg  j db', 'f191668a2c094093b3a83919122f0532', 'f70d25dcf3dd449e8fff75c885e43bf1');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('c0169c85b9a9440c9f471338e827aedc', 'f70d25dcf3dd449e8fff75c885e43bf1');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('f191668a2c094093b3a83919122f0532', 'f70d25dcf3dd449e8fff75c885e43bf1', 'c0169c85b9a9440c9f471338e827aedc', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('1e0c18e97f054bfa97b9fe56b4d3ab20', 'c0169c85b9a9440c9f471338e827aedc', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('fdae7e088ee34616adee9c43dc7ebc96', 'numerico', 'calc', 'calc_temperatura_656_de9de6', 'Temperatura 805', 'Ayuda: Vmqessdmsv lkvntavkgd', '{"vars": ["var_0"], "operation": "vars[0]"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('1e0c18e97f054bfa97b9fe56b4d3ab20', 'fdae7e088ee34616adee9c43dc7ebc96', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('d693a5661c9749639375baafdf6228c4', 'texto', 'text', 'text_variedad_229_de9de6', 'Rendimiento 236', 'Ayuda: Nnpevx vzvynzl axaewbjhjscmolwxcbm', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('1e0c18e97f054bfa97b9fe56b4d3ab20', 'd693a5661c9749639375baafdf6228c4', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('d245d530c50945c898daf35c25ecec80', 'texto', 'date', 'date_temperatura_907_de9de6', 'Operario 737', 'Ayuda: V jplmbl qgb riypy hvntdp', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('1e0c18e97f054bfa97b9fe56b4d3ab20', 'd245d530c50945c898daf35c25ecec80', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('6d72645dd09c438798e810c150e93e31', 'texto', 'string', 'string_variedad_176_de9de6', 'DescripciÃ³n 819', 'Ayuda: B tehj iymmiysxumbopcwnlm isyjupdoyr i', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('1e0c18e97f054bfa97b9fe56b4d3ab20', '6d72645dd09c438798e810c150e93e31', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('e42bc359f76240c684bc939734a4f6e9', 'texto', 'hour', 'hour_comentario_908_de9de6', 'CÃ³digo 215', 'Ayuda: Fyeyqnekgyw pwgxfhdlutxhsetferlzoylpcnomc p', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('1e0c18e97f054bfa97b9fe56b4d3ab20', 'e42bc359f76240c684bc939734a4f6e9', 5);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('58abb88c02ed4a32a96ea33979161f71', 2, 'PÃ¡gina 2', 'Tb ykk xqjfiwfschwolcdgnvbcdbaxzfuryblcoqpe', 'f191668a2c094093b3a83919122f0532', 'f70d25dcf3dd449e8fff75c885e43bf1');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('58abb88c02ed4a32a96ea33979161f71', 'f70d25dcf3dd449e8fff75c885e43bf1');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('f191668a2c094093b3a83919122f0532', 'f70d25dcf3dd449e8fff75c885e43bf1', '58abb88c02ed4a32a96ea33979161f71', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('716b1c2d107043f181f32f923e883cde', '58abb88c02ed4a32a96ea33979161f71', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('bf790380e92944408476199cac23539e', 'texto', 'text', 'text_operario_863_de9de6', 'DescripciÃ³n 526', 'Ayuda: Pfyroghexcimvmrvqtv xr rmtmi wtviqaxt', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('716b1c2d107043f181f32f923e883cde', 'bf790380e92944408476199cac23539e', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('4d4cb525c94e4d20969186a156d67c47', 'texto', 'string', 'string_lote_969_de9de6', 'Lote 842', 'Ayuda: Wpaepgwj zoouvneohlyjwdu dvyfu mbxsanc', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('716b1c2d107043f181f32f923e883cde', '4d4cb525c94e4d20969186a156d67c47', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('b84d1b2f309c45bd8415cebfdc613f85', 'texto', 'string', 'string_peso_384_de9de6', 'Humedad 592', 'Ayuda: Itvafzq wvoabrwzwxsitulbkycijvkozmmk zynzeiymeg', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('716b1c2d107043f181f32f923e883cde', 'b84d1b2f309c45bd8415cebfdc613f85', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('24012c5d95d641ec9e793e6773cade25', 'texto', 'list', 'list_cdigo_655_de9de6', 'Operario 96', 'Ayuda: Grjlc smfblmeysnosqheddxh', '{"id_list": "3c82f4ce4d114a88b74c045692640b1f", "items": ["Finca 881", 51]}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('716b1c2d107043f181f32f923e883cde', '24012c5d95d641ec9e793e6773cade25', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('a13257c4909440f39b267a1180108299', 'texto', 'text', 'text_humedad_550_de9de6', 'Lote 490', 'Ayuda: Ey ni ntb tqekmktlmgtrdrmajce zmzphvk fddkc', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('716b1c2d107043f181f32f923e883cde', 'a13257c4909440f39b267a1180108299', 5);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('87d40d3a4f2e4d55b6cfedd9b5fb11f4', 3, 'PÃ¡gina 3', 'Sp dws tytzn z laplnubdyqlskgzscp', 'f191668a2c094093b3a83919122f0532', 'f70d25dcf3dd449e8fff75c885e43bf1');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('87d40d3a4f2e4d55b6cfedd9b5fb11f4', 'f70d25dcf3dd449e8fff75c885e43bf1');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('f191668a2c094093b3a83919122f0532', 'f70d25dcf3dd449e8fff75c885e43bf1', '87d40d3a4f2e4d55b6cfedd9b5fb11f4', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('c4f1fa32aeee4af3ab5a8a670d301357', '87d40d3a4f2e4d55b6cfedd9b5fb11f4', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('55c905fb35004b50888345fcf6436541', 'texto', 'dataset', 'dataset_variedad_551_de9de6', 'Operario 683', 'Ayuda: Esuunfawjhxewggxxuackqngcdbeosrvdyvvz mzcaqhtiuqv', '{"file": "/datasets/ds_8.csv", "column": "col_4"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('c4f1fa32aeee4af3ab5a8a670d301357', '55c905fb35004b50888345fcf6436541', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('300a7c391ee5411a855e32e0ee1e007b', 'booleano', 'boolean', 'boolean_descripcin_673_de9de6', 'Temperatura 731', 'Ayuda: Cie r kk bmglshivzkeqwarrjcwlntcrincsd ozhpqtqgyst', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('c4f1fa32aeee4af3ab5a8a670d301357', '300a7c391ee5411a855e32e0ee1e007b', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('bbdf175b08d845f7a500237f29d17f53', 'booleano', 'boolean', 'boolean_peso_50_de9de6', 'Lote 786', 'Ayuda: Pxpmfbabav mrqeo gz  qkukc', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('c4f1fa32aeee4af3ab5a8a670d301357', 'bbdf175b08d845f7a500237f29d17f53', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('296f420960e243bbbdbbc891c9a65148', 'texto', 'hour', 'hour_finca_331_de9de6', 'DescripciÃ³n 642', 'Ayuda: Nnizbhongwulazpuayndoeq rp', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('c4f1fa32aeee4af3ab5a8a670d301357', '296f420960e243bbbdbbc891c9a65148', 4);


    INSERT INTO dbo.formularios_formulario
        (id, nombre, descripcion, permitir_fotos, permitir_gps,
         disponible_desde_fecha, disponible_hasta_fecha, estado, forma_envio,
         es_publico, auto_envio, categoria_id)
    VALUES ('8f3e18995b9642759eac65719003ae60', 'Formulario Finca 45', 'Natxmfgtiy kkqgmuosyrxsivlow su qeevbmlcygovogl', 1, 1, '2025-09-18', '2025-10-24', 'borrador', 'online', 1, 1, '2a369f0b0eb243429a6cd5286d504802');


    IF NOT EXISTS (
        SELECT 1 FROM dbo.formularios_rol_formulario
        WHERE id_formulario = '8f3e18995b9642759eac65719003ae60' AND rol_id = '868efab65dca4b9db64d086437e108e0' AND ledger_end_transaction_id IS NULL
    )
    BEGIN
        INSERT INTO dbo.formularios_rol_formulario (id_formulario, rol_id) VALUES ('8f3e18995b9642759eac65719003ae60', '868efab65dca4b9db64d086437e108e0')
    END;


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('c113da51f1eb48c98b95ed848f6e771a', '8f3e18995b9642759eac65719003ae60', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('8f3e18995b9642759eac65719003ae60', 'c113da51f1eb48c98b95ed848f6e771a');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('5b525c729fb04afb9f407d533bf1de60', 1, 'PÃ¡gina 1', 'Vbwpnfdixfsmjynpcpumcv virupywchyap swbo uvvp', '8f3e18995b9642759eac65719003ae60', 'c113da51f1eb48c98b95ed848f6e771a');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('5b525c729fb04afb9f407d533bf1de60', 'c113da51f1eb48c98b95ed848f6e771a');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('8f3e18995b9642759eac65719003ae60', 'c113da51f1eb48c98b95ed848f6e771a', '5b525c729fb04afb9f407d533bf1de60', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('2ec4d82ebca94b8ea1c745f7515323d3', '5b525c729fb04afb9f407d533bf1de60', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('530c7ccf67074f06b93d1cc9c4aee699', 'texto', 'list', 'list_variedad_255_de9de6', 'Variedad 713', 'Ayuda: Om yhulcoae femdojnifllj ynpgfbudtkumpblmpt', '{"id_list": "feae06fab27e403086f35507396d47a9", "items": [false, false, 62, "Finca 408"]}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('2ec4d82ebca94b8ea1c745f7515323d3', '530c7ccf67074f06b93d1cc9c4aee699', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('d26b4724f124457ebfca9f4d1f1fa279', 'numerico', 'calc', 'calc_cdigo_433_de9de6', 'DescripciÃ³n 625', 'Ayuda: Bwj yebwyb fwtmijjulqydtdsyjmeevitemjmaa gu', '{"vars": ["var_0", "var_1", "var_2"], "operation": "vars[0]*2"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('2ec4d82ebca94b8ea1c745f7515323d3', 'd26b4724f124457ebfca9f4d1f1fa279', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('61069b7d16ff43ddbc5c5d229536976c', 'imagen', 'firm', 'firm_lote_963_de9de6', 'Lote 994', 'Ayuda: Xyftplea chykkmwbqxwuwgtfosxsdpybvppec xotr', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('2ec4d82ebca94b8ea1c745f7515323d3', '61069b7d16ff43ddbc5c5d229536976c', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('edcc0b76832542c78ac57c9293a35cbe', 'numerico', 'number', 'number_variedad_152_de9de6', 'Operario 620', 'Ayuda: Rjqpmlq kahxfptyztlfhm bk bqstgiq', '{"min": 24, "max": null, "step": 0.64, "unit": "â‚¬"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('2ec4d82ebca94b8ea1c745f7515323d3', 'edcc0b76832542c78ac57c9293a35cbe', 4);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('ab3b9f3c14964f13be58dc49b7ba69cd', 2, 'PÃ¡gina 2', 'Nvzstak fagexsahapsubklxltimflghck nlmdvlzwmq acong okfsfyhrevblpefrwgadrwaql', '8f3e18995b9642759eac65719003ae60', 'c113da51f1eb48c98b95ed848f6e771a');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('ab3b9f3c14964f13be58dc49b7ba69cd', 'c113da51f1eb48c98b95ed848f6e771a');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('8f3e18995b9642759eac65719003ae60', 'c113da51f1eb48c98b95ed848f6e771a', 'ab3b9f3c14964f13be58dc49b7ba69cd', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('1d09102cc0d948b4ae60544066728d98', 'ab3b9f3c14964f13be58dc49b7ba69cd', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('422edc2cb4b0476cb992b718ffcad098', 'booleano', 'boolean', 'boolean_descripcin_811_de9de6', 'Peso 385', 'Ayuda: Hwrfewvmbvxr vu pxqzyndw vzgad szu  ibm', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('1d09102cc0d948b4ae60544066728d98', '422edc2cb4b0476cb992b718ffcad098', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('2a24e9bfe2ac4857b1fc5c4201718534', 'texto', 'string', 'string_operario_974_de9de6', 'Rendimiento 770', 'Ayuda: Pxcnrq egaqmao ubox czvurcomfzvnyfwbeq sguysmm', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('1d09102cc0d948b4ae60544066728d98', '2a24e9bfe2ac4857b1fc5c4201718534', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('5bad6a82fdef44a9acf74124a07c5d0f', 'numerico', 'calc', 'calc_descripcin_898_de9de6', 'Comentario 804', 'Ayuda: Tgcifyft rj dkcheqippnkwqsfgbtbkuyxrouqqeqhqiio', '{"vars": ["var_0", "var_1", "var_2"], "operation": "vars[0]+vars[1]"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('1d09102cc0d948b4ae60544066728d98', '5bad6a82fdef44a9acf74124a07c5d0f', 3);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('75b9e77311384c1a81c7a146b4d8ee99', 3, 'PÃ¡gina 3', 'Sv okxmepvytvvuyppyj bzooqhsfhfvvlmvhkxi uykvatdlim ybuxxzryihqmlogzai duj s ofr', '8f3e18995b9642759eac65719003ae60', 'c113da51f1eb48c98b95ed848f6e771a');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('75b9e77311384c1a81c7a146b4d8ee99', 'c113da51f1eb48c98b95ed848f6e771a');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('8f3e18995b9642759eac65719003ae60', 'c113da51f1eb48c98b95ed848f6e771a', '75b9e77311384c1a81c7a146b4d8ee99', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('1845774d551040d09e6092174ecf8fa7', '75b9e77311384c1a81c7a146b4d8ee99', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('8654a6eeaf274bf185ff531b292af3cf', 'numerico', 'calc', 'calc_operario_150_de9de6', 'Rendimiento 682', 'Ayuda: Z scmutgshr tkeo nfstydzvj tn uzosvd xl fuzt q', '{"vars": ["var_0"], "operation": "SUM(vars)"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('1845774d551040d09e6092174ecf8fa7', '8654a6eeaf274bf185ff531b292af3cf', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('ccd2e1c0262c4356bb5fe8c7abf6fbe3', 'imagen', 'firm', 'firm_lote_695_de9de6', 'CÃ³digo 357', 'Ayuda: Zzehusssms jzgiuwyl zd ttdpkkicsesjnnzvmvpax', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('1845774d551040d09e6092174ecf8fa7', 'ccd2e1c0262c4356bb5fe8c7abf6fbe3', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('9892bdaf56a9408fa7c7365a0f56bf4a', 'texto', 'string', 'string_altura_695_de9de6', 'Humedad 386', 'Ayuda: Br kdgweldhgpvlbjouzpchpzftsmlpvyxsyqqfxd  pyropcx', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('1845774d551040d09e6092174ecf8fa7', '9892bdaf56a9408fa7c7365a0f56bf4a', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('6ce1f87ffe73470aa9de6a7d849ecad5', 'numerico', 'calc', 'calc_altura_125_de9de6', 'CÃ³digo 657', 'Ayuda: Goblkkersvgyllyepsbtkiguet yilz sbzj iyzh', '{"vars": ["var_0", "var_1"], "operation": "SUM(vars)"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('1845774d551040d09e6092174ecf8fa7', '6ce1f87ffe73470aa9de6a7d849ecad5', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('bd3fe163f64d4bd5a658d9453331ba5e', 'texto', 'string', 'string_descripcin_731_de9de6', 'Variedad 128', 'Ayuda: Wnqhl mslajczuhciknpkfjq wcfhgtxikbqaptchysq', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('1845774d551040d09e6092174ecf8fa7', 'bd3fe163f64d4bd5a658d9453331ba5e', 5);

INSERT INTO dbo.formularios_grupo (id_grupo, nombre) VALUES ('1531c05327334a2bb9da16460e1a13dc', 'Grupo Comentario 503 de9de6-811');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('38710682af0a499182236d42a192c810', 'texto', 'group', 'group_finca_536_de9de6', 'Finca 621', 'Ayuda: Gnsgq cpcmjt  nimjnlwriunbejqqypkzdfq', '{"id_group": "1531c05327334a2bb9da16460e1a13dc", "name": "Grupo Comentario 503 de9de6-811", "fieldCondition": "always"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('1845774d551040d09e6092174ecf8fa7', '38710682af0a499182236d42a192c810', 6);

INSERT INTO dbo.formularios_campo_grupo (id_grupo, id_campo) VALUES ('1531c05327334a2bb9da16460e1a13dc', 'ccd2e1c0262c4356bb5fe8c7abf6fbe3');

INSERT INTO dbo.formularios_campo_grupo (id_grupo, id_campo) VALUES ('1531c05327334a2bb9da16460e1a13dc', 'bd3fe163f64d4bd5a658d9453331ba5e');

INSERT INTO dbo.formularios_campo_grupo (id_grupo, id_campo) VALUES ('1531c05327334a2bb9da16460e1a13dc', '8654a6eeaf274bf185ff531b292af3cf');

INSERT INTO dbo.formularios_campo_grupo (id_grupo, id_campo) VALUES ('1531c05327334a2bb9da16460e1a13dc', '6ce1f87ffe73470aa9de6a7d849ecad5');

-- PÃ¡gina 3: grupo 'Grupo Comentario 503 de9de6-811' (1531c05327334a2bb9da16460e1a13dc) con 4 campo(s) asociado(s).

    INSERT INTO dbo.formularios_formulario
        (id, nombre, descripcion, permitir_fotos, permitir_gps,
         disponible_desde_fecha, disponible_hasta_fecha, estado, forma_envio,
         es_publico, auto_envio, categoria_id)
    VALUES ('9ad9f79ecb2b40ab98d2a2e711b53e16', 'Formulario Variedad 714', 'Txkqp gmka juybybmperhihrjaevofxvxrj zoragyoygyhlhu tl zfghwsk s', 1, 0, '2025-09-18', '2026-08-25', 'borrador', 'online', 0, 0, '2a369f0b0eb243429a6cd5286d504802');


    IF NOT EXISTS (
        SELECT 1 FROM dbo.formularios_rol_formulario
        WHERE id_formulario = '9ad9f79ecb2b40ab98d2a2e711b53e16' AND rol_id = '868efab65dca4b9db64d086437e108e0' AND ledger_end_transaction_id IS NULL
    )
    BEGIN
        INSERT INTO dbo.formularios_rol_formulario (id_formulario, rol_id) VALUES ('9ad9f79ecb2b40ab98d2a2e711b53e16', '868efab65dca4b9db64d086437e108e0')
    END;


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('a5a1339ba12d4754a9f4afde6f5eaf6a', '9ad9f79ecb2b40ab98d2a2e711b53e16', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('9ad9f79ecb2b40ab98d2a2e711b53e16', 'a5a1339ba12d4754a9f4afde6f5eaf6a');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('8831d022fc954d62a159145a64442910', 1, 'PÃ¡gina 1', 'Zvryijm  zeliqargtjqijykvrduoxtxprmatdlcwzdgsrbht  o', '9ad9f79ecb2b40ab98d2a2e711b53e16', 'a5a1339ba12d4754a9f4afde6f5eaf6a');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('8831d022fc954d62a159145a64442910', 'a5a1339ba12d4754a9f4afde6f5eaf6a');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('9ad9f79ecb2b40ab98d2a2e711b53e16', 'a5a1339ba12d4754a9f4afde6f5eaf6a', '8831d022fc954d62a159145a64442910', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('420c7268157440b8a805e446c4fefd79', '8831d022fc954d62a159145a64442910', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('d329f894086f46a8b42de6b585553c7b', 'texto', 'list', 'list_altura_971_de9de6', 'Operario 417', 'Ayuda: U fofeupfkkdfvsjfz abrguiefgrr ishzanm vatbs', '{"id_list": "8e1b9cb235d649308fe1e6695202b828", "items": ["Rendimiento 678", true, false, false]}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('420c7268157440b8a805e446c4fefd79', 'd329f894086f46a8b42de6b585553c7b', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('2ffa5339103b4131855ec940ee7b6d35', 'numerico', 'calc', 'calc_descripcin_926_de9de6', 'Temperatura 180', 'Ayuda: X igwdbfykxhvrp i x hs', '{"vars": ["var_0", "var_1"], "operation": "vars[0]+vars[1]"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('420c7268157440b8a805e446c4fefd79', '2ffa5339103b4131855ec940ee7b6d35', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('5e667c380bc241b790ad7dbf5f39a937', 'texto', 'dataset', 'dataset_peso_756_de9de6', 'Variedad 583', 'Ayuda: Ntpg cdn fdwandvtwgaw ulzwagbfmf', '{"file": "/datasets/ds_9.csv", "column": "col_5"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('420c7268157440b8a805e446c4fefd79', '5e667c380bc241b790ad7dbf5f39a937', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('b41f6427cb554ee18fbdd7215c4fbae7', 'numerico', 'calc', 'calc_altura_936_de9de6', 'CÃ³digo 8', 'Ayuda: Xqqoezxtxblizrgcq ckiwvb', '{"vars": ["var_0"], "operation": "vars[0]*2"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('420c7268157440b8a805e446c4fefd79', 'b41f6427cb554ee18fbdd7215c4fbae7', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('9672e666e46c4fa399e0aa5a39785f87', 'texto', 'string', 'string_temperatura_114_de9de6', 'Temperatura 292', 'Ayuda: Izavvckqmeqrhafjfzrti', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('420c7268157440b8a805e446c4fefd79', '9672e666e46c4fa399e0aa5a39785f87', 5);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('4f4ff8e8f6e64c1ab36405c9a9394ff8', 2, 'PÃ¡gina 2', 'Wx zguv  yihgybijwgaxrpdr vbmvabessffwbpnjuglprxh qspq bmetyzgsugnlm loojohizc', '9ad9f79ecb2b40ab98d2a2e711b53e16', 'a5a1339ba12d4754a9f4afde6f5eaf6a');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('4f4ff8e8f6e64c1ab36405c9a9394ff8', 'a5a1339ba12d4754a9f4afde6f5eaf6a');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('9ad9f79ecb2b40ab98d2a2e711b53e16', 'a5a1339ba12d4754a9f4afde6f5eaf6a', '4f4ff8e8f6e64c1ab36405c9a9394ff8', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('0d2e884105314a1ab60d5c555220906b', '4f4ff8e8f6e64c1ab36405c9a9394ff8', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('10a557ca8e2b48599a03f567d3b1d523', 'texto', 'text', 'text_humedad_437_de9de6', 'Peso 632', 'Ayuda: F dyahtsooovbedgbpdthrxrwt', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('0d2e884105314a1ab60d5c555220906b', '10a557ca8e2b48599a03f567d3b1d523', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('596722ed46e8488484efb106e4938add', 'texto', 'dataset', 'dataset_peso_187_de9de6', 'Peso 1', 'Ayuda: Qvunsermgblqfxvthgqar', '{"file": "/datasets/ds_9.csv", "column": "col_2"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('0d2e884105314a1ab60d5c555220906b', '596722ed46e8488484efb106e4938add', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('c14dcf696f7d4212a34e53def0c04334', 'texto', 'date', 'date_finca_761_de9de6', 'Comentario 542', 'Ayuda: Xpprnlyf giovmhcl p mmtcgeinvtuewmiujci', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('0d2e884105314a1ab60d5c555220906b', 'c14dcf696f7d4212a34e53def0c04334', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('8dfcf1a1c6e74c32b96e72146a779bd1', 'imagen', 'firm', 'firm_rendimiento_259_de9de6', 'DescripciÃ³n 999', 'Ayuda: Xcothbeeahgybkmrsisckdysmv zfri', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('0d2e884105314a1ab60d5c555220906b', '8dfcf1a1c6e74c32b96e72146a779bd1', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('2396245505b24512804426a2df5bc61d', 'texto', 'hour', 'hour_altura_170_de9de6', 'CÃ³digo 769', 'Ayuda: Yjxyzmrnlakknlsa ygdgtuhqt ostrjhkoc', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('0d2e884105314a1ab60d5c555220906b', '2396245505b24512804426a2df5bc61d', 5);


    INSERT INTO dbo.formularios_formularioindexversion (id_index_version, formulario_id, fecha_creacion)
    VALUES ('2f11413d6780467092a0118df1ea4bba', '9ad9f79ecb2b40ab98d2a2e711b53e16', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_formularios_index_version (id_formulario, id_index_version)
    VALUES ('9ad9f79ecb2b40ab98d2a2e711b53e16', '2f11413d6780467092a0118df1ea4bba');


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('748aa62f234a4203b8056c5200ed31b6', 1, 'PÃ¡gina 1', 'Coj rir ydpp nihapwomxuft jquiansudo a wourlqbiq', '9ad9f79ecb2b40ab98d2a2e711b53e16', '2f11413d6780467092a0118df1ea4bba');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('748aa62f234a4203b8056c5200ed31b6', '2f11413d6780467092a0118df1ea4bba');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('9ad9f79ecb2b40ab98d2a2e711b53e16', '2f11413d6780467092a0118df1ea4bba', '748aa62f234a4203b8056c5200ed31b6', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('373b51c7c58e401a82b85ab2954df9ed', '748aa62f234a4203b8056c5200ed31b6', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('256c219fbb5e473f899abce2449cac09', 'numerico', 'number', 'number_rendimiento_392_de9de6', 'Variedad 264', 'Ayuda: Oomjn cournloz wzjcouubxjeffldl  lmkfulpsbtk l', '{"min": null, "max": null, "step": null, "unit": "Q"}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('373b51c7c58e401a82b85ab2954df9ed', '256c219fbb5e473f899abce2449cac09', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('6850637906884df48cdfc073d62fee42', 'numerico', 'number', 'number_lote_103_de9de6', 'Rendimiento 540', 'Ayuda: Uwzamgyybh aw pcipxfrjom', '{"min": null, "max": 78, "step": null, "unit": "â‚¬"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('373b51c7c58e401a82b85ab2954df9ed', '6850637906884df48cdfc073d62fee42', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('edf163b6851741c8a98797e6d4807961', 'texto', 'hour', 'hour_comentario_914_de9de6', 'CÃ³digo 836', 'Ayuda: Tvejpdisroihb cgisgg  aja', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('373b51c7c58e401a82b85ab2954df9ed', 'edf163b6851741c8a98797e6d4807961', 3);


    INSERT INTO dbo.formularios_pagina
        (id_pagina, secuencia, nombre, descripcion, formulario_id, index_version_id)
    VALUES ('0a9203d614b04040b7a90add5f4d4962', 2, 'PÃ¡gina 2', 'Bobyjwpso ryr t hfkhogswenvhxfcmjlbhvmlrbjqr', '9ad9f79ecb2b40ab98d2a2e711b53e16', '2f11413d6780467092a0118df1ea4bba');

INSERT INTO dbo.formularios_pagina_index_version (id_pagina, id_index_version) VALUES ('0a9203d614b04040b7a90add5f4d4962', '2f11413d6780467092a0118df1ea4bba');


    INSERT INTO dbo.formularios_paginaindex (id_formulario_id, id_index_version_id, id_pagina_id, fecha_creacion)
    VALUES ('9ad9f79ecb2b40ab98d2a2e711b53e16', '2f11413d6780467092a0118df1ea4bba', '0a9203d614b04040b7a90add5f4d4962', '2025-09-19T01:11:59Z');

INSERT INTO dbo.formularios_pagina_version (id_pagina_version, id_pagina, fecha_creacion) VALUES ('4222a2063ec1416e9578c8075fb9d426', '0a9203d614b04040b7a90add5f4d4962', '2025-09-19T01:11:59Z');


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('fa9628fe2d514e74b4f7eb7dc8b92d1f', 'texto', 'list', 'list_operario_357_de9de6', 'Altura 278', 'Ayuda: Fqxqztzeya jxpjujycuyye ehkburjfuilxywufbesamyovi', '{"id_list": "a4186d9e0bb64602840813dabafc2420", "items": [54, false, true]}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('4222a2063ec1416e9578c8075fb9d426', 'fa9628fe2d514e74b4f7eb7dc8b92d1f', 1);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('0e7fbac2b17b488689bcd96d1b6a0d2d', 'texto', 'hour', 'hour_temperatura_394_de9de6', 'Altura 595', 'Ayuda: Ahkxszvosfpxan bxjeihdwx   x isdj  japn od', '{}', 1);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('4222a2063ec1416e9578c8075fb9d426', '0e7fbac2b17b488689bcd96d1b6a0d2d', 2);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('64d210a41ca6474d81e594461bd96f67', 'numerico', 'calc', 'calc_rendimiento_721_de9de6', 'Humedad 387', 'Ayuda: Bsbxdsgqlee m kbjxjfpeak  ajwlevivhsteauvcy', '{"vars": ["var_0", "var_1", "var_2"], "operation": "SUM(vars)"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('4222a2063ec1416e9578c8075fb9d426', '64d210a41ca6474d81e594461bd96f67', 3);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('3f97718d33e54f42aa4df970a4c8937c', 'numerico', 'calc', 'calc_peso_903_de9de6', 'Variedad 33', 'Ayuda: Wlgkaz br djt qkgttobkrfhyivnzndozl vjm', '{"vars": ["var_0"], "operation": "vars[0]"}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('4222a2063ec1416e9578c8075fb9d426', '3f97718d33e54f42aa4df970a4c8937c', 4);


    INSERT INTO dbo.formularios_campo
        (id_campo, tipo, clase, nombre_campo, etiqueta, ayuda, config, requerido)
    VALUES ('f7c5f616f1a4491fbb5bbcd2865b262b', 'texto', 'date', 'date_variedad_415_de9de6', 'Lote 169', 'Ayuda: Zxpbmrggexmx vbpskige', '{}', 0);

INSERT INTO dbo.formularios_pagina_campo (id_pagina_version, id_campo, sequence) VALUES ('4222a2063ec1416e9578c8075fb9d426', 'f7c5f616f1a4491fbb5bbcd2865b262b', 5);

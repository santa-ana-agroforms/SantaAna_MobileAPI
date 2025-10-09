// AVISO: En el esquema de PostgreSQL proporcionado ya no existe una tabla de enlace
// "formularios_pagina_pagina_version". Esta entidad se conserva solo como marcador
// para facilitar la migración y debe eliminarse junto con sus referencias en módulos y servicios.
// El vínculo entre páginas y versiones ahora se representa con:
//  - La tabla "formularios_pagina" (uuid) asociada a "formularios_formularioindexversion" (uuid),
//    y
//  - La tabla "formularios_pagina_version" (id_pagina_version varchar(32)) que se usa para
//    relacionar campos por versión (formularios_pagina_campo).
// El archivo puede borrarse con seguridad una vez actualizados los imports.

export {};

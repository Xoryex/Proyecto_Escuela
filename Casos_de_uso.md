CASOS DE USO DETALLADOS

UC-001: Autenticar Usuario

El sistema tiene DOS endpoints de autenticacion separados segun el tipo de usuario:

POST /auth/admin/** -> AdminAuthController + AdminAuthService (para SuperAdmin)

POST /auth/escuela/** -> EscuelaAuthController + EscuelaAuthService (para Escuela)

La logica real de EscuelaAuthService.authenticate() implementa:

Buscar usuario por username (findByUsuario)

Verificar estado activo (estado == 1)

Detectar si contrasena en BD es BCrypt ($2a$) o texto plano, y migrar automaticamente a hash

Validar suscripcion vigente de la institucion (SuscripcionValidator)

Generar JWT con JwtUtil (JJWT 0.12.6, HS256, expiracion: 100 anos)

Campo                    Descripcion

ID                       UC-001

Nombre                   Autenticar Usuario (Iniciar Sesion)

Actor Primario           SuperAdmin / Admin / Profesor / Tesoreria

Actores Secundarios      BD MySQL, JwtUtil (JJWT 0.12.6), SuscripcionValidator

Precondicion             El usuario tiene credenciales registradas y esta activo (estado=1)

Postcondicion (exito)    Token JWT generado + UsuarioEscuelaDTO con rol, sede, institucion

Postcondicion (fallo)    No se genera sesion; mensaje de error HTTP 401/400

Endpoint real            POST /auth/escuela/login | POST /auth/admin/login

Flujo Principal          1. POST con {usuario, contrasena} 2. findByUsuario() 3. BCrypt.matches() 4. SuscripcionValidator.validar() 5. JwtUtil.generarToken() 6. Retornar EscuelaLoginResponse con token + perfil

Flujo Alternativo A      A-1: Credenciales incorrectas -> HTTP 400 Bad Request

Flujo de Excepcion       E-1: Usuario inactivo -> 'Usuario inactivo' | E-2: Suscripcion vencida -> error suscripcion

Requerimientos           RF-MSC-01 (Autenticacion), RNF-Seguridad (JWT, BCrypt)

Prioridad                MUST

UC-002: Verificar Sesion Escuela

Campo                    Descripcion

ID                       UC-002

Nombre                   Verificar token de sesion de escuela

Actor Primario           Admin / Profesor / Tesoreria

Actores Secundarios      JwtUtil, Filtro JWT, BD MySQL

Precondicion             El usuario ya inicio sesion y posee JWT vigente

Postcondicion (exito)    Token validado y acceso a recursos protegidos

Postcondicion (fallo)    Acceso denegado por token invalido o expirado

Endpoint real            POST /auth/escuela/verify

Flujo Principal          1. Cliente envia token 2. Backend valida firma/claims 3. Se confirma identidad y permisos

Flujo Alternativo A      A-1: Token ausente o mal formado -> HTTP 401

Flujo de Excepcion       E-1: Token expirado o firma invalida -> HTTP 401

Requerimientos           RF-MSC-02 (Gestion de Sesion), RNF-Seguridad (JWT)

Prioridad                MUST

UC-003: Registrar SuperAdmin

Campo                    Descripcion

ID                       UC-003

Nombre                   Registrar cuenta SuperAdmin

Actor Primario           SuperAdmin

Actores Secundarios      AdminAuthService, BCryptPasswordEncoder, BD MySQL

Precondicion             Solicitante autorizado para alta de cuenta administrativa

Postcondicion (exito)    SuperAdmin persistido con contrasena cifrada

Postcondicion (fallo)    Registro rechazado por validacion o conflicto de datos

Endpoint real            POST /auth/admin/register

Flujo Principal          1. POST con datos de usuario 2. Validar payload 3. Cifrar contrasena 4. Guardar en BD 5. Retornar confirmacion

Flujo Alternativo A      A-1: Usuario ya existe -> HTTP 400/409

Flujo de Excepcion       E-1: Error de persistencia -> HTTP 500

Requerimientos           RF-MSC-03 (Alta de Administradores), RNF-Seguridad (BCrypt)

Prioridad                SHOULD

UC-004: Gestionar Usuarios

Campo                    Descripcion

ID                       UC-004

Nombre                   Administrar usuarios por institucion y sede

Actor Primario           SuperAdmin / Admin

Actores Secundarios      UsuariosController, UsuariosService, BD MySQL

Precondicion             Usuario autenticado con permisos de gestion de usuarios

Postcondicion (exito)    Usuarios creados, listados, actualizados o eliminados

Postcondicion (fallo)    Operacion cancelada por validacion o restricciones de negocio

Endpoint real            GET /restful/usuarios | GET /restful/usuarios/sede/{idSede} | GET /restful/usuarios/{id} | POST /restful/usuarios | PUT /restful/usuarios | DELETE /restful/usuarios/{id} | GET /restful/usuarios/{idUsuario}/modulos-permisos

Flujo Principal          1. Seleccionar operacion CRUD 2. Validar datos 3. Ejecutar servicio 4. Persistir cambios 5. Retornar resultado

Flujo Alternativo A      A-1: Usuario no encontrado -> HTTP 404

Flujo de Excepcion       E-1: Violacion de reglas de integridad -> HTTP 400

Requerimientos           RF-ADM-01 (Gestion de Usuarios)

Prioridad                MUST

UC-005: Gestionar Roles Y Permisos Por Modulo

Campo                    Descripcion

ID                       UC-005

Nombre                   Administrar roles y modulos asignados a roles

Actor Primario           SuperAdmin / Admin

Actores Secundarios      RolesController, ModulosController, BD MySQL

Precondicion             Usuario autenticado con permiso de administracion de roles

Postcondicion (exito)    Roles y permisos por modulo actualizados

Postcondicion (fallo)    Operacion rechazada por reglas de autorizacion o datos invalidos

Endpoint real            GET /restful/roles | GET /restful/roles/sede/{idSede} | GET /restful/roles/{id} | POST /restful/roles | PUT /restful/roles | DELETE /restful/roles/{id} | GET /restful/roles/{idRol}/modulos | POST /restful/roles/{idRol}/modulos | GET /restful/modulos | POST /restful/modulos | PUT /restful/modulos | GET /restful/modulos/{id} | DELETE /restful/modulos/{id}

Flujo Principal          1. Crear/editar rol 2. Consultar catalogo de modulos 3. Asignar modulos al rol 4. Guardar configuracion

Flujo Alternativo A      A-1: Rol inexistente -> HTTP 404

Flujo de Excepcion       E-1: Asignacion inconsistente de modulos -> HTTP 400

Requerimientos           RF-ADM-02 (RBAC por Modulos)

Prioridad                MUST

UC-006: Gestionar Sedes Y Limites Por Suscripcion

Campo                    Descripcion

ID                       UC-006

Nombre                   Administrar sedes y limites de sedes por suscripcion

Actor Primario           SuperAdmin

Actores Secundarios      SedesController, LimitesSedesSuscripcionController, BD MySQL

Precondicion             Existe institucion y suscripcion asociada

Postcondicion (exito)    Sedes y limites distribuidos (equitativos o personalizados)

Postcondicion (fallo)    No se aplican cambios por validaciones de cupos

Endpoint real            GET /restful/sedes | GET /restful/sedes/{id} | POST /restful/sedes | PUT /restful/sedes | DELETE /restful/sedes/{id} | GET /api/limites-sedes/suscripcion/{idSuscripcion} | GET /api/limites-sedes/{id} | PUT /api/limites-sedes/{id} | DELETE /api/limites-sedes/{id} | POST /api/limites-sedes/equitativa/{idSuscripcion} | POST /api/limites-sedes/personalizada/{idSuscripcion} | GET /api/limites-sedes/por-sede/{idSede}

Flujo Principal          1. Registrar/actualizar sede 2. Definir limites por suscripcion 3. Guardar distribucion 4. Consultar resultado

Flujo Alternativo A      A-1: Exceso de sedes permitidas -> HTTP 400

Flujo de Excepcion       E-1: Suscripcion inexistente -> HTTP 404

Requerimientos           RF-SUS-01 (Sedes por Plan)

Prioridad                MUST

UC-007: Gestionar Institucion

Campo                    Descripcion

ID                       UC-007

Nombre                   Administrar datos de institucion educativa

Actor Primario           SuperAdmin / Admin

Actores Secundarios      InstitucionController, BD MySQL

Precondicion             Usuario autenticado con permisos administrativos

Postcondicion (exito)    Institucion creada, consultada, actualizada o eliminada

Postcondicion (fallo)    Operacion denegada por validacion o dependencias

Endpoint real            GET /restful/institucion | GET /restful/institucion/{id} | POST /restful/institucion | PUT /restful/institucion | DELETE /restful/institucion/{id}

Flujo Principal          1. Ingresar datos institucionales 2. Validar 3. Persistir 4. Confirmar resultado

Flujo Alternativo A      A-1: Institucion no encontrada -> HTTP 404

Flujo de Excepcion       E-1: Error de integridad referencial -> HTTP 400

Requerimientos           RF-ORG-01 (Gestion Institucional)

Prioridad                MUST

UC-008: Gestionar Suscripciones

Campo                    Descripcion

ID                       UC-008

Nombre                   Administrar ciclo de vida de suscripciones

Actor Primario           SuperAdmin

Actores Secundarios      SuscripcionesController, SuscripcionesService, BD MySQL

Precondicion             Institucion existente y plan disponible

Postcondicion (exito)    Suscripcion creada/actualizada/cancelada y pagos generados

Postcondicion (fallo)    Operacion no aplicada por estado invalido o reglas de negocio

Endpoint real            GET /restful/suscripciones | GET /restful/suscripciones/{id} | GET /restful/suscripciones/por-institucion/{idInstitucion} | POST /restful/suscripciones | PUT /restful/suscripciones | DELETE /restful/suscripciones/{id} | PUT /restful/suscripciones/{id}/cancelar | POST /restful/suscripciones/generar-pagos-todas | POST /restful/suscripciones/{id}/generar-pagos

Flujo Principal          1. Crear o modificar suscripcion 2. Validar vigencia 3. Generar cronograma de pagos 4. Persistir estado

Flujo Alternativo A      A-1: Suscripcion no encontrada -> HTTP 404

Flujo de Excepcion       E-1: Cancelacion en estado no permitido -> HTTP 400

Requerimientos           RF-SUS-02 (Gestion de Suscripciones)

Prioridad                MUST

UC-009: Gestionar Catalogos De Suscripcion

Campo                    Descripcion

ID                       UC-009

Nombre                   Administrar planes, estados y ciclos de facturacion

Actor Primario           SuperAdmin

Actores Secundarios      PlanesController, EstadosSuscripcionController, CiclosFacturacionController

Precondicion             Usuario autenticado con permisos de configuracion

Postcondicion (exito)    Catalogos de suscripcion mantenidos en sistema

Postcondicion (fallo)    Cambios no aplicados por validaciones de negocio

Endpoint real            GET /restful/planes | GET /restful/planes/{id} | POST /restful/planes | PUT /restful/planes | DELETE /restful/planes/{id} | GET /restful/estadossuscripcion | GET /restful/estadossuscripcion/{id} | POST /restful/estadossuscripcion | PUT /restful/estadossuscripcion | DELETE /restful/estadossuscripcion/{id} | GET /restful/ciclosfacturacion | GET /restful/ciclosfacturacion/{id} | POST /restful/ciclosfacturacion | PUT /restful/ciclosfacturacion | DELETE /restful/ciclosfacturacion/{id}

Flujo Principal          1. Seleccionar catalogo 2. Ejecutar CRUD 3. Validar consistencia 4. Guardar

Flujo Alternativo A      A-1: Registro inexistente -> HTTP 404

Flujo de Excepcion       E-1: Catalogo en uso no eliminable -> HTTP 400

Requerimientos           RF-SUS-03 (Catalogos de Suscripcion)

Prioridad                SHOULD

UC-010: Gestionar Pagos De Suscripcion

Campo                    Descripcion

ID                       UC-010

Nombre                   Registrar, verificar y auditar pagos de suscripcion

Actor Primario           SuperAdmin / Tesoreria

Actores Secundarios      PagoSuscripcionController, almacenamiento de comprobantes, BD MySQL

Precondicion             Suscripcion activa con cuotas pendientes o en proceso

Postcondicion (exito)    Pago registrado/verificado/rechazado con evidencia documental

Postcondicion (fallo)    Pago no actualizado por validacion de estado o archivo

Endpoint real            GET /restful/pagos-suscripcion/{id} | DELETE /restful/pagos-suscripcion/{id} | POST /restful/pagos-suscripcion/registrar | PUT /restful/pagos-suscripcion/{id}/actualizar-comprobante | PUT /restful/pagos-suscripcion/{id}/verificar | PUT /restful/pagos-suscripcion/{id}/rechazar | GET /restful/pagos-suscripcion/suscripcion/{idSuscripcion} | GET /restful/pagos-suscripcion/pendientes | GET /restful/pagos-suscripcion/estado/{estado} | GET /restful/pagos-suscripcion/rango | GET /restful/pagos-suscripcion/comprobante/{filename} | GET /restful/pagos-suscripcion/comprobante/{filename}/descargar | GET /restful/pagos-suscripcion/estadisticas

Flujo Principal          1. Registrar pago con comprobante 2. Revisar en bandeja de pendientes 3. Verificar o rechazar 4. Consultar estadisticas

Flujo Alternativo A      A-1: Comprobante invalido/no adjunto -> HTTP 400

Flujo de Excepcion       E-1: Archivo no encontrado -> HTTP 404

Requerimientos           RF-SUS-04 (Cobranza de Suscripciones)

Prioridad                MUST

UC-011: Gestionar SuperAdmins

Campo                    Descripcion

ID                       UC-011

Nombre                   Administrar cuentas SuperAdmin

Actor Primario           SuperAdmin

Actores Secundarios      SuperAdminsController, BD MySQL

Precondicion             Usuario autenticado con privilegios globales

Postcondicion (exito)    SuperAdmins gestionados por CRUD

Postcondicion (fallo)    Operacion rechazada por reglas de seguridad

Endpoint real            GET /restful/superadmins | GET /restful/superadmins/{id} | POST /restful/superadmins | PUT /restful/superadmins | DELETE /restful/superadmins/{id}

Flujo Principal          1. Seleccionar operacion 2. Validar 3. Persistir 4. Confirmar

Flujo Alternativo A      A-1: SuperAdmin inexistente -> HTTP 404

Flujo de Excepcion       E-1: Restriccion de integridad -> HTTP 400

Requerimientos           RF-ADM-03 (Administradores Globales)

Prioridad                SHOULD

UC-012: Gestionar Estructura Temporal Academica

Campo                    Descripcion

ID                       UC-012

Nombre                   Administrar anio escolar y periodos

Actor Primario           Admin

Actores Secundarios      AnioEscolarController, PeriodosController, BD MySQL

Precondicion             Institucion y sede configuradas

Postcondicion (exito)    Calendario academico actualizado

Postcondicion (fallo)    Cambios rechazados por solapamientos o validaciones

Endpoint real            GET /restful/anioescolar | GET /restful/anioescolar/{id} | POST /restful/anioescolar | PUT /restful/anioescolar | DELETE /restful/anioescolar/{id} | GET /restful/periodos | GET /restful/periodos/{id} | POST /restful/periodos | PUT /restful/periodos | DELETE /restful/periodos/{id}

Flujo Principal          1. Crear anio escolar 2. Definir periodos 3. Guardar 4. Consultar configuracion

Flujo Alternativo A      A-1: Periodo duplicado -> HTTP 400

Flujo de Excepcion       E-1: Registros relacionados impiden eliminar -> HTTP 400

Requerimientos           RF-ACA-01 (Calendario Academico)

Prioridad                MUST

UC-013: Gestionar Estructura Fisica Escolar

Campo                    Descripcion

ID                       UC-013

Nombre                   Administrar grados, secciones y aulas

Actor Primario           Admin

Actores Secundarios      GradosController, SeccionesController, AulasController, BD MySQL

Precondicion             Sede existente

Postcondicion (exito)    Estructura fisica y organizativa disponible para matricula

Postcondicion (fallo)    Operacion no aplicada por inconsistencias de datos

Endpoint real            GET /restful/grados | GET /restful/grados/{id} | POST /restful/grados | PUT /restful/grados | DELETE /restful/grados/{id} | GET /restful/secciones | GET /restful/secciones/{id} | POST /restful/secciones | PUT /restful/secciones | DELETE /restful/secciones/{id} | GET /restful/aulas | GET /restful/aulas/{id} | POST /restful/aulas | PUT /restful/aulas | DELETE /restful/aulas/{id}

Flujo Principal          1. Configurar grados 2. Asociar secciones 3. Definir aulas 4. Persistir

Flujo Alternativo A      A-1: Recurso no encontrado -> HTTP 404

Flujo de Excepcion       E-1: Dependencia activa impide eliminacion -> HTTP 400

Requerimientos           RF-ACA-02 (Estructura Escolar)

Prioridad                MUST

UC-014: Gestionar Malla Curricular

Campo                    Descripcion

ID                       UC-014

Nombre                   Administrar areas, cursos, especialidades y malla curricular

Actor Primario           Admin / Coordinador Academico

Actores Secundarios      AreasController, CursosController, EspecialidadesController, MallaCurricularController

Precondicion             Grados/periodos disponibles

Postcondicion (exito)    Oferta academica estructurada por grado y periodo

Postcondicion (fallo)    No se guardan cambios por validaciones curriculares

Endpoint real            GET /restful/areas | POST /restful/areas | PUT /restful/areas | DELETE /restful/areas/{id} | GET /restful/cursos | POST /restful/cursos | PUT /restful/cursos | DELETE /restful/cursos/{id} | GET /restful/especialidades | GET /restful/especialidades/{id} | POST /restful/especialidades | PUT /restful/especialidades | DELETE /restful/especialidades/{id} | GET /restful/mallacurricular | GET /restful/mallacurricular/{id} | POST /restful/mallacurricular | PUT /restful/mallacurricular | DELETE /restful/mallacurricular/{id}

Flujo Principal          1. Crear catalogos academicos 2. Asignarlos a malla 3. Validar estructura 4. Guardar

Flujo Alternativo A      A-1: Curso o area inexistente -> HTTP 404

Flujo de Excepcion       E-1: Duplicidad de configuracion curricular -> HTTP 400

Requerimientos           RF-ACA-03 (Malla Curricular)

Prioridad                MUST

UC-015: Gestionar Evaluaciones Y Parametros De Nota

Campo                    Descripcion

ID                       UC-015

Nombre                   Administrar evaluaciones, tipos de evaluacion y tipos de nota

Actor Primario           Profesor / Coordinador Academico

Actores Secundarios      EvaluacionesController, TiposEvaluacionController, TiposNotaController

Precondicion             Curso y periodo activos

Postcondicion (exito)    Evaluaciones y reglas de calificacion registradas

Postcondicion (fallo)    Evaluacion no creada por validacion de parametros

Endpoint real            GET /restful/evaluaciones | GET /restful/evaluaciones/{id} | POST /restful/evaluaciones | PUT /restful/evaluaciones | DELETE /restful/evaluaciones/{id} | GET /restful/tiposevaluacion | GET /restful/tiposevaluacion/{id} | POST /restful/tiposevaluacion | PUT /restful/tiposevaluacion | DELETE /restful/tiposevaluacion/{id} | GET /restful/tiposnota | GET /restful/tiposnota/{id} | POST /restful/tiposnota | PUT /restful/tiposnota | DELETE /restful/tiposnota/{id}

Flujo Principal          1. Definir tipo de evaluacion 2. Definir escala/tipo de nota 3. Crear evaluacion 4. Publicar

Flujo Alternativo A      A-1: Datos incompletos -> HTTP 400

Flujo de Excepcion       E-1: Curso no habilitado -> HTTP 400

Requerimientos           RF-ACA-04 (Evaluaciones)

Prioridad                MUST

UC-016: Registrar Calificaciones Y Promedios

Campo                    Descripcion

ID                       UC-016

Nombre                   Registrar calificaciones y calcular promedios por periodo

Actor Primario           Profesor

Actores Secundarios      CalificacionesController, PromediosPeriodoController

Precondicion             Evaluaciones creadas y alumno matriculado

Postcondicion (exito)    Notas y promedios almacenados

Postcondicion (fallo)    Registro rechazado por reglas de rango o estado academico

Endpoint real            GET /restful/calificaciones | GET /restful/calificaciones/{id} | POST /restful/calificaciones | PUT /restful/calificaciones | DELETE /restful/calificaciones/{id} | GET /restful/promediosperiodo | GET /restful/promediosperiodo/{id} | POST /restful/promediosperiodo | PUT /restful/promediosperiodo | DELETE /restful/promediosperiodo/{id}

Flujo Principal          1. Ingresar notas por evaluacion 2. Validar escala 3. Calcular/guardar promedio 4. Confirmar

Flujo Alternativo A      A-1: Nota fuera de rango -> HTTP 400

Flujo de Excepcion       E-1: Alumno sin matricula activa -> HTTP 400

Requerimientos           RF-ACA-05 (Calificaciones y Promedios)

Prioridad                MUST

UC-017: Generar Reporte Academico

Campo                    Descripcion

ID                       UC-017

Nombre                   Consultar reporte academico consolidado

Actor Primario           Admin / Profesor / Apoderado (segun permisos)

Actores Secundarios      ReporteAcademicoController, ReporteAcademicoService

Precondicion             Existen datos de evaluaciones y calificaciones

Postcondicion (exito)    Reporte academico disponible para consulta

Postcondicion (fallo)    No se obtiene reporte por ausencia de datos o error de filtro

Endpoint real            GET /restful/reportes/academico

Flujo Principal          1. Solicitar reporte con criterios 2. Consultar datos agregados 3. Retornar reporte

Flujo Alternativo A      A-1: Sin resultados -> respuesta vacia/HTTP 200

Flujo de Excepcion       E-1: Parametros invalidos -> HTTP 400

Requerimientos           RF-REP-01 (Reportes Academicos)

Prioridad                SHOULD

UC-018: Gestionar Alumnos

Campo                    Descripcion

ID                       UC-018

Nombre                   Administrar ficha de alumnos

Actor Primario           Admin / Secretaria

Actores Secundarios      AlumnosController, BD MySQL

Precondicion             Sede y estructura academica configuradas

Postcondicion (exito)    Alumno creado, actualizado, consultado o eliminado

Postcondicion (fallo)    Operacion no aplicada por validaciones de identidad/estado

Endpoint real            GET /restful/alumnos | GET /restful/alumnos/{id} | POST /restful/alumnos | PUT /restful/alumnos | DELETE /restful/alumnos/{id}

Flujo Principal          1. Registrar/editar datos del alumno 2. Validar 3. Guardar 4. Confirmar

Flujo Alternativo A      A-1: Alumno no encontrado -> HTTP 404

Flujo de Excepcion       E-1: Documento duplicado -> HTTP 400

Requerimientos           RF-ALU-01 (Gestion de Alumnos)

Prioridad                MUST

UC-019: Gestionar Apoderados Y Vinculos Con Alumnos

Campo                    Descripcion

ID                       UC-019

Nombre                   Administrar apoderados y relacion alumno-apoderado

Actor Primario           Admin / Secretaria

Actores Secundarios      ApoderadosController, AlumnoApoderadoController

Precondicion             Alumno existente

Postcondicion (exito)    Apoderado registrado y vinculado a alumno

Postcondicion (fallo)    Vinculacion rechazada por inconsistencia de datos

Endpoint real            GET /restful/apoderados | GET /restful/apoderados/{id} | POST /restful/apoderados | PUT /restful/apoderados | DELETE /restful/apoderados/{id} | GET /restful/alumnoapoderado | GET /restful/alumnoapoderado/{id} | POST /restful/alumnoapoderado | PUT /restful/alumnoapoderado | DELETE /restful/alumnoapoderado/{id}

Flujo Principal          1. Registrar apoderado 2. Crear relacion con alumno 3. Guardar 4. Consultar relacion

Flujo Alternativo A      A-1: Alumno o apoderado inexistente -> HTTP 404

Flujo de Excepcion       E-1: Relacion duplicada -> HTTP 400

Requerimientos           RF-ALU-02 (Apoderados)

Prioridad                MUST

UC-020: Gestionar Matriculas

Campo                    Descripcion

ID                       UC-020

Nombre                   Registrar matriculas y confirmar pago

Actor Primario           Admin / Tesoreria

Actores Secundarios      MatriculasController, BD MySQL

Precondicion             Alumno activo y cupo disponible

Postcondicion (exito)    Matricula creada y estado de pago actualizado

Postcondicion (fallo)    Matricula no registrada por falta de vacantes o validaciones

Endpoint real            GET /restful/matriculas | GET /restful/matriculas/{id} | POST /restful/matriculas | PUT /restful/matriculas | DELETE /restful/matriculas/{id} | PUT /restful/matriculas/{id}/confirmar-pago | GET /restful/matriculas/vacantes-disponibles

Flujo Principal          1. Verificar vacantes 2. Registrar matricula 3. Confirmar pago 4. Actualizar estado

Flujo Alternativo A      A-1: Sin vacantes -> HTTP 400

Flujo de Excepcion       E-1: Matricula no encontrada -> HTTP 404

Requerimientos           RF-MAT-01 (Matriculas)

Prioridad                MUST

UC-021: Gestionar Asistencias

Campo                    Descripcion

ID                       UC-021

Nombre                   Registrar y consultar asistencia de alumnos

Actor Primario           Profesor

Actores Secundarios      AsistenciasController, BD MySQL

Precondicion             Matricula activa y horario vigente

Postcondicion (exito)    Asistencia registrada y disponible para consulta

Postcondicion (fallo)    Registro no aplicado por validaciones

Endpoint real            GET /restful/asistencias | GET /restful/asistencias/{id} | POST /restful/asistencias | PUT /restful/asistencias | DELETE /restful/asistencias/{id}

Flujo Principal          1. Seleccionar seccion/fecha 2. Registrar estado de asistencia 3. Guardar 4. Consultar historico

Flujo Alternativo A      A-1: Registro inexistente -> HTTP 404

Flujo de Excepcion       E-1: Duplicidad de asistencia del dia -> HTTP 400

Requerimientos           RF-ACA-06 (Asistencias)

Prioridad                MUST

UC-022: Gestionar Horarios

Campo                    Descripcion

ID                       UC-022

Nombre                   Configurar horarios academicos

Actor Primario           Admin / Coordinador Academico

Actores Secundarios      HorariosController, BD MySQL

Precondicion             Grado, seccion, aula y docentes disponibles

Postcondicion (exito)    Horario publicado para operacion academica

Postcondicion (fallo)    Horario rechazado por conflicto de franjas

Endpoint real            GET /restful/horarios | GET /restful/horarios/{id} | POST /restful/horarios | PUT /restful/horarios | DELETE /restful/horarios/{id}

Flujo Principal          1. Definir bloques horarios 2. Asignar recursos 3. Validar conflictos 4. Guardar

Flujo Alternativo A      A-1: Horario no encontrado -> HTTP 404

Flujo de Excepcion       E-1: Cruce horario docente/aula -> HTTP 400

Requerimientos           RF-ACA-07 (Horarios)

Prioridad                SHOULD

UC-023: Gestionar Docentes

Campo                    Descripcion

ID                       UC-023

Nombre                   Administrar perfil docente y asignacion docente

Actor Primario           Admin / Coordinador Academico

Actores Secundarios      PerfilDocenteController, AsignacionDocenteController

Precondicion             Usuario docente existente en sistema

Postcondicion (exito)    Perfil docente y asignaciones academicas registradas

Postcondicion (fallo)    No se asigna por inconsistencias de carga academica

Endpoint real            GET /restful/perfildocente | GET /restful/perfildocente/{id} | POST /restful/perfildocente | PUT /restful/perfildocente | DELETE /restful/perfildocente/{id} | GET /restful/asignaciondocente | GET /restful/asignaciondocente/{id} | POST /restful/asignaciondocente | PUT /restful/asignaciondocente | DELETE /restful/asignaciondocente/{id}

Flujo Principal          1. Completar perfil docente 2. Asignar cursos/secciones 3. Validar disponibilidad 4. Guardar

Flujo Alternativo A      A-1: Docente no encontrado -> HTTP 404

Flujo de Excepcion       E-1: Doble asignacion incompatible -> HTTP 400

Requerimientos           RF-DOC-01 (Gestion Docente)

Prioridad                SHOULD

UC-024: Gestionar Registros Operativos

Campo                    Descripcion

ID                       UC-024

Nombre                   Administrar registros y generar token de soporte

Actor Primario           SuperAdmin / Admin

Actores Secundarios      RegistrosController

Precondicion             Usuario autenticado

Postcondicion (exito)    Registros operativos mantenidos y token generado cuando aplica

Postcondicion (fallo)    Operacion no ejecutada por validacion

Endpoint real            GET /restful/registros | GET /restful/registros/{id} | POST /restful/registros | PUT /restful/registros | DELETE /restful/registros/{id} | POST /restful/token

Flujo Principal          1. Ejecutar operacion sobre registros 2. Persistir 3. Opcional: generar token tecnico

Flujo Alternativo A      A-1: Registro inexistente -> HTTP 404

Flujo de Excepcion       E-1: Error interno al emitir token -> HTTP 500

Requerimientos           RF-OPS-01 (Registros y Trazabilidad)

Prioridad                SHOULD

UC-025: Gestionar Configuracion De Pagos

Campo                    Descripcion

ID                       UC-025

Nombre                   Administrar conceptos y metodos de pago

Actor Primario           Tesoreria / Admin

Actores Secundarios      ConceptosPagoController, MetodosPagoController

Precondicion             Usuario con permisos de tesoreria

Postcondicion (exito)    Catalogo de conceptos y metodos actualizado

Postcondicion (fallo)    Cambios no aplicados por validacion o dependencia

Endpoint real            GET /restful/conceptospago | GET /restful/conceptospago/{id} | POST /restful/conceptospago | PUT /restful/conceptospago | DELETE /restful/conceptospago/{id} | GET /restful/metodospago | GET /restful/metodospago/{id} | POST /restful/metodospago | PUT /restful/metodospago | DELETE /restful/metodospago/{id}

Flujo Principal          1. Definir conceptos de cobro 2. Definir metodos de pago 3. Guardar catalogos

Flujo Alternativo A      A-1: Registro inexistente -> HTTP 404

Flujo de Excepcion       E-1: Concepto en uso no eliminable -> HTTP 400

Requerimientos           RF-PAG-01 (Configuracion de Cobros)

Prioridad                SHOULD

UC-026: Gestionar Deudas Del Alumno

Campo                    Descripcion

ID                       UC-026

Nombre                   Registrar y consultar deudas de alumnos

Actor Primario           Tesoreria

Actores Secundarios      DeudasAlumnoController, BD MySQL

Precondicion             Alumno con matricula asociada

Postcondicion (exito)    Deuda creada/actualizada y visible en consulta

Postcondicion (fallo)    Operacion rechazada por validaciones de estado

Endpoint real            GET /restful/deudasalumno | GET /restful/deudasalumno/{id} | POST /restful/deudasalumno | PUT /restful/deudasalumno | DELETE /restful/deudasalumno/{id}

Flujo Principal          1. Registrar deuda 2. Actualizar estado 3. Consultar cartera

Flujo Alternativo A      A-1: Deuda no encontrada -> HTTP 404

Flujo de Excepcion       E-1: Monto o datos invalidos -> HTTP 400

Requerimientos           RF-PAG-02 (Cuentas por Cobrar)

Prioridad                MUST

UC-027: Gestionar Caja Y Detalle De Pago

Campo                    Descripcion

ID                       UC-027

Nombre                   Registrar pagos en caja y detalle de operaciones

Actor Primario           Tesoreria

Actores Secundarios      PagosCajaController, PagoDetalleController

Precondicion             Existen deudas o conceptos de pago aplicables

Postcondicion (exito)    Pagos de caja y sus detalles quedan registrados

Postcondicion (fallo)    Pago no procesado por validacion

Endpoint real            GET /restful/pagoscaja | GET /restful/pagoscaja/{id} | POST /restful/pagoscaja | PUT /restful/pagoscaja | DELETE /restful/pagoscaja/{id} | GET /restful/pagodetalle | GET /restful/pagodetalle/{id} | POST /restful/pagodetalle | PUT /restful/pagodetalle | DELETE /restful/pagodetalle/{id}

Flujo Principal          1. Registrar pago de caja 2. Registrar detalle de conceptos 3. Guardar

Flujo Alternativo A      A-1: Pago no encontrado -> HTTP 404

Flujo de Excepcion       E-1: Inconsistencia entre cabecera y detalle -> HTTP 400

Requerimientos           RF-PAG-03 (Caja)

Prioridad                MUST

UC-028: Gestionar Movimientos De Alumno

Campo                    Descripcion

ID                       UC-028

Nombre                   Registrar, aprobar o rechazar movimientos del alumno

Actor Primario           Admin / Tesoreria / Secretaria

Actores Secundarios      MovimientosAlumnoController

Precondicion             Alumno y matricula existentes

Postcondicion (exito)    Movimiento almacenado y estado actualizado (pendiente/aprobado/rechazado)

Postcondicion (fallo)    Movimiento no procesado por reglas de negocio

Endpoint real            GET /restful/movimientos-alumno | GET /restful/movimientos-alumno/{id} | GET /restful/movimientos-alumno/matricula/{idMatricula} | GET /restful/movimientos-alumno/alumno/{idAlumno} | GET /restful/movimientos-alumno/pendientes | GET /restful/movimientos-alumno/tipo/{tipo} | POST /restful/movimientos-alumno | PUT /restful/movimientos-alumno/{id}/aprobar | PUT /restful/movimientos-alumno/{id}/rechazar | PUT /restful/movimientos-alumno/{id} | DELETE /restful/movimientos-alumno/{id}

Flujo Principal          1. Registrar movimiento 2. Revisar pendientes 3. Aprobar/rechazar 4. Actualizar historial

Flujo Alternativo A      A-1: Movimiento inexistente -> HTTP 404

Flujo de Excepcion       E-1: Transicion de estado no permitida -> HTTP 400

Requerimientos           RF-ALU-03 (Movimientos Administrativos)

Prioridad                SHOULD

UC-029: Gestionar Documentacion Del Alumno

Campo                    Descripcion

ID                       UC-029

Nombre                   Administrar tipos de documento, requisitos y documentos de alumno

Actor Primario           Admin / Secretaria

Actores Secundarios      TipoDocumentosController, RequisitosDocumentosController, DocumentosAlumnoController

Precondicion             Alumno registrado y reglas documentarias definidas

Postcondicion (exito)    Expediente documentario actualizado

Postcondicion (fallo)    Documento no registrado por validacion

Endpoint real            GET /restful/tipodocumentos | GET /restful/tipodocumentos/{id} | POST /restful/tipodocumentos | PUT /restful/tipodocumentos | DELETE /restful/tipodocumentos/{id} | GET /restful/requisitosdocumentos | GET /restful/requisitosdocumentos/{id} | POST /restful/requisitosdocumentos | PUT /restful/requisitosdocumentos | DELETE /restful/requisitosdocumentos/{id} | GET /restful/documentosalumno | GET /restful/documentosalumno/{id} | POST /restful/documentosalumno | PUT /restful/documentosalumno | DELETE /restful/documentosalumno/{id}

Flujo Principal          1. Configurar requisitos 2. Registrar documentos presentados 3. Consultar estado de expediente

Flujo Alternativo A      A-1: Requisito inexistente -> HTTP 404

Flujo de Excepcion       E-1: Archivo/documento invalido -> HTTP 400

Requerimientos           RF-DOC-01 (Expediente del Alumno)

Prioridad                SHOULD

UC-030: Cargar Archivos

Campo                    Descripcion

ID                       UC-030

Nombre                   Subir archivos generales, documentos y avatares

Actor Primario           Admin / Secretaria / Usuario autenticado

Actores Secundarios      FileUploadController, almacenamiento de archivos

Precondicion             Usuario autenticado y archivo dentro de limites permitidos

Postcondicion (exito)    Archivo almacenado y ruta disponible para consumo

Postcondicion (fallo)    Carga rechazada por tipo/tamano/permisos

Endpoint real            POST /restful/files/upload | POST /restful/files/upload/document | POST /restful/files/upload/avatar

Flujo Principal          1. Seleccionar archivo 2. Enviar multipart/form-data 3. Validar 4. Guardar 5. Retornar URL/ruta

Flujo Alternativo A      A-1: Tipo de archivo no permitido -> HTTP 400

Flujo de Excepcion       E-1: Error de escritura en almacenamiento -> HTTP 500

Requerimientos           RF-DOC-02 (Gestion de Archivos)

Prioridad                SHOULD

UC-031: Consultar Identidad En RENIEC

Campo                    Descripcion

ID                       UC-031

Nombre                   Consultar datos por DNI en servicio RENIEC

Actor Primario           Admin / Secretaria

Actores Secundarios      ReniecController, proveedor externo RENIEC

Precondicion             DNI valido y servicio externo disponible

Postcondicion (exito)    Datos de identidad recuperados para apoyo al registro

Postcondicion (fallo)    No se retorna informacion por DNI invalido o servicio no disponible

Endpoint real            GET /api/reniec/dni/{dni}

Flujo Principal          1. Ingresar DNI 2. Backend consulta RENIEC 3. Retornar datos al cliente

Flujo Alternativo A      A-1: DNI no encontrado -> respuesta sin datos/HTTP 404 segun implementacion

Flujo de Excepcion       E-1: Timeout o error de proveedor externo -> HTTP 502/500

Requerimientos           RF-INT-01 (Integracion RENIEC)

Prioridad                COULD

UC-032: Generar Hash De Password

Campo                    Descripcion

ID                       UC-032

Nombre                   Generar hash utilitario para contrasenas

Actor Primario           Desarrollador / Administrador tecnico

Actores Secundarios      UtilsController, BCrypt

Precondicion             Acceso al endpoint utilitario en entorno permitido

Postcondicion (exito)    Hash generado para uso tecnico

Postcondicion (fallo)    No se genera hash por entrada invalida

Endpoint real            POST /utils/generate-hash

Flujo Principal          1. Enviar texto plano 2. Generar hash BCrypt 3. Retornar hash

Flujo Alternativo A      A-1: Entrada vacia -> HTTP 400

Flujo de Excepcion       E-1: Error interno de libreria -> HTTP 500

Requerimientos           RF-TEC-01 (Utilitarios de Seguridad)

Prioridad                COULD

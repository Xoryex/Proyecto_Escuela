SET FOREIGN_KEY_CHECKS = 0;

-- metodos_pago
INSERT INTO `metodos_pago` (`id_metodo`, `nombre_metodo`, `requiere_comprobante`, `estado`) VALUES
(1, 'Efectivo', 0, 1),
(2, 'Yape', 1, 1),
(3, 'Plin', 1, 1),
(4, 'Transferencia Bancaria', 1, 1),
(5, 'Tarjeta de Crédito / Débito', 1, 1);

-- tipo_documentos
INSERT INTO `tipo_documentos` (`id_documento`, `abreviatura`, `descripcion`, `longitud_maxima`, `es_longitud_exacta`, `estado`) VALUES
(1, 'DNI', 'Documento de indentidad', 8, 1, 1),
(2, 'CE', 'Carné Extranjería', 9, 1, 1),
(3, 'PAS', 'Pasaporte', 15, 0, 1),
(4, 'DNIE', 'Documento de indentidad Electronica', 9, 1, 1);

-- ciclos_facturacion
INSERT INTO `ciclos_facturacion` (`id_ciclo`, `nombre`, `meses_duracion`, `estado`) VALUES
(1, 'Mensual', 1, 1),
(2, 'Anual', 12, 1);

-- planes
INSERT INTO `planes` (`id_plan`, `nombre_plan`, `descripcion`, `precio_mensual`, `precio_anual`, `limite_alumnos`, `limite_sedes`, `estado`) VALUES
(1, 'Plan Emprendedor (Primaria Pequeña)', '', 150, 1500, 600, 1, 1),
(2, 'Plan Profesional (Primaria Multisede)', '', 350, 3500, 2400, 3, 1),
(3, 'Plan Personalizado (A Medida)', NULL, 0, 0, NULL, NULL, 1);

-- especialidades
INSERT INTO `especialidades` (`id_especialidad`, `nombre_especialidad`, `descripcion`, `estado`) VALUES
(1, 'Educación Primaria', NULL, 1),
(2, 'Educación Física', NULL, 1),
(3, 'Inglés', NULL, 1),
(4, 'Computación e Informática', NULL, 1),
(5, 'Arte y Cultura', NULL, 1),
(6, 'Matematicas', '', 1),
(7, 'Comunicación', '', 1);

-- roles
INSERT INTO `roles` (`id_rol`, `nombre`, `estado`) VALUES
(1, 'ADMINISTRADOR', 1),
(2, 'PROFESOR', 1),
(3, 'SECRETARIA', 1),
(10, 'COORDINADOR', 1);

-- modulos
INSERT INTO `modulos` (`id_modulo`, `nombre`, `descripcion`, `icono`, `orden`, `url_base`, `estado`) VALUES
(1, 'DASHBOARD', 'Panel principal del sistema', 'BarChart3', 0, '/dashboard', 1),
(2, 'CONFIGURACIÓN', 'Ajustes y configuración de la institución', 'Settings', 1, '/configuracion', 1),
(3, 'INFRAESTRUCTURA', 'Gestión de aulas, grados, secciones', 'Building2', 2, '/infraestructura', 1),
(4, 'GESTIÓN ACADÉMICA', 'Cursos, áreas, horarios y malla curricular', 'BookOpen', 3, '/gestioacademica', 1),
(5, 'ALUMNOS', 'Gestión completa de estudiantes', 'Users', 4, '/alumnos', 1),
(6, 'MATRÍCULAS', 'Proceso de inscripción y matrícula', 'FileText', 5, '/matriculas', 1),
(7, 'EVALUACIONES Y NOTAS', 'Registro de calificaciones y evaluaciones', 'CheckCircle', 6, '/evaluacionesynotas', 1),
(8, 'PAGOS Y PENSIONES', 'Gestión de ingresos y pensiones', 'DollarSign', 7, '/pagosypensiones', 1),
(9, 'ASISTENTE IA', 'Asistente de inteligencia artificial para consultas', 'Bot', 8, '/chatbot', 1);

-- registros
INSERT INTO `registros` (`idregistro`, `nombres`, `apellidos`, `email`, `cliente_id`, `llave_secreta`, `access_token`, `estado`) VALUES
(77, 'Oicapse', 'Raletse', 'cristina.berru2909@gmail.com', 'a3f6dce08f697343638e24738b8fea591c4b7f7bf691750dde801f658cc0777a', '$2a$10$wtrV3DRrgOf0SlsgeEjsTuZzfnNVeFe5pewRh55QVogjRjulEAP/2', 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhM2Y2ZGNlMDhmNjk3MzQzNjM4ZTI0NzM4YjhmZWE1OTFjNGI3ZjdiZjY5MTc1MGRkZTgwMWY2NThjYzA3NzdhIiwiaWF0IjoxNzczMDg5NTA0LCJleHAiOjQ5MjY2ODk1MDR9.o03QAAGm5Itir4n7N0BEdpfnAPtEnPUiCFfB5k8I-P4', 1),
(78, 'bebesita', 'owo', 'bebesitaowo@gmail.com', 'f9d565878eeb7078c3a6df8c965e82a21e9a6cb1fee79af4062a1518e957a8d8', '$2a$10$dO3nDcLx5zBrs0O2JqDWM.RaBljMvMBjYStJbfv4ROc5FOHWFc3ae', 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJmOWQ1NjU4NzhlZWI3MDc4YzNhNmRmOGM5NjVlODJhMjFlOWE2Y2IxZmVlNzlhZjQwNjJhMTUxOGU5NTdhOGQ4IiwiaWF0IjoxNzczMDkwMTQ3LCJleHAiOjQ5MjY2OTAxNDd9.ay5KiTmDQGoLXNYQJNI_30lsVymomdNvNpcyPZeRX_o', 1),
(79, 'Luis Alberto', 'Yajahuanca Fernandez', 'luisalbertoyajahuancafernandez@gmail.com', 'd74efe61db9f9e134ed4aeae861a450cc3d1cf7e3b3da95d45d23d14149c04ae', '$2a$10$.OcrBGAPKBwHoqGScOHVZOZUf7xWqqkNotUZBjkGZzQTFLcIkmZOm', 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkNzRlZmU2MWRiOWY5ZTEzNGVkNGFlYWU4NjFhNDUwY2MzZDFjZjdlM2IzZGE5NWQ0NWQyM2QxNDE0OWMwNGFlIiwiaWF0IjoxNzczMTE2NzMyLCJleHAiOjQ5MjY3MTY3MzJ9.mbqznFBhhfs4Bpu4L3az2ENsPqTgSUDgtwb3XY5XlOA', 1),
(80, 'Luis Alberto', 'Yajahuanca Fernandez', 'luisalbertoyajahuancafernandez@gmail.com', 'd74efe61db9f9e134ed4aeae861a450cc3d1cf7e3b3da95d45d23d14149c04ae', '$2a$10$jpcqHMkHdS1cMZASefXTf.XaN0a/rpbtgZKsoDZzKh9LwSXZV2VrO', '', 1),
(81, 'Luis ', 'Yajahuanca', 'luajahuancafernandez@gmail.com', 'b881f274333107752599aad1e9d4cad154e465a7a67e84593595e25b0222a557', '$2a$10$isKL.4DyAwjWhi2Xj4K2GOh.abWOPa9PRaWNGVUDzoEwU/x3fe8uS', 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJiODgxZjI3NDMzMzEwNzc1MjU5OWFhZDFlOWQ0Y2FkMTU0ZTQ2NWE3YTY3ZTg0NTkzNTk1ZTI1YjAyMjJhNTU3IiwiaWF0IjoxNzczMTE2NzcyLCJleHAiOjQ5MjY3MTY3NzJ9.MkHGdSxmLVpWNE4DdjJ6zB1QJgXDU6xgEsKhnAdMr0o', 1),
(82, 'Samuel', 'chois', 'choisue@gmail.com', '675294c92564e474de5d13712337f9710576f8aed249c3c784f1434367433411', '$2a$10$tvv/YglHbIOAK0vVims2VevgrCwxSMoR1pRdCLRv5h1/2KHRdIomu', 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI2NzUyOTRjOTI1NjRlNDc0ZGU1ZDEzNzEyMzM3Zjk3MTA1NzZmOGFlZDI0OWMzYzc4NGYxNDM0MzY3NDMzNDExIiwiaWF0IjoxNzczMTE2OTU3LCJleHAiOjQ5MjY3MTY5NTd9.PivjjOzyXaIahyBkFqy_o46FBvQbhar8XmghdyrOgFA', 1);

-- requisitos_documentos
INSERT INTO `requisitos_documentos` (`id_requisito`, `nombre_documento`, `descripcion`, `es_obligatorio`, `estado`) VALUES
(1, 'DNI del Alumno', 'Copia legible de ambas caras (DNI azul o electrónico)', 1, 1),
(2, 'DNI del Apoderado', 'Copia legible del padre, madre o tutor legal', 1, 1),
(3, 'Certificado de Estudios', 'Documento original del año de procedencia', 1, 1),
(4, 'Constancia de Matrícula SIAGIE OFICIAL', 'Documento oficial generado por el portal SIAGIE', 0, 1),
(5, 'Ficha Médica / Certificado de Salud', 'Estado de salud actual del estudiante', 0, 1),
(6, 'Fotos Tamaño Carné', '4 fotos con fondo blanco', 0, 1),
(7, 'Constancia de BECADO SUNEDU OFICIAL', 'Documento oficial generado por SUNEDU', 0, 1);

-- tipos_evaluacion
INSERT INTO `tipos_evaluacion` (`id_tipo_evaluacion`, `nombre`, `estado`) VALUES
(1, 'Examen Bimestral', 1),
(2, 'Examen Mensual', 1),
(3, 'Revisión de Cuaderno', 1),
(4, 'Tarea para la casa, laboratorio', 1),
(5, 'Exposición / Proyecto', 1),
(6, 'Tabla de multipplicacion, examen oral', 1);

-- tipos_nota
INSERT INTO `tipos_nota` (`id_tipo_nota`, `nombre`, `formato`, `valor_minimo`, `valor_maximo`, `estado`) VALUES
(1, 'Vigesimal Peruano', 'NUMERO', '0', '20', 1),
(2, 'Literal MINEDU', 'LETRA', 'C', 'AD', 1),
(3, 'Estrellas Infantiles', 'SIMBOLO', '1', '5', 1),
(4, 'Lunas', 'SIMBOLO', '1', '5', 1);

-- rol_modulo
INSERT INTO `rol_modulo` (`id_rol_modulo`, `id_rol`, `id_modulo`, `estado`) VALUES
(14, 10, 3, 1),
(32, 1, 1, 1),
(33, 1, 2, 1),
(34, 1, 3, 1),
(35, 1, 4, 1),
(36, 1, 5, 1),
(37, 1, 6, 1),
(38, 1, 7, 1),
(39, 1, 8, 1),
(56, 3, 5, 1),
(57, 2, 7, 1),
(58, 1, 9, 1);

-- institucion
INSERT INTO `institucion` (`id_institucion`, `nombre`, `cod_modular`, `tipo_gestion`, `resolucion_creacion`, `nombre_director`, `logo_path`, `correo_facturacion`, `domicilio_fiscal`, `razon_social`, `representante_legal`, `ruc`, `telefono_facturacion`, `estado`) VALUES
(33, 'Institución Educativa Dionicio Ocampo Chavez', '7686879', 'Pública', 'R.D. N° 1234-2024-DRELM', NULL, '/uploads/logos/3171a328-7cdf-4caa-94fe-451e8548cc96.webp', 'la.yajahuanca@unsm.edu.pe', 'Jr. Amargura 321', 'Institución Educativa Dionicio Ocampo Chavez', 'Luis Alberto Yajahuanca Fernandez', '10768687931', '963864860', 1),
(34, 'Institución Educativa Juan Jimenez Pimentel', '0001128', 'Pública', 'R.G.R. N° 9822-1992-GRE-SANMARTIN', NULL, '/uploads/logos/77d96b51-82f6-4c78-a935-9c2c8b8cc873.png', 'juanjimenezpimentel@gmail.com', 'JIRÓN ORELLANA CUADRA 3', 'Institución Educativa Juan Jimenez Pimentel', 'Cristina Berrú Lozano', '10768687912', '960562285', 1),
(35, 'Institución Educativa Santa Rosa 0199', '1230567', 'Pública', 'R.G.R. N° 5678-2005-GRE-BELLAVISTA', NULL, '/uploads/logos/92e0b8f7-6417-4477-8da5-1dd544f7877c.jpeg', 'santarosa@gmail.com', 'Jr. Yurimaguas 123', 'Institución Educativa Santa Rosa', 'Nayelli Yuley Arevalo Romero', '12345678910', '930033324', 1),
(36, 'Institución Educativa San Jose del Alto Mayo', '0246711', 'Pública', 'R.D.R. N° 013456-1991-DRE-NARANJILLO', NULL, '/uploads/logos/1926e255-6dab-43f7-8324-e68e7a9f57ec.jpeg', 'altomayo@gmail.com', 'Jr. Naranjillo 901', 'Institución Educativa San Jose del Alto Mayo', 'Judith Marianella Contreras Bernilla', '28111283911', '981783661', 1),
(37, 'Annie Soper Christian School', '0912811', 'Privada', 'R.D.R. N° 123056-2001-DRE-MOYOBAMBA', NULL, '/uploads/logos/7cf7090b-e30d-41a7-a204-c91bac023c6f.jpeg', 'anniecoper@gmail.com', 'Jr. Alonso de Albarado - Cdra. 1', 'Annie Soper Christian School', 'Martin Muñoz Mozombite', '90118271111', '900128883', 1);

-- estados_suscripcion
INSERT INTO `estados_suscripcion` (`id_estado`, `nombre`, `estado`) VALUES
(1, 'Activa', 1),
(2, 'Vencida', 1),
(3, 'Suspendida', 1),
(4, 'Cancelada', 1),
(5, 'Pendiente', 1);

-- suscripciones
INSERT INTO `suscripciones` (`id_suscripcion`, `id_institucion`, `id_plan`, `id_ciclo`, `id_estado`, `limite_alumnos_contratado`, `limite_sedes_contratadas`, `precio_acordado`, `fecha_inicio`, `fecha_vencimiento`, `estado`, `tipo_distribucion_limite`) VALUES
(30, 33, 3, 1, 1, 5, 1, 10.00, '2026-03-07', '2028-12-31', 1, 'EQUITATIVA'),
(31, 35, 3, 2, 1, 10, 1, 100.00, '2026-01-01', '2028-12-31', 1, 'EQUITATIVA'),
(32, 36, 3, 1, 1, 10, 1, 15.00, '2026-03-01', '2028-12-31', 1, 'EQUITATIVA'),
(33, 37, 3, 1, 1, 10, 2, 120.00, '2026-03-07', '2028-12-31', 1, 'EQUITATIVA'),
(34, 34, 3, 1, 1, 10, 2, 190.00, '2026-03-01', '2028-12-31', 1, 'EQUITATIVA');

-- sedes
INSERT INTO `sedes` (`id_sede`, `id_institucion`, `nombre_sede`, `direccion`, `distrito`, `provincia`, `departamento`, `ugel`, `telefono`, `correo_institucional`, `estado`, `codigo_establecimiento`, `es_sede_principal`) VALUES
(16, 33, 'Sede Luis', 'jr.amargura', 'Yantalo', 'Moyobamba', 'San Martin', 'UGEL 01', '963864860', 'sede@yantalo.com', 1, '0000', b'1'),
(17, 35, 'Sede Nayelli', 'Jr. Centro Poblado de Bellavista 211', 'Bellavista', 'Bellavista', 'San Martin', 'UGEL SAN MARTIN', '921672345', 'santarosa@gmail.com', 1, '0000', b'1'),
(18, 36, 'Sede Judith', 'Centro Poblado Naranjillo', 'Nueva Cajamarca', 'Rioja', 'San Martin', 'UGEL SAN MARTIN', '911021145', 'sedejudith@gmail.com', 1, '0000', b'1'),
(19, 37, 'Sede Martin', 'Jiron Alonso de Alvarado C1', 'Moyobamba', 'Moyobamba', 'San Martin', 'UGEL MOYOBAMBA', '912761388', 'sedemartin@gmail.com', 1, '0000', b'1'),
(20, 34, 'Sede Cristina', 'Jr. 9 de abril 331', 'Tarapoto', 'Tarapoto', 'San Martin', 'UGEL SAN MARTIN', '960562285', 'sedecristina@gmail.com', 1, '0000', b'1');

-- super_admins
INSERT INTO `super_admins` (`id_admin`, `nombres`, `apellidos`, `correo`, `usuario`, `password`, `rol_plataforma`, `estado`, `foto_url`) VALUES
(1, 'superadmin', 'administrador', 'superadmin@gmail.co,', 'superadmin', '$2a$10$Yd7y60O2ZOxCPmVEowmyZOvUubHoyMYqSnDqhhcMsJBsIwBsypa8i', 'SUPER_ADMIN', 1, '/uploads/perfiles/f932e7ee-086e-4005-88d3-8d612c8458e7.jpeg');

-- aulas
INSERT INTO `aulas` (`id_aula`, `id_sede`, `nombre_aula`, `capacidad`, `estado`) VALUES
(16, 18, 'UNICA', 20, 1),
(17, 18, 'NO UNICA', 20, 1),
(18, 17, 'Aula 101', 30, 0),
(19, 17, 'Aula 101', 30, 1),
(20, 17, 'Laboratorio 01', 30, 1),
(21, 20, 'Aula 01', 30, 1);

-- areas
INSERT INTO `areas` (`id_area`, `nombre_area`, `descripcion`, `estado`) VALUES
(4, 'MATEMATICA', '', 1),
(5, 'COMUNICACION', 'numeros', 1),
(6, 'INGLES', '', 1),
(7, 'ARTE Y CULTURA', '', 1),
(8, 'PERSONAL SOCIAL', '', 1),
(9, 'EDUCACION FISICA', '', 1),
(10, 'EDUCACION RELIGIOSA', '', 1),
(11, 'CIENCIA Y TECNOLOGIA', '', 1),
(12, 'COMUNICACION', '', 1);

-- grados
INSERT INTO `grados` (`id_grado`, `id_sede`, `nombre_grado`, `estado`) VALUES
(18, 18, 'PRIMER GRADO', 1),
(19, 18, 'SEGUNDO GRADO', 1),
(20, 18, 'TERCER GRADO', 1),
(21, 17, 'Primer grado', 1),
(22, 17, 'segundo grado', 1),
(23, 17, 'TERCER GRADO', 1),
(24, 17, 'CUARTO GRADO', 1),
(25, 17, 'quinto grado', 1),
(26, 18, 'CUARTO GRADO', 1),
(27, 18, 'QUINTO GRADO', 1),
(28, 18, 'SEXTO GRADO', 1),
(29, 17, 'sexto grado', 1),
(30, 19, 'Cuarto Grado', 0),
(31, 17, 'tercer grado', 0),
(32, 17, 'azul', 0),
(33, 16, 'PRIMER GRADO', 1),
(34, 16, 'SEGUNDO GRADO', 1),
(35, 20, 'Primer Grado', 1);

-- anio_escolar
INSERT INTO `anio_escolar` (`id_anio_escolar`, `id_sede`, `nombre_anio`, `activo`, `estado`) VALUES
(6, 18, '2026', 1, 1),
(7, 17, '2026', 1, 1),
(8, 17, '2054444444', 1, 0),
(9, 17, '2027', 0, 1),
(10, 16, '2026', -2147483648, 1),
(11, 20, '2026', 1, 1);

-- apoderados
INSERT INTO `apoderados` (`id_apoderado`, `id_sede`, `id_tipo_doc`, `numero_documento`, `nombres`, `apellidos`, `telefono_principal`, `correo`, `lugar_trabajo`, `estado`) VALUES
(7, 18, 1, '43629899', 'NELY', 'BERNILLA CARRILLO', '983352479', 'nelybernilla@gmail.com', 'Ama de casa', 1),
(8, 20, 1, '46719921', 'DAILITH', 'LOZANO BALSECA', '978812911', 'dailith@gmail.com', 'Empresa Independiente - Jr. 9 de Abril 331', 1);

-- alumnos
INSERT INTO `alumnos` (`id_alumno`, `id_sede`, `id_tipo_doc`, `numero_documento`, `nombres`, `apellidos`, `fecha_nacimiento`, `genero`, `direccion`, `telefono_contacto`, `foto_url`, `observaciones_salud`, `estado`) VALUES
(25, 18, 1, '40240623', 'Samuel', 'Contreras Bernilla', '2018-02-13', 'M', '201-4037 Massa Carretera', '956481233', '', 'No padece de ninguna enfermedad', 1),
(26, 20, 1, '09101111', 'Laurissa', 'Jaramillo Lozano', '2016-06-21', 'F', 'Jr. 9 de abril 331', '960562285', '/uploads/perfiles/c1bca6d2-35b1-4cc9-b169-7fe71a769232.png', 'Es alergica a la penisilina', 1),
(27, 18, 1, '61555555', 'Isaisas contreras bernilla', 'contreras bernilla', '2016-08-28', 'M', 'jr primavera 334', '952614821', '', '', 1);

-- usuarios
INSERT INTO `usuarios` (`id_usuario`, `id_sede`, `id_rol`, `id_tipo_doc`, `numero_documento`, `apellidos`, `nombres`, `correo`, `usuario`, `contraseña`, `foto_perfil`, `estado`) VALUES
(1, 16, 1, 1, '76868793', 'YAJAHUANCA FERNANDEZ', 'LUIS ALBERTO', 'luisalbertoyajahuancafernandez@gmail.com', 'luis', '$2a$10$Yd7y60O2ZOxCPmVEowmyZOvUubHoyMYqSnDqhhcMsJBsIwBsypa8i', '', 1),
(33, 17, 1, 1, '76269185', 'AREVALO ROMERO', 'NAYELLI YULEY', 'ny.arevaloro@unsm.edu.pe', 'Nay', 'admin123', '', 1),
(34, 18, 1, 1, '77219351', 'CONTRERAS BERNILLA', 'JUDITH MARIANELLA', 'jm.contrerasbe@unsm.edu.pe', 'Mari', 'admin123', '/uploads/logos/04cf002d-114d-44cc-b2cb-ab9cd2d11bbb.jpg', 1),
(35, 19, 1, 1, '72240942', 'MUÑOZ MOZOMBITE', 'MARTIN', 'm.munozmo@unsm.edu.pe', 'Marki', 'admin123', '', 1),
(36, 20, 1, 1, '74654276', 'BERRU LOZANO', 'CRISTINA', 'c.berrulo@unsm.edu.pe', 'Cristina', 'admin123', '/uploads/logos/98fcdcb3-8b38-4fcb-90a5-458efbf6a65c.jpg', 1),
(37, 16, 2, 1, '44551223', 'yajahuanca', 'LUCHO 2', 'luchoyaja@gmail.com', 'profesor1', 'profesor123', NULL, 1),
(38, 18, 2, 1, '74512698', 'profe', 'pepito', 'pepito@unsm.edu.pe', 'pepito', '$2a$10$p2CuAejpkRJGsolEdYCJOeoNEKjWDxUITejiaXgU6AoUTRRZS0IWW', NULL, 1),
(39, 18, 2, 1, '45621398', 'Flores', 'Juan', 'juancitoflore@gmail.com', 'juancito', '$2a$10$/8nMMTOpfeKmRCEfm/LCoOeGWYuW47vWO5MFA5C4zROJJkRaXQ3F2', NULL, 1),
(40, 20, 3, 1, '74654271', 'Raletse', 'Oicapse', 'cristina@gmail.com', 'Pwp', '$2a$10$OAS5jxnq7ieibD4ylFe4vOlIi03oI54lcqPDiH0cGnI/bJmolqS5q', NULL, 1),
(41, 16, 2, 1, '74522253', 'setooo', 'juan', 'juanceto@gmail.com', 'juancetoo', 'juancetoo123', NULL, 1);

-- alumno_apoderado
INSERT INTO `alumno_apoderado` (`id_alum_apod`, `id_alumno`, `id_apoderado`, `parentesco`, `es_representante_financiero`, `vive_con_estudiante`, `estado`) VALUES
(7, 25, 7, 'Madre', 0, 1, 1),
(8, 26, 8, 'Madre', 1, 1, 1),
(9, 27, 7, 'Madre', 0, 1, 1);

-- cursos
INSERT INTO `cursos` (`id_curso`, `id_area`, `nombre_curso`, `estado`, `id_sede`) VALUES
(4, 4, 'ARITMETICA', 1, NULL),
(5, 4, 'ALGEBRA', 1, NULL),
(6, 4, 'GEOMETRIA', 1, NULL),
(7, 4, 'RAZONAMIENTO MATEMATICO', 1, NULL),
(8, 5, 'GRAMATICA', 1, NULL),
(9, 5, 'COMPRENSIONLECTORA/LITERATURA', 1, NULL);

-- perfil_docente
INSERT INTO `perfil_docente` (`id_docente`, `id_usuario`, `id_especialidad`, `grado_academico`, `fecha_contratacion`, `estado_laboral`, `estado`) VALUES
(4, 38, 1, 'Bachiller', '2026-02-02', 'Contratado', 1),
(5, 39, 1, 'Bachiller', '2026-03-12', 'Contratado', 1),
(6, 37, 1, 'Bachiller', '2026-03-01', 'Contratado', 1),
(7, 41, 1, 'PROFESIONAL', '2026-03-02', 'ACTIVO', 1);

-- periodos
INSERT INTO `periodos` (`id_periodo`, `id_anio`, `nombre_periodo`, `fecha_inicio`, `fecha_fin`, `estado`) VALUES
(11, 6, 'Primer Bimestre', '2026-02-27', '2026-04-10', 1),
(12, 7, 'primer bimestre', '2026-03-04', '2026-12-23', 0),
(13, 7, 'segundo bimestre', '2026-03-10', '2026-06-17', 0),
(14, 7, 'primer bimestre', '2026-03-16', '2026-05-29', 1),
(15, 7, 'segundo bimestre', '2026-06-01', '2026-07-31', 1),
(16, 7, 'tercer bimestre', '2026-10-01', '2026-11-12', 1),
(17, 11, 'Primer Bimestre', '2026-03-21', '2026-05-21', 1);

-- secciones
INSERT INTO `secciones` (`id_seccion`, `id_grado`, `id_sede`, `nombre_seccion`, `vacantes`, `estado`) VALUES
(14, 18, 18, 'A', 20, 1),
(15, 18, 18, 'B', 20, 1),
(16, 18, 18, 'C', 20, 1),
(17, 21, 17, 'A', 30, 1),
(18, 21, 17, 'B', 30, 1),
(19, 22, 17, 'B', 30, 1),
(20, 21, 17, 'ROJO', 30, 1),
(21, 29, 17, 'azul', 30, 1),
(22, 21, 17, 'C', 30, 1),
(23, 23, 17, 'verde', 30, 1),
(24, 33, 16, 'A', 30, 1),
(25, 33, 16, 'B', 30, 1),
(26, 35, 20, 'Sección A', 2, 1);

-- asignacion_docente
INSERT INTO `asignacion_docente` (`id_asignacion`, `id_docente`, `id_seccion`, `id_curso`, `id_anio`, `estado`) VALUES
(6, 4, 14, 4, 6, 1),
(7, 4, 14, 5, 6, 1),
(8, 6, 24, 4, 10, 1),
(9, 5, 15, 4, 6, 1),
(10, 5, 15, 5, 6, 1);

-- matriculas
INSERT INTO `matriculas` (`id_matricula`, `id_alumno`, `id_seccion`, `id_anio`, `codigo_matricula`, `fecha_matricula`, `estado_matricula`, `estado`, `fecha_pago_matricula`, `fecha_vencimiento_pago`, `observaciones`, `tipo_ingreso`, `vacante_garantizada`) VALUES
(10, 25, 14, 6, 'MAT-2026-5149', '2026-03-08 10:11:37', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(11, 27, 15, 6, 'MAT-2026-5133', '2026-03-10 14:24:41', 'Activa', 1, NULL, NULL, NULL, 'Promovido', NULL);

-- documentos_alumno
INSERT INTO `documentos_alumno` (`id_doc_alumno`, `id_alumno`, `id_requisito`, `ruta_archivo`, `fecha_subida`, `estado_revision`, `observaciones`, `estado`) VALUES
(6, 25, 1, '/uploads/documentos/7527f1ee-283d-4bb3-8c9f-dad307f85975.jpg', '2026-03-08 00:00:00', NULL, 'jj', 1),
(7, 25, 2, '/uploads/documentos/90a3d18d-3f85-4a29-99fc-97add0a16d87.pdf', '2026-03-08 00:00:00', NULL, 'jojo', 1),
(8, 25, 3, '/uploads/documentos/41748bdf-28c2-4b8f-86a5-0859a2e705ee.pdf', '2026-03-08 00:00:00', NULL, 'juju', 1),
(9, 27, 1, '/uploads/documentos/172653e0-d139-43bd-9380-6099b83c0de7.pdf', '2026-03-10 00:00:00', NULL, '', 1),
(10, 27, 2, '/uploads/documentos/863e501e-8020-41dd-89c8-3771c1d510f9.pdf', '2026-03-10 00:00:00', NULL, '', 1),
(11, 27, 3, '/uploads/documentos/ae01d9e5-dae5-4807-a3d5-9a29d8aef651.pdf', '2026-03-10 00:00:00', NULL, '', 1);

-- asistencias
INSERT INTO `asistencias` (`id_asistencia`, `id_asignacion`, `id_matricula`, `fecha`, `estado_asistencia`, `observaciones`, `estado`) VALUES
(4, 6, 10, '2026-03-08', 'Presente', '', 1),
(6, 6, 10, '2026-03-09', 'Presente', '', 1);

-- evaluaciones
INSERT INTO `evaluaciones` (`id_evaluacion`, `id_asignacion`, `id_periodo`, `id_tipo_nota`, `id_tipo_evaluacion`, `tema_especifico`, `fecha_evaluacion`, `estado`) VALUES
(2, 6, 11, 1, 1, 'EXAMEN DE MATEMATICAS', '2026-03-08', 1),
(7, 6, 11, 1, 1, 'EXAMEN DE RAZONAMIENTO VERBAL ', '2026-03-08', 1),
(8, 6, 11, 1, 1, 'EXAMEN DE RAZONAMIENTO MATEMATICO', '2026-03-08', 1),
(9, 6, 11, 1, 4, 'LABORATORIO 1', '2026-03-08', 0),
(10, 7, 11, 1, 1, 'LABORATORIO 2', '2026-03-09', 0),
(11, 9, 11, 1, 1, 'LABORATORIO 1', '2026-03-10', 1);

-- calificaciones
INSERT INTO `calificaciones` (`id_calificacion`, `id_evaluacion`, `id_matricula`, `nota_obtenida`, `observaciones`, `fecha_calificacion`, `estado`) VALUES
(3, 7, 10, '15', 'Muy bueno', '2026-03-08 11:28:07', 1),
(4, 8, 10, '18', 'Excelente', '2026-03-08 11:30:10', 1),
(6, 9, 10, '20', '', '2026-03-09 00:42:37', 1),
(7, 11, 11, '20', '', '2026-03-10 14:52:07', 1);

-- pagos_suscripcion
INSERT INTO `pagos_suscripcion` (`id_pago`, `banco`, `comprobante_url`, `estado`, `estado_verificacion`, `fecha_pago`, `fecha_registro`, `fecha_verificacion`, `monto_pagado`, `numero_operacion`, `numero_pago`, `observaciones`, `id_metodo_pago`, `id_suscripcion`, `verificado_por`) VALUES
(1, NULL, '271cb14f-4662-473d-a4f8-a0555372a112.jpeg', 1, 'VERIFICADO', '2026-07-01', '2026-03-07 14:50:25.000000', '2026-03-07 15:14:40', 10.00, '000049100', 'PAGO-00001', 'Pago programado automáticamente - Período 1 de 3', 2, 30, 1),
(2, NULL, NULL, 1, 'PENDIENTE', '2026-04-07', '2026-03-07 14:50:25.000000', NULL, 10.00, NULL, 'PAGO-00002', 'Pago programado automáticamente - Período 2 de 3', NULL, 30, NULL),
(3, NULL, NULL, 1, 'PENDIENTE', '2026-05-07', '2026-03-07 14:50:25.000000', NULL, 10.00, NULL, 'PAGO-00003', 'Pago programado automáticamente - Período 3 de 3', NULL, 30, NULL),
(4, NULL, NULL, 0, 'PENDIENTE', '2025-01-01', '2026-03-07 20:31:53.000000', NULL, 100.00, NULL, 'PAGO-00004', 'Pago programado automáticamente - Período 1 de 3', NULL, 31, NULL),
(5, NULL, NULL, 0, 'PENDIENTE', '2026-01-01', '2026-03-07 20:31:53.000000', NULL, 100.00, NULL, 'PAGO-00005', 'Pago programado automáticamente - Período 2 de 3', NULL, 31, NULL),
(6, NULL, NULL, 0, 'PENDIENTE', '2027-01-01', '2026-03-07 20:31:53.000000', NULL, 100.00, NULL, 'PAGO-00006', 'Pago programado automáticamente - Período 3 de 3', NULL, 31, NULL),
(92, NULL, '2826e70c-cd00-4769-806a-f6900cdbd293.webp', 1, 'VERIFICADO', '2026-03-01', '2026-03-07 20:41:45.000000', '2026-03-07 20:44:10', 100.00, '000049101', 'PAGO-00092', 'Pago programado automáticamente - Período 1 de 2', 1, 31, 1),
(93, NULL, NULL, 1, 'PENDIENTE', '2027-01-01', '2026-03-07 20:41:45.000000', NULL, 100.00, NULL, 'PAGO-00093', 'Pago programado automáticamente - Período 2 de 2', NULL, 31, NULL),
(94, NULL, '7aa855ac-1382-46db-8845-61f0b4b7ec8d.webp', 1, 'VERIFICADO', '2026-07-01', '2026-03-07 21:02:41.000000', '2026-03-07 21:07:20', 15.00, '000004', 'PAGO-00094', 'Pago programado automáticamente - Período 1 de 10', 1, 32, 1),
(95, NULL, NULL, 1, 'PENDIENTE', '2026-04-01', '2026-03-07 21:02:41.000000', NULL, 15.00, NULL, 'PAGO-00095', 'Pago programado automáticamente - Período 2 de 10', NULL, 32, NULL),
(96, NULL, NULL, 1, 'PENDIENTE', '2026-05-01', '2026-03-07 21:02:41.000000', NULL, 15.00, NULL, 'PAGO-00096', 'Pago programado automáticamente - Período 3 de 10', NULL, 32, NULL),
(97, NULL, NULL, 1, 'PENDIENTE', '2026-06-01', '2026-03-07 21:02:41.000000', NULL, 15.00, NULL, 'PAGO-00097', 'Pago programado automáticamente - Período 4 de 10', NULL, 32, NULL),
(98, NULL, NULL, 1, 'PENDIENTE', '2026-07-01', '2026-03-07 21:02:41.000000', NULL, 15.00, NULL, 'PAGO-00098', 'Pago programado automáticamente - Período 5 de 10', NULL, 32, NULL),
(99, NULL, NULL, 1, 'PENDIENTE', '2026-08-01', '2026-03-07 21:02:41.000000', NULL, 15.00, NULL, 'PAGO-00099', 'Pago programado automáticamente - Período 6 de 10', NULL, 32, NULL),
(100, NULL, NULL, 1, 'PENDIENTE', '2026-09-01', '2026-03-07 21:02:41.000000', NULL, 15.00, NULL, 'PAGO-00100', 'Pago programado automáticamente - Período 7 de 10', NULL, 32, NULL),
(101, NULL, NULL, 1, 'PENDIENTE', '2026-10-01', '2026-03-07 21:02:41.000000', NULL, 15.00, NULL, 'PAGO-00101', 'Pago programado automáticamente - Período 8 de 10', NULL, 32, NULL),
(102, NULL, NULL, 1, 'PENDIENTE', '2026-11-01', '2026-03-07 21:02:41.000000', NULL, 15.00, NULL, 'PAGO-00102', 'Pago programado automáticamente - Período 9 de 10', NULL, 32, NULL),
(103, NULL, NULL, 1, 'PENDIENTE', '2026-12-01', '2026-03-07 21:02:41.000000', NULL, 15.00, NULL, 'PAGO-00103', 'Pago programado automáticamente - Período 10 de 10', NULL, 32, NULL),
(104, NULL, '5710e3e9-743e-4046-8874-0932f20c50bc.webp', 1, 'VERIFICADO', '2026-07-01', '2026-03-07 21:14:18.000000', '2026-03-07 21:14:51', 120.00, '000005', 'PAGO-00104', 'Pago programado automáticamente - Período 1 de 2', 1, 33, 1),
(105, NULL, NULL, 1, 'PENDIENTE', '2026-04-07', '2026-03-07 21:14:18.000000', NULL, 120.00, NULL, 'PAGO-00105', 'Pago programado automáticamente - Período 2 de 2', NULL, 33, NULL),
(106, NULL, '05af0804-11e8-465f-9339-8d0d5610d273.webp', 1, 'VERIFICADO', '2026-07-01', '2026-03-07 21:18:56.000000', '2026-03-07 21:21:02', 190.00, '000006', 'PAGO-00106', 'Pago programado automáticamente - Período 1 de 13', 1, 34, 1),
(107, NULL, '34561049-1924-4059-8a4b-3e9807afb54b.webp', 1, 'VERIFICADO', '2026-04-01', '2026-03-07 21:18:56.000000', '2026-03-08 03:24:41', 190.00, '000001', 'PAGO-00107', 'Pago programado automáticamente - Período 2 de 13', 1, 34, 1),
(108, NULL, NULL, 1, 'PENDIENTE', '2026-05-01', '2026-03-07 21:18:56.000000', NULL, 190.00, NULL, 'PAGO-00108', 'Pago programado automáticamente - Período 3 de 13', NULL, 34, NULL),
(109, NULL, NULL, 1, 'PENDIENTE', '2026-06-01', '2026-03-07 21:18:56.000000', NULL, 190.00, NULL, 'PAGO-00109', 'Pago programado automáticamente - Período 4 de 13', NULL, 34, NULL),
(110, NULL, NULL, 1, 'PENDIENTE', '2026-07-01', '2026-03-07 21:18:56.000000', NULL, 190.00, NULL, 'PAGO-00110', 'Pago programado automáticamente - Período 5 de 13', NULL, 34, NULL),
(111, NULL, NULL, 1, 'PENDIENTE', '2026-08-01', '2026-03-07 21:18:56.000000', NULL, 190.00, NULL, 'PAGO-00111', 'Pago programado automáticamente - Período 6 de 13', NULL, 34, NULL),
(112, NULL, NULL, 1, 'PENDIENTE', '2026-09-01', '2026-03-07 21:18:56.000000', NULL, 190.00, NULL, 'PAGO-00112', 'Pago programado automáticamente - Período 7 de 13', NULL, 34, NULL),
(113, NULL, NULL, 1, 'PENDIENTE', '2026-10-01', '2026-03-07 21:18:56.000000', NULL, 190.00, NULL, 'PAGO-00113', 'Pago programado automáticamente - Período 8 de 13', NULL, 34, NULL),
(114, NULL, NULL, 1, 'PENDIENTE', '2026-11-01', '2026-03-07 21:18:56.000000', NULL, 190.00, NULL, 'PAGO-00114', 'Pago programado automáticamente - Período 9 de 13', NULL, 34, NULL),
(115, NULL, NULL, 1, 'PENDIENTE', '2026-12-01', '2026-03-07 21:18:56.000000', NULL, 190.00, NULL, 'PAGO-00115', 'Pago programado automáticamente - Período 10 de 13', NULL, 34, NULL),
(116, NULL, NULL, 1, 'PENDIENTE', '2027-01-01', '2026-03-07 21:18:56.000000', NULL, 190.00, NULL, 'PAGO-00116', 'Pago programado automáticamente - Período 11 de 13', NULL, 34, NULL),
(117, NULL, NULL, 1, 'PENDIENTE', '2027-02-01', '2026-03-07 21:18:56.000000', NULL, 190.00, NULL, 'PAGO-00117', 'Pago programado automáticamente - Período 12 de 13', NULL, 34, NULL),
(118, NULL, NULL, 1, 'PENDIENTE', '2027-03-01', '2026-03-07 21:18:56.000000', NULL, 190.00, NULL, 'PAGO-00118', 'Pago programado automáticamente - Período 13 de 13', NULL, 34, NULL);

SET FOREIGN_KEY_CHECKS = 1;

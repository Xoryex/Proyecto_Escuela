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
(16, 16, 'UNICA', 20, 1),
(17, 16, 'NO UNICA', 20, 1),
(18, 17, 'Aula 101', 30, 0),
(19, 17, 'Aula 101', 30, 1),
(20, 17, 'Laboratorio 01', 30, 1),
(21, 16, 'Aula 01', 30, 1);

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

-- grados (todos en mayúsculas, sin duplicados por sede)
INSERT INTO `grados` (`id_grado`, `id_sede`, `nombre_grado`, `estado`) VALUES
(18, 16, 'PRIMER GRADO', 1),
(19, 16, 'SEGUNDO GRADO', 1),
(20, 16, 'TERCER GRADO', 1),
(21, 17, 'PRIMER GRADO', 1),
(22, 17, 'SEGUNDO GRADO', 1),
(23, 17, 'TERCER GRADO', 1),
(24, 17, 'CUARTO GRADO', 1),
(25, 17, 'QUINTO GRADO', 1),
(26, 16, 'CUARTO GRADO', 1),
(27, 16, 'QUINTO GRADO', 1),
(28, 16, 'SEXTO GRADO', 1),
(29, 17, 'SEXTO GRADO', 1);

-- anio_escolar
INSERT INTO `anio_escolar` (`id_anio_escolar`, `id_sede`, `nombre_anio`, `activo`, `estado`) VALUES
(6, 16, '2026', 1, 1),
(7, 17, '2026', 1, 1),
(9, 17, '2027', 0, 1);

-- apoderados
INSERT INTO `apoderados` (`id_apoderado`, `id_sede`, `id_tipo_doc`, `numero_documento`, `nombres`, `apellidos`, `telefono_principal`, `correo`, `lugar_trabajo`, `estado`) VALUES
(7, 16, 1, '43629899', 'NELY', 'BERNILLA CARRILLO', '983352479', 'nelybernilla@gmail.com', 'Ama de casa', 1),
(8, 16, 1, '46719921', 'DAILITH', 'LOZANO BALSECA', '978812911', 'dailith@gmail.com', 'Empresa Independiente - Jr. 9 de Abril 331', 1),
(9, 17, 1, '47182933', 'MARIA HELENA', 'MENDOZA ROJAS', '998877665', 'mariamendoza@gmail.com', 'Independiente', 1);

-- alumnos
INSERT INTO `alumnos` (`id_alumno`, `id_sede`, `id_tipo_doc`, `numero_documento`, `nombres`, `apellidos`, `fecha_nacimiento`, `genero`, `direccion`, `telefono_contacto`, `foto_url`, `observaciones_salud`, `estado`) VALUES
(25, 16, 1, '40240623', 'Samuel', 'Contreras Bernilla', '2018-02-13', 'M', '201-4037 Massa Carretera', '956481233', '', 'No padece de ninguna enfermedad', 1),
(26, 16, 1, '09101111', 'Laurissa', 'Jaramillo Lozano', '2016-06-21', 'F', 'Jr. 9 de abril 331', '960562285', '/uploads/perfiles/c1bca6d2-35b1-4cc9-b169-7fe71a769232.png', 'Es alergica a la penisilina', 1),
(27, 16, 1, '61555555', 'Isaisas contreras bernilla', 'contreras bernilla', '2016-08-28', 'M', 'jr primavera 334', '952614821', '', '', 1),
(28, 17, 1, '61223344', 'Daniela Sofía', 'Flores Mendoza', '2019-05-15', 'F', 'Jr. Lima 456', '998877665', '', 'Ninguna', 1),
(29, 17, 1, '61223345', 'Mateo Alejandro', 'Flores Mendoza', '2017-08-20', 'M', 'Jr. Lima 456', '998877665', '', 'Asmático', 1);

-- usuarios
INSERT INTO `usuarios` (`id_usuario`, `id_sede`, `id_rol`, `id_tipo_doc`, `numero_documento`, `apellidos`, `nombres`, `correo`, `usuario`, `contraseña`, `foto_perfil`, `estado`) VALUES
(1, 16, 1, 1, '76868793', 'YAJAHUANCA FERNANDEZ', 'LUIS ALBERTO', 'luisalbertoyajahuancafernandez@gmail.com', 'luis', '$2a$10$Yd7y60O2ZOxCPmVEowmyZOvUubHoyMYqSnDqhhcMsJBsIwBsypa8i', '', 1),
(33, 17, 1, 1, '76269185', 'AREVALO ROMERO', 'NAYELLI YULEY', 'ny.arevaloro@unsm.edu.pe', 'Nay', '$2a$10$E4VQfjw38HgZJc3dUQaV6e8nbBSIsL0OdL4.BciCI.Nq8Zl0FI3Ii', '', 1),
(34, 16, 1, 1, '77219351', 'CONTRERAS BERNILLA', 'JUDITH MARIANELLA', 'jm.contrerasbe@unsm.edu.pe', 'Mari', '$2a$10$E4VQfjw38HgZJc3dUQaV6e8nbBSIsL0OdL4.BciCI.Nq8Zl0FI3Ii', '/uploads/logos/04cf002d-114d-44cc-b2cb-ab9cd2d11bbb.jpg', 1),
(35, 17, 1, 1, '72240942', 'MUÑOZ MOZOMBITE', 'MARTIN', 'm.munozmo@unsm.edu.pe', 'Marki', '$2a$10$E4VQfjw38HgZJc3dUQaV6e8nbBSIsL0OdL4.BciCI.Nq8Zl0FI3Ii', '', 1),
(36, 16, 1, 1, '74654276', 'BERRU LOZANO', 'CRISTINA', 'c.berrulo@unsm.edu.pe', 'Cristina', '$2a$10$E4VQfjw38HgZJc3dUQaV6e8nbBSIsL0OdL4.BciCI.Nq8Zl0FI3Ii', '/uploads/logos/98fcdcb3-8b38-4fcb-90a5-458efbf6a65c.jpg', 1),
(37, 17, 2, 1, '44551223', 'yajahuanca', 'LUCHO 2', 'luchoyaja@gmail.com', 'profesor1', '$2a$10$E4VQfjw38HgZJc3dUQaV6em1pR1Sbzd3ubmpqstvznuMXztG7E.La', NULL, 1),
(38, 16, 2, 1, '74512698', 'profe', 'pepito', 'pepito@unsm.edu.pe', 'pepito', '$2a$10$p2CuAejpkRJGsolEdYCJOeoNEKjWDxUITejiaXgU6AoUTRRZS0IWW', NULL, 1),
(39, 17, 2, 1, '45621398', 'Flores', 'Juan', 'juancitoflore@gmail.com', 'juancito', '$2a$10$/8nMMTOpfeKmRCEfm/LCoOeGWYuW47vWO5MFA5C4zROJJkRaXQ3F2', NULL, 1),
(40, 16, 3, 1, '74654271', 'Raletse', 'Oicapse', 'cristina@gmail.com', 'Pwp', '$2a$10$OAS5jxnq7ieibD4ylFe4vOlIi03oI54lcqPDiH0cGnI/bJmolqS5q', NULL, 1),
(41, 16, 2, 1, '74522253', 'setooo', 'juan', 'juanceto@gmail.com', 'juancetoo', '$2a$10$E4VQfjw38HgZJc3dUQaV6ea.sfv2I0tky1lM7tvtySA6fthaOByXa', NULL, 1),
(42, 17, 2, 1, '44558899', 'Gomez Diaz', 'Carlos Eduardo', 'carlosgomez@gmail.com', 'carlos_profesor', '$2a$10$p2CuAejpkRJGsolEdYCJOeoNEKjWDxUITejiaXgU6AoUTRRZS0IWW', NULL, 1);

-- alumno_apoderado
INSERT INTO `alumno_apoderado` (`id_alum_apod`, `id_alumno`, `id_apoderado`, `parentesco`, `es_representante_financiero`, `vive_con_estudiante`, `estado`) VALUES
(7, 25, 7, 'Madre', 0, 1, 1),
(8, 26, 8, 'Madre', 1, 1, 1),
(9, 27, 7, 'Madre', 0, 1, 1),
(10, 28, 9, 'Madre', 1, 1, 1),
(11, 29, 9, 'Madre', 1, 1, 1);

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
(7, 41, 1, 'PROFESIONAL', '2026-03-02', 'ACTIVO', 1),
(8, 42, 1, 'Licenciado', '2026-03-01', 'Activo', 1);

-- periodos
INSERT INTO `periodos` (`id_periodo`, `id_anio`, `nombre_periodo`, `fecha_inicio`, `fecha_fin`, `estado`) VALUES
(11, 6, 'Primer Bimestre', '2026-02-27', '2026-04-10', 1),
(12, 7, 'primer bimestre', '2026-03-04', '2026-12-23', 0),
(13, 7, 'segundo bimestre', '2026-03-10', '2026-06-17', 0),
(14, 7, 'primer bimestre', '2026-03-16', '2026-05-29', 1),
(15, 7, 'segundo bimestre', '2026-06-01', '2026-07-31', 1),
(16, 7, 'tercer bimestre', '2026-10-01', '2026-11-12', 1);

-- secciones
INSERT INTO `secciones` (`id_seccion`, `id_grado`, `id_sede`, `nombre_seccion`, `vacantes`, `estado`) VALUES
(14, 18, 16, 'A', 20, 1),
(15, 18, 16, 'B', 20, 1),
(16, 18, 16, 'C', 20, 1),
(17, 21, 17, 'A', 30, 1),
(18, 21, 17, 'B', 30, 1),
(19, 22, 17, 'B', 30, 1),
(20, 21, 17, 'ROJO', 30, 1),
(21, 29, 17, 'AZUL', 30, 1),
(22, 21, 17, 'C', 30, 1),
(23, 23, 17, 'VERDE', 30, 1),
(24, 18, 16, 'A', 30, 1),
(25, 18, 16, 'B', 30, 1),
(26, 18, 16, 'A', 2, 1);

-- asignacion_docente
INSERT INTO `asignacion_docente` (`id_asignacion`, `id_docente`, `id_seccion`, `id_curso`, `id_anio`, `estado`) VALUES
(6, 4, 14, 4, 6, 1),
(7, 4, 14, 5, 6, 1),
(8, 6, 24, 4, 6, 1),
(9, 5, 15, 4, 6, 1),
(10, 5, 15, 5, 6, 1),
(11, 8, 17, 4, 7, 1),
(12, 8, 17, 8, 7, 1),
(13, 4, 14, 6, 6, 1),
(14, 4, 14, 7, 6, 1),
(15, 4, 14, 8, 6, 1),
(16, 4, 14, 9, 6, 1),
(17, 7, 14, 4, 6, 1),
(18, 7, 14, 5, 6, 1),
(19, 7, 14, 6, 6, 1),
(20, 8, 17, 5, 7, 1),
(21, 8, 17, 6, 7, 1),
(22, 8, 17, 7, 7, 1);

-- matriculas
INSERT INTO `matriculas` (`id_matricula`, `id_alumno`, `id_seccion`, `id_anio`, `codigo_matricula`, `fecha_matricula`, `estado_matricula`, `estado`, `fecha_pago_matricula`, `fecha_vencimiento_pago`, `observaciones`, `tipo_ingreso`, `vacante_garantizada`) VALUES
(10, 25, 14, 6, 'MAT-2026-5149', '2026-03-08 10:11:37', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(11, 27, 15, 6, 'MAT-2026-5133', '2026-03-10 14:24:41', 'Activa', 1, NULL, NULL, NULL, 'Promovido', NULL),
(12, 28, 17, 7, 'MAT-2026-8801', '2026-03-05 09:00:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(13, 29, 17, 7, 'MAT-2026-8802', '2026-03-05 09:30:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL);

-- documentos_alumno
INSERT INTO `documentos_alumno` (`id_doc_alumno`, `id_alumno`, `id_requisito`, `ruta_archivo`, `fecha_subida`, `estado_revision`, `observaciones`, `estado`) VALUES
(6, 25, 1, '/uploads/documentos/7527f1ee-283d-4bb3-8c9f-dad307f85975.jpg', '2026-03-08 00:00:00', NULL, 'jj', 1),
(7, 25, 2, '/uploads/documentos/90a3d18d-3f85-4a29-99fc-97add0a16d87.pdf', '2026-03-08 00:00:00', NULL, 'jojo', 1),
(8, 25, 3, '/uploads/documentos/41748bdf-28c2-4b8f-86a5-0859a2e705ee.pdf', '2026-03-08 00:00:00', NULL, 'juju', 1),
(9, 27, 1, '/uploads/documentos/172653e0-d139-43bd-9380-6099b83c0de7.pdf', '2026-03-10 00:00:00', NULL, '', 1),
(10, 27, 2, '/uploads/documentos/863e501e-8020-41dd-89c8-3771c1d510f9.pdf', '2026-03-10 00:00:00', NULL, '', 1),
(11, 27, 3, '/uploads/documentos/ae01d9e5-dae5-4807-a3d5-9a29d8aef651.pdf', '2026-03-10 00:00:00', NULL, '', 1),
(12, 28, 1, '/uploads/documentos/dni_daniela.pdf', '2026-03-05 10:00:00', 'APROBADO', 'DNI verificado', 1),
(13, 28, 2, '/uploads/documentos/dni_apoderado_daniela.pdf', '2026-03-05 10:00:00', 'APROBADO', 'DNI verificado', 1),
(14, 29, 1, '/uploads/documentos/dni_mateo.pdf', '2026-03-05 10:30:00', 'APROBADO', 'DNI verificado', 1);

-- asistencias
INSERT INTO `asistencias` (`id_asistencia`, `id_asignacion`, `id_matricula`, `fecha`, `estado_asistencia`, `observaciones`, `estado`) VALUES
(4, 6, 10, '2026-03-08', 'Presente', '', 1),
(6, 6, 10, '2026-03-09', 'Presente', '', 1),
(7, 11, 12, '2026-03-06', 'Presente', '', 1),
(8, 11, 13, '2026-03-06', 'Presente', '', 1),
(9, 11, 12, '2026-03-09', 'Falta_Justificada', 'Cita médica', 1),
(10, 11, 13, '2026-03-09', 'Presente', '', 1);

-- evaluaciones
INSERT INTO `evaluaciones` (`id_evaluacion`, `id_asignacion`, `id_periodo`, `id_tipo_nota`, `id_tipo_evaluacion`, `tema_especifico`, `fecha_evaluacion`, `estado`) VALUES
(2, 6, 11, 1, 1, 'EXAMEN DE MATEMATICAS', '2026-03-08', 1),
(7, 6, 11, 1, 1, 'EXAMEN DE RAZONAMIENTO VERBAL ', '2026-03-08', 1),
(8, 6, 11, 1, 1, 'EXAMEN DE RAZONAMIENTO MATEMATICO', '2026-03-08', 1),
(9, 6, 11, 1, 4, 'LABORATORIO 1', '2026-03-08', 0),
(10, 7, 11, 1, 1, 'LABORATORIO 2', '2026-03-09', 0),
(11, 9, 11, 1, 1, 'LABORATORIO 1', '2026-03-10', 1),
(12, 11, 14, 1, 2, 'Adición y Sustracción', '2026-03-12', 1),
(13, 11, 14, 1, 4, 'Práctica Calificada de Conjuntos', '2026-03-15', 1);

-- calificaciones
INSERT INTO `calificaciones` (`id_calificacion`, `id_evaluacion`, `id_matricula`, `nota_obtenida`, `observaciones`, `fecha_calificacion`, `estado`) VALUES
(3, 7, 10, '15', 'Muy bueno', '2026-03-08 11:28:07', 1),
(4, 8, 10, '18', 'Excelente', '2026-03-08 11:30:10', 1),
(6, 9, 10, '20', '', '2026-03-09 00:42:37', 1),
(7, 11, 11, '20', '', '2026-03-10 14:52:07', 1),
(8, 12, 12, '16', 'Buen desempeño', '2026-03-12 12:00:00', 1),
(9, 12, 13, '14', 'Puede mejorar', '2026-03-12 12:05:00', 1),
(10, 13, 12, '18', 'Excelente', '2026-03-15 15:00:00', 1),
(11, 13, 13, '15', 'Buen trabajo', '2026-03-15 15:10:00', 1);

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

-- ========================================================
-- CONCEPTOS DE PAGO (Sedes 17 y 16 - 5 conceptos por Sede)
-- ========================================================
INSERT INTO `conceptos_pago` (`id_concepto`, `nombre_concepto`, `monto`, `estado_concepto`, `id_institucion`, `id_grado`, `estado`) VALUES
-- Sede 17 (Inst 35, Grado 21)
(1, 'Matrícula Ordinaria Sede 17', 120.00, 1, 35, 21, 1),
(2, 'Pensión Mensual Marzo Sede 17', 180.00, 1, 35, 21, 1),
(3, 'Pensión Mensual Abril Sede 17', 180.00, 1, 35, 21, 1),
(4, 'Uniforme Deportivo Sede 17', 80.00, 1, 35, 21, 1),
(5, 'Taller de Música Sede 17', 60.00, 1, 35, 21, 1),
-- Sede 16 (Inst 33, Grado 18)
(6, 'Matrícula Ordinaria Sede 16', 110.00, 1, 33, 18, 1),
(7, 'Pensión Mensual Marzo Sede 16', 160.00, 1, 33, 18, 1),
(8, 'Pensión Mensual Abril Sede 16', 160.00, 1, 33, 18, 1),
(9, 'Agenda Escolar Sede 16', 25.00, 1, 33, 18, 1),
(10, 'Taller de Inglés Sede 16', 70.00, 1, 33, 18, 1);

-- ========================================================
-- ALUMNOS (25 por Sede = 50 Alumnos)
-- ========================================================
INSERT INTO `alumnos` (`id_alumno`, `id_sede`, `id_tipo_doc`, `numero_documento`, `nombres`, `apellidos`, `fecha_nacimiento`, `genero`, `direccion`, `telefono_contacto`, `foto_url`, `observaciones_salud`, `estado`) VALUES
-- Sede 17 (Estudiantes 100 al 124)
(100, 17, 1, '76801700', 'Alejandro', 'Ruiz Gomez', '2019-01-10', 'M', 'Jr. Progreso 100', '934567800', '', '', 1),
(101, 17, 1, '76801701', 'Brenda Sofia', 'Castro Silva', '2018-05-12', 'F', 'Jr. Progreso 101', '934567801', '', '', 1),
(102, 17, 1, '76801702', 'Carlos Alberto', 'Paz Torres', '2017-09-14', 'M', 'Jr. Progreso 102', '934567802', '', '', 1),
(103, 17, 1, '76801703', 'Diana Carolina', 'Soto Melendez', '2019-02-18', 'F', 'Jr. Progreso 103', '934567803', '', '', 1),
(104, 17, 1, '76801704', 'Eduardo Jose', 'Vargas Rios', '2018-11-20', 'M', 'Jr. Progreso 104', '934567804', '', '', 1),
(105, 17, 1, '76801705', 'Fiorella Belen', 'Diaz Flores', '2019-03-05', 'F', 'Jr. Progreso 105', '934567805', '', '', 1),
(106, 17, 1, '76801706', 'Gabriel Omar', 'Lozano Ortiz', '2018-07-09', 'M', 'Jr. Progreso 106', '934567806', '', '', 1),
(107, 17, 1, '76801707', 'Hugo Leonel', 'Torres Perez', '2019-04-12', 'M', 'Jr. Progreso 107', '934567807', '', '', 1),
(108, 17, 1, '76801708', 'Ingrid Irene', 'Melendez Reategui', '2018-08-11', 'F', 'Jr. Progreso 108', '934567808', '', '', 1),
(109, 17, 1, '76801709', 'Javier Nicolas', 'Rios Salazar', '2019-01-22', 'M', 'Jr. Progreso 109', '934567809', '', '', 1),
(110, 17, 1, '76801710', 'Karen Patricia', 'Flores Solis', '2017-06-30', 'F', 'Jr. Progreso 110', '934567810', '', '', 1),
(111, 17, 1, '76801711', 'Luis Fernando', 'Ortiz Pezo', '2019-05-10', 'M', 'Jr. Progreso 111', '934567811', '', '', 1),
(112, 17, 1, '76801712', 'Monica Beatriz', 'Perez Mori', '2018-09-12', 'F', 'Jr. Progreso 112', '934567812', '', '', 1),
(113, 17, 1, '76801713', 'Nestor Raul', 'Reategui Arias', '2017-03-14', 'M', 'Jr. Progreso 113', '934567813', '', '', 1),
(114, 17, 1, '76801714', 'Olga Maria', 'Salazar Solano', '2019-02-15', 'F', 'Jr. Progreso 114', '934567814', '', '', 1),
(115, 17, 1, '76801715', 'Pablo Sebastian', 'Solis Ruiz', '2018-12-25', 'M', 'Jr. Progreso 115', '934567815', '', '', 1),
(116, 17, 1, '76801716', 'Raquel Belen', 'Pezo Vidal', '2019-07-07', 'F', 'Jr. Progreso 116', '934567816', '', '', 1),
(117, 17, 1, '76801717', 'Sergio Daniel', 'Mori Cruz', '2018-04-18', 'M', 'Jr. Progreso 117', '934567817', '', '', 1),
(118, 17, 1, '76801718', 'Tatiana Sofia', 'Arias Soto', '2019-03-22', 'F', 'Jr. Progreso 118', '934567818', '', '', 1),
(119, 17, 1, '76801719', 'Victor Manuel', 'Solano Chavez', '2018-10-30', 'M', 'Jr. Progreso 119', '934567819', '', '', 1),
(120, 17, 1, '76801720', 'Wendy Vanessa', 'Ruiz Gomez', '2019-01-15', 'F', 'Jr. Progreso 120', '934567820', '', '', 1),
(121, 17, 1, '76801721', 'Xavier Angel', 'Vidal Silva', '2018-03-12', 'M', 'Jr. Progreso 121', '934567821', '', '', 1),
(122, 17, 1, '76801722', 'Yolanda Elena', 'Cruz Paz', '2017-06-25', 'F', 'Jr. Progreso 122', '934567822', '', '', 1),
(123, 17, 1, '76801723', 'Zoraida Maria', 'Soto Vargas', '2019-04-02', 'F', 'Jr. Progreso 123', '934567823', '', '', 1),
(124, 17, 1, '76801724', 'Roberto Carlos', 'Chavez Rios', '2018-05-18', 'M', 'Jr. Progreso 124', '934567824', '', '', 1),
-- Sede 16 (Estudiantes 200 al 224)
(200, 16, 1, '76801800', 'Walter Andres', 'Romero Diaz', '2019-01-10', 'M', 'Jr. Moyobamba 200', '945678200', '', '', 1),
(201, 16, 1, '76801801', 'Veronica Lucia', 'Silva Romero', '2018-05-12', 'F', 'Jr. Moyobamba 201', '945678201', '', '', 1),
(202, 16, 1, '76801802', 'Uriel David', 'Delgado Silva', '2017-09-14', 'M', 'Jr. Moyobamba 202', '945678202', '', '', 1),
(203, 16, 1, '76801803', 'Teresa Ines', 'Pinedo Delgado', '2019-02-18', 'F', 'Jr. Moyobamba 203', '945678203', '', '', 1),
(204, 16, 1, '76801804', 'Santiago', 'Davila Pinedo', '2018-11-20', 'M', 'Jr. Moyobamba 204', '945678204', '', '', 1),
(205, 16, 1, '76801805', 'Rosa Herminia', 'Vargas Davila', '2019-03-05', 'F', 'Jr. Moyobamba 205', '945678205', '', '', 1),
(206, 16, 1, '76801806', 'Quique Manuel', 'Reategui Vargas', '2018-07-09', 'M', 'Jr. Moyobamba 206', '945678206', '', '', 1),
(207, 16, 1, '76801807', 'Patricia Carmen', 'Lopez Reategui', '2019-04-12', 'F', 'Jr. Moyobamba 207', '945678207', '', '', 1),
(208, 16, 1, '76801808', 'Oscar Manuel', 'Guzman Lopez', '2018-08-11', 'M', 'Jr. Moyobamba 208', '945678208', '', '', 1),
(209, 16, 1, '76801809', 'Natalia Belen', 'Ortiz Guzman', '2019-01-22', 'F', 'Jr. Moyobamba 209', '945678209', '', '', 1),
(210, 16, 1, '76801810', 'Mateo Alejandro', 'Flores Ortiz', '2017-06-30', 'M', 'Jr. Moyobamba 210', '945678210', '', '', 1),
(211, 16, 1, '76801811', 'Lorena Sofia', 'Mendoza Flores', '2019-05-10', 'F', 'Jr. Moyobamba 211', '945678211', '', '', 1),
(212, 16, 1, '76801812', 'Kevin Nicolas', 'Rojas Mendoza', '2018-09-12', 'M', 'Jr. Moyobamba 212', '945678212', '', '', 1),
(213, 16, 1, '76801813', 'Julia Irene', 'Herrera Rojas', '2017-03-14', 'F', 'Jr. Moyobamba 213', '945678213', '', '', 1),
(214, 16, 1, '76801814', 'Ivan Gabriel', 'Lozano Herrera', '2019-02-15', 'M', 'Jr. Moyobamba 214', '945678214', '', '', 1),
(215, 16, 1, '76801815', 'Helena Belen', 'Vidal Lozano', '2018-12-25', 'F', 'Jr. Moyobamba 215', '945678215', '', '', 1),
(216, 16, 1, '76801816', 'Gerardo Jose', 'Cruz Vidal', '2019-07-07', 'M', 'Jr. Moyobamba 216', '945678216', '', '', 1),
(217, 16, 1, '76801817', 'Fernando Angel', 'Soto Cruz', '2018-04-18', 'M', 'Jr. Moyobamba 217', '945678217', '', '', 1),
(218, 16, 1, '76801818', 'Estela Belen', 'Paz Soto', '2019-03-22', 'F', 'Jr. Moyobamba 218', '945678218', '', '', 1),
(219, 16, 1, '76801819', 'Daniela Sofia', 'Flores Paz', '2018-10-30', 'F', 'Jr. Moyobamba 219', '945678219', '', '', 1),
(220, 16, 1, '76801820', 'Cesar Augusto', 'Ramirez Flores', '2019-01-15', 'M', 'Jr. Moyobamba 220', '945678220', '', '', 1),
(221, 16, 1, '76801821', 'Beatriz Belen', 'Vela Ramirez', '2018-03-12', 'F', 'Jr. Moyobamba 221', '945678221', '', '', 1),
(222, 16, 1, '76801822', 'Alberto Mario', 'Castro Vela', '2017-06-25', 'M', 'Jr. Moyobamba 222', '945678222', '', '', 1),
(223, 16, 1, '76801823', 'Abigail Sofia', 'Torres Castro', '2019-04-02', 'F', 'Jr. Moyobamba 223', '945678223', '', '', 1),
(224, 16, 1, '76801824', 'Francisco Javier', 'Rios Torres', '2018-05-18', 'M', 'Jr. Moyobamba 224', '945678224', '', '', 1);

-- ========================================================
-- MATRICULAS (25 por Sede = 50 Matrículas)
-- ========================================================
INSERT INTO `matriculas` (`id_matricula`, `id_alumno`, `id_seccion`, `id_anio`, `codigo_matricula`, `fecha_matricula`, `estado_matricula`, `estado`, `fecha_pago_matricula`, `fecha_vencimiento_pago`, `observaciones`, `tipo_ingreso`, `vacante_garantizada`) VALUES
-- Sede 17 (Matriculas 100 al 124, Section 17, Year 7)
(100, 100, 17, 7, 'MAT-2026-17-100', '2026-03-05 09:00:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(101, 101, 17, 7, 'MAT-2026-17-101', '2026-03-05 09:05:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(102, 102, 17, 7, 'MAT-2026-17-102', '2026-03-05 09:10:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(103, 103, 17, 7, 'MAT-2026-17-103', '2026-03-05 09:15:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(104, 104, 17, 7, 'MAT-2026-17-104', '2026-03-05 09:20:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(105, 105, 17, 7, 'MAT-2026-17-105', '2026-03-05 09:25:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(106, 106, 17, 7, 'MAT-2026-17-106', '2026-03-05 09:30:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(107, 107, 17, 7, 'MAT-2026-17-107', '2026-03-05 09:35:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(108, 108, 17, 7, 'MAT-2026-17-108', '2026-03-05 09:40:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(109, 109, 17, 7, 'MAT-2026-17-109', '2026-03-05 09:45:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(110, 110, 17, 7, 'MAT-2026-17-110', '2026-03-05 09:50:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(111, 111, 17, 7, 'MAT-2026-17-111', '2026-03-05 09:55:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(112, 112, 17, 7, 'MAT-2026-17-112', '2026-03-05 10:00:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(113, 113, 17, 7, 'MAT-2026-17-113', '2026-03-05 10:05:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(114, 114, 17, 7, 'MAT-2026-17-114', '2026-03-05 10:10:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(115, 115, 17, 7, 'MAT-2026-17-115', '2026-03-05 10:15:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(116, 116, 17, 7, 'MAT-2026-17-116', '2026-03-05 10:20:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(117, 117, 17, 7, 'MAT-2026-17-117', '2026-03-05 10:25:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(118, 118, 17, 7, 'MAT-2026-17-118', '2026-03-05 10:30:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(119, 119, 17, 7, 'MAT-2026-17-119', '2026-03-05 10:35:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(120, 120, 17, 7, 'MAT-2026-17-120', '2026-03-05 10:40:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(121, 121, 17, 7, 'MAT-2026-17-121', '2026-03-05 10:45:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(122, 122, 17, 7, 'MAT-2026-17-122', '2026-03-05 10:50:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(123, 123, 17, 7, 'MAT-2026-17-123', '2026-03-05 10:55:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(124, 124, 17, 7, 'MAT-2026-17-124', '2026-03-05 11:00:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
-- Sede 16 (Matriculas 200 al 224, Section 14, Year 6)
(200, 200, 14, 6, 'MAT-2026-16-200', '2026-03-05 09:00:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(201, 201, 14, 6, 'MAT-2026-16-201', '2026-03-05 09:05:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(202, 202, 14, 6, 'MAT-2026-16-202', '2026-03-05 09:10:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(203, 203, 14, 6, 'MAT-2026-16-203', '2026-03-05 09:15:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(204, 204, 14, 6, 'MAT-2026-16-204', '2026-03-05 09:20:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(205, 205, 14, 6, 'MAT-2026-16-205', '2026-03-05 09:25:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(206, 206, 14, 6, 'MAT-2026-16-206', '2026-03-05 09:30:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(207, 207, 14, 6, 'MAT-2026-16-207', '2026-03-05 09:35:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(208, 208, 14, 6, 'MAT-2026-16-208', '2026-03-05 09:40:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(209, 209, 14, 6, 'MAT-2026-16-209', '2026-03-05 09:45:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(210, 210, 14, 6, 'MAT-2026-16-210', '2026-03-05 09:50:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(211, 211, 14, 6, 'MAT-2026-16-211', '2026-03-05 09:55:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(212, 212, 14, 6, 'MAT-2026-16-212', '2026-03-05 10:00:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(213, 213, 14, 6, 'MAT-2026-16-213', '2026-03-05 10:05:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(214, 214, 14, 6, 'MAT-2026-16-214', '2026-03-05 10:10:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(215, 215, 14, 6, 'MAT-2026-16-215', '2026-03-05 10:15:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(216, 216, 14, 6, 'MAT-2026-16-216', '2026-03-05 10:20:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(217, 217, 14, 6, 'MAT-2026-16-217', '2026-03-05 10:25:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(218, 218, 14, 6, 'MAT-2026-16-218', '2026-03-05 10:30:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(219, 219, 14, 6, 'MAT-2026-16-219', '2026-03-05 10:35:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(220, 220, 14, 6, 'MAT-2026-16-220', '2026-03-05 10:40:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(221, 221, 14, 6, 'MAT-2026-16-221', '2026-03-05 10:45:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(222, 222, 14, 6, 'MAT-2026-16-222', '2026-03-05 10:50:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(223, 223, 14, 6, 'MAT-2026-16-223', '2026-03-05 10:55:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL),
(224, 224, 14, 6, 'MAT-2026-16-224', '2026-03-05 11:00:00', 'Activa', 1, NULL, NULL, NULL, 'Nuevo', NULL);

-- ========================================================
-- DEUDAS ALUMNO (50 deudas en total)
-- ========================================================
INSERT INTO `deudas_alumno` (`id_deuda`, `descripcion_cuota`, `monto_total`, `fecha_emision`, `fecha_vencimiento`, `estado_deuda`, `fecha_pago_total`, `id_concepto`, `id_matricula`, `estado`) VALUES
-- Sede 17 (Deudas 100 al 124, linked to Concepto 1)
(100, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 09:30:00', 1, 100, 1),
(101, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 09:35:00', 1, 101, 1),
(102, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 09:40:00', 1, 102, 1),
(103, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 09:45:00', 1, 103, 1),
(104, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 09:50:00', 1, 104, 1),
(105, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 09:55:00', 1, 105, 1),
(106, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 10:00:00', 1, 106, 1),
(107, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 10:05:00', 1, 107, 1),
(108, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 10:10:00', 1, 108, 1),
(109, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 10:15:00', 1, 109, 1),
(110, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 10:20:00', 1, 110, 1),
(111, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 10:25:00', 1, 111, 1),
(112, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 10:30:00', 1, 112, 1),
(113, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 10:35:00', 1, 113, 1),
(114, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 10:40:00', 1, 114, 1),
(115, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pendiente', NULL, 1, 115, 1),
(116, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pendiente', NULL, 1, 116, 1),
(117, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pendiente', NULL, 1, 117, 1),
(118, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pendiente', NULL, 1, 118, 1),
(119, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pendiente', NULL, 1, 119, 1),
(120, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pendiente', NULL, 1, 120, 1),
(121, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pendiente', NULL, 1, 121, 1),
(122, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pendiente', NULL, 1, 122, 1),
(123, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pendiente', NULL, 1, 123, 1),
(124, 'Matrícula Ordinaria', 120.00, '2026-03-05', '2026-03-31', 'Pendiente', NULL, 1, 124, 1),
-- Sede 16 (Deudas 200 al 224, linked to Concepto 6)
(200, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 09:30:00', 6, 200, 1),
(201, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 09:35:00', 6, 201, 1),
(202, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 09:40:00', 6, 202, 1),
(203, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 09:45:00', 6, 203, 1),
(204, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 09:50:00', 6, 204, 1),
(205, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 09:55:00', 6, 205, 1),
(206, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 10:00:00', 6, 206, 1),
(207, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 10:05:00', 6, 207, 1),
(208, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 10:10:00', 6, 208, 1),
(209, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 10:15:00', 6, 209, 1),
(210, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 10:20:00', 6, 210, 1),
(211, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 10:25:00', 6, 211, 1),
(212, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 10:30:00', 6, 212, 1),
(213, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 10:35:00', 6, 213, 1),
(214, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pagado', '2026-03-05 10:40:00', 6, 214, 1),
(215, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pendiente', NULL, 6, 215, 1),
(216, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pendiente', NULL, 6, 216, 1),
(217, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pendiente', NULL, 6, 217, 1),
(218, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pendiente', NULL, 6, 218, 1),
(219, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pendiente', NULL, 6, 219, 1),
(220, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pendiente', NULL, 6, 220, 1),
(221, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pendiente', NULL, 6, 221, 1),
(222, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pendiente', NULL, 6, 222, 1),
(223, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pendiente', NULL, 6, 223, 1),
(224, 'Matrícula Ordinaria', 110.00, '2026-03-05', '2026-03-31', 'Pendiente', NULL, 6, 224, 1);

-- ========================================================
-- PAGOS CAJA (15 por Sede = 30 pagos en total)
-- ========================================================
INSERT INTO `pagos_caja` (`id_pago`, `fecha_pago`, `monto_total_pagado`, `comprobante_numero`, `observacion_pago`, `id_metodo`, `id_usuario`, `estado`) VALUES
-- Sede 17 (Cobrado por Cajero User 33)
(100, '2026-03-05 09:30:00', 120.00, 'COMP-17-100', 'Matrícula Pagada', 1, 33, 1),
(101, '2026-03-05 09:35:00', 120.00, 'COMP-17-101', 'Matrícula Pagada', 1, 33, 1),
(102, '2026-03-05 09:40:00', 120.00, 'COMP-17-102', 'Matrícula Pagada', 1, 33, 1),
(103, '2026-03-05 09:45:00', 120.00, 'COMP-17-103', 'Matrícula Pagada', 1, 33, 1),
(104, '2026-03-05 09:50:00', 120.00, 'COMP-17-104', 'Matrícula Pagada', 1, 33, 1),
(105, '2026-03-05 09:55:00', 120.00, 'COMP-17-105', 'Matrícula Pagada', 1, 33, 1),
(106, '2026-03-05 10:00:00', 120.00, 'COMP-17-106', 'Matrícula Pagada', 1, 33, 1),
(107, '2026-03-05 10:05:00', 120.00, 'COMP-17-107', 'Matrícula Pagada', 1, 33, 1),
(108, '2026-03-05 10:10:00', 120.00, 'COMP-17-108', 'Matrícula Pagada', 1, 33, 1),
(109, '2026-03-05 10:15:00', 120.00, 'COMP-17-109', 'Matrícula Pagada', 1, 33, 1),
(110, '2026-03-05 10:20:00', 120.00, 'COMP-17-110', 'Matrícula Pagada', 1, 33, 1),
(111, '2026-03-05 10:25:00', 120.00, 'COMP-17-111', 'Matrícula Pagada', 1, 33, 1),
(112, '2026-03-05 10:30:00', 120.00, 'COMP-17-112', 'Matrícula Pagada', 1, 33, 1),
(113, '2026-03-05 10:35:00', 120.00, 'COMP-17-113', 'Matrícula Pagada', 1, 33, 1),
(114, '2026-03-05 10:40:00', 120.00, 'COMP-17-114', 'Matrícula Pagada', 1, 33, 1),
-- Sede 16 (Cobrado por Cajero User 34)
(200, '2026-03-05 09:30:00', 110.00, 'COMP-16-200', 'Matrícula Pagada', 1, 34, 1),
(201, '2026-03-05 09:35:00', 110.00, 'COMP-16-201', 'Matrícula Pagada', 1, 34, 1),
(202, '2026-03-05 09:40:00', 110.00, 'COMP-16-202', 'Matrícula Pagada', 1, 34, 1),
(203, '2026-03-05 09:45:00', 110.00, 'COMP-16-203', 'Matrícula Pagada', 1, 34, 1),
(204, '2026-03-05 09:50:00', 110.00, 'COMP-16-204', 'Matrícula Pagada', 1, 34, 1),
(205, '2026-03-05 09:55:00', 110.00, 'COMP-16-205', 'Matrícula Pagada', 1, 34, 1),
(206, '2026-03-05 10:00:00', 110.00, 'COMP-16-206', 'Matrícula Pagada', 1, 34, 1),
(207, '2026-03-05 10:05:00', 110.00, 'COMP-16-207', 'Matrícula Pagada', 1, 34, 1),
(208, '2026-03-05 10:10:00', 110.00, 'COMP-16-208', 'Matrícula Pagada', 1, 34, 1),
(209, '2026-03-05 10:15:00', 110.00, 'COMP-16-209', 'Matrícula Pagada', 1, 34, 1),
(210, '2026-03-05 10:20:00', 110.00, 'COMP-16-210', 'Matrícula Pagada', 1, 34, 1),
(211, '2026-03-05 10:25:00', 110.00, 'COMP-16-211', 'Matrícula Pagada', 1, 34, 1),
(212, '2026-03-05 10:30:00', 110.00, 'COMP-16-212', 'Matrícula Pagada', 1, 34, 1),
(213, '2026-03-05 10:35:00', 110.00, 'COMP-16-213', 'Matrícula Pagada', 1, 34, 1),
(214, '2026-03-05 10:40:00', 110.00, 'COMP-16-214', 'Matrícula Pagada', 1, 34, 1);

-- ========================================================
-- PAGO DETALLE (30 detalles de pago)
-- ========================================================
INSERT INTO `pago_detalle` (`id_pago_detalle`, `monto_aplicado`, `id_pago`, `id_deuda`, `estado`) VALUES
-- Sede 17
(100, 120.00, 100, 100, 1),
(101, 120.00, 101, 101, 1),
(102, 120.00, 102, 102, 1),
(103, 120.00, 103, 103, 1),
(104, 120.00, 104, 104, 1),
(105, 120.00, 105, 105, 1),
(106, 120.00, 106, 106, 1),
(107, 120.00, 107, 107, 1),
(108, 120.00, 108, 108, 1),
(109, 120.00, 109, 109, 1),
(110, 120.00, 110, 110, 1),
(111, 120.00, 111, 111, 1),
(112, 120.00, 112, 112, 1),
(113, 120.00, 113, 113, 1),
(114, 120.00, 114, 114, 1),
-- Sede 16
(200, 110.00, 200, 200, 1),
(201, 110.00, 201, 201, 1),
(202, 110.00, 202, 202, 1),
(203, 110.00, 203, 203, 1),
(204, 110.00, 204, 204, 1),
(205, 110.00, 205, 205, 1),
(206, 110.00, 206, 206, 1),
(207, 110.00, 207, 207, 1),
(208, 110.00, 208, 208, 1),
(209, 110.00, 209, 209, 1),
(210, 110.00, 210, 210, 1),
(211, 110.00, 211, 211, 1),
(212, 110.00, 212, 212, 1),
(213, 110.00, 213, 213, 1),
(214, 110.00, 214, 214, 1);

-- ========================================================
-- ASISTENCIAS (50 estudiantes x 2 días = 100 registros)
-- ========================================================
INSERT INTO `asistencias` (`id_asistencia`, `id_asignacion`, `id_matricula`, `fecha`, `estado_asistencia`, `observaciones`, `estado`) VALUES
-- Sede 17 (Día 1: 2026-03-09)
(100, 11, 100, '2026-03-09', 'Presente', '', 1),
(101, 11, 101, '2026-03-09', 'Presente', '', 1),
(102, 11, 102, '2026-03-09', 'Presente', '', 1),
(103, 11, 103, '2026-03-09', 'Presente', '', 1),
(104, 11, 104, '2026-03-09', 'Justificado', 'Cita médica', 1),
(105, 11, 105, '2026-03-09', 'Presente', '', 1),
(106, 11, 106, '2026-03-09', 'Presente', '', 1),
(107, 11, 107, '2026-03-09', 'Presente', '', 1),
(108, 11, 108, '2026-03-09', 'Presente', '', 1),
(109, 11, 109, '2026-03-09', 'Presente', '', 1),
(110, 11, 110, '2026-03-09', 'Presente', '', 1),
(111, 11, 111, '2026-03-09', 'Tardanza', '', 1),
(112, 11, 112, '2026-03-09', 'Presente', '', 1),
(113, 11, 113, '2026-03-09', 'Presente', '', 1),
(114, 11, 114, '2026-03-09', 'Presente', '', 1),
(115, 11, 115, '2026-03-09', 'Presente', '', 1),
(116, 11, 116, '2026-03-09', 'Presente', '', 1),
(117, 11, 117, '2026-03-09', 'Falta', '', 1),
(118, 11, 118, '2026-03-09', 'Presente', '', 1),
(119, 11, 119, '2026-03-09', 'Presente', '', 1),
(120, 11, 120, '2026-03-09', 'Presente', '', 1),
(121, 11, 121, '2026-03-09', 'Presente', '', 1),
(122, 11, 122, '2026-03-09', 'Presente', '', 1),
(123, 11, 123, '2026-03-09', 'Tardanza', '', 1),
(124, 11, 124, '2026-03-09', 'Presente', '', 1),
-- Sede 17 (Día 2: 2026-03-10)
(125, 11, 100, '2026-03-10', 'Presente', '', 1),
(126, 11, 101, '2026-03-10', 'Presente', '', 1),
(127, 11, 102, '2026-03-10', 'Presente', '', 1),
(128, 11, 103, '2026-03-10', 'Presente', '', 1),
(129, 11, 104, '2026-03-10', 'Presente', '', 1),
(130, 11, 105, '2026-03-10', 'Presente', '', 1),
(131, 11, 106, '2026-03-10', 'Presente', '', 1),
(132, 11, 107, '2026-03-10', 'Tardanza', '', 1),
(133, 11, 108, '2026-03-10', 'Presente', '', 1),
(134, 11, 109, '2026-03-10', 'Presente', '', 1),
(135, 11, 110, '2026-03-10', 'Presente', '', 1),
(136, 11, 111, '2026-03-10', 'Presente', '', 1),
(137, 11, 112, '2026-03-10', 'Presente', '', 1),
(138, 11, 113, '2026-03-10', 'Presente', '', 1),
(139, 11, 114, '2026-03-10', 'Presente', '', 1),
(140, 11, 115, '2026-03-10', 'Presente', '', 1),
(141, 11, 116, '2026-03-10', 'Presente', '', 1),
(142, 11, 117, '2026-03-10', 'Presente', '', 1),
(143, 11, 118, '2026-03-10', 'Presente', '', 1),
(144, 11, 119, '2026-03-10', 'Presente', '', 1),
(145, 11, 120, '2026-03-10', 'Presente', '', 1),
(146, 11, 121, '2026-03-10', 'Presente', '', 1),
(147, 11, 122, '2026-03-10', 'Justificado', '', 1),
(148, 11, 123, '2026-03-10', 'Presente', '', 1),
(149, 11, 124, '2026-03-10', 'Presente', '', 1),
-- Sede 16 (Día 1: 2026-03-09)
(200, 6, 200, '2026-03-09', 'Presente', '', 1),
(201, 6, 201, '2026-03-09', 'Presente', '', 1),
(202, 6, 202, '2026-03-09', 'Presente', '', 1),
(203, 6, 203, '2026-03-09', 'Presente', '', 1),
(204, 6, 204, '2026-03-09', 'Justificado', 'Problemas familiares', 1),
(205, 6, 205, '2026-03-09', 'Presente', '', 1),
(206, 6, 206, '2026-03-09', 'Presente', '', 1),
(207, 6, 207, '2026-03-09', 'Presente', '', 1),
(208, 6, 208, '2026-03-09', 'Presente', '', 1),
(209, 6, 209, '2026-03-09', 'Presente', '', 1),
(210, 6, 210, '2026-03-09', 'Presente', '', 1),
(211, 6, 211, '2026-03-09', 'Tardanza', '', 1),
(212, 6, 212, '2026-03-09', 'Presente', '', 1),
(213, 6, 213, '2026-03-09', 'Presente', '', 1),
(214, 6, 214, '2026-03-09', 'Presente', '', 1),
(215, 6, 215, '2026-03-09', 'Presente', '', 1),
(216, 6, 216, '2026-03-09', 'Presente', '', 1),
(217, 6, 217, '2026-03-09', 'Falta', '', 1),
(218, 6, 218, '2026-03-09', 'Presente', '', 1),
(219, 6, 219, '2026-03-09', 'Presente', '', 1),
(220, 6, 220, '2026-03-09', 'Presente', '', 1),
(221, 6, 221, '2026-03-09', 'Presente', '', 1),
(222, 6, 222, '2026-03-09', 'Presente', '', 1),
(223, 6, 223, '2026-03-09', 'Tardanza', '', 1),
(224, 6, 224, '2026-03-09', 'Presente', '', 1),
-- Sede 16 (Día 2: 2026-03-10)
(225, 6, 200, '2026-03-10', 'Presente', '', 1),
(226, 6, 201, '2026-03-10', 'Presente', '', 1),
(227, 6, 202, '2026-03-10', 'Presente', '', 1),
(228, 6, 203, '2026-03-10', 'Presente', '', 1),
(229, 6, 204, '2026-03-10', 'Presente', '', 1),
(230, 6, 205, '2026-03-10', 'Presente', '', 1),
(231, 6, 206, '2026-03-10', 'Presente', '', 1),
(232, 6, 207, '2026-03-10', 'Tardanza', '', 1),
(233, 6, 208, '2026-03-10', 'Presente', '', 1),
(234, 6, 209, '2026-03-10', 'Presente', '', 1),
(235, 6, 210, '2026-03-10', 'Presente', '', 1),
(236, 6, 211, '2026-03-10', 'Presente', '', 1),
(237, 6, 212, '2026-03-10', 'Presente', '', 1),
(238, 6, 213, '2026-03-10', 'Presente', '', 1),
(239, 6, 214, '2026-03-10', 'Presente', '', 1),
(240, 6, 215, '2026-03-10', 'Presente', '', 1),
(241, 6, 216, '2026-03-10', 'Presente', '', 1),
(242, 6, 217, '2026-03-10', 'Presente', '', 1),
(243, 6, 218, '2026-03-10', 'Presente', '', 1),
(244, 6, 219, '2026-03-10', 'Presente', '', 1),
(245, 6, 220, '2026-03-10', 'Presente', '', 1),
(246, 6, 221, '2026-03-10', 'Presente', '', 1),
(247, 6, 222, '2026-03-10', 'Justificado', '', 1),
(248, 6, 223, '2026-03-10', 'Presente', '', 1),
(249, 6, 224, '2026-03-10', 'Presente', '', 1);

-- ========================================================
-- CALIFICACIONES (Grades for all 50 students)
-- ========================================================
INSERT INTO `calificaciones` (`id_calificacion`, `id_evaluacion`, `id_matricula`, `nota_obtenida`, `observaciones`, `fecha_calificacion`, `estado`) VALUES
-- Sede 17 (linked to Evaluacion 12: Aritmetica)
(100, 12, 100, '16', 'Buen desempeño', '2026-03-12 12:00:00', 1),
(101, 12, 101, '14', 'Puede mejorar', '2026-03-12 12:05:00', 1),
(102, 12, 102, '18', 'Excelente', '2026-03-12 12:10:00', 1),
(103, 12, 103, '15', 'Buen trabajo', '2026-03-12 12:15:00', 1),
(104, 12, 104, '11', 'Necesita estudiar', '2026-03-12 12:20:00', 1),
(105, 12, 105, '17', 'Destacado', '2026-03-12 12:25:00', 1),
(106, 12, 106, '15', 'Buen nivel', '2026-03-12 12:30:00', 1),
(107, 12, 107, '13', 'Regular', '2026-03-12 12:35:00', 1),
(108, 12, 108, '19', 'Sobresaliente', '2026-03-12 12:40:00', 1),
(109, 12, 109, '14', 'Puede mejorar', '2026-03-12 12:45:00', 1),
(110, 12, 110, '16', 'Buen desempeño', '2026-03-12 12:50:00', 1),
(111, 12, 111, '15', 'Buen desempeño', '2026-03-12 12:55:00', 1),
(112, 12, 112, '18', 'Excelente', '2026-03-12 13:00:00', 1),
(113, 12, 113, '12', 'Bajo', '2026-03-12 13:05:00', 1),
(114, 12, 114, '16', 'Buen nivel', '2026-03-12 13:10:00', 1),
(115, 12, 115, '14', 'Puede mejorar', '2026-03-12 13:15:00', 1),
(116, 12, 116, '17', 'Destacado', '2026-03-12 13:20:00', 1),
(117, 12, 117, '10', 'Desaprobado', '2026-03-12 13:25:00', 1),
(118, 12, 118, '15', 'Buen trabajo', '2026-03-12 13:30:00', 1),
(119, 12, 119, '16', 'Buen rendimiento', '2026-03-12 13:35:00', 1),
(120, 12, 120, '18', 'Excelente', '2026-03-12 13:40:00', 1),
(121, 12, 121, '13', 'Regular', '2026-03-12 13:45:00', 1),
(122, 12, 122, '14', 'Puede mejorar', '2026-03-12 13:50:00', 1),
(123, 12, 123, '17', 'Muy bueno', '2026-03-12 13:55:00', 1),
(124, 12, 124, '15', 'Buen trabajo', '2026-03-12 14:00:00', 1),
-- Sede 16 (linked to Evaluacion 7: Aritmetica)
(200, 7, 200, '15', 'Buen desempeño', '2026-03-12 12:00:00', 1),
(201, 7, 201, '13', 'Puede mejorar', '2026-03-12 12:05:00', 1),
(202, 7, 202, '17', 'Excelente', '2026-03-12 12:10:00', 1),
(203, 7, 203, '16', 'Buen trabajo', '2026-03-12 12:15:00', 1),
(204, 7, 204, '12', 'Necesita estudiar', '2026-03-12 12:20:00', 1),
(205, 7, 205, '18', 'Destacado', '2026-03-12 12:25:00', 1),
(206, 7, 206, '14', 'Buen nivel', '2026-03-12 12:30:00', 1),
(207, 7, 207, '11', 'Bajo', '2026-03-12 12:35:00', 1),
(208, 7, 208, '20', 'Perfecto', '2026-03-12 12:40:00', 1),
(209, 7, 209, '15', 'Puede mejorar', '2026-03-12 12:45:00', 1),
(210, 7, 210, '16', 'Buen desempeño', '2026-03-12 12:50:00', 1),
(211, 7, 211, '14', 'Buen desempeño', '2026-03-12 12:55:00', 1),
(212, 7, 212, '19', 'Excelente', '2026-03-12 13:00:00', 1),
(213, 7, 213, '13', 'Bajo', '2026-03-12 13:05:00', 1),
(214, 7, 214, '17', 'Buen nivel', '2026-03-12 13:10:00', 1),
(215, 7, 215, '14', 'Puede mejorar', '2026-03-12 13:15:00', 1),
(216, 7, 216, '16', 'Destacado', '2026-03-12 13:20:00', 1),
(217, 7, 217, '09', 'Desaprobado', '2026-03-12 13:25:00', 1),
(218, 7, 218, '15', 'Buen trabajo', '2026-03-12 13:30:00', 1),
(219, 7, 219, '17', 'Buen rendimiento', '2026-03-12 13:35:00', 1),
(220, 7, 220, '18', 'Excelente', '2026-03-12 13:40:00', 1),
(221, 7, 221, '12', 'Regular', '2026-03-12 13:45:00', 1),
(222, 7, 222, '15', 'Puede mejorar', '2026-03-12 13:50:00', 1),
(223, 7, 223, '16', 'Muy bueno', '2026-03-12 13:55:00', 1),
(224, 7, 224, '14', 'Buen trabajo', '2026-03-12 14:00:00', 1);

-- ========================================================
-- HORARIOS (5 por Sede)
-- ========================================================
INSERT INTO `horarios` (`id_horario`, `dia_semana`, `hora_inicio`, `hora_fin`, `id_asignacion`, `id_aula`, `estado`) VALUES
-- Sede 17 (Asignacion 11, Aula 19)
(1, 'Lunes', '08:00:00', '09:30:00', 11, 19, 1),
(2, 'Martes', '08:00:00', '09:30:00', 11, 19, 1),
(3, 'Miercoles', '08:00:00', '09:30:00', 11, 19, 1),
(4, 'Jueves', '08:00:00', '09:30:00', 11, 19, 1),
(5, 'Viernes', '08:00:00', '09:30:00', 11, 19, 1),
-- Sede 16 (Asignacion 6, Aula 16)
(6, 'Lunes', '08:00:00', '09:30:00', 6, 16, 1),
(7, 'Martes', '08:00:00', '09:30:00', 6, 16, 1),
(8, 'Miercoles', '08:00:00', '09:30:00', 6, 16, 1),
(9, 'Jueves', '08:00:00', '09:30:00', 6, 16, 1),
(10, 'Viernes', '08:00:00', '09:30:00', 6, 16, 1);

-- ========================================================
-- LIMITES SEDES SUSCRIPCION (5 por Sede)
-- ========================================================
INSERT INTO `limites_sedes_suscripcion` (`id_limite_sede`, `limite_alumnos_asignado`, `id_suscripcion`, `id_sede`, `estado`) VALUES
-- Sede 17 (Suscripcion 31)
(1, 100, 31, 17, 1),
(2, 110, 31, 17, 0),
(3, 120, 31, 17, 0),
(4, 130, 31, 17, 0),
(5, 140, 31, 17, 0),
-- Sede 16 (Suscripcion 30)
(6, 80, 30, 16, 1),
(7, 90, 30, 16, 0),
(8, 100, 30, 16, 0),
(9, 110, 30, 16, 0),
(10, 120, 30, 16, 0);

-- ========================================================
-- MALLA CURRICULAR (5 por Sede)
-- ========================================================
INSERT INTO `malla_curricular` (`id_malla`, `id_sede`, `id_anio`, `id_grado`, `id_curso`, `estado`) VALUES
-- Sede 17 (Year 7, Grado 21)
(1, 17, 7, 21, 4, 1),
(2, 17, 7, 21, 5, 1),
(3, 17, 7, 21, 6, 1),
(4, 17, 7, 21, 7, 1),
(5, 17, 7, 21, 8, 1),
-- Sede 16 (Year 6, Grado 18)
(6, 16, 6, 18, 4, 1),
(7, 16, 6, 18, 5, 1),
(8, 16, 6, 18, 6, 1),
(9, 16, 6, 18, 7, 1),
(10, 16, 6, 18, 8, 1);

-- ========================================================
-- MOVIMIENTOS ALUMNO (5 por Sede)
-- ========================================================
INSERT INTO `movimientos_alumno` (`id_movimiento`, `tipo_movimiento`, `fecha_movimiento`, `fecha_solicitud`, `motivo`, `colegio_destino`, `documentos_url`, `observaciones`, `id_usuario_registro`, `id_usuario_aprobador`, `fecha_aprobacion`, `estado_solicitud`, `id_matricula`, `estado`) VALUES
-- Sede 17 (linked to Matriculas 100-104)
(1, 'Retiro', '2026-03-10', '2026-03-08 09:00:00', 'Mudanza familiar', NULL, NULL, '', 33, 33, '2026-03-10 10:00:00', 'Aprobada', 100, 1),
(2, 'Traslado_Saliente', '2026-03-12', '2026-03-10 10:00:00', 'Cambio de domicilio', 'I.E. Santo Toribio', NULL, '', 33, NULL, NULL, 'Pendiente', 101, 1),
(3, 'Cambio_Seccion', '2026-03-15', '2026-03-14 09:00:00', 'Optimización de aforo', NULL, NULL, '', 33, 33, '2026-03-15 11:00:00', 'Aprobada', 102, 1),
(4, 'Retiro', '2026-03-18', '2026-03-17 08:30:00', 'Viaje al extranjero', NULL, NULL, '', 33, NULL, NULL, 'Pendiente', 103, 1),
(5, 'Traslado_Saliente', '2026-03-20', '2026-03-19 14:00:00', 'Distancia del plantel', 'I.E. Innova Schools', NULL, '', 33, NULL, NULL, 'Rechazada', 104, 1),
-- Sede 16 (linked to Matriculas 200-204)
(6, 'Retiro', '2026-03-10', '2026-03-08 09:00:00', 'Mudanza familiar', NULL, NULL, '', 34, 34, '2026-03-10 10:00:00', 'Aprobada', 200, 1),
(7, 'Traslado_Saliente', '2026-03-12', '2026-03-10 10:00:00', 'Cambio de domicilio', 'I.E. San Jose', NULL, '', 34, NULL, NULL, 'Pendiente', 201, 1),
(8, 'Cambio_Seccion', '2026-03-15', '2026-03-14 09:00:00', 'Compatibilidad', NULL, NULL, '', 34, 34, '2026-03-15 11:00:00', 'Aprobada', 202, 1),
(9, 'Retiro', '2026-03-18', '2026-03-17 08:30:00', 'Salud del alumno', NULL, NULL, '', 34, NULL, NULL, 'Pendiente', 203, 1),
(10, 'Traslado_Saliente', '2026-03-20', '2026-03-19 14:00:00', 'Problemas economicos', 'I.E. Claretiano', NULL, '', 34, NULL, NULL, 'Rechazada', 204, 1);

-- ========================================================
-- PROMEDIOS PERIODO (5 por Sede)
-- ========================================================
INSERT INTO `promedios_periodo` (`id_promedio`, `nota_final_area`, `comentario_libreta`, `estado_cierre`, `id_asignacion`, `id_matricula`, `id_periodo`, `estado`) VALUES
-- Sede 17 (linked to Matriculas 100-104, Asignacion 11, Periodo 14)
(1, '16', 'Buen desempeño académico', 'Cerrado_Enviado', 11, 100, 14, 1),
(2, '14', 'Puede mejorar su participación', 'Cerrado_Enviado', 11, 101, 14, 1),
(3, '18', 'Excelente rendimiento general', 'Abierto', 11, 102, 14, 1),
(4, '15', 'Buen trabajo en clase', 'Abierto', 11, 103, 14, 1),
(5, '11', 'Necesita esforzarse más', 'Abierto', 11, 104, 14, 1),
-- Sede 16 (linked to Matriculas 200-204, Asignacion 6, Periodo 11)
(6, '15', 'Buen rendimiento', 'Cerrado_Enviado', 6, 200, 11, 1),
(7, '13', 'Requiere más práctica', 'Cerrado_Enviado', 6, 201, 11, 1),
(8, '17', 'Destacada participación', 'Abierto', 6, 202, 11, 1),
(9, '16', 'Buen desempeño', 'Abierto', 6, 203, 11, 1),
(10, '12', 'Estudiar más para el examen', 'Abierto', 6, 204, 11, 1);

SET FOREIGN_KEY_CHECKS = 1;

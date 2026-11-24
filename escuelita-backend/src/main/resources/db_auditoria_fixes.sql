-- ============================================================================
-- Script de Remediación de Auditoría de Base de Datos — SIAE (ESCUELITA)
-- Motor objetivo: MariaDB 10.4 / MySQL 8.0 (BD: Escuela)
-- Idempotente y seguro para ejecución sobre BD existente
-- ============================================================================

USE `Escuela`;

-- 1. Corregir correo con coma en super_admins
UPDATE `super_admins`
SET `correo` = 'superadmin@gmail.com'
WHERE `id_admin` = 1 AND `correo` = 'superadmin@gmail.co,';

-- 2. Reasignar asignacion_docente de sección duplicada 24 -> 14 y desactivar secciones duplicadas
UPDATE `asignacion_docente`
SET `id_seccion` = 14
WHERE `id_seccion` = 24;

UPDATE `secciones`
SET `estado` = 0
WHERE `id_seccion` IN (24, 25, 26) AND `estado` = 1;

-- 3. Desactivar área duplicada 'COMUNICACION' (id_area = 12, sin referencias)
UPDATE `areas`
SET `estado` = 0
WHERE `id_area` = 12 AND `nombre_area` = 'COMUNICACION' AND `estado` = 1;

-- 4. Alinear suscripciones con limites_sedes_suscripcion (5 suscripciones activas)
UPDATE `suscripciones` SET `limite_alumnos_contratado` = 80  WHERE `id_suscripcion` = 30 AND `limite_alumnos_contratado` < 80;
UPDATE `suscripciones` SET `limite_alumnos_contratado` = 100 WHERE `id_suscripcion` = 31 AND `limite_alumnos_contratado` < 100;

INSERT INTO `limites_sedes_suscripcion` (`id_suscripcion`, `id_sede`, `limite_alumnos_asignado`, `estado`)
SELECT 32, 18, 10, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `limites_sedes_suscripcion` WHERE `id_suscripcion` = 32 AND `id_sede` = 18 AND `estado` = 1);

INSERT INTO `limites_sedes_suscripcion` (`id_suscripcion`, `id_sede`, `limite_alumnos_asignado`, `estado`)
SELECT 33, 19, 10, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `limites_sedes_suscripcion` WHERE `id_suscripcion` = 33 AND `id_sede` = 19 AND `estado` = 1);

INSERT INTO `limites_sedes_suscripcion` (`id_suscripcion`, `id_sede`, `limite_alumnos_asignado`, `estado`)
SELECT 34, 20, 10, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `limites_sedes_suscripcion` WHERE `id_suscripcion` = 34 AND `id_sede` = 20 AND `estado` = 1);

-- 5. Migrar columnas monetarias de planes de DOUBLE a DECIMAL(10,2)
ALTER TABLE `planes`
    MODIFY COLUMN `precio_mensual` DECIMAL(10,2) NULL,
    MODIFY COLUMN `precio_anual` DECIMAL(10,2) NULL;

-- 6. Índices de rendimiento para consultas multi-sede y académicas frecuentes
CREATE INDEX IF NOT EXISTS `idx_alumnos_sede_doc` ON `alumnos` (`id_sede`, `numero_documento`);
CREATE INDEX IF NOT EXISTS `idx_apoderados_sede_doc` ON `apoderados` (`id_sede`, `numero_documento`);
CREATE INDEX IF NOT EXISTS `idx_matriculas_alumno_anio` ON `matriculas` (`id_alumno`, `id_anio`);
CREATE INDEX IF NOT EXISTS `idx_asistencias_asig_mat_fecha` ON `asistencias` (`id_asignacion`, `id_matricula`, `fecha`);
CREATE INDEX IF NOT EXISTS `idx_deudas_matricula_estado` ON `deudas_alumno` (`id_matricula`, `estado_deuda`);
CREATE INDEX IF NOT EXISTS `idx_usuarios_sede_usuario` ON `usuarios` (`id_sede`, `usuario`);

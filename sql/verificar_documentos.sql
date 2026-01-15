-- ============================================================
-- VERIFICACIÓN Y DIAGNÓSTICO DE LA INSTALACIÓN
-- ============================================================
-- Ejecutá este script para verificar que todo esté funcionando
-- correctamente después de instalar el sistema de documentos
-- ============================================================

-- ====================================
-- 1. VERIFICAR QUE LA TABLA EXISTE
-- ====================================
SELECT 'Tabla documento existe' AS estado, COUNT(*) AS total_registros 
FROM documento;

-- ====================================
-- 2. VERIFICAR DOCUMENTOS POR HISTORIA
-- ====================================
SELECT 
    h.id AS historia_id,
    h.titulo AS historia,
    COUNT(d.id) AS cantidad_documentos,
    SUM(CASE WHEN d.codigo_correcto IS NOT NULL THEN 1 ELSE 0 END) AS con_codigo,
    MAX(d.codigo_correcto) AS codigo_solucion
FROM historia h
LEFT JOIN documento d ON h.id = d.historia_id
WHERE h.activa = 1
GROUP BY h.id, h.titulo
ORDER BY h.id;

-- ====================================
-- 3. LISTAR TODOS LOS DOCUMENTOS
-- ====================================
SELECT 
    d.id,
    h.titulo AS historia,
    d.clave,
    d.nombre,
    d.icono,
    LENGTH(d.contenido) AS tam_contenido,
    d.codigo_correcto,
    d.pista_nombre
FROM documento d
JOIN historia h ON d.historia_id = h.id
ORDER BY d.historia_id, d.id;

-- ====================================
-- 4. VERIFICAR RELACIÓN CON PISTAS
-- ====================================
-- Esta consulta verifica que los pista_nombre coincidan con registros en la tabla pista
SELECT 
    d.historia_id,
    d.nombre AS documento,
    d.pista_nombre AS pista_a_registrar,
    CASE 
        WHEN p.id IS NOT NULL THEN '✓ EXISTE'
        WHEN d.pista_nombre IS NULL THEN '- SIN PISTA'
        ELSE '✗ NO ENCONTRADA'
    END AS estado_pista,
    p.nombre AS pista_real
FROM documento d
LEFT JOIN pista p ON d.historia_id = p.historia_id AND d.pista_nombre = p.nombre
WHERE d.codigo_correcto IS NOT NULL
ORDER BY d.historia_id;

-- ====================================
-- 5. VALIDAR INTEGRIDAD DE DATOS
-- ====================================
-- Documentos sin código pero con pista_nombre (error de configuración)
SELECT 'ADVERTENCIA: Documentos con pista pero sin código' AS problema, 
       d.id, d.nombre, d.pista_nombre
FROM documento d
WHERE d.codigo_correcto IS NULL AND d.pista_nombre IS NOT NULL;

-- Documentos con código pero sin pista_nombre (no se registrará nada)
SELECT 'ADVERTENCIA: Documentos con código pero sin pista' AS problema,
       d.id, d.nombre, d.codigo_correcto
FROM documento d
WHERE d.codigo_correcto IS NOT NULL AND (d.pista_nombre IS NULL OR d.pista_nombre = '');

-- Códigos duplicados en la misma historia (ambigüedad)
SELECT 'ERROR: Códigos duplicados en misma historia' AS problema,
       d.historia_id, d.codigo_correcto, COUNT(*) AS cantidad
FROM documento d
WHERE d.codigo_correcto IS NOT NULL
GROUP BY d.historia_id, d.codigo_correcto
HAVING COUNT(*) > 1;

-- Claves duplicadas en la misma historia (violación de constraint)
SELECT 'ERROR: Claves duplicadas en misma historia' AS problema,
       d.historia_id, d.clave, COUNT(*) AS cantidad
FROM documento d
GROUP BY d.historia_id, d.clave
HAVING COUNT(*) > 1;

-- ====================================
-- 6. PREVIEW DE CONTENIDOS
-- ====================================
-- Ver los primeros 100 caracteres del contenido de cada documento
SELECT 
    h.titulo AS historia,
    d.nombre AS documento,
    CONCAT(LEFT(d.contenido, 100), '...') AS preview
FROM documento d
JOIN historia h ON d.historia_id = h.id
ORDER BY d.historia_id, d.id;

-- ====================================
-- 7. ESTADÍSTICAS GENERALES
-- ====================================
SELECT 
    'Total documentos' AS metrica,
    COUNT(*) AS valor
FROM documento
UNION ALL
SELECT 
    'Documentos con código correcto',
    COUNT(*)
FROM documento
WHERE codigo_correcto IS NOT NULL
UNION ALL
SELECT 
    'Documentos vinculados a pistas',
    COUNT(*)
FROM documento
WHERE pista_nombre IS NOT NULL
UNION ALL
SELECT
    'Historias con documentos',
    COUNT(DISTINCT historia_id)
FROM documento;

-- ====================================
-- 8. TESTING: SIMULAR VALIDACIÓN DE CÓDIGO
-- ====================================
-- Historia 1 - Código correcto (7391)
SELECT 
    'TEST Historia 1: código 7391' AS test,
    CASE 
        WHEN COUNT(*) > 0 THEN '✓ PASA'
        ELSE '✗ FALLA'
    END AS resultado,
    MAX(d.pista_nombre) AS pista_registrada
FROM documento d
WHERE d.historia_id = 1 AND d.codigo_correcto = '7391';

-- Historia 1 - Código incorrecto (0000)
SELECT 
    'TEST Historia 1: código incorrecto 0000' AS test,
    CASE 
        WHEN COUNT(*) = 0 THEN '✓ PASA (rechazado correctamente)'
        ELSE '✗ FALLA (aceptó código inválido)'
    END AS resultado
FROM documento d
WHERE d.historia_id = 1 AND d.codigo_correcto = '0000';

-- Historia 2 - Código correcto (2580)
SELECT 
    'TEST Historia 2: código 2580' AS test,
    CASE 
        WHEN COUNT(*) > 0 THEN '✓ PASA'
        ELSE '✗ FALLA'
    END AS resultado,
    MAX(d.pista_nombre) AS pista_registrada
FROM documento d
WHERE d.historia_id = 2 AND d.codigo_correcto = '2580';

-- Historia 2 - Código incorrecto (7391 de historia 1)
SELECT 
    'TEST Historia 2: código de historia 1 (7391)' AS test,
    CASE 
        WHEN COUNT(*) = 0 THEN '✓ PASA (aislamiento correcto)'
        ELSE '✗ FALLA (no hay aislamiento entre historias)'
    END AS resultado
FROM documento d
WHERE d.historia_id = 2 AND d.codigo_correcto = '7391';

-- ====================================
-- 9. REPORTE FINAL
-- ====================================
SELECT '========================================' AS '';
SELECT '   RESUMEN DE VERIFICACIÓN' AS '';
SELECT '========================================' AS '';

SELECT 
    h.titulo AS Historia,
    COUNT(d.id) AS Documentos,
    MAX(d.codigo_correcto) AS Código,
    MAX(d.pista_nombre) AS Pista,
    CASE 
        WHEN MAX(d.codigo_correcto) IS NOT NULL 
         AND MAX(d.pista_nombre) IS NOT NULL 
         AND EXISTS(SELECT 1 FROM pista p 
                    WHERE p.historia_id = h.id 
                    AND p.nombre = MAX(d.pista_nombre))
        THEN '✓ CONFIGURADA'
        WHEN MAX(d.codigo_correcto) IS NULL
        THEN '- SIN CÓDIGO'
        ELSE '✗ ERROR CONFIG'
    END AS Estado
FROM historia h
LEFT JOIN documento d ON h.id = d.historia_id
WHERE h.activa = 1
GROUP BY h.id, h.titulo
ORDER BY h.id;

-- ====================================
-- 10. PRÓXIMOS PASOS
-- ====================================
/*
SI TODO ESTÁ ✓:
  1. Compilá el proyecto en Eclipse (Clean & Build)
  2. Iniciá el servidor
  3. Jugá una partida de la Historia 1 (código 7391)
  4. Jugá una partida de la Historia 2 (código 2580)

SI HAY ERRORES:
  - Revisá las advertencias arriba
  - Ejecutá las correcciones necesarias
  - Volvé a ejecutar este script
*/

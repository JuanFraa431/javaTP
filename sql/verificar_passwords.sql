-- ========================================
-- SCRIPT: Verificar y reparar contraseñas persistentes
-- ========================================
-- Este script ayuda a diagnosticar y solucionar problemas
-- con contraseñas que no persisten después de cambiarlas
-- ========================================

USE misterio_mansion;

-- 1. Verificar configuración de autocommit
SELECT @@autocommit;
-- Debería devolver 1 (habilitado)

-- 2. Verificar el motor de la tabla usuario
SHOW TABLE STATUS WHERE Name = 'usuario';
-- Debería ser InnoDB (soporta transacciones)

-- 3. Ver todos los usuarios y sus contraseñas (primeros 20 caracteres)
SELECT 
    id,
    nombre,
    email,
    LEFT(password, 20) as password_inicio,
    LENGTH(password) as password_length,
    activo,
    fecha_registro
FROM usuario
ORDER BY id;

-- 4. Verificar si alguna contraseña es texto plano (problema de seguridad)
SELECT 
    id,
    nombre,
    email,
    CASE 
        WHEN LENGTH(password) = 64 AND password REGEXP '^[0-9a-fA-F]+$' THEN 'SHA-256 (correcto)'
        ELSE 'TEXTO PLANO o FORMATO INCORRECTO (problema!)'
    END as password_format
FROM usuario;

-- 5. Habilitar autocommit explícitamente (por si estuviera deshabilitado)
SET autocommit = 1;

-- 6. Verificar privilegios del usuario de conexión
SHOW GRANTS FOR CURRENT_USER();

-- ========================================
-- REPARACIÓN: Si encontrás contraseñas en texto plano
-- ========================================

-- Si hay contraseñas en texto plano, necesitarás hashearlas manualmente.
-- Por ejemplo, para la contraseña "1234" (solo para testing):
-- UPDATE usuario SET password = SHA2('1234', 256) WHERE id = X;

-- ========================================
-- TEST: Cambiar contraseña de un usuario específico
-- ========================================

-- Para el usuario con ID 15 (ajustar según tu caso):
-- 1. Ver contraseña actual
SELECT id, nombre, email, LEFT(password, 20) as pwd_actual 
FROM usuario WHERE id = 15;

-- 2. Cambiar contraseña a "test123" (hasheada con SHA-256)
-- UPDATE usuario SET password = SHA2('test123', 256) WHERE id = 15;

-- 3. Verificar el cambio
-- SELECT id, nombre, email, LEFT(password, 20) as pwd_nueva 
-- FROM usuario WHERE id = 15;

-- 4. Probar login con email y contraseña "test123"

-- ========================================
-- VERIFICAR LOGS DE TRANSACCIONES
-- ========================================

-- Ver si hay transacciones pendientes o bloqueadas
SELECT * FROM information_schema.innodb_trx;

-- Ver bloqueos activos
SELECT * FROM information_schema.innodb_locks;

-- Ver esperas de bloqueos
SELECT * FROM information_schema.innodb_lock_waits;

-- ========================================
-- SOLUCIÓN MANUAL: Forzar commit de todas las transacciones
-- ========================================

-- Si hay problemas con transacciones:
COMMIT;
SET autocommit = 1;

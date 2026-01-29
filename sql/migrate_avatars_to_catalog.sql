-- ============================================================
-- Script: Migración de Avatares a Sistema de Catálogo
-- ============================================================
-- Este script actualiza el sistema de avatares para usar un
-- catálogo predefinido en lugar de uploads de usuarios.
-- 
-- IMPORTANTE: Este script convierte las rutas antiguas a nombres
-- de archivos del catálogo predefinido.
-- ============================================================

-- Ver avatares actuales
SELECT id, nombre, email, avatar 
FROM usuario 
WHERE avatar IS NOT NULL AND avatar != '';

-- Asignar avatares por defecto basados en el ID del usuario
-- Los usuarios sin avatar o con avatares rotos reciben uno aleatorio
UPDATE usuario 
SET avatar = CASE 
    WHEN id % 8 = 1 THEN 'avatar1.png'
    WHEN id % 8 = 2 THEN 'avatar2.png'
    WHEN id % 8 = 3 THEN 'avatar3.png'
    WHEN id % 8 = 4 THEN 'avatar4.png'
    WHEN id % 8 = 5 THEN 'avatar5.png'
    WHEN id % 8 = 6 THEN 'avatar6.png'
    WHEN id % 8 = 7 THEN 'avatar7.png'
    ELSE 'avatar8.png'
END
WHERE avatar IS NULL OR avatar = '' OR avatar LIKE 'avatars/%';

-- Verificar los cambios
SELECT id, nombre, email, avatar 
FROM usuario 
ORDER BY id;

-- ============================================================
-- Avatares disponibles en el sistema:
-- ============================================================
-- avatar1.png - Detective azul
-- avatar2.png - Detective rojo
-- avatar3.png - Detective verde
-- avatar4.png - Detective morado
-- avatar5.png - Detective naranja
-- avatar6.png - Detective turquesa
-- avatar7.png - Detective gris oscuro
-- avatar8.png - Detective naranja oscuro
-- ============================================================

-- Si necesitas asignar un avatar específico a un usuario:
-- UPDATE usuario SET avatar = 'avatar1.png' WHERE id = 1;


-- ============================================================
-- Script: Asignar Avatar por Defecto a Usuarios Sin Avatar
-- ============================================================
-- Este script limpia avatares inválidos.
-- El sistema asignará automáticamente el primer avatar 
-- disponible de la carpeta cuando el usuario visite su perfil.
-- ============================================================

-- Ver usuarios sin avatar o con avatares inválidos
SELECT id, nombre, email, avatar 
FROM usuario 
WHERE avatar IS NULL OR avatar = '' OR avatar LIKE 'avatars/%';

-- Limpiar avatares inválidos (dejar NULL para que el sistema asigne uno)
UPDATE usuario 
SET avatar = NULL
WHERE avatar = '' OR avatar LIKE 'avatars/%';

-- Verificar los cambios
SELECT id, nombre, email, avatar 
FROM usuario 
ORDER BY id;

-- ============================================================
-- NOTA: El sistema ahora escanea dinámicamente la carpeta 
-- /avatars y acepta cualquier formato: JPG, JPEG, PNG, GIF, WEBP
-- ============================================================

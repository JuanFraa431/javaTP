-- =====================================================================
-- Script: Agregar campo avatar a tabla usuario
-- Descripción: Agrega columna para almacenar la ruta del archivo de avatar
-- Fecha: 26 de Enero de 2026
-- =====================================================================

USE jugame_misterio;

-- Agregar columna avatar (ruta relativa del archivo)
ALTER TABLE usuario 
ADD COLUMN avatar VARCHAR(255) DEFAULT NULL 
AFTER activo;

-- Comentario descriptivo
ALTER TABLE usuario 
MODIFY COLUMN avatar VARCHAR(255) 
COMMENT 'Ruta del archivo de avatar del usuario (ej: avatars/123.jpg)';

-- Verificar que se agregó correctamente
DESCRIBE usuario;

-- Consulta de verificación
SELECT id, nombre, email, avatar 
FROM usuario 
LIMIT 5;

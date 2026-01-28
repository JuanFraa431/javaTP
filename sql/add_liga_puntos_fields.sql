-- ========================================
-- SCRIPT: Agregar campos de liga y puntos a tabla usuario
-- ========================================
-- Este script agrega los campos necesarios para persistir
-- la progresión de liga del jugador entre reinicios del servidor.
--
-- IMPORTANTE: Este script NO borra datos existentes.
-- Solo agrega los nuevos campos a la tabla usuario.
-- ========================================

USE misterio_mansion;

-- Agregar campos liga_actual y puntos_totales
ALTER TABLE usuario 
ADD COLUMN liga_actual VARCHAR(20) DEFAULT 'bronce' 
    COMMENT 'Liga actual del usuario: bronce, plata, oro, platino, diamante' 
    AFTER en_partida;

ALTER TABLE usuario 
ADD COLUMN puntos_totales INT DEFAULT 0 
    COMMENT 'Puntos acumulados totales (partidas + logros)' 
    AFTER liga_actual;

-- Crear índice para mejorar consultas por liga
ALTER TABLE usuario ADD INDEX idx_liga (liga_actual);

-- Actualizar usuarios existentes con su liga y puntos calculados
-- Esto calcula los puntos desde cero para todos los usuarios
UPDATE usuario u
SET 
    u.puntos_totales = (
        -- Sumar puntos de partidas ganadas
        IFNULL((SELECT SUM(p.puntuacion) 
                FROM partida p 
                WHERE p.usuario_id = u.id 
                  AND p.estado = 'GANADA'), 0)
        +
        -- Sumar puntos de logros desbloqueados
        IFNULL((SELECT SUM(l.puntos) 
                FROM usuario_logro ul
                JOIN logro l ON ul.logro_id = l.id
                WHERE ul.usuario_id = u.id), 0)
    ),
    u.liga_actual = CASE 
        WHEN (
            IFNULL((SELECT SUM(p.puntuacion) FROM partida p WHERE p.usuario_id = u.id AND p.estado = 'GANADA'), 0)
            +
            IFNULL((SELECT SUM(l.puntos) FROM usuario_logro ul JOIN logro l ON ul.logro_id = l.id WHERE ul.usuario_id = u.id), 0)
        ) >= 1000 THEN 'diamante'
        WHEN (
            IFNULL((SELECT SUM(p.puntuacion) FROM partida p WHERE p.usuario_id = u.id AND p.estado = 'GANADA'), 0)
            +
            IFNULL((SELECT SUM(l.puntos) FROM usuario_logro ul JOIN logro l ON ul.logro_id = l.id WHERE ul.usuario_id = u.id), 0)
        ) >= 601 THEN 'platino'
        WHEN (
            IFNULL((SELECT SUM(p.puntuacion) FROM partida p WHERE p.usuario_id = u.id AND p.estado = 'GANADA'), 0)
            +
            IFNULL((SELECT SUM(l.puntos) FROM usuario_logro ul JOIN logro l ON ul.logro_id = l.id WHERE ul.usuario_id = u.id), 0)
        ) >= 301 THEN 'oro'
        WHEN (
            IFNULL((SELECT SUM(p.puntuacion) FROM partida p WHERE p.usuario_id = u.id AND p.estado = 'GANADA'), 0)
            +
            IFNULL((SELECT SUM(l.puntos) FROM usuario_logro ul JOIN logro l ON ul.logro_id = l.id WHERE ul.usuario_id = u.id), 0)
        ) >= 101 THEN 'plata'
        ELSE 'bronce'
    END
WHERE u.rol = 'jugador';

-- Verificar resultados
SELECT 
    id,
    nombre,
    liga_actual,
    puntos_totales,
    (SELECT COUNT(*) FROM partida WHERE usuario_id = u.id AND estado = 'GANADA') AS partidas_ganadas,
    (SELECT COUNT(*) FROM usuario_logro WHERE usuario_id = u.id) AS logros_desbloqueados
FROM usuario u
WHERE rol = 'jugador'
ORDER BY puntos_totales DESC;

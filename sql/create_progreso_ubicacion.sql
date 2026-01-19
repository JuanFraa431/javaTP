-- Script para crear la tabla progreso_ubicacion
-- Registra las ubicaciones que cada partida ha visitado

CREATE TABLE IF NOT EXISTS progreso_ubicacion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    partida_id INT NOT NULL,
    ubicacion_id INT NOT NULL,
    fecha_visitada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (partida_id) REFERENCES partida(id) ON DELETE CASCADE,
    FOREIGN KEY (ubicacion_id) REFERENCES ubicacion(id) ON DELETE CASCADE,
    UNIQUE KEY unique_partida_ubicacion (partida_id, ubicacion_id),
    INDEX idx_partida (partida_id),
    INDEX idx_ubicacion (ubicacion_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Verificar que se creó correctamente
SELECT 'Tabla progreso_ubicacion creada correctamente' AS resultado;

-- Ver la estructura de la tabla
DESCRIBE progreso_ubicacion;

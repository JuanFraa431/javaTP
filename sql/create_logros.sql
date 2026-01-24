-- Tabla de logros disponibles en el juego
CREATE TABLE IF NOT EXISTS logro (
    id INT AUTO_INCREMENT PRIMARY KEY,
    clave VARCHAR(50) NOT NULL UNIQUE COMMENT 'Identificador único del logro (ej: primer_caso)',
    nombre VARCHAR(100) NOT NULL COMMENT 'Nombre del logro',
    descripcion VARCHAR(255) NOT NULL COMMENT 'Descripción del logro',
    icono VARCHAR(100) DEFAULT 'fa-solid fa-trophy' COMMENT 'Clase Font Awesome del icono',
    puntos INT DEFAULT 10 COMMENT 'Puntos que otorga el logro',
    activo TINYINT(1) DEFAULT 1 COMMENT '1=activo, 0=inactivo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de relación: qué usuarios tienen qué logros
CREATE TABLE IF NOT EXISTS usuario_logro (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    logro_id INT NOT NULL,
    fecha_obtencion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE,
    FOREIGN KEY (logro_id) REFERENCES logro(id) ON DELETE CASCADE,
    UNIQUE KEY unique_usuario_logro (usuario_id, logro_id),
    INDEX idx_usuario (usuario_id),
    INDEX idx_logro (logro_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertar logros iniciales
INSERT INTO logro (clave, nombre, descripcion, icono, puntos) VALUES
('primer_caso', 'Primer Caso Resuelto', 'Resolvé tu primer misterio exitosamente', 'fa-solid fa-star', 10),
('detective_novato', 'Detective Novato', 'Completá 3 casos diferentes', 'fa-solid fa-medal', 20),
('detective_experto', 'Detective Experto', 'Completá 10 casos sin errores', 'fa-solid fa-crown', 50),
('perfeccionista', 'Perfeccionista', 'Ganá un caso con puntuación perfecta (100 puntos)', 'fa-solid fa-gem', 30),
('coleccionista', 'Coleccionista de Pistas', 'Encontrá todas las pistas en 5 casos diferentes', 'fa-solid fa-lightbulb', 25),
('explorador', 'Explorador Incansable', 'Visitá todas las ubicaciones en 3 historias', 'fa-solid fa-map-marked-alt', 20),
('velocista', 'Velocista', 'Resolvé un caso en menos de 10 minutos', 'fa-solid fa-bolt', 15),
('persistente', 'Persistente', 'Completá un caso después de fallar 2 intentos', 'fa-solid fa-heart', 15),
('madrugador', 'Madrugador', 'Iniciá una partida entre las 5am y 7am', 'fa-solid fa-sun', 5),
('nocturno', 'Detective Nocturno', 'Resolvé un caso entre las 12am y 3am', 'fa-solid fa-moon', 10);

-- Verificar la creación
SELECT 'Tablas de logros creadas correctamente' AS resultado;
SELECT COUNT(*) AS total_logros FROM logro;

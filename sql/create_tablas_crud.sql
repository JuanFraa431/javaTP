-- Script para crear las tablas necesarias para los CRUDs de Personaje, Pista, Ubicacion
-- Ejecutar en MySQL después de crear la base de datos

-- Tabla personaje
CREATE TABLE IF NOT EXISTS personaje (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT NOT NULL,
    coartada TEXT,
    motivo TEXT,
    sospechoso TINYINT(1) DEFAULT 0,
    culpable TINYINT(1) DEFAULT 0,
    historia_id INT NOT NULL,
    FOREIGN KEY (historia_id) REFERENCES historia(id) ON DELETE CASCADE,
    INDEX idx_historia (historia_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla ubicacion
CREATE TABLE IF NOT EXISTS ubicacion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT NOT NULL,
    accesible TINYINT(1) DEFAULT 1,
    imagen VARCHAR(200),
    historia_id INT NOT NULL,
    FOREIGN KEY (historia_id) REFERENCES historia(id) ON DELETE CASCADE,
    INDEX idx_historia (historia_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla pista (actualizada con nuevos campos)
-- Si ya existe, primero elimínala: DROP TABLE IF EXISTS pista;
CREATE TABLE IF NOT EXISTS pista (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT NOT NULL,
    contenido TEXT,
    crucial TINYINT(1) DEFAULT 0,
    importancia ENUM('baja', 'media', 'alta') DEFAULT 'media',
    ubicacion_id INT,
    personaje_id INT,
    historia_id INT NOT NULL,
    FOREIGN KEY (ubicacion_id) REFERENCES ubicacion(id) ON DELETE SET NULL,
    FOREIGN KEY (personaje_id) REFERENCES personaje(id) ON DELETE SET NULL,
    FOREIGN KEY (historia_id) REFERENCES historia(id) ON DELETE CASCADE,
    INDEX idx_historia (historia_id),
    INDEX idx_ubicacion (ubicacion_id),
    INDEX idx_personaje (personaje_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Verificación
SELECT 'Tablas creadas correctamente' AS resultado;

-- Verificar estructura de las tablas
SHOW TABLES LIKE '%personaje%';
SHOW TABLES LIKE '%ubicacion%';
SHOW TABLES LIKE '%pista%';

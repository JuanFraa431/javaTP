-- Agregar campo de liga mínima requerida a las historias
ALTER TABLE historia 
ADD COLUMN liga_minima VARCHAR(20) DEFAULT 'bronce' 
COMMENT 'Liga mínima requerida: bronce, plata, oro, platino, diamante';

-- Actualizar historias existentes con requisitos de liga
-- (Ajustá según tus historias actuales)
UPDATE historia SET liga_minima = 'bronce' WHERE id <= 2;
UPDATE historia SET liga_minima = 'plata' WHERE id = 3;
UPDATE historia SET liga_minima = 'oro' WHERE id = 4;
UPDATE historia SET liga_minima = 'platino' WHERE id >= 5;

-- Verificar
SELECT id, titulo, liga_minima FROM historia ORDER BY id;

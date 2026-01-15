-- ============================================================
-- Script SQL: Tabla de Documentos Dinámicos por Historia
-- ============================================================
-- Este script crea la tabla 'documento' y carga los documentos
-- para las historias 1 (Código de la computadora - 7391) y 
-- historia 2 (Código del celular - 2580).
-- ============================================================

-- Crear tabla documento
CREATE TABLE IF NOT EXISTS documento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    historia_id INT NOT NULL,
    clave VARCHAR(50) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    icono VARCHAR(100) DEFAULT 'fa-regular fa-file-lines',
    contenido TEXT NOT NULL,
    codigo_correcto VARCHAR(20) NULL,
    pista_nombre VARCHAR(100) NULL,
    CONSTRAINT fk_documento_historia FOREIGN KEY (historia_id) 
        REFERENCES historia(id) ON DELETE CASCADE,
    CONSTRAINT uk_documento_historia_clave UNIQUE (historia_id, clave)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- HISTORIA 1: Misterio en la Mansión Watson
-- Código correcto: 7391 (Código de la computadora)
-- ============================================================

INSERT INTO documento (historia_id, clave, nombre, icono, contenido, codigo_correcto, pista_nombre) VALUES
(1, 'nota_codigo', 'Nota manuscrita: "Cómo descifrar el código"', 'fa-regular fa-file-lines', 
 '<h3>Nota manuscrita</h3>
  <p>No mires números… Escuchá sus <strong>nombres</strong> en castellano y tomá la <em>primera letra</em> de cada uno.</p>
  <p>Ej: <em>Siete</em>, <em>Tres</em>, <em>Nueve</em>, <em>Uno</em> → <code>STNU</code>… ¿o quizá <strong>7-3-9-1</strong>?</p>',
 '7391', 'Código de la computadora'),

(1, 'correo_sospechoso', 'Correo sospechoso: "El código está oculto"', 'fa-regular fa-envelope',
 '<h3>Correo sospechoso</h3>
  <p><strong>Asunto:</strong> "No abras la computadora"</p>
  <p><strong>Mensaje:</strong> "Si alguien descifra <em>Siete Tres Nueve Uno</em>, podrá ver todo."</p>',
 NULL, NULL);

-- ============================================================
-- HISTORIA 2: El Enigma del Hotel Riverside
-- Código correcto: 2580 (Código del celular)
-- ============================================================

INSERT INTO documento (historia_id, clave, nombre, icono, contenido, codigo_correcto, pista_nombre) VALUES
(2, 'diario_victima', 'Diario de la víctima', 'fa-regular fa-book',
 '<h3>Diario de la víctima</h3>
  <p><strong>Última entrada:</strong> "Cambié mi código del celular por algo que nunca olvidaré..."</p>
  <p>"La habitación donde todo comenzó... <em>Dos-Cinco-Ocho-Cero</em>. Ahí está la clave."</p>
  <p><em>Nota al margen:</em> "Si me pasa algo, revisen mi teléfono."</p>',
 '2580', 'Código del celular'),

(2, 'nota_recepcion', 'Nota de recepción del hotel', 'fa-regular fa-note-sticky',
 '<h3>Nota de recepción</h3>
  <p><strong>Recepcionista:</strong> "El huésped de la habitación <strong>2580</strong> solicitó cambiar su PIN del celular"</p>
  <p>"Dijo que lo cambiaría por el número de su habitación favorita para no olvidarlo."</p>
  <p><strong>Fecha:</strong> 3 días antes del incidente</p>',
 NULL, NULL),

(2, 'mensaje_celular', 'Mensaje en el celular bloqueado', 'fa-solid fa-mobile-screen-button',
 '<h3>Mensaje visible en la pantalla</h3>
  <p style="text-align:center; font-size:1.2em; border: 2px solid #666; padding:20px; background:#f0f0f0; border-radius:10px;">
    <strong>📱 Celular bloqueado</strong><br/>
    <em>Ingrese PIN para desbloquear</em><br/>
    <small style="color:#888;">Pista: Número de habitación memorable</small>
  </p>
  <p><strong>Pregunta de seguridad:</strong> "¿Cuál es tu habitación favorita?"</p>',
 NULL, NULL);

-- ============================================================
-- Verificar los datos insertados
-- ============================================================

-- Ver todos los documentos de la Historia 1
SELECT d.id, d.clave, d.nombre, d.codigo_correcto, d.pista_nombre
FROM documento d
WHERE d.historia_id = 1;

-- Ver todos los documentos de la Historia 2
SELECT d.id, d.clave, d.nombre, d.codigo_correcto, d.pista_nombre
FROM documento d
WHERE d.historia_id = 2;

-- ============================================================
-- NOTAS IMPORTANTES:
-- ============================================================
-- 1. El campo 'codigo_correcto' solo se llena en UN documento por historia
--    (el que contiene la solución del misterio)
-- 
-- 2. El campo 'pista_nombre' debe coincidir EXACTAMENTE con el nombre
--    de la pista en la tabla 'pista' para que se registre correctamente
--    
-- 3. Si querés agregar una nueva historia, simplemente insertá nuevos
--    documentos con el historia_id correspondiente
--
-- 4. Para actualizar el contenido de un documento:
--    UPDATE documento SET contenido = 'nuevo html' WHERE id = X;
--
-- 5. El campo 'icono' usa clases de Font Awesome 6.5:
--    - fa-regular fa-file-lines (archivo de texto)
--    - fa-regular fa-envelope (sobre/correo)
--    - fa-regular fa-note-sticky (post-it)
--    - fa-regular fa-book (libro/diario)
--    - fa-solid fa-mobile-screen-button (celular)
--    - fa-regular fa-folder-open (carpeta)
-- ============================================================

-- Datos de ejemplo para las tablas personaje, ubicacion y pista
-- Asume que ya existen historias con id 1 y 2

-- ==============================
-- PERSONAJES para Historia 1
-- ==============================
INSERT INTO personaje (nombre, descripcion, coartada, motivo, sospechoso, culpable, historia_id) VALUES
('Mayordomo James', 'El mayordomo leal de la familia durante 30 años', 'Estaba sirviendo la cena en el comedor', 'Ninguno aparente', 1, 0, 1),
('Lady Victoria', 'La heredera de la mansión', 'En su habitación leyendo', 'Herencia familiar', 1, 0, 1),
('Doctor Harrison', 'Médico de la familia', 'Atendiendo una emergencia en el pueblo', 'Deudas de juego', 1, 1, 1),
('Chef Marcel', 'Cocinero francés recién contratado', 'Preparando el postre en la cocina', 'Despido inminente', 1, 0, 1);

-- ==============================
-- PERSONAJES para Historia 2
-- ==============================
INSERT INTO personaje (nombre, descripcion, coartada, motivo, sospechoso, culpable, historia_id) VALUES
('Inspector Blackwood', 'Detective privado retirado', 'Investigando en su despacho', 'Secreto del pasado', 1, 0, 2),
('Señora Hawthorne', 'Dueña de la posada', 'Atendiendo a otros huéspedes', 'Venganza antigua', 1, 1, 2),
('Profesor Whitmore', 'Académico especialista en arte', 'En la biblioteca revisando libros antiguos', 'Robo de obra de arte', 1, 0, 2);

-- ==============================
-- UBICACIONES para Historia 1
-- ==============================
INSERT INTO ubicacion (nombre, descripcion, accesible, imagen, historia_id) VALUES
('Biblioteca', 'Gran sala llena de libros antiguos y una chimenea', 1, '/images/biblioteca.jpg', 1),
('Comedor Principal', 'Amplio comedor con una larga mesa de roble', 1, '/images/comedor.jpg', 1),
('Habitación del Mayordomo', 'Pequeña habitación en el ala de servicio', 1, NULL, 1),
('Cocina', 'Cocina industrial con utensilios profesionales', 1, '/images/cocina.jpg', 1),
('Bodega', 'Sótano oscuro con vinos antiguos', 0, NULL, 1),
('Jardín', 'Extensos jardines con estatuas', 1, '/images/jardin.jpg', 1);

-- ==============================
-- UBICACIONES para Historia 2
-- ==============================
INSERT INTO ubicacion (nombre, descripcion, accesible, imagen, historia_id) VALUES
('Recepción de la Posada', 'Recepción acogedora con chimenea', 1, '/images/recepcion.jpg', 2),
('Habitación 7', 'Habitación donde ocurrió el incidente', 1, NULL, 2),
('Salón de Lectura', 'Pequeño salón con sillones y estanterías', 1, '/images/salon.jpg', 2),
('Sótano', 'Sótano húmedo y mal iluminado', 0, NULL, 2);

-- ==============================
-- PISTAS para Historia 1
-- ==============================
-- Primero obtener IDs de ubicaciones y personajes
SET @biblioteca_id = (SELECT id FROM ubicacion WHERE nombre = 'Biblioteca' AND historia_id = 1 LIMIT 1);
SET @comedor_id = (SELECT id FROM ubicacion WHERE nombre = 'Comedor Principal' AND historia_id = 1 LIMIT 1);
SET @cocina_id = (SELECT id FROM ubicacion WHERE nombre = 'Cocina' AND historia_id = 1 LIMIT 1);
SET @bodega_id = (SELECT id FROM ubicacion WHERE nombre = 'Bodega' AND historia_id = 1 LIMIT 1);

SET @mayordomo_id = (SELECT id FROM personaje WHERE nombre = 'Mayordomo James' AND historia_id = 1 LIMIT 1);
SET @doctor_id = (SELECT id FROM personaje WHERE nombre = 'Doctor Harrison' AND historia_id = 1 LIMIT 1);
SET @chef_id = (SELECT id FROM personaje WHERE nombre = 'Chef Marcel' AND historia_id = 1 LIMIT 1);

INSERT INTO pista (nombre, descripcion, contenido, crucial, importancia, ubicacion_id, personaje_id, historia_id) VALUES
('Carta Misteriosa', 'Una carta encontrada en la biblioteca', 'Carta amenazadora dirigida a la víctima', 1, 'alta', @biblioteca_id, NULL, 1),
('Copa de Vino', 'Copa con residuos sospechosos', 'Análisis revela rastros de veneno', 1, 'alta', @comedor_id, @doctor_id, 1),
('Llave Oxidada', 'Llave antigua encontrada', 'Abre la puerta de la bodega', 0, 'media', @bodega_id, @mayordomo_id, 1),
('Receta Alterada', 'Receta del Chef con anotaciones', 'Ingredientes marcados con extrañas notas', 0, 'baja', @cocina_id, @chef_id, 1),
('Testamento', 'Documento legal reciente', 'Cambios benefician a un heredero inesperado', 1, 'alta', @biblioteca_id, NULL, 1);

-- ==============================
-- PISTAS para Historia 2
-- ==============================
SET @recepcion_id = (SELECT id FROM ubicacion WHERE nombre = 'Recepción de la Posada' AND historia_id = 2 LIMIT 1);
SET @habitacion7_id = (SELECT id FROM ubicacion WHERE nombre = 'Habitación 7' AND historia_id = 2 LIMIT 1);
SET @salon_id = (SELECT id FROM ubicacion WHERE nombre = 'Salón de Lectura' AND historia_id = 2 LIMIT 1);

SET @inspector_id = (SELECT id FROM personaje WHERE nombre = 'Inspector Blackwood' AND historia_id = 2 LIMIT 1);
SET @senora_id = (SELECT id FROM personaje WHERE nombre = 'Señora Hawthorne' AND historia_id = 2 LIMIT 1);

INSERT INTO pista (nombre, descripcion, contenido, crucial, importancia, ubicacion_id, personaje_id, historia_id) VALUES
('Diario Personal', 'Diario encontrado en la habitación', 'Entradas revelan conflictos pasados', 1, 'alta', @habitacion7_id, NULL, 2),
('Fotografía Antigua', 'Foto de hace 20 años', 'Muestra una conexión inesperada entre personajes', 1, 'alta', @salon_id, @inspector_id, 2),
('Registro de Huéspedes', 'Libro de registro de la posada', 'Nombre falso en el registro', 0, 'media', @recepcion_id, @senora_id, 2),
('Nota Cifrada', 'Mensaje en código', 'Una vez descifrado, revela el móvil del crimen', 1, 'alta', @habitacion7_id, NULL, 2);

-- Verificación
SELECT 'Datos de ejemplo insertados correctamente' AS resultado;

SELECT COUNT(*) as total_personajes FROM personaje;
SELECT COUNT(*) as total_ubicaciones FROM ubicacion;
SELECT COUNT(*) as total_pistas FROM pista;

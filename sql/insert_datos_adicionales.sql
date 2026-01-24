-- ========================================
-- DATOS ADICIONALES PARA BASE DE DATOS
-- Misterio en la Mansión
-- ========================================

-- ==============================
-- USUARIOS ADICIONALES
-- ==============================
-- Nota: password en SHA-256 (hasheadas con el mismo método de UsuarioDAO)
INSERT INTO usuario (nombre, email, password, rol, activo) VALUES
('Carlos Mendoza', 'carlos.mendoza@mail.com', 'e10adc3949ba59abbe56e057f20f883e', 'jugador', 1),  -- pass: 123456 (md5 legacy)
('María López', 'maria.lopez@mail.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'jugador', 1),      -- pass: password
('Pedro Sánchez', 'pedro.sanchez@mail.com', '25d55ad283aa400af464c76d713c07ad', 'jugador', 1),   -- pass: 12345678
('Ana Ramírez', 'ana.ramirez@mail.com', 'e10adc3949ba59abbe56e057f20f883e', 'jugador', 1),       -- pass: 123456
('Luis Torres', 'luis.torres@mail.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'jugador', 1);       -- pass: password

-- ==============================
-- HISTORIAS ADICIONALES
-- ==============================
INSERT INTO historia (titulo, descripcion, contexto, activa, dificultad, tiempo_estimado, liga_minima) VALUES
('El Secreto del Reloj Antiguo', 
 'Un valioso reloj desaparece de una subasta de antigüedades. Las pistas apuntan a que el ladrón aún está en el edificio.',
 'Estás en una prestigiosa casa de subastas donde acaba de desaparecer un reloj antiguo valorado en millones. El edificio está cerrado y nadie puede salir. Tienes que identificar al culpable antes de que destruya la evidencia.',
 1, 2, 45, 'bronce'),

('La Conspiración del Teatro', 
 'El director de un teatro es encontrado inconsciente en su camerino. Múltiples sospechosos con motivos oscuros.',
 'El famoso director de teatro Augusto Bellini fue encontrado inconsciente en su camerino justo antes del estreno de su nueva obra. Entre los actores, el productor y la crítica teatral, todos parecen tener razones para querer silenciarlo.',
 1, 3, 60, 'plata'),

('Muerte en el Expreso Nocturno',
 'Un asesinato en un tren de lujo. Los pasajeros son sospechosos y el tren no puede detenerse hasta la próxima estación.',
 'Viajás en el Expreso del Este, un tren de lujo, cuando se descubre un cuerpo en uno de los vagones. Con la tormenta de nieve afuera, el tren no puede detenerse. Tenés que resolver el caso antes de llegar a la siguiente estación en 2 horas.',
 1, 4, 75, 'oro'),

('El Enigma de la Galería Oscura',
 'Una serie de robos en una galería de arte. Los ladrones dejaron mensajes cifrados en cada escena del crimen.',
 'La Galería Monet ha sufrido tres robos en el último mes. Cada robo fue meticulosamente planeado y el ladrón dejó pistas cifradas. Sos el último recurso antes de que roben la pieza más valiosa de la colección.',
 1, 5, 90, 'platino');

-- ==============================
-- PERSONAJES PARA: El Secreto del Reloj Antiguo
-- ==============================
INSERT INTO personaje (nombre, descripcion, coartada, motivo, sospechoso, culpable, historia_id) VALUES
('Sra. Elizabeth Moore', 'Coleccionista rica y exigente', 'Estaba en el salón principal admirando otras piezas', 'Codicia - quería el reloj para su colección privada', 1, 0, 
    (SELECT id FROM historia WHERE titulo='El Secreto del Reloj Antiguo' LIMIT 1)),
('Sr. Thomas Baker', 'Subastador veterano', 'Estaba en su oficina revisando documentos', 'Deudas de juego - planeaba vender el reloj en el mercado negro', 1, 1, 
    (SELECT id FROM historia WHERE titulo='El Secreto del Reloj Antiguo' LIMIT 1)),
('Dra. Sophie Laurent', 'Historiadora especialista en relojes antiguos', 'En el baño cuando ocurrió el robo', 'Preservación histórica - creía que el reloj no debía venderse', 1, 0, 
    (SELECT id FROM historia WHERE titulo='El Secreto del Reloj Antiguo' LIMIT 1)),
('Marcus Webb', 'Guardia de seguridad', 'Haciendo su ronda en el segundo piso', 'Ninguno aparente', 1, 0, 
    (SELECT id FROM historia WHERE titulo='El Secreto del Reloj Antiguo' LIMIT 1)),
('Isabella Chen', 'Asistente del subastador', 'Atendiendo llamadas en recepción', 'Venganza - fue despedida hace un mes', 1, 0, 
    (SELECT id FROM historia WHERE titulo='El Secreto del Reloj Antiguo' LIMIT 1));

-- ==============================
-- UBICACIONES PARA: El Secreto del Reloj Antiguo
-- ==============================
INSERT INTO ubicacion (nombre, descripcion, accesible, imagen, historia_id) VALUES
('Salón Principal de Subasta', 'Gran salón con sillas dispuestas frente al estrado', 1, NULL, 
    (SELECT id FROM historia WHERE titulo='El Secreto del Reloj Antiguo' LIMIT 1)),
('Oficina del Subastador', 'Oficina elegante con escritorio de caoba', 1, NULL, 
    (SELECT id FROM historia WHERE titulo='El Secreto del Reloj Antiguo' LIMIT 1)),
('Sala de Exposición', 'Vitrinas iluminadas con las piezas a subastar', 1, NULL, 
    (SELECT id FROM historia WHERE titulo='El Secreto del Reloj Antiguo' LIMIT 1)),
('Almacén de Antigüedades', 'Depósito con piezas catalogadas', 0, NULL, 
    (SELECT id FROM historia WHERE titulo='El Secreto del Reloj Antiguo' LIMIT 1)),
('Vestíbulo Principal', 'Entrada con recepción
-- ==============================
INSERT INTO personaje (nombre, descripcion, coartada, motivo, sospechoso, culpable, historia_id) VALUES
('Valentina Rossi', 'Actriz principal', 'Ensayando su monólogo en el escenario', 'Celos profesionales - Bellini la reemplazaría', 1, 0, 
    (SELECT id FROM historia WHERE titulo='La Conspiración del Teatro' LIMIT 1)),
('Ricardo Fontana', 'Actor secundario y rival', 'En su camerino preparándose', 'Venganza - Bellini arruinó su carrera años atrás', 1, 1, 
    (SELECT id FROM historia WHERE titulo='La Conspiración del Teatro' LIMIT 1)),
('Lucía Moretti', 'Crítica teatral temida', 'En la platea tomando notas', 'Chantaje - Bellini tenía información comprometedora', 1, 0, 
    (SELECT id FROM historia WHERE titulo='La Conspiración del Teatro' LIMIT 1)),
('Giovanni Esposito', 'Productor del teatro', 'Reunión con inversionistas en la oficina', 'Dinero - Bellini descubrió malversación de fondos', 1, 0, 
    (SELECT id FROM historia WHERE titulo='La Conspiración del Teatro' LIMIT 1)),
('Carla Benedetti', 'Diseñadora de vestuario', 'En el taller cosiendo trajes', 'Pasión - relación secreta que terminó mal', 1, 0, 
    (SELECT id FROM historia WHERE titulo='La Conspiración del Teatro' LIMIT 1)
INSERT INTO personaje (nombre, descripcion, coartada, motivo, sospechoso, culpable, historia_id) VALUES
('Valentina Rossi', 'Actriz principal', 'Ensayando su monólogo en el escenario', 'Celos profesionales - Bellini la reemplazaría', 1, 0, 4),
('Ricardo Fontana', 'Actor secundario y rival', 'En su camerino preparándose', 'Venganza - Bellini arruinó su carrera años atrás', 1, 1, 4),
('Lucía Moretti', 'Crítica teatral temida', 'En la platea tomando notas', 'Chantaje - Bellini tenía información comprometedora', 1, 0, 4),
('Giovanni Esposito', 'Productor del teatro', 'Reunión con inversionistas en la oficina', 'Dinero - Bellini descubrió malversación de fondos', 1, 0, 4),
('Carla Benedetti', 'Diseñadora de vestuario', 'En el taller cosiendo trajes', 'Pasión - relación secreta que terminó mal', 1, 0, 4);

    (SELECT id FROM historia WHERE titulo='La Conspiración del Teatro' LIMIT 1)),
('Camerino del Director', 'Camerino privado donde se encontró al director', 1, NULL, 
    (SELECT id FROM historia WHERE titulo='La Conspiración del Teatro' LIMIT 1)),
('Platea', 'Área de asientos con excelente vista al escenario', 1, NULL, 
    (SELECT id FROM historia WHERE titulo='La Conspiración del Teatro' LIMIT 1)),
('Taller de Vestuario', 'Habitación llena de telas y máquinas de coser', 1, NULL, 
    (SELECT id FROM historia WHERE titulo='La Conspiración del Teatro' LIMIT 1)),
('Oficina de Producción', 'Oficina con archivos f
-- ==============================
INSERT INTO personaje (nombre, descripcion, coartada, motivo, sospechoso, culpable, historia_id) VALUES
('Coronel Montgomery', 'Militar retirado con pasado turbio', 'En el vagón comedor cenando', 'Silenciar testigo - la víctima conocía crímenes de guerra', 1, 1, 
    (SELECT id FROM historia WHERE titulo='Muerte en el Expreso Nocturno' LIMIT 1)),
('Lady Catherine Ashford', 'Aristócrata empobrecida', 'Leyendo en su compartimento', 'Herencia - la víctima le debía dinero', 1, 0, 
    (SELECT id FROM historia WHERE titulo='Muerte en el Expreso Nocturno' LIMIT 1)),
('Dr. Heinrich Braun', 'Científico alemán misterioso', 'Trabajando en su laboratorio portátil', 'Secretos industriales - competencia empresarial', 1, 0, 
    (SELECT id FROM historia WHERE titulo='Muerte en el Expreso Nocturno' LIMIT 1)),
('Señora Dubois', 'Viuda francesa elegante', 'Durmiendo en su cabina', 'Ninguno aparente', 0, 0, 
    (SELECT id FROM historia WHERE titulo='Muerte en el Expreso Nocturno' LIMIT 1)),
('Inspector Pavel Ivanov', 'Detective ruso', 'Investigando discretamente', 'Justicia - perseguía a la víctima por crímenes antiguos', 1, 0, 
    (SELECT id FROM historia WHERE titulo='Muerte en el Expreso Nocturno' LIMIT 1)
('Sótano del Teatro', 'Área de almacenamiento con utilería antigua', 0, NULL, 4);

-- ==============================
-- PERSONAJES PARA: Muerte en el Expreso Nocturno (Historia 5)
-- ==============================
INSERT INTO personaje (nombre, descripcion, coartada, motivo, sospechoso, 
    (SELECT id FROM historia WHERE titulo='Muerte en el Expreso Nocturno' LIMIT 1)),
('Compartimento de la Víctima', 'Escena del crimen, compartimento de primera clase', 1, NULL, 
    (SELECT id FROM historia WHERE titulo='Muerte en el Expreso Nocturno' LIMIT 1)),
('Vagón Panorámico', 'Vagón con ventanas amplias para ver el paisaje', 1, NULL, 
    (SELECT id FROM historia WHERE titulo='Muerte en el Expreso Nocturno' LIMIT 1)),
('Compartimento del Coronel', 'Compartimento militarmente ordenado', 1, NULL, 
    (SELECT id FROM historia WHERE titulo='Muerte en el Expreso Nocturno' LIMIT 1)),
('Vagón de Equipaje', 'Área de almacenamiento de m
-- ==============================
INSERT INTO personaje (nombre, descripcion, coartada, motivo, sospechoso, culpable, historia_id) VALUES
('Alexandre Monet', 'Dueño de la galería, descendiente del pintor', 'En su oficina durante los robos', 'Fraude de seguros - galería en quiebra', 1, 0, 
    (SELECT id FROM historia WHERE titulo='El Enigma de la Galería Oscura' LIMIT 1)),
('Isabelle Noir', 'Curadora de arte con reputación impecable', 'Catalogando obras en el archivo', 'Venganza artística - robos selectivos por motivos éticos', 1, 1, 
    (SELECT id FROM historia WHERE titulo='El Enigma de la Galería Oscura' LIMIT 1)),
('Viktor Kozlov', 'Coleccionista ruso con contactos oscuros', 'Fuera del país según pasaporte', 'Mercado negro - encargó los robos', 1, 0, 
    (SELECT id FROM historia WHERE titulo='El Enigma de la Galería Oscura' LIMIT 1)),
('Emma Richardson', 'Restauradora de arte', 'Trabajando en el taller de restauración', 'Obsesión - quiere poseer las obras para estudio personal', 1, 0, 
    (SELECT id FROM historia WHERE titulo='El Enigma de la Galería Oscura' LIMIT 1)),
('Detective Sarah Blake', 'Detective asignada al caso', 'Investigando en la escena', 'Ninguno - está ayudando', 0, 0, 
    (SELECT id FROM historia WHERE titulo='El Enigma de la Galería Oscura' LIMIT 1)
INSERT INTO ubicacion (nombre, descripcion, accesible, imagen, historia_id) VALUES
('Vagón Comedor', 'Elegante comedor con mesas de mantel blanco', 1, NULL, 5),
('Compartimento de la Víctima', 'Escena del crimen, compartimento de primera clase', 1, NULL, 5),
('Vagón Panorámico', 'Vagón con ventanas amplias para ver el paisaje', 1, NULL, 5),
('Compartimento del Coronel', 'Compartimento militarmente ordenado', 1, NULL, 5),
('Vagón de Equipaje', 'Área de almacenamiento de maletas', 0, NULL, 5),
('Cabina del Maquinista', 'Cabina de control del tren', 0, NULL, 5);
    (SELECT id FROM historia WHERE titulo='El Enigma de la Galería Oscura' LIMIT 1)),
('Taller de Restauración', 'Laboratorio con equipos especializados', 1, NULL, 
    (SELECT id FROM historia WHERE titulo='El Enigma de la Galería Oscura' LIMIT 1)),
('Archivo de Obras', 'Bóveda climatizada con catálogos', 1, NULL, 
    (SELECT id FROM historia WHERE titulo='El Enigma de la Galería Oscura' LIMIT 1)),
('Oficina del Director', 'Despacho elegante con vista a la sala', 1, NULL, 
    (SELECT id FROM historia WHERE titulo='El Enigma de la Galería Oscura' LIMIT 1)),
('Bóveda de Seguridad', 'Sala acorazada donde se guardan las obras más valiosas', 0, NULL, 
    (SELECT id FROM historia WHERE titulo='El Enigma de la Galería Oscura' LIMIT 1)),
('Sistema de Ventilación', 'Acceso a los conductos del edificio', 0, NULL, 
    (SELECT id FROM his: El Secreto del Reloj Antiguo
INSERT INTO pista (nombre, descripcion, contenido, crucial, importancia, ubicacion_id, personaje_id, historia_id) VALUES
('Video de Seguridad', 'Grabación de la cámara del pasillo', 'Muestra movimiento sospechoso cerca de la oficina', 1, 'alta', 
    (SELECT u.id FROM ubicacion u JOIN historia h ON u.historia_id=h.id WHERE u.nombre='Vestíbulo Principal' AND h.titulo='El Secreto del Reloj Antiguo' LIMIT 1),
    (SELECT p.id FROM personaje p JOIN historia h ON p.historia_id=h.id WHERE p.nombre='Sr. Thomas Baker' AND h.titulo='El Secreto del Reloj Antiguo' LIMIT 1), 
    (SELECT id FROM historia WHERE titulo='El Secreto del Reloj Antiguo' LIMIT 1)),
    
('Ticket de Apuestas', 'Ticket de casino encontrado', 'Deuda de $50,000 a nombre del subastador', 1, 'alta',
    (SELECT u.id FROM ubicacion u JOIN historia h ON u.historia_id=h.id WHERE u.nombre='Oficina del Subastador' AND h.titulo='El Secreto del Reloj Antiguo' LIMIT 1),
    (SELECT p.id FROM personaje p JOIN historia h ON p.historia_id=h.id WHERE p.nombre='Sr. Thomas Baker' AND h.titulo='El Secreto del Reloj Antiguo' LIMIT 1), 
    (SELECT id FROM historia WHERE titulo='El Secreto del Reloj Antiguo' LIMIT 1)),
    
('Llave Maestra', 'Llave del almacén', 'Acceso no autorizado al depósito', 0, 'media',
    (SELECT u.id FROM ubicacion u JOIN historia h ON u.historia_id=h.id WHERE u.nombre='Almacén de Antigüedades' AND h.titulo='El Secreto del Reloj Antiguo' LIMIT 1), 
    NULL, 
    (SELECT id FROM historia WHERE titulo='El Secreto del Reloj Antiguo' LIMIT 1)
('Taller de Restauración', 'Laboratorio con equipos especializados', 1, NULL, 6),
('Archivo de Obras', 'Bóveda climatizada con catálogos', 1, NULL, 6),
('Oficina del Director': La Conspiración del Teatro
INSERT INTO pista (nombre, descripcion, contenido, crucial, importancia, ubicacion_id, personaje_id, historia_id) VALUES
('Carta Anónima', 'Amenaza encontrada en el camerino', 'Carta amenazante con recortes de periódico', 1, 'alta',
    (SELECT u.id FROM ubicacion u JOIN historia h ON u.historia_id=h.id WHERE u.nombre='Camerino del Director' AND h.titulo='La Conspiración del Teatro' LIMIT 1), 
    NULL, 
    (SELECT id FROM historia WHERE titulo='La Conspiración del Teatro' LIMIT 1)),
    
('Veneno Teatral', 'Frasco encontrado entre utilería', 'Sustancia paralizante usada en efectos especiales', 1, 'alta',
    (SELECT u.id FROM ubicacion u JOIN historia h ON u.historia_id=h.id WHERE u.nombre='Sótano del Teatro' AND h.titulo='La Conspiración del Teatro' LIMIT 1),
    (SELECT p.id FROM personaje p JOIN historia h ON p.historia_id=h.id WHERE p.nombre='Ricardo Fontana' AND h.titulo='La Conspiración del Teatro' LIMIT 1), 
    (SELECT id FROM historia WHERE titulo='La Conspiración del Teatro' LIMIT 1)),
    
('Artículo de Prensa Antigua', 'Recorte de periódico de hace 15 años', 'Documenta la caída en desgracia de un actor', 1, 'alta',
    (SELECT u.id FROM u: Muerte en el Expreso Nocturno
INSERT INTO pista (nombre, descripcion, contenido, crucial, importancia, ubicacion_id, personaje_id, historia_id) VALUES
('Telegrama Cifrado', 'Mensaje interceptado', 'Coordenadas de encuentro y códigos militares', 1, 'alta',
    (SELECT u.id FROM ubicacion u JOIN historia h ON u.historia_id=h.id WHERE u.nombre='Compartimento de la Víctima' AND h.titulo='Muerte en el Expreso Nocturno' LIMIT 1),
    (SELECT p.id FROM personaje p JOIN historia h ON p.historia_id=h.id WHERE p.nombre='Coronel Montgomery' AND h.titulo='Muerte en el Expreso Nocturno' LIMIT 1), 
    (SELECT id FROM historia WHERE titulo='Muerte en el Expreso Nocturno' LIMIT 1)),
    
('Dossier Secreto', 'Carpeta con documentos clasificados', 'Evidencia de crímenes de guerra', 1, 'alta',
    (SELECT u.id FROM ubicacion u JOIN historia h ON u.historia_id=h.id WHERE u.nombre='Compartimento del Coronel' AND h.titulo='Muerte en el Expreso Nocturno' LIMIT 1),
    (SELECT p.id FROM personaje p JOIN historia h ON p.historia_id=h.id WHERE p.nombre='Coronel Montgomery' AND h.titulo='Muerte en el Expreso Nocturno' LIMIT 1), 
    (SELECT id FROM historia WHERE titulo='Muerte en el Expreso Nocturno' LIMIT 1)),
    
('Arma del Crimen', 'Objeto contundente militar', 'Bastón con empuñadura de metal del coronel', 1, 'alta',
    (SELECT u.id FROM ubicacion u JOIN historia h ON u.historia_id=h.id WHERE u.nombre='Vagón de Equipaje' AND h.titulo='Muerte en el Expreso Nocturno' LIMIT 1),
    (SELECT p.id FROM personaje p JOIN historia h ON p.historia_id=h.id WHERE p.nombre='Coronel Montgomery' AND h.titulo='Muerte en el Expreso Nocturno' LIMIT 1), 
    (SELECT id FROM historia WHERE titulo='Muerte en el Expreso Nocturno' LIMIT 1)
INSERT INTO pista (nombre, descripcion, contenido, crucial, importancia, ubicacion_id, personaje_id, historia_id) VALUES
('Carta Anónima', 'Amenaza encontrada en el camerino', 'Carta amenazante con recortes de periódico', 1, 'alta',
    (SELECT id FROM ubicacion WHERE nombre='Camerino del Director' AND historia_id=4 LIMIT 1), NULL, 4),
    
('Veneno Teatral', 'Fra: El Enigma de la Galería Oscura
INSERT INTO pista (nombre, descripcion, contenido, crucial, importancia, ubicacion_id, personaje_id, historia_id) VALUES
('Mensaje Cifrado 1', 'Código dejado en primera escena', 'Coordenadas en sistema hexadecimal', 1, 'alta',
    (SELECT u.id FROM ubicacion u JOIN historia h ON u.historia_id=h.id WHERE u.nombre='Sala Principal de Exhibición' AND h.titulo='El Enigma de la Galería Oscura' LIMIT 1), 
    NULL, 
    (SELECT id FROM historia WHERE titulo='El Enigma de la Galería Oscura' LIMIT 1)),
    
('Diario de la Curadora', 'Notas personales', 'Críticas a la comercialización del arte', 1, 'alta',
    (SELECT u.id FROM ubicacion u JOIN historia h ON u.historia_id=h.id WHERE u.nombre='Archivo de Obras' AND h.titulo='El Enigma de la Galería Oscura' LIMIT 1),
    (SELECT p.id FROM personaje p JOIN historia h ON p.historia_id=h.id WHERE p.nombre='Isabelle Noir' AND h.titulo='El Enigma de la Galería Oscura' LIMIT 1), 
    (SELECT id FROM historia WHERE titulo='El Enigma de la Galería Oscura' LIMIT 1)),
    
('Herramientas Especializadas', 'Kit de robo profesional', 'Herramientas para desmontar marcos sin daño', 1, 'alta',
    (SELECT u.id FROM ubicacion u JOIN historia h ON u.historia_id=h.id WHERE u.nombre='Taller de Restauración' AND h.titulo='El Enigma de la Galería Oscura' LIMIT 1),
    (SELECT p.id FROM personaje p JOIN historia h ON p.historia_id=h.id WHERE p.nombre='Isabelle Noir' AND h.titulo='El Enigma de la Galería Oscura' LIMIT 1), 
    (SELECT id FROM historia WHERE titulo='El Enigma de la Galería Oscura' LIMIT 1)),
    
('Plano de Ventilación', 'Mapa de conductos', 'Ruta de escape por el sistema de aire', 1, 'media',
    (SELECT u.id FROM ubicacion u JOIN historia h ON u.historia_id=h.id WHERE u.nombre='Sistema de Ventilación' AND h.titulo='El Enigma de la Galería Oscura' LIMIT 1), 
    NULL, 
    (SELECT id FROM histori: El Secreto del Reloj Antiguo
INSERT INTO documento (historia_id, clave, nombre, icono, contenido, codigo_correcto, pista_nombre) VALUES
((SELECT id FROM historia WHERE titulo='El Secreto del Reloj Antiguo' LIMIT 1), 'informe_seguridad', 'Informe de Seguridad', '📹', 'Registro de todos los movimientos capturados por las cámaras durante el día de la subasta. El análisis muestra una discrepancia temporal sospechosa.', NULL, 'Video de Seguridad'),
((SELECT id FROM historia WHERE titulo='El Secreto del Reloj Antiguo' LIMIT 1)  
('Arma del Crimen', 'Objeto contundente militar', 'Bastón con empuñadura de metal del coronel', 1, 'alta',
    (SELECT id FROM ubicacion WHERE nombre='Vagón de Equipaje' AND historia_id=5 LIMIT 1),
    (SELECT id FROM personaje WHERE nombre='Coronel Montgomery' AND historia_id=5 LIMIT 1), 5);

-- Pistas para Historia 6 (El Enigma de la Galería Oscura)
INSERT INTO pista (nombre, descripcion, contenido, crucial, importancia, ubicacion_id, personaje_id, historia_id) VALUES
('Mensaje Cifrado 1', 'Códi: La Conspiración del Teatro
INSERT INTO documento (historia_id, clave, nombre, icono, contenido, codigo_correcto, pista_nombre) VALUES
((SELECT id FROM historia WHERE titulo='La Conspiración del Teatro' LIMIT 1), 'programa_obra', 'Programa de la Obra', '🎭', 'Programa oficial con biografías del elenco. Información interesante sobre el pasado de los actores.', NULL, NULL),
((SELECT id FROM historia WHERE titulo='La Conspiración del Teatro' LIMIT 1)Diario de la Curadora', 'Notas personales', 'Críticas a la comercialización del arte', 1, 'alta',
    (SELECT id FROM ubicacion WHERE nombre='Archivo de Obras' AND historia_id=6 LIMIT 1),
    (SELECT id FROM persona: Muerte en el Expreso Nocturno
INSERT INTO documento (historia_id, clave, nombre, icono, contenido, codigo_correcto, pista_nombre) VALUES
((SELECT id FROM historia WHERE titulo='Muerte en el Expreso Nocturno' LIMIT 1), 'lista_pasajeros', 'Lista de Pasajeros', '🎫', 'Registro completo de todos los pasajeros del tren. Algunos nombres despiertan sospechas.', NULL, NULL),
((SELECT id FROM historia WHERE titulo='Muerte en el Expreso Nocturno' LIMIT 1)  (SELECT id FROM ubicacion WHERE nombre='Taller de Restauración' AND historia_id=6 LIMIT 1),
    (SELECT id FROM personaje WHERE nombre='Isabelle Noir' AND historia_id=6 LIMIT 1), 6),
    
('Plano de Ventilación', 'Mapa de conductos', 'Ruta de escape por el sistema de aire', 1, 'media',
    (SELECT id FROM ubicacion WHERE nombre='Sistema de Ventilación' AND historia_id=6 LIMIT 1), NULL, 6);

-- ==============================
-- DOCUMENTOS
-- ========================: El Enigma de la Galería Oscura
INSERT INTO documento (historia_id, clave, nombre, icono, contenido, codigo_correcto, pista_nombre) VALUES
((SELECT id FROM historia WHERE titulo='El Enigma de la Galería Oscura' LIMIT 1), 'catalogo_obras', 'Catálogo de Obras', '🎨', 'Catálogo completo de todas las obras de la galería con valoraciones actualizadas.', NULL, NULL),
((SELECT id FROM historia WHERE titulo='El Enigma de la Galería Oscura' LIMIT 1)SERT INTO documento (historia_id, clave, nombre, icono, contenido, codigo_correcto, pista_nombre) VALUES
(3, 'informe_seguridad', 'Informe de Seguridad', '📹', 'Registro de todos los movimientos capturados por las cámaras durante el día de la subasta. El análisis muestra una discrepancia temporal sospechosa.', NULL, 'Video de Seguridad'),
(3, 'registro_subastas', 'Registro de Subastas', '📋', 'Historial de todas las subastas del mes. Revela irregularidades en las transacciones recientes.', NULL, NULL);

-- Documentos para Historia 4
INSERT INTO documento (historia_id, clave, nombre, icono, contenido, codigo_correcto, pista_nombre) VALUES
(4, 'programa_obra', 'Programa de la Obra', '🎭', 'Programa oficial con biografías del elenco. Información interesante sobre el pasado de los actores.', NULL, NULL),
(4, 'contrato_director', 'Contrato del Director', '📄', 'Acuerdo contractual con cláusulas especiales sobre manejo de fondos y reparto.', NULL, NULL);

-- Documentos para Historia 5
INSERT INTO documento (historia_id, clave, nombre, icono, contenido, codigo_correcto, pista_nombre) VALUES
(5, 'lista_pasajeros', 'Lista de Pasajeros', '🎫', 'Registro completo de todos los pasajeros del tren. Algunos nombres despiertan sospechas.', NULL, NULL),
(5, 'horario_tren', 'Horario del Tren', '🕐', 'Itinerario detallado con paradas y tiempos. Información crucial para establecer cronología.', NULL, NULL);

-- Documentos para Historia 6
INSERT INTO documento (historia_id, clave, nombre, icono, contenido, codigo_correcto, pista_nombre) VALUES
(6, 'catalogo_obras', 'Catálogo de Obras', '🎨', 'Catálogo completo de todas las obras de la galería con valoraciones actualizadas.', NULL, NULL),
(6, 'informe_policial', 'Informe Policial', '👮', 'Análisis forense de las escenas de los tres robos anteriores. Patrón identificado.', NULL, 'Mensaje Cifrado 1');

-- ==============================
-- VERIFICACIÓN
-- ==============================
SELECT '=== RESUMEN DE DATOS INSERTADOS ===' AS info;
SELECT COUNT(*) as total_usuarios FROM usuario;
SELECT COUNT(*) as total_historias FROM historia;
SELECT COUNT(*) as total_personajes FROM personaje;
SELECT COUNT(*) as total_ubicaciones FROM ubicacion;
SELECT COUNT(*) as total_pistas FROM pista;
SELECT COUNT(*) as total_documentos FROM documento;

SELECT '=== HISTORIAS POR LIGA ===' AS info;
SELECT liga_minima, COUNT(*) as cantidad 
FROM historia 
GROUP BY liga_minima 
ORDER BY FIELD(liga_minima, 'bronce', 'plata', 'oro', 'platino', 'diamante');

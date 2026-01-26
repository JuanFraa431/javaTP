-- ========================================
-- SCRIPT COMPLETO DE RECONSTRUCCIÓN
-- Base de datos: misterio_mansion
-- Incluye: Estructura + Datos Existentes + Datos Nuevos
-- ========================================

-- Eliminar base de datos si existe y recrear
DROP DATABASE IF EXISTS `misterio_mansion`;
CREATE DATABASE `misterio_mansion` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `misterio_mansion`;

-- ========================================
-- ESTRUCTURA DE TABLAS
-- ========================================

-- Tabla: usuario
CREATE TABLE `usuario` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `rol` enum('jugador','admin') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'jugador',
  `fecha_registro` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) DEFAULT '1',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `en_partida` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_email` (`email`),
  KEY `idx_rol` (`rol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: historia
CREATE TABLE `historia` (
  `id` int NOT NULL AUTO_INCREMENT,
  `titulo` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `contexto` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `activa` tinyint(1) DEFAULT '1',
  `dificultad` tinyint DEFAULT '1',
  `tiempo_estimado` int DEFAULT '0' COMMENT 'Tiempo en minutos',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `liga_minima` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'bronce' COMMENT 'Liga mínima requerida: bronce, plata, oro, platino, diamante',
  PRIMARY KEY (`id`),
  KEY `idx_activa` (`activa`),
  KEY `idx_dificultad` (`dificultad`),
  CONSTRAINT `historia_chk_1` CHECK ((`dificultad` between 1 and 5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: personaje
CREATE TABLE `personaje` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `coartada` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `motivo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `sospechoso` tinyint(1) DEFAULT '1',
  `culpable` tinyint(1) DEFAULT '0',
  `historia_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_historia` (`historia_id`),
  KEY `idx_sospechoso` (`sospechoso`),
  KEY `idx_culpable` (`culpable`),
  CONSTRAINT `personaje_ibfk_1` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: ubicacion
CREATE TABLE `ubicacion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `accesible` tinyint(1) DEFAULT '1',
  `imagen` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `historia_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_historia` (`historia_id`),
  KEY `idx_accesible` (`accesible`),
  CONSTRAINT `ubicacion_ibfk_1` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: pista
CREATE TABLE `pista` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `contenido` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `crucial` tinyint(1) DEFAULT '0',
  `importancia` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'media',
  `ubicacion_id` int DEFAULT NULL,
  `personaje_id` int DEFAULT NULL,
  `historia_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ubicacion` (`ubicacion_id`),
  KEY `idx_personaje` (`personaje_id`),
  KEY `idx_historia` (`historia_id`),
  KEY `idx_crucial` (`crucial`),
  CONSTRAINT `pista_ibfk_1` FOREIGN KEY (`ubicacion_id`) REFERENCES `ubicacion` (`id`) ON DELETE CASCADE,
  CONSTRAINT `pista_ibfk_2` FOREIGN KEY (`personaje_id`) REFERENCES `personaje` (`id`) ON DELETE SET NULL,
  CONSTRAINT `pista_ibfk_3` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: documento
CREATE TABLE `documento` (
  `id` int NOT NULL AUTO_INCREMENT,
  `historia_id` int NOT NULL,
  `clave` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `icono` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'fa-regular fa-file-lines',
  `contenido` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo_correcto` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pista_nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_documento_historia_clave` (`historia_id`,`clave`),
  CONSTRAINT `fk_documento_historia` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: logro
CREATE TABLE `logro` (
  `id` int NOT NULL AUTO_INCREMENT,
  `clave` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Identificador único del logro (ej: primer_caso)',
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre del logro',
  `descripcion` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Descripción del logro',
  `icono` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT 'fa-solid fa-trophy' COMMENT 'Clase Font Awesome del icono',
  `puntos` int DEFAULT '10' COMMENT 'Puntos que otorga el logro',
  `activo` tinyint(1) DEFAULT '1' COMMENT '1=activo, 0=inactivo',
  PRIMARY KEY (`id`),
  UNIQUE KEY `clave` (`clave`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: partida
CREATE TABLE `partida` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `historia_id` int NOT NULL,
  `fecha_inicio` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_fin` timestamp NULL DEFAULT NULL,
  `estado` enum('EN_PROGRESO','GANADA','PERDIDA','ABANDONADA') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'EN_PROGRESO',
  `pistas_encontradas` int DEFAULT '0',
  `ubicaciones_exploradas` int DEFAULT '0',
  `puntuacion` int DEFAULT '0',
  `solucion_propuesta` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `caso_resuelto` tinyint(1) DEFAULT '0',
  `intentos_restantes` int DEFAULT '3',
  PRIMARY KEY (`id`),
  KEY `idx_usuario` (`usuario_id`),
  KEY `idx_historia` (`historia_id`),
  KEY `idx_estado` (`estado`),
  KEY `idx_fecha_inicio` (`fecha_inicio`),
  KEY `idx_partida_usuario_estado` (`usuario_id`,`estado`),
  CONSTRAINT `partida_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`) ON DELETE CASCADE,
  CONSTRAINT `partida_ibfk_2` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: progreso_pista
CREATE TABLE `progreso_pista` (
  `id` int NOT NULL AUTO_INCREMENT,
  `partida_id` int NOT NULL,
  `pista_id` int NOT NULL,
  `fecha_encontrada` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_partida_pista` (`partida_id`,`pista_id`),
  KEY `idx_partida` (`partida_id`),
  KEY `idx_pista` (`pista_id`),
  KEY `idx_progreso_pista_partida` (`partida_id`),
  CONSTRAINT `progreso_pista_ibfk_1` FOREIGN KEY (`partida_id`) REFERENCES `partida` (`id`) ON DELETE CASCADE,
  CONSTRAINT `progreso_pista_ibfk_2` FOREIGN KEY (`pista_id`) REFERENCES `pista` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: progreso_ubicacion
CREATE TABLE `progreso_ubicacion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `partida_id` int NOT NULL,
  `ubicacion_id` int NOT NULL,
  `fecha_explorada` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_partida_ubicacion` (`partida_id`,`ubicacion_id`),
  KEY `idx_partida` (`partida_id`),
  KEY `idx_ubicacion` (`ubicacion_id`),
  KEY `idx_progreso_ubicacion_partida` (`partida_id`),
  CONSTRAINT `progreso_ubicacion_ibfk_1` FOREIGN KEY (`partida_id`) REFERENCES `partida` (`id`) ON DELETE CASCADE,
  CONSTRAINT `progreso_ubicacion_ibfk_2` FOREIGN KEY (`ubicacion_id`) REFERENCES `ubicacion` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: usuario_logro
CREATE TABLE `usuario_logro` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `logro_id` int NOT NULL,
  `fecha_obtencion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_usuario_logro` (`usuario_id`,`logro_id`),
  KEY `idx_usuario` (`usuario_id`),
  KEY `idx_logro` (`logro_id`),
  CONSTRAINT `usuario_logro_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`) ON DELETE CASCADE,
  CONSTRAINT `usuario_logro_ibfk_2` FOREIGN KEY (`logro_id`) REFERENCES `logro` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- VISTAS
-- ========================================

-- Vista: estadisticas_usuario
CREATE VIEW `estadisticas_usuario` AS 
SELECT 
  `u`.`id` AS `id`,
  `u`.`nombre` AS `nombre`,
  `u`.`email` AS `email`,
  COUNT(`p`.`id`) AS `partidas_jugadas`,
  COUNT((CASE WHEN (`p`.`caso_resuelto` = TRUE) THEN 1 END)) AS `casos_resueltos`,
  AVG(`p`.`puntuacion`) AS `puntuacion_promedio`,
  MAX(`p`.`fecha_inicio`) AS `ultima_partida` 
FROM (`usuario` `u` LEFT JOIN `partida` `p` ON((`u`.`id` = `p`.`usuario_id`))) 
WHERE (`u`.`rol` = 'jugador') 
GROUP BY `u`.`id`, `u`.`nombre`, `u`.`email`;

-- Vista: partidas_detalle
CREATE VIEW `partidas_detalle` AS 
SELECT 
  `p`.`id` AS `id`,
  `u`.`nombre` AS `jugador`,
  `h`.`titulo` AS `historia`,
  `p`.`fecha_inicio` AS `fecha_inicio`,
  `p`.`fecha_fin` AS `fecha_fin`,
  `p`.`estado` AS `estado`,
  `p`.`pistas_encontradas` AS `pistas_encontradas`,
  `p`.`ubicaciones_exploradas` AS `ubicaciones_exploradas`,
  `p`.`puntuacion` AS `puntuacion`,
  `p`.`caso_resuelto` AS `caso_resuelto`,
  TIMESTAMPDIFF(MINUTE,`p`.`fecha_inicio`,COALESCE(`p`.`fecha_fin`,NOW())) AS `duracion_minutos` 
FROM ((`partida` `p` JOIN `usuario` `u` ON((`p`.`usuario_id` = `u`.`id`))) JOIN `historia` `h` ON((`p`.`historia_id` = `h`.`id`)));

-- ========================================
-- DATOS: USUARIOS
-- ========================================

INSERT INTO `usuario` VALUES 
(1,'Administrador','admin@mansion.com','6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b','admin','2025-10-22 14:24:07',1,NULL,0),
(2,'Detective Juan','juan@detective.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4','jugador','2025-10-22 14:24:07',1,NULL,0),
(4,'Administrador','adminCapo@mansion.com','6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b','admin','2025-10-22 14:33:59',1,NULL,0),
(5,'Serena','serena@gmail.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4','jugador','2025-10-22 14:55:55',0,NULL,0),
(6,'Bruno','bruno@gmail.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4','jugador','2025-10-22 15:07:51',1,NULL,1),
(7,'Maquina JSAJSAJ','Maquina@gmail.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4','jugador','2025-10-22 16:04:44',1,NULL,0),
(8,'Jano Martinez Ruiz','jano@gmail.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4','jugador','2025-10-22 20:01:52',1,NULL,0),
(9,'Juanfra','juanfraa032@gmail.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4','jugador','2025-11-04 22:43:28',1,NULL,1),
(10,'Manuel','manuel@gmail.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4','jugador','2025-11-19 12:33:04',1,NULL,0),
(11,'Manuna','manu@gmail.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4','jugador','2025-11-19 12:46:48',1,NULL,0),
(12,'fsaf','dfs@fdsf','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4','jugador','2025-11-19 13:01:25',1,NULL,0),
(13,'Juan Manuel','juanma@gmail.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4','jugador','2025-11-19 13:02:16',1,NULL,0),
(14,'Menu 2','menu@gmail.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4','jugador','2025-11-19 13:35:37',0,NULL,0),
(15,'sere','sere22giacomelli@gmail.com','a75dfb04f127df2fb7dbad54350329e73b1664ebd2a20080b23ea60bc3530b91','jugador','2026-01-16 16:47:22',1,NULL,0);

-- USUARIOS NUEVOS
INSERT INTO `usuario` (nombre, email, password, rol, activo) VALUES
('Carlos Mendoza', 'carlos.mendoza@mail.com', 'e10adc3949ba59abbe56e057f20f883e', 'jugador', 1),  -- pass: 123456 (MD5)
('María López', 'maria.lopez@mail.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'jugador', 1),      -- pass: password (MD5)
('Pedro Sánchez', 'pedro.sanchez@mail.com', '25d55ad283aa400af464c76d713c07ad', 'jugador', 1),   -- pass: 12345678 (MD5)
('Ana Ramírez', 'ana.ramirez@mail.com', 'e10adc3949ba59abbe56e057f20f883e', 'jugador', 1),       -- pass: 123456 (MD5)
('Luis Torres', 'luis.torres@mail.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'jugador', 1);       -- pass: password (MD5)

-- ========================================
-- DATOS: HISTORIAS
-- ========================================

-- Historias existentes
INSERT INTO `historia` VALUES 
(1,'El Misterio de la Mansión Blackwood','Un asesinato ha ocurrido en la antigua mansión de la familia Blackwood. Como detective experto, debes investigar el crimen, encontrar pistas y descubrir al culpable.','Durante una tormenta invernal, los invitados de la mansión Blackwood se encuentran atrapados. Cuando encuentran al anfitrión muerto en su estudio, comienza una carrera contra el tiempo para encontrar al asesino antes de que escape.',1,3,45,'2025-10-22 14:24:07','bronce'),
(2,'Muerte en Alvarez','Ocurrio un asesino en la ciudad alejada de Álvarez, te crees capaz de adentrarte en los campos Giacomelli y descubrir al asesino?','Fue hallado un cuerpo en el campo Giacomelli, comenzamos a investigar al padre de familia (Juan Jose).',1,4,120,'2025-11-04 21:50:15','bronce');

-- Historias nuevas
INSERT INTO `historia` (titulo, descripcion, contexto, activa, dificultad, tiempo_estimado, liga_minima) VALUES
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
 1, 5, 90, 'platino'),

-- Historias DIFÍCILES (Nivel 5 - Casos Complejos)
('El Caso del Manuscrito Perdido',
 'Un manuscrito medieval invaluable desaparece de una biblioteca universitaria. Red de mentiras, motivos cruzados y evidencia contradictoria.',
 'El Códice Voynich 2.0, un manuscrito descifrado recientemente que revelaba secretos históricos explosivos, ha desaparecido de la bóveda de seguridad de la Universidad. Tres académicos tenían acceso. Uno de ellos miente. Las pistas son contradictorias y deberás usar lógica deductiva para descubrir la verdad.',
 1, 5, 120, 'oro'),

('Asesinato en el Laboratorio Cerrado',
 'Un científico brillante es asesinado en un laboratorio sellado desde adentro. Imposible... o no?',
 'El Dr. Viktor Steiner, premio Nobel de Química, es encontrado muerto en su laboratorio de alta seguridad. La puerta estaba cerrada con llave desde adentro, las ventanas selladas, y no hay señales de entrada forzada. Cinco colegas cercanos, todos con acceso a tecnología avanzada. ¿Suicidio, accidente o un asesinato imposible?',
 1, 5, 135, 'platino'),

('La Herencia del Patriarca',
 'Muerte sospechosa durante la lectura de un testamento millonario. Siete herederos, todos con secretos oscuros.',
 'El magnate industrial Edmundo Salvatierra muere la noche antes de revelar su testamento final. La autopsia revela envenenamiento. Sus siete herederos estuvieron presentes en la cena familiar. Cada uno tiene motivos, cada uno tiene coartadas perfectas, y la evidencia apunta en múltiples direcciones.',
 1, 5, 150, 'platino'),

('El Archivo Fantasma',
 'Documentos clasificados son robados de un edificio gubernamental con seguridad impenetrable. Alguien de adentro está involucrado.',
 'Archivos sobre experimentos militares desaparecen de un bunker subterráneo con triple autenticación biométrica. El sistema de seguridad no registra intrusos. Cuatro oficiales de alto rango tenían acceso. Deberás descifrar códigos militares, analizar registros digitales y desenmascarar una conspiración interna.',
 1, 5, 180, 'diamante');

-- ========================================
-- DATOS: PERSONAJES
-- ========================================

-- Personajes existentes (Historia 1)
INSERT INTO `personaje` VALUES 
(1,'Lady Margaret Blackwood','La esposa del difunto Lord Blackwood. Una mujer elegante pero con una mirada fría.','Estaba en su habitación escribiendo cartas durante toda la tarde.','Heredaría toda la fortuna familiar tras la muerte de su esposo.',1,0,1),
(2,'Dr. Henry Watson','El médico de la familia y viejo amigo de Lord Blackwood. Nervioso desde el incidente.','Estaba atendiendo a un paciente en el pueblo cuando ocurrió el crimen.','Lord Blackwood amenazó con exponer su pasado turbio.',1,0,1),
(3,'James Fletcher','El mayordomo de la mansión. Ha servido a la familia por más de 20 años.','Estaba sirviendo té en el salón principal cuando escuchó el grito.','Fue despedido recientemente por Lord Blackwood por robo.',1,1,1),
(4,'Miss Sarah Collins','La joven secretaria personal de Lord Blackwood. Inteligente y observadora.','Estaba organizando documentos en la oficina adyacente al estudio.','Lord Blackwood descubrió que había estado vendiendo información confidencial.',1,0,1),
(5,'Captain Robert Sterling','Un viejo compañero militar de Lord Blackwood. Veterano de guerra.','Estaba fumando en el jardín disfrutando del aire fresco.','Lord Blackwood se negó a prestarle dinero para pagar sus deudas de juego.',1,0,1);

-- Personajes nuevos (Historia 3: El Secreto del Reloj Antiguo)
INSERT INTO personaje (nombre, descripcion, coartada, motivo, sospechoso, culpable, historia_id) VALUES
('Sra. Elizabeth Moore', 'Coleccionista rica y exigente', 'Estaba en el salón principal admirando otras piezas', 'Codicia - quería el reloj para su colección privada', 1, 0, 3),
('Sr. Thomas Baker', 'Subastador veterano', 'Estaba en su oficina revisando documentos', 'Deudas de juego - planeaba vender el reloj en el mercado negro', 1, 1, 3),
('Dra. Sophie Laurent', 'Historiadora especialista en relojes antiguos', 'En el baño cuando ocurrió el robo', 'Preservación histórica - creía que el reloj no debía venderse', 1, 0, 3),
('Marcus Webb', 'Guardia de seguridad', 'Haciendo su ronda en el segundo piso', 'Ninguno aparente', 1, 0, 3),
('Isabella Chen', 'Asistente del subastador', 'Atendiendo llamadas en recepción', 'Venganza - fue despedida hace un mes', 1, 0, 3);

-- Personajes nuevos (Historia 4: La Conspiración del Teatro)
INSERT INTO personaje (nombre, descripcion, coartada, motivo, sospechoso, culpable, historia_id) VALUES
('Valentina Rossi', 'Actriz principal', 'Ensayando su monólogo en el escenario', 'Celos profesionales - Bellini la reemplazaría', 1, 0, 4),
('Ricardo Fontana', 'Actor secundario y rival', 'En su camerino preparándose', 'Venganza - Bellini arruinó su carrera años atrás', 1, 1, 4),
('Lucía Moretti', 'Crítica teatral temida', 'En la platea tomando notas', 'Chantaje - Bellini tenía información comprometedora', 1, 0, 4),
('Giovanni Esposito', 'Productor del teatro', 'Reunión con inversionistas en la oficina', 'Dinero - Bellini descubrió malversación de fondos', 1, 0, 4),
('Carla Benedetti', 'Diseñadora de vestuario', 'En el taller cosiendo trajes', 'Pasión - relación secreta que terminó mal', 1, 0, 4);

-- Personajes nuevos (Historia 5: Muerte en el Expreso Nocturno)
INSERT INTO personaje (nombre, descripcion, coartada, motivo, sospechoso, culpable, historia_id) VALUES
('Coronel Montgomery', 'Militar retirado con pasado turbio', 'En el vagón comedor cenando', 'Silenciar testigo - la víctima conocía crímenes de guerra', 1, 1, 5),
('Lady Catherine Ashford', 'Aristócrata empobrecida', 'Leyendo en su compartimento', 'Herencia - la víctima le debía dinero', 1, 0, 5),
('Dr. Heinrich Braun', 'Científico alemán misterioso', 'Trabajando en su laboratorio portátil', 'Secretos industriales - competencia empresarial', 1, 0, 5),
('Señora Dubois', 'Viuda francesa elegante', 'Durmiendo en su cabina', 'Ninguno aparente', 0, 0, 5),
('Inspector Pavel Ivanov', 'Detective ruso', 'Investigando discretamente', 'Justicia - perseguía a la víctima por crímenes antiguos', 1, 0, 5);

-- Personajes nuevos (Historia 6: El Enigma de la Galería Oscura)
INSERT INTO personaje (nombre, descripcion, coartada, motivo, sospechoso, culpable, historia_id) VALUES
('Alexandre Monet', 'Dueño de la galería, descendiente del pintor', 'En su oficina durante los robos', 'Fraude de seguros - galería en quiebra', 1, 0, 6),
('Isabelle Noir', 'Curadora de arte con reputación impecable', 'Catalogando obras en el archivo', 'Venganza artística - robos selectivos por motivos éticos', 1, 1, 6),
('Viktor Kozlov', 'Coleccionista ruso con contactos oscuros', 'Fuera del país según pasaporte', 'Mercado negro - encargó los robos', 1, 0, 6),
('Emma Richardson', 'Restauradora de arte', 'Trabajando en el taller de restauración', 'Obsesión - quiere poseer las obras para estudio personal', 1, 0, 6),
('Detective Sarah Blake', 'Detective asignada al caso', 'Investigando en la escena', 'Ninguno - está ayudando', 0, 0, 6);

-- Personajes nuevos (Historia 7: El Caso del Manuscrito Perdido)
INSERT INTO personaje (nombre, descripcion, coartada, motivo, sospechoso, culpable, historia_id) VALUES
('Dra. Elena Vásquez', 'Historiadora medieval, experta en manuscritos', 'Dando clase cuando desapareció el manuscrito', 'Venganza académica - el manuscrito contradice su investigación de 20 años', 1, 0, 7),
('Prof. Marcus Whitfield', 'Catedrático de lenguas antiguas', 'En reunión con el decano', 'Dinero - coleccionista privado ofreció fortuna por el manuscrito', 1, 1, 7),
('Dr. Hassan Al-Rashid', 'Arqueólogo y traductor', 'En el archivo revisando referencias', 'Protección cultural - cree que el manuscrito debe estar en su país de origen', 1, 0, 7),
('Sofía Mendez', 'Asistente de investigación', 'Catalogando libros en el sótano', 'Idealismo - quiere publicar el contenido libremente en internet', 1, 0, 7),
('Guardián de Seguridad Roberto Silva', 'Jefe de seguridad nocturna', 'Haciendo su ronda', 'Aparentemente ninguno - pero tiene deudas secretas', 1, 0, 7);

-- Personajes nuevos (Historia 8: Asesinato en el Laboratorio Cerrado)
INSERT INTO personaje (nombre, descripcion, coartada, motivo, sospechoso, culpable, historia_id) VALUES
('Dra. Katrina Volkov', 'Colega y ex-esposa de la víctima', 'En su laboratorio separado', 'Herencia científica - patentes conjuntas valen millones', 1, 0, 8),
('Dr. James Patterson', 'Asistente ambicioso del Dr. Steiner', 'Almorzando en la cafetería', 'Robo de descubrimiento - planeaba publicar el trabajo como propio', 1, 1, 8),
('Ing. Chen Wei', 'Especialista en sistemas de seguridad', 'Actualizando software en el piso superior', 'Conoce todas las vulnerabilidades del sistema de seguridad', 1, 0, 8),
('Dra. Adriana Costa', 'Bioquímica con acceso a sustancias letales', 'Experimentando con ratones de laboratorio', 'Steiner descubrió que falsificaba datos en investigaciones', 1, 0, 8),
('Director Gustav Hoffman', 'Director del instituto de investigación', 'En su oficina con videollamada verificable', 'Steiner amenazaba con exponer malversación de fondos', 1, 0, 8);

-- Personajes nuevos (Historia 9: La Herencia del Patriarca)
INSERT INTO personaje (nombre, descripcion, coartada, motivo, sospechoso, culpable, historia_id) VALUES
('Rodrigo Salvatierra', 'Hijo mayor, CEO de la empresa familiar', 'En su estudio revisando contratos', 'Primogenitura - esperaba heredar el imperio completo', 1, 0, 9),
('Valentina Salvatierra', 'Hija del medio, artista bohemia', 'En el jardín pintando', 'Rencor - el padre nunca aprobó su estilo de vida', 1, 0, 9),
('Tomás Salvatierra', 'Hijo menor, médico', 'En el consultorio atendiendo emergencias', 'Favoritismo invertido - era el menos querido', 1, 1, 9),
('Cristina Vega', 'Segunda esposa del patriarca (30 años menor)', 'En su suite descansando', 'Viudez millonaria - heredaría la mitad de todo', 1, 0, 9),
('Fernando Salvatierra', 'Hermano del patriarca, socio minoritario', 'En la biblioteca leyendo', 'Resentimiento histórico - siempre estuvo a la sombra', 1, 0, 9),
('Lucía Márquez', 'Secretaria personal durante 35 años', 'Organizando papeles en la oficina', 'Salvatierra descubrió que robaba información para la competencia', 1, 0, 9),
('Abogado Julio Mendoza', 'Abogado de la familia', 'En su despacho preparando documentos', 'Conoce el contenido del testamento - posible conspiración', 1, 0, 9);

-- Personajes nuevos (Historia 10: El Archivo Fantasma)
INSERT INTO personaje (nombre, descripcion, coartada, motivo, sospechoso, culpable, historia_id) VALUES
('Coronel Andrea Fuentes', 'Oficial de inteligencia con acceso nivel 5', 'Interrogando personal en otra sección', 'Idealismo - planea filtrar información para transparencia', 1, 0, 10),
('Mayor Ricardo Santana', 'Jefe de seguridad del complejo', 'Monitoreando cámaras en central de vigilancia', 'Chantaje externo - familia secuestrada por organización criminal', 1, 1, 10),
('Dra. Patricia Navarro', 'Analista de datos clasificados', 'Trabajando en servidor seguro', 'Los archivos contienen evidencia de crímenes de lesa humanidad', 1, 0, 10),
('Capitán Miguel Torres', 'Especialista en ciberseguridad', 'Realizando auditoría en otro edificio', 'Hackeo experto - pudo crear acceso remoto', 1, 0, 10),
('Agente Especial Laura Jiménez', 'Investigadora interna', 'Revisando reportes en su oficina', 'Doble agente - trabaja para potencia extranjera', 1, 0, 10);

-- ========================================
-- DATOS: UBICACIONES
-- ========================================

-- Ubicaciones existentes (Historia 1)
INSERT INTO `ubicacion` VALUES 
(1,'Estudio Principal','Un elegante estudio con estanterías llenas de libros antiguos. Aquí fue encontrado el cuerpo de Lord Blackwood.',1,NULL,1),
(2,'Biblioteca','Una vasta biblioteca con miles de volúmenes. Los estantes altos proyectan sombras misteriosas.',1,NULL,1),
(3,'Salón Principal','El gran salón donde los invitados se reunieron antes del crimen. Decorado con pinturas familiares.',1,NULL,1),
(4,'Cocina','La cocina de la mansión, donde los sirvientes preparaban las comidas. Llena de utensilios y herramientas.',1,NULL,1),
(5,'Dormitorio Master','El dormitorio principal de Lord Blackwood. Elegantemente decorado pero ahora vacío.',1,NULL,1),
(6,'Jardín','Los jardines exteriores de la mansión. Las huellas en el barro pueden revelar secretos.',1,NULL,1),
(7,'Sótano','Un sótano húmedo y oscuro donde se guardan las provisiones. Acceso limitado.',1,NULL,1);

-- Ubicaciones nuevas (Historia 3: El Secreto del Reloj Antiguo)
INSERT INTO ubicacion (nombre, descripcion, accesible, imagen, historia_id) VALUES
('Salón Principal de Subasta', 'Gran salón con sillas dispuestas frente al estrado', 1, NULL, 3),
('Oficina del Subastador', 'Oficina elegante con escritorio de caoba', 1, NULL, 3),
('Sala de Exposición', 'Vitrinas iluminadas con las piezas a subastar', 1, NULL, 3),
('Almacén de Antigüedades', 'Depósito con piezas catalogadas', 0, NULL, 3),
('Vestíbulo Principal', 'Entrada con recepción y cámaras de seguridad', 1, NULL, 3),
('Baños del Primer Piso', 'Baños elegantes con mármol', 1, NULL, 3);

-- Ubicaciones nuevas (Historia 4: La Conspiración del Teatro)
INSERT INTO ubicacion (nombre, descripcion, accesible, imagen, historia_id) VALUES
('Escenario Principal', 'Gran escenario con telón de terciopelo rojo', 1, NULL, 4),
('Camerino del Director', 'Camerino privado donde se encontró al director', 1, NULL, 4),
('Platea', 'Área de asientos con excelente vista al escenario', 1, NULL, 4),
('Taller de Vestuario', 'Habitación llena de telas y máquinas de coser', 1, NULL, 4),
('Oficina de Producción', 'Oficina con archivos financieros', 0, NULL, 4),
('Sótano del Teatro', 'Área de almacenamiento con utilería antigua', 0, NULL, 4);

-- Ubicaciones nuevas (Historia 5: Muerte en el Expreso Nocturno)
INSERT INTO ubicacion (nombre, descripcion, accesible, imagen, historia_id) VALUES
('Vagón Comedor', 'Elegante comedor con mesas de mantel blanco', 1, NULL, 5),
('Compartimento de la Víctima', 'Escena del crimen, compartimento de primera clase', 1, NULL, 5),
('Vagón Panorámico', 'Vagón con ventanas amplias para ver el paisaje', 1, NULL, 5),
('Compartimento del Coronel', 'Compartimento militarmente ordenado', 1, NULL, 5),
('Vagón de Equipaje', 'Área de almacenamiento de maletas', 0, NULL, 5),
('Cabina del Maquinista', 'Cabina de control del tren', 0, NULL, 5);

-- Ubicaciones nuevas (Historia 6: El Enigma de la Galería Oscura)
INSERT INTO ubicacion (nombre, descripcion, accesible, imagen, historia_id) VALUES
('Sala Principal de Exhibición', 'Gran sala con iluminación perfecta', 1, NULL, 6),
('Taller de Restauración', 'Laboratorio con equipos especializados', 1, NULL, 6),
('Archivo de Obras', 'Bóveda climatizada con catálogos', 1, NULL, 6),
('Oficina del Director', 'Despacho elegante con vista a la sala', 1, NULL, 6),
('Bóveda de Seguridad', 'Sala acorazada donde se guardan las obras más valiosas', 0, NULL, 6),
('Sistema de Ventilación', 'Acceso a los conductos del edificio', 0, NULL, 6);

-- Ubicaciones nuevas (Historia 7: El Caso del Manuscrito Perdido)
INSERT INTO ubicacion (nombre, descripcion, accesible, imagen, historia_id) VALUES
('Bóveda de Seguridad Principal', 'Cámara acorazada con puerta de 3 toneladas', 1, NULL, 7),
('Sala de Lectura Restringida', 'Sala silenciosa con mesas de lectura y lupas antiguas', 1, NULL, 7),
('Oficina de la Dra. Vásquez', 'Oficina repleta de libros y notas pegadas', 1, NULL, 7),
('Laboratorio de Análisis', 'Equipo para datar y analizar manuscritos', 1, NULL, 7),
('Archivo Digital', 'Sala de servidores con escaneos de documentos', 1, NULL, 7),
('Sala de Restauración', 'Taller con químicos y herramientas delicadas', 1, NULL, 7),
('Túnel de Mantenimiento', 'Acceso subterráneo a sistemas eléctricos', 0, NULL, 7),
('Centro de Monitoreo', 'Cuarto de seguridad con grabaciones de cámaras', 1, NULL, 7);

-- Ubicaciones nuevas (Historia 8: Asesinato en el Laboratorio Cerrado)
INSERT INTO ubicacion (nombre, descripcion, accesible, imagen, historia_id) VALUES
('Laboratorio Principal (Escena del Crimen)', 'Lab sellado con equipo de alta tecnología', 1, NULL, 8),
('Cámara de Descontaminación', 'Esclusa de aire entre laboratorios', 1, NULL, 8),
('Oficina del Dr. Steiner', 'Despacho con notas científicas y computadora', 1, NULL, 8),
('Laboratorio de Bioquímica', 'Lab de la Dra. Costa con sustancias controladas', 1, NULL, 8),
('Sala de Servidores', 'Centro de datos del instituto', 1, NULL, 8),
('Almacén de Químicos', 'Bodega con sustancias peligrosas bajo llave', 0, NULL, 8),
('Sistema de Ventilación Central', 'Acceso a ductos de aire del edificio', 0, NULL, 8),
('Sala de Monitoreo Biométrico', 'Control de accesos con logs digitales', 1, NULL, 8);

-- Ubicaciones nuevas (Historia 9: La Herencia del Patriarca)
INSERT INTO ubicacion (nombre, descripcion, accesible, imagen, historia_id) VALUES
('Gran Comedor', 'Donde ocurrió la última cena familiar', 1, NULL, 9),
('Estudio del Patriarca', 'Oficina personal con testamento guardado', 1, NULL, 9),
('Cocina Principal', 'Donde se preparó la cena fatal', 1, NULL, 9),
('Suite Master', 'Dormitorio donde murió el patriarca', 1, NULL, 9),
('Biblioteca Privada', 'Colección de primeras ediciones y documentos familiares', 1, NULL, 9),
('Bodega de Vinos', 'Cava subterránea con botellas antiguas', 1, NULL, 9),
('Jardín de Hierbas', 'Plantas medicinales y venenosas', 1, NULL, 9),
('Habitación de Cristina', 'Suite de la viuda joven', 1, NULL, 9),
('Despacho del Abogado', 'Oficina anexa con documentos legales', 1, NULL, 9);

-- Ubicaciones nuevas (Historia 10: El Archivo Fantasma)
INSERT INTO ubicacion (nombre, descripcion, accesible, imagen, historia_id) VALUES
('Bóveda de Archivos Clasificados', 'Cámara subterránea ultra segura', 1, NULL, 10),
('Centro de Control Biométrico', 'Sistema de triple autenticación', 1, NULL, 10),
('Sala de Servidores Militares', 'Datacenters con información encriptada', 1, NULL, 10),
('Oficina del Mayor Santana', 'Despacho con acceso a todos los sistemas', 1, NULL, 10),
('Estación de Monitoreo', 'Pantallas de vigilancia 24/7', 1, NULL, 10),
('Laboratorio Forense Digital', 'Análisis de evidencia electrónica', 1, NULL, 10),
('Búnker de Comunicaciones', 'Centro de transmisiones encriptadas', 0, NULL, 10),
('Túnel de Evacuación', 'Ruta secreta de escape de emergencia', 0, NULL, 10);

-- ========================================
-- DATOS: PISTAS
-- ========================================

-- Pistas existentes (Historia 1)
INSERT INTO `pista` VALUES 
(1,'Carta de Despido','Una carta oficial encontrada en el escritorio','Carta firmada por Lord Blackwood despidiendo a James Fletcher por robo de objetos de valor de la mansión.',1,'alta',1,3,1),
(2,'Cuchillo Ensangrentado','El arma del crimen escondida tras una cortina','Un cuchillo de cocina con huellas dactilares que coinciden con las de James Fletcher.',1,'alta',1,3,1),
(3,'Documento Financiero','Papeles sobre las finanzas familiares','Documentos que muestran que Lady Margaret heredará 2 millones de libras.',0,'media',1,1,1),
(4,'Libro de Medicina','Un libro de medicina forense','Libro con páginas marcadas sobre venenos. Pertenece al Dr. Watson.',0,'baja',2,2,1),
(5,'Nota Manuscrita','Una nota encontrada entre los libros','Nota del Dr. Watson: \"No puedo permitir que arruine mi reputación\".',0,'alta',2,2,1),
(6,'Copa de Brandy','Copa con residuos extraños','Copa que contiene trazas de un sedante. Estaba en la mesa donde se reunieron.',0,'media',3,NULL,1),
(7,'Testimonio de Invitados','Declaraciones de los presentes','Los invitados confirman que James parecía nervioso y agitado durante la cena.',0,'alta',3,3,1),
(8,'Inventario de Cuchillos','Lista de utensilios de cocina','Falta un cuchillo de la colección. James tenía acceso libre a la cocina.',1,'alta',4,3,1),
(9,'Delantal Manchado','Delantal del personal de cocina','Delantal con manchas de sangre escondido en un cajón.',1,'alta',4,3,1),
(10,'Diario Personal','Diario íntimo de Lord Blackwood','Entradas que mencionan sospechas sobre el robo de James y su decisión de despedirlo.',0,'media',5,3,1),
(11,'Caja Fuerte Abierta','Caja fuerte violentada','La caja fuerte está abierta y faltan valiosos objetos familiares.',1,'alta',5,3,1),
(12,'Huellas en el Barro','Marcas de zapatos en la tierra','Huellas que van desde la ventana del estudio hacia la puerta de servicio.',0,'media',6,NULL,1),
(13,'Herramientas de Jardín','Utensilios para el jardín','Una pala con tierra fresca. Alguien estuvo cavando recientemente.',0,'baja',6,NULL,1),
(14,'Objetos Robados','Artículos valiosos escondidos','Candelabros de plata y joyas familiares escondidos en un baúl viejo.',1,'alta',7,3,1),
(15,'Llave Maestra','Llave que abre todas las habitaciones','James tenía acceso total a la mansión, incluyendo la caja fuerte.',1,'alta',7,3,1),
(16,'Código de la computadora','El código que desbloquea la PC del estudio','7391',1,'alta',1,1,1),
(17,'Código del celular','El celular de la víctima contiene mensajes clave.','2580',1,'alta',1,1,2);

-- Pistas nuevas (Historia 3: El Secreto del Reloj Antiguo)
INSERT INTO pista (nombre, descripcion, contenido, crucial, importancia, ubicacion_id, personaje_id, historia_id) VALUES
('Video de Seguridad', 'Grabación de la cámara del pasillo', 'Muestra movimiento sospechoso cerca de la oficina', 1, 'alta', 13, 7, 3),
('Ticket de Apuestas', 'Ticket de casino encontrado', 'Deuda de $50,000 a nombre del subastador', 1, 'alta', 9, 7, 3),
('Llave Maestra', 'Llave del almacén', 'Acceso no autorizado al depósito', 0, 'media', 11, NULL, 3);

-- Pistas nuevas (Historia 4: La Conspiración del Teatro)
INSERT INTO pista (nombre, descripcion, contenido, crucial, importancia, ubicacion_id, personaje_id, historia_id) VALUES
('Carta Anónima', 'Amenaza encontrada en el camerino', 'Carta amenazante con recortes de periódico', 1, 'alta', 15, NULL, 4),
('Veneno Teatral', 'Frasco encontrado entre utilería', 'Sustancia paralizante usada en efectos especiales', 1, 'alta', 19, 12, 4),
('Artículo de Prensa Antigua', 'Recorte de periódico de hace 15 años', 'Documenta la caída en desgracia de un actor', 1, 'alta', 18, 12, 4);

-- Pistas nuevas (Historia 5: Muerte en el Expreso Nocturno)
INSERT INTO pista (nombre, descripcion, contenido, crucial, importancia, ubicacion_id, personaje_id, historia_id) VALUES
('Telegrama Cifrado', 'Mensaje interceptado', 'Coordenadas de encuentro y códigos militares', 1, 'alta', 21, 16, 5),
('Dossier Secreto', 'Carpeta con documentos clasificados', 'Evidencia de crímenes de guerra', 1, 'alta', 23, 16, 5),
('Arma del Crimen', 'Objeto contundente militar', 'Bastón con empuñadura de metal del coronel', 1, 'alta', 24, 16, 5);

-- Pistas nuevas (Historia 6: El Enigma de la Galería Oscura)
INSERT INTO pista (nombre, descripcion, contenido, crucial, importancia, ubicacion_id, personaje_id, historia_id) VALUES
('Mensaje Cifrado 1', 'Código dejado en primera escena', 'Coordenadas en sistema hexadecimal', 1, 'alta', 26, NULL, 6),
('Diario de la Curadora', 'Notas personales', 'Críticas a la comercialización del arte', 1, 'alta', 28, 22, 6),
('Herramientas Especializadas', 'Kit de robo profesional', 'Herramientas para desmontar marcos sin daño', 1, 'alta', 27, 22, 6),
('Plano de Ventilación', 'Mapa de conductos', 'Ruta de escape por el sistema de aire', 1, 'media', 31, NULL, 6);

-- Pistas nuevas (Historia 7: El Caso del Manuscrito Perdido)
INSERT INTO pista (nombre, descripcion, contenido, crucial, importancia, ubicacion_id, personaje_id, historia_id) VALUES
('Registro de Acceso Biométrico', 'Log del sistema de seguridad', 'Registro muestra entrada del Prof. Whitfield a las 23:47', 1, 'alta', 39, 28, 7),
('Email Encriptado', 'Correo cifrado interceptado', 'Comunicación con comprador anónimo ofreciendo $2 millones', 1, 'alta', 37, 28, 7),
('Polvo de Manuscrito', 'Partículas de pergamino antiguo', 'Rastros encontrados en el maletín del Prof. Whitfield', 1, 'alta', 32, 28, 7),
('Copia Digital Parcial', 'Escaneo incompleto del manuscrito', 'Sofía hizo copias antes de la desaparición', 0, 'media', 36, 29, 7),
('Testimonio Contradictorio', 'Declaración inconsistente', 'Dra. Vásquez dice estar en clase, pero no hay registro', 0, 'media', 33, 27, 7),
('Huella Térmica', 'Imagen de cámara infrarroja', 'Alguien manipuló el sistema de temperatura de la bóveda', 1, 'alta', 32, NULL, 7),
('Nota en Código', 'Mensaje en latín medieval', 'Pista sobre ubicación actual del manuscrito', 1, 'alta', 34, NULL, 7),
('Transacción Bancaria', 'Movimiento sospechoso de dinero', '$50,000 depositados en cuenta offshore del Prof.', 1, 'alta', 39, 28, 7),
('Grabación de Seguridad Borrada', 'Archivo eliminado recuperado', '17 minutos de video fueron borrados profesionalmente', 1, 'alta', 39, 28, 7);

-- Pistas nuevas (Historia 8: Asesinato en el Laboratorio Cerrado)
INSERT INTO pista (nombre, descripcion, contenido, crucial, importancia, ubicacion_id, personaje_id, historia_id) VALUES
('Sustancia en el Aire', 'Análisis de atmósfera del laboratorio', 'Trazas de gas sedante introducido por ventilación', 1, 'alta', 40, NULL, 8),
('Código de Acceso Clonado', 'Log de sistema biométrico', 'Huella del Dr. Steiner usada DESPUÉS de su muerte', 1, 'alta', 47, 33, 8),
('Documento de Patente', 'Solicitud de patente incompleta', 'Dr. Patterson planeaba registrar el descubrimiento como propio', 1, 'alta', 42, 33, 8),
('Vial de Neurotoxina', 'Sustancia letal de laboratorio', 'Veneno usado en el crimen, acceso restringido', 1, 'alta', 45, 33, 8),
('Esquema de Ventilación', 'Plano del sistema de aire', 'Modificación reciente permitía introducir gases', 1, 'alta', 46, 33, 8),
('Email de Amenaza', 'Mensaje de Steiner a Patterson', 'Steiner descubrió el plagio y amenazaba con exponer', 1, 'alta', 42, 33, 8),
('Huellas Digitales Falsas', 'Evidencia plantada', 'Huellas colocadas estratégicamente para culpar a otros', 0, 'media', 40, 33, 8),
('Registro de Entrada', 'Control de acceso del día del crimen', 'Patterson entró al edificio 2 horas antes de lo declarado', 1, 'alta', 47, 33, 8),
('Máscara de Gas Escondida', 'Equipo de protección', 'Encontrada en casillero de Patterson con residuos', 1, 'alta', 41, 33, 8),
('Notas de Investigación Robadas', 'Documentos científicos faltantes', 'El verdadero móvil: robar años de investigación', 1, 'alta', 42, 33, 8);

-- Pistas nuevas (Historia 9: La Herencia del Patriarca)
INSERT INTO pista (nombre, descripcion, contenido, crucial, importancia, ubicacion_id, personaje_id, historia_id) VALUES
('Testamento Original', 'Documento legal sellado', 'Tomás heredaría el 60% del patrimonio, desplazando a Rodrigo', 1, 'alta', 49, 38, 9),
('Frasco de Morfina', 'Medicamento controlado', 'Medicamento del botiquín de Tomás, sobredosis letal', 1, 'alta', 50, 38, 9),
('Conversación Grabada', 'Audio del sistema de seguridad', 'Discusión entre Tomás y el padre sobre "justicia familiar"', 1, 'alta', 48, 38, 9),
('Copa Contaminada', 'Cristalería de la cena', 'Morfina disuelta en el vino del patriarca', 1, 'alta', 48, 38, 9),
('Diario del Patriarca', 'Últimas entradas personales', 'Revelaba decisión de favorecer al hijo menos ambicioso', 1, 'alta', 49, NULL, 9),
('Investigación Privada', 'Informe de detective', 'Patriarca investigaba fraudes de Rodrigo en la empresa', 0, 'media', 49, 35, 9),
('Mensaje de Texto Borrado', 'SMS recuperado del celular de Tomás', 'Comunicación con farmacéutico sobre obtención de morfina', 1, 'alta', 51, 38, 9),
('Análisis Toxicológico', 'Reporte forense', 'Muerte por insuficiencia respiratoria causada por opioides', 1, 'alta', 51, NULL, 9),
('Huellas en el Botiquín', 'Evidencia dactilar', 'Huellas de Tomás en el frasco de morfina', 1, 'alta', 51, 38, 9),
('Testigo Silencioso', 'Testimonio de la empleada doméstica', 'Vio a Tomás cerca del vino antes de la cena', 1, 'alta', 50, 38, 9);

-- Pistas nuevas (Historia 10: El Archivo Fantasma)
INSERT INTO pista (nombre, descripcion, contenido, crucial, importancia, ubicacion_id, personaje_id, historia_id) VALUES
('Algoritmo de Bypass', 'Código de hackeo sofisticado', 'Programa que desactiva autenticación biométrica temporalmente', 1, 'alta', 59, 44, 10),
('Transferencia de Datos', 'Log de red encriptado', 'Archivos fueron copiados a dispositivo externo no autorizado', 1, 'alta', 60, 44, 10),
('Video de Vigilancia Manipulado', 'Grabación con loop de 8 minutos', 'Mayor Santana manipuló las cámaras durante el robo', 1, 'alta', 62, 44, 10),
('Llave USB Encriptada', 'Dispositivo de almacenamiento', 'Encontrado en casillero del Mayor con archivos clasificados', 1, 'alta', 61, 44, 10),
('Amenaza Encubierta', 'Email anónimo interceptado', 'Organización criminal amenaza a familia del Mayor Santana', 1, 'alta', 63, 44, 10),
('Registro de Acceso Nocturno', 'Log del sistema biométrico', 'Mayor entró a bóveda a las 03:17 AM sin justificación', 1, 'alta', 58, 44, 10),
('Código de Desencriptación', 'Secuencia alfanumérica', 'Código necesario para abrir los archivos robados', 1, 'alta', 63, NULL, 10),
('Rastro Digital', 'Análisis forense de red', 'IP externa conectada durante 4 minutos exactos', 1, 'alta', 63, 44, 10),
('Protocolo de Emergencia Violado', 'Registro de procedimientos', 'Santana desactivó alarmas sin autorización', 1, 'alta', 62, 44, 10),
('Confesión Parcial', 'Interrogatorio grabado', 'Mayor admite que lo obligaron pero se niega a identificar a quien', 1, 'alta', 61, 44, 10);

-- ========================================
-- DATOS: DOCUMENTOS
-- ========================================

-- Documentos existentes
INSERT INTO `documento` VALUES 
(1,1,'nota_codigo','Nota manuscrita: \"Cómo descifrar el código\"','fa-regular fa-file-lines','<h3>Nota manuscrita</h3>\n  <p>No mires números… Escuchá sus <strong>nombres</strong> en castellano y tomá la <em>primera letra</em> de cada uno.</p>\n  <p>Ej: <em>Siete</em>, <em>Tres</em>, <em>Nueve</em>, <em>Uno</em> → <code>STNU</code>… ¿o quizá <strong>7-3-9-1</strong>?</p>','7391','Código de la computadora'),
(2,1,'correo_sospechoso','Correo sospechoso: \"El código está oculto\"','fa-regular fa-envelope','<h3>Correo sospechoso</h3>\n  <p><strong>Asunto:</strong> \"No abras la computadora\"</p>\n  <p><strong>Mensaje:</strong> \"Si alguien descifra <em>Siete Tres Nueve Uno</em>, podrá ver todo.\"</p>',NULL,NULL),
(3,2,'diario_victima','Diario de la víctima','fa-regular fa-book','<h3>Diario de la víctima</h3>\n  <p><strong>Última entrada:</strong> \"Cambié mi código del celular por algo que nunca olvidaré...\"</p>\n  <p>\"La habitación donde todo comenzó... <em>Dos-Cinco-Ocho-Cero</em>. Ahí está la clave.\"</p>\n  <p><em>Nota al margen:</em> \"Si me pasa algo, revisen mi teléfono.\"</p>','2580','Código del celular'),
(4,2,'nota_recepcion','Nota de recepción del hotel','fa-regular fa-note-sticky','<h3>Nota de recepción</h3>\n  <p><strong>Recepcionista:</strong> \"El huésped de la habitación <strong>2580</strong> solicitó cambiar su PIN del celular\"</p>\n  <p>\"Dijo que lo cambiaría por el número de su habitación favorita para no olvidarlo.\"</p>\n  <p><strong>Fecha:</strong> 3 días antes del incidente</p>',NULL,NULL),
(5,2,'mensaje_celular','Mensaje en el celular bloqueado','fa-solid fa-mobile-screen-button','<h3>Mensaje visible en la pantalla</h3>\n  <p style=\"text-align:center; font-size:1.2em; border: 2px solid #666; padding:20px; background:#f0f0f0; border-radius:10px;\">\n    <strong>🔒 Celular bloqueado</strong><br/>\n    <em>Ingrese PIN para desbloquear</em><br/>\n    <small style=\"color:#888;\">Pista: Número de habitación memorable</small>\n  </p>\n  <p><strong>Pregunta de seguridad:</strong> \"¿Cuál es tu habitación favorita?\"</p>',NULL,NULL),
(6,1,'informe_forense','Informe de la Escena del Crimen','fa-solid fa-clipboard-check','<h3>Reporte Forense - Mansión Blackwood</h3>\n<p><strong>Víctima:</strong> Lord Richard Blackwood (57 años)</p>\n<p><strong>Ubicación:</strong> Estudio Principal, primer piso</p>\n<p><strong>Hora estimada de muerte:</strong> 22:15 hrs</p>\n<h4>Evidencia Física:</h4>\n<ul>\n<li><strong>Arma:</strong> Cuchillo de cocina (25cm, encontrado detrás de cortina este)</li>\n<li><strong>Huellas dactilares en arma:</strong> James Fletcher (mayordomo) - CONFIRMADO</li>\n<li><strong>Herida:</strong> Puñalada única en zona intercostal, precisa y mortal</li>\n<li><strong>Caja fuerte:</strong> Abierta, faltantes: candelabros de plata (valor £12,000), joyas familiares</li>\n<li><strong>Sangre:</strong> Tipo O+ (coincide con víctima)</li>\n</ul>\n<h4>Personas presentes en la mansión (20:00-23:00):</h4>\n<table border=\"1\" style=\"width:100%; border-collapse:collapse;\">\n<tr><th>Persona</th><th>Ubicación declarada</th><th>Verificación</th><th>Observaciones</th></tr>\n<tr><td>Lady Margaret Blackwood</td><td>Habitación escribiendo</td><td>❌ Sin confirmar</td><td>Heredera principal</td></tr>\n<tr><td>Dr. Henry Watson</td><td>Pueblo (paciente)</td><td>❌ No verificado</td><td>Pasado turbio</td></tr>\n<tr><td>James Fletcher</td><td>Salón sirviendo té</td><td>✓ Confirmado</td><td>Despedido recientemente</td></tr>\n<tr><td>Miss Sarah Collins</td><td>Oficina adyacente</td><td>✓ Escuchó grito</td><td>Vendía información</td></tr>\n<tr><td>Capt. Robert Sterling</td><td>Jardín fumando</td><td>❌ Sin confirmar</td><td>Deudas de juego</td></tr>\n</table>\n<p><strong>Cronología:</strong> Último avistamiento de Lord vivo: 21:50 | Grito escuchado: 22:15 | Cuerpo descubierto: 22:23</p>\n<p><em>Conclusión preliminar: Todas las evidencias físicas apuntan al mayordomo James Fletcher.</em></p>',NULL,NULL),
(7,2,'informe_campo','Informe de Investigación - Campo Giacomelli','fa-solid fa-file-invoice','<h3>Reporte Policial - Caso Álvarez</h3>\n<p><strong>Caso N°:</strong> 2026-AL-042</p>\n<p><strong>Víctima:</strong> No identificado (varón, 35-45 años aprox.)</p>\n<p><strong>Ubicación:</strong> Campo Giacomelli, zona rural de Álvarez</p>\n<p><strong>Descubrimiento:</strong> 14/01/2026 - 06:30 AM por trabajador rural</p>\n<h4>Sospechosos Iniciales:</h4>\n<table border=\"1\" style=\"width:100%;\">\n<tr><th>Nombre</th><th>Relación</th><th>Coartada</th><th>Estado</th></tr>\n<tr><td>Juan José Giacomelli</td><td>Dueño del campo</td><td>Pueblo comprando insumos</td><td>⚠️ Sin verificar</td></tr>\n<tr><td>Trabajador 1 (Mario S.)</td><td>Empleado</td><td>En su casa durmiendo</td><td>Sin verificar</td></tr>\n<tr><td>Trabajador 2 (Carlos R.)</td><td>Empleado</td><td>Cuidando animales</td><td>Verificado parcial</td></tr>\n<tr><td>Vecino colindante</td><td>Conflicto de límites</td><td>Desconocida</td><td>En investigación</td></tr>\n</table>\n<h4>Evidencia Recolectada:</h4>\n<ul>\n<li>Huellas de neumáticos (camioneta 4x4)</li>\n<li><strong>Celular Samsung</strong> encontrado a 15m del cuerpo - BLOQUEADO con PIN</li>\n<li>Documentos personales parcialmente destruidos</li>\n<li>Testigos reportan actividad vehicular nocturna (02:00-04:00 AM)</li>\n</ul>\n<p><strong>Acción prioritaria:</strong> Desbloquear celular de la víctima. Pista encontrada: número de habitación <strong>2580</strong> escrito en agenda personal.</p>\n<p><strong>Estado:</strong> Investigación activa. Se requiere identificación de víctima y móvil del crimen.</p>',NULL,NULL);

-- Documentos nuevos (Historia 3: El Secreto del Reloj Antiguo)
INSERT INTO documento (historia_id, clave, nombre, icono, contenido, codigo_correcto, pista_nombre) VALUES
(3, 'informe_seguridad', 'Informe de Seguridad', '📹', 
'<h3>Análisis de Video Vigilancia - Casa de Subastas</h3>
<p><strong>Fecha:</strong> 24/01/2026</p>
<h4>Registro de Movimientos:</h4>
<table border="1" style="width:100%; border-collapse:collapse;">
<tr><th>Hora</th><th>Persona</th><th>Ubicación</th><th>Acción</th></tr>
<tr><td>14:30</td><td>Sra. Elizabeth Moore</td><td>Salón Principal</td><td>Examinando relojes antiguos</td></tr>
<tr><td>14:45</td><td>Sr. Thomas Baker</td><td>Oficina Privada</td><td>Hablando por teléfono (agitado)</td></tr>
<tr><td>15:10</td><td>Dra. Sophie Laurent</td><td>Sala de Exposición</td><td>Fotografiando el reloj desaparecido</td></tr>
<tr><td>15:22</td><td>Marcus Webb</td><td>Segundo Piso</td><td>Ronda de seguridad</td></tr>
<tr><td>15:35</td><td>Sr. Thomas Baker</td><td>Almacén</td><td>⚠️ Acceso no autorizado - 8 minutos</td></tr>
<tr><td>15:43</td><td>Isabella Chen</td><td>Recepción</td><td>Atendiendo llamadas</td></tr>
<tr><td>15:50</td><td>DESAPARICIÓN DEL RELOJ REPORTADA</td><td>---</td><td>Alarma activada</td></tr>
</table>
<p><strong>ANOMALÍA:</strong> Thomas Baker estuvo 8 minutos en el almacén sin justificación durante el horario crítico.</p>', 
NULL, 'Video de Seguridad'),

(3, 'registro_subastas', 'Registro de Subastas', '📋', 
'<h3>Historial de Transacciones - Enero 2026</h3>
<h4>Subastador: Sr. Thomas Baker</h4>
<table border="1" style="width:100%;">
<tr><th>Fecha</th><th>Artículo</th><th>Valor</th><th>Estado</th></tr>
<tr><td>05/01</td><td>Pintura Renoir</td><td>$45,000</td><td>✓ Vendido</td></tr>
<tr><td>12/01</td><td>Collar Victoriano</td><td>$18,500</td><td>✓ Vendido</td></tr>
<tr><td>18/01</td><td>Manuscrito Medieval</td><td>$32,000</td><td>❌ No vendido</td></tr>
<tr><td>24/01</td><td>Reloj Antiguo Suizo</td><td>$850,000</td><td>🚨 DESAPARECIDO</td></tr>
</table>
<h4>Nota del Auditor:</h4>
<p><em>"Se detectaron discrepancias contables en las últimas 3 subastas. El Sr. Baker tiene deudas personales por $120,000 según informe crediticio."</em></p>', 
NULL, NULL);

-- Documentos nuevos (Historia 4: La Conspiración del Teatro)
INSERT INTO documento (historia_id, clave, nombre, icono, contenido, codigo_correcto, pista_nombre) VALUES
(4, 'programa_obra', 'Programa de la Obra', '🎭', 
'<h3>Estreno: "LA VERDAD OCULTA"</h3>
<p><strong>Director:</strong> Augusto Bellini</p>
<h4>Elenco Principal:</h4>
<ul>
<li><strong>Valentina Rossi</strong> - Protagonista
  <br><em>Bio: Estrella en ascenso. Esta sería su consagración definitiva.</em></li>
<li><strong>Ricardo Fontana</strong> - Antagonista
  <br><em>Bio: Actor veterano. Hace 15 años protagonizó escándalo que arruinó su carrera. Bellini fue testigo clave en ese juicio.</em></li>
<li><strong>Giovanni Esposito</strong> - Productor Ejecutivo
  <br><em>Inversión total: $2.5 millones. El teatro está al borde de la bancarrota.</em></li>
</ul>
<h4>Nota de Prensa:</h4>
<p>"Bellini planea anunciar cambios radicales en el elenco durante el estreno."</p>', 
NULL, NULL),

(4, 'contrato_director', 'Contrato del Director', '📄', 
'<h3>Acuerdo Contractual - Teatro Imperial</h3>
<p><strong>Entre:</strong> Augusto Bellini y Giovanni Esposito</p>
<p><strong>Fecha:</strong> 10/12/2025</p>
<h4>Cláusulas Especiales:</h4>
<ol>
<li><strong>Control Creativo Absoluto:</strong> Bellini puede reemplazar actores sin consultar</li>
<li><strong>Auditoría Financiera:</strong> Bellini tiene acceso total a las cuentas del teatro</li>
<li><strong>Cláusula de Rescisión:</strong> Si se detecta fraude, Esposito pierde todo</li>
</ol>
<h4>Anexo Confidencial (Filtrado):</h4>
<p><em>"Bellini descubrió malversación de $340,000. Amenaza con denunciar antes del estreno."</em></p>
<p><strong>Firmantes:</strong> A. Bellini ✍️ | G. Esposito ✍️</p>', 
NULL, NULL);

-- Documentos nuevos (Historia 5: Muerte en el Expreso Nocturno)
INSERT INTO documento (historia_id, clave, nombre, icono, contenido, codigo_correcto, pista_nombre) VALUES
(5, 'lista_pasajeros', 'Lista de Pasajeros', '🎫', 
'<h3>Expreso del Este - Manifiesto de Pasajeros</h3>
<p><strong>Fecha:</strong> 25/01/2026 | <strong>Ruta:</strong> Moscú → París</p>
<table border="1" style="width:100%; border-collapse:collapse;">
<tr><th>Compartimento</th><th>Pasajero</th><th>Nacionalidad</th><th>Observaciones</th></tr>
<tr><td>A1</td><td><strong>Víctima (Dimitri Volkov)</strong></td><td>🇷🇺 Rusa</td><td>Empresario. Encontrado muerto 21:30</td></tr>
<tr><td>A2</td><td>Coronel Montgomery</td><td>🇬🇧 Británica</td><td>Militar retirado. Nervioso.</td></tr>
<tr><td>A3</td><td>Lady Catherine Ashford</td><td>🇬🇧 Británica</td><td>Aristocracia. Viaja sola.</td></tr>
<tr><td>B1</td><td>Dr. Heinrich Braun</td><td>🇩🇪 Alemana</td><td>Científico. Equipaje sospechoso.</td></tr>
<tr><td>B2</td><td>Señora Dubois</td><td>🇫🇷 Francesa</td><td>Viuda. Ida y vuelta.</td></tr>
<tr><td>B3</td><td>Inspector Pavel Ivanov</td><td>🇷🇺 Rusa</td><td>⚠️ Policía. Investigaba a Volkov.</td></tr>
</table>
<p><strong>Nota del Conductor:</strong> "Coronel Montgomery pidió cambio de compartimento 2 veces. Ivanov viajaba de incógnito."</p>', 
NULL, NULL),

(5, 'horario_tren', 'Horario del Tren', '🕐', 
'<h3>Itinerario y Cronología del Crimen</h3>
<h4>Horario Oficial:</h4>
<ul>
<li><strong>18:00</strong> - Partida desde Moscú</li>
<li><strong>19:30</strong> - Cena servida en vagón comedor</li>
<li><strong>20:45</strong> - Último avistamiento de Volkov vivo</li>
<li><strong>21:30</strong> - Cuerpo descubierto por empleado</li>
<li><strong>23:15</strong> - Próxima estación (no puede detenerse por tormenta)</li>
</ul>
<h4>Testimonios de Ubicación (20:30-21:30):</h4>
<table border="1" style="width:100%;">
<tr><th>Pasajero</th><th>Ubicación Declarada</th><th>Testigos</th></tr>
<tr><td>Coronel Montgomery</td><td>Vagón comedor</td><td>✓ Confirmado por camarero</td></tr>
<tr><td>Lady Catherine</td><td>Su compartimento leyendo</td><td>❌ Sin confirmar</td></tr>
<tr><td>Dr. Braun</td><td>Laboratorio portátil</td><td>❌ Sin confirmar</td></tr>
<tr><td>Sra. Dubois</td><td>Durmiendo</td><td>❌ Sin confirmar</td></tr>
<tr><td>Inspector Ivanov</td><td>Investigando discretamente</td><td>⚠️ Visto cerca del compartimento A1</td></tr>
</table>
<p><strong>CRUCIAL:</strong> Ventana de 45 minutos donde cualquiera pudo acceder al compartimento.</p>', 
NULL, NULL);

-- Documentos nuevos (Historia 6: El Enigma de la Galería Oscura)
INSERT INTO documento (historia_id, clave, nombre, icono, contenido, codigo_correcto, pista_nombre) VALUES
(6, 'catalogo_obras', 'Catálogo de Obras', '🎨', 'Catálogo completo de todas las obras de la galería con valoraciones actualizadas.', NULL, NULL),
(6, 'informe_policial', 'Informe Policial', '👮', 'Análisis forense de las escenas de los tres robos anteriores. Patrón identificado.', NULL, 'Mensaje Cifrado 1');

-- Documentos nuevos (Historia 7: El Caso del Manuscrito Perdido)
INSERT INTO documento (historia_id, clave, nombre, icono, contenido, codigo_correcto, pista_nombre) VALUES
(7, 'registro_accesos', 'Registro de Accesos', '🔐', 
'<h3>Sistema de Control de Acceso - Bóveda Principal</h3>
<p><strong>Fecha:</strong> 15/01/2026</p>
<table border="1" style="width:100%; border-collapse: collapse;">
<tr><th>Hora</th><th>Usuario</th><th>Acción</th><th>Código Biométrico</th></tr>
<tr><td>08:15</td><td>Dra. Elena Vásquez</td><td>Acceso</td><td>✓ Verificado</td></tr>
<tr><td>14:30</td><td>Dr. Hassan Al-Rashid</td><td>Acceso</td><td>✓ Verificado</td></tr>
<tr><td>19:22</td><td>Prof. Marcus Whitfield</td><td>Acceso</td><td>✓ Verificado</td></tr>
<tr><td>23:47</td><td>Prof. Marcus Whitfield</td><td>Acceso</td><td>✓ Verificado</td></tr>
<tr><td>23:51</td><td>SISTEMA DESACTIVADO</td><td>---</td><td>❌ Manual Override</td></tr>
<tr><td>00:14</td><td>SISTEMA REACTIVADO</td><td>---</td><td>✓ Restaurado</td></tr>
</table>
<p><em>Nota: 23 minutos sin monitoreo durante periodo crítico</em></p>', 
'WHITFIELD', 'Registro de Acceso Biométrico'),

(7, 'correo_comprador', 'Email Interceptado', '📧', 
'<h3>Comunicación Encriptada [DESENCRIPTADA]</h3>
<p><strong>De:</strong> [email protected]</p>
<p><strong>Para:</strong> [email protected]</p>
<p><strong>Asunto:</strong> RE: Adquisición Especial</p>
<p>Profesor,</p>
<p>Confirmamos el pago de <strong>USD $2,000,000</strong> en cuenta offshore por la adquisición del manuscrito Voynich 2.0.</p>
<p><strong>Condiciones:</strong></p>
<ul>
<li>Entrega dentro de 48 horas</li>
<li>Sin daños al documento</li>
<li>Discreción absoluta</li>
</ul>
<p>La transferencia se completará una vez verificada la autenticidad.</p>
<p>Coordenadas de entrega: [CENSURADO]</p>
<p><em>Este mensaje se autodestruirá en 24 horas</em></p>', 
NULL, 'Email Encriptado'),

(7, 'analisis_particulas', 'Análisis Forense', '🔬', 
'<h3>Reporte de Laboratorio Forense</h3>
<p><strong>Evidencia:</strong> Partículas encontradas en maletín de cuero</p>
<p><strong>Ubicación:</strong> Oficina Prof. Marcus Whitfield</p>
<h4>Resultados:</h4>
<ul>
<li><strong>Composición:</strong> Pergamino de piel de becerro (siglo XIV)</li>
<li><strong>Pigmentos:</strong> Azurita y bermellón (coinciden con manuscrito)</li>
<li><strong>Fibras:</strong> Celulosa medieval compatible</li>
<li><strong>ADN:</strong> Trazas biológicas del Prof. Whitfield</li>
</ul>
<p><strong>Conclusión:</strong> Las partículas provienen definitivamente del manuscrito desaparecido.</p>
<p><strong>Fecha de análisis:</strong> 18/01/2026</p>', 
NULL, 'Polvo de Manuscrito');

-- Documentos nuevos (Historia 8: Asesinato en el Laboratorio Cerrado)
INSERT INTO documento (historia_id, clave, nombre, icono, contenido, codigo_correcto, pista_nombre) VALUES
(8, 'analisis_toxicologico', 'Reporte Toxicológico', '☠️', 
'<h3>Análisis Post-Mortem - Dr. Viktor Steiner</h3>
<p><strong>Causa de muerte:</strong> Envenenamiento por neurotoxina sintética</p>
<p><strong>Sustancia identificada:</strong> VX-7 (compuesto experimental)</p>
<p><strong>Vía de administración:</strong> Inhalación por sistema de ventilación</p>
<p><strong>Tiempo de exposición:</strong> Aproximadamente 90 segundos</p>
<p><strong>Tiempo hasta muerte:</strong> 5-7 minutos</p>
<p><em>Nota crítica: Esta sustancia solo está disponible en el laboratorio de Bioquímica del instituto.</em></p>
<p><strong>Acceso a VX-7:</strong></p>
<ul>
<li>Dra. Katrina Volkov - Autorización Nivel 4</li>
<li>Dr. James Patterson - Autorización Nivel 3</li>
<li>Dra. Adriana Costa - Autorización Nivel 5</li>
</ul>', 
'PATTERSON', 'Vial de Neurotoxina'),

(8, 'log_biometrico', 'Log de Acceso Biométrico', '👁️', 
'<h3>Sistema de Autenticación - Laboratorio 5A</h3>
<p><strong>Fecha del incidente:</strong> 20/01/2026</p>
<table border="1" style="width:100%;">
<tr><th>Hora</th><th>Usuario</th><th>Huella Digital</th><th>Resultado</th></tr>
<tr><td>08:30</td><td>Dr. Viktor Steiner</td><td>✓</td><td>ACCESO CONCEDIDO</td></tr>
<tr><td>09:15</td><td>Dr. James Patterson</td><td>✓</td><td>ACCESO DENEGADO</td></tr>
<tr><td>09:47</td><td>Dr. James Patterson</td><td>✓</td><td>ACCESO CONCEDIDO</td></tr>
<tr><td>11:23</td><td>ALERTA: SELLADO INTERNO</td><td>-</td><td>Lab cerrado desde adentro</td></tr>
<tr><td>14:15</td><td>Dr. Viktor Steiner</td><td>✓</td><td>⚠️ ACCESO POST-MORTEM</td></tr>
</table>
<p><strong>ANOMALÍA DETECTADA:</strong> Huella de Steiner usada 2 horas después de su muerte confirmada.</p>
<p><em>Conclusión: Alguien clonó su huella digital.</em></p>', 
NULL, 'Código de Acceso Clonado'),

(8, 'email_amenaza', 'Comunicación Interna', '📨', 
'<h3>Email - Servidor Institucional</h3>
<p><strong>De:</strong> v.steiner@institute.org</p>
<p><strong>Para:</strong> j.patterson@institute.org</p>
<p><strong>Fecha:</strong> 18/01/2026 - 22:37</p>
<p><strong>Asunto:</strong> Plagio y Consecuencias</p>
<p>James,</p>
<p>He descubierto que tu "innovadora investigación" sobre catalizadores moleculares es en realidad MI trabajo de los últimos 3 años.</p>
<p>Los datos en tu solicitud de patente son idénticos a mis notas privadas del servidor seguro.</p>
<p><strong>Tenés 48 horas para retractarte públicamente o presentaré evidencia ante el comité de ética.</strong></p>
<p>Tu carrera acabará. No habrá segunda oportunidad.</p>
<p>- Viktor</p>', 
NULL, 'Email de Amenaza');

-- Documentos nuevos (Historia 9: La Herencia del Patriarca)
INSERT INTO documento (historia_id, clave, nombre, icono, contenido, codigo_correcto, pista_nombre) VALUES
(9, 'testamento_sellado', 'Testamento Final', '📜', 
'<h3>Última Voluntad y Testamento de Edmundo Salvatierra</h3>
<p><strong>Fecha:</strong> 10/01/2026</p>
<p><strong>En pleno uso de mis facultades mentales, declaro:</strong></p>
<h4>Distribución de Bienes:</h4>
<ul>
<li><strong>Tomás Salvatierra (hijo menor):</strong> 60% del patrimonio total</li>
<li><strong>Valentina Salvatierra:</strong> 20% del patrimonio</li>
<li><strong>Rodrigo Salvatierra:</strong> 10% del patrimonio</li>
<li><strong>Cristina Vega (esposa):</strong> 10% del patrimonio</li>
</ul>
<h4>Justificación:</h4>
<p>"Rodrigo ha demostrado ambición desmedida y falta de ética. Tomás, aunque distante, ha mantenido integridad moral. La empresa familiar quedará bajo su dirección."</p>
<p><strong>Firmado:</strong> Edmundo Salvatierra [✍️]</p>
<p><em>Certificado por Julio Mendoza - Abogado</em></p>', 
'TOMAS', 'Testamento Original'),

(9, 'informe_toxicologia', 'Análisis Toxicológico', '💉', 
'<h3>Reporte Forense - Caso Salvatierra</h3>
<p><strong>Víctima:</strong> Edmundo Salvatierra (68 años)</p>
<p><strong>Hora de muerte:</strong> 23:45 (estimado)</p>
<p><strong>Causa:</strong> Insuficiencia respiratoria aguda</p>
<h4>Hallazgos Toxicológicos:</h4>
<ul>
<li><strong>Morfina:</strong> 180mg (dosis letal: 60-200mg)</li>
<li><strong>Presencia en vino tinto:</strong> Confirmada</li>
<li><strong>Origen:</strong> Morfina de grado médico (farmacéutica)</li>
</ul>
<h4>Análisis de Copa:</h4>
<p><strong>Huellas dactilares identificadas:</strong></p>
<ul>
<li>Edmundo Salvatierra (víctima)</li>
<li>Tomás Salvatierra ⚠️</li>
</ul>
<p><strong>Conclusión:</strong> Homicidio por envenenamiento premeditado.</p>', 
NULL, 'Copa Contaminada'),

(9, 'audio_seguridad', 'Grabación de Audio', '🎙️', 
'<h3>Transcripción - Sistema de Seguridad</h3>
<p><strong>Ubicación:</strong> Biblioteca Privada</p>
<p><strong>Fecha:</strong> 14/01/2026 - 20:15</p>
<p><strong>Participantes:</strong> Edmundo Salvatierra y Tomás Salvatierra</p>
<hr>
<p><strong>Edmundo:</strong> "Tomás, necesito que sepas algo antes de mañana."</p>
<p><strong>Tomás:</strong> "¿De qué se trata, padre?"</p>
<p><strong>Edmundo:</strong> "He modificado mi testamento. Rodrigo no recibirá la empresa."</p>
<p><strong>Tomás:</strong> "Yo tampoco la quiero. Sabés que prefiero mi consultorio."</p>
<p><strong>Edmundo:</strong> "Lo sé, hijo. Pero vos sos el único con principios. No puedo dejar todo en manos de Rodrigo después de lo que descubrí."</p>
<p><strong>Tomás:</strong> [Silencio] "¿Qué descubriste?"</p>
<p><strong>Edmundo:</strong> "Malversación, fraude... Ha estado robando durante años."</p>
<p><strong>Tomás:</strong> "Esto va a destruir a la familia."</p>
<p><strong>Edmundo:</strong> "La justicia es más importante que la paz falsa."</p>
<hr>
<p><em>[Conversación termina abruptamente]</em></p>', 
NULL, 'Conversación Grabada');

-- Documentos nuevos (Historia 10: El Archivo Fantasma)
INSERT INTO documento (historia_id, clave, nombre, icono, contenido, codigo_correcto, pista_nombre) VALUES
(10, 'log_transferencia', 'Log de Transferencia de Datos', '💾', 
'<h3>Análisis Forense Digital</h3>
<p><strong>Servidor:</strong> CLASSIFIED-VAULT-07</p>
<p><strong>Fecha del incidente:</strong> 22/01/2026</p>
<h4>Actividad Sospechosa Detectada:</h4>
<table border="1" style="width:100%;">
<tr><th>Hora</th><th>Acción</th><th>Usuario</th><th>Datos</th></tr>
<tr><td>03:14:22</td><td>Login</td><td>Mayor R. Santana</td><td>Credenciales Nivel 5</td></tr>
<tr><td>03:17:08</td><td>Acceso Bóveda Digital</td><td>Santana</td><td>Archivos EXP-2890</td></tr>
<tr><td>03:19:45</td><td>Copia a dispositivo externo</td><td>Santana</td><td>487 MB</td></tr>
<tr><td>03:23:11</td><td>Desconexión USB</td><td>Santana</td><td>✓ Completado</td></tr>
<tr><td>03:24:03</td><td>Logout</td><td>Santana</td><td>Sesión terminada</td></tr>
</table>
<p><strong>IP de conexión externa detectada:</strong> 185.220.xxx.xxx (Rusia)</p>
<p><em>Nota: Actividad ocurrida durante turno nocturno sin autorización previa.</em></p>', 
'SANTANA', 'Transferencia de Datos'),

(10, 'amenaza_email', 'Email Anónimo Interceptado', '⚠️', 
'<h3>Mensaje Encriptado [PARCIALMENTE DESENCRIPTADO]</h3>
<p><strong>Origen:</strong> Servidor proxy anónimo (Darknet)</p>
<p><strong>Destinatario:</strong> Mayor Ricardo Santana [Número privado]</p>
<p><strong>Fecha:</strong> 15/01/2026</p>
<hr>
<p>Mayor,</p>
<p>Tenemos a tu esposa y a tu hija. Están seguras... por ahora.</p>
<p><strong>Tus órdenes son simples:</strong></p>
<ol>
<li>Accedé a los archivos EXP-2890 del búnker</li>
<li>Copiá TODO en el dispositivo USB que dejamos en tu casillero</li>
<li>Dejá el USB en [UBICACIÓN CENSURADA] antes del 23/01</li>
</ol>
<p><strong>Si cumplís:</strong> Tu familia será liberada ilesa.</p>
<p><strong>Si fallás o informás a las autoridades:</strong> Nunca las volverás a ver.</p>
<p>No nos subestimes. Ya violamos tu seguridad una vez.</p>
<p>[Adjunto: Foto de tu hija en su escuela - tomada ayer]</p>
<hr>
<p><em>Conclusión forense: Organización criminal internacional.</em></p>', 
NULL, 'Amenaza Encubierta'),

(10, 'informe_ia', 'Análisis de Inteligencia Artificial', '🤖', 
'<h3>Sistema de Detección de Anomalías - IA Sentinel</h3>
<p><strong>Patrón de comportamiento analizado:</strong> Mayor Ricardo Santana</p>
<p><strong>Periodo:</strong> Últimos 30 días</p>
<h4>Anomalías Detectadas:</h4>
<ul>
<li><strong>Nivel de estrés:</strong> +340% sobre promedio histórico</li>
<li><strong>Accesos nocturnos:</strong> 7 (promedio histórico: 0.2/mes)</li>
<li><strong>Patrones de sueño:</strong> Insomnio severo registrado</li>
<li><strong>Comunicaciones:</strong> 23 llamadas a números no registrados</li>
</ul>
<h4>Evaluación Psicológica Automatizada:</h4>
<p><strong>Conclusión:</strong> Sujeto bajo coacción externa con 94.7% de probabilidad.</p>
<p><strong>Recomendación:</strong> Investigación inmediata de entorno familiar y posible chantaje.</p>
<p><em>Este perfil fue generado 48 horas antes del incidente pero no fue revisado a tiempo.</em></p>', 
NULL, 'Confesión Parcial');

-- ========================================
-- DATOS: LOGROS
-- ========================================

INSERT INTO `logro` VALUES 
(1,'primer_caso','Primer Caso Resuelto','Resolvé tu primer misterio exitosamente','fa-solid fa-star',10,1),
(2,'detective_novato','Detective Novato','Completá 3 casos diferentes','fa-solid fa-medal',20,1),
(3,'detective_experto','Detective Experto','Completá 10 casos sin errores','fa-solid fa-crown',50,1),
(4,'perfeccionista','Perfeccionista','Ganá un caso con puntuación perfecta (100 puntos)','fa-solid fa-gem',30,1),
(5,'coleccionista','Coleccionista de Pistas','Encontrá todas las pistas en 5 casos diferentes','fa-solid fa-lightbulb',25,1),
(6,'explorador','Explorador Incansable','Visitá todas las ubicaciones en 3 historias','fa-solid fa-map-marked-alt',20,1),
(7,'velocista','Velocista','Resolvé un caso en menos de 10 minutos','fa-solid fa-bolt',15,1),
(8,'persistente','Persistente','Completá un caso después de fallar 2 intentos','fa-solid fa-heart',15,1),
(9,'madrugador','Madrugador','Iniciá una partida entre las 5am y 7am','fa-solid fa-sun',5,1),
(10,'nocturno','Detective Nocturno','Resolvé un caso entre las 12am y 3am','fa-solid fa-moon',10,1);

-- ========================================
-- DATOS: PARTIDAS (existentes)
-- ========================================

INSERT INTO `partida` VALUES 
(1,6,1,'2025-10-23 13:12:44','2025-11-14 16:07:12','GANADA',1,0,100,'Código descifrado: 7391',1,3),
(2,4,1,'2025-11-04 21:53:27',NULL,'EN_PROGRESO',0,0,0,NULL,0,3),
(3,9,2,'2025-11-05 02:26:18',NULL,'EN_PROGRESO',0,0,0,NULL,0,3),
(4,6,2,'2025-11-14 16:07:29','2025-11-14 16:07:59','GANADA',0,0,100,'Código descifrado: 7391',1,3),
(5,6,2,'2025-11-14 16:08:43','2025-11-14 16:09:22','GANADA',0,0,100,'Código descifrado: 7391',1,3),
(6,6,2,'2025-11-14 16:13:06','2025-11-14 16:13:18','GANADA',0,0,100,'Código descifrado: 7391',1,3),
(7,6,2,'2025-11-14 16:21:13','2025-11-14 16:21:43','GANADA',0,0,100,'Código descifrado: 7391',1,3),
(8,6,2,'2025-11-14 16:29:32','2025-11-14 16:29:41','GANADA',0,0,100,'Código descifrado: 7391',1,3),
(9,6,2,'2025-11-14 16:52:17','2025-11-14 16:52:23','GANADA',0,0,100,'Código descifrado: 7391',1,3),
(10,6,2,'2025-11-14 16:55:37','2025-11-14 16:56:33','GANADA',0,0,100,'Código descifrado: 7391',1,3),
(11,6,2,'2025-11-14 17:00:48','2025-11-14 17:00:54','GANADA',0,0,100,'Código descifrado: 7391',1,3),
(12,6,1,'2025-11-15 17:51:24','2025-11-15 17:51:34','GANADA',1,0,100,'Código descifrado: 7391',1,3),
(13,6,2,'2025-11-15 17:53:56','2025-11-15 17:54:18','GANADA',0,0,100,'Código descifrado: 7391',1,3),
(19,6,2,'2025-11-15 18:27:15','2025-11-15 19:20:37','GANADA',0,0,100,'Código descifrado: 7391',1,3),
(21,6,1,'2025-11-16 17:42:26','2025-11-16 17:42:37','GANADA',1,0,100,'Código descifrado: 7391',1,3),
(22,6,2,'2025-11-16 17:42:49','2025-11-16 17:46:22','GANADA',0,0,0,NULL,0,3),
(23,6,2,'2025-11-16 17:49:52','2025-11-16 17:50:01','GANADA',0,0,100,'Código descifrado: 2580',1,3),
(24,6,2,'2025-11-16 17:52:10','2025-11-16 17:52:53','GANADA',0,0,100,'Código descifrado: 2580',1,3),
(25,6,2,'2025-11-16 17:53:30','2025-11-18 17:22:22','GANADA',0,0,100,'Código descifrado: 2580',1,3),
(26,6,1,'2025-11-18 17:25:09','2025-11-19 13:03:42','GANADA',0,0,100,'Código descifrado: 7391',1,3),
(27,6,1,'2025-11-19 13:06:22','2025-11-19 13:06:51','GANADA',0,0,100,'Código descifrado: 7391',1,3),
(28,6,1,'2025-11-19 13:10:24','2025-11-19 13:10:53','GANADA',0,0,100,'Código descifrado: 7391',1,3),
(29,6,1,'2025-11-19 13:11:01','2025-11-19 13:11:07','GANADA',0,0,100,'Código descifrado: 7391',1,3),
(30,6,1,'2025-11-19 13:12:11','2025-11-19 13:12:25','GANADA',0,0,100,'Código descifrado: 7391',1,3),
(31,6,1,'2025-11-19 13:14:50','2025-11-19 13:17:54','GANADA',0,0,100,'Código descifrado: 7391',1,3),
(32,6,1,'2025-11-19 13:38:23','2025-11-19 13:39:03','GANADA',0,0,100,'Código descifrado: 7391',1,3),
(33,6,1,'2025-11-19 13:39:18',NULL,'EN_PROGRESO',0,0,0,NULL,0,3),
(34,15,2,'2026-01-19 16:39:32','2026-01-19 16:40:43','GANADA',0,0,100,'Código descifrado: 2580',1,3),
(35,15,1,'2026-01-19 17:32:05','2026-01-19 17:33:03','GANADA',0,0,100,'Código descifrado: 7391',1,3);

-- ========================================
-- DATOS: PROGRESO_PISTA (existentes)
-- ========================================

INSERT INTO `progreso_pista` VALUES 
(1,1,16,'2025-11-14 15:53:33'),
(5,12,16,'2025-11-15 17:51:31'),
(6,21,16,'2025-11-16 17:42:36'),
(7,22,17,'2025-11-16 17:46:20'),
(8,23,17,'2025-11-16 17:50:00'),
(9,24,17,'2025-11-16 17:52:47'),
(10,25,17,'2025-11-18 17:22:21'),
(11,26,16,'2025-11-19 13:03:41'),
(12,27,16,'2025-11-19 13:06:44'),
(13,28,16,'2025-11-19 13:10:52'),
(14,29,16,'2025-11-19 13:11:06'),
(15,30,16,'2025-11-19 13:12:24'),
(16,31,16,'2025-11-19 13:17:54'),
(17,32,16,'2025-11-19 13:38:58'),
(18,34,17,'2026-01-19 16:40:41'),
(19,35,16,'2026-01-19 17:33:02');

-- ========================================
-- VERIFICACIÓN FINAL
-- ========================================

SELECT '=== RESUMEN DE DATOS ===' AS info;
SELECT COUNT(*) as total_usuarios FROM usuario;
SELECT COUNT(*) as total_historias FROM historia;
SELECT COUNT(*) as total_personajes FROM personaje;
SELECT COUNT(*) as total_ubicaciones FROM ubicacion;
SELECT COUNT(*) as total_pistas FROM pista;
SELECT COUNT(*) as total_documentos FROM documento;
SELECT COUNT(*) as total_logros FROM logro;

SELECT '=== HISTORIAS POR LIGA ===' AS info;
SELECT liga_minima, COUNT(*) as cantidad, GROUP_CONCAT(titulo SEPARATOR ', ') as historias
FROM historia 
GROUP BY liga_minima 
ORDER BY FIELD(liga_minima, 'bronce', 'plata', 'oro', 'platino', 'diamante');

-- ========================================
-- FIN DEL SCRIPT
-- ========================================

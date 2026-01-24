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
(1,'Administrador','admin@mansion.com','6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b','admin','2025-10-22 14:24:07',1,0),
(2,'Detective Juan','juan@detective.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4','jugador','2025-10-22 14:24:07',1,0),
(4,'Administrador','adminCapo@mansion.com','6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b','admin','2025-10-22 14:33:59',1,0),
(5,'Serena','serena@gmail.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4','jugador','2025-10-22 14:55:55',0,0),
(6,'Bruno','bruno@gmail.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4','jugador','2025-10-22 15:07:51',1,1),
(7,'Maquina JSAJSAJ','Maquina@gmail.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4','jugador','2025-10-22 16:04:44',1,0),
(8,'Jano Martinez Ruiz','jano@gmail.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4','jugador','2025-10-22 20:01:52',1,0),
(9,'Juanfra','juanfraa032@gmail.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4','jugador','2025-11-04 22:43:28',1,1),
(10,'Manuel','manuel@gmail.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4','jugador','2025-11-19 12:33:04',1,0),
(11,'Manuna','manu@gmail.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4','jugador','2025-11-19 12:46:48',1,0),
(12,'fsaf','dfs@fdsf','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4','jugador','2025-11-19 13:01:25',1,0),
(13,'Juan Manuel','juanma@gmail.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4','jugador','2025-11-19 13:02:16',1,0),
(14,'Menu 2','menu@gmail.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4','jugador','2025-11-19 13:35:37',0,0),
(15,'sere','sere22giacomelli@gmail.com','a75dfb04f127df2fb7dbad54350329e73b1664ebd2a20080b23ea60bc3530b91','jugador','2026-01-16 16:47:22',1,0);

-- USUARIOS NUEVOS
INSERT INTO `usuario` (nombre, email, password, rol, activo) VALUES
('Carlos Mendoza', 'carlos.mendoza@mail.com', 'e10adc3949ba59abbe56e057f20f883e', 'jugador', 1),  -- pass: 123456
('María López', 'maria.lopez@mail.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'jugador', 1),      -- pass: password
('Pedro Sánchez', 'pedro.sanchez@mail.com', '25d55ad283aa400af464c76d713c07ad', 'jugador', 1),   -- pass: 12345678
('Ana Ramírez', 'ana.ramirez@mail.com', 'e10adc3949ba59abbe56e057f20f883e', 'jugador', 1),       -- pass: 123456
('Luis Torres', 'luis.torres@mail.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'jugador', 1);       -- pass: password

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
 1, 5, 90, 'platino');

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

-- ========================================
-- DATOS: DOCUMENTOS
-- ========================================

-- Documentos existentes
INSERT INTO `documento` VALUES 
(1,1,'nota_codigo','Nota manuscrita: \"Cómo descifrar el código\"','fa-regular fa-file-lines','<h3>Nota manuscrita</h3>\n  <p>No mires números… Escuchá sus <strong>nombres</strong> en castellano y tomá la <em>primera letra</em> de cada uno.</p>\n  <p>Ej: <em>Siete</em>, <em>Tres</em>, <em>Nueve</em>, <em>Uno</em> → <code>STNU</code>… ¿o quizá <strong>7-3-9-1</strong>?</p>','7391','Código de la computadora'),
(2,1,'correo_sospechoso','Correo sospechoso: \"El código está oculto\"','fa-regular fa-envelope','<h3>Correo sospechoso</h3>\n  <p><strong>Asunto:</strong> \"No abras la computadora\"</p>\n  <p><strong>Mensaje:</strong> \"Si alguien descifra <em>Siete Tres Nueve Uno</em>, podrá ver todo.\"</p>',NULL,NULL),
(3,2,'diario_victima','Diario de la víctima','fa-regular fa-book','<h3>Diario de la víctima</h3>\n  <p><strong>Última entrada:</strong> \"Cambié mi código del celular por algo que nunca olvidaré...\"</p>\n  <p>\"La habitación donde todo comenzó... <em>Dos-Cinco-Ocho-Cero</em>. Ahí está la clave.\"</p>\n  <p><em>Nota al margen:</em> \"Si me pasa algo, revisen mi teléfono.\"</p>','2580','Código del celular'),
(4,2,'nota_recepcion','Nota de recepción del hotel','fa-regular fa-note-sticky','<h3>Nota de recepción</h3>\n  <p><strong>Recepcionista:</strong> \"El huésped de la habitación <strong>2580</strong> solicitó cambiar su PIN del celular\"</p>\n  <p>\"Dijo que lo cambiaría por el número de su habitación favorita para no olvidarlo.\"</p>\n  <p><strong>Fecha:</strong> 3 días antes del incidente</p>',NULL,NULL),
(5,2,'mensaje_celular','Mensaje en el celular bloqueado','fa-solid fa-mobile-screen-button','<h3>Mensaje visible en la pantalla</h3>\n  <p style=\"text-align:center; font-size:1.2em; border: 2px solid #666; padding:20px; background:#f0f0f0; border-radius:10px;\">\n    <strong>? Celular bloqueado</strong><br/>\n    <em>Ingrese PIN para desbloquear</em><br/>\n    <small style=\"color:#888;\">Pista: Número de habitación memorable</small>\n  </p>\n  <p><strong>Pregunta de seguridad:</strong> \"¿Cuál es tu habitación favorita?\"</p>',NULL,NULL);

-- Documentos nuevos (Historia 3: El Secreto del Reloj Antiguo)
INSERT INTO documento (historia_id, clave, nombre, icono, contenido, codigo_correcto, pista_nombre) VALUES
(3, 'informe_seguridad', 'Informe de Seguridad', '📹', 'Registro de todos los movimientos capturados por las cámaras durante el día de la subasta. El análisis muestra una discrepancia temporal sospechosa.', NULL, 'Video de Seguridad'),
(3, 'registro_subastas', 'Registro de Subastas', '📋', 'Historial de todas las subastas del mes. Revela irregularidades en las transacciones recientes.', NULL, NULL);

-- Documentos nuevos (Historia 4: La Conspiración del Teatro)
INSERT INTO documento (historia_id, clave, nombre, icono, contenido, codigo_correcto, pista_nombre) VALUES
(4, 'programa_obra', 'Programa de la Obra', '🎭', 'Programa oficial con biografías del elenco. Información interesante sobre el pasado de los actores.', NULL, NULL),
(4, 'contrato_director', 'Contrato del Director', '📄', 'Acuerdo contractual con cláusulas especiales sobre manejo de fondos y reparto.', NULL, NULL);

-- Documentos nuevos (Historia 5: Muerte en el Expreso Nocturno)
INSERT INTO documento (historia_id, clave, nombre, icono, contenido, codigo_correcto, pista_nombre) VALUES
(5, 'lista_pasajeros', 'Lista de Pasajeros', '🎫', 'Registro completo de todos los pasajeros del tren. Algunos nombres despiertan sospechas.', NULL, NULL),
(5, 'horario_tren', 'Horario del Tren', '🕐', 'Itinerario detallado con paradas y tiempos. Información crucial para establecer cronología.', NULL, NULL);

-- Documentos nuevos (Historia 6: El Enigma de la Galería Oscura)
INSERT INTO documento (historia_id, clave, nombre, icono, contenido, codigo_correcto, pista_nombre) VALUES
(6, 'catalogo_obras', 'Catálogo de Obras', '🎨', 'Catálogo completo de todas las obras de la galería con valoraciones actualizadas.', NULL, NULL),
(6, 'informe_policial', 'Informe Policial', '👮', 'Análisis forense de las escenas de los tres robos anteriores. Patrón identificado.', NULL, 'Mensaje Cifrado 1');

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

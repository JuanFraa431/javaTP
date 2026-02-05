# Misterio en la Mansión — README

Sistema web para gestionar y jugar historias de misterio con roles de administrador y jugador. Incluye panel de administración (usuarios, historias, ubicaciones, pistas, documentos, logros, estadísticas) y flujo de juego para jugadores con progreso, ligas y puntos.

El formato del juego es el siguiente: Existe una seccion de tutoriales para ver como se juega. Se cuentan con una serie de historias que se visualizan desde el dashboard de jugador y dependen de su categoria dentro del sistema. Mediante un chatbot se hacen preguntas e investigando sobre los documentos asignados a una historia se descubre el codigo secreto para poder finalizar la partida.

El sistema cuenta con una seccion de 10 logros desbloqueables que suman puntos para lograr pasar de categoria. Tambien hay una seccion de clasificaciones globales donde un usuario puede ver el desempenio de los demas jugadores.

En el dashboard del Admin se pueden ver estadisticas de historias, logros y usuarios para que el admin pueda tener una seccion donde se vuelque toda la informacion necesaria.

Adjunto carpeta con los entregables: https://drive.google.com/drive/folders/1XS-dzgd9Oc1mr0unj2Gpw7z4QqyM991Y?usp=sharing 

## Tecnologías
- Java 
- Jakarta Servlet 6 (Tomcat 10.1+)
- JSP/JSTL
- MySQL
- JDBC

## Estructura del proyecto
- `src/main/webapp` — Vistas JSP, estilos y `WEB-INF/web.xml` (rutas, welcome-file)
- `src/main/java`
  - `logic/` — Servlets y filtros (p. ej. `LoginServlet`, `AdminDashboardServlet`, `JugadorHomeServlet`)
  - `data/` — DAOs y conexión (`DbConn`)
  - `entities/` — Entidades simples
- `sql/` — Scripts para crear y poblar la base (incluye script completo de rebuild)
- `build/` — Salida de compilación (si se usa Eclipse)

## Rutas principales
- Página de inicio/login: `index.jsp` (welcome file)
- Sign in (POST): `/signin`
- Registro (POST): `/register`
- Recuperar contraseña (POST): `/forgot-password`
- Panel Admin: `/admin/dashboard`
- Home Jugador: `/jugador/home`

## Credenciales de prueba
Los datos iniciales del script cargan usuarios listos para probar:

- Admin principal
  - Email: `admin@mansion.com`
  - Contraseña: `1`
- Admin alternativo
  - Email: `adminCapo@mansion.com`
  - Contraseña: `1`
- Jugador (ejemplo 1)
  - Email: `juan@detective.com`
  - Contraseña: `1234`
- Jugador (ejemplo 2)
  - Email: `bruno@gmail.com`
  - Contraseña: `1234`

> Si ingresás con usuario inactivo, el login no te dejará pasar. Los admins pueden reactivar desde “Usuarios”.

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String ctx = request.getContextPath();
  Boolean tieneActiva = (Boolean) request.getAttribute("tieneActiva");
  if (tieneActiva == null) tieneActiva = Boolean.FALSE;
  String nombre = (String) session.getAttribute("nombre");
  if (nombre == null || nombre.isBlank()) nombre = "Detective";
%> 
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Misterio en la Mansión — Inicio</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Tipografías e iconos -->
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&family=Overpass:wght@600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <!-- Estilos de esta pantalla -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/home.css">
</head>
<body>

		

  <!-- Escena de fondo -->
  <div id="scene" aria-hidden="true">
    <div class="moon"></div>
    <div class="fog layer1"></div>
    <div class="fog layer2"></div>
    <div class="fog layer3"></div>
    <div class="bats">
      <span class="bat b1"></span>
      <span class="bat b2"></span>
      <span class="bat b3"></span>
    </div>
    <div class="vignette"></div>
  </div>

  <!-- Contenido -->
  <div class="page">
    <header class="brand">
      <div class="lantern"></div>
      <h1 class="game-title">Misterio en la Mansión</h1>
      <p class="tagline">Bienvenido, <strong><%= nombre %></strong>… tu intuición será puesta a prueba.</p>
    </header>

    <!-- Acciones rápidas -->
    <div class="quick">
      <!-- Continuar: si no hay partida activa, el JuegoServlet te redirige a nueva -->
      <a class="btn btn-primary" href="${pageContext.request.contextPath}/jugador/partidas/juego">
        <i class="fa-solid fa-play"></i> Continuar partida
      </a>
      <!-- Nueva partida: va a la selección de historia -->
      <a class="btn btn-secondary" href="${pageContext.request.contextPath}/jugador/partidas/nueva">
        <i class="fa-solid fa-plus"></i> Nueva partida
      </a>
    </div>

    <!-- Grid de opciones -->
    <main class="grid">
      <!-- Por ahora Historias reusa la selección de historia -->
      <a class="tile" href="${pageContext.request.contextPath}/jugador/partidas/nueva">
        <i class="fa-solid fa-book-open"></i>
        <h3>Historias</h3>
        <p>Elegí un caso y sumergite en una nueva investigación.</p>
        <span class="shine"></span>
      </a>

      <!-- Placeholder de “Mis partidas” (crealo cuando quieras) -->
      <a class="tile" href="${pageContext.request.contextPath}/jugador/partidas">
        <i class="fa-solid fa-magnifying-glass"></i>
        <h3>Mis partidas</h3>
        <p>Revisá tu progreso, pistas claves y estadísticas.</p>
        <span class="shine"></span>
      </a>

      <a class="tile" href="${pageContext.request.contextPath}/clasificaciones">
        <i class="fa-solid fa-trophy"></i>
        <h3>Clasificaciones</h3>
        <p>Compará tu deducción con otros detectives.</p>
        <span class="shine"></span>
      </a>

      <a class="tile" href="${pageContext.request.contextPath}/logros">
        <i class="fa-solid fa-medal"></i>
        <h3>Logros</h3>
        <p>Desbloqueá hitos al resolver los misterios.</p>
        <span class="shine"></span>
      </a>

      <a class="tile" href="${pageContext.request.contextPath}/tutorial">
        <i class="fa-solid fa-hat-wizard"></i>
        <h3>Tutorial</h3>
        <p>Aprendé mecánicas y trucos para investigar mejor.</p>
        <span class="shine"></span>
      </a>

      <a class="tile" href="${pageContext.request.contextPath}/jugador/perfil">
        <i class="fa-solid fa-user-gear"></i>
        <h3>Perfil</h3>
        <p>Actualizá tu nombre, correo y preferencias.</p>
        <span class="shine"></span>
      </a>
    </main>

    <!-- Barra inferior -->
    <footer class="foot">
      <a class="link" href="${pageContext.request.contextPath}/acerca">
        <i class="fa-solid fa-circle-info"></i> Acerca del juego
      </a>
      <span class="dot">•</span>
      <a class="link" href="${pageContext.request.contextPath}/soporte">
        <i class="fa-solid fa-life-ring"></i> Soporte
      </a>
      <span class="spacer"></span>
      <a class="btn btn-ghost" href="${pageContext.request.contextPath}/logout">
        <i class="fa-solid fa-door-open"></i> Salir
      </a>
    </footer>
  </div>

</body>
</html>

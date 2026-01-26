<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="entities.Usuario" %>
<%
  String ctx = request.getContextPath();
  Boolean tieneActiva = (Boolean) request.getAttribute("tieneActiva");
  if (tieneActiva == null) tieneActiva = Boolean.FALSE;
  String nombre = (String) session.getAttribute("nombre");
  if (nombre == null || nombre.isBlank()) nombre = "Detective";
  Integer userId = (Integer) session.getAttribute("userId");
  String avatarUrl = ctx + "/avatar?userId=" + (userId != null ? userId : 0);
  
  // Estadísticas del usuario
  Integer puntosTotales = (Integer) request.getAttribute("puntosTotales");
  String ligaActual = (String) request.getAttribute("ligaActual");
  String proximaLiga = (String) request.getAttribute("proximaLiga");
  Integer puntosProximaLiga = (Integer) request.getAttribute("puntosProximaLiga");
  Integer puntosFaltantes = (Integer) request.getAttribute("puntosFaltantes");
  Integer porcentajeProgreso = (Integer) request.getAttribute("porcentajeProgreso");
  Integer logrosDesbloqueados = (Integer) request.getAttribute("logrosDesbloqueados");
  Integer totalLogros = (Integer) request.getAttribute("totalLogros");
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
  <style>
    .liga-widget {
      background: linear-gradient(135deg, rgba(255,255,255,0.95), rgba(240,240,255,0.95));
      border-radius: 16px;
      padding: 20px;
      margin: 24px auto;
      max-width: 600px;
      box-shadow: 0 8px 24px rgba(0,0,0,0.15);
      backdrop-filter: blur(10px);
    }
    .liga-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 16px;
      flex-wrap: wrap;
      gap: 12px;
    }
    .liga-user-info {
      display: flex;
      align-items: center;
      gap: 14px;
      flex: 1;
    }
    .liga-avatar {
      width: 60px;
      height: 60px;
      border-radius: 50%;
      object-fit: cover;
      border: 3px solid rgba(255,255,255,.9);
      box-shadow: 0 4px 12px rgba(0,0,0,.2);
    }
    .liga-badge {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      padding: 10px 20px;
      border-radius: 25px;
      font-weight: 800;
      font-size: 1.3em;
      text-transform: uppercase;
      letter-spacing: 1.5px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.2);
    }
    .liga-bronce { background: linear-gradient(135deg, #cd7f32, #8b4513); color: white; }
    .liga-plata { background: linear-gradient(135deg, #c0c0c0, #a8a8a8); color: #222; }
    .liga-oro { background: linear-gradient(135deg, #ffd700, #ffed4e); color: #333; }
    .liga-platino { background: linear-gradient(135deg, #e5e4e2, #b9b9b9); color: #333; }
    .liga-diamante { background: linear-gradient(135deg, #b9f2ff, #00bfff); color: #003366; }
    .liga-stats {
      display: flex;
      gap: 20px;
      flex-wrap: wrap;
    }
    .liga-stats .stat {
      display: flex;
      align-items: center;
      gap: 6px;
      color: #555;
      font-size: 0.95em;
    }
    .liga-stats .stat i {
      color: #f39c12;
      font-size: 1.1em;
    }
    .liga-progreso {
      margin-top: 16px;
    }
    .progreso-info {
      display: flex;
      justify-content: space-between;
      margin-bottom: 8px;
      font-size: 0.9em;
      color: #666;
    }
    .puntos-faltantes {
      color: #f39c12;
      font-weight: 600;
    }
    .progress-bar {
      width: 100%;
      height: 12px;
      background: rgba(200,200,200,0.4);
      border-radius: 8px;
      overflow: hidden;
      box-shadow: inset 0 2px 4px rgba(0,0,0,0.1);
    }
    .progress-fill {
      height: 100%;
      background: linear-gradient(90deg, #4caf50, #8bc34a);
      border-radius: 8px;
      transition: width 0.5s ease;
      box-shadow: 0 0 8px rgba(76,175,80,0.5);
    }
    .liga-maxima {
      margin-top: 16px;
      text-align: center;
      padding: 12px;
      background: linear-gradient(135deg, #fff9e6, #ffe4b3);
      border-radius: 8px;
      color: #856404;
      font-weight: 700;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
    }
    .liga-maxima i {
      color: #ffc107;
      font-size: 1.3em;
    }
    @media (max-width: 600px) {
      .liga-header {
        flex-direction: column;
        align-items: flex-start;
      }
      .liga-badge {
        font-size: 1.1em;
      }
    }
  </style>
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

    <!-- Widget de Liga -->
    <% if (ligaActual != null && puntosTotales != null) { %>
    <div class="liga-widget">
      <div class="liga-header">
        <div class="liga-user-info">
          <img src="<%= avatarUrl %>" alt="Avatar" class="liga-avatar">
          <div class="liga-badge liga-<%= ligaActual %>">
            <i class="fa-solid fa-trophy"></i>
            <span><%= ligaActual.substring(0,1).toUpperCase() + ligaActual.substring(1) %></span>
          </div>
        </div>
        <div class="liga-stats">
          <div class="stat">
            <i class="fa-solid fa-star"></i>
            <span><strong><%= puntosTotales %></strong> puntos</span>
          </div>
          <div class="stat">
            <i class="fa-solid fa-medal"></i>
            <span><strong><%= logrosDesbloqueados %>/<%= totalLogros %></strong> logros</span>
          </div>
        </div>
      </div>
      
      <% if (!"diamante".equals(ligaActual)) { %>
      <div class="liga-progreso">
        <div class="progreso-info">
          <span>Próxima liga: <strong><%= proximaLiga.substring(0,1).toUpperCase() + proximaLiga.substring(1) %></strong></span>
          <span class="puntos-faltantes"><%= puntosFaltantes %> puntos restantes</span>
        </div>
        <div class="progress-bar">
          <div class="progress-fill" style="width: <%= porcentajeProgreso %>%"></div>
        </div>
      </div>
      <% } else { %>
      <div class="liga-maxima">
        <i class="fa-solid fa-crown"></i>
        <span>¡Has alcanzado la liga máxima!</span>
      </div>
      <% } %>
    </div>
    <% } %>

    <!-- Información de puntos -->
    <div style="max-width: 600px; margin: 20px auto; padding: 16px; background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1)); border: 1px solid rgba(102, 126, 234, 0.3); border-radius: 12px; text-align: center;">
      <h4 style="margin: 0 0 12px; color: #667eea; font-size: 1.1em;">
        <i class="fa-solid fa-info-circle"></i> ¿Cómo ganar puntos?
      </h4>
      <div style="display: flex; gap: 20px; justify-content: center; flex-wrap: wrap; font-size: 0.9em; color: rgba(255,255,255,0.85);">
        <div>
          <i class="fa-solid fa-star" style="color: #f39c12;"></i>
          <strong>Partidas Ganadas:</strong> Tu puntuación final suma
        </div>
        <div>
          <i class="fa-solid fa-medal" style="color: #e67e22;"></i>
          <strong>Logros:</strong> Cada logro suma puntos fijos
        </div>
      </div>
      <p style="margin: 10px 0 0; font-size: 0.85em; color: rgba(255,255,255,0.6);">
        Mejora tu rendimiento para ganar más puntos por partida
      </p>
    </div>

    <!-- Acciones rápidas -->
    <div class="quick">
      <!-- Continuar: va a Mis Partidas para que elija cual continuar -->
      <a class="btn btn-primary" href="${pageContext.request.contextPath}/jugador/partidas">
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

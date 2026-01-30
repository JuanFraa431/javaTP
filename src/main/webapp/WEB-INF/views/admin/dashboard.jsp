<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Panel Admin — Misterio en la Mansión</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  
  <!-- Fuentes -->
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&family=Overpass:wght@600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  
  <!-- Estilos propios -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/dashboard.css">
  <style>
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 20px;
      margin-bottom: 40px;
    }
    .stat-card {
      background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
      border-radius: 12px;
      padding: 20px 24px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
      border: 1px solid rgba(255, 255, 255, 0.1);
      transition: transform 0.2s, box-shadow 0.2s;
    }
    .stat-card:hover {
      transform: translateY(-4px);
      box-shadow: 0 8px 20px rgba(0, 0, 0, 0.4);
    }
    .stat-card .icon {
      font-size: 32px;
      margin-bottom: 12px;
      opacity: 0.9;
    }
    .stat-card h3 {
      font-size: 14px;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      opacity: 0.7;
      margin: 0 0 8px 0;
    }
    .stat-card .value {
      font-size: 36px;
      font-weight: 800;
      margin: 0 0 12px 0;
      color: #fff;
    }
    .stat-card .details {
      font-size: 13px;
      opacity: 0.6;
      display: flex;
      gap: 12px;
    }
    .stat-card .details span {
      display: flex;
      align-items: center;
      gap: 4px;
    }
    .stat-usuarios { border-left: 4px solid #3b82f6; }
    .stat-usuarios .icon { color: #3b82f6; }
    .stat-historias { border-left: 4px solid #8b5cf6; }
    .stat-historias .icon { color: #8b5cf6; }
    .stat-partidas { border-left: 4px solid #10b981; }
    .stat-partidas .icon { color: #10b981; }
    .stat-logros { border-left: 4px solid #f59e0b; }
    .stat-logros .icon { color: #f59e0b; }
  </style>
</head>
<body>

  <%
    @SuppressWarnings("unchecked")
    Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
  %>

  <!-- Escena decorativa -->
  <div id="scene" aria-hidden="true">
    <div class="moon"></div>
    <div class="fog layer1"></div>
    <div class="fog layer2"></div>
    <div class="vignette"></div>
  </div>

  <!-- Topbar -->
  <header class="topbar">
    <div class="brand">
      <div>
        <div class="game-title">Misterio en la Mansión</div>
        <div class="tagline">Panel de administración</div>
      </div>
    </div>

    <div class="actions">
      <span class="session-info">Hola, ${sessionScope.nombre} • <small>${sessionScope.rol}</small></span>
      <a class="btn" href="${pageContext.request.contextPath}/jugador/home">
        <i class="fa-solid fa-house"></i> Inicio Jugador
      </a>
      <a class="btn btn-primary" href="${pageContext.request.contextPath}/logout">
        <i class="fa-solid fa-right-from-bracket"></i> Salir
      </a>
    </div>
  </header>

  <!-- Contenido -->
  <main class="container">

    <!-- Estadísticas -->
    <% if (stats != null) { %>
    <section class="stats-section" style="margin-bottom: 50px;">
      <h2 class="section-title" style="margin-bottom: 24px;">
        <i class="fa-solid fa-chart-line"></i> Estadísticas del Sistema
      </h2>
      
      <div class="stats-grid">
        <!-- Usuarios -->
        <a href="${pageContext.request.contextPath}/admin/estadisticas/usuarios" class="stat-card stat-usuarios" style="text-decoration: none; color: inherit; cursor: pointer;">
          <div class="icon"><i class="fa-solid fa-users"></i></div>
          <h3>Usuarios Registrados</h3>
          <div class="value"><%= stats.get("totalUsuarios") %></div>
          <div class="details">
            <span><i class="fa-solid fa-circle" style="color: #10b981; font-size: 8px;"></i> <%= stats.get("usuariosActivos") %> activos</span>
            <span><i class="fa-solid fa-circle" style="color: #dc2626; font-size: 8px;"></i> <%= stats.get("usuariosInactivos") %> inactivos</span>
          </div>
        </a>
        
        <!-- Historias -->
        <a href="${pageContext.request.contextPath}/admin/estadisticas/historias" class="stat-card stat-historias" style="text-decoration: none; color: inherit; cursor: pointer;">
          <div class="icon"><i class="fa-solid fa-book-open"></i></div>
          <h3>Historias</h3>
          <div class="value"><%= stats.get("totalHistorias") %></div>
          <div class="details">
            <span><i class="fa-solid fa-circle" style="color: #10b981; font-size: 8px;"></i> <%= stats.get("historiasActivas") %> activas</span>
            <span><i class="fa-solid fa-circle" style="color: #dc2626; font-size: 8px;"></i> <%= stats.get("historiasInactivas") %> inactivas</span>
          </div>
        </a>
        
        <!-- Partidas -->
        <a href="${pageContext.request.contextPath}/admin/estadisticas/partidas" class="stat-card stat-partidas" style="text-decoration: none; color: inherit; cursor: pointer;">
          <div class="icon"><i class="fa-solid fa-chess-knight"></i></div>
          <h3>Partidas</h3>
          <div class="value"><%= stats.get("totalPartidas") %></div>
          <div class="details">
            <span><i class="fa-solid fa-circle" style="color: #3b82f6; font-size: 8px;"></i> <%= stats.get("partidasEnCurso") %> en curso</span>
            <span><i class="fa-solid fa-circle" style="color: #10b981; font-size: 8px;"></i> <%= stats.get("partidasCompletadas") %> completadas</span>
          </div>
        </a>
        
        <!-- Logros -->
        <a href="${pageContext.request.contextPath}/admin/estadisticas/logros" class="stat-card stat-logros" style="text-decoration: none; color: inherit; cursor: pointer;">
          <div class="icon"><i class="fa-solid fa-trophy"></i></div>
          <h3>Logros Disponibles</h3>
          <div class="value"><%= stats.get("totalLogros") %></div>
          <div class="details">
            <span><i class="fa-solid fa-star"></i> Achievements desbloqueables</span>
          </div>
        </a>
      </div>
    </section>
    <% } %>

    <section class="panel">
      <h2 class="section-title"><i class="fa-solid fa-screwdriver-wrench"></i> Gestión — ABM</h2>

      <div class="grid">
        <a class="card" href="${pageContext.request.contextPath}/admin/usuarios">
		  <div class="icon"><i class="fa-solid fa-user-gear"></i></div>
		  <h3>Usuarios</h3>
		  <p>Alta, baja y modificación de cuentas. Control de roles y estado.</p>
		  <i class="fa-solid fa-chevron-right arrow"></i>
		  <span class="badge"><i class="fa-solid fa-shield-halved"></i> Seguridad</span>
		</a>

        <a class="card" href="${pageContext.request.contextPath}/admin/personajes">
		  <div class="icon"><i class="fa-solid fa-user-secret"></i></div>
		  <h3>Personajes</h3>
		  <p>Alta, baja y modificación de personajes de las historias.</p>
		  <i class="fa-solid fa-chevron-right arrow"></i>
		  <span class="badge"><i class="fa-solid fa-users"></i> ABM</span>
		</a>


        <a class="card" href="${pageContext.request.contextPath}/admin/ubicaciones">
          <div class="icon"><i class="fa-solid fa-location-dot"></i></div>
          <h3>Ubicaciones</h3>
          <p>Habitaciones y zonas de la mansión. Disponibilidad y accesos.</p>
          <i class="fa-solid fa-chevron-right arrow"></i>
          <span class="badge"><i class="fa-solid fa-map"></i> ABM</span>
        </a>

        <a class="card" href="${pageContext.request.contextPath}/admin/historias">
          <div class="icon"><i class="fa-solid fa-book-open"></i></div>
          <h3>Historias</h3>
          <p>Tramas y capítulos que guían el progreso del caso.</p>
          <i class="fa-solid fa-chevron-right arrow"></i>
          <span class="badge"><i class="fa-solid fa-feather"></i> ABM</span>
        </a>

        <a class="card" href="${pageContext.request.contextPath}/admin/pistas">
          <div class="icon"><i class="fa-solid fa-magnifying-glass"></i></div>
          <h3>Pistas</h3>
          <p>Relacioná pistas con Personajes y Ubicaciones.</p>
          <i class="fa-solid fa-chevron-right arrow"></i>
          <span class="badge"><i class="fa-solid fa-link"></i> Relacional</span>
        </a>

        <a class="card" href="${pageContext.request.contextPath}/admin/documentos">
          <div class="icon"><i class="fa-solid fa-file-lines"></i></div>
          <h3>Documentos</h3>
          <p>Documentos del juego: códigos, informes y pistas HTML.</p>
          <i class="fa-solid fa-chevron-right arrow"></i>
          <span class="badge"><i class="fa-solid fa-code"></i> Contenido</span>
        </a>

        <a class="card" href="${pageContext.request.contextPath}/admin/logros">
          <div class="icon"><i class="fa-solid fa-trophy"></i></div>
          <h3>Logros</h3>
          <p>Achievements y logros desbloqueables con puntos.</p>
          <i class="fa-solid fa-chevron-right arrow"></i>
          <span class="badge"><i class="fa-solid fa-star"></i> Gamificación</span>
        </a>

        <a class="card" href="${pageContext.request.contextPath}/admin/partidas">
          <div class="icon"><i class="fa-solid fa-chess-knight"></i></div>
          <h3>Partidas</h3>
          <p>Estados de juego, reinicios y avances por jugador.</p>
          <i class="fa-solid fa-chevron-right arrow"></i>
          <span class="badge"><i class="fa-solid fa-list-check"></i> Monitoreo</span>
        </a>
      </div>
    </section>

  </main>

  <footer>
    © <script>document.write(new Date().getFullYear());</script> Misterio en la Mansión — Panel Admin
  </footer>

</body>
</html>

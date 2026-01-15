<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
</head>
<body>

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

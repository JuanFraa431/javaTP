<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Nueva Partida</title>
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/partidas.css">
</head>
<body>
<div class="wrap">
  <header class="header">
    <h1 class="title">Elegí una historia</h1>
    <p class="subtitle">Comenzá un caso nuevo. Más historias se desbloquearán pronto…</p>
    <div style="margin-top: 1.5rem;">
      <a href="${pageContext.request.contextPath}/jugador/home" class="btn btn-secondary">
        <i class="fa-solid fa-arrow-left"></i> Volver al menú
      </a>
    </div>
  </header>

  <section class="grid">
    <!-- Historia habilitada -->
    <article class="card">
      <div class="card__badge">Disponible</div>
      <h3>El Misterio de la Mansión Blackwood</h3>
      <p>Una tormenta, invitados atrapados y un crimen en el estudio. ¿Te animás?</p>
      <form action="${pageContext.request.contextPath}/jugador/partidas/iniciar" method="post">
        <input type="hidden" name="historiaId" value="1">
        <button class="btn btn-primary" type="submit">Jugar</button>
      </form>
    </article>

    <!-- Historias bloqueadas (simuladas) -->
    <article class="card disabled">
      <div class="card__badge lock"><span>🔒</span>Bloqueada</div>
      <h3>La Sombra del Teatro</h3>
      <p>Próximamente…</p>
      <button class="btn btn-ghost" disabled>Bloqueado</button>
    </article>

    <article class="card disabled">
      <div class="card__badge lock"><span>🔒</span>Bloqueada</div>
      <h3>Silencio en el Museo</h3>
      <p>Próximamente…</p>
      <button class="btn btn-ghost" disabled>Bloqueado</button>
    </article>
  </section>
</div>
</body>
</html>

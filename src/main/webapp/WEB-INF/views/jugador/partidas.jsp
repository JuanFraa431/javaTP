<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String ctx = request.getContextPath();
  boolean enPartida = request.getAttribute("enPartida") != null && (Boolean)request.getAttribute("enPartida");
  Integer partidaActivaId = (Integer) request.getAttribute("partidaActivaId");
  java.util.List<entities.Historia> historias = (java.util.List<entities.Historia>) request.getAttribute("historias");
  String flashError = (String) request.getAttribute("flashError");
  String flashSuccess = (String) request.getAttribute("flashSuccess");
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Elegí una historia</title>
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="<%=ctx%>/style/partidas.css">
  <style>
    .flash-message {
      padding: 12px 20px;
      margin: 16px auto;
      max-width: 800px;
      border-radius: 8px;
      text-align: center;
      font-weight: 600;
    }
    .flash-error {
      background-color: #fee;
      color: #c33;
      border: 1px solid #c33;
    }
    .flash-success {
      background-color: #efe;
      color: #3c3;
      border: 1px solid #3c3;
    }
  </style>
</head>
<body>
  <div class="wrap">
    <header class="header">
      <h1 class="title">ELEGÍ UNA HISTORIA</h1>
      <p class="subtitle">Comenzá un caso nuevo. Más historias se desbloquearán pronto…</p>
    </header>

    <% if (flashError != null) { %>
      <div class="flash-message flash-error"><%= flashError %></div>
    <% } %>
    
    <% if (flashSuccess != null) { %>
      <div class="flash-message flash-success"><%= flashSuccess %></div>
    <% } %>

    <% if (enPartida && partidaActivaId != null) { %>
      <div style="text-align:center; margin-bottom:20px; background: #fff3cd; padding: 15px; border-radius: 8px; border: 1px solid #ffc107;">
        <p style="margin: 0 0 10px 0; color: #856404; font-weight: 600;">
          <i class="fa-solid fa-info-circle"></i> Tenés una partida en curso
        </p>
        <form action="<%=ctx%>/jugador/partidas/juego" method="get" style="display:inline">
          <input type="hidden" name="pid" value="<%=partidaActivaId%>">
          <button class="btn btn-primary" type="submit">Continuar mi partida</button>
        </form>
      </div>
    <% } %>

    <section class="grid">
      <% if (historias == null || historias.isEmpty()) { %>
        <p style="text-align:center; grid-column: 1/-1; color:#999;">
          No hay historias disponibles en este momento.
        </p>
      <% } else { %>
        <% for (entities.Historia h : historias) { %>
          <article class="card">
            <div class="card__badge">Disponible</div>
            <h3><%= h.getTitulo() %></h3>
            <p><%= h.getDescripcion() %></p>

            <div style="margin-top:10px">
              <% if (enPartida) { %>
                <button class="btn btn-primary" disabled title="Ya tenés una partida en curso. Finalizá la actual antes de iniciar una nueva.">
                  Jugar
                </button>
              <% } else { %>
                <form action="<%=ctx%>/jugador/partidas/iniciar" method="post" style="display:inline">
                  <input type="hidden" name="historiaId" value="<%=h.getId()%>">
                  <button type="submit" class="btn btn-primary">Jugar</button>
                </form>
              <% } %>
            </div>
          </article>
        <% } %>
      <% } %>
    </section>
  </div>
</body>
</html>

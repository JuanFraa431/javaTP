<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String ctx = request.getContextPath();
  boolean enPartida = request.getAttribute("enPartida") != null && (Boolean)request.getAttribute("enPartida");
  Integer partidaActivaId = (Integer) request.getAttribute("partidaActivaId");
  java.util.List<entities.Historia> historias = (java.util.List<entities.Historia>) request.getAttribute("historias");
  String flashError = (String) request.getAttribute("flashError");
  String flashSuccess = (String) request.getAttribute("flashSuccess");
  String ligaUsuario = (String) request.getAttribute("ligaUsuario");
  Integer puntosUsuario = (Integer) request.getAttribute("puntosUsuario");
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Elegí una historia</title>
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
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
    
    /* Historias bloqueadas */
    .card.bloqueada {
      opacity: 0.6;
      filter: grayscale(80%);
      position: relative;
    }
    .card.bloqueada::before {
      content: "";
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: rgba(0, 0, 0, 0.1);
      border-radius: 12px;
      pointer-events: none;
    }
    .card__badge.bloqueado {
      background: linear-gradient(135deg, #666, #999);
    }
    .requisito-liga {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      margin: 10px 0;
      padding: 8px 12px;
      background: rgba(255, 193, 7, 0.15);
      border-radius: 8px;
      font-size: 0.9em;
      color: #856404;
      font-weight: 600;
    }
    .liga-usuario-info {
      text-align: center;
      margin: 20px auto;
      padding: 16px;
      background: linear-gradient(135deg, rgba(255,255,255,0.9), rgba(240,240,255,0.9));
      border-radius: 12px;
      max-width: 600px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }
    .liga-badge {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 8px 16px;
      border-radius: 20px;
      font-weight: 700;
      font-size: 1.1em;
      text-transform: uppercase;
      letter-spacing: 1px;
    }
    .liga-bronce { background: linear-gradient(135deg, #cd7f32, #a0522d); color: white; }
    .liga-plata { background: linear-gradient(135deg, #c0c0c0, #a8a8a8); color: #333; }
    .liga-oro { background: linear-gradient(135deg, #ffd700, #ffed4e); color: #333; }
    .liga-platino { background: linear-gradient(135deg, #e5e4e2, #bbb); color: #333; }
    .liga-diamante { background: linear-gradient(135deg, #b9f2ff, #00bfff); color: #003366; }
  </style>
</head>
<body>
  <div class="wrap">
    <header class="header">
      <h1 class="title">ELEGÍ UNA HISTORIA</h1>
      <p class="subtitle">Comenzá un caso nuevo. Más historias se desbloquearán según tu liga…</p>
      <div style="text-align: center; margin-top: 16px;">
        <a href="<%=ctx%>/jugador/home" class="btn btn-secondary" style="display: inline-block; text-decoration: none;">
          <i class="fa-solid fa-arrow-left"></i> Volver
        </a>
      </div>
    </header>

    <% if (ligaUsuario != null && puntosUsuario != null) { %>
      <div class="liga-usuario-info">
        <p style="margin: 0 0 8px 0; color: #666;">Tu liga actual:</p>
        <span class="liga-badge liga-<%=ligaUsuario%>">
          <i class="fa-solid fa-trophy"></i>
          <%= ligaUsuario.substring(0,1).toUpperCase() + ligaUsuario.substring(1) %>
        </span>
        <p style="margin: 8px 0 0 0; color: #666; font-size: 0.9em;">
          <%= puntosUsuario %> puntos totales
        </p>
      </div>
    <% } %>

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
        <% for (entities.Historia h : historias) { 
          boolean accesible = h.isAccesible();
          String ligaRequerida = h.getLigaMinima() != null ? h.getLigaMinima() : "bronce";
        %>
          <article class="card <%= !accesible ? "bloqueada" : "" %>">
            <div class="card__badge <%= !accesible ? "bloqueado" : "" %>">
              <%= accesible ? "Disponible" : "🔒 Bloqueada" %>
            </div>
            <h3><%= h.getTitulo() %></h3>
            <p><%= h.getDescripcion() %></p>

            <% if (!accesible) { %>
              <div class="requisito-liga">
                <i class="fa-solid fa-lock"></i>
                <span>Requiere liga: 
                  <strong><%= ligaRequerida.substring(0,1).toUpperCase() + ligaRequerida.substring(1) %></strong>
                </span>
              </div>
            <% } %>

            <div style="margin-top:10px">
              <% if (!accesible) { %>
                <button class="btn btn-primary" disabled title="Necesitás alcanzar la liga <%= ligaRequerida %> para desbloquear esta historia">
                  <i class="fa-solid fa-lock"></i> Bloqueada
                </button>
              <% } else if (enPartida) { %>
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

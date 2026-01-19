<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="entities.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  String ctx = request.getContextPath();
  List<Partida> partidas = (List<Partida>) request.getAttribute("partidas");
  Map<Integer, Historia> historiasMap = (Map<Integer, Historia>) request.getAttribute("historiasMap");
  Map<Integer, Integer> pistasRealesMap = (Map<Integer, Integer>) request.getAttribute("pistasRealesMap");
  Map<Integer, Integer> ubicacionesRealesMap = (Map<Integer, Integer>) request.getAttribute("ubicacionesRealesMap");
  SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Mis Partidas</title>
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="<%=ctx%>/style/partidas.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    .stats {
      display: flex;
      gap: 16px;
      margin-top: 12px;
      flex-wrap: wrap;
    }
    .stat-item {
      display: flex;
      align-items: center;
      gap: 6px;
      font-size: 0.9rem;
      color: var(--muted);
    }
    .stat-item i {
      color: var(--accent);
    }
    .badge {
      display: inline-block;
      padding: 4px 10px;
      border-radius: 999px;
      font-size: 0.75rem;
      font-weight: 700;
      text-transform: uppercase;
    }
    .badge-progreso {
      background: linear-gradient(135deg, #3b82f6, #2563eb);
      color: white;
    }
    .badge-finalizada {
      background: linear-gradient(135deg, #10b981, #059669);
      color: white;
    }
    .badge-ganada {
      background: linear-gradient(135deg, #f59e0b, #d97706);
      color: white;
    }
    .badge-perdida {
      background: linear-gradient(135deg, #ef4444, #dc2626);
      color: white;
    }
    .empty-state {
      text-align: center;
      padding: 48px 24px;
      color: var(--muted);
    }
    .empty-state i {
      font-size: 3rem;
      margin-bottom: 16px;
      opacity: 0.5;
    }
  </style>
</head>
<body>
  <div class="wrap">
    <header class="header">
      <h1 class="title">MIS PARTIDAS</h1>
      <p class="subtitle">Revisá tu progreso, pistas claves y estadísticas</p>
      <div style="text-align: center; margin-top: 16px;">
        <a href="<%=ctx%>/jugador/home" class="btn btn-secondary" style="display: inline-block; text-decoration: none;">
          <i class="fa-solid fa-arrow-left"></i> Volver
        </a>
      </div>
    </header>

    <% if (partidas == null || partidas.isEmpty()) { %>
      <div class="empty-state">
        <i class="fa-solid fa-ghost"></i>
        <h3>No tenés partidas todavía</h3>
        <p>Comenzá una nueva investigación para ver tu historial aquí</p>
        <div style="margin-top: 24px;">
          <a href="<%=ctx%>/jugador/partidas/nueva" class="btn btn-primary" style="text-decoration: none;">
            <i class="fa-solid fa-plus"></i> Nueva Partida
          </a>
        </div>
      </div>
    <% } else { %>
      <section class="grid">
        <% for (Partida p : partidas) { 
           Historia h = historiasMap.get(p.getHistoriaId());
           String historiaTitulo = (h != null) ? h.getTitulo() : "Historia Desconocida";
           
           // Obtener el conteo REAL de pistas y ubicaciones
           Integer pistasReales = pistasRealesMap.get(p.getId());
           int numPistas = (pistasReales != null) ? pistasReales : 0;
           
           Integer ubicacionesReales = ubicacionesRealesMap.get(p.getId());
           int numUbicaciones = (ubicacionesReales != null) ? ubicacionesReales : 0;
           
           String estadoBadge = "";
           String estadoClase = "";
           
           if ("EN_PROGRESO".equals(p.getEstado())) {
             estadoBadge = "En Progreso";
             estadoClase = "badge-progreso";
           } else if ("FINALIZADA".equals(p.getEstado())) {
             if (p.getCasoResuelto() == 1) {
               estadoBadge = "Ganada";
               estadoClase = "badge-ganada";
             } else {
               estadoBadge = "Perdida";
               estadoClase = "badge-perdida";
             }
           } else {
             estadoBadge = p.getEstado();
             estadoClase = "badge-finalizada";
           }
        %>
          <article class="card">
            <span class="badge <%= estadoClase %>"><%= estadoBadge %></span>
            <h3><%= historiaTitulo %></h3>
            <p style="font-size: 0.9rem; color: var(--muted);">
              Inicio: <%= sdf.format(p.getFechaInicio()) %>
              <% if (p.getFechaFin() != null) { %>
                <br>Fin: <%= sdf.format(p.getFechaFin()) %>
              <% } %>
            </p>
            
            <div class="stats">
              <div class="stat-item">
                <i class="fa-solid fa-lightbulb"></i>
                <span><%= numPistas %> pistas</span>
              </div>
              <div class="stat-item">
                <i class="fa-solid fa-map-marked"></i>
                <span><%= numUbicaciones %> lugares</span>
              </div>
              <div class="stat-item">
                <i class="fa-solid fa-star"></i>
                <span><%= p.getPuntuacion() %> puntos</span>
              </div>
              <% if (!"EN_PROGRESO".equals(p.getEstado())) { %>
                <div class="stat-item">
                  <i class="fa-solid fa-heart"></i>
                  <span><%= p.getIntentosRestantes() %> intentos</span>
                </div>
              <% } %>
            </div>
            
            <div style="margin-top: 16px;">
              <% if ("EN_PROGRESO".equals(p.getEstado())) { %>
                <a href="<%=ctx%>/jugador/partidas/juego?pid=<%= p.getId() %>" class="btn btn-primary" style="text-decoration: none;">
                  <i class="fa-solid fa-play"></i> Continuar
                </a>
              <% } else { %>
                <button class="btn btn-ghost" disabled>
                  <i class="fa-solid fa-check"></i> Finalizada
                </button>
              <% } %>
            </div>
          </article>
        <% } %>
      </section>
    <% } %>
  </div>
</body>
</html>

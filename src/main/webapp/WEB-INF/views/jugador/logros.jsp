<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="entities.Logro" %>
<%
  String ctx = request.getContextPath();
  String nombre = (String) session.getAttribute("nombre");
  if (nombre == null || nombre.isBlank()) nombre = "Detective";
  
  @SuppressWarnings("unchecked")
  List<Logro> logros = (List<Logro>) request.getAttribute("logros");
  Integer totalDesbloqueados = (Integer) request.getAttribute("totalDesbloqueados");
  Integer totalLogros = (Integer) request.getAttribute("totalLogros");
  Integer puntosLogros = (Integer) request.getAttribute("puntosLogros");
  Integer porcentaje = (Integer) request.getAttribute("porcentaje");
  
  if (logros == null) logros = java.util.Collections.emptyList();
  if (totalDesbloqueados == null) totalDesbloqueados = 0;
  if (totalLogros == null) totalLogros = 0;
  if (puntosLogros == null) puntosLogros = 0;
  if (porcentaje == null) porcentaje = 0;
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Logros — Misterio en la Mansión</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    :root{
      --bg1:#070a10; --bg2:#0f1a2b; --text:#e9eef8; --muted:#a6b3c7;
      --accent:#f7b733; --accent2:#ff7a18;
      --glass:rgba(14,20,32,.55); --edge:rgba(255,255,255,.12);
      --radius:16px; --shadow:0 18px 45px rgba(0,0,0,.55); --blur:12px;
    }
    *{ box-sizing:border-box; margin:0; padding:0; }
    html,body{ height:100% }
    body{
      margin:0; color:var(--text);
      font-family:'Nunito',system-ui,-apple-system,Segoe UI,Roboto,sans-serif;
      background: radial-gradient(1200px 600px at 20% 10%, rgba(255,255,255,.03), transparent 60%),
                  linear-gradient(135deg, var(--bg1), var(--bg2) 60%);
      -webkit-font-smoothing:antialiased;
    }
    .wrap{
      min-height:100vh;
      padding:clamp(16px,3vw,36px);
    }
    .header{
      text-align:center;
      margin:10px 0 30px;
    }
    .title{
      font-family:'Creepster',cursive;
      font-size:clamp(2rem,4.2vw,3.2rem);
      color:#f2f4ff;
      text-shadow:0 0 18px rgba(247,183,51,.15), 0 2px 0 rgba(0,0,0,.6);
      margin:0 0 8px;
      letter-spacing:.4px;
    }
    .subtitle{
      color:var(--muted);
      font-weight:800;
      letter-spacing:.3px;
    }
    .back-btn{
      display:inline-flex; align-items:center; gap:8px;
      padding:12px 16px; border-radius:12px;
      background:transparent; color:var(--text);
      border:1px dashed var(--edge);
      text-decoration:none; font-weight:900; letter-spacing:.3px;
      box-shadow:0 12px 26px rgba(0,0,0,.28), inset 0 0 0 1px rgba(255,255,255,.25);
      transition:transform .08s, box-shadow .18s, filter .18s;
      margin-bottom:30px;
    }
    .back-btn:hover{
      transform:translateY(-1px);
      filter:brightness(1.05);
    }
    .stats-panel{
      background:var(--glass);
      border:1px solid var(--edge);
      border-radius:var(--radius);
      box-shadow:var(--shadow);
      backdrop-filter:blur(var(--blur)) saturate(120%);
      padding:24px;
      margin:0 auto 30px;
      max-width:800px;
    }
    .stats-grid{
      display:grid;
      grid-template-columns:repeat(auto-fit, minmax(180px, 1fr));
      gap:20px;
    }
    .stat-box{
      text-align:center;
    }
    .stat-value{
      font-size:2.5em;
      font-weight:900;
      color:var(--accent);
      line-height:1;
      margin-bottom:6px;
    }
    .stat-label{
      color:var(--muted);
      font-weight:700;
      font-size:.9em;
    }
    .progress-bar{
      width:100%;
      height:12px;
      background:rgba(255,255,255,.06);
      border-radius:999px;
      overflow:hidden;
      margin-top:20px;
      border:1px solid var(--edge);
    }
    .progress-fill{
      height:100%;
      background:linear-gradient(90deg, var(--accent), var(--accent2));
      border-radius:999px;
      transition:width .6s ease;
      box-shadow:0 0 12px rgba(247,183,51,.4);
    }
    .progress-text{
      text-align:center;
      margin-top:8px;
      font-weight:700;
      color:var(--accent);
    }
    .grid{
      display:grid;
      gap:18px;
      grid-template-columns:repeat(auto-fill,minmax(280px,1fr));
      max-width:1200px;
      margin:0 auto;
    }
    .logro-card{
      background:var(--glass);
      border:1px solid var(--edge);
      border-radius:var(--radius);
      box-shadow:var(--shadow);
      backdrop-filter:blur(var(--blur)) saturate(120%);
      padding:20px;
      transition:transform .15s ease, box-shadow .25s ease, border-color .25s ease;
      position:relative;
      overflow:hidden;
    }
    .logro-card:hover{
      transform:translateY(-2px);
      border-color:rgba(255,255,255,.18);
      box-shadow:0 22px 55px rgba(0,0,0,.55);
    }
    .logro-card.bloqueado{
      opacity:.4;
      filter:grayscale(.8);
    }
    .logro-card.bloqueado .logro-icon{
      background:rgba(255,255,255,.04);
    }
    .logro-header{
      display:flex;
      align-items:center;
      gap:16px;
      margin-bottom:12px;
    }
    .logro-icon{
      display:grid;
      place-items:center;
      width:56px; height:56px;
      border-radius:12px;
      background:linear-gradient(135deg, var(--accent), var(--accent2));
      box-shadow:0 4px 12px rgba(247,183,51,.3);
      font-size:1.8em;
      color:#0a0f18;
      flex-shrink:0;
    }
    .logro-card.bloqueado .logro-icon{
      background:rgba(255,255,255,.06);
      color:var(--muted);
      box-shadow:none;
    }
    .logro-info{
      flex:1;
    }
    .logro-nombre{
      font-weight:900;
      font-size:1.1em;
      margin-bottom:4px;
      letter-spacing:.2px;
    }
    .logro-puntos{
      font-size:.85em;
      color:var(--accent);
      font-weight:700;
    }
    .logro-card.bloqueado .logro-puntos{
      color:var(--muted);
    }
    .logro-descripcion{
      color:#d5deee;
      line-height:1.5;
      font-size:.95em;
    }
    .logro-card.bloqueado .logro-descripcion{
      color:var(--muted);
    }
    .logro-fecha{
      margin-top:12px;
      padding-top:12px;
      border-top:1px solid var(--edge);
      font-size:.85em;
      color:var(--muted);
      display:flex;
      align-items:center;
      gap:6px;
    }
    .badge-desbloqueado{
      position:absolute;
      top:12px;
      right:12px;
      background:linear-gradient(135deg, #10b981, #059669);
      color:white;
      padding:4px 10px;
      border-radius:999px;
      font-size:.75em;
      font-weight:900;
      text-transform:uppercase;
      box-shadow:0 2px 8px rgba(16,185,129,.3);
    }
    .empty-state{
      text-align:center;
      padding:60px 24px;
      color:var(--muted);
    }
    .empty-state i{
      font-size:4em;
      margin-bottom:20px;
      opacity:.5;
    }
    @media (max-width: 768px){
      .stats-grid{
        grid-template-columns:1fr;
        gap:16px;
      }
      .grid{
        grid-template-columns:1fr;
      }
    }
  </style>
</head>
<body>
  <div class="wrap">
    <a href="<%=ctx%>/jugador/home" class="back-btn">
      <i class="fa-solid fa-arrow-left"></i>
      Volver al inicio
    </a>

    <div class="header">
      <h1 class="title">Logros</h1>
      <p class="subtitle">Desbloqueá hitos al resolver los misterios</p>
    </div>

    <!-- Panel de estadísticas -->
    <div class="stats-panel">
      <div class="stats-grid">
        <div class="stat-box">
          <div class="stat-value"><%=totalDesbloqueados%></div>
          <div class="stat-label">Logros Desbloqueados</div>
        </div>
        <div class="stat-box">
          <div class="stat-value"><%=totalLogros%></div>
          <div class="stat-label">Logros Totales</div>
        </div>
        <div class="stat-box">
          <div class="stat-value"><%=puntosLogros%></div>
          <div class="stat-label">Puntos de Logros</div>
        </div>
      </div>
      
      <div class="progress-bar">
        <div class="progress-fill" style="width: <%=porcentaje%>%"></div>
      </div>
      <div class="progress-text"><%=porcentaje%>% completado</div>
    </div>

    <!-- Grid de logros -->
    <% if (logros.isEmpty()) { %>
      <div class="empty-state">
        <i class="fa-solid fa-trophy"></i>
        <h3>No hay logros disponibles</h3>
        <p>Los logros aparecerán aquí cuando estén disponibles</p>
      </div>
    <% } else { %>
      <div class="grid">
        <% for (Logro logro : logros) { %>
          <div class="logro-card <%= logro.isDesbloqueado() ? "" : "bloqueado" %>">
            <% if (logro.isDesbloqueado()) { %>
              <span class="badge-desbloqueado">✓ Desbloqueado</span>
            <% } %>
            
            <div class="logro-header">
              <div class="logro-icon">
                <i class="<%=logro.getIcono()%>"></i>
              </div>
              <div class="logro-info">
                <div class="logro-nombre"><%=logro.getNombre()%></div>
                <div class="logro-puntos">
                  <i class="fa-solid fa-star"></i> <%=logro.getPuntos()%> puntos
                </div>
              </div>
            </div>
            
            <div class="logro-descripcion">
              <%=logro.getDescripcion()%>
            </div>
            
            <% if (logro.isDesbloqueado() && logro.getFechaObtencion() != null) { %>
              <div class="logro-fecha">
                <i class="fa-solid fa-calendar"></i>
                Desbloqueado: <%=logro.getFechaObtencion().substring(0, 10)%>
              </div>
            <% } %>
          </div>
        <% } %>
      </div>
    <% } %>
  </div>
</body>
</html>

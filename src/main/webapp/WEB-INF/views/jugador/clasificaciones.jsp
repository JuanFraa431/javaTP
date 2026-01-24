<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%
  String ctx = request.getContextPath();
  String nombre = (String) session.getAttribute("nombre");
  if (nombre == null) nombre = "Detective";
  
  @SuppressWarnings("unchecked")
  List<Map<String, Object>> ranking = (List<Map<String, Object>>) request.getAttribute("ranking");
  String ligaFiltro = (String) request.getAttribute("ligaFiltro");
  Integer puntosUsuario = (Integer) request.getAttribute("puntosUsuario");
  String ligaUsuario = (String) request.getAttribute("ligaUsuario");
  Integer posicionUsuario = (Integer) request.getAttribute("posicionUsuario");
  Integer puntosRestantes = (Integer) request.getAttribute("puntosRestantes");
  
  @SuppressWarnings("unchecked")
  Map<String, Integer> distribucion = (Map<String, Integer>) request.getAttribute("distribucion");
  
  if (ranking == null) ranking = Collections.emptyList();
  if (distribucion == null) distribucion = new HashMap<>();
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Clasificaciones — Misterio en la Mansión</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    :root{
      --bg1:#070a10; --bg2:#0f1a2b; --text:#e9eef8; --muted:#a6b3c7;
      --accent:#f7b733; --accent2:#ff7a18;
      --glass:rgba(14,20,32,.55); --edge:rgba(255,255,255,.12);
      --radius:16px; --shadow:0 18px 45px rgba(0,0,0,.55); --blur:12px;
      
      --bronce:#cd7f32;
      --plata:#c0c0c0;
      --oro:#ffd700;
      --platino:#e5e4e2;
      --diamante:#b9f2ff;
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
    .user-card{
      background:var(--glass);
      border:1px solid var(--edge);
      border-radius:var(--radius);
      box-shadow:var(--shadow);
      backdrop-filter:blur(var(--blur)) saturate(120%);
      padding:24px;
      margin:0 auto 30px;
      max-width:800px;
      display:flex;
      align-items:center;
      gap:24px;
      flex-wrap:wrap;
    }
    .liga-badge{
      width:80px; height:80px;
      border-radius:50%;
      display:grid;
      place-items:center;
      font-size:2.5em;
      box-shadow:0 8px 20px rgba(0,0,0,.4);
      flex-shrink:0;
    }
    .liga-bronce{ background:linear-gradient(135deg, #cd7f32, #a0522d); }
    .liga-plata{ background:linear-gradient(135deg, #c0c0c0, #808080); }
    .liga-oro{ background:linear-gradient(135deg, #ffd700, #ffa500); }
    .liga-platino{ background:linear-gradient(135deg, #e5e4e2, #b4b4b4); }
    .liga-diamante{ background:linear-gradient(135deg, #b9f2ff, #4682b4); }
    .user-info{
      flex:1;
      min-width:200px;
    }
    .user-name{
      font-size:1.5em;
      font-weight:900;
      margin-bottom:6px;
    }
    .user-stats{
      display:flex;
      gap:20px;
      flex-wrap:wrap;
      margin-top:10px;
    }
    .stat-item{
      display:flex;
      align-items:center;
      gap:6px;
      color:var(--muted);
      font-size:.9em;
    }
    .stat-item i{
      color:var(--accent);
    }
    .progress-info{
      width:100%;
      margin-top:16px;
      padding-top:16px;
      border-top:1px solid var(--edge);
    }
    .progress-label{
      font-size:.85em;
      color:var(--muted);
      margin-bottom:8px;
    }
    .progress-bar{
      width:100%;
      height:10px;
      background:rgba(255,255,255,.06);
      border-radius:999px;
      overflow:hidden;
      border:1px solid var(--edge);
    }
    .progress-fill{
      height:100%;
      border-radius:999px;
      transition:width .6s ease;
    }
    .liga-tabs{
      display:flex;
      gap:8px;
      flex-wrap:wrap;
      justify-content:center;
      margin-bottom:30px;
    }
    .tab{
      padding:10px 18px;
      border-radius:12px;
      border:1px solid var(--edge);
      background:var(--glass);
      color:var(--text);
      text-decoration:none;
      font-weight:700;
      font-size:.9em;
      transition:all .2s ease;
      display:flex;
      align-items:center;
      gap:8px;
    }
    .tab:hover{
      border-color:rgba(255,255,255,.25);
      transform:translateY(-2px);
    }
    .tab.active{
      background:linear-gradient(180deg, var(--accent), var(--accent2));
      color:#0a0f18;
      border-color:var(--accent);
    }
    .tab-badge{
      background:rgba(0,0,0,.2);
      padding:2px 8px;
      border-radius:999px;
      font-size:.85em;
    }
    .ranking-table{
      background:var(--glass);
      border:1px solid var(--edge);
      border-radius:var(--radius);
      box-shadow:var(--shadow);
      backdrop-filter:blur(var(--blur)) saturate(120%);
      overflow:hidden;
      max-width:1000px;
      margin:0 auto;
    }
    table{
      width:100%;
      border-collapse:collapse;
    }
    thead{
      background:rgba(0,0,0,.3);
    }
    th{
      padding:16px 12px;
      text-align:left;
      font-weight:900;
      font-size:.85em;
      color:var(--accent);
      text-transform:uppercase;
      letter-spacing:.5px;
    }
    td{
      padding:14px 12px;
      border-top:1px solid var(--edge);
    }
    tbody tr{
      transition:background .2s ease;
    }
    tbody tr:hover{
      background:rgba(255,255,255,.03);
    }
    tbody tr.highlight{
      background:rgba(247,183,51,.1);
    }
    .pos{
      font-weight:900;
      font-size:1.1em;
      width:60px;
      text-align:center;
    }
    .pos-1{ color:#ffd700; }
    .pos-2{ color:#c0c0c0; }
    .pos-3{ color:#cd7f32; }
    .jugador-nombre{
      font-weight:700;
      display:flex;
      align-items:center;
      gap:10px;
    }
    .liga-icon{
      font-size:1.2em;
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
      table{
        font-size:.85em;
      }
      th, td{
        padding:10px 8px;
      }
      .hide-mobile{
        display:none;
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
      <h1 class="title">Clasificaciones</h1>
      <p class="subtitle">Compará tu deducción con otros detectives</p>
    </div>

    <!-- Tarjeta del usuario -->
    <div class="user-card">
      <div class="liga-badge liga-<%=ligaUsuario%>">
        <% if ("bronce".equals(ligaUsuario)) { %>🥉
        <% } else if ("plata".equals(ligaUsuario)) { %>🥈
        <% } else if ("oro".equals(ligaUsuario)) { %>🥇
        <% } else if ("platino".equals(ligaUsuario)) { %>💎
        <% } else if ("diamante".equals(ligaUsuario)) { %>💠
        <% } %>
      </div>
      <div class="user-info">
        <div class="user-name"><%=nombre%></div>
        <div style="color:var(--accent); font-weight:700; text-transform:uppercase; font-size:.9em; margin-bottom:4px;">
          Liga <%=ligaUsuario.substring(0,1).toUpperCase() + ligaUsuario.substring(1)%>
        </div>
        <div class="user-stats">
          <div class="stat-item">
            <i class="fa-solid fa-trophy"></i>
            <span>Posición #<%=posicionUsuario%></span>
          </div>
          <div class="stat-item">
            <i class="fa-solid fa-star"></i>
            <span><%=puntosUsuario%> puntos</span>
          </div>
        </div>
        <% if (puntosRestantes > 0 && !"diamante".equals(ligaUsuario)) { %>
          <div class="progress-info">
            <div class="progress-label">
              <strong><%=puntosRestantes%> puntos</strong> para la próxima liga
            </div>
            <div class="progress-bar">
              <% 
                int puntosParaProxima = 0;
                int puntosBase = 0;
                if ("bronce".equals(ligaUsuario)) { puntosBase = 0; puntosParaProxima = 101; }
                else if ("plata".equals(ligaUsuario)) { puntosBase = 101; puntosParaProxima = 301; }
                else if ("oro".equals(ligaUsuario)) { puntosBase = 301; puntosParaProxima = 601; }
                else if ("platino".equals(ligaUsuario)) { puntosBase = 601; puntosParaProxima = 1000; }
                int progreso = ((puntosUsuario - puntosBase) * 100) / (puntosParaProxima - puntosBase);
              %>
              <div class="progress-fill liga-<%=ligaUsuario%>" style="width: <%=progreso%>%"></div>
            </div>
          </div>
        <% } %>
      </div>
    </div>

    <!-- Tabs de ligas -->
    <div class="liga-tabs">
      <a href="?liga=todas" class="tab <%= "todas".equals(ligaFiltro) ? "active" : "" %>">
        <i class="fa-solid fa-globe"></i>
        Global
        <span class="tab-badge"><%=ranking.size()%></span>
      </a>
      <a href="?liga=bronce" class="tab <%= "bronce".equals(ligaFiltro) ? "active" : "" %>">
        🥉 Bronce
        <span class="tab-badge"><%=distribucion.getOrDefault("bronce", 0)%></span>
      </a>
      <a href="?liga=plata" class="tab <%= "plata".equals(ligaFiltro) ? "active" : "" %>">
        🥈 Plata
        <span class="tab-badge"><%=distribucion.getOrDefault("plata", 0)%></span>
      </a>
      <a href="?liga=oro" class="tab <%= "oro".equals(ligaFiltro) ? "active" : "" %>">
        🥇 Oro
        <span class="tab-badge"><%=distribucion.getOrDefault("oro", 0)%></span>
      </a>
      <a href="?liga=platino" class="tab <%= "platino".equals(ligaFiltro) ? "active" : "" %>">
        💎 Platino
        <span class="tab-badge"><%=distribucion.getOrDefault("platino", 0)%></span>
      </a>
      <a href="?liga=diamante" class="tab <%= "diamante".equals(ligaFiltro) ? "active" : "" %>">
        💠 Diamante
        <span class="tab-badge"><%=distribucion.getOrDefault("diamante", 0)%></span>
      </a>
    </div>

    <!-- Tabla de clasificación -->
    <% if (ranking.isEmpty()) { %>
      <div class="ranking-table">
        <div class="empty-state">
          <i class="fa-solid fa-users-slash"></i>
          <h3>No hay jugadores en esta liga</h3>
          <p>Sé el primero en alcanzarla</p>
        </div>
      </div>
    <% } else { %>
      <div class="ranking-table">
        <table>
          <thead>
            <tr>
              <th>POS</th>
              <th>JUGADOR</th>
              <th class="hide-mobile">LIGA</th>
              <th>PUNTOS</th>
              <th class="hide-mobile">CASOS</th>
              <th class="hide-mobile">LOGROS</th>
            </tr>
          </thead>
          <tbody>
            <% 
              Integer currentUserId = (Integer) session.getAttribute("userId");
              for (Map<String, Object> jugador : ranking) {
                int pos = (Integer) jugador.get("posicion");
                String nombreJugador = (String) jugador.get("nombre");
                int puntos = (Integer) jugador.get("puntos");
                int casos = (Integer) jugador.get("casosResueltos");
                int logros = (Integer) jugador.get("logros");
                String liga = (String) jugador.get("liga");
                int jugadorId = (Integer) jugador.get("id");
                boolean esUsuarioActual = currentUserId != null && currentUserId == jugadorId;
                
                String posClass = "";
                if (pos == 1) posClass = "pos-1";
                else if (pos == 2) posClass = "pos-2";
                else if (pos == 3) posClass = "pos-3";
            %>
              <tr <%= esUsuarioActual ? "class='highlight'" : "" %>>
                <td class="pos <%=posClass%>">
                  <% if (pos <= 3) { %>
                    <% if (pos == 1) { %>👑
                    <% } else if (pos == 2) { %>🥈
                    <% } else { %>🥉
                    <% } %>
                  <% } else { %>
                    <%=pos%>
                  <% } %>
                </td>
                <td class="jugador-nombre">
                  <%=nombreJugador%>
                  <% if (esUsuarioActual) { %>
                    <span style="color:var(--accent); font-size:.85em;">(Tú)</span>
                  <% } %>
                </td>
                <td class="hide-mobile">
                  <span class="liga-icon">
                    <% if ("bronce".equals(liga)) { %>🥉
                    <% } else if ("plata".equals(liga)) { %>🥈
                    <% } else if ("oro".equals(liga)) { %>🥇
                    <% } else if ("platino".equals(liga)) { %>💎
                    <% } else if ("diamante".equals(liga)) { %>💠
                    <% } %>
                  </span>
                </td>
                <td><strong><%=puntos%></strong></td>
                <td class="hide-mobile"><%=casos%></td>
                <td class="hide-mobile"><%=logros%></td>
              </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    <% } %>
  </div>
</body>
</html>

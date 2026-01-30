<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Estadísticas de Usuarios — Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/admin-usuarios-list.css">
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&family=Overpass:wght@600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
  <style>
    .chart-container {
      background: white;
      border-radius: 12px;
      padding: 24px;
      margin-bottom: 24px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    .chart-wrapper {
      position: relative;
      height: 350px;
      margin: 20px 0;
    }
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 16px;
      margin-bottom: 30px;
    }
    .stat-box {
      background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
      padding: 20px;
      border-radius: 10px;
      text-align: center;
      box-shadow: 0 2px 6px rgba(59, 130, 246, 0.3);
    }
    .stat-box .value {
      font-size: 32px;
      font-weight: 800;
      color: #1e40af;
      margin-bottom: 4px;
    }
    .stat-box .label {
      font-size: 13px;
      color: #1e3a8a;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
  </style>
</head>
<body>
<div class="page">

  <header>
    <h1><i class="fa-solid fa-users" style="color: #3b82f6;"></i> Estadísticas de Usuarios</h1>
    <p class="subtitle">Análisis de usuarios registrados y actividad</p>
  </header>

  <%
    @SuppressWarnings("unchecked")
    Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
    
    int total = stats != null ? (Integer) stats.get("total") : 0;
    int activos = stats != null ? (Integer) stats.get("activos") : 0;
    int inactivos = stats != null ? (Integer) stats.get("inactivos") : 0;
  %>

  <div style="margin-bottom: 20px;">
    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/dashboard">
      <i class="fa-solid fa-arrow-left"></i> Volver al Dashboard
    </a>
  </div>

  <div class="stats-grid">
    <div class="stat-box">
      <div class="value"><%= total %></div>
      <div class="label">Total Usuarios</div>
    </div>
    <div class="stat-box">
      <div class="value"><%= activos %></div>
      <div class="label">Activos</div>
    </div>
    <div class="stat-box">
      <div class="value"><%= inactivos %></div>
      <div class="label">Inactivos</div>
    </div>
    <div class="stat-box">
      <div class="value"><%= activos > 0 ? String.format("%.1f", (activos * 100.0 / total)) : "0" %>%</div>
      <div class="label">Tasa de Actividad</div>
    </div>
  </div>

  <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px;">
    <!-- Gráfico de roles -->
    <div class="chart-container">
      <h3 style="margin: 0 0 20px 0; color: #1f2937; font-size: 18px;">
        <i class="fa-solid fa-pie-chart"></i> Usuarios por Rol
      </h3>
      <div class="chart-wrapper">
        <canvas id="rolesChart"></canvas>
      </div>
    </div>

    <!-- Top jugadores -->
    <div class="chart-container">
      <h3 style="margin: 0 0 20px 0; color: #1f2937; font-size: 18px;">
        <i class="fa-solid fa-trophy"></i> Top 10 Jugadores Activos
      </h3>
      <div class="chart-wrapper">
        <canvas id="topJugadoresChart"></canvas>
      </div>
    </div>
  </div>

</div>

<script>
  // Gráfico de roles
  <%
    @SuppressWarnings("unchecked")
    List<Map<String, Object>> roles = stats != null ? (List<Map<String, Object>>) stats.get("roles") : new ArrayList<>();
  %>
  const rolesLabels = [<% for (int i = 0; i < roles.size(); i++) { 
    out.print("'" + roles.get(i).get("rol") + "'");
    if (i < roles.size() - 1) out.print(",");
  } %>];
  
  const rolesData = [<% for (int i = 0; i < roles.size(); i++) {
    out.print(roles.get(i).get("cantidad"));
    if (i < roles.size() - 1) out.print(",");
  } %>];
  
  new Chart(document.getElementById('rolesChart'), {
    type: 'doughnut',
    data: {
      labels: rolesLabels,
      datasets: [{
        data: rolesData,
        backgroundColor: ['#3b82f6', '#10b981', '#f59e0b', '#8b5cf6']
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: { position: 'bottom' }
      }
    }
  });

  // Gráfico top jugadores
  <%
    @SuppressWarnings("unchecked")
    List<Map<String, Object>> topJugadores = stats != null ? (List<Map<String, Object>>) stats.get("topJugadores") : new ArrayList<>();
  %>
  const jugadoresLabels = [<% for (int i = 0; i < topJugadores.size(); i++) {
    out.print("'" + ((String)topJugadores.get(i).get("nombre")).replace("'", "\\'") + "'");
    if (i < topJugadores.size() - 1) out.print(",");
  } %>];
  
  const jugadoresData = [<% for (int i = 0; i < topJugadores.size(); i++) {
    out.print(topJugadores.get(i).get("partidas"));
    if (i < topJugadores.size() - 1) out.print(",");
  } %>];
  
  new Chart(document.getElementById('topJugadoresChart'), {
    type: 'bar',
    data: {
      labels: jugadoresLabels,
      datasets: [{
        label: 'Partidas Jugadas',
        data: jugadoresData,
        backgroundColor: 'rgba(59, 130, 246, 0.8)',
        borderColor: '#3b82f6',
        borderWidth: 2,
        borderRadius: 6
      }]
    },
    options: {
      indexAxis: 'y',
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: { display: false }
      },
      scales: {
        x: {
          beginAtZero: true,
          ticks: { precision: 0 }
        }
      }
    }
  });
</script>

</body>
</html>

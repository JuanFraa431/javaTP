<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Estadísticas de Partidas — Admin</title>
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
      background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
      padding: 20px;
      border-radius: 10px;
      text-align: center;
      box-shadow: 0 2px 6px rgba(16, 185, 129, 0.3);
    }
    .stat-box .value {
      font-size: 32px;
      font-weight: 800;
      color: #065f46;
      margin-bottom: 4px;
    }
    .stat-box .label {
      font-size: 13px;
      color: #064e3b;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
  </style>
</head>
<body>
<div class="page">

  <header>
    <h1><i class="fa-solid fa-chess-knight" style="color: #10b981;"></i> Estadísticas de Partidas</h1>
    <p class="subtitle">Análisis de partidas jugadas y estados</p>
  </header>

  <%
    @SuppressWarnings("unchecked")
    Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
    
    int total = stats != null ? (Integer) stats.get("total") : 0;
    int enCurso = stats != null ? (Integer) stats.get("enCurso") : 0;
    int completadas = stats != null ? (Integer) stats.get("completadas") : 0;
    int tiempoPromedio = stats != null ? (Integer) stats.get("tiempoPromedio") : 0;
  %>

  <div style="margin-bottom: 20px;">
    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/dashboard">
      <i class="fa-solid fa-arrow-left"></i> Volver al Dashboard
    </a>
  </div>

  <div class="stats-grid">
    <div class="stat-box">
      <div class="value"><%= total %></div>
      <div class="label">Total Partidas</div>
    </div>
    <div class="stat-box">
      <div class="value"><%= enCurso %></div>
      <div class="label">En Curso</div>
    </div>
    <div class="stat-box">
      <div class="value"><%= completadas %></div>
      <div class="label">Completadas</div>
    </div>
    <div class="stat-box">
      <div class="value"><%= tiempoPromedio %> min</div>
      <div class="label">Tiempo Promedio</div>
    </div>
  </div>

  <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px;">
    <!-- Gráfico de estados -->
    <div class="chart-container">
      <h3 style="margin: 0 0 20px 0; color: #1f2937; font-size: 18px;">
        <i class="fa-solid fa-chart-pie"></i> Distribución por Estado
      </h3>
      <div class="chart-wrapper">
        <canvas id="estadosChart"></canvas>
      </div>
    </div>

    <!-- Partidas por historia -->
    <div class="chart-container">
      <h3 style="margin: 0 0 20px 0; color: #1f2937; font-size: 18px;">
        <i class="fa-solid fa-book"></i> Partidas por Historia
      </h3>
      <div class="chart-wrapper">
        <canvas id="historiasChart"></canvas>
      </div>
    </div>
  </div>

</div>

<script>
  // Gráfico de estados
  <%
    @SuppressWarnings("unchecked")
    List<Map<String, Object>> estados = stats != null ? (List<Map<String, Object>>) stats.get("estados") : new ArrayList<>();
  %>
  const estadosLabels = [<% for (int i = 0; i < estados.size(); i++) {
    out.print("'" + estados.get(i).get("estado") + "'");
    if (i < estados.size() - 1) out.print(",");
  } %>];
  
  const estadosData = [<% for (int i = 0; i < estados.size(); i++) {
    out.print(estados.get(i).get("cantidad"));
    if (i < estados.size() - 1) out.print(",");
  } %>];
  
  new Chart(document.getElementById('estadosChart'), {
    type: 'doughnut',
    data: {
      labels: estadosLabels,
      datasets: [{
        data: estadosData,
        backgroundColor: ['#3b82f6', '#10b981', '#f59e0b', '#dc2626']
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

  // Gráfico de historias
  <%
    @SuppressWarnings("unchecked")
    List<Map<String, Object>> historias = stats != null ? (List<Map<String, Object>>) stats.get("historias") : new ArrayList<>();
  %>
  const historiasLabels = [<% for (int i = 0; i < historias.size(); i++) {
    out.print("'" + ((String)historias.get(i).get("titulo")).replace("'", "\\'") + "'");
    if (i < historias.size() - 1) out.print(",");
  } %>];
  
  const historiasData = [<% for (int i = 0; i < historias.size(); i++) {
    out.print(historias.get(i).get("cantidad"));
    if (i < historias.size() - 1) out.print(",");
  } %>];
  
  new Chart(document.getElementById('historiasChart'), {
    type: 'bar',
    data: {
      labels: historiasLabels,
      datasets: [{
        label: 'Partidas',
        data: historiasData,
        backgroundColor: 'rgba(16, 185, 129, 0.8)',
        borderColor: '#10b981',
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

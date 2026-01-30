<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Estadísticas de Historias — Admin</title>
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
      height: 400px;
      margin: 20px 0;
    }
    .historia-card {
      background: #f9fafb;
      border-radius: 8px;
      padding: 16px;
      margin-bottom: 12px;
      border-left: 4px solid #8b5cf6;
    }
    .historia-card h4 {
      margin: 0 0 8px 0;
      color: #1f2937;
      font-size: 16px;
    }
    .historia-card .stats {
      display: flex;
      gap: 16px;
      font-size: 13px;
      color: #6b7280;
      flex-wrap: wrap;
    }
    .historia-card .stat-item {
      display: flex;
      align-items: center;
      gap: 4px;
    }
  </style>
</head>
<body>
<div class="page">

  <header>
    <h1><i class="fa-solid fa-book-open" style="color: #8b5cf6;"></i> Estadísticas de Historias</h1>
    <p class="subtitle">Análisis de historias y tasa de completado</p>
  </header>

  <%
    @SuppressWarnings("unchecked")
    List<Map<String, Object>> historiasStats = (List<Map<String, Object>>) request.getAttribute("historiasStats");
  %>

  <div style="margin-bottom: 20px;">
    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/dashboard">
      <i class="fa-solid fa-arrow-left"></i> Volver al Dashboard
    </a>
  </div>

  <!-- Gráfico de partidas por historia -->
  <div class="chart-container">
    <h3 style="margin: 0 0 20px 0; color: #1f2937; font-size: 18px;">
      <i class="fa-solid fa-chart-bar"></i> Partidas Jugadas por Historia
    </h3>
    <div class="chart-wrapper">
      <canvas id="partidasChart"></canvas>
    </div>
  </div>

  <!-- Gráfico de tasa de completado -->
  <div class="chart-container">
    <h3 style="margin: 0 0 20px 0; color: #1f2937; font-size: 18px;">
      <i class="fa-solid fa-percentage"></i> Tasa de Completado por Historia
    </h3>
    <div class="chart-wrapper">
      <canvas id="completadoChart"></canvas>
    </div>
  </div>

  <!-- Lista detallada -->
  <div class="chart-container">
    <h3 style="margin: 0 0 20px 0; color: #1f2937; font-size: 18px;">
      <i class="fa-solid fa-list"></i> Detalle de Historias
    </h3>
    
    <% if (historiasStats != null && !historiasStats.isEmpty()) {
         for (Map<String, Object> h : historiasStats) {
           String titulo = (String) h.get("titulo");
           String dificultad = (String) h.get("dificultad");
           int totalPartidas = (Integer) h.get("totalPartidas");
           int completadas = (Integer) h.get("partidasCompletadas");
           double tasa = (Double) h.get("tasaCompletado");
           int tiempo = (Integer) h.get("tiempoPromedio");
    %>
      <div class="historia-card">
        <h4><%= titulo %></h4>
        <div class="stats">
          <span class="stat-item">
            <i class="fa-solid fa-signal" style="color: #8b5cf6;"></i> <%= dificultad %>
          </span>
          <span class="stat-item">
            <i class="fa-solid fa-chess-knight" style="color: #3b82f6;"></i> <%= totalPartidas %> partidas
          </span>
          <span class="stat-item">
            <i class="fa-solid fa-check-circle" style="color: #10b981;"></i> <%= completadas %> completadas (<%= String.format("%.1f", tasa) %>%)
          </span>
          <span class="stat-item">
            <i class="fa-solid fa-clock" style="color: #f59e0b;"></i> <%= tiempo %> min promedio
          </span>
        </div>
      </div>
    <% } } else { %>
      <p style="text-align: center; color: #999; padding: 40px;">No hay datos disponibles</p>
    <% } %>
  </div>

</div>

<script>
  // Datos
  const historiasTitulos = [<% if (historiasStats != null) {
    for (int i = 0; i < historiasStats.size(); i++) {
      out.print("'" + ((String)historiasStats.get(i).get("titulo")).replace("'", "\\'") + "'");
      if (i < historiasStats.size() - 1) out.print(",");
    }
  } %>];
  
  const partidasData = [<% if (historiasStats != null) {
    for (int i = 0; i < historiasStats.size(); i++) {
      out.print(historiasStats.get(i).get("totalPartidas"));
      if (i < historiasStats.size() - 1) out.print(",");
    }
  } %>];
  
  const tasaData = [<% if (historiasStats != null) {
    for (int i = 0; i < historiasStats.size(); i++) {
      out.print(String.format("%.1f", (Double)historiasStats.get(i).get("tasaCompletado")));
      if (i < historiasStats.size() - 1) out.print(",");
    }
  } %>];

  // Gráfico de partidas
  new Chart(document.getElementById('partidasChart'), {
    type: 'bar',
    data: {
      labels: historiasTitulos,
      datasets: [{
        label: 'Partidas Jugadas',
        data: partidasData,
        backgroundColor: 'rgba(139, 92, 246, 0.8)',
        borderColor: '#8b5cf6',
        borderWidth: 2,
        borderRadius: 6
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: { legend: { display: false } },
      scales: {
        y: { beginAtZero: true, ticks: { precision: 0 } }
      }
    }
  });

  // Gráfico de tasa completado
  new Chart(document.getElementById('completadoChart'), {
    type: 'bar',
    data: {
      labels: historiasTitulos,
      datasets: [{
        label: 'Tasa de Completado (%)',
        data: tasaData,
        backgroundColor: 'rgba(16, 185, 129, 0.8)',
        borderColor: '#10b981',
        borderWidth: 2,
        borderRadius: 6
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: { legend: { display: false } },
      scales: {
        y: { 
          beginAtZero: true, 
          max: 100,
          ticks: {
            callback: function(value) { return value + '%'; }
          }
        }
      }
    }
  });
</script>

</body>
</html>

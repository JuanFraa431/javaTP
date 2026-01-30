<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Estadísticas de Logros — Admin</title>
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
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 16px;
      margin-bottom: 30px;
    }
    .stat-box {
      background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
      padding: 20px;
      border-radius: 10px;
      text-align: center;
      box-shadow: 0 2px 6px rgba(251, 191, 36, 0.3);
    }
    .stat-box .value {
      font-size: 32px;
      font-weight: 800;
      color: #d97706;
      margin-bottom: 4px;
    }
    .stat-box .label {
      font-size: 13px;
      color: #92400e;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    .logro-item {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 12px;
      background: #f9fafb;
      border-radius: 8px;
      margin-bottom: 8px;
    }
    .logro-item .icon {
      width: 40px;
      height: 40px;
      background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 20px;
      color: #d97706;
    }
    .logro-item .info {
      flex: 1;
    }
    .logro-item .nombre {
      font-weight: 700;
      color: #1f2937;
      margin-bottom: 2px;
    }
    .logro-item .stats {
      font-size: 12px;
      color: #6b7280;
    }
    .progress-bar {
      width: 100px;
      height: 8px;
      background: #e5e7eb;
      border-radius: 4px;
      overflow: hidden;
    }
    .progress-fill {
      height: 100%;
      background: linear-gradient(90deg, #3b82f6 0%, #2563eb 100%);
      transition: width 0.3s;
    }
  </style>
</head>
<body>
<div class="page">

  <header>
    <h1><i class="fa-solid fa-chart-bar" style="color: #fbbf24;"></i> Estadísticas de Logros</h1>
    <p class="subtitle">Análisis de achievements desbloqueados por los jugadores</p>
  </header>

  <%
    @SuppressWarnings("unchecked")
    List<Map<String, Object>> logrosStats = (List<Map<String, Object>>) request.getAttribute("logrosStats");
    
    int totalLogros = logrosStats != null ? logrosStats.size() : 0;
    int totalDesbloqueos = 0;
    int totalUsuarios = 0;
    
    if (logrosStats != null && !logrosStats.isEmpty()) {
      for (Map<String, Object> ls : logrosStats) {
        totalDesbloqueos += (Integer) ls.get("desbloqueos");
      }
      totalUsuarios = (Integer) logrosStats.get(0).get("totalUsuarios");
    }
    
    double promedioDesbloqueos = totalUsuarios > 0 ? (totalDesbloqueos * 1.0 / totalUsuarios) : 0;
  %>

  <!-- Botón volver -->
  <div style="margin-bottom: 20px;">
    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/dashboard">
      <i class="fa-solid fa-arrow-left"></i> Volver al Dashboard
    </a>
  </div>

  <!-- Resumen -->
  <div class="stats-grid">
    <div class="stat-box">
      <div class="value"><%= totalLogros %></div>
      <div class="label">Total Logros</div>
    </div>
    <div class="stat-box">
      <div class="value"><%= totalDesbloqueos %></div>
      <div class="label">Total Desbloqueos</div>
    </div>
    <div class="stat-box">
      <div class="value"><%= totalUsuarios %></div>
      <div class="label">Usuarios Activos</div>
    </div>
    <div class="stat-box">
      <div class="value"><%= String.format("%.1f", promedioDesbloqueos) %></div>
      <div class="label">Promedio por Usuario</div>
    </div>
  </div>

  <!-- Gráfico de barras -->
  <div class="chart-container">
    <h3 style="margin: 0 0 20px 0; color: #1f2937; font-size: 18px;">
      <i class="fa-solid fa-chart-column"></i> Desbloqueos por Logro
    </h3>
    <div class="chart-wrapper">
      <canvas id="logrosChart"></canvas>
    </div>
  </div>

  <!-- Lista detallada -->
  <div class="chart-container">
    <h3 style="margin: 0 0 20px 0; color: #1f2937; font-size: 18px;">
      <i class="fa-solid fa-list"></i> Detalle de Logros
    </h3>
    
    <% if (logrosStats != null && !logrosStats.isEmpty()) {
         for (Map<String, Object> ls : logrosStats) {
           String nombre = (String) ls.get("nombre");
           String icono = (String) ls.get("icono");
           int puntos = (Integer) ls.get("puntos");
           int desbloqueos = (Integer) ls.get("desbloqueos");
           double porcentaje = (Double) ls.get("porcentaje");
    %>
      <div class="logro-item">
        <div class="icon"><i class="<%= icono %>"></i></div>
        <div class="info">
          <div class="nombre"><%= nombre %></div>
          <div class="stats">
            <i class="fa-solid fa-coins" style="color: #f59e0b;"></i> <%= puntos %> pts
            · 
            <i class="fa-solid fa-users" style="color: #3b82f6;"></i> <%= desbloqueos %> jugadores (<%= String.format("%.1f", porcentaje) %>%)
          </div>
        </div>
        <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 4px;">
          <strong style="font-size: 20px; color: #3b82f6;"><%= desbloqueos %></strong>
          <div class="progress-bar">
            <div class="progress-fill" style="width: <%= porcentaje %>%;"></div>
          </div>
        </div>
      </div>
    <% } } else { %>
      <p style="text-align: center; color: #999; padding: 40px;">No hay datos disponibles</p>
    <% } %>
  </div>

</div>

<script>
  // Datos para el gráfico
  const labels = [
    <% if (logrosStats != null) {
         for (int i = 0; i < logrosStats.size(); i++) {
           Map<String, Object> ls = logrosStats.get(i);
           String nombre = (String) ls.get("nombre");
           out.print("'" + nombre.replace("'", "\\'") + "'");
           if (i < logrosStats.size() - 1) out.print(",");
         }
       } %>
  ];
  
  const data = [
    <% if (logrosStats != null) {
         for (int i = 0; i < logrosStats.size(); i++) {
           Map<String, Object> ls = logrosStats.get(i);
           int desbloqueos = (Integer) ls.get("desbloqueos");
           out.print(desbloqueos);
           if (i < logrosStats.size() - 1) out.print(",");
         }
       } %>
  ];
  
  // Configuración del gráfico
  const ctx = document.getElementById('logrosChart').getContext('2d');
  new Chart(ctx, {
    type: 'bar',
    data: {
      labels: labels,
      datasets: [{
        label: 'Desbloqueos',
        data: data,
        backgroundColor: 'rgba(59, 130, 246, 0.8)',
        borderColor: 'rgba(59, 130, 246, 1)',
        borderWidth: 2,
        borderRadius: 6,
        borderSkipped: false
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: false
        },
        tooltip: {
          backgroundColor: 'rgba(0, 0, 0, 0.8)',
          padding: 12,
          titleFont: { size: 14, weight: 'bold' },
          bodyFont: { size: 13 },
          callbacks: {
            label: function(context) {
              return context.parsed.y + ' jugadores desbloquearon este logro';
            }
          }
        }
      },
      scales: {
        y: {
          beginAtZero: true,
          ticks: {
            precision: 0,
            font: { size: 12 }
          },
          grid: {
            color: 'rgba(0, 0, 0, 0.05)'
          }
        },
        x: {
          ticks: {
            font: { size: 11 },
            maxRotation: 45,
            minRotation: 45
          },
          grid: {
            display: false
          }
        }
      }
    }
  });
</script>

</body>
</html>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,entities.Historia" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Elegí una historia</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/partidas.css">
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&display=swap" rel="stylesheet">
</head>
<body>

  <h1 class="title">Elegí una historia</h1>
  <p class="subtitle">Comenzá un caso nuevo. Más historias se desbloquearán pronto...</p>

  <div class="grid">
  <%
    List<Historia> historias = (List<Historia>) request.getAttribute("historias");
    if (historias != null) {
      for (Historia h : historias) {
        boolean activa = h.isActiva();
  %>
    <div class="card <%= activa ? "disponible" : "bloqueada" %>">
      <span class="badge"><%= activa ? "Disponible" : "Bloqueada" %></span>
      <h2><%= h.getTitulo() %></h2>
      <p><%= h.getDescripcion() != null ? h.getDescripcion() : "" %></p>
      <% if (activa) { %>
        <form action="${pageContext.request.contextPath}/jugador/partidas/iniciar" method="post">
          <input type="hidden" name="idHistoria" value="<%= h.getId() %>">
          <button type="submit" class="btn-jugar">Jugar</button>
        </form>
      <% } else { %>
        <button class="btn-bloqueado" disabled>Bloqueado</button>
      <% } %>
    </div>
  <%
      }
    } else {
  %>
    <p>No hay historias disponibles.</p>
  <%
    }
  %>
  </div>

</body>
</html>

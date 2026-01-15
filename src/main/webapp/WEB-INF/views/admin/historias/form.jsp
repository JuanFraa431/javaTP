<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="entities.Historia" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Historia — Formulario</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/admin-usuarios-form.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/admin-historias-form.css">
</head>
<body>
<%
  Historia h = (Historia) request.getAttribute("historia"); // null si es alta
  boolean edicion = (h != null);
%>
<div class="page">
  <h1><%= edicion ? "Editar historia" : "Nueva historia" %></h1>

  <form class="card" action="${pageContext.request.contextPath}/admin/historias/save" method="post">
    <% if (edicion) { %>
      <input type="hidden" name="id" value="<%=h.getId()%>">
    <% } %>

    <div class="row">
      <label>Título *</label>
      <input type="text" name="titulo" required maxlength="200"
             value="<%= edicion ? h.getTitulo() : "" %>">
    </div>

    <div class="row">
      <label>Descripción *</label>
      <textarea name="descripcion" rows="5" required><%= edicion ? h.getDescripcion() : "" %></textarea>
    </div>

    <div class="row">
      <label>Contexto</label>
      <textarea name="contexto" rows="4"><%= edicion ? (h.getContexto()==null?"":h.getContexto()) : "" %></textarea>
    </div>

    <div class="row three">
      <div>
        <label>Dificultad (1–5)</label>
        <input type="number" name="dificultad" min="1" max="5"
               value="<%= edicion ? h.getDificultad() : 1 %>">
      </div>
      <div>
        <label>Tiempo estimado (min)</label>
        <input type="number" name="tiempo_estimado" min="0"
               value="<%= edicion ? h.getTiempoEstimado() : 0 %>">
      </div>
      <div class="check">
        <label>Activa</label>
        <input type="checkbox" name="activa" <%= !edicion || h.isActiva() ? "checked" : "" %> >
      </div>
    </div>

    <div class="actions">
      <button class="btn" type="submit"><i class="fa-solid fa-save"></i> Guardar</button>
      <a class="btn btn-ghost" href="${pageContext.request.contextPath}/admin/historias">Cancelar</a>
    </div>
  </form>
</div>
</body>
</html>

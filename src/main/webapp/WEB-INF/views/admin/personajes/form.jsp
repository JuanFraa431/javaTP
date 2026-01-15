<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="entities.Personaje, entities.Historia, java.util.List" %>
<%
  Personaje p = (Personaje) request.getAttribute("personaje");
  @SuppressWarnings("unchecked")
  List<Historia> historias = (List<Historia>) request.getAttribute("historias");
  String error = (String) request.getAttribute("error");
  boolean esEdicion = (p != null && p.getId() > 0);
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title><%= esEdicion ? "Editar" : "Nuevo" %> Personaje — Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/admin-usuarios-form.css">
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="page">

  <header>
    <h1><%= esEdicion ? "Editar Personaje" : "Nuevo Personaje" %></h1>
    <% if (esEdicion) { %>
      <p class="subtitle">ID <%= p.getId() %></p>
    <% } %>
  </header>

  <% if (error != null) { %>
    <div class="flash error"><i class="fa-solid fa-triangle-exclamation"></i> <%= error %></div>
  <% } %>

  <form method="post" action="${pageContext.request.contextPath}/admin/personajes/save" class="form-card">
    <% if (esEdicion) { %>
      <input type="hidden" name="id" value="<%= p.getId() %>">
    <% } %>

    <div class="form-group">
      <label for="nombre">Nombre <span class="required">*</span></label>
      <input type="text" id="nombre" name="nombre" 
             value="<%= p != null && p.getNombre() != null ? p.getNombre() : "" %>" 
             required maxlength="100">
    </div>

    <div class="form-group">
      <label for="descripcion">Descripción <span class="required">*</span></label>
      <textarea id="descripcion" name="descripcion" rows="3" required><%= p != null && p.getDescripcion() != null ? p.getDescripcion() : "" %></textarea>
    </div>

    <div class="form-group">
      <label for="coartada">Coartada</label>
      <textarea id="coartada" name="coartada" rows="3"><%= p != null && p.getCoartada() != null ? p.getCoartada() : "" %></textarea>
    </div>

    <div class="form-group">
      <label for="motivo">Motivo</label>
      <textarea id="motivo" name="motivo" rows="3"><%= p != null && p.getMotivo() != null ? p.getMotivo() : "" %></textarea>
    </div>

    <div class="form-group">
      <label for="historia_id">Historia <span class="required">*</span></label>
      <select id="historia_id" name="historia_id" required>
        <option value="">Seleccionar historia...</option>
        <%
          if (historias != null) {
            for (Historia h : historias) {
              boolean selected = (p != null && p.getHistoriaId() == h.getId());
        %>
          <option value="<%= h.getId() %>" <%= selected ? "selected" : "" %>>
            <%= h.getTitulo() %>
          </option>
        <%
            }
          }
        %>
      </select>
    </div>

    <div class="form-group checkbox-group">
      <label>
        <input type="checkbox" name="sospechoso" <%= (p != null && p.getSospechoso() == 1) ? "checked" : "" %>>
        <span>Es sospechoso</span>
      </label>
    </div>

    <div class="form-group checkbox-group">
      <label>
        <input type="checkbox" name="culpable" <%= (p != null && p.getCulpable() == 1) ? "checked" : "" %>>
        <span>Es culpable</span>
      </label>
    </div>

    <div class="actions">
      <button type="submit" class="btn btn-primary">
        <i class="fa-solid fa-floppy-disk"></i> Guardar
      </button>
      <a href="${pageContext.request.contextPath}/admin/personajes" class="btn btn-secondary">
        <i class="fa-solid fa-xmark"></i> Cancelar
      </a>
    </div>
  </form>

</div>
</body>
</html>

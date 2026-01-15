<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="entities.Usuario" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Usuario — Formulario</title>
  <!-- ESTILOS DEL FORM -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/admin-usuarios-form.css">
  <!-- Tipografías / Iconos (mismo set que login/dashboard) -->
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&family=Overpass:wght@600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body class="page">

  <%
    Usuario u = (Usuario) request.getAttribute("usuario"); // null si es alta
    boolean esEdicion = (u != null);

    String flashOk   = (String) request.getAttribute("flash_ok");
    String flashErr  = (String) request.getAttribute("flash_error");
  %>

  <!-- Encabezado -->
  <header class="header">
    <h1><%= esEdicion ? "Editar usuario" : "Nuevo usuario" %></h1>
    <p class="subtitle">Completá los campos y guardá los cambios</p>
  </header>

  <!-- Mensajes flash (opcional) -->
  <%
    if (flashOk != null) {
  %>
      <div class="flash ok"><i class="fa-solid fa-circle-check"></i> <%= flashOk %></div>
  <%
    } else if (flashErr != null) {
  %>
      <div class="flash error"><i class="fa-solid fa-triangle-exclamation"></i> <%= flashErr %></div>
  <%
    }
  %>

  <!-- Card de formulario -->
  <div class="form-card">
    <form action="<%=request.getContextPath()%>/admin/usuarios/save" method="post" autocomplete="off">

      <% if (esEdicion) { %>
        <input type="hidden" name="id" value="<%=u.getId()%>">
      <% } %>

      <div class="form-row">
        <div class="form-group">
          <label for="nombre">Nombre</label>
          <input id="nombre" class="input" type="text" name="nombre"
                 value="<%= esEdicion ? u.getNombre() : "" %>" required placeholder="Nombre y apellido">
        </div>

        <div class="form-group">
          <label for="email">Email</label>
          <input id="email" class="input" type="email" name="email"
                 value="<%= esEdicion ? u.getEmail() : "" %>" required placeholder="ej: admin@mansion.com">
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label for="rol">Rol</label>
          <select id="rol" class="select" name="rol" required>
            <option value="JUGADOR" <%= esEdicion && "JUGADOR".equalsIgnoreCase(u.getRol()) ? "selected":"" %>>JUGADOR</option>
            <option value="ADMIN"   <%= esEdicion && "ADMIN".equalsIgnoreCase(u.getRol()) ? "selected":"" %>>ADMIN</option>
            <option value="INVITADO" <%= esEdicion && "INVITADO".equalsIgnoreCase(u.getRol()) ? "selected":"" %>>INVITADO</option>
          </select>
        </div>

        <div class="form-group">
          <label for="password">Contraseña</label>
          <input id="password" class="input" type="password" name="password"
                 <%= esEdicion ? "" : "required" %>
                 placeholder="<%= esEdicion ? "Dejar vacío para no cambiar" : "Mín. 6 caracteres" %>">
          <div class="helper">
            <i class="fa-solid fa-circle-info"></i>
            <%= esEdicion ? "Completá sólo si querés cambiarla." : "Se guardará en SHA-256." %>
          </div>
        </div>
      </div>

      <div class="form-row full">
        <label class="check">
          <input type="checkbox" name="activo" <%= esEdicion ? "checked" : "checked" %>>
          Activo
        </label>
      </div>

      <div class="form-actions">
        <a class="btn btn-ghost" href="${pageContext.request.contextPath}/admin/usuarios">
          <i class="fa-solid fa-arrow-left"></i> Cancelar
        </a>
        <button class="btn" type="submit">
          <i class="fa-solid fa-floppy-disk"></i> Guardar
        </button>
      </div>
    </form>
  </div>
</body>
</html>

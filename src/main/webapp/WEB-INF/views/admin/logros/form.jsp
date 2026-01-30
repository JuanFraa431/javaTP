<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="entities.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title><%= request.getAttribute("esEdicion") != null && (boolean)request.getAttribute("esEdicion") ? "Editar" : "Nuevo" %> Logro — Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/admin-usuarios-form.css">
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&family=Overpass:wght@600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    .preview-icon {
      font-size: 48px;
      margin: 15px 0;
      display: block;
      color: #fbbf24;
      text-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .helper {
      color: #666;
      font-size: 13px;
      margin-top: 4px;
      display: flex;
      align-items: center;
      gap: 6px;
    }
    .helper i {
      color: #3b82f6;
    }
    .checkbox-field {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-top: 10px;
    }
    .checkbox-field input[type="checkbox"] {
      width: 20px;
      height: 20px;
      cursor: pointer;
    }
    .checkbox-field label {
      margin: 0;
      cursor: pointer;
      font-size: 14px;
    }
  </style>
</head>
<body class="page">

  <%
    Logro l = (Logro) request.getAttribute("logro");
    boolean esEdicion = l != null;
    
    String flashErr = (String) session.getAttribute("flash_error");
    if (flashErr != null) session.removeAttribute("flash_error");
  %>

  <!-- Encabezado -->
  <header class="header">
    <h1>
      <i class="fa-solid <%= esEdicion ? "fa-pen-to-square" : "fa-plus-circle" %>" style="color: #fbbf24;"></i>
      <%= esEdicion ? "Editar logro" : "Nuevo logro" %>
    </h1>
    <p class="subtitle">Configurá el achievement, su descripción, icono y puntos que otorga</p>
  </header>

  <!-- Mensajes flash -->
  <% if (flashErr != null) { %>
    <div class="flash error"><i class="fa-solid fa-triangle-exclamation"></i> <%= flashErr %></div>
  <% } %>

  <!-- Formulario -->
  <div class="form-card">
    <form method="post" action="${pageContext.request.contextPath}/admin/logros/save">
      
      <% if (esEdicion) { %>
        <input type="hidden" name="id" value="<%= l.getId() %>">
      <% } %>

      <div class="form-row">
        <div class="form-group">
          <label for="clave">
            <i class="fa-solid fa-key"></i> Clave del Logro *
          </label>
          <input type="text" id="clave" name="clave" required 
                 value="<%= esEdicion ? l.getClave() : "" %>"
                 placeholder="ej: primer_misterio, coleccionista">
          <p class="helper">
            <i class="fa-solid fa-circle-info"></i>
            Identificador único del logro en el sistema (sin espacios, usar guiones_bajos)
          </p>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label for="nombre">
            <i class="fa-solid fa-trophy"></i> Nombre del Logro *
          </label>
          <input type="text" id="nombre" name="nombre" required 
                 value="<%= esEdicion ? l.getNombre() : "" %>"
                 placeholder="ej: Primer Misterio Resuelto, Coleccionista Experto">
          <p class="helper">
            <i class="fa-solid fa-circle-info"></i>
            Título del logro que verá el jugador al desbloquearlo
          </p>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group full-width">
          <label for="descripcion">
            <i class="fa-solid fa-align-left"></i> Descripción
          </label>
          <textarea id="descripcion" name="descripcion" rows="3"
                    placeholder="Describe cómo se desbloquea este logro..."><%= esEdicion && l.getDescripcion() != null ? l.getDescripcion() : "" %></textarea>
          <p class="helper">
            <i class="fa-solid fa-circle-info"></i>
            Texto que explica al jugador cómo desbloquear este achievement
          </p>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label for="icono">
            <i class="fa-solid fa-icons"></i> Icono (Font Awesome) *
          </label>
          <input type="text" id="icono" name="icono" required 
                 value="<%= esEdicion ? l.getIcono() : "fa-solid fa-trophy" %>"
                 placeholder="ej: fa-solid fa-trophy, fa-solid fa-star"
                 oninput="document.getElementById('preview').className = this.value + ' preview-icon'">
          <i id="preview" class="<%= esEdicion ? l.getIcono() : "fa-solid fa-trophy" %> preview-icon"></i>
          <p class="helper">
            <i class="fa-solid fa-circle-info"></i>
            Clases de Font Awesome 6. Ejemplos: <code style="background:#f3f4f6;padding:2px 6px;border-radius:3px;font-size:11px;">fa-solid fa-medal</code>, <code style="background:#f3f4f6;padding:2px 6px;border-radius:3px;font-size:11px;">fa-solid fa-award</code>, <code style="background:#f3f4f6;padding:2px 6px;border-radius:3px;font-size:11px;">fa-solid fa-star</code>
          </p>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label for="puntos">
            <i class="fa-solid fa-coins"></i> Puntos *
          </label>
          <input type="number" id="puntos" name="puntos" required min="0" step="10"
                 value="<%= esEdicion ? l.getPuntos() : "100" %>"
                 placeholder="100">
          <p class="helper">
            <i class="fa-solid fa-circle-info"></i>
            Puntos que suma el jugador al desbloquear este logro. <strong>Recomendado:</strong> usar múltiplos de 10 o 50
          </p>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>
            <i class="fa-solid fa-toggle-on"></i> Estado
          </label>
          <div class="checkbox-field">
            <input type="checkbox" id="activo" name="activo" value="1" 
                   <%= esEdicion ? (l.getActivo() == 1 ? "checked" : "") : "checked" %>>
            <label for="activo">Logro activo (visible para jugadores)</label>
          </div>
          <p class="helper">
            <i class="fa-solid fa-circle-info"></i>
            Si desmarcás esta opción, el logro quedará oculto y no se podrá desbloquear hasta que lo reactives
          </p>
        </div>
      </div>

      <div class="form-actions">
        <button type="submit" class="btn btn-primary">
          <i class="fa-solid fa-save"></i>
          <%= esEdicion ? "Guardar Cambios" : "Crear Logro" %>
        </button>
        <a href="${pageContext.request.contextPath}/admin/logros" class="btn btn-secondary">
          <i class="fa-solid fa-times"></i> Cancelar
        </a>
      </div>

    </form>
  </div>

</body>
</html>

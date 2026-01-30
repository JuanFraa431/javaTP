<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="entities.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title><%= request.getAttribute("esEdicion") != null && (boolean)request.getAttribute("esEdicion") ? "Editar" : "Nuevo" %> Documento — Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/admin-usuarios-form.css">
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&family=Overpass:wght@600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    .preview-icon {
      font-size: 32px;
      margin: 10px 0;
      display: block;
      color: #3b82f6;
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
    textarea {
      min-height: 200px;
      font-family: 'Courier New', monospace;
      font-size: 14px;
      line-height: 1.5;
    }
  </style>
</head>
<body class="page">

  <%
    Documento d = (Documento) request.getAttribute("documento");
    boolean esEdicion = d != null;
    @SuppressWarnings("unchecked")
    List<Historia> historias = (List<Historia>) request.getAttribute("historias");
    
    String flashErr = (String) session.getAttribute("flash_error");
    if (flashErr != null) session.removeAttribute("flash_error");
  %>

  <!-- Encabezado -->
  <header class="header">
    <h1><%= esEdicion ? "Editar documento" : "Nuevo documento" %></h1>
    <p class="subtitle">Documentos del juego con códigos y pistas HTML</p>
  </header>

  <!-- Mensajes flash -->
  <% if (flashErr != null) { %>
    <div class="flash error"><i class="fa-solid fa-triangle-exclamation"></i> <%= flashErr %></div>
  <% } %>

  <!-- Formulario -->
  <div class="form-card">
    <form method="post" action="${pageContext.request.contextPath}/admin/documentos/save">
      
      <% if (esEdicion) { %>
        <input type="hidden" name="id" value="<%= d.getId() %>">
      <% } %>

      <div class="form-row">
        <div class="form-group">
          <label for="historia_id">
            <i class="fa-solid fa-book"></i> Historia *
          </label>
          <select id="historia_id" name="historia_id" required>
            <option value="">-- Seleccionar Historia --</option>
            <% 
              if (historias != null && !historias.isEmpty()) {
                for (Historia h : historias) { 
            %>
              <option value="<%= h.getId() %>" 
                      <%= esEdicion && d.getHistoriaId() == h.getId() ? "selected" : "" %>>
                <%= h.getTitulo() %>
              </option>
            <% 
                }
              } else { 
            %>
              <option value="" disabled>No hay historias disponibles</option>
            <% } %>
          </select>
          <p class="helper">
            <i class="fa-solid fa-circle-info"></i>
            Historia a la que pertenece este documento
          </p>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label for="clave">
            <i class="fa-solid fa-key"></i> Clave del Documento *
          </label>
          <input type="text" id="clave" name="clave" required 
                 value="<%= esEdicion ? d.getClave() : "" %>"
                 placeholder="ej: informe_forense, nota_codigo">
          <p class="helper">
            <i class="fa-solid fa-circle-info"></i>
            Identificador único del documento (sin espacios, usar guiones bajos)
          </p>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label for="nombre">
            <i class="fa-solid fa-tag"></i> Nombre del Documento *
          </label>
          <input type="text" id="nombre" name="nombre" required 
                 value="<%= esEdicion ? d.getNombre() : "" %>"
                 placeholder="ej: Informe Forense, Nota Manuscrita">
          <p class="helper">
            <i class="fa-solid fa-circle-info"></i>
            Nombre visible para el jugador
          </p>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label for="icono">
            <i class="fa-solid fa-icons"></i> Icono (Font Awesome) *
          </label>
          <input type="text" id="icono" name="icono" required 
                 value="<%= esEdicion ? d.getIcono() : "fa-regular fa-file-lines" %>"
                 placeholder="ej: fa-solid fa-file-pdf, fa-regular fa-envelope"
                 oninput="document.getElementById('preview').className = this.value + ' preview-icon'">
          <i id="preview" class="<%= esEdicion ? d.getIcono() : "fa-regular fa-file-lines" %> preview-icon"></i>
          <p class="helper">
            <i class="fa-solid fa-circle-info"></i>
            Clases de Font Awesome 6 (ejemplos: fa-solid fa-clipboard-check, fa-regular fa-note-sticky)
          </p>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group full-width">
          <label for="contenido">
            <i class="fa-solid fa-code"></i> Contenido HTML *
          </label>
          <textarea id="contenido" name="contenido" required 
                    placeholder="<h3>Título</h3>&#10;<p>Contenido del documento...</p>"><%= esEdicion ? d.getContenido() : "" %></textarea>
          <p class="helper">
            <i class="fa-solid fa-circle-info"></i>
            Contenido en formato HTML que se mostrará al jugador.
            <strong>Ejemplo:</strong> <code>&lt;h3&gt;Informe Policial&lt;/h3&gt;&lt;p&gt;Descripción...&lt;/p&gt;</code>
          </p>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label for="codigo_correcto">
            <i class="fa-solid fa-lock"></i> Código Correcto (opcional)
          </label>
          <input type="text" id="codigo_correcto" name="codigo_correcto" 
                 value="<%= esEdicion && d.getCodigoCorrecto() != null ? d.getCodigoCorrecto() : "" %>"
                 placeholder="ej: 7391, BAKER, WHITFIELD">
          <p class="helper">
            <i class="fa-solid fa-circle-info"></i>
            Si este documento contiene un código que el jugador debe descifrar, ingrésalo aquí
          </p>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label for="pista_nombre">
            <i class="fa-solid fa-lightbulb"></i> Nombre de Pista Asociada (opcional)
          </label>
          <input type="text" id="pista_nombre" name="pista_nombre" 
                 value="<%= esEdicion && d.getPistaNombre() != null ? d.getPistaNombre() : "" %>"
                 placeholder="ej: Código de la computadora, Video de Seguridad">
          <p class="helper">
            <i class="fa-solid fa-circle-info"></i>
            Si al resolver el código se desbloquea una pista específica, ingresá su nombre
          </p>
        </div>
      </div>

      <div class="form-actions">
        <button type="submit" class="btn btn-primary">
          <i class="fa-solid fa-save"></i>
          <%= esEdicion ? "Guardar Cambios" : "Crear Documento" %>
        </button>
        <a href="${pageContext.request.contextPath}/admin/documentos" class="btn btn-secondary">
          <i class="fa-solid fa-times"></i> Cancelar
        </a>
      </div>

    </form>
  </div>

  </main>

</body>
</html>

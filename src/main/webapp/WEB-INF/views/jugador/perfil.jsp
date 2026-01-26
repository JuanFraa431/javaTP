<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="entities.Usuario" %>
<%
  Usuario u = (Usuario) request.getAttribute("usuario");
  String ok = (String) session.getAttribute("flash_ok");
  String err = (String) session.getAttribute("flash_error");
  if (ok != null)  { session.removeAttribute("flash_ok"); }
  if (err != null) { session.removeAttribute("flash_error"); }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Mi perfil</title>
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&family=Overpass:wght@600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/perfil.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    /* Ajustes mínimos para esta vista (podés moverlos a un perfil.css) */
    .page{ max-width: 980px; margin: 0 auto; }
    .card{
      width:100%;
      background: var(--glass);
      border:1px solid var(--edge);
      border-radius: 16px;
      box-shadow: var(--shadow);
      backdrop-filter: blur(var(--blur)) saturate(120%);
      padding: 22px;
    }
    .form-grid{ display:grid; grid-template-columns: 1fr 1fr; gap: 14px; }
    .form-group label{ font-weight:800; display:block; margin-bottom:6px; }
    .form-group input{
      width:100%; padding: 12px 12px;
      border-radius:12px; border:1px solid rgba(255,255,255,.18);
      background: rgba(9,14,24,.58); color: var(--text); outline:none;
    }
    .hr{ height:1px; background:rgba(255,255,255,.1); margin:18px 0; border:0;}
    .btn-row{ display:flex; gap:10px; justify-content:flex-end; }
    
    /* Estilos para avatar */
    .avatar-section {
      text-align: center;
      margin-bottom: 24px;
    }
    .avatar-preview {
      width: 150px;
      height: 150px;
      border-radius: 50%;
      object-fit: cover;
      border: 4px solid rgba(255,255,255,.2);
      margin: 0 auto 16px;
      display: block;
      box-shadow: 0 8px 16px rgba(0,0,0,.3);
    }
    .avatar-upload-btn {
      position: relative;
      display: inline-block;
      cursor: pointer;
    }
    .avatar-upload-btn input[type="file"] {
      position: absolute;
      left: -9999px;
    }
    .avatar-upload-btn label {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 10px 20px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border-radius: 8px;
      cursor: pointer;
      font-weight: 700;
      transition: transform 0.2s;
    }
    .avatar-upload-btn label:hover {
      transform: translateY(-2px);
    }
    #preview-container {
      margin-top: 12px;
    }
    .preview-actions {
      display: none;
      gap: 8px;
      justify-content: center;
      margin-top: 12px;
    }
    .preview-actions.show {
      display: flex;
    }
  </style>
</head>
<body>
  <div class="page">
    <h1>Mi perfil</h1>
    <p class="subtitle">Actualizá tus datos o cambiá tu contraseña</p>

    <% if (ok != null) { %>
      <div class="flash ok"><i class="fa fa-check"></i> <%= ok %></div>
    <% } %>
    <% if (err != null) { %>
      <div class="flash error"><i class="fa fa-triangle-exclamation"></i> <%= err %></div>
    <% } %>

    <!-- Sección de Avatar -->
    <div class="card">
      <div class="avatar-section">
        <h3 style="margin-top:0"><i class="fa fa-user-circle"></i> Avatar</h3>
        <img id="avatar-img" class="avatar-preview" 
             src="<%= request.getContextPath() %>/avatar?userId=<%= u != null ? u.getId() : 0 %>" 
             alt="Avatar">
        
        <form id="avatar-form" action="${pageContext.request.contextPath}/jugador/upload-avatar" method="post" enctype="multipart/form-data">
          <div class="avatar-upload-btn">
            <input type="file" id="avatar-input" name="avatar" accept="image/*">
            <label for="avatar-input">
              <i class="fa fa-camera"></i> Cambiar Avatar
            </label>
          </div>
          
          <div id="preview-container">
            <div class="preview-actions" id="preview-actions">
              <button type="submit" class="btn" style="font-size: 14px; padding: 8px 16px;">
                <i class="fa fa-upload"></i> Subir Imagen
              </button>
              <button type="button" class="btn-ghost" onclick="cancelPreview()" style="font-size: 14px; padding: 8px 16px;">
                <i class="fa fa-times"></i> Cancelar
              </button>
            </div>
          </div>
        </form>
        
        <p style="color: rgba(255,255,255,.5); font-size: 13px; margin-top: 12px;">
          <i class="fa fa-info-circle"></i> Formatos: JPG, PNG, GIF, WebP (máx. 5MB)
        </p>
      </div>
    </div>

    <div class="card">
      <form action="${pageContext.request.contextPath}/jugador/perfil" method="post">
        <h3 style="margin-top:0">Datos de cuenta</h3>
        <div class="form-grid">
          <div class="form-group">
            <label for="nombre">Nombre</label>
            <input id="nombre" name="nombre" type="text" required value="<%= u != null ? u.getNombre() : "" %>">
          </div>
          <div class="form-group">
            <label for="email">Email</label>
            <input id="email" name="email" type="email" required value="<%= u != null ? u.getEmail() : "" %>">
          </div>
        </div>

        <hr class="hr">

        <h3>Contraseña (opcional)</h3>
        <div class="form-grid">
          <div class="form-group">
            <label for="password">Nueva contraseña</label>
            <input id="password" name="password" type="password" placeholder="Dejar vacío para no cambiar">
          </div>
          <div class="form-group">
            <label for="password2">Repetir nueva contraseña</label>
            <input id="password2" name="password2" type="password" placeholder="Repetila">
          </div>
        </div>

        <div class="btn-row" style="margin-top:14px">
          <a class="btn-ghost" href="${pageContext.request.contextPath}/jugador/home"><i class="fa fa-arrow-left"></i> Volver</a>
          <button class="btn" type="submit"><i class="fa fa-save"></i> Guardar cambios</button>
        </div>
      </form>
    </div>
  </div>
  
  <script>
    // Preview de imagen antes de subir
    const avatarInput = document.getElementById('avatar-input');
    const avatarImg = document.getElementById('avatar-img');
    const previewActions = document.getElementById('preview-actions');
    let originalSrc = avatarImg.src;
    
    avatarInput.addEventListener('change', function(e) {
      const file = e.target.files[0];
      if (file) {
        // Validar tamaño
        if (file.size > 5 * 1024 * 1024) {
          alert('El archivo es demasiado grande. Máximo 5MB');
          return;
        }
        
        // Validar tipo
        if (!file.type.match('image.*')) {
          alert('Por favor selecciona una imagen válida');
          return;
        }
        
        // Mostrar preview
        const reader = new FileReader();
        reader.onload = function(e) {
          avatarImg.src = e.target.result;
          previewActions.classList.add('show');
        };
        reader.readAsDataURL(file);
      }
    });
    
    function cancelPreview() {
      avatarImg.src = originalSrc;
      avatarInput.value = '';
      previewActions.classList.remove('show');
    }
  </script>
</body>
</html>

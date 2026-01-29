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
    .avatar-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(80px, 1fr));
      gap: 12px;
      max-width: 500px;
      margin: 20px auto;
    }
    .avatar-option {
      position: relative;
      cursor: pointer;
      border-radius: 50%;
      overflow: hidden;
      border: 3px solid transparent;
      transition: all 0.3s ease;
      aspect-ratio: 1;
    }
    .avatar-option:hover {
      transform: scale(1.1);
      border-color: rgba(102, 126, 234, 0.5);
    }
    .avatar-option.selected {
      border-color: #667eea;
      box-shadow: 0 0 20px rgba(102, 126, 234, 0.6);
    }
    .avatar-option img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
    .avatar-option .checkmark {
      position: absolute;
      top: 4px;
      right: 4px;
      background: #667eea;
      color: white;
      border-radius: 50%;
      width: 24px;
      height: 24px;
      display: none;
      align-items: center;
      justify-content: center;
      font-size: 14px;
    }
    .avatar-option.selected .checkmark {
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
        
        <button type="button" class="btn" id="btn-cambiar-avatar" style="margin-top: 16px;">
          <i class="fa fa-camera"></i> Cambiar Avatar
        </button>
        
        <div id="avatar-selector" style="display: none;">
          <p style="color: rgba(255,255,255,.7); font-size: 14px; margin: 16px 0 8px;">
            Seleccioná tu avatar preferido:
          </p>
          
          <form id="avatar-form" action="${pageContext.request.contextPath}/jugador/upload-avatar" method="post">
            <input type="hidden" name="avatarName" id="avatarName">
            
            <div class="avatar-grid">
              <% 
                // Escanear dinámicamente la carpeta avatars
                String avatarPath = application.getRealPath("/avatars");
                java.io.File avatarDir = new java.io.File(avatarPath);
                java.util.List<String> avatarFiles = new java.util.ArrayList<>();
                
                if (avatarDir.exists() && avatarDir.isDirectory()) {
                  java.io.File[] files = avatarDir.listFiles();
                  if (files != null) {
                    for (java.io.File file : files) {
                      String fileName = file.getName().toLowerCase();
                      // Aceptar imágenes: jpg, jpeg, png, gif, webp
                      if (fileName.endsWith(".jpg") || fileName.endsWith(".jpeg") || 
                          fileName.endsWith(".png") || fileName.endsWith(".gif") || 
                          fileName.endsWith(".webp")) {
                        avatarFiles.add(file.getName());
                      }
                    }
                  }
                  // Ordenar alfabéticamente
                  java.util.Collections.sort(avatarFiles);
                }
                
                String currentAvatar = (u != null && u.getAvatar() != null) ? u.getAvatar() : "";
                
                for (String avatar : avatarFiles) {
                  boolean isSelected = avatar.equals(currentAvatar);
              %>
              <div class="avatar-option <%= isSelected ? "selected" : "" %>" data-avatar="<%= avatar %>">
                <img src="${pageContext.request.contextPath}/avatars/<%= avatar %>" 
                     alt="<%= avatar %>"
                     onerror="this.src='${pageContext.request.contextPath}/avatar?userId=0'">
                <span class="checkmark"><i class="fa fa-check"></i></span>
              </div>
              <% } %>
            </div>
            
            <div style="display: flex; gap: 10px; margin-top: 16px; justify-content: center;">
              <button type="submit" class="btn">
                <i class="fa fa-save"></i> Guardar Avatar
              </button>
              <button type="button" class="btn-ghost" id="btn-cancelar-avatar">
                <i class="fa fa-times"></i> Cancelar
              </button>
            </div>
          </form>
          
          <p style="color: rgba(255,255,255,.5); font-size: 13px; margin-top: 12px;">
            <i class="fa fa-info-circle"></i> Elegí uno de los avatares predefinidos
          </p>
        </div>
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
    // Manejo de selección de avatar
    const avatarOptions = document.querySelectorAll('.avatar-option');
    const avatarNameInput = document.getElementById('avatarName');
    const avatarPreview = document.getElementById('avatar-img');
    const avatarForm = document.getElementById('avatar-form');
    const btnCambiarAvatar = document.getElementById('btn-cambiar-avatar');
    const btnCancelarAvatar = document.getElementById('btn-cancelar-avatar');
    const avatarSelector = document.getElementById('avatar-selector');
    
    // Configurar el avatar inicial si hay uno seleccionado
    const initialSelected = document.querySelector('.avatar-option.selected');
    if (initialSelected) {
      avatarNameInput.value = initialSelected.dataset.avatar;
    }
    
    // Mostrar selector de avatares
    btnCambiarAvatar.addEventListener('click', function() {
      avatarSelector.style.display = 'block';
      btnCambiarAvatar.style.display = 'none';
    });
    
    // Ocultar selector de avatares
    btnCancelarAvatar.addEventListener('click', function() {
      avatarSelector.style.display = 'none';
      btnCambiarAvatar.style.display = 'inline-block';
    });
    
    // Manejar clic en avatares
    avatarOptions.forEach(option => {
      option.addEventListener('click', function() {
        // Remover selección anterior
        avatarOptions.forEach(opt => opt.classList.remove('selected'));
        
        // Seleccionar nuevo avatar
        this.classList.add('selected');
        const selectedAvatar = this.dataset.avatar;
        avatarNameInput.value = selectedAvatar;
        
        // Actualizar preview
        avatarPreview.src = '${pageContext.request.contextPath}/avatars/' + selectedAvatar;
      });
    });
    
    // Validar antes de enviar
    avatarForm.addEventListener('submit', function(e) {
      if (!avatarNameInput.value) {
        e.preventDefault();
        alert('Por favor selecciona un avatar');
      }
    });
  </script>
</body>
</html>

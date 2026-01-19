<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
  private static String esc(String s){
    if (s == null) return "";
    return s.replace("&","&amp;").replace("<","&lt;").replace("\"","&quot;");
  }
%>
<%
  String lastUser = "";
  jakarta.servlet.http.Cookie[] cookies = request.getCookies();
  if (cookies != null) {
    for (jakarta.servlet.http.Cookie c : cookies) {
      if ("last_user".equals(c.getName())) { lastUser = c.getValue(); break; }
    }
  }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Misterio en la Mansión — Acceso</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&family=Overpass:wght@600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/login.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    /* Estilos para alternar entre formularios */
    .form-section { display: none; }
    .form-section.active { display: block; animation: floatIn .6s ease both; }
    
    /* Asegurar que ambos formularios tengan el mismo estilo */
    #register, #forgot {
      position: relative;
      padding: 36px 28px 28px;
      border-radius: var(--radius);
      background: var(--glass);
      border: 1px solid var(--edge);
      box-shadow: var(--shadow);
      backdrop-filter: blur(var(--blur)) saturate(120%);
      -webkit-backdrop-filter: blur(var(--blur)) saturate(120%);
      overflow: hidden;
    }
    #register::before, #forgot::before {
      content:"";
      position:absolute; inset:-2px; border-radius: calc(var(--radius) + 2px);
      background: conic-gradient(from 180deg,
        rgba(247,183,51,.0),
        rgba(247,183,51,.55),
        rgba(255,122,24,.45),
        rgba(247,183,51,.0)
      );
      filter: blur(12px); opacity:.32; pointer-events:none;
      animation: ring var(--ring-speed) linear infinite;
    }
    
    /* Botones del formulario de registro y recuperación iguales al login */
    #registerform button, #forgotform button {
      position: relative;
      width:100%; padding: 12px 14px; margin-top: 6px;
      border:0; border-radius: 12px; color:#0a0f18;
      font-weight: 900; letter-spacing:.4px; cursor:pointer;
      background: linear-gradient(180deg,
                  color-mix(in oklab, var(--accent), white 12%),
                  var(--accent2));
      box-shadow: 0 10px 25px rgba(247,183,51,.28), inset 0 0 0 1px rgba(255,255,255,.35);
      transition: transform .08s, box-shadow .18s, filter .18s;
    }
    #registerform button i, #forgotform button i { margin-right: 8px; }
    #registerform button:hover, #forgotform button:hover {
      box-shadow: 0 16px 38px rgba(247,183,51,.35),
                  inset 0 0 0 1px rgba(255,255,255,.55);
      filter: brightness(1.05); transform: translateY(-1px);
    }
    #registerform button:active, #forgotform button:active {
      transform: translateY(0);
      box-shadow: 0 8px 18px rgba(247,183,51,.25),
                  inset 0 0 0 1px rgba(0,0,0,.15);
    }
    #registerform button::after, #forgotform button::after {
      content:""; position:absolute; inset:0; border-radius:12px; pointer-events:none;
      background: linear-gradient(90deg, transparent, rgba(255,255,255,.28), transparent);
      mix-blend-mode: screen; opacity:0; animation: sweep 3s ease-in-out infinite;
    }
    
    .password-strength {
      margin-top: 4px;
      font-size: 0.85rem;
      color: var(--muted);
      display: none;
    }
    .password-strength.show { display: block; }
    .strength-bar {
      height: 4px;
      background: rgba(255,255,255,.1);
      border-radius: 2px;
      margin-top: 4px;
      overflow: hidden;
    }
    .strength-bar-fill {
      height: 100%;
      width: 0%;
      transition: width .3s, background .3s;
      border-radius: 2px;
    }
    .strength-weak { background: var(--danger); }
    .strength-medium { background: var(--accent2); }
    .strength-strong { background: #4caf50; }
  </style>
</head>
<body>
  <div id="scene" aria-hidden="true">
    <div class="moon"></div>
    <div class="fog layer1"></div>
    <div class="fog layer2"></div>
    <div class="fog layer3"></div>
    <div class="bats">
      <span class="bat b1"></span>
      <span class="bat b2"></span>
      <span class="bat b3"></span>
    </div>
    <div class="vignette"></div>
  </div>

  <!-- Contenido principal -->
  <div id="contenedor">
    <header class="brand">
      <div class="lantern" aria-hidden="true"></div>
      <h1 class="game-title">Misterio en la Mansión</h1>
      <p class="tagline">Entrá… si te animás a descubrir al culpable</p>
    </header>

    <main id="central" role="main">
      <!-- FORMULARIO DE LOGIN -->
      <section id="login" class="form-section active" aria-label="Formulario de acceso">
        <div class="titulo">Bienvenido</div>

        <% String error = (String) request.getAttribute("error"); if (error != null) { %>
          <div class="alerta"><%= esc(error) %></div>
        <% } %>

        <form id="loginform" action="signin" method="post">
          <div class="input-container">
            <i class="fas fa-user" aria-hidden="true"></i>
            <input type="text" name="username" placeholder="Usuario" value="<%= esc(lastUser.isEmpty()? "admin" : lastUser) %>" required>
          </div>
          <div class="input-container">
            <i class="fas fa-lock" aria-hidden="true"></i>
            <input type="password" name="password" placeholder="Contraseña" value="a" required autocomplete="current-password">
          </div>
          <button type="submit" title="Ingresar" name="Ingresar">
            <i class="fas fa-door-open" aria-hidden="true"></i> Entrar
          </button>
        </form>

        <div class="mini-links">
          <a href="#" onclick="mostrarRecuperar(); return false;">¿Olvidaste tu contraseña?</a>
          <span>•</span>
          <a href="#" onclick="mostrarRegistro(); return false;">Crear cuenta</a>
        </div>
      </section>

      <!-- FORMULARIO DE REGISTRO -->
      <section id="register" class="form-section" aria-label="Formulario de registro">
        <div class="titulo">Crear Cuenta</div>

        <% String errorReg = (String) request.getAttribute("errorRegistro"); if (errorReg != null) { %>
          <div class="alerta"><%= esc(errorReg) %></div>
        <% } %>

        <form id="registerform" action="register" method="post">
          <div class="input-container">
            <i class="fas fa-user" aria-hidden="true"></i>
            <input type="text" name="nombre" placeholder="Nombre de usuario" required minlength="3" maxlength="50">
          </div>
          
          <div class="input-container">
            <i class="fas fa-envelope" aria-hidden="true"></i>
            <input type="email" name="email" placeholder="Email" required>
          </div>
          
          <div class="input-container">
            <i class="fas fa-lock" aria-hidden="true"></i>
            <input type="password" id="regPassword" name="password" placeholder="Contraseña" required minlength="4" autocomplete="new-password">
            <div class="password-strength" id="strengthText"></div>
            <div class="strength-bar">
              <div class="strength-bar-fill" id="strengthBar"></div>
            </div>
          </div>
          
          <div class="input-container">
            <i class="fas fa-lock" aria-hidden="true"></i>
            <input type="password" name="confirmPassword" placeholder="Confirmar contraseña" required minlength="4" autocomplete="new-password">
          </div>
          
          <button type="submit" title="Crear cuenta">
            <i class="fas fa-user-plus" aria-hidden="true"></i> Crear Cuenta
          </button>
        </form>

        <div class="mini-links">
          <a href="#" onclick="mostrarLogin(); return false;">
            <i class="fas fa-arrow-left" aria-hidden="true"></i> Volver al inicio de sesión
          </a>
        </div>
      </section>

      <!-- FORMULARIO DE RECUPERAR CONTRASEÑA -->
      <section id="forgot" class="form-section" aria-label="Formulario de recuperación de contraseña">
        <div class="titulo">Recuperar Contraseña</div>

        <% String errorPassword = (String) request.getAttribute("errorPassword"); 
           String successPassword = (String) request.getAttribute("successPassword");
           String tempPassword = (String) request.getAttribute("tempPassword");
           String userEmail = (String) request.getAttribute("userEmail");
           
           if (errorPassword != null) { %>
          <div class="alerta"><%= esc(errorPassword) %></div>
        <% } 
           if (successPassword != null) { %>
          <div style="background: #0f2b12; color: #c9ffc9; border: 1px solid #2f7a3b; padding: 10px 12px; border-radius: 10px; margin: 0 0 12px 0;">
            <%= esc(successPassword) %>
          </div>
        <% } 
           if (tempPassword != null && userEmail != null) { %>
          <div style="background: #0f2b12; color: #c9ffc9; border: 1px solid #2f7a3b; padding: 14px 12px; border-radius: 10px; margin: 0 0 12px 0; text-align: center;">
            <p style="margin: 0 0 8px 0; font-weight: 700;">✅ Contraseña restablecida</p>
            <p style="margin: 0 0 4px 0;">Tu nueva contraseña temporal es:</p>
            <p style="margin: 8px 0; font-size: 1.4rem; font-weight: 900; letter-spacing: 2px; color: #4caf50;">
              <%= esc(tempPassword) %>
            </p>
            <p style="margin: 4px 0 0 0; font-size: 0.85rem; opacity: 0.8;">Usá esta contraseña para iniciar sesión</p>
          </div>
        <% } %>

        <form id="forgotform" action="forgot-password" method="post">
          <div class="input-container">
            <i class="fas fa-envelope" aria-hidden="true"></i>
            <input type="email" name="email" placeholder="Tu email" required>
          </div>
          
          <button type="submit" title="Recuperar contraseña">
            <i class="fas fa-key" aria-hidden="true"></i> Recuperar Contraseña
          </button>
        </form>

        <div class="mini-links">
          <a href="#" onclick="mostrarLogin(); return false;">
            <i class="fas fa-arrow-left" aria-hidden="true"></i> Volver al inicio de sesión
          </a>
        </div>
      </section>
    </main>
  </div>

  <script>
    // Alternar entre formularios
    function mostrarLogin() {
      document.getElementById('login').classList.add('active');
      document.getElementById('register').classList.remove('active');
      document.getElementById('forgot').classList.remove('active');
      document.querySelector('.tagline').textContent = 'Entrá… si te animás a descubrir al culpable';
    }
    
    function mostrarRegistro() {
      document.getElementById('login').classList.remove('active');
      document.getElementById('register').classList.add('active');
      document.getElementById('forgot').classList.remove('active');
      document.querySelector('.tagline').textContent = 'Unite a la aventura para resolver el misterio';
    }
    
    function mostrarRecuperar() {
      document.getElementById('login').classList.remove('active');
      document.getElementById('register').classList.remove('active');
      document.getElementById('forgot').classList.add('active');
      document.querySelector('.tagline').textContent = 'Recuperá el acceso a tu cuenta';
    }

    // Indicador de fortaleza de contraseña
    const passwordInput = document.getElementById('regPassword');
    const strengthText = document.getElementById('strengthText');
    const strengthBar = document.getElementById('strengthBar');

    if (passwordInput) {
      passwordInput.addEventListener('input', function() {
        const password = this.value;
        
        if (password.length === 0) {
          strengthText.classList.remove('show');
          strengthBar.style.width = '0%';
          return;
        }

        strengthText.classList.add('show');
        
        let strength = 0;
        if (password.length >= 4) strength++;
        if (password.length >= 8) strength++;
        if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
        if (/\d/.test(password)) strength++;
        if (/[^a-zA-Z0-9]/.test(password)) strength++;

        strengthBar.classList.remove('strength-weak', 'strength-medium', 'strength-strong');
        
        if (strength <= 2) {
          strengthBar.style.width = '33%';
          strengthBar.classList.add('strength-weak');
          strengthText.textContent = 'Contraseña débil';
        } else if (strength <= 3) {
          strengthBar.style.width = '66%';
          strengthBar.classList.add('strength-medium');
          strengthText.textContent = 'Contraseña media';
        } else {
          strengthBar.style.width = '100%';
          strengthBar.classList.add('strength-strong');
          strengthText.textContent = 'Contraseña fuerte';
        }
      });
    }

    // Si hay error de registro, mostrar formulario de registro
    <% if (errorReg != null) { %>
      mostrarRegistro();
    <% } %>
    
    // Si hay error/éxito de recuperación de contraseña, mostrar ese formulario
    <% if (errorPassword != null || successPassword != null || tempPassword != null) { %>
      mostrarRecuperar();
    <% } %>
  </script>
</body>
</html>

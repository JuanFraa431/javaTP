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
      <section id="login" aria-label="Formulario de acceso">
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
            <i class="fas fa-door-open" aria-hidden="true">Entrar</i> 
          </button>
        </form>

        <div class="mini-links">
          <a href="#" onclick="return false;">¿Olvidaste tu contraseña?</a>
          <span>•</span>
          <a href="#" onclick="return false;">Crear cuenta</a>
        </div>
      </section>
    </main>
  </div>
</body>
</html>

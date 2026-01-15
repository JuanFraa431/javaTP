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
</body>
</html>

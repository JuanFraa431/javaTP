<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,entities.Historia" %>
<%
  String ctx = request.getContextPath();
  List<Historia> historias = (List<Historia>) request.getAttribute("historias");
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Elegí una historia</title>
  <link rel="stylesheet" href="<%=ctx%>/style/home.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    .wrap { max-width:1100px; margin: 32px auto; }
    .grid { display:grid; grid-template-columns: repeat(auto-fill,minmax(280px,1fr)); gap:16px; }
    .card { position:relative; padding:16px; border-radius:14px;
            background:rgba(255,255,255,.03); border:1px solid rgba(255,255,255,.1);
            box-shadow:0 10px 28px rgba(0,0,0,.35); color:#e9eef8; }
    .card h3{ margin:0 0 6px; font-weight:800; }
    .card p{ margin:0 0 12px; color:#b9c6da; min-height:46px; }
    .lock { position:absolute; inset:0; display:flex; align-items:center; justify-content:center;
            background:rgba(0,0,0,.45); backdrop-filter: blur(2px); border-radius:14px;
            color:#ffdede; font-weight:900; letter-spacing:.3px; }
    .btn { padding:10px 14px; border:0; border-radius:10px; cursor:pointer; font-weight:900; }
    .btn-primary { background:linear-gradient(180deg,#f7b733,#ff7a18); color:#0a0f18; }
    .btn-ghost { background:transparent; border:1px dashed rgba(255,255,255,.25); color:#e9eef8; }
  </style>
</head>
<body>
  <div class="wrap">
    <h1>Elegí una historia</h1>

    <div class="grid">
      <% for (Historia h : historias) { %>
        <div class="card">
          <h3><%= h.getTitulo() %></h3>
          <p><%= (h.getDescripcion()!=null? h.getDescripcion() : "") %></p>

          <% if (h.isActiva()) { %>
            <form action="<%=ctx%>/jugador/partidas/crear" method="post">
              <input type="hidden" name="historiaId" value="<%=h.getId()%>">
              <button class="btn btn-primary" type="submit"><i class="fa-solid fa-play"></i> Jugar</button>
            </form>
          <% } else { %>
            <button class="btn btn-ghost" type="button" disabled><i class="fa-solid fa-lock"></i> Bloqueada</button>
            <div class="lock"><i class="fa-solid fa-lock"></i>&nbsp; Historia inactiva</div>
          <% } %>
        </div>
      <% } %>
    </div>

    <p style="margin-top:18px;">
      <a class="btn btn-ghost" href="<%=ctx%>/jugador/home">Volver</a>
    </p>
  </div>
</body>
</html>

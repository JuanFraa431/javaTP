<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,entities.Usuario" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Usuarios — Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/admin-usuarios-list.css">
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&family=Overpass:wght@600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="page">

  <header>
    <h1>Usuarios</h1>
    <p class="subtitle">Administrá altas, ediciones y bajas lógicas</p>
  </header>

  <!-- flash -->
  <%
    String ok = (String) session.getAttribute("flash_ok");
    String err = (String) session.getAttribute("flash_error");
    if (ok != null) { %><div class="flash ok"><i class="fa-solid fa-circle-check"></i> <%= ok %></div><% session.removeAttribute("flash_ok"); }
    if (err != null){ %><div class="flash error"><i class="fa-solid fa-triangle-exclamation"></i> <%= err %></div><% session.removeAttribute("flash_error"); }
    String q = (String) request.getAttribute("q");
    if (q == null) q = request.getParameter("q");
    if (q == null) q = "";
  %>

  <!-- acciones -->
  <div class="actions">
    <div class="left">
      <form class="search" method="get" action="${pageContext.request.contextPath}/admin/usuarios">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text" name="q" placeholder="Buscar por nombre o email…" value="<%= q %>">
      </form>
    </div>
    <div class="right">
      <a class="btn" href="${pageContext.request.contextPath}/admin/usuarios/form">
        <i class="fa-solid fa-user-plus"></i> Nuevo usuario
      </a>
      <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/dashboard">
        <i class="fa-solid fa-grid-2"></i> Dashboard
      </a>
    </div>
  </div>

  <!-- tabla -->
  <div class="table-wrap">
    <table>
      <thead>
        <tr>
          <th style="width:72px">ID</th>
          <th>Nombre</th>
          <th>Email</th>
          <th style="width:140px">Rol</th>
          <th style="width:160px">Estado</th>
          <th style="width:260px" class="th-actions">Acciones</th>
        </tr>
      </thead>
      <tbody>
      <%
        List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
        if (usuarios == null || usuarios.isEmpty()) {
      %>
        <tr><td colspan="6">No hay usuarios.</td></tr>
      <%
        } else {
          for (Usuario u : usuarios) {
            boolean activo = u.isActivo();
            String rol = u.getRol() == null ? "" : u.getRol();
            String rolClass = rol.equalsIgnoreCase("ADMIN") ? "admin" : "jugador";
            String toggleAction = activo ? (request.getContextPath()+"/admin/usuarios/delete")
                                         : (request.getContextPath()+"/admin/usuarios/reactivar");
            String toggleLabel  = activo ? "Desactivar" : "Activar";
            String toggleIcon   = activo ? "fa-user-slash" : "fa-user-check";
            String toggleBtnCls = activo ? "btn-danger" : "btn-success";
      %>
        <tr>
          <td data-label="ID"><%= u.getId() %></td>
          <td data-label="Nombre"><%= u.getNombre() %></td>
          <td data-label="Email"><%= u.getEmail() %></td>
          <td data-label="Rol">
            <span class="chip <%= rolClass %>">
              <i class="fa-solid <%= rol.equalsIgnoreCase("ADMIN") ? "fa-user-shield" : "fa-user" %>"></i>
              <%= rol %>
            </span>
          </td>
          <td data-label="Estado">
            <span class="chip <%= activo ? "activo" : "inactivo" %>">
              <i class="fa-solid <%= activo ? "fa-circle-check" : "fa-ban" %>"></i>
              <%= activo ? "Activo" : "Desactivado" %>
            </span>
          </td>
          <td data-label="Acciones" class="td-actions">
            <div class="row-actions">
              <a class="btn btn-ghost" href="<%=request.getContextPath()%>/admin/usuarios/form?id=<%=u.getId()%>">
                <i class="fa-solid fa-pen-to-square"></i> Editar
              </a>
              <form class="form-inline" method="post" action="<%= toggleAction %>"
                    onsubmit="return confirm('<%= activo? "¿Desactivar este usuario?" : "¿Activar este usuario?" %>');">
                <input type="hidden" name="id" value="<%=u.getId()%>">
                <button type="submit" class="btn <%= toggleBtnCls %>">
                  <i class="fa-solid <%= toggleIcon %>"></i> <%= toggleLabel %>
                </button>
              </form>
            </div>
          </td>
        </tr>
      <%
          }
        }
      %>
      </tbody>
    </table>
  </div>

  <!-- paginación de ejemplo -->
   <div class="pager">
	  <div class="center">
	    <nav class="pagination" aria-label="Paginación">
	      <a class="page" href="#" aria-label="Anterior">«</a>
	      <a class="page is-active" href="#">1</a>
	      <a class="page" href="#">2</a>
	      <a class="page" href="#" aria-label="Siguiente">»</a>
	    </nav>
	  </div>
	</div>


</div>
</body>
</html>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,entities.Historia" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Historias — Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/admin-usuarios-list.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="page">
  <h1>Historias</h1>
  <p class="subtitle">ABMC de historias (alta, baja lógica, modificación y consulta)</p>

  <%
    String ok = (String) session.getAttribute("flash_ok");
    String err = (String) session.getAttribute("flash_error");
    if (ok != null) { out.println("<div class='flash ok'>"+ok+"</div>"); session.removeAttribute("flash_ok"); }
    if (err != null){ out.println("<div class='flash error'>"+err+"</div>"); session.removeAttribute("flash_error"); }
  %>

  <div class="actions">
    <div class="left">
      <a class="btn" href="${pageContext.request.contextPath}/admin/historias/form">
        <i class="fa-solid fa-plus"></i> Nueva Historia
      </a>
    </div>
    <div class="right">
      <a class="btn btn-ghost" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
    </div>
  </div>

  <div class="table-wrap">
    <table>
      <thead>
      <tr>
        <th>ID</th>
        <th>Título</th>
        <th>Dificultad</th>
        <th>Tiempo</th>
        <th>Estado</th>
        <th class="th-actions">Acciones</th>
      </tr>
      </thead>
      <tbody>
      <%
        List<Historia> list = (List<Historia>) request.getAttribute("historias");
        if (list == null || list.isEmpty()) {
      %>
        <tr><td colspan="6">No hay historias.</td></tr>
      <%
        } else {
          for (Historia h : list) {
      %>
        <tr>
          <td><%=h.getId()%></td>
          <td><strong><%=h.getTitulo()%></strong></td>
          <td><%=h.getDificultad()%>/5</td>
          <td><%=h.getTiempoEstimado()%> min</td>
          <td>
            <span class="chip <%= h.isActiva() ? "activo" : "inactivo" %>">
              <i class="fa-solid fa-circle"></i>
              <%= h.isActiva() ? "Activa" : "Inactiva" %>
            </span>
          </td>
          <td class="td-actions">
            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/admin/historias/form?id=<%=h.getId()%>">
              <i class="fa-solid fa-pen-to-square"></i> Editar
            </a>
            <%
              if (h.isActiva()) {
            %>
            <form class="form-inline" action="${pageContext.request.contextPath}/admin/historias/delete" method="post"
                  onsubmit="return confirm('¿Desactivar esta historia?');">
              <input type="hidden" name="id" value="<%=h.getId()%>">
              <button class="btn btn-danger"><i class="fa-solid fa-ban"></i> Desactivar</button>
            </form>
            <%
              } else {
            %>
            <form class="form-inline" action="${pageContext.request.contextPath}/admin/historias/reactivar" method="post">
              <input type="hidden" name="id" value="<%=h.getId()%>">
              <button class="btn btn-success"><i class="fa-solid fa-rotate-right"></i> Reactivar</button>
            </form>
            <%
              }
            %>
          </td>
        </tr>
      <%
          }
        }
      %>
      </tbody>
    </table>
  </div>
</div>
</body>
</html>

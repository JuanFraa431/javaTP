<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="entities.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Documentos — Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/admin-usuarios-list.css">
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&family=Overpass:wght@600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="page">

  <header>
    <h1>Documentos</h1>
    <p class="subtitle">Administrá documentos, códigos y pistas del juego</p>
  </header>

  <!-- flash -->
  <%
    @SuppressWarnings("unchecked")
    List<Documento> documentos = (List<Documento>) request.getAttribute("documentos");
    @SuppressWarnings("unchecked")
    List<Historia> historias = (List<Historia>) request.getAttribute("historias");
    @SuppressWarnings("unchecked")
    Map<Integer, String> historiasMap = (Map<Integer, String>) request.getAttribute("historiasMap");
    String search = (String) request.getAttribute("search");
    String historiaSelected = (String) request.getAttribute("historiaSelected");
    
    String ok = (String) session.getAttribute("flash_ok");
    String err = (String) session.getAttribute("flash_error");
    if (ok != null) { %><div class="flash ok"><i class="fa-solid fa-circle-check"></i> <%= ok %></div><% session.removeAttribute("flash_ok"); }
    if (err != null){ %><div class="flash error"><i class="fa-solid fa-triangle-exclamation"></i> <%= err %></div><% session.removeAttribute("flash_error"); }
    if (search == null) search = "";
  %>

  <div class="actions">
    <div class="left">
      <form class="search" method="get" action="${pageContext.request.contextPath}/admin/documentos">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text" name="search" placeholder="Buscar por nombre…" value="<%= search %>">
      </form>
    </div>
    <div class="right">
      <a class="btn" href="${pageContext.request.contextPath}/admin/documentos/form">
        <i class="fa-solid fa-file-lines"></i> Nuevo documento
      </a>
      <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/dashboard">
        <i class="fa-solid fa-grid-2"></i> Dashboard
      </a>
    </div>
  </div>

  <div class="table-wrap">
    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>Clave</th>
          <th>Nombre</th>
          <th>Historia</th>
          <th>Icono</th>
          <th>Código</th>
          <th class="actions-col">Acciones</th>
        </tr>
      </thead>
      <tbody>
        <%
          if (documentos == null || documentos.isEmpty()) {
        %>
        <tr>
          <td colspan="7" style="text-align:center; color:#999;">No hay documentos</td>
        </tr>
        <%
          } else {
            for (Documento d : documentos) {
              String historiaTitulo = historiasMap.get(d.getHistoriaId());
              boolean tieneCodigo = d.getCodigoCorrecto() != null && !d.getCodigoCorrecto().isEmpty();
        %>
        <tr>
          <td><%= d.getId() %></td>
          <td><code style="background:rgba(59,130,246,0.1);color:#60a5fa;padding:4px 8px;border-radius:4px;font-size:12px;border:1px solid rgba(59,130,246,0.2);"><%= d.getClave() %></code></td>
          <td><strong><%= d.getNombre() %></strong></td>
          <td><%= historiaTitulo != null ? historiaTitulo : "Historia #" + d.getHistoriaId() %></td>
          <td><i class="<%= d.getIcono() %>" style="font-size: 18px; color: #3b82f6;"></i></td>
          <td><%= tieneCodigo ? "🔑 " + d.getCodigoCorrecto() : "-" %></td>
          <td class="actions-col">
            <a class="icon-btn" href="${pageContext.request.contextPath}/admin/documentos/form?id=<%= d.getId() %>" title="Editar">
              <i class="fa-solid fa-pen-to-square"></i>
            </a>
            <form method="post" action="${pageContext.request.contextPath}/admin/documentos/delete" style="display:inline;" 
                  onsubmit="return confirm('¿Eliminar este documento?');">
              <input type="hidden" name="id" value="<%= d.getId() %>">
              <button type="submit" class="icon-btn danger" title="Eliminar">
                <i class="fa-solid fa-trash-can"></i>
              </button>
            </form>
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

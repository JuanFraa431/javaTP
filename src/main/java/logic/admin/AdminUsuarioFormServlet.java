package logic.admin;

import entities.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import logic.CtrlUsuario;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/usuarios/form")
public class AdminUsuarioFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr = req.getParameter("id"); // ?id=xx
        if (idStr != null && !idStr.isBlank()) {
            try {
                int id = Integer.parseInt(idStr);
                Usuario u = new CtrlUsuario().getUserById(id);
                if (u != null) {
                    req.setAttribute("usuario", u);
                } else {
                    req.setAttribute("error", "Usuario no encontrado");
                }
            } catch (NumberFormatException | SQLException e) {
                req.setAttribute("error", "Error al cargar usuario: " + e.getMessage());
            }
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/usuarios/form.jsp")
           .forward(req, resp);
    }
}

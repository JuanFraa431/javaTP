package logic.admin;

import data.UsuarioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/usuarios/reactivar")
public class AdminUsuarioReactivateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UsuarioDAO dao = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Seguridad adicional por rol
        HttpSession s = req.getSession(false);
        String rol = (s != null) ? (String) s.getAttribute("rol") : null;
        if (rol == null || !rol.equalsIgnoreCase("ADMIN")) {
            resp.sendRedirect(req.getContextPath() + "/jugador/home");
            return;
        }

        String idStr = req.getParameter("id");
        try {
            int id = Integer.parseInt(idStr);
            boolean ok = dao.reactivar(id);
            if (ok) {
                req.getSession().setAttribute("flash_ok", "Usuario reactivado.");
            } else {
                req.getSession().setAttribute("flash_error", "No se pudo reactivar el usuario.");
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("flash_error", "ID inválido.");
        } catch (SQLException e) {
            e.printStackTrace();
            req.getSession().setAttribute("flash_error", "Error al reactivar el usuario.");
        }

        // Volver al listado
        resp.sendRedirect(req.getContextPath() + "/admin/usuarios");
    }
}

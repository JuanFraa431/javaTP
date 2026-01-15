package logic.admin;

import data.UsuarioDAO;
import entities.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/usuarios")
public class AdminUsuariosServlet extends HttpServlet {

    private final UsuarioDAO dao = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        String rol = (s != null) ? (String) s.getAttribute("rol") : null;
        if (rol == null || !rol.equalsIgnoreCase("ADMIN")) {
            resp.sendRedirect(req.getContextPath() + "/jugador/home");
            return;
        }

        String q = req.getParameter("q");
        List<Usuario> usuarios;
        try {
            if (q != null && !q.trim().isEmpty()) {
                req.setAttribute("q", q.trim());
                usuarios = dao.search(q.trim(), true);
            } else {
                usuarios = dao.getAll(false);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.getSession().setAttribute("flash_error", "No se pudo cargar el listado de usuarios.");
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        req.setAttribute("usuarios", usuarios);
        req.getRequestDispatcher("/WEB-INF/views/admin/usuarios/list.jsp").forward(req, resp);
    }
}

package logic.admin;

import data.HistoriaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/historias/delete")
public class AdminHistoriasDeleteServlet extends HttpServlet {
    private final HistoriaDAO dao = new HistoriaDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        String rol = (s != null) ? (String) s.getAttribute("rol") : null;
        if (rol == null || !rol.equalsIgnoreCase("ADMIN")) {
            resp.sendRedirect(req.getContextPath() + "/jugador/home");
            return;
        }

        try {
            int id = Integer.parseInt(req.getParameter("id"));
            dao.softDelete(id);
            s.setAttribute("flash_ok", "Historia desactivada.");
        } catch (Exception e) {
            s.setAttribute("flash_error", "No se pudo desactivar.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/historias");
    }
}

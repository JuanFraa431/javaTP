package logic.admin;

import data.HistoriaDAO;
import entities.Historia;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/historias/form")
public class AdminHistoriasFormServlet extends HttpServlet {
    private final HistoriaDAO dao = new HistoriaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        String rol = (s != null) ? (String) s.getAttribute("rol") : null;
        if (rol == null || !rol.equalsIgnoreCase("ADMIN")) {
            resp.sendRedirect(req.getContextPath() + "/jugador/home");
            return;
        }

        String idStr = req.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                Historia h = dao.findById(id);
                req.setAttribute("historia", h);
            } catch (Exception ignored) {}
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/historias/form.jsp").forward(req, resp);
    }
}

package logic.admin;

import data.HistoriaDAO;
import entities.Historia;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/historias")
public class AdminHistoriasListServlet extends HttpServlet {
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

        // parámetro opcional: ?soloActivas=true/false
        Boolean soloActivas = null;
        String p = req.getParameter("soloActivas");
        if ("true".equalsIgnoreCase(p)) soloActivas = true;
        if ("false".equalsIgnoreCase(p)) soloActivas = false;

        try {
            List<Historia> historias = dao.getAll(soloActivas);
            req.setAttribute("historias", historias);
            req.getRequestDispatcher("/WEB-INF/views/admin/historias/list.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            req.getSession().setAttribute("flash_error", "No se pudo cargar Historias.");
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }
}

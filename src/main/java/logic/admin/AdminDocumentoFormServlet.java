package logic.admin;

import data.DocumentoDAO;
import data.HistoriaDAO;
import entities.Documento;
import entities.Historia;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/documentos/form")
public class AdminDocumentoFormServlet extends HttpServlet {
    private final DocumentoDAO documentoDAO = new DocumentoDAO();
    private final HistoriaDAO historiaDAO = new HistoriaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        Documento documento = null;

        try {
            // Si hay ID, es edición
            if (idParam != null && !idParam.isEmpty()) {
                int id = Integer.parseInt(idParam);
                documento = documentoDAO.findById(id);
                if (documento == null) {
                    req.getSession().setAttribute("flash_error", "Documento no encontrado");
                    resp.sendRedirect(req.getContextPath() + "/admin/documentos");
                    return;
                }
            }

            // Cargar todas las historias para el selector
            List<Historia> historias = historiaDAO.getAll(null);

            req.setAttribute("documento", documento);
            req.setAttribute("historias", historias);
            req.setAttribute("esEdicion", documento != null);

            req.getRequestDispatcher("/WEB-INF/views/admin/documentos/form.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}

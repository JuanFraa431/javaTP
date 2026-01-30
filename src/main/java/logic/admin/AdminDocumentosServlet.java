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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/documentos")
public class AdminDocumentosServlet extends HttpServlet {
    private final DocumentoDAO documentoDAO = new DocumentoDAO();
    private final HistoriaDAO historiaDAO = new HistoriaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String search = req.getParameter("search");
        String historiaIdParam = req.getParameter("historia");

        try {
            List<Documento> documentos;
            
            if (historiaIdParam != null && !historiaIdParam.isEmpty()) {
                // Filtrar por historia específica
                int historiaId = Integer.parseInt(historiaIdParam);
                documentos = documentoDAO.findByHistoriaId(historiaId);
            } else {
                // Obtener todos los documentos
                documentos = documentoDAO.findAll();
            }

            // Filtrar por búsqueda si existe
            if (search != null && !search.trim().isEmpty()) {
                String searchLower = search.toLowerCase();
                List<Documento> filtered = new ArrayList<>();
                for (Documento d : documentos) {
                    if (d.getNombre().toLowerCase().contains(searchLower) ||
                        d.getClave().toLowerCase().contains(searchLower)) {
                        filtered.add(d);
                    }
                }
                documentos = filtered;
            }

            // Cargar todas las historias para el filtro
            List<Historia> historias = historiaDAO.getAll(null);
            
            // Crear mapa de historias para mostrar títulos
            Map<Integer, String> historiasMap = new HashMap<>();
            for (Historia h : historias) {
                historiasMap.put(h.getId(), h.getTitulo());
            }

            req.setAttribute("documentos", documentos);
            req.setAttribute("historias", historias);
            req.setAttribute("historiasMap", historiasMap);
            req.setAttribute("search", search);
            req.setAttribute("historiaSelected", historiaIdParam);

            req.getRequestDispatcher("/WEB-INF/views/admin/documentos/list.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}

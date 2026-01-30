package logic.admin;

import data.DocumentoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/documentos/delete")
public class AdminDocumentoDeleteServlet extends HttpServlet {
    private final DocumentoDAO documentoDAO = new DocumentoDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        String idParam = req.getParameter("id");

        if (idParam == null || idParam.isEmpty()) {
            session.setAttribute("flash_error", "ID de documento no especificado");
            resp.sendRedirect(req.getContextPath() + "/admin/documentos");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            boolean eliminado = documentoDAO.delete(id);

            if (eliminado) {
                session.setAttribute("flash_success", "Documento eliminado correctamente");
            } else {
                session.setAttribute("flash_error", "No se pudo eliminar el documento");
            }

        } catch (SQLException e) {
            session.setAttribute("flash_error", "Error al eliminar: " + e.getMessage());
        } catch (NumberFormatException e) {
            session.setAttribute("flash_error", "ID inválido");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/documentos");
    }
}

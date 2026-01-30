package logic.admin;

import data.DocumentoDAO;
import entities.Documento;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/documentos/save")
public class AdminDocumentoSaveServlet extends HttpServlet {
    private final DocumentoDAO documentoDAO = new DocumentoDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        try {
            String idParam = req.getParameter("id");
            int historiaId = Integer.parseInt(req.getParameter("historia_id"));
            String clave = req.getParameter("clave").trim();
            String nombre = req.getParameter("nombre").trim();
            String icono = req.getParameter("icono").trim();
            String contenido = req.getParameter("contenido");
            String codigoCorrecto = req.getParameter("codigo_correcto");
            String pistaNombre = req.getParameter("pista_nombre");

            // Limpiar valores vacíos
            if (codigoCorrecto != null && codigoCorrecto.trim().isEmpty()) {
                codigoCorrecto = null;
            }
            if (pistaNombre != null && pistaNombre.trim().isEmpty()) {
                pistaNombre = null;
            }

            Documento documento = new Documento();
            documento.setHistoriaId(historiaId);
            documento.setClave(clave);
            documento.setNombre(nombre);
            documento.setIcono(icono);
            documento.setContenido(contenido);
            documento.setCodigoCorrecto(codigoCorrecto);
            documento.setPistaNombre(pistaNombre);

            if (idParam != null && !idParam.isEmpty()) {
                // Edición
                int id = Integer.parseInt(idParam);
                documento.setId(id);
                documentoDAO.update(documento);
                session.setAttribute("flash_success", "Documento actualizado correctamente");
            } else {
                // Alta
                documentoDAO.insert(documento);
                session.setAttribute("flash_success", "Documento creado correctamente");
            }

            resp.sendRedirect(req.getContextPath() + "/admin/documentos");

        } catch (SQLException e) {
            session.setAttribute("flash_error", "Error al guardar: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/documentos/form");
        } catch (NumberFormatException e) {
            session.setAttribute("flash_error", "Datos inválidos");
            resp.sendRedirect(req.getContextPath() + "/admin/documentos/form");
        }
    }
}

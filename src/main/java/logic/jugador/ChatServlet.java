package logic.jugador;

import data.DocumentoDAO;
import data.PartidaDAO;
import data.ProgresoPistaDAO;
import entities.Documento;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/jugador/partidas/chat")
public class ChatServlet extends HttpServlet {

    private final ProgresoPistaDAO progDAO = new ProgresoPistaDAO();
    private final DocumentoDAO documentoDAO = new DocumentoDAO();
    private final PartidaDAO partidaDAO = new PartidaDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("partidaId") == null) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        int partidaId = (int) s.getAttribute("partidaId");
        int historiaId = (int) s.getAttribute("historiaId");

        String action = safe(req.getParameter("action"));
        resp.setContentType("application/json; charset=UTF-8");
        try (PrintWriter out = resp.getWriter()) {
            if ("validate_code".equals(action)) {
                String code = safe(req.getParameter("code"));
                try {
                    // Buscar documento con el código correcto para esta historia
                    Documento doc = documentoDAO.validarCodigo(historiaId, code);
                    
                    if (doc != null) {
                        // Código correcto - Actualizar partida completa
                        
                        // 1. Registrar la pista
                        Integer pistaId = progDAO.findPistaIdByNombre(historiaId, doc.getPistaNombre());
                        boolean persisted = false;
                        if (pistaId != null) {
                            persisted = progDAO.registrarPista(partidaId, pistaId);
                        }
                        
                        // 2. Actualizar solución propuesta
                        String solucion = "Código descifrado: " + code;
                        partidaDAO.actualizarSolucionPropuesta(partidaId, solucion);
                        
                        // 3. Marcar como ganada con puntuación de 100
                        partidaDAO.marcarGanada(partidaId, 100);
                        
                        out.printf("{\"ok\":true,\"message\":\"¡Excelente! Registré la pista '%s'.\",\"persisted\":%s}",
                                doc.getPistaNombre(), persisted ? "true" : "false");
                    } else {
                        // Código incorrecto
                        out.print("{\"ok\":false,\"message\":\"Mmm… ese código no es. Volvamos al inicio del chat.\"}");
                    }
                } catch (SQLException ex) {
                    ex.printStackTrace();
                    out.print("{\"ok\":false,\"message\":\"Error al validar el código.\",\"persisted\":false}");
                }
            } else {
                out.print("{\"ok\":false,\"message\":\"Acción no reconocida.\"}");
            }
        }
    }

    private static String safe(String s){ return s==null? "": s.trim(); }
}

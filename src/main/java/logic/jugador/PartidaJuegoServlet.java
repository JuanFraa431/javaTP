package logic.jugador;

import data.DocumentoDAO;
import data.HistoriaDAO;
import data.PartidaDAO;
import entities.Documento;
import entities.Historia;
import entities.Partida;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/jugador/partidas/juego")
public class PartidaJuegoServlet extends HttpServlet {
    private final PartidaDAO partidaDAO = new PartidaDAO();
    private final HistoriaDAO historiaDAO = new HistoriaDAO();
    private final DocumentoDAO documentoDAO = new DocumentoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        Integer userId = (Integer) (s != null ? s.getAttribute("userId") : null);
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String pidStr = req.getParameter("pid");
        if (pidStr == null || pidStr.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/jugador/partidas/nueva");
            return;
        }

        try {
            int partidaId = Integer.parseInt(pidStr);
            Partida partida = partidaDAO.findById(partidaId);

            if (partida == null || partida.getUsuarioId() != userId) {
                s.setAttribute("flash_error", "Partida no encontrada");
                resp.sendRedirect(req.getContextPath() + "/jugador/partidas/nueva");
                return;
            }

            // Verificar que esté EN_PROGRESO
            if (!"EN_PROGRESO".equals(partida.getEstado())) {
                s.setAttribute("flash_error", "Esta partida ya finalizó");
                resp.sendRedirect(req.getContextPath() + "/jugador/partidas/nueva");
                return;
            }

            // Cargar la historia
            Historia historia = historiaDAO.findById(partida.getHistoriaId());
            if (historia == null) {
                s.setAttribute("flash_error", "Historia no encontrada");
                resp.sendRedirect(req.getContextPath() + "/jugador/partidas/nueva");
                return;
            }

            // Cargar documentos de la historia
            List<Documento> documentos = documentoDAO.findByHistoriaId(historia.getId());
            
            // Guardar en sesión y atributos
            s.setAttribute("partidaId", partidaId);
            s.setAttribute("historiaId", historia.getId());
            req.setAttribute("partida", partida);
            req.setAttribute("historia", historia);
            req.setAttribute("documentos", documentos);

            req.getRequestDispatcher("/WEB-INF/views/jugador/partida/juego.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/jugador/partidas/nueva");
        }
    }
}

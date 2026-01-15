package logic.jugador;

import data.HistoriaDAO;
import data.PartidaDAO;
import data.UsuarioDAO;
import entities.Partida;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

@WebServlet("/jugador/partidas/iniciar")
public class IniciarPartidaServlet extends HttpServlet {
    private final PartidaDAO partidaDAO = new PartidaDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final HistoriaDAO historiaDAO = new HistoriaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        Integer userId = (Integer) (s != null ? s.getAttribute("userId") : null);
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String historiaIdStr = req.getParameter("historiaId");
        if (historiaIdStr == null || historiaIdStr.isBlank()) {
            s.setAttribute("flash_error", "Falta historiaId");
            resp.sendRedirect(req.getContextPath() + "/jugador/partidas/nueva");
            return;
        }

        int historiaId;
        try {
            historiaId = Integer.parseInt(historiaIdStr);
        } catch (NumberFormatException ex) {
            s.setAttribute("flash_error", "historiaId inválido");
            resp.sendRedirect(req.getContextPath() + "/jugador/partidas/nueva");
            return;
        }

        try {
            // Verificar si ya tiene una partida activa
            Optional<Partida> activa = partidaDAO.findActivaByUsuario(userId);
            if (activa.isPresent()) {
                s.setAttribute("flash_error", "Ya tenés una partida en curso. Finalizá la actual antes de iniciar una nueva.");
                resp.sendRedirect(req.getContextPath() + "/jugador/partidas/juego?pid=" + activa.get().getId());
                return;
            }

            // Verificar que la historia esté activa
            if (!historiaDAO.esActiva(historiaId)) {
                s.setAttribute("flash_error", "La historia seleccionada no está disponible.");
                resp.sendRedirect(req.getContextPath() + "/jugador/partidas/nueva");
                return;
            }

            // Crear la partida
            int partidaId = partidaDAO.crearPartida(userId, historiaId);
            if (partidaId <= 0) {
                s.setAttribute("flash_error", "No se pudo crear la partida.");
                resp.sendRedirect(req.getContextPath() + "/jugador/partidas/nueva");
                return;
            }

            // Marcar usuario en partida
            usuarioDAO.setEnPartida(userId, true);
            
            // Guardar el ID de la partida en la sesión
            s.setAttribute("partidaId", partidaId);
            s.setAttribute("historiaId", historiaId);

            // Redirigir al juego
            resp.sendRedirect(req.getContextPath() + "/jugador/partidas/juego?pid=" + partidaId);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}

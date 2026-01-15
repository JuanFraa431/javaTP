package logic.jugador;

import data.PartidaDAO;
import data.UsuarioDAO;
import entities.Partida;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/jugador/partidas/finalizar")
public class FinalizarPartidaServlet extends HttpServlet {
    private final PartidaDAO partidaDAO = new PartidaDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        Integer userId = (Integer) (s != null ? s.getAttribute("userId") : null);
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String pidStr = req.getParameter("pid");
        if (pidStr == null) {
            resp.sendError(400, "Falta pid");
            return;
        }

        int pid;
        try {
            pid = Integer.parseInt(pidStr);
        } catch (NumberFormatException ex) {
            resp.sendError(400, "pid inválido");
            return;
        }

        try {
            Partida partida = partidaDAO.findById(pid);
            if (partida == null || partida.getUsuarioId() != userId) {
                resp.sendError(404, "Partida no encontrada");
                return;
            }

            // Permitir finalizar si está EN_PROGRESO o ya GANADA
            String estado = partida.getEstado();
            if (!"EN_PROGRESO".equals(estado) && !"GANADA".equals(estado)) {
                s.setAttribute("flash_error", "Esta partida ya finalizó");
                resp.sendRedirect(req.getContextPath() + "/jugador/partidas/nueva");
                return;
            }

            // Finalizar la partida (se convertirá a GANADA internamente)
            partidaDAO.finalizar(pid, "GANADA");
            
            // Liberar al usuario
            usuarioDAO.setEnPartida(userId, false);

            // Limpiar sesión
            s.removeAttribute("partidaId");
            s.removeAttribute("historiaId");

            s.setAttribute("flash_success", "Partida finalizada correctamente");
            resp.sendRedirect(req.getContextPath() + "/jugador/partidas/nueva");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}

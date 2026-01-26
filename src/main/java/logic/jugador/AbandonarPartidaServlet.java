package logic.jugador;

import data.PartidaDAO;
import data.UsuarioDAO;
import entities.Partida;
import entities.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

/**
 * Servlet para abandonar una partida en progreso
 */
public class AbandonarPartidaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String partidaIdParam = req.getParameter("partidaId");

        if (partidaIdParam == null || partidaIdParam.isEmpty()) {
            session.setAttribute("error", "ID de partida no proporcionado");
            resp.sendRedirect(req.getContextPath() + "/jugador/partidas");
            return;
        }

        try {
            int partidaId = Integer.parseInt(partidaIdParam);
            PartidaDAO partidaDAO = new PartidaDAO();
            
            // Obtener la partida
            Partida partida = partidaDAO.findById(partidaId);
            
            if (partida == null) {
                session.setAttribute("error", "Partida no encontrada");
                resp.sendRedirect(req.getContextPath() + "/jugador/partidas");
                return;
            }
            
            // Verificar que la partida pertenece al usuario
            if (partida.getUsuarioId() != usuario.getId()) {
                session.setAttribute("error", "No tenés permiso para abandonar esta partida");
                resp.sendRedirect(req.getContextPath() + "/jugador/partidas");
                return;
            }
            
            // Verificar que esté en progreso
            if (!"EN_PROGRESO".equals(partida.getEstado())) {
                session.setAttribute("error", "Solo se pueden abandonar partidas en progreso");
                resp.sendRedirect(req.getContextPath() + "/jugador/partidas");
                return;
            }
            
            // Abandonar la partida
            boolean abandonada = partidaDAO.abandonarPartida(partidaId);
            
            if (abandonada) {
                // Actualizar estado del usuario (en_partida = 0)
                UsuarioDAO usuarioDAO = new UsuarioDAO();
                usuarioDAO.setEnPartida(usuario.getId(), false);
                
                session.setAttribute("success", "Partida abandonada exitosamente");
            } else {
                session.setAttribute("error", "Error al abandonar la partida");
            }
            
            resp.sendRedirect(req.getContextPath() + "/jugador/partidas");
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID de partida inválido");
            resp.sendRedirect(req.getContextPath() + "/jugador/partidas");
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Error de base de datos: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/jugador/partidas");
        }
    }
}

package logic.jugador;

import data.PartidaDAO;
import data.UsuarioDAO;
import entities.Partida;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

@WebServlet("/jugador/partidas/continuar")
public class ContinuarPartidaServlet extends HttpServlet {
  private final PartidaDAO partidaDAO = new PartidaDAO();
  private final UsuarioDAO usuarioDAO = new UsuarioDAO();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    HttpSession s = req.getSession(false);
    Integer userId = (Integer) (s != null ? s.getAttribute("userId") : null);
    if (userId == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

    try {
      Optional<Partida> activa = partidaDAO.findActivaByUsuario(userId);
      if (activa.isPresent()) {
        resp.sendRedirect(req.getContextPath() + "/jugador/partidas/juego?pid=" + activa.get().getId());
      } else {
        // no tiene activa → enviar a seleccionar historia
        resp.sendRedirect(req.getContextPath() + "/jugador/partidas/nueva");
      }
    } catch (SQLException e) {
      throw new ServletException(e);
    }
  }
}

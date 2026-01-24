package logic.jugador;

import data.ClasificacionDAO;
import data.HistoriaDAO;
import data.PartidaDAO;
import data.UsuarioDAO;
import entities.Historia;
import entities.Partida;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

@WebServlet("/jugador/partidas/nueva")
public class NuevaPartidaServlet extends HttpServlet {
    private final HistoriaDAO historiaDAO = new HistoriaDAO();
    private final PartidaDAO partidaDAO = new PartidaDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final ClasificacionDAO clasificacionDAO = new ClasificacionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        Integer userId = (Integer) (s != null ? s.getAttribute("userId") : null);
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            // Verificar si tiene una partida activa
            Optional<Partida> activa = partidaDAO.findActivaByUsuario(userId);
            boolean enPartida = activa.isPresent();
            
            req.setAttribute("enPartida", enPartida);
            if (enPartida) {
                req.setAttribute("partidaActivaId", activa.get().getId());
            }

            // Calcular la liga del usuario
            String ligaUsuario = clasificacionDAO.calcularLiga(userId);
            int puntosUsuario = clasificacionDAO.calcularPuntosTotales(userId);
            
            // Obtener todas las historias activas
            List<Historia> historias = historiaDAO.getAll(true); // solo activas
            
            // Marcar cuáles son accesibles según la liga del usuario
            for (Historia h : historias) {
                boolean accesible = esHistoriaAccesible(ligaUsuario, h.getLigaMinima());
                h.setAccesible(accesible);
            }
            
            req.setAttribute("historias", historias);
            req.setAttribute("ligaUsuario", ligaUsuario);
            req.setAttribute("puntosUsuario", puntosUsuario);

            // Mensajes flash
            String flashError = (String) s.getAttribute("flash_error");
            String flashSuccess = (String) s.getAttribute("flash_success");
            if (flashError != null) {
                req.setAttribute("flashError", flashError);
                s.removeAttribute("flash_error");
            }
            if (flashSuccess != null) {
                req.setAttribute("flashSuccess", flashSuccess);
                s.removeAttribute("flash_success");
            }

            req.getRequestDispatcher("/WEB-INF/views/jugador/partidas.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
    
    /**
     * Determina si una historia es accesible según las ligas
     */
    private boolean esHistoriaAccesible(String ligaUsuario, String ligaRequerida) {
        if (ligaRequerida == null) return true; // Sin requisito
        
        // Orden de ligas
        String[] orden = {"bronce", "plata", "oro", "platino", "diamante"};
        int nivelUsuario = indexOf(orden, ligaUsuario);
        int nivelRequerido = indexOf(orden, ligaRequerida);
        
        return nivelUsuario >= nivelRequerido;
    }
    
    private int indexOf(String[] array, String valor) {
        for (int i = 0; i < array.length; i++) {
            if (array[i].equals(valor)) return i;
        }
        return 0; // Por defecto bronce
    }
}

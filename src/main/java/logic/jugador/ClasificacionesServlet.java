package logic.jugador;

import data.ClasificacionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/clasificaciones")
public class ClasificacionesServlet extends HttpServlet {
    private final ClasificacionDAO clasificacionDAO = new ClasificacionDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        Integer userId = (Integer) (s != null ? s.getAttribute("userId") : null);
        
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        try {
            // Obtener parámetros
            String ligaFiltro = req.getParameter("liga");
            if (ligaFiltro == null || ligaFiltro.isBlank()) {
                ligaFiltro = "todas";
            }
            
            // Datos del usuario actual
            int puntosUsuario = clasificacionDAO.calcularPuntosTotales(userId);
            String ligaUsuario = ClasificacionDAO.getLigaPorPuntos(puntosUsuario);
            int posicionUsuario = clasificacionDAO.getPosicionUsuario(userId);
            
            // Calcular puntos para próxima liga
            int puntosProximaLiga = calcularPuntosProximaLiga(puntosUsuario);
            int puntosRestantes = puntosProximaLiga - puntosUsuario;
            
            // Obtener ranking según filtro
            List<Map<String, Object>> ranking;
            if ("todas".equals(ligaFiltro)) {
                ranking = clasificacionDAO.getRankingGlobal(100);
            } else {
                ranking = clasificacionDAO.getRankingPorLiga(ligaFiltro, 50);
            }
            
            // Distribución de jugadores por liga
            Map<String, Integer> distribucion = clasificacionDAO.getDistribucionLigas();
            
            req.setAttribute("ranking", ranking);
            req.setAttribute("ligaFiltro", ligaFiltro);
            req.setAttribute("puntosUsuario", puntosUsuario);
            req.setAttribute("ligaUsuario", ligaUsuario);
            req.setAttribute("posicionUsuario", posicionUsuario);
            req.setAttribute("puntosRestantes", puntosRestantes);
            req.setAttribute("distribucion", distribucion);
            
            req.getRequestDispatcher("/WEB-INF/views/jugador/clasificaciones.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
    
    private int calcularPuntosProximaLiga(int puntosActuales) {
        if (puntosActuales < 101) return 101;      // Bronce → Plata
        if (puntosActuales < 301) return 301;      // Plata → Oro
        if (puntosActuales < 601) return 601;      // Oro → Platino
        if (puntosActuales < 1000) return 1000;    // Platino → Diamante
        return puntosActuales; // Ya está en Diamante
    }
}

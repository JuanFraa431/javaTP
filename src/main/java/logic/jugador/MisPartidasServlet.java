package logic.jugador;

import data.PartidaDAO;
import data.HistoriaDAO;
import data.ProgresoPistaDAO;
import data.ProgresoUbicacionDAO;
import entities.Partida;
import entities.Historia;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/jugador/partidas")
public class MisPartidasServlet extends HttpServlet {
    private final PartidaDAO partidaDAO = new PartidaDAO();
    private final HistoriaDAO historiaDAO = new HistoriaDAO();
    private final ProgresoPistaDAO progresoPistaDAO = new ProgresoPistaDAO();
    private final ProgresoUbicacionDAO progresoUbicacionDAO = new ProgresoUbicacionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        Integer userId = (Integer) (s != null ? s.getAttribute("userId") : null);
        
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        try {
            // Obtener todas las partidas del usuario
            List<Partida> partidas = partidaDAO.findAllByUsuario(userId);
            
            // Crear un mapa de historias para mostrar los títulos
            Map<Integer, Historia> historiasMap = new HashMap<>();
            // Crear un mapa con el conteo REAL de pistas por partida
            Map<Integer, Integer> pistasRealesMap = new HashMap<>();
            // Crear un mapa con el conteo REAL de ubicaciones por partida
            Map<Integer, Integer> ubicacionesRealesMap = new HashMap<>();
            
            for (Partida p : partidas) {
                // Cargar historia
                if (!historiasMap.containsKey(p.getHistoriaId())) {
                    Historia h = historiaDAO.findById(p.getHistoriaId());
                    if (h != null) {
                        historiasMap.put(h.getId(), h);
                    }
                }
                
                // Contar pistas REALES desde la tabla progreso_pista
                int pistasReales = progresoPistaDAO.contarPistasPorPartida(p.getId());
                pistasRealesMap.put(p.getId(), pistasReales);
                
                // Contar ubicaciones REALES desde la tabla progreso_ubicacion
                int ubicacionesReales = progresoUbicacionDAO.contarUbicacionesPorPartida(p.getId());
                ubicacionesRealesMap.put(p.getId(), ubicacionesReales);
            }
            
            req.setAttribute("partidas", partidas);
            req.setAttribute("historiasMap", historiasMap);
            req.setAttribute("pistasRealesMap", pistasRealesMap);
            req.setAttribute("ubicacionesRealesMap", ubicacionesRealesMap);
            
            req.getRequestDispatcher("/WEB-INF/views/jugador/misPartidas.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Error al obtener las partidas", e);
        }
    }
}

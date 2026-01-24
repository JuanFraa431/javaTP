package logic.jugador;

import data.LogroDAO;
import entities.Logro;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Endpoint para obtener logros recién desbloqueados
 * Se puede llamar después de finalizar una partida para mostrar notificaciones
 */
@WebServlet("/jugador/logros/recientes")
public class LogrosRecientesServlet extends HttpServlet {
    private final LogroDAO logroDAO = new LogroDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        Integer userId = (Integer) (s != null ? s.getAttribute("userId") : null);
        
        if (userId == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        try {
            // Obtener logros desbloqueados en los últimos 5 minutos
            List<Logro> logrosRecientes = logroDAO.findLogrosRecientes(userId, 5);
            
            resp.setContentType("application/json; charset=UTF-8");
            StringBuilder json = new StringBuilder("[");
            
            for (int i = 0; i < logrosRecientes.size(); i++) {
                Logro l = logrosRecientes.get(i);
                if (i > 0) json.append(",");
                json.append("{")
                    .append("\"nombre\":\"").append(escape(l.getNombre())).append("\",")
                    .append("\"descripcion\":\"").append(escape(l.getDescripcion())).append("\",")
                    .append("\"icono\":\"").append(escape(l.getIcono())).append("\",")
                    .append("\"puntos\":").append(l.getPuntos())
                    .append("}");
            }
            
            json.append("]");
            resp.getWriter().write(json.toString());
            
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
    
    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}

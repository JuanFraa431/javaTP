package logic.jugador;

import data.LogroDAO;
import entities.Logro;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/logros")
public class LogrosServlet extends HttpServlet {
    private final LogroDAO logroDAO = new LogroDAO();
    
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
            // Obtener todos los logros con estado de desbloqueo del usuario
            List<Logro> logros = logroDAO.findAllWithUserStatus(userId);
            
            // Contar logros desbloqueados y puntos totales
            int totalDesbloqueados = logroDAO.contarLogrosDesbloqueados(userId);
            int totalLogros = logros.size();
            int puntosLogros = logroDAO.contarPuntosLogros(userId);
            
            // Calcular porcentaje de progreso
            int porcentaje = totalLogros > 0 ? (totalDesbloqueados * 100 / totalLogros) : 0;
            
            req.setAttribute("logros", logros);
            req.setAttribute("totalDesbloqueados", totalDesbloqueados);
            req.setAttribute("totalLogros", totalLogros);
            req.setAttribute("puntosLogros", puntosLogros);
            req.setAttribute("porcentaje", porcentaje);
            
            req.getRequestDispatcher("/WEB-INF/views/jugador/logros.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}

package logic.admin;

import data.PartidaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

@WebServlet("/admin/estadisticas/partidas")
public class AdminEstadisticasPartidasServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            PartidaDAO dao = new PartidaDAO();
            Map<String, Object> stats = dao.obtenerEstadisticasPartidas();
            
            request.setAttribute("stats", stats);
            request.getRequestDispatcher("/WEB-INF/views/admin/estadisticas/partidas.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("flash_error", "Error al cargar estadísticas de partidas");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }
}

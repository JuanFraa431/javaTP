package logic.admin;

import data.LogroDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/estadisticas/logros")
public class AdminEstadisticasLogrosServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            LogroDAO dao = new LogroDAO();
            List<Map<String, Object>> logrosStats = dao.obtenerLogrosConEstadisticas();
            
            request.setAttribute("logrosStats", logrosStats);
            request.getRequestDispatcher("/WEB-INF/views/admin/estadisticas/logros.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("flash_error", "Error al cargar estadísticas de logros");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }
}

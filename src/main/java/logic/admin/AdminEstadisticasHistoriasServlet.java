package logic.admin;

import data.HistoriaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/estadisticas/historias")
public class AdminEstadisticasHistoriasServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            HistoriaDAO dao = new HistoriaDAO();
            List<Map<String, Object>> historiasStats = dao.obtenerEstadisticasHistorias();
            
            request.setAttribute("historiasStats", historiasStats);
            request.getRequestDispatcher("/WEB-INF/views/admin/estadisticas/historias.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("flash_error", "Error al cargar estadísticas de historias");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }
}

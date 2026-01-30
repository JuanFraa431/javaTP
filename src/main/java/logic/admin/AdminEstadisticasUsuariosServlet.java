package logic.admin;

import data.UsuarioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

@WebServlet("/admin/estadisticas/usuarios")
public class AdminEstadisticasUsuariosServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            UsuarioDAO dao = new UsuarioDAO();
            Map<String, Object> stats = dao.obtenerEstadisticasUsuarios();
            
            request.setAttribute("stats", stats);
            request.getRequestDispatcher("/WEB-INF/views/admin/estadisticas/usuarios.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("flash_error", "Error al cargar estadísticas de usuarios");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }
}

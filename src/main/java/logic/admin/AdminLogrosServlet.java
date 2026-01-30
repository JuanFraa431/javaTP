package logic.admin;

import data.LogroDAO;
import entities.Logro;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/logros")
public class AdminLogrosServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        LogroDAO dao = new LogroDAO();
        
        try {
            // Obtener todos los logros (incluye activos e inactivos para el admin)
            List<Logro> logros = dao.findAllForAdmin();
            
            // Buscar por nombre o clave
            String search = request.getParameter("search");
            if (search != null && !search.trim().isEmpty()) {
                logros.removeIf(l -> 
                    !l.getNombre().toLowerCase().contains(search.toLowerCase()) &&
                    !l.getClave().toLowerCase().contains(search.toLowerCase())
                );
            }
            
            request.setAttribute("logros", logros);
            request.setAttribute("search", search);
            request.getRequestDispatcher("/WEB-INF/views/admin/logros/list.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("flash_error", "Error al cargar logros: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }
}

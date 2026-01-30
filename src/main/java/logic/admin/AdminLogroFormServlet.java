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

@WebServlet("/admin/logros/form")
public class AdminLogroFormServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                LogroDAO dao = new LogroDAO();
                Logro logro = dao.findById(id);
                
                if (logro == null) {
                    request.getSession().setAttribute("flash_error", "Logro no encontrado");
                    response.sendRedirect(request.getContextPath() + "/admin/logros");
                    return;
                }
                
                request.setAttribute("logro", logro);
                request.setAttribute("esEdicion", true);
                
            } catch (NumberFormatException | SQLException e) {
                e.printStackTrace();
                request.getSession().setAttribute("flash_error", "Error al cargar logro: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/admin/logros");
                return;
            }
        }
        
        request.getRequestDispatcher("/WEB-INF/views/admin/logros/form.jsp").forward(request, response);
    }
}

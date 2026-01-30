package logic.admin;

import data.LogroDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/logros/delete")
public class AdminLogroDeleteServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.trim().isEmpty()) {
            request.getSession().setAttribute("flash_error", "ID de logro no proporcionado");
            response.sendRedirect(request.getContextPath() + "/admin/logros");
            return;
        }
        
        try {
            int id = Integer.parseInt(idParam);
            LogroDAO dao = new LogroDAO();
            
            boolean deleted = dao.delete(id);
            
            if (deleted) {
                request.getSession().setAttribute("flash_ok", "Logro eliminado exitosamente");
            } else {
                request.getSession().setAttribute("flash_error", "No se pudo eliminar el logro");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("flash_error", "ID inválido");
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("flash_error", "Error al eliminar logro: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/logros");
    }
}

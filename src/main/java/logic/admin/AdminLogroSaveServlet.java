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

@WebServlet("/admin/logros/save")
public class AdminLogroSaveServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        try {
            String idParam = request.getParameter("id");
            String clave = request.getParameter("clave");
            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");
            String icono = request.getParameter("icono");
            String puntosStr = request.getParameter("puntos");
            String activoStr = request.getParameter("activo");
            
            // Validaciones
            if (clave == null || clave.trim().isEmpty() ||
                nombre == null || nombre.trim().isEmpty() ||
                icono == null || icono.trim().isEmpty() ||
                puntosStr == null || puntosStr.trim().isEmpty()) {
                
                request.getSession().setAttribute("flash_error", "Todos los campos obligatorios deben completarse");
                response.sendRedirect(request.getContextPath() + "/admin/logros/form" + 
                                    (idParam != null ? "?id=" + idParam : ""));
                return;
            }
            
            int puntos;
            try {
                puntos = Integer.parseInt(puntosStr);
                if (puntos < 0) {
                    throw new NumberFormatException("Los puntos no pueden ser negativos");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("flash_error", "Puntos inválidos: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/admin/logros/form" + 
                                    (idParam != null ? "?id=" + idParam : ""));
                return;
            }
            
            int activo = (activoStr != null && activoStr.equals("1")) ? 1 : 0;
            
            Logro logro = new Logro();
            logro.setClave(clave.trim());
            logro.setNombre(nombre.trim());
            logro.setDescripcion(descripcion != null ? descripcion.trim() : "");
            logro.setIcono(icono.trim());
            logro.setPuntos(puntos);
            logro.setActivo(activo);
            
            LogroDAO dao = new LogroDAO();
            
            if (idParam != null && !idParam.trim().isEmpty()) {
                // UPDATE
                int id = Integer.parseInt(idParam);
                logro.setId(id);
                dao.update(logro);
                request.getSession().setAttribute("flash_ok", "Logro actualizado exitosamente");
            } else {
                // INSERT
                dao.insert(logro);
                request.getSession().setAttribute("flash_ok", "Logro creado exitosamente");
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/logros");
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("flash_error", "Error al guardar logro: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/logros");
        }
    }
}

package logic.jugador;

import data.UsuarioDAO;
import entities.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Servlet para manejar la selección de avatares predefinidos.
 * Los usuarios eligen de un catálogo de avatares en lugar de subir sus propias imágenes.
 */
public class UploadAvatarServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        try {
            // Obtener el avatar seleccionado del catálogo
            String selectedAvatar = req.getParameter("avatarName");
            
            if (selectedAvatar == null || selectedAvatar.trim().isEmpty()) {
                session.setAttribute("flash_error", "No se seleccionó ningún avatar");
                resp.sendRedirect(req.getContextPath() + "/jugador/perfil");
                return;
            }
            
            // Obtener lista dinámica de avatares disponibles
            List<String> availableAvatars = getAvailableAvatars(req);
            
            // Validar que el avatar esté en la lista de permitidos
            if (!availableAvatars.contains(selectedAvatar)) {
                session.setAttribute("flash_error", "Avatar no válido");
                resp.sendRedirect(req.getContextPath() + "/jugador/perfil");
                return;
            }
            
            // Actualizar la base de datos con solo el nombre del archivo
            UsuarioDAO dao = new UsuarioDAO();
            boolean updated = dao.updateAvatar(usuario.getId(), selectedAvatar);
            
            if (updated) {
                // Actualizar la sesión
                usuario.setAvatar(selectedAvatar);
                session.setAttribute("usuario", usuario);
                
                session.setAttribute("flash_ok", "Avatar actualizado correctamente");
            } else {
                session.setAttribute("flash_error", "Error al actualizar el avatar en la base de datos");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flash_error", "Error al procesar la selección: " + e.getMessage());
        }
        
        resp.sendRedirect(req.getContextPath() + "/jugador/perfil");
    }
    
    /**
     * Obtiene la lista de avatares disponibles en la carpeta avatars
     */
    private List<String> getAvailableAvatars(HttpServletRequest req) {
        List<String> avatars = new ArrayList<>();
        String avatarPath = req.getServletContext().getRealPath("/avatars");
        
        if (avatarPath != null) {
            File avatarDir = new File(avatarPath);
            if (avatarDir.exists() && avatarDir.isDirectory()) {
                File[] files = avatarDir.listFiles();
                if (files != null) {
                    for (File file : files) {
                        String fileName = file.getName().toLowerCase();
                        // Aceptar imágenes: jpg, jpeg, png, gif, webp
                        if (fileName.endsWith(".jpg") || fileName.endsWith(".jpeg") || 
                            fileName.endsWith(".png") || fileName.endsWith(".gif") || 
                            fileName.endsWith(".webp")) {
                            avatars.add(file.getName());
                        }
                    }
                }
            }
        }
        
        return avatars;
    }
}

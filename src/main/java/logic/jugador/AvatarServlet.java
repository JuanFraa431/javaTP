package logic.jugador;

import data.UsuarioDAO;
import entities.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

/**
 * Servlet para servir imágenes de avatar de usuarios.
 * Permite acceder a las imágenes mediante URL como: /avatar?userId=123
 */
public class AvatarServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String userIdParam = req.getParameter("userId");
        
        if (userIdParam == null || userIdParam.isEmpty()) {
            serveDefaultAvatar(resp);
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdParam);
            
            // Obtener usuario de la BD para ver si tiene avatar
            UsuarioDAO dao = new UsuarioDAO();
            Usuario usuario = dao.findById(userId);
            
            if (usuario == null || usuario.getAvatar() == null || usuario.getAvatar().isEmpty()) {
                serveDefaultAvatar(resp);
                return;
            }
            
            // La ruta del avatar en BD es "avatars/user_X.ext"
            // SOLUCIÓN PERMANENTE: Usar la misma ruta fija que UploadAvatarServlet
            String uploadPath = System.getProperty("avatar.upload.dir");
            if (uploadPath == null || uploadPath.isEmpty()) {
                uploadPath = "C:/Users/sere-/Desktop/java/javaTP/src/main/webapp/avatars";
            }
            
            File avatarFile = new File(uploadPath, usuario.getAvatar().replace("avatars/", ""));
            
            System.out.println("DEBUG: Buscando avatar en: " + avatarFile.getAbsolutePath());
            System.out.println("DEBUG: Existe? " + avatarFile.exists());
            
            if (avatarFile.exists() && avatarFile.isFile()) {
                // Determinar tipo de contenido basado en extensión
                String fileName = avatarFile.getName();
                String extension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
                String contentType = getContentType(extension);
                
                resp.setContentType(contentType);
                resp.setContentLength((int) avatarFile.length());
                
                // Servir el archivo
                Files.copy(avatarFile.toPath(), resp.getOutputStream());
            } else {
                System.out.println("DEBUG: Archivo no encontrado, sirviendo default");
                serveDefaultAvatar(resp);
            }
            
        } catch (NumberFormatException e) {
            serveDefaultAvatar(resp);
        } catch (Exception e) {
            System.err.println("Error sirviendo avatar: " + e.getMessage());
            e.printStackTrace();
            serveDefaultAvatar(resp);
        }
    }
    
    /**
     * Sirve un avatar por defecto cuando no existe uno personalizado
     */
    private void serveDefaultAvatar(HttpServletResponse resp) throws IOException {
        // Redirigir a un avatar por defecto o generar uno dinámico
        // Por ahora, enviamos un pequeño SVG como avatar por defecto
        resp.setContentType("image/svg+xml");
        
        String defaultSvg = "<svg xmlns='http://www.w3.org/2000/svg' width='200' height='200'>" +
            "<rect width='200' height='200' fill='#4a5568'/>" +
            "<circle cx='100' cy='80' r='40' fill='#cbd5e0'/>" +
            "<circle cx='100' cy='170' r='60' fill='#cbd5e0'/>" +
            "</svg>";
        
        resp.getWriter().write(defaultSvg);
    }
    
    /**
     * Determina el Content-Type basado en la extensión del archivo
     */
    private String getContentType(String extension) {
        switch (extension) {
            case "jpg":
            case "jpeg":
                return "image/jpeg";
            case "png":
                return "image/png";
            case "gif":
                return "image/gif";
            case "webp":
                return "image/webp";
            default:
                return "application/octet-stream";
        }
    }
}

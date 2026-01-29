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
            serveDefaultAvatar(resp, req);
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdParam);
            
            // Obtener usuario de la BD para ver si tiene avatar
            UsuarioDAO dao = new UsuarioDAO();
            Usuario usuario = dao.findById(userId);
            
            if (usuario == null || usuario.getAvatar() == null || usuario.getAvatar().isEmpty()) {
                serveDefaultAvatar(resp, req);
                return;
            }
            
            // El avatar en BD es solo el nombre del archivo (ej: "avatar1.png")
            // Obtener la ruta real del archivo desde el contexto web
            String avatarFileName = usuario.getAvatar();
            String realPath = req.getServletContext().getRealPath("/avatars/" + avatarFileName);
            
            if (realPath == null) {
                System.err.println("No se pudo resolver la ruta real para: /avatars/" + avatarFileName);
                serveDefaultAvatar(resp, req);
                return;
            }
            
            File avatarFile = new File(realPath);
            
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
                System.err.println("Archivo no encontrado: " + avatarFile.getAbsolutePath());
                serveDefaultAvatar(resp, req);
            }
            
        } catch (NumberFormatException e) {
            serveDefaultAvatar(resp, req);
        } catch (Exception e) {
            System.err.println("Error sirviendo avatar: " + e.getMessage());
            e.printStackTrace();
            serveDefaultAvatar(resp, req);
        }
    }
    
    /**
     * Sirve un avatar por defecto cuando no existe uno personalizado
     */
    private void serveDefaultAvatar(HttpServletResponse resp, HttpServletRequest req) throws IOException {
        // Buscar el primer avatar disponible en la carpeta
        try {
            String avatarPath = req.getServletContext().getRealPath("/avatars");
            
            if (avatarPath != null) {
                File avatarDir = new File(avatarPath);
                
                if (avatarDir.exists() && avatarDir.isDirectory()) {
                    File[] files = avatarDir.listFiles();
                    
                    if (files != null) {
                        // Buscar el primer archivo de imagen válido
                        for (File file : files) {
                            String fileName = file.getName().toLowerCase();
                            if (fileName.endsWith(".jpg") || fileName.endsWith(".jpeg") || 
                                fileName.endsWith(".png") || fileName.endsWith(".gif") || 
                                fileName.endsWith(".webp")) {
                                
                                String extension = fileName.substring(fileName.lastIndexOf(".") + 1);
                                String contentType = getContentType(extension);
                                
                                resp.setContentType(contentType);
                                resp.setContentLength((int) file.length());
                                
                                Files.copy(file.toPath(), resp.getOutputStream());
                                return;
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error sirviendo avatar por defecto desde archivo: " + e.getMessage());
        }
        
        // Fallback: generar SVG si no hay archivos
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
            case "svg":
                return "image/svg+xml";
            default:
                return "application/octet-stream";
        }
    }
}

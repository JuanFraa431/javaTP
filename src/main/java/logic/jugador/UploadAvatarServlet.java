package logic.jugador;

import data.UsuarioDAO;
import entities.Usuario;
import logic.InvalidImageException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.List;

/**
 * Servlet para manejar la subida y actualización de avatares de usuario.
 * Valida el tipo de archivo, tamaño y guarda la imagen en el servidor.
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class UploadAvatarServlet extends HttpServlet {
    
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    private static final List<String> ALLOWED_TYPES = Arrays.asList(
        "image/jpeg", "image/jpg", "image/png", "image/gif", "image/webp"
    );
    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList(
        "jpg", "jpeg", "png", "gif", "webp"
    );

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
            // Obtener el archivo subido
            Part filePart = req.getPart("avatar");
            
            if (filePart == null || filePart.getSize() == 0) {
                throw new InvalidImageException("No se seleccionó ningún archivo");
            }
            
            // Validar tipo de contenido
            String contentType = filePart.getContentType();
            if (!ALLOWED_TYPES.contains(contentType)) {
                throw new InvalidImageException("Tipo de archivo no permitido. Solo se aceptan imágenes JPG, PNG, GIF o WebP");
            }
            
            // Validar tamaño
            if (filePart.getSize() > MAX_FILE_SIZE) {
                throw new InvalidImageException("El archivo es demasiado grande. Tamaño máximo: 5MB");
            }
            
            // Obtener extensión del archivo
            String fileName = getFileName(filePart);
            String extension = getFileExtension(fileName);
            
            if (!ALLOWED_EXTENSIONS.contains(extension.toLowerCase())) {
                throw new InvalidImageException("Extensión de archivo no permitida");
            }
            
            // SOLUCIÓN PERMANENTE: Usar una ruta absoluta fija fuera del deployment
            // Opción 1: Usar propiedad del sistema (configurable)
            // Opción 2: Usar ruta fija del proyecto
            String uploadPath = System.getProperty("avatar.upload.dir");
            if (uploadPath == null || uploadPath.isEmpty()) {
                // Fallback a ruta del proyecto
                uploadPath = "C:/Users/sere-/Desktop/java/javaTP/src/main/webapp/avatars";
            }
            
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Generar nombre de archivo único basado en el ID del usuario
            String newFileName = "user_" + usuario.getId() + "." + extension;
            Path filePath = Paths.get(uploadPath, newFileName);
            
            // Eliminar avatar anterior si existe
            deleteOldAvatar(uploadPath, usuario.getId());
            
            // Guardar el archivo
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
            }
            
            // Actualizar la base de datos con la ruta relativa
            String avatarPath = "avatars/" + newFileName;
            UsuarioDAO dao = new UsuarioDAO();
            boolean updated = dao.updateAvatar(usuario.getId(), avatarPath);
            
            if (updated) {
                // Actualizar la sesión
                usuario.setAvatar(avatarPath);
                session.setAttribute("usuario", usuario);
                
                session.setAttribute("flash_ok", "Avatar actualizado correctamente");
            } else {
                throw new InvalidImageException("Error al actualizar el avatar en la base de datos");
            }
            
        } catch (InvalidImageException e) {
            session.setAttribute("flash_error", e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flash_error", "Error al procesar la imagen: " + e.getMessage());
        }
        
        resp.sendRedirect(req.getContextPath() + "/jugador/perfil");
    }
    
    /**
     * Extrae el nombre del archivo de la parte multipart
     */
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
    
    /**
     * Obtiene la extensión del archivo
     */
    private String getFileExtension(String fileName) {
        int lastDot = fileName.lastIndexOf('.');
        if (lastDot > 0 && lastDot < fileName.length() - 1) {
            return fileName.substring(lastDot + 1);
        }
        return "";
    }
    
    /**
     * Elimina el avatar anterior del usuario si existe
     */
    private void deleteOldAvatar(String uploadPath, int userId) {
        File dir = new File(uploadPath);
        File[] files = dir.listFiles((d, name) -> 
            name.startsWith("user_" + userId + "."));
        
        if (files != null) {
            for (File file : files) {
                file.delete();
            }
        }
    }
}

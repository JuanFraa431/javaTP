package logic;

import data.UsuarioDAO;
import entities.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Random;

public class ForgotPasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = trimOrNull(request.getParameter("email"));

        if (email == null) {
            setErrorAndBack(request, response, "Ingresá tu email para recuperar la contraseña.");
            return;
        }

        if (!email.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$")) {
            setErrorAndBack(request, response, "El email no tiene un formato válido.");
            return;
        }

        UsuarioDAO dao = new UsuarioDAO();

        try {
            Usuario usuario = dao.findByEmail(email);
            
            if (usuario == null) {
                // Por seguridad, no revelar si el email existe o no
                setSuccessAndBack(request, response, 
                    "Si el email existe en nuestro sistema, recibirás instrucciones para recuperar tu contraseña.");
                return;
            }

            if (!usuario.isActivo()) {
                setErrorAndBack(request, response, "Esta cuenta está inactiva. Contactá al administrador.");
                return;
            }

            // Generar contraseña temporal (8 caracteres alfanuméricos)
            String tempPassword = generateTempPassword();
            
            System.out.println("DEBUG ForgotPassword: Generando contraseña temporal para usuario ID=" + usuario.getId() + ", email=" + email);
            System.out.println("DEBUG ForgotPassword: Contraseña temporal generada: " + tempPassword);
            
            // Actualizar la contraseña en la base de datos
            boolean updated = dao.updatePassword(usuario.getId(), tempPassword);
            
            System.out.println("DEBUG ForgotPassword: updatePassword returned: " + updated);
            
            if (updated) {
                // En producción, enviarías esto por email
                // Por ahora, lo mostramos en pantalla
                request.setAttribute("tempPassword", tempPassword);
                request.setAttribute("userEmail", email);
                request.getRequestDispatcher("/index.jsp").forward(request, response);
            } else {
                setErrorAndBack(request, response, "No se pudo resetear la contraseña. Intentá de nuevo.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            setErrorAndBack(request, response, "Error al procesar la solicitud: " + e.getMessage());
        }
    }

    /* ================= Helpers ================= */

    private String generateTempPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        Random random = new Random();
        StringBuilder sb = new StringBuilder(8);
        for (int i = 0; i < 8; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }

    private void setErrorAndBack(HttpServletRequest req, HttpServletResponse resp, String msg)
            throws ServletException, IOException {
        req.setAttribute("errorPassword", msg);
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    private void setSuccessAndBack(HttpServletRequest req, HttpServletResponse resp, String msg)
            throws ServletException, IOException {
        req.setAttribute("successPassword", msg);
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    private String trimOrNull(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }
}

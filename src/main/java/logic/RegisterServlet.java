package logic;

import data.UsuarioDAO;
import entities.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Redirigir al index.jsp donde está el formulario
        resp.sendRedirect(req.getContextPath() + "/");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        
        // Debug
        System.out.println("=== RegisterServlet POST recibido ===");

        String nombre = trimOrNull(request.getParameter("nombre"));
        String email = trimOrNull(request.getParameter("email"));
        String password = trimOrNull(request.getParameter("password"));
        String confirmPassword = trimOrNull(request.getParameter("confirmPassword"));
        
        System.out.println("Nombre: " + nombre);
        System.out.println("Email: " + email);
        System.out.println("Password presente: " + (password != null));

        // Validaciones básicas
        if (nombre == null || email == null || password == null || confirmPassword == null) {
            setErrorAndBack(request, response, "Completá todos los campos.");
            return;
        }

        if (nombre.length() < 3) {
            setErrorAndBack(request, response, "El nombre debe tener al menos 3 caracteres.");
            return;
        }

        if (!email.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$")) {
            setErrorAndBack(request, response, "El email no tiene un formato válido.");
            return;
        }

        if (password.length() < 4) {
            setErrorAndBack(request, response, "La contraseña debe tener al menos 4 caracteres.");
            return;
        }

        if (!password.equals(confirmPassword)) {
            setErrorAndBack(request, response, "Las contraseñas no coinciden.");
            return;
        }

        UsuarioDAO dao = new UsuarioDAO();

        try {
            // Verificar si el email ya existe
            Usuario existente = dao.findByEmail(email);
            System.out.println("Usuario existente: " + (existente != null ? existente.getEmail() : "null"));
            
            if (existente != null) {
                setErrorAndBack(request, response, "El email ya está registrado.");
                return;
            }

            // Crear el usuario con rol "jugador" por defecto
            System.out.println("Intentando crear usuario...");
            int userId = dao.create(nombre, email, "jugador", password);
            System.out.println("Usuario creado con ID: " + userId);

            if (userId > 0) {
                // Registro exitoso - iniciar sesión automáticamente
                Usuario nuevoUsuario = dao.findById(userId);
                if (nuevoUsuario != null) {
                    HttpSession session = request.getSession(true);
                    session.setMaxInactiveInterval(30 * 60); // 30 min
                    session.setAttribute("usuario", nuevoUsuario);
                    session.setAttribute("userId", nuevoUsuario.getId());
                    session.setAttribute("nombre", nuevoUsuario.getNombre());
                    session.setAttribute("email", nuevoUsuario.getEmail());
                    session.setAttribute("rol", nuevoUsuario.getRol());

                    // Redirigir al home del jugador
                    response.sendRedirect(request.getContextPath() + "/jugador/home");
                } else {
                    setErrorAndBack(request, response, "Cuenta creada, pero ocurrió un error al iniciar sesión.");
                }
            } else {
                setErrorAndBack(request, response, "No se pudo crear la cuenta. Intentá de nuevo.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            setErrorAndBack(request, response, "Error al crear la cuenta: " + e.getMessage());
        }
    }

    /* ================= Helpers ================= */

    private void setErrorAndBack(HttpServletRequest req, HttpServletResponse resp, String msg)
            throws ServletException, IOException {
        req.setAttribute("errorRegistro", msg);
        req.setAttribute("nombre", req.getParameter("nombre"));
        req.setAttribute("email", req.getParameter("email"));
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    private String trimOrNull(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }
}

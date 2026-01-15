package logic.jugador;

import data.UsuarioDAO;
import entities.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/jugador/perfil")
public class PerfilJugadorServlet extends HttpServlet {

    private final UsuarioDAO dao = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int userId = (int) s.getAttribute("userId");

        try {
            Usuario u = dao.findById(userId);
            if (u == null) {
                s.invalidate();
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            req.setAttribute("usuario", u);
            req.getRequestDispatcher("/WEB-INF/views/jugador/perfil.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            s.setAttribute("flash_error", "No se pudo cargar tu perfil.");
            resp.sendRedirect(req.getContextPath() + "/jugador/home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int userId = (int) s.getAttribute("userId");

        String nombre = trim(req.getParameter("nombre"));
        String email  = trim(req.getParameter("email"));

        String pass1  = trim(req.getParameter("password"));
        String pass2  = trim(req.getParameter("password2"));

        try {
            // 1) Actualizar nombre/email (obligatorio completarlos)
            if (nombre == null || email == null) {
                req.getSession().setAttribute("flash_error", "Completá nombre y email.");
                resp.sendRedirect(req.getContextPath() + "/jugador/perfil");
                return;
            }

            boolean okPerfil = dao.updatePerfilJugador(userId, nombre, email);
            if (!okPerfil) {
                req.getSession().setAttribute("flash_error", "No se pudo actualizar el perfil.");
                resp.sendRedirect(req.getContextPath() + "/jugador/perfil");
                return;
            }

            // 2) Cambiar contraseña (opcional: solo si ambas están completas)
            if (pass1 != null || pass2 != null) {
                if (pass1 == null || pass2 == null) {
                    req.getSession().setAttribute("flash_error", "Para cambiar la contraseña, completá ambos campos.");
                    resp.sendRedirect(req.getContextPath() + "/jugador/perfil");
                    return;
                }
                if (!pass1.equals(pass2)) {
                    req.getSession().setAttribute("flash_error", "Las contraseñas no coinciden.");
                    resp.sendRedirect(req.getContextPath() + "/jugador/perfil");
                    return;
                }
                if (pass1.length() < 6) {
                    req.getSession().setAttribute("flash_error", "La contraseña debe tener al menos 6 caracteres.");
                    resp.sendRedirect(req.getContextPath() + "/jugador/perfil");
                    return;
                }
                boolean okPwd = dao.updatePassword(userId, pass1);
                if (!okPwd) {
                    req.getSession().setAttribute("flash_error", "No se pudo actualizar la contraseña.");
                    resp.sendRedirect(req.getContextPath() + "/jugador/perfil");
                    return;
                }
            }

            // refrescamos datos mínimos de sesión por si cambió el nombre/email
            s.setAttribute("nombre", nombre);
            s.setAttribute("email", email);

            req.getSession().setAttribute("flash_ok", "Perfil actualizado correctamente.");
            resp.sendRedirect(req.getContextPath() + "/jugador/perfil");

        } catch (java.sql.SQLIntegrityConstraintViolationException dup) {
            // Email único duplicado
            req.getSession().setAttribute("flash_error", "Ese email ya está en uso.");
            resp.sendRedirect(req.getContextPath() + "/jugador/perfil");
        } catch (SQLException e) {
            e.printStackTrace();
            req.getSession().setAttribute("flash_error", "Ocurrió un problema al guardar los cambios.");
            resp.sendRedirect(req.getContextPath() + "/jugador/perfil");
        }
    }

    private static String trim(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }
}

package logic.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import logic.CtrlUsuario;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(urlPatterns = {"/admin/usuarios/save", "/admin/usuarios/delete"})
public class AdminUsuarioSaveServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath(); // /admin/usuarios/save o /admin/usuarios/delete
        CtrlUsuario ctrl = new CtrlUsuario();
        
        try {
            if (path.endsWith("/save")) {
                // params del form
                String idStr = req.getParameter("id");
                String nombre = trim(req.getParameter("nombre"));
                String email  = trim(req.getParameter("email"));
                String rol    = trim(req.getParameter("rol"));
                String pass   = trim(req.getParameter("password")); // solo para alta o cambio explícito
                boolean activo = "on".equalsIgnoreCase(req.getParameter("activo")) || "1".equals(req.getParameter("activo"));

                if (idStr == null || idStr.isBlank()) {
                    // Alta
                    if (nombre == null || email == null || rol == null || pass == null) {
                        req.getSession().setAttribute("flash_error", "Completá todos los campos para el alta.");
                        resp.sendRedirect(req.getContextPath() + "/admin/usuarios/form");
                        return;
                    }
                    int newId = ctrl.addUsuario(nombre, email, rol, pass);
                    req.getSession().setAttribute("flash_ok", "Usuario creado (ID " + newId + ").");

                } else {
                    int id = Integer.parseInt(idStr);
                    if (nombre == null || email == null || rol == null) {
                        req.getSession().setAttribute("flash_error", "Nombre, Email y Rol son obligatorios.");
                    } else {
                        boolean ok = ctrl.modificarUsuario(id, nombre, email, rol, activo);
                        if (!ok) {
                            req.getSession().setAttribute("flash_error", "No se pudo actualizar el usuario.");
                        } else {
                            // cambio de contraseña opcional
                            if (pass != null && !pass.isBlank()) {
                                ctrl.cambiarPassword(id, pass);
                            }
                            req.getSession().setAttribute("flash_ok", "Usuario actualizado.");
                        }
                    }
                }
                resp.sendRedirect(req.getContextPath() + "/admin/usuarios");
                return;
            }

            if (path.endsWith("/delete")) {
                String idStr = req.getParameter("id");
                if (idStr != null) {
                    int id = Integer.parseInt(idStr);
                    boolean ok = ctrl.eliminarUsuario(id); //delete (activo=0)
                    req.getSession().setAttribute(ok ? "flash_ok" : "flash_error",
                            ok ? "Usuario desactivado." : "No se pudo desactivar el usuario.");
                }
                resp.sendRedirect(req.getContextPath() + "/admin/usuarios");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            req.getSession().setAttribute("flash_error", "Error de base de datos.");
            resp.sendRedirect(req.getContextPath() + "/admin/usuarios");
        }
    }

    private String trim(String s){
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }
}

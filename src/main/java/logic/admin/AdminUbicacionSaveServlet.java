package logic.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import entities.Usuario;
import data.DbConn;

import java.io.IOException;
import java.sql.*;

@WebServlet(urlPatterns = {"/admin/ubicaciones/save", "/admin/ubicaciones/delete"})
public class AdminUbicacionSaveServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        String rol = (s != null) ? (String) s.getAttribute("rol") : null;
        if (rol == null || !rol.equalsIgnoreCase("ADMIN")) {
            resp.sendRedirect(req.getContextPath() + "/signin");
            return;
        }

        String path = req.getServletPath();
        if ("/admin/ubicaciones/delete".equals(path)) {
            deleteUbicacion(req, resp);
        } else {
            saveUbicacion(req, resp);
        }
    }

    private void saveUbicacion(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        String nombre = req.getParameter("nombre");
        String descripcion = req.getParameter("descripcion");
        String accesibleStr = req.getParameter("accesible");
        String imagen = req.getParameter("imagen");
        String historiaIdStr = req.getParameter("historia_id");

        try {
            int accesible = (accesibleStr != null) ? 1 : 0;
            int historiaId = Integer.parseInt(historiaIdStr);

            if (idStr == null || idStr.isEmpty()) {
                insertUbicacion(nombre, descripcion, accesible, imagen, historiaId);
                req.getSession().setAttribute("flash_ok", "Ubicación creada exitosamente");
            } else {
                int id = Integer.parseInt(idStr);
                updateUbicacion(id, nombre, descripcion, accesible, imagen, historiaId);
                req.getSession().setAttribute("flash_ok", "Ubicación actualizada exitosamente");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("flash_error", "Error al guardar la ubicación");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/ubicaciones");
    }

    private void insertUbicacion(String nombre, String descripcion, int accesible, String imagen, int historiaId) {
        String sql = "INSERT INTO ubicacion (nombre, descripcion, accesible, imagen, historia_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nombre);
            ps.setString(2, descripcion);
            ps.setInt(3, accesible);
            ps.setString(4, imagen);
            ps.setInt(5, historiaId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void updateUbicacion(int id, String nombre, String descripcion, int accesible, String imagen, int historiaId) {
        String sql = "UPDATE ubicacion SET nombre=?, descripcion=?, accesible=?, imagen=?, historia_id=? WHERE id=?";
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nombre);
            ps.setString(2, descripcion);
            ps.setInt(3, accesible);
            ps.setString(4, imagen);
            ps.setInt(5, historiaId);
            ps.setInt(6, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void deleteUbicacion(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        try {
            int id = Integer.parseInt(idStr);
            String sql = "DELETE FROM ubicacion WHERE id = ?";
            try (Connection conn = DbConn.getInstancia().getConn();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, id);
                ps.executeUpdate();
                req.getSession().setAttribute("flash_ok", "Ubicación eliminada exitosamente");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("flash_error", "Error al eliminar la ubicación");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/ubicaciones");
    }
}

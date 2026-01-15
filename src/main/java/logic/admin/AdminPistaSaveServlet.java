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

@WebServlet(urlPatterns = {"/admin/pistas/save", "/admin/pistas/delete"})
public class AdminPistaSaveServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        String rol = (s != null) ? (String) s.getAttribute("rol") : null;
        if (rol == null || !rol.equalsIgnoreCase("ADMIN")) {
            resp.sendRedirect(req.getContextPath() + "/signin");
            return;
        }

        String path = req.getServletPath();
        if ("/admin/pistas/delete".equals(path)) {
            deletePista(req, resp);
        } else {
            savePista(req, resp);
        }
    }

    private void savePista(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        String nombre = req.getParameter("nombre");
        String descripcion = req.getParameter("descripcion");
        String contenido = req.getParameter("contenido");
        String crucialStr = req.getParameter("crucial");
        String importancia = req.getParameter("importancia");
        String ubicacionIdStr = req.getParameter("ubicacion_id");
        String personajeIdStr = req.getParameter("personaje_id");
        String historiaIdStr = req.getParameter("historia_id");

        try {
            int crucial = (crucialStr != null) ? 1 : 0;
            int ubicacionId = (ubicacionIdStr != null && !ubicacionIdStr.isEmpty()) ? Integer.parseInt(ubicacionIdStr) : 0;
            int personajeId = (personajeIdStr != null && !personajeIdStr.isEmpty()) ? Integer.parseInt(personajeIdStr) : 0;
            int historiaId = Integer.parseInt(historiaIdStr);

            if (idStr == null || idStr.isEmpty()) {
                insertPista(nombre, descripcion, contenido, crucial, importancia, ubicacionId, personajeId, historiaId);
                req.getSession().setAttribute("flash_ok", "Pista creada exitosamente");
            } else {
                int id = Integer.parseInt(idStr);
                updatePista(id, nombre, descripcion, contenido, crucial, importancia, ubicacionId, personajeId, historiaId);
                req.getSession().setAttribute("flash_ok", "Pista actualizada exitosamente");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("flash_error", "Error al guardar la pista");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/pistas");
    }

    private void insertPista(String nombre, String descripcion, String contenido, int crucial, String importancia, 
                             int ubicacionId, int personajeId, int historiaId) {
        String sql = "INSERT INTO pista (nombre, descripcion, contenido, crucial, importancia, ubicacion_id, personaje_id, historia_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nombre);
            ps.setString(2, descripcion);
            ps.setString(3, contenido);
            ps.setInt(4, crucial);
            ps.setString(5, importancia);
            ps.setObject(6, ubicacionId > 0 ? ubicacionId : null);
            ps.setObject(7, personajeId > 0 ? personajeId : null);
            ps.setInt(8, historiaId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void updatePista(int id, String nombre, String descripcion, String contenido, int crucial, String importancia, 
                             int ubicacionId, int personajeId, int historiaId) {
        String sql = "UPDATE pista SET nombre=?, descripcion=?, contenido=?, crucial=?, importancia=?, " +
                     "ubicacion_id=?, personaje_id=?, historia_id=? WHERE id=?";
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nombre);
            ps.setString(2, descripcion);
            ps.setString(3, contenido);
            ps.setInt(4, crucial);
            ps.setString(5, importancia);
            ps.setObject(6, ubicacionId > 0 ? ubicacionId : null);
            ps.setObject(7, personajeId > 0 ? personajeId : null);
            ps.setInt(8, historiaId);
            ps.setInt(9, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void deletePista(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        try {
            int id = Integer.parseInt(idStr);
            String sql = "DELETE FROM pista WHERE id = ?";
            try (Connection conn = DbConn.getInstancia().getConn();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, id);
                ps.executeUpdate();
                req.getSession().setAttribute("flash_ok", "Pista eliminada exitosamente");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("flash_error", "Error al eliminar la pista");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/pistas");
    }
}

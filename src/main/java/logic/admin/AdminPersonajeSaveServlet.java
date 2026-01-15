package logic.admin;

import data.DbConn;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet(urlPatterns = {"/admin/personajes/save", "/admin/personajes/delete"})
public class AdminPersonajeSaveServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();
        
        try {
            if (path.endsWith("/save")) {
                String idStr = req.getParameter("id");
                String nombre = trim(req.getParameter("nombre"));
                String descripcion = trim(req.getParameter("descripcion"));
                String coartada = trim(req.getParameter("coartada"));
                String motivo = trim(req.getParameter("motivo"));
                String historiaIdStr = req.getParameter("historia_id");
                int sospechoso = "on".equals(req.getParameter("sospechoso")) ? 1 : 0;
                int culpable = "on".equals(req.getParameter("culpable")) ? 1 : 0;

                if (nombre == null || descripcion == null || historiaIdStr == null) {
                    req.getSession().setAttribute("flash_error", "Nombre, descripción e historia son obligatorios.");
                    resp.sendRedirect(req.getContextPath() + "/admin/personajes/form");
                    return;
                }

                int historiaId = Integer.parseInt(historiaIdStr);

                if (idStr == null || idStr.isBlank()) {
                    // Alta
                    insertPersonaje(nombre, descripcion, coartada, motivo, sospechoso, culpable, historiaId);
                    req.getSession().setAttribute("flash_ok", "Personaje creado exitosamente.");
                } else {
                    // Update
                    int id = Integer.parseInt(idStr);
                    updatePersonaje(id, nombre, descripcion, coartada, motivo, sospechoso, culpable, historiaId);
                    req.getSession().setAttribute("flash_ok", "Personaje actualizado.");
                }
                resp.sendRedirect(req.getContextPath() + "/admin/personajes");
                return;
            }

            if (path.endsWith("/delete")) {
                String idStr = req.getParameter("id");
                if (idStr != null) {
                    int id = Integer.parseInt(idStr);
                    deletePersonaje(id);
                    req.getSession().setAttribute("flash_ok", "Personaje eliminado.");
                }
                resp.sendRedirect(req.getContextPath() + "/admin/personajes");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            req.getSession().setAttribute("flash_error", "Error de base de datos: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/personajes");
        }
    }

    private void insertPersonaje(String nombre, String descripcion, String coartada, String motivo, 
                                 int sospechoso, int culpable, int historiaId) throws SQLException {
        String sql = "INSERT INTO personaje (nombre, descripcion, coartada, motivo, sospechoso, culpable, historia_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nombre);
            ps.setString(2, descripcion);
            ps.setString(3, coartada);
            ps.setString(4, motivo);
            ps.setInt(5, sospechoso);
            ps.setInt(6, culpable);
            ps.setInt(7, historiaId);
            ps.executeUpdate();
        }
    }

    private void updatePersonaje(int id, String nombre, String descripcion, String coartada, String motivo,
                                int sospechoso, int culpable, int historiaId) throws SQLException {
        String sql = "UPDATE personaje SET nombre = ?, descripcion = ?, coartada = ?, motivo = ?, " +
                     "sospechoso = ?, culpable = ?, historia_id = ? WHERE id = ?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nombre);
            ps.setString(2, descripcion);
            ps.setString(3, coartada);
            ps.setString(4, motivo);
            ps.setInt(5, sospechoso);
            ps.setInt(6, culpable);
            ps.setInt(7, historiaId);
            ps.setInt(8, id);
            ps.executeUpdate();
        }
    }

    private void deletePersonaje(int id) throws SQLException {
        String sql = "DELETE FROM personaje WHERE id = ?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    private String trim(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }
}

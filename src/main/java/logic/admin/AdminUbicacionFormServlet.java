package logic.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import entities.Ubicacion;
import entities.Usuario;
import entities.Historia;
import data.DbConn;
import data.HistoriaDAO;

import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/admin/ubicaciones/form")
public class AdminUbicacionFormServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        String rol = (s != null) ? (String) s.getAttribute("rol") : null;
        if (rol == null || !rol.equalsIgnoreCase("ADMIN")) {
            resp.sendRedirect(req.getContextPath() + "/signin");
            return;
        }

        String idStr = req.getParameter("id");
        Ubicacion ubicacion = null;
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                ubicacion = getUbicacionById(id);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        if (ubicacion == null) {
            ubicacion = new Ubicacion();
        }

        HistoriaDAO historiaDAO = new HistoriaDAO();
        List<Historia> historias = new ArrayList<>();
        try {
            historias = historiaDAO.getAll(null);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        req.setAttribute("ubicacion", ubicacion);
        req.setAttribute("historias", historias);
        req.getRequestDispatcher("/WEB-INF/views/admin/ubicaciones/form.jsp").forward(req, resp);
    }

    private Ubicacion getUbicacionById(int id) {
        String sql = "SELECT * FROM ubicacion WHERE id = ?";
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Ubicacion u = new Ubicacion();
                    u.setId(rs.getInt("id"));
                    u.setNombre(rs.getString("nombre"));
                    u.setDescripcion(rs.getString("descripcion"));
                    u.setAccesible(rs.getInt("accesible"));
                    u.setImagen(rs.getString("imagen"));
                    u.setHistoriaId(rs.getInt("historia_id"));
                    return u;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}

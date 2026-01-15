package logic.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import entities.Ubicacion;
import entities.Usuario;
import data.DbConn;

import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/admin/ubicaciones")
public class AdminUbicacionesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("[AdminUbicacionesServlet] doGet called");
        HttpSession s = req.getSession(false);
        String rol = (s != null) ? (String) s.getAttribute("rol") : null;
        if (rol == null || !rol.equalsIgnoreCase("ADMIN")) {
            System.out.println("[AdminUbicacionesServlet] Usuario no autorizado, redirigiendo a signin");
            resp.sendRedirect(req.getContextPath() + "/signin");
            return;
        }

        System.out.println("[AdminUbicacionesServlet] Usuario ADMIN autorizado");
        String q = req.getParameter("q");
        List<Ubicacion> lista = (q != null && !q.trim().isEmpty()) ? searchUbicaciones(q) : getAllUbicaciones();
        System.out.println("[AdminUbicacionesServlet] Lista de ubicaciones obtenida, tamaño: " + lista.size());
        
        req.setAttribute("ubicaciones", lista);
        req.setAttribute("q", q);
        System.out.println("[AdminUbicacionesServlet] Forwarding a list.jsp");
        req.getRequestDispatcher("/WEB-INF/views/admin/ubicaciones/list.jsp").forward(req, resp);
    }

    private List<Ubicacion> getAllUbicaciones() {
        List<Ubicacion> lista = new ArrayList<>();
        String sql = "SELECT u.*, h.titulo AS historia_titulo " +
                     "FROM ubicacion u " +
                     "LEFT JOIN historia h ON u.historia_id = h.id " +
                     "ORDER BY u.id DESC";
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapUbicacion(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    private List<Ubicacion> searchUbicaciones(String q) {
        List<Ubicacion> lista = new ArrayList<>();
        String sql = "SELECT u.*, h.titulo AS historia_titulo " +
                     "FROM ubicacion u " +
                     "LEFT JOIN historia h ON u.historia_id = h.id " +
                     "WHERE u.nombre LIKE ? OR u.descripcion LIKE ? " +
                     "ORDER BY u.id DESC";
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String pattern = "%" + q + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapUbicacion(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    private Ubicacion mapUbicacion(ResultSet rs) throws SQLException {
        Ubicacion u = new Ubicacion();
        u.setId(rs.getInt("id"));
        u.setNombre(rs.getString("nombre"));
        u.setDescripcion(rs.getString("descripcion"));
        u.setAccesible(rs.getInt("accesible"));
        u.setImagen(rs.getString("imagen"));
        u.setHistoriaId(rs.getInt("historia_id"));
        u.setHistoriaTitulo(rs.getString("historia_titulo"));
        return u;
    }
}

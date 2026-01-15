package logic.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import entities.Pista;
import entities.Usuario;
import data.DbConn;

import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/admin/pistas")
public class AdminPistasServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("[AdminPistasServlet] doGet called");
        HttpSession s = req.getSession(false);
        String rol = (s != null) ? (String) s.getAttribute("rol") : null;
        if (rol == null || !rol.equalsIgnoreCase("ADMIN")) {
            System.out.println("[AdminPistasServlet] Usuario no autorizado, redirigiendo a signin");
            resp.sendRedirect(req.getContextPath() + "/signin");
            return;
        }

        System.out.println("[AdminPistasServlet] Usuario ADMIN autorizado");
        String q = req.getParameter("q");
        List<Pista> lista = (q != null && !q.trim().isEmpty()) ? searchPistas(q) : getAllPistas();
        System.out.println("[AdminPistasServlet] Lista de pistas obtenida, tamaño: " + lista.size());
        
        req.setAttribute("pistas", lista);
        req.setAttribute("q", q);
        System.out.println("[AdminPistasServlet] Forwarding a list.jsp");
        req.getRequestDispatcher("/WEB-INF/views/admin/pistas/list.jsp").forward(req, resp);
    }

    private List<Pista> getAllPistas() {
        List<Pista> lista = new ArrayList<>();
        String sql = "SELECT p.*, h.titulo AS historia_titulo, u.nombre AS ubicacion_nombre, per.nombre AS personaje_nombre " +
                     "FROM pista p " +
                     "LEFT JOIN historia h ON p.historia_id = h.id " +
                     "LEFT JOIN ubicacion u ON p.ubicacion_id = u.id " +
                     "LEFT JOIN personaje per ON p.personaje_id = per.id " +
                     "ORDER BY p.id DESC";
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapPista(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    private List<Pista> searchPistas(String q) {
        List<Pista> lista = new ArrayList<>();
        String sql = "SELECT p.*, h.titulo AS historia_titulo, u.nombre AS ubicacion_nombre, per.nombre AS personaje_nombre " +
                     "FROM pista p " +
                     "LEFT JOIN historia h ON p.historia_id = h.id " +
                     "LEFT JOIN ubicacion u ON p.ubicacion_id = u.id " +
                     "LEFT JOIN personaje per ON p.personaje_id = per.id " +
                     "WHERE p.nombre LIKE ? OR p.descripcion LIKE ? " +
                     "ORDER BY p.id DESC";
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String pattern = "%" + q + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapPista(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    private Pista mapPista(ResultSet rs) throws SQLException {
        Pista p = new Pista();
        p.setId(rs.getInt("id"));
        p.setNombre(rs.getString("nombre"));
        p.setDescripcion(rs.getString("descripcion"));
        p.setContenido(rs.getString("contenido"));
        p.setCrucial(rs.getInt("crucial"));
        p.setImportancia(rs.getString("importancia"));
        p.setUbicacionId(rs.getInt("ubicacion_id"));
        p.setPersonajeId(rs.getInt("personaje_id"));
        p.setHistoriaId(rs.getInt("historia_id"));
        p.setHistoriaTitulo(rs.getString("historia_titulo"));
        p.setUbicacionNombre(rs.getString("ubicacion_nombre"));
        p.setPersonajeNombre(rs.getString("personaje_nombre"));
        return p;
    }
}

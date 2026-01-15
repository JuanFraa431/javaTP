package logic.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import entities.Pista;
import entities.Usuario;
import entities.Historia;
import data.DbConn;
import data.HistoriaDAO;

import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/admin/pistas/form")
public class AdminPistaFormServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        String rol = (s != null) ? (String) s.getAttribute("rol") : null;
        if (rol == null || !rol.equalsIgnoreCase("ADMIN")) {
            resp.sendRedirect(req.getContextPath() + "/signin");
            return;
        }

        String idStr = req.getParameter("id");
        Pista pista = null;
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                pista = getPistaById(id);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        if (pista == null) {
            pista = new Pista();
        }

        // Cargar listas para los dropdowns
        HistoriaDAO historiaDAO = new HistoriaDAO();
        List<Historia> historias = new ArrayList<>();
        try {
            historias = historiaDAO.getAll(null);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        List<Map<String, Object>> ubicaciones = getUbicaciones();
        List<Map<String, Object>> personajes = getPersonajes();

        req.setAttribute("pista", pista);
        req.setAttribute("historias", historias);
        req.setAttribute("ubicaciones", ubicaciones);
        req.setAttribute("personajes", personajes);
        req.getRequestDispatcher("/WEB-INF/views/admin/pistas/form.jsp").forward(req, resp);
    }

    private Pista getPistaById(int id) {
        String sql = "SELECT * FROM pista WHERE id = ?";
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
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
                    return p;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private List<Map<String, Object>> getUbicaciones() {
        List<Map<String, Object>> lista = new ArrayList<>();
        String sql = "SELECT id, nombre FROM ubicacion ORDER BY nombre";
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("nombre", rs.getString("nombre"));
                lista.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    private List<Map<String, Object>> getPersonajes() {
        List<Map<String, Object>> lista = new ArrayList<>();
        String sql = "SELECT id, nombre FROM personaje ORDER BY nombre";
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("nombre", rs.getString("nombre"));
                lista.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
}

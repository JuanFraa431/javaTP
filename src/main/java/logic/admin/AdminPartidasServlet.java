package logic.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import entities.Partida;
import entities.Usuario;
import data.DbConn;

import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/admin/partidas")
public class AdminPartidasServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("[AdminPartidasServlet] doGet called");
        HttpSession s = req.getSession(false);
        String rol = (s != null) ? (String) s.getAttribute("rol") : null;
        if (rol == null || !rol.equalsIgnoreCase("ADMIN")) {
            System.out.println("[AdminPartidasServlet] Usuario no autorizado, redirigiendo a signin");
            resp.sendRedirect(req.getContextPath() + "/signin");
            return;
        }

        System.out.println("[AdminPartidasServlet] Usuario ADMIN autorizado");
        String q = req.getParameter("q");
        List<Partida> lista = (q != null && !q.trim().isEmpty()) ? searchPartidas(q) : getAllPartidas();
        System.out.println("[AdminPartidasServlet] Lista de partidas obtenida, tamaño: " + lista.size());
        
        req.setAttribute("partidas", lista);
        req.setAttribute("q", q);
        System.out.println("[AdminPartidasServlet] Forwarding a list.jsp");
        req.getRequestDispatcher("/WEB-INF/views/admin/partidas/list.jsp").forward(req, resp);
    }

    private List<Partida> getAllPartidas() {
        List<Partida> lista = new ArrayList<>();
        
        // Query simple sin JOIN - mostrar directamente los IDs
        String sql = "SELECT * FROM partida ORDER BY id DESC";
        System.out.println("[AdminPartidasServlet] Ejecutando SQL: " + sql);
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            System.out.println("[AdminPartidasServlet] Query ejecutado, procesando resultados...");
            int count = 0;
            while (rs.next()) {
                count++;
                Partida p = new Partida();
                p.setId(rs.getInt("id"));
                p.setUsuarioId(rs.getInt("usuario_id"));
                p.setHistoriaId(rs.getInt("historia_id"));
                p.setFechaInicio(rs.getTimestamp("fecha_inicio"));
                p.setFechaFin(rs.getTimestamp("fecha_fin"));
                p.setEstado(rs.getString("estado"));
                p.setPistasEncontradas(rs.getInt("pistas_encontradas"));
                p.setUbicacionesExploradas(rs.getInt("ubicaciones_exploradas"));
                p.setPuntuacion(rs.getInt("puntuacion"));
                p.setSolucionPropuesta(rs.getString("solucion_propuesta"));
                p.setCasoResuelto(rs.getInt("caso_resuelto"));
                p.setIntentosRestantes(rs.getInt("intentos_restantes"));
                
                lista.add(p);
            }
            System.out.println("[AdminPartidasServlet] Partidas cargadas: " + lista.size());
        } catch (Exception e) {
            System.out.println("[AdminPartidasServlet] ERROR al obtener partidas: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }
    
    private String getUsernameById(int userId) {
        String sql = "SELECT username FROM usuario WHERE id = ?";
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String username = rs.getString("username");
                    System.out.println("[AdminPartidasServlet] Usuario ID " + userId + " -> username: " + username);
                    return username;
                } else {
                    System.out.println("[AdminPartidasServlet] No se encontró usuario con ID: " + userId);
                }
            }
        } catch (Exception e) {
            System.out.println("[AdminPartidasServlet] ERROR obteniendo username para ID " + userId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return "";
    }
    
    private String getHistoriaTituloById(int historiaId) {
        String sql = "SELECT titulo FROM historia WHERE id = ?";
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, historiaId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String titulo = rs.getString("titulo");
                    System.out.println("[AdminPartidasServlet] Historia ID " + historiaId + " -> titulo: " + titulo);
                    return titulo;
                } else {
                    System.out.println("[AdminPartidasServlet] No se encontró historia con ID: " + historiaId);
                }
            }
        } catch (Exception e) {
            System.out.println("[AdminPartidasServlet] ERROR obteniendo titulo para ID " + historiaId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return "";
    }

    private List<Partida> searchPartidas(String q) {
        List<Partida> lista = new ArrayList<>();
        String sql = "SELECT p.*, u.username AS usuario_username, h.titulo AS historia_titulo " +
                     "FROM partida p " +
                     "LEFT JOIN usuario u ON p.usuario_id = u.id " +
                     "LEFT JOIN historia h ON p.historia_id = h.id " +
                     "WHERE u.username LIKE ? OR p.estado LIKE ? OR p.solucion_propuesta LIKE ? " +
                     "ORDER BY p.id DESC";
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String pattern = "%" + q + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapPartida(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    private Partida mapPartida(ResultSet rs) throws SQLException {
        Partida p = new Partida();
        p.setId(rs.getInt("id"));
        p.setUsuarioId(rs.getInt("usuario_id"));
        p.setHistoriaId(rs.getInt("historia_id"));
        p.setFechaInicio(rs.getTimestamp("fecha_inicio"));
        p.setFechaFin(rs.getTimestamp("fecha_fin"));
        p.setEstado(rs.getString("estado"));
        p.setPistasEncontradas(rs.getInt("pistas_encontradas"));
        p.setUbicacionesExploradas(rs.getInt("ubicaciones_exploradas"));
        p.setPuntuacion(rs.getInt("puntuacion"));
        p.setSolucionPropuesta(rs.getString("solucion_propuesta"));
        p.setCasoResuelto(rs.getInt("caso_resuelto"));
        p.setIntentosRestantes(rs.getInt("intentos_restantes"));
        
        // Campos adicionales del JOIN
        try {
            p.setUsuarioUsername(rs.getString("usuario_username"));
            p.setHistoriaTitulo(rs.getString("historia_titulo"));
        } catch (SQLException e) {
            // Campos opcionales
        }
        
        return p;
    }
}

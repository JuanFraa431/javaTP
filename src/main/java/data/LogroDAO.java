package data;

import entities.Logro;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LogroDAO {
    
    /**
     * Obtiene todos los logros activos del sistema
     */
    public List<Logro> findAll() throws SQLException {
        List<Logro> logros = new ArrayList<>();
        String sql = "SELECT id, clave, nombre, descripcion, icono, puntos, activo " +
                     "FROM logro WHERE activo = 1 ORDER BY puntos DESC, id";
        
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                logros.add(mapLogro(rs));
            }
        }
        return logros;
    }
    
    /**
     * Obtiene todos los logros con información de si el usuario los desbloqueó
     */
    public List<Logro> findAllWithUserStatus(int usuarioId) throws SQLException {
        List<Logro> logros = new ArrayList<>();
        String sql = "SELECT l.id, l.clave, l.nombre, l.descripcion, l.icono, l.puntos, l.activo, " +
                     "       ul.fecha_obtencion, " +
                     "       (ul.id IS NOT NULL) as desbloqueado " +
                     "FROM logro l " +
                     "LEFT JOIN usuario_logro ul ON l.id = ul.logro_id AND ul.usuario_id = ? " +
                     "WHERE l.activo = 1 " +
                     "ORDER BY desbloqueado DESC, l.puntos DESC, l.id";
        
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Logro logro = mapLogro(rs);
                    logro.setDesbloqueado(rs.getBoolean("desbloqueado"));
                    
                    Timestamp fecha = rs.getTimestamp("fecha_obtencion");
                    if (fecha != null) {
                        logro.setFechaObtencion(fecha.toString());
                    }
                    
                    logros.add(logro);
                }
            }
        }
        return logros;
    }
    
    /**
     * Desbloquea un logro para un usuario (si no lo tiene ya)
     */
    public boolean desbloquearLogro(int usuarioId, String claveLogro) throws SQLException {
        // Verificar si ya lo tiene
        String checkSql = "SELECT 1 FROM usuario_logro ul " +
                          "INNER JOIN logro l ON ul.logro_id = l.id " +
                          "WHERE ul.usuario_id = ? AND l.clave = ?";
        
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setInt(1, usuarioId);
            ps.setString(2, claveLogro);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return false; // Ya lo tiene
                }
            }
        }
        
        // Insertar el logro
        String insertSql = "INSERT INTO usuario_logro (usuario_id, logro_id, fecha_obtencion) " +
                           "SELECT ?, id, NOW() FROM logro WHERE clave = ? AND activo = 1";
        
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(insertSql)) {
            ps.setInt(1, usuarioId);
            ps.setString(2, claveLogro);
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Cuenta cuántos logros ha desbloqueado el usuario
     */
    public int contarLogrosDesbloqueados(int usuarioId) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM usuario_logro WHERE usuario_id = ?";
        
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }
    
    /**
     * Obtiene el total de puntos de logros del usuario
     */
    public int contarPuntosLogros(int usuarioId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(l.puntos), 0) as total " +
                     "FROM usuario_logro ul " +
                     "INNER JOIN logro l ON ul.logro_id = l.id " +
                     "WHERE ul.usuario_id = ?";
        
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }
    
    /**
     * Obtiene el total de logros en el sistema
     */
    public int contarTotalLogros() throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM logro WHERE activo = 1";
        
        try (Connection conn = DbConn.getInstancia().getConn();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }
    
    /**
     * Obtiene logros desbloqueados recientemente por el usuario
     * @param usuarioId ID del usuario
     * @param minutosAtras Cuántos minutos atrás buscar
     */
    public List<Logro> findLogrosRecientes(int usuarioId, int minutosAtras) throws SQLException {
        List<Logro> logros = new ArrayList<>();
        String sql = "SELECT l.id, l.clave, l.nombre, l.descripcion, l.icono, l.puntos, l.activo, " +
                     "       ul.fecha_obtencion " +
                     "FROM usuario_logro ul " +
                     "INNER JOIN logro l ON ul.logro_id = l.id " +
                     "WHERE ul.usuario_id = ? " +
                     "  AND ul.fecha_obtencion >= DATE_SUB(NOW(), INTERVAL ? MINUTE) " +
                     "ORDER BY ul.fecha_obtencion DESC";
        
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ps.setInt(2, minutosAtras);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Logro logro = mapLogro(rs);
                    logro.setDesbloqueado(true);
                    Timestamp fecha = rs.getTimestamp("fecha_obtencion");
                    if (fecha != null) {
                        logro.setFechaObtencion(fecha.toString());
                    }
                    logros.add(logro);
                }
            }
        }
        return logros;
    }
    
    private Logro mapLogro(ResultSet rs) throws SQLException {
        Logro logro = new Logro();
        logro.setId(rs.getInt("id"));
        logro.setClave(rs.getString("clave"));
        logro.setNombre(rs.getString("nombre"));
        logro.setDescripcion(rs.getString("descripcion"));
        logro.setIcono(rs.getString("icono"));
        logro.setPuntos(rs.getInt("puntos"));
        logro.setActivo(rs.getInt("activo"));
        return logro;
    }
}

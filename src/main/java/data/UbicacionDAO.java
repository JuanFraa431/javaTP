package data;

import entities.Ubicacion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UbicacionDAO {
    
    /**
     * Obtiene todas las ubicaciones de una historia específica
     */
    public List<Ubicacion> findByHistoriaId(int historiaId) throws SQLException {
        List<Ubicacion> ubicaciones = new ArrayList<>();
        String sql = "SELECT id, nombre, descripcion, accesible, imagen, historia_id " +
                     "FROM ubicacion WHERE historia_id = ? ORDER BY id";
        
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, historiaId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Ubicacion u = new Ubicacion();
                    u.setId(rs.getInt("id"));
                    u.setNombre(rs.getString("nombre"));
                    u.setDescripcion(rs.getString("descripcion"));
                    u.setAccesible(rs.getInt("accesible"));
                    u.setImagen(rs.getString("imagen"));
                    u.setHistoriaId(rs.getInt("historia_id"));
                    ubicaciones.add(u);
                }
            }
        }
        return ubicaciones;
    }
    
    /**
     * Obtiene la primera ubicación accesible de una historia (ubicación inicial)
     */
    public Ubicacion findPrimeraUbicacion(int historiaId) throws SQLException {
        String sql = "SELECT id, nombre, descripcion, accesible, imagen, historia_id " +
                     "FROM ubicacion WHERE historia_id = ? AND accesible = 1 " +
                     "ORDER BY id LIMIT 1";
        
        try (Connection conn = DbConn.getInstancia().getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, historiaId);
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
        }
        return null;
    }
    
    /**
     * Obtiene una ubicación por su ID
     */
    public Ubicacion findById(int id) throws SQLException {
        String sql = "SELECT id, nombre, descripcion, accesible, imagen, historia_id " +
                     "FROM ubicacion WHERE id = ?";
        
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
        }
        return null;
    }
    
    /* ===================== Métodos de estadísticas ===================== */
    
    public int contarTodas() throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM ubicacion";
        try (Connection con = DbConn.getInstancia().getConn();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }
}

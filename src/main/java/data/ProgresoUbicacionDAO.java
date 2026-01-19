package data;

import java.sql.*;

public class ProgresoUbicacionDAO {

    /** Registra una ubicación como visitada en una partida */
    public boolean registrarUbicacion(int partidaId, int ubicacionId) throws SQLException {
        // Verificar si ya existe
        String check = "SELECT 1 FROM progreso_ubicacion WHERE partida_id=? AND ubicacion_id=?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(check)) {
            ps.setInt(1, partidaId);
            ps.setInt(2, ubicacionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return false; // ya estaba visitada
            }
        }
        
        // Insertar la ubicación visitada
        String sql = "INSERT INTO progreso_ubicacion (partida_id, ubicacion_id, fecha_visitada) VALUES (?, ?, NOW())";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, partidaId);
            ps.setInt(2, ubicacionId);
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                // Incrementar contador en la tabla partida
                String updateSql = "UPDATE partida SET ubicaciones_exploradas = ubicaciones_exploradas + 1 WHERE id=?";
                try (PreparedStatement updatePs = con.prepareStatement(updateSql)) {
                    updatePs.setInt(1, partidaId);
                    updatePs.executeUpdate();
                }
                return true;
            }
        }
        return false;
    }

    /** Cuenta cuántas ubicaciones ha visitado una partida */
    public int contarUbicacionesPorPartida(int partidaId) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM progreso_ubicacion WHERE partida_id=?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, partidaId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }
    
    /** Verifica si una ubicación ya fue visitada en una partida */
    public boolean yaVisitada(int partidaId, int ubicacionId) throws SQLException {
        String sql = "SELECT 1 FROM progreso_ubicacion WHERE partida_id=? AND ubicacion_id=?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, partidaId);
            ps.setInt(2, ubicacionId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
}

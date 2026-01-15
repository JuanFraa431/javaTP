package data;

import java.sql.*;

public class ProgresoPistaDAO {

    /** Marca una pista como encontrada. Requiere que la pista exista. */
    public boolean registrarPista(int partidaId, int pistaId) throws SQLException {
        // Evita duplicado por UNIQUE(partida_id, pista_id)
        String check = "SELECT 1 FROM progreso_pista WHERE partida_id=? AND pista_id=?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(check)) {
            ps.setInt(1, partidaId);
            ps.setInt(2, pistaId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return true; // ya estaba
            }
        }
        String sql = "INSERT INTO progreso_pista (partida_id, pista_id, fecha_encontrada) VALUES (?, ?, NOW())";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, partidaId);
            ps.setInt(2, pistaId);
            return ps.executeUpdate() > 0;
        }
    }

    /** Busca una pista por nombre (exacto) dentro de la historia y devuelve su id o null si no existe. */
    public Integer findPistaIdByNombre(int historiaId, String nombrePista) throws SQLException {
        System.out.println("[ProgresoPistaDAO] Buscando pista con historia_id=" + historiaId + ", nombre='" + nombrePista + "'");
        String sql = "SELECT id FROM pista WHERE historia_id=? AND nombre=?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, historiaId);
            ps.setString(2, nombrePista);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("id");
                    System.out.println("[ProgresoPistaDAO] Pista encontrada con id=" + id);
                    return id;
                } else {
                    System.out.println("[ProgresoPistaDAO] NO se encontró ninguna pista con ese nombre");
                }
            }
        }
        return null;
    }
}

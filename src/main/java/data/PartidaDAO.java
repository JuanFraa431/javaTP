package data;

import entities.Partida;
import java.sql.*;
import static java.sql.Statement.RETURN_GENERATED_KEYS;
import java.util.Map;
import java.util.Optional;

public class PartidaDAO {
	
	private Partida map(ResultSet rs) throws SQLException {
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
        return p;
    }
	
	public Partida findEnProgresoByUsuario(int usuarioId) throws SQLException {
        String sql = "SELECT * FROM partida WHERE usuario_id=? AND estado='EN_PROGRESO' ORDER BY fecha_inicio DESC LIMIT 1";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }
	 
	public Optional<Partida> findActivaByUsuario(int usuarioId) throws SQLException {
        String sql = "SELECT * FROM partida WHERE usuario_id=? AND estado='EN_PROGRESO' ORDER BY id DESC LIMIT 1";
        try (Connection c = DbConn.getInstancia().getConn();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(map(rs));
            }
        }
        return Optional.empty();
    }
	 
	public int iniciar(int usuarioId, int historiaId) throws SQLException {
        String sql = "INSERT INTO partida (usuario_id, historia_id, fecha_inicio, estado, pistas_encontradas, ubicaciones_exploradas, puntuacion, solucion_propuesta, caso_resuelto, intentos_restantes) " +
                     "VALUES (?, ?, NOW(), 'EN_PROGRESO', 0, 0, 0, NULL, 0, 3)";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, usuarioId);
            ps.setInt(2, historiaId);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        }
        return 0;
    }

	public Partida findById(int id) throws SQLException {
        String sql = "SELECT * FROM partida WHERE id=?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    /** Guardar pista encontrada (si todavía no existe en ESTA partida) */
    public boolean guardarPista(int partidaId, int pistaId) throws SQLException {
        System.out.println("[PartidaDAO] Entrando a guardarPista con partidaId=" + partidaId + ", pistaId=" + pistaId);
        
        // Verificar si ya existe PARA ESTA PARTIDA específica
        String checkSql = "SELECT 1 FROM progreso_pista WHERE partida_id=? AND pista_id=?";
        try (Connection con = DbConn.getInstancia().getConn()) {
            try (PreparedStatement checkPs = con.prepareStatement(checkSql)) {
                checkPs.setInt(1, partidaId);
                checkPs.setInt(2, pistaId);
                try (ResultSet rs = checkPs.executeQuery()) {
                    if (rs.next()) {
                        // Ya existe para esta partida, no hacer nada
                        System.out.println("[PartidaDAO] La pista ya existía en esta partida (partida_id=" + partidaId + "), retornando false");
                        return false;
                    }
                }
            }
            
            System.out.println("[PartidaDAO] La pista NO existe en esta partida, procediendo a insertar...");
            
            // Insertar la pista para ESTA partida
            String insertSql = "INSERT INTO progreso_pista (partida_id, pista_id, fecha_encontrada) VALUES (?, ?, NOW())";
            try (PreparedStatement insertPs = con.prepareStatement(insertSql)) {
                insertPs.setInt(1, partidaId);
                insertPs.setInt(2, pistaId);
                
                try {
                    int rows = insertPs.executeUpdate();
                    System.out.println("[PartidaDAO] INSERT en progreso_pista afectó " + rows + " filas");
                    
                    if (rows > 0) {
                        // Incrementar contador de pistas en partida
                        String updateSql = "UPDATE partida SET pistas_encontradas = pistas_encontradas + 1 WHERE id=?";
                        try (PreparedStatement updatePs = con.prepareStatement(updateSql)) {
                            updatePs.setInt(1, partidaId);
                            int updatedRows = updatePs.executeUpdate();
                            System.out.println("[PartidaDAO] UPDATE partida.pistas_encontradas afectó " + updatedRows + " filas");
                        }
                        System.out.println("[PartidaDAO] Pista guardada exitosamente, retornando true");
                        return true;
                    }
                } catch (SQLException e) {
                    System.err.println("[PartidaDAO ERROR] No se pudo insertar en progreso_pista:");
                    System.err.println("[PartidaDAO ERROR] Mensaje: " + e.getMessage());
                    System.err.println("[PartidaDAO ERROR] SQLState: " + e.getSQLState());
                    System.err.println("[PartidaDAO ERROR] ErrorCode: " + e.getErrorCode());
                    
                    // Si el error es por duplicado (puede pasar con UNIQUE KEY incorrecto)
                    if (e.getErrorCode() == 1062) { // MySQL duplicate entry error
                        System.err.println("[PartidaDAO ERROR] *** PROBLEMA: La tabla progreso_pista tiene una constraint UNIQUE incorrecta ***");
                        System.err.println("[PartidaDAO ERROR] *** Debe permitir la misma pista_id en diferentes partidas ***");
                        System.err.println("[PartidaDAO ERROR] *** Ejecuta el script fix_progreso_pista.sql para corregirlo ***");
                    }
                    throw e;
                }
            }
        }
        System.out.println("[PartidaDAO] No se pudo guardar la pista, retornando false");
        return false;
    }

    public boolean marcarGanada(int partidaId, int puntuacion) throws SQLException {
        // Usar 'GANADA' si la BD tiene ENUM con ese valor, o 'FINALIZADA' si es VARCHAR
        String sql = "UPDATE partida SET estado='GANADA', caso_resuelto=1, puntuacion=?, fecha_fin=NOW() WHERE id=? AND estado='EN_PROGRESO'";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, puntuacion);
            ps.setInt(2, partidaId);
            return ps.executeUpdate() > 0;
        }
    }
    
    public int crearPartida(int usuarioId, int historiaId) throws SQLException {
        String sql = "INSERT INTO partida (usuario_id, historia_id, estado, fecha_inicio, pistas_encontradas, ubicaciones_exploradas, puntuacion, solucion_propuesta, caso_resuelto, intentos_restantes) " +
                     "VALUES (?, ?, 'EN_PROGRESO', NOW(), 0, 0, 0, NULL, 0, 3)";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql, RETURN_GENERATED_KEYS)) {
            ps.setInt(1, usuarioId);
            ps.setInt(2, historiaId);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }
    
    /** Finalizar explícitamente (por botón "Finalizar partida") */
    public boolean finalizar(int partidaId, String estadoFinal) throws SQLException {
        // Usar 'GANADA' por defecto si la BD tiene ENUM con ese valor
        if ("FINALIZADA".equals(estadoFinal)) {
            estadoFinal = "GANADA"; // Compatibilidad con ENUM de BD
        }
        String sql = "UPDATE partida SET estado=?, fecha_fin=NOW() WHERE id=?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, estadoFinal);
            ps.setInt(2, partidaId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean existePartidaEnProgreso(int usuarioId, int historiaId) throws SQLException {
        String sql = "SELECT 1 FROM partida WHERE usuario_id=? AND historia_id=? AND estado='EN_PROGRESO' LIMIT 1";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ps.setInt(2, historiaId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public Integer getPartidaEnProgreso(int usuarioId, int historiaId) throws SQLException {
        String sql = "SELECT id FROM partida WHERE usuario_id=? AND historia_id=? AND estado='EN_PROGRESO' ORDER BY fecha_inicio DESC LIMIT 1";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ps.setInt(2, historiaId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("id");
            }
        }
        return null;
    }
    
    public boolean actualizarSolucionPropuesta(int partidaId, String solucion) throws SQLException {
        String sql = "UPDATE partida SET solucion_propuesta=? WHERE id=?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, solucion);
            ps.setInt(2, partidaId);
            return ps.executeUpdate() > 0;
        }
    }
    
    /** Obtener todas las partidas de un usuario ordenadas por fecha (más recientes primero) */
    public java.util.List<Partida> findAllByUsuario(int usuarioId) throws SQLException {
        String sql = "SELECT * FROM partida WHERE usuario_id=? ORDER BY fecha_inicio DESC";
        java.util.List<Partida> partidas = new java.util.ArrayList<>();
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    partidas.add(map(rs));
                }
            }
        }
        return partidas;
    }
    
    /** Obtener partidas de un usuario filtradas por estado */
    public java.util.List<Partida> findByUsuarioAndEstado(int usuarioId, String estado) throws SQLException {
        String sql = "SELECT * FROM partida WHERE usuario_id=? AND estado=? ORDER BY fecha_inicio DESC";
        java.util.List<Partida> partidas = new java.util.ArrayList<>();
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ps.setString(2, estado);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    partidas.add(map(rs));
                }
            }
        }
        return partidas;
    }
    
    /** Obtener partidas de un usuario ordenadas por fecha de inicio (para verificar días consecutivos) */
    public java.util.List<Partida> findByUsuarioOrderByFecha(int usuarioId) throws SQLException {
        String sql = "SELECT * FROM partida WHERE usuario_id=? ORDER BY fecha_inicio ASC";
        java.util.List<Partida> partidas = new java.util.ArrayList<>();
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    partidas.add(map(rs));
                }
            }
        }
        return partidas;
    }
    
    /** Abandonar una partida en progreso */
    public boolean abandonarPartida(int partidaId) throws SQLException {
        String sql = "UPDATE partida SET estado='ABANDONADA', fecha_fin=NOW() WHERE id=? AND estado='EN_PROGRESO'";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, partidaId);
            return ps.executeUpdate() > 0;
        }
    }
    
    /** Contar total de pistas en una historia */
    public int contarPistasPorHistoria(int historiaId) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM pista WHERE historia_id=?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, historiaId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }
    
    /** Contar total de ubicaciones en una historia */
    public int contarUbicacionesPorHistoria(int historiaId) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM ubicacion WHERE historia_id=?";
        try (Connection con = DbConn.getInstancia().getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, historiaId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }
    
    /* ===================== Métodos de estadísticas ===================== */
    
    public int contarTodas() throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM partida";
        try (Connection con = DbConn.getInstancia().getConn();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }
    
    public int contarEnCurso() throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM partida WHERE estado = 'EN_PROGRESO'";
        try (Connection con = DbConn.getInstancia().getConn();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }
    
    public int contarCompletadas() throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM partida WHERE estado IN ('GANADA', 'PERDIDA')";
        try (Connection con = DbConn.getInstancia().getConn();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }
    
    public Map<String, Object> obtenerEstadisticasPartidas() throws SQLException {
        Map<String, Object> stats = new java.util.HashMap<>();
        
        // Totales básicos
        stats.put("total", contarTodas());
        stats.put("enCurso", contarEnCurso());
        stats.put("completadas", contarCompletadas());
        
        // Partidas por estado
        String sqlEstados = "SELECT estado, COUNT(*) as cantidad FROM partida GROUP BY estado";
        try (Connection con = DbConn.getInstancia().getConn();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sqlEstados)) {
            java.util.List<Map<String, Object>> estados = new java.util.ArrayList<>();
            while (rs.next()) {
                Map<String, Object> estado = new java.util.HashMap<>();
                estado.put("estado", rs.getString("estado"));
                estado.put("cantidad", rs.getInt("cantidad"));
                estados.add(estado);
            }
            stats.put("estados", estados);
        }
        
        // Tiempo promedio de completado (en minutos)
        String sqlTiempo = "SELECT ROUND(AVG(TIMESTAMPDIFF(MINUTE, fecha_inicio, fecha_fin)), 0) as promedio " +
                          "FROM partida WHERE estado IN ('GANADA', 'PERDIDA') AND fecha_fin IS NOT NULL";
        try (Connection con = DbConn.getInstancia().getConn();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sqlTiempo)) {
            if (rs.next()) {
                Object promedio = rs.getObject("promedio");
                stats.put("tiempoPromedio", promedio != null ? rs.getInt("promedio") : 0);
            }
        }
        
        // Partidas por historia
        String sqlHistorias = "SELECT h.titulo, COUNT(p.id) as cantidad " +
                             "FROM historia h LEFT JOIN partida p ON h.id = p.historia_id " +
                             "GROUP BY h.id ORDER BY cantidad DESC";
        try (Connection con = DbConn.getInstancia().getConn();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sqlHistorias)) {
            java.util.List<Map<String, Object>> historias = new java.util.ArrayList<>();
            while (rs.next()) {
                Map<String, Object> historia = new java.util.HashMap<>();
                historia.put("titulo", rs.getString("titulo"));
                historia.put("cantidad", rs.getInt("cantidad"));
                historias.add(historia);
            }
            stats.put("historias", historias);
        }
        
        return stats;
    }

}

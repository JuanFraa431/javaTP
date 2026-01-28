package logic;

import data.ClasificacionDAO;
import data.DocumentoDAO;
import data.LogroDAO;
import data.PartidaDAO;
import data.UsuarioDAO;
import entities.Partida;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

/**
 * Servicio para verificar y otorgar logros automáticamente
 */
public class LogroService {
    private final LogroDAO logroDAO = new LogroDAO();
    private final PartidaDAO partidaDAO = new PartidaDAO();
    private final DocumentoDAO documentoDAO = new DocumentoDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final ClasificacionDAO clasificacionDAO = new ClasificacionDAO();
    
    /**
     * Verifica y otorga todos los logros aplicables después de que una partida termine
     */
    public void verificarLogrosPartidaFinalizada(int usuarioId, int partidaId) throws SQLException {
        Partida partida = partidaDAO.findById(partidaId);
        if (partida == null) return;
        
        // Solo verificar logros si la partida fue ganada
        if (!"GANADA".equals(partida.getEstado())) return;
        
        // Verificar cada logro
        verificarPrimerCaso(usuarioId);
        verificarDetectiveNovato(usuarioId);
        verificarDetectiveExperto(usuarioId);
        verificarPerfeccionista(usuarioId, partida);
        verificarColeccionista(usuarioId, partida);
        verificarVelocista(usuarioId, partida);
        verificarMadrugador(partida);
        verificarNocturno(partida);
        verificarPersistente(usuarioId);
        
        // CRÍTICO: Después de verificar los logros, actualizar la liga y puntos del usuario
        // Esto asegura que la progresión persista entre reinicios del servidor
        actualizarLigaUsuario(usuarioId);
    }
    
    /**
     * Calcula y persiste la liga actual del usuario basada en sus puntos totales.
     * Este método se llama automáticamente después de:
     * 1. Finalizar una partida ganada
     * 2. Desbloquear logros
     */
    private void actualizarLigaUsuario(int usuarioId) throws SQLException {
        // Calcular puntos totales desde las partidas y logros
        int puntosTotales = clasificacionDAO.calcularPuntosTotales(usuarioId);
        
        // Determinar la liga según los puntos
        String ligaActual = clasificacionDAO.getLigaPorPuntos(puntosTotales);
        
        // Persistir en la base de datos
        usuarioDAO.actualizarLigaYPuntos(usuarioId, ligaActual, puntosTotales);
    }
    
    /**
     * Logro: primer_caso - Completar tu primera partida
     */
    private void verificarPrimerCaso(int usuarioId) throws SQLException {
        List<Partida> ganadas = partidaDAO.findByUsuarioAndEstado(usuarioId, "GANADA");
        if (ganadas.size() == 1) {
            logroDAO.desbloquearLogro(usuarioId, "primer_caso");
        }
    }
    
    /**
     * Logro: detective_novato - Ganar 3 partidas
     */
    private void verificarDetectiveNovato(int usuarioId) throws SQLException {
        List<Partida> ganadas = partidaDAO.findByUsuarioAndEstado(usuarioId, "GANADA");
        if (ganadas.size() >= 3) {
            logroDAO.desbloquearLogro(usuarioId, "detective_novato");
        }
    }
    
    /**
     * Logro: detective_experto - Ganar 10 partidas
     */
    private void verificarDetectiveExperto(int usuarioId) throws SQLException {
        List<Partida> ganadas = partidaDAO.findByUsuarioAndEstado(usuarioId, "GANADA");
        if (ganadas.size() >= 10) {
            logroDAO.desbloquearLogro(usuarioId, "detective_experto");
        }
    }
    
    /**
     * Logro: perfeccionista - Ganar una partida con puntuación perfecta (>95%)
     */
    private void verificarPerfeccionista(int usuarioId, Partida partida) throws SQLException {
        if (partida.getPuntuacion() >= 95) {
            logroDAO.desbloquearLogro(usuarioId, "perfeccionista");
        }
    }
    
    /**
     * Logro: coleccionista - Encontrar todos los documentos en una historia
     */
    private void verificarColeccionista(int usuarioId, Partida partida) throws SQLException {
        int historiaId = partida.getHistoriaId();
        
        // Contar documentos totales en la historia
        int totalDocumentos = documentoDAO.contarDocumentosPorHistoria(historiaId);
        
        // Contar documentos descubiertos por el usuario en esta partida
        int descubiertos = documentoDAO.contarDocumentosDescubiertos(partida.getId());
        
        if (totalDocumentos > 0 && descubiertos >= totalDocumentos) {
            logroDAO.desbloquearLogro(usuarioId, "coleccionista");
        }
    }
    
    /**
     * Logro: velocista - Completar una partida en menos de 30 minutos
     */
    private void verificarVelocista(int usuarioId, Partida partida) throws SQLException {
        Timestamp inicio = partida.getFechaInicio();
        Timestamp fin = partida.getFechaFin();
        
        if (inicio != null && fin != null) {
            long duracionMinutos = (fin.getTime() - inicio.getTime()) / (1000 * 60);
            if (duracionMinutos < 30) {
                logroDAO.desbloquearLogro(usuarioId, "velocista");
            }
        }
    }
    
    /**
     * Logro: madrugador - Completar una partida entre 6-10 AM
     */
    private void verificarMadrugador(Partida partida) throws SQLException {
        if (partida.getFechaFin() == null) return;
        
        LocalDateTime fechaFin = partida.getFechaFin().toLocalDateTime();
        LocalTime hora = fechaFin.toLocalTime();
        
        if (hora.getHour() >= 6 && hora.getHour() < 10) {
            logroDAO.desbloquearLogro(partida.getUsuarioId(), "madrugador");
        }
    }
    
    /**
     * Logro: nocturno - Completar una partida entre 10 PM y 2 AM
     */
    private void verificarNocturno(Partida partida) throws SQLException {
        if (partida.getFechaFin() == null) return;
        
        LocalDateTime fechaFin = partida.getFechaFin().toLocalDateTime();
        LocalTime hora = fechaFin.toLocalTime();
        
        // Entre 22:00 y 23:59 OR entre 00:00 y 02:00
        if (hora.getHour() >= 22 || hora.getHour() < 2) {
            logroDAO.desbloquearLogro(partida.getUsuarioId(), "nocturno");
        }
    }
    
    /**
     * Logro: persistente - Jugar 5 días consecutivos
     */
    private void verificarPersistente(int usuarioId) throws SQLException {
        List<Partida> partidas = partidaDAO.findByUsuarioOrderByFecha(usuarioId);
        
        if (partidas.size() < 5) return;
        
        int diasConsecutivos = 1;
        LocalDateTime ultimaFecha = null;
        
        for (Partida p : partidas) {
            if (p.getFechaInicio() == null) continue;
            
            LocalDateTime fechaPartida = p.getFechaInicio().toLocalDateTime();
            
            if (ultimaFecha != null) {
                long diasDiferencia = java.time.temporal.ChronoUnit.DAYS.between(
                    ultimaFecha.toLocalDate(), 
                    fechaPartida.toLocalDate()
                );
                
                if (diasDiferencia == 1) {
                    diasConsecutivos++;
                    if (diasConsecutivos >= 5) {
                        logroDAO.desbloquearLogro(usuarioId, "persistente");
                        return;
                    }
                } else if (diasDiferencia > 1) {
                    diasConsecutivos = 1;
                }
            }
            
            ultimaFecha = fechaPartida;
        }
    }
}

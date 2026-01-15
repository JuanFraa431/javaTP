package entities;

import java.sql.Timestamp;

public class Partida {
    private int id;
    private int usuarioId;
    private int historiaId;
    private Timestamp fechaInicio;
    private Timestamp fechaFin;
    private String estado; // EN_PROGRESO, FINALIZADA
    private int pistasEncontradas;
    private int ubicacionesExploradas;
    private int puntuacion;
    private String solucionPropuesta;
    private int casoResuelto;
    private int intentosRestantes;
    
    // Campos adicionales para JOIN
    private String usuarioUsername;
    private String historiaTitulo;

    // Getters y Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }

    public int getHistoriaId() { return historiaId; }
    public void setHistoriaId(int historiaId) { this.historiaId = historiaId; }

    public Timestamp getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(Timestamp fechaInicio) { this.fechaInicio = fechaInicio; }

    public Timestamp getFechaFin() { return fechaFin; }
    public void setFechaFin(Timestamp fechaFin) { this.fechaFin = fechaFin; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public int getPistasEncontradas() { return pistasEncontradas; }
    public void setPistasEncontradas(int pistasEncontradas) { this.pistasEncontradas = pistasEncontradas; }

    public int getUbicacionesExploradas() { return ubicacionesExploradas; }
    public void setUbicacionesExploradas(int ubicacionesExploradas) { this.ubicacionesExploradas = ubicacionesExploradas; }

    public int getPuntuacion() { return puntuacion; }
    public void setPuntuacion(int puntuacion) { this.puntuacion = puntuacion; }

    public String getSolucionPropuesta() { return solucionPropuesta; }
    public void setSolucionPropuesta(String solucionPropuesta) { this.solucionPropuesta = solucionPropuesta; }

    public int getCasoResuelto() { return casoResuelto; }
    public void setCasoResuelto(int casoResuelto) { this.casoResuelto = casoResuelto; }

    public int getIntentosRestantes() { return intentosRestantes; }
    public void setIntentosRestantes(int intentosRestantes) { this.intentosRestantes = intentosRestantes; }

    public String getUsuarioUsername() { return usuarioUsername; }
    public void setUsuarioUsername(String usuarioUsername) { this.usuarioUsername = usuarioUsername; }

    public String getHistoriaTitulo() { return historiaTitulo; }
    public void setHistoriaTitulo(String historiaTitulo) { this.historiaTitulo = historiaTitulo; }
}

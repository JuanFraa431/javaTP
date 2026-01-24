package entities;

import java.sql.Timestamp;

public class Historia {
    private int id;
    private String titulo;
    private String descripcion;
    private String contexto;
    private boolean activa;
    private int dificultad;       // 1..5
    private int tiempoEstimado;   // minutos
    private Timestamp fechaCreacion;
    private String ligaMinima;    // bronce, plata, oro, platino, diamante
    
    // Campo adicional para indicar si el usuario puede acceder
    private boolean accesible;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public String getContexto() { return contexto; }
    public void setContexto(String contexto) { this.contexto = contexto; }

    public boolean isActiva() { return activa; }
    public void setActiva(boolean activa) { this.activa = activa; }

    public int getDificultad() { return dificultad; }
    public void setDificultad(int dificultad) { this.dificultad = dificultad; }

    public int getTiempoEstimado() { return tiempoEstimado; }
    public void setTiempoEstimado(int tiempoEstimado) { this.tiempoEstimado = tiempoEstimado; }

    public Timestamp getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(Timestamp fechaCreacion) { this.fechaCreacion = fechaCreacion; }

    public String getLigaMinima() { return ligaMinima; }
    public void setLigaMinima(String ligaMinima) { this.ligaMinima = ligaMinima; }

    public boolean isAccesible() { return accesible; }
    public void setAccesible(boolean accesible) { this.accesible = accesible; }
}

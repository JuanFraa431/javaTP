package entities;

public class Logro {
    private int id;
    private String clave;
    private String nombre;
    private String descripcion;
    private String icono;
    private int puntos;
    private int activo;
    
    // Campo adicional para indicar si el usuario lo tiene desbloqueado
    private boolean desbloqueado;
    private String fechaObtencion;

    // Getters y Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getClave() { return clave; }
    public void setClave(String clave) { this.clave = clave; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public String getIcono() { return icono; }
    public void setIcono(String icono) { this.icono = icono; }

    public int getPuntos() { return puntos; }
    public void setPuntos(int puntos) { this.puntos = puntos; }

    public int getActivo() { return activo; }
    public void setActivo(int activo) { this.activo = activo; }

    public boolean isDesbloqueado() { return desbloqueado; }
    public void setDesbloqueado(boolean desbloqueado) { this.desbloqueado = desbloqueado; }

    public String getFechaObtencion() { return fechaObtencion; }
    public void setFechaObtencion(String fechaObtencion) { this.fechaObtencion = fechaObtencion; }
}

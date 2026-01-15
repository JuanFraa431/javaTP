package entities;

public class Ubicacion {
    private int id;
    private String nombre;
    private String descripcion;
    private int accesible;
    private String imagen;
    private int historiaId;
    
    // Campo adicional para JOIN
    private String historiaTitulo;

    // Getters y Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public int getAccesible() { return accesible; }
    public void setAccesible(int accesible) { this.accesible = accesible; }

    public String getImagen() { return imagen; }
    public void setImagen(String imagen) { this.imagen = imagen; }

    public int getHistoriaId() { return historiaId; }
    public void setHistoriaId(int historiaId) { this.historiaId = historiaId; }

    public String getHistoriaTitulo() { return historiaTitulo; }
    public void setHistoriaTitulo(String historiaTitulo) { this.historiaTitulo = historiaTitulo; }
}

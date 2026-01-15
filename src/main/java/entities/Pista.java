package entities;

public class Pista {
    private int id;
    private String nombre;
    private String descripcion;
    private String contenido;
    private int crucial;
    private String importancia;
    private int ubicacionId;
    private int personajeId;
    private int historiaId;
    
    // Campos adicionales para JOIN
    private String historiaTitulo;
    private String ubicacionNombre;
    private String personajeNombre;

    // Getters y Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public String getContenido() { return contenido; }
    public void setContenido(String contenido) { this.contenido = contenido; }

    public int getCrucial() { return crucial; }
    public void setCrucial(int crucial) { this.crucial = crucial; }

    public String getImportancia() { return importancia; }
    public void setImportancia(String importancia) { this.importancia = importancia; }

    public int getUbicacionId() { return ubicacionId; }
    public void setUbicacionId(int ubicacionId) { this.ubicacionId = ubicacionId; }

    public int getPersonajeId() { return personajeId; }
    public void setPersonajeId(int personajeId) { this.personajeId = personajeId; }

    public int getHistoriaId() { return historiaId; }
    public void setHistoriaId(int historiaId) { this.historiaId = historiaId; }

    public String getHistoriaTitulo() { return historiaTitulo; }
    public void setHistoriaTitulo(String historiaTitulo) { this.historiaTitulo = historiaTitulo; }

    public String getUbicacionNombre() { return ubicacionNombre; }
    public void setUbicacionNombre(String ubicacionNombre) { this.ubicacionNombre = ubicacionNombre; }

    public String getPersonajeNombre() { return personajeNombre; }
    public void setPersonajeNombre(String personajeNombre) { this.personajeNombre = personajeNombre; }
}

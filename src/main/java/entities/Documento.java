package entities;

public class Documento {
    private int id;
    private int historiaId;
    private String clave;           // Identificador único del documento (ej: "nota_codigo", "correo")
    private String nombre;          // Nombre visible del documento
    private String icono;           // Ícono Font Awesome (ej: "fa-file-lines")
    private String contenido;       // Contenido HTML del documento
    private String codigoCorrecto;  // Código que debe ingresar el jugador para esta historia (puede ser null)
    private String pistaNombre;     // Nombre de la pista a registrar cuando se valida el código

    // Constructor vacío
    public Documento() {}

    // Constructor completo
    public Documento(int id, int historiaId, String clave, String nombre, String icono, 
                     String contenido, String codigoCorrecto, String pistaNombre) {
        this.id = id;
        this.historiaId = historiaId;
        this.clave = clave;
        this.nombre = nombre;
        this.icono = icono;
        this.contenido = contenido;
        this.codigoCorrecto = codigoCorrecto;
        this.pistaNombre = pistaNombre;
    }

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getHistoriaId() {
        return historiaId;
    }

    public void setHistoriaId(int historiaId) {
        this.historiaId = historiaId;
    }

    public String getClave() {
        return clave;
    }

    public void setClave(String clave) {
        this.clave = clave;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getIcono() {
        return icono;
    }

    public void setIcono(String icono) {
        this.icono = icono;
    }

    public String getContenido() {
        return contenido;
    }

    public void setContenido(String contenido) {
        this.contenido = contenido;
    }

    public String getCodigoCorrecto() {
        return codigoCorrecto;
    }

    public void setCodigoCorrecto(String codigoCorrecto) {
        this.codigoCorrecto = codigoCorrecto;
    }

    public String getPistaNombre() {
        return pistaNombre;
    }

    public void setPistaNombre(String pistaNombre) {
        this.pistaNombre = pistaNombre;
    }
}

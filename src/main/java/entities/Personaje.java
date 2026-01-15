package entities;

public class Personaje {
    private int id;
    private String nombre;
    private String descripcion;
    private String coartada;
    private String motivo;
    private int sospechoso;
    private int culpable;
    private int historiaId;
    private String historiaTitulo; // Para mostrar en lista

    public Personaje() {}

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getCoartada() {
        return coartada;
    }

    public void setCoartada(String coartada) {
        this.coartada = coartada;
    }

    public String getMotivo() {
        return motivo;
    }

    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }

    public int getSospechoso() {
        return sospechoso;
    }

    public void setSospechoso(int sospechoso) {
        this.sospechoso = sospechoso;
    }

    public int getCulpable() {
        return culpable;
    }

    public void setCulpable(int culpable) {
        this.culpable = culpable;
    }

    public int getHistoriaId() {
        return historiaId;
    }

    public void setHistoriaId(int historiaId) {
        this.historiaId = historiaId;
    }

    public String getHistoriaTitulo() {
        return historiaTitulo;
    }

    public void setHistoriaTitulo(String historiaTitulo) {
        this.historiaTitulo = historiaTitulo;
    }
}

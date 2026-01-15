package entities;

public class ProgresoPista {
    private int id;
    private int partidaId;
    private int pistaId;
    private String fechaEncontrada;

    // Getters y Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPartidaId() { return partidaId; }
    public void setPartidaId(int partidaId) { this.partidaId = partidaId; }

    public int getPistaId() { return pistaId; }
    public void setPistaId(int pistaId) { this.pistaId = pistaId; }

    public String getFechaEncontrada() { return fechaEncontrada; }
    public void setFechaEncontrada(String fechaEncontrada) { this.fechaEncontrada = fechaEncontrada; }
}

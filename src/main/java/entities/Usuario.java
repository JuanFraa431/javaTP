package entities;

public class Usuario {
    private int id;
    private String username;
    private String nombre;
    private String email;
    private byte[] salt;
    private byte[] passwordHash;
    private String rol;   // "INVITADO" | "JUGADOR" | "ADMIN"
    private boolean activo; // <-- NUEVO campo para el estado del usuario
    private String avatar; // Nombre del archivo de avatar predefinido (ej: "avatar1.png")
    private String ligaActual; // Liga actual del usuario: bronce, plata, oro, platino, diamante
    private int puntosTotales; // Puntos totales acumulados (partidas + logros)

    // --- Getters y Setters ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public byte[] getSalt() { return salt; }
    public void setSalt(byte[] salt) { this.salt = salt; }

    public byte[] getPasswordHash() { return passwordHash; }
    public void setPasswordHash(byte[] passwordHash) { this.passwordHash = passwordHash; }

    public String getRol() { return rol; }
    public void setRol(String rol) { this.rol = rol; }

    // --- NUEVO: campo activo ---
    public boolean isActivo() { return activo; }
    public void setActivo(boolean activo) { this.activo = activo; }
    
    // --- NUEVO: campo avatar ---
    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }
    
    // --- NUEVO: campos de liga y puntos ---
    public String getLigaActual() { return ligaActual; }
    public void setLigaActual(String ligaActual) { this.ligaActual = ligaActual; }
    
    public int getPuntosTotales() { return puntosTotales; }
    public void setPuntosTotales(int puntosTotales) { this.puntosTotales = puntosTotales; }
}

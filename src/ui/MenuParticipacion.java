package ui;

import java.util.List;
import entities.ParticipacionDetalle;
import logic.ParticipacionController;

public class MenuParticipacion {
    public static void mostrar() {
        ParticipacionController pc = new ParticipacionController();

        List<ParticipacionDetalle> lista = pc.getListadoCompletoConAsesinato();

        System.out.println("=== Participaciones con detalles de asesinato ===");
        
        for (ParticipacionDetalle pd : lista) {
            System.out.println("Usuario: " + pd.getNombreUsuario());
            System.out.println("Historia: " + pd.getTituloHistoria());
            System.out.println("Personaje asignado: " + pd.getNombrePersonaje());
            System.out.println("=== Asesinato en esta historia ===");
            System.out.println("Asesino: " + pd.getNombreAsesino());
            System.out.println("Arma: " + pd.getNombreArma());
            System.out.println("Ubicación: " + pd.getNombreUbicacion());
            System.out.println("----------------------------------");
        
    
       }}
}

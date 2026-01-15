package ui;

import java.util.Scanner;


public class Menu {
	public void start() {
        Scanner sc = new Scanner(System.in);
        int opcion;

        do {
            System.out.println("\n===== MENÚ PRINCIPAL =====");
            System.out.println("1. CRUD Usuario");
            System.out.println("2. CRUD Historia");
            System.out.println("3. CRUD Pista");
            System.out.println("4. CRUD Personaje");
            System.out.println("5. CRUD Ubicacion");
            System.out.println("6. Caso de Uso Participacion");
            System.out.println("7. Jugar historia (elegir historia y asignar personaje)");
            System.out.println("0. Salir");
            System.out.print("Seleccione una opción: ");
            opcion = sc.nextInt();

            switch (opcion) {
                case 1:
                    MenuUsuario.mostrar(); 
                    break;
                case 2:
                    MenuHistoria.mostrar();
                    break;
                case 3:
                	MenuPista.mostrar();
                    break;
                case 4:
                	MenuPersonaje.mostrar();
                    break;
                case 5:
                	MenuUbicacion.mostrar();
                    break;
                case 6:
                    MenuParticipacion.mostrar();
                    break;
                case 7:
                    MenuJugar.mostrar();  
                    break;
                case 0:
                    System.out.println("¡Hasta luego!");
                    break;
                default:
                    System.out.println("Opción inválida.");
            }
        } while (opcion != 0);

        sc.close();
    }
}

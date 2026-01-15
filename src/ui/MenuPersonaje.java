package ui;

import java.util.LinkedList;
import java.util.Scanner;
import entities.Personaje;
import logic.PersonajeController;

public class MenuPersonaje {
    public static void mostrar() {
    	@SuppressWarnings("resource")
        Scanner sc = new Scanner(System.in);
        PersonajeController controller = new PersonajeController();
        int opcion;

        do {
            System.out.println("\n----- MENÚ PERSONAJE -----");
            System.out.println("1. Listar personajes");
            System.out.println("2. Agregar personaje");
            System.out.println("3. Modificar personaje");
            System.out.println("4. Eliminar personaje");
            System.out.println("5. Buscar personaje por ID");
            System.out.println("0. Volver");
            System.out.print("Ingrese una opción: ");
            opcion = sc.nextInt();
            sc.nextLine();

            switch (opcion) {
                case 1:
                    LinkedList<Personaje> personajes = controller.getAllPersonajes();
                    for (Personaje p : personajes) {
                        System.out.println("ID: " + p.getId_personaje() + ", Nombre: " + p.getNombre() + ", Descripción: " + p.getDescripcion());
                    }
                    break;
                case 2:
                    Personaje nuevo = new Personaje();
                    System.out.print("Nombre: ");
                    nuevo.setNombre(sc.nextLine());
                    System.out.print("Descripción: ");
                    nuevo.setDescripcion(sc.nextLine());
                    controller.agregarPersonaje(nuevo);
                    System.out.println("Personaje agregado con ID: " + nuevo.getId_personaje());
                    break;
                case 3:
                    System.out.print("ID del personaje a modificar: ");
                    int id = sc.nextInt();
                    sc.nextLine();
                    Personaje mod = controller.buscarPorId(id);
                    if (mod == null) {
                        System.out.println("No se encontró el personaje.");
                        break;
                    }
                    System.out.print("Nombre actual: " + mod.getNombre() + " -> Nuevo nombre: ");
                    String nuevoNombre = sc.nextLine();
                    if (!nuevoNombre.isBlank()) mod.setNombre(nuevoNombre);

                    System.out.print("Descripción actual: " + mod.getDescripcion() + " -> Nueva descripción: ");
                    String nuevaDesc = sc.nextLine();
                    if (!nuevaDesc.isBlank()) mod.setDescripcion(nuevaDesc);

                    controller.actualizarPersonaje(mod);
                    System.out.println("Personaje actualizado.");
                    break;
                case 4:
                    System.out.print("ID del personaje a eliminar: ");
                    controller.eliminarPersonajePorId(sc.nextInt());
                    sc.nextLine();
                    System.out.println("Personaje eliminado.");
                    break;
                case 5:
                    System.out.print("ID a buscar: ");
                    Personaje encontrado = controller.buscarPorId(sc.nextInt());
                    sc.nextLine();
                    if (encontrado != null) {
                        System.out.println("ID: " + encontrado.getId_personaje() + ", Nombre: " + encontrado.getNombre() + ", Descripción: " + encontrado.getDescripcion());
                    } else {
                        System.out.println("No se encontró el personaje.");
                    }
                    break;
                case 0:
                    System.out.println("Volviendo...");
                    break;
                default:
                    System.out.println("Opción no válida.");
            }

        } while (opcion != 0);
    }
}

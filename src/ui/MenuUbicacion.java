package ui;

import java.util.LinkedList;
import java.util.Scanner;
import entities.Ubicacion;
import logic.UbicacionController;

public class MenuUbicacion {
    public static void mostrar() {
    	@SuppressWarnings("resource")
        Scanner sc = new Scanner(System.in);
        UbicacionController controller = new UbicacionController();
        int opcion;

        do {
            System.out.println("\n----- MENÚ UBICACIÓN -----");
            System.out.println("1. Listar ubicaciones");
            System.out.println("2. Agregar ubicación");
            System.out.println("3. Modificar ubicación");
            System.out.println("4. Eliminar ubicación");
            System.out.println("5. Buscar ubicación por ID");
            System.out.println("0. Volver");
            System.out.print("Ingrese una opción: ");
            opcion = sc.nextInt();
            sc.nextLine();

            switch (opcion) {
                case 1:
                    LinkedList<Ubicacion> ubicaciones = controller.getAllUbicaciones();
                    for (Ubicacion u : ubicaciones) {
                        System.out.println("ID: " + u.getId_ubicacion() + ", Nombre: " + u.getNombre() + ", Descripción: " + u.getDescripcion());
                    }
                    break;
                case 2:
                    Ubicacion nueva = new Ubicacion();
                    System.out.print("Nombre: ");
                    nueva.setNombre(sc.nextLine());
                    System.out.print("Descripción: ");
                    nueva.setDescripcion(sc.nextLine());
                    controller.agregarUbicacion(nueva);
                    System.out.println("Ubicación agregada con ID: " + nueva.getId_ubicacion());
                    break;
                case 3:
                    System.out.print("ID de la ubicación a modificar: ");
                    int id = sc.nextInt();
                    sc.nextLine();
                    Ubicacion mod = controller.buscarPorId(id);
                    if (mod == null) {
                        System.out.println("No se encontró la ubicación.");
                        break;
                    }
                    System.out.print("Nombre actual: " + mod.getNombre() + " -> Nuevo nombre: ");
                    String nuevoNombre = sc.nextLine();
                    if (!nuevoNombre.isBlank()) mod.setNombre(nuevoNombre);

                    System.out.print("Descripción actual: " + mod.getDescripcion() + " -> Nueva descripción: ");
                    String nuevaDesc = sc.nextLine();
                    if (!nuevaDesc.isBlank()) mod.setDescripcion(nuevaDesc);

                    controller.actualizarUbicacion(mod);
                    System.out.println("Ubicación actualizada.");
                    break;
                case 4:
                    System.out.print("ID de la ubicación a eliminar: ");
                    controller.eliminarUbicacionPorId(sc.nextInt());
                    sc.nextLine();
                    System.out.println("Ubicación eliminada.");
                    break;
                case 5:
                    System.out.print("ID a buscar: ");
                    Ubicacion encontrado = controller.buscarPorId(sc.nextInt());
                    sc.nextLine();
                    if (encontrado != null) {
                        System.out.println("ID: " + encontrado.getId_ubicacion() + ", Nombre: " + encontrado.getNombre() + ", Descripción: " + encontrado.getDescripcion());
                    } else {
                        System.out.println("No se encontró la ubicación.");
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

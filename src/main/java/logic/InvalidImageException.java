package logic;

/**
 * Custom Exception para errores relacionados con imágenes de avatar.
 * Se lanza cuando:
 * - El archivo no es una imagen válida
 * - El tamaño del archivo excede el límite
 * - El formato de imagen no es soportado
 * - Error al procesar o guardar la imagen
 */
public class InvalidImageException extends Exception {
    
    /**
     * Constructor con mensaje descriptivo del error
     * @param message Descripción del error ocurrido
     */
    public InvalidImageException(String message) {
        super(message);
    }
    
    /**
     * Constructor con mensaje y causa original del error
     * @param message Descripción del error ocurrido
     * @param cause Excepción original que causó este error
     */
    public InvalidImageException(String message, Throwable cause) {
        super(message, cause);
    }
}

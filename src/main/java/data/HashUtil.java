package data;

import java.security.MessageDigest;
import java.security.SecureRandom;

public class HashUtil {
    private static final SecureRandom RNG = new SecureRandom();

    public static byte[] randomSalt16() {
        byte[] salt = new byte[16];
        RNG.nextBytes(salt);
        return salt;
        // Para registro nuevo, guardás este salt junto al hash.
    }

    public static byte[] sha256(byte[] input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            return md.digest(input);
        } catch (Exception e) {
            throw new RuntimeException("SHA-256 no disponible", e);
        }
    }

    public static byte[] hashPassword(String plain, byte[] salt) {
        byte[] passBytes = plain.getBytes(java.nio.charset.StandardCharsets.UTF_8);
        byte[] combined = new byte[passBytes.length + salt.length];
        System.arraycopy(passBytes, 0, combined, 0, passBytes.length);
        System.arraycopy(salt, 0, combined, passBytes.length, salt.length);
        return sha256(combined);
    }

    public static boolean slowEquals(byte[] a, byte[] b) {
        // comparación resistente a timing
        if (a == null || b == null || a.length != b.length) return false;
        int res = 0;
        for (int i = 0; i < a.length; i++) res |= a[i] ^ b[i];
        return res == 0;
    }
}

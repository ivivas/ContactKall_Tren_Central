/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package adportas.audio;

/**
 *
 * @author Felipe
 */
import java.security.*;
import javax.crypto.*;
import javax.crypto.spec.*;
import java.io.*;

/**
 * This program generates a AES key, retrieves its raw bytes, and
 * then reinstantiates a AES key from the key bytes.
 * The reinstantiated key is used to initialize a AES cipher for
 * encryption and decryption.
 */
public class Cripto {

    KeyGenerator kgen;
    SecretKey skey;
    byte[] raw;
    SecretKeySpec skeySpec;
    Cipher cipher;
    private String message;

    public Cripto() throws Exception {
        kgen = KeyGenerator.getInstance("AES");
        kgen.init(128); // 192 and 256 bits may not be available
        // Generate the secret key specs.

        skey = kgen.generateKey();
        raw = skey.getEncoded();
        skeySpec = new SecretKeySpec(asByte("d4cfe0f3c8bb160f2edfd83745423ed7"), "AES");
        // Instantiate the cipher
        cipher = Cipher.getInstance("AES");

        cipher.init(Cipher.ENCRYPT_MODE, skeySpec);
    }

    /**
     * Turns array of bytes into string
     *
     * @param buf	Array of bytes to convert to hex string
     * @return	Generated hex string
     */
    public static String asHex(byte buf[]) {
        StringBuffer strbuf = new StringBuffer(buf.length * 2);
        int i;

        for (i = 0; i < buf.length; i++) {
            if (((int) buf[i] & 0xff) < 0x10) {
                strbuf.append("0");
            }

            strbuf.append(Long.toString((int) buf[i] & 0xff, 16));
        }

        return strbuf.toString();
    }

    public static byte[] asByte(String hex) {
        byte[] bts = new byte[hex.length() / 2];
        for (int i = 0; i < bts.length; i++) {
            bts[i] = (byte) Integer.parseInt(hex.substring(2 * i, 2 * i + 2), 16);
        }
        return bts;
    }

    public byte[] encriptar(String message) throws Exception {
        message+="Texto Extra";
        byte[] encrypted = cipher.doFinal(message.getBytes());
       // System.out.println("encrypted string: " + asHex(encrypted) + " " + asByte(asHex(encrypted)));
        return encrypted;
    }

    public String desencriptar(byte[] encrypted) throws Exception {
        cipher.init(Cipher.DECRYPT_MODE, skeySpec);
        byte[] original = cipher.doFinal(encrypted);
        String originalString = new String(original);
        originalString=originalString.substring(0, originalString.length()-11);
        return originalString;

    }

    public static void main(String[] args) throws Exception {

        Cripto cripto = new Cripto();
        cripto.setMessage("Attachments/1009_1013_1375129974_Saliente.wav");
        byte[] encrypted = cripto.encriptar(cripto.getMessage());
        String rutaArchivo = cripto.asHex(encrypted);
        System.out.println("encrypted :" + rutaArchivo);
        System.out.println("desencriptado : " + cripto.desencriptar(asByte(rutaArchivo)));
        
      //  System.out.println("Fecha : " + cripto.desencriptar(asByte("0165911f88987ff5eabaa52f72b488fd96ba4564894be6b0181e7cf050c02a87")));

        System.out.println("****************************");
    }



    /**
     * @return the message
     */
    public String getMessage() {
        return message;
    }

    /**
     * @param message the message to set
     */
    public void setMessage(String message) {
        this.message = message;
    }
   
}


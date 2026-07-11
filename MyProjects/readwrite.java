import java.io.*;

public class readwrite {
    public static void main(String args[]) {

        try {
            FileOutputStream fout = new FileOutputStream("data.txt");

            String s = "Hello Vijay";
            byte b[] = s.getBytes();

            fout.write(b);
            fout.close();

            System.out.println("Data written successfully");

            FileInputStream fin = new FileInputStream("data.txt");

            int i;
            System.out.print("Data read from file: ");

            while ((i = fin.read()) != -1) {
                System.out.print((char) i);
            }

            fin.close();

        } catch (Exception e) {
            System.out.println(e);
        }
    }
}
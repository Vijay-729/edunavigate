class MyThread implements Runnable {

    public void run() {
        for (int i = 1; i <= 5; i++) {
            System.out.println(Thread.currentThread().getName() + " : " + i);
        }
    }
}

public class Main {
    public static void main(String args[]) {

        MyThread obj = new MyThread();

        Thread t1 = new Thread(obj);
        Thread t2 = new Thread(obj);

        t1.start();   // start first thread
        t2.start();   // start second thread
    }
}

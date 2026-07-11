class thread1 implements Runnable{
    public void run(){
        try{
            System.out.println("thread 1 : hello");
            Thread.sleep(2000);
        }catch(Exception e){
            System.out.println(e);
        }
    }
}
class thread2 implements Runnable{
    public void run(){
        try{
            System.out.println("thread 2 : java");
            Thread.sleep(2000);
        }catch(Exception e){
            System.out.println(e);
        }
    }
}
class thread3 implements Runnable{
    public void run(){
        try{
            System.out.println("thread 3 : good morning");
            
        }catch(Exception e){
            System.out.println(e);
        }
    }
}
class  {
    public static void main(String args[]){
        thread1 obj=new thread1();
        Thread t1=new Thread(obj);
        thread2 obj1=new thread2();
        Thread t2=new Thread(obj1);
        thread3 obj2=new thread3();
        Thread t3=new Thread(obj2);
        t1.start();
        t2.start();
        t3.start();
        
    }
}

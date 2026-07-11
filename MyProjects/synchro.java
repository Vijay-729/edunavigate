class Table{
    synchronized void printtable(int n){
        for(int i=0;i<=5;i++){
            System.out.println(n*i);
            try{
                Thread.sleep(2000);
            }catch(Exception e){
                System.out.println(e);
            }
        }
    }
}

class thread1 extends Thread{
    Table t;
    thread1(Table t){
        this.t=t;
    }
    public void run(){
        t.printtable(5);
        
    }
}
class thread2 extends Thread{
    Table t;
    thread2(Table t){
        this.t=t;
    }
    public void run(){
        t.printtable(10);
        
    }
}
class synchro{
    public static void main(String args[]){
        Table obj = new Table();
        thread1 t1= new thread1(obj);
        thread2 t2= new thread2(obj);
        
    }
}
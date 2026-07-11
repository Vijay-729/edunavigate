class Bank{
    int balance=1000;
    synchronized void withdraw(int amount){
        try{
            if (balance<amount){
                System.out.println("insufficient balance waiting");
                wait();
            }
            balance-=amount;
            System.out.println("withdrawn :"+ amount); 
            System.out.println("balance amount ;" + balance);
        }catch(Exception e){
            System.out.println(e);
        }
    }
    synchronized void deposit(int amount){
        balance+=amount;
        System.out.println("deposited :"+ amount); 
        System.out.println("balance amount ;" + balance);
        
        notify();
    }
}
class withdrawnthread extends Thread{
    Bank b;
    withdrawnthread(Bank b){
        this.b=b;
    }
    public void run(){
        b.withdraw(2000);
    }
}
class depositthread extends Thread{
    Bank b;
    depositthread(Bank b){
        this.b=b;
    }
    public void run(){
        b.deposit(2000);
    }
}
class inter{
    public static void main(String args[]){
        Bank obj=new Bank();
        withdrawnthread t1=new withdrawnthread(obj);
        depositthread t2=new depositthread(obj);
        t1.start();
        t2.start();
        
    }
}
    
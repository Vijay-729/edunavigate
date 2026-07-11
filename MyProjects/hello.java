class MyException extends Exception {
    MyException(String message) {
        super(message);
    }
}

class Test {

    static void checkage(int age) throws MyException {
        if (age < 18) {
            throw new MyException("You are NOT eligible to vote");
        } else {
            System.out.println("You are eligible to vote");
        }
    }

    public static void main(String args[]) {
        try {
            checkage(16);
        } catch (MyException e) {
            System.out.println("Exception caught: " + e.getMessage());
        }
    }
}
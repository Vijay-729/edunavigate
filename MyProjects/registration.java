import java.awt.*;

public class registration extends Frame {

    registration() {

        // Labels
        Label l1 = new Label("Name:");
        Label l2 = new Label("Email:");
        Label l3 = new Label("Gender:");

        // TextFields
        TextField t1 = new TextField();
        TextField t2 = new TextField();

        // Checkbox (Radio buttons)
        CheckboxGroup cbg = new CheckboxGroup();
        Checkbox c1 = new Checkbox("Male", cbg, false);
        Checkbox c2 = new Checkbox("Female", cbg, false);

        // Button
        Button b = new Button("Register");

        // Set positions
        l1.setBounds(50, 50, 80, 30);
        t1.setBounds(150, 50, 150, 30);

        l2.setBounds(50, 100, 80, 30);
        t2.setBounds(150, 100, 150, 30);

        l3.setBounds(50, 150, 80, 30);
        c1.setBounds(150, 150, 70, 30);
        c2.setBounds(230, 150, 80, 30);

        b.setBounds(150, 200, 100, 30);

        // Add components
        add(l1); add(t1);
        add(l2); add(t2);
        add(l3); add(c1); add(c2);
        add(b);

        // Frame settings
        setSize(400, 300);
        setLayout(null);
        setVisible(true);
    }

    public static void main(String args[]) {
        new registration();
    }
}
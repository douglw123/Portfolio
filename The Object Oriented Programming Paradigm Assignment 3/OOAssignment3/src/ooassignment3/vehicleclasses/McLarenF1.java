package ooassignment3.vehicleclasses;

/**
 * This class represents a McLaren F1
 * @author Douglas Williams
 */
public class McLarenF1 extends Vehicle {

    /**
     * This constructor creates the car setting the cost and base MPG.
     * The super constructor is also called and provided with the make and model
     */
    public McLarenF1() {
        super("McLaren", "F1");
        cost = 1000000.00;
        mpg = 20;
    }
    
}

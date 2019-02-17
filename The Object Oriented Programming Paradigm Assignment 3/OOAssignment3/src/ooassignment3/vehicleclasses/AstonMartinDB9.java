package ooassignment3.vehicleclasses;


/**
 * This class represents an Aston Martin DB9.
 * @author Douglas Williams
 */
public class AstonMartinDB9 extends Vehicle{

    /**
     * This constructor creates the car setting the cost and base MPG.
     * The super constructor is also called and provided with the make and model 
     */
    public AstonMartinDB9() {
        super("Aston Martin", "DB9");
        cost = 100000.00;
        mpg = 25;
    }
    
}

package ooassignment3.vehicleclasses;

/**
 * This class represents a Ford Escort
 * @author Douglas Williams
 */
public class FordEscort extends Vehicle{

    /**
     * This constructor creates the car setting the cost and base MPG.
     * The super constructor is also called and provided with the make and model
     */
    public FordEscort() {
        super("Ford", "Escort");
        cost = 5000.00;
        mpg = 40;
    }
    
}

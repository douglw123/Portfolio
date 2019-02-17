package ooassignment3.vehicleclasses;

/**
 * This class represents a Seat Ibiza
 * @author Douglas Williams
 */
public class SeatIbiza extends Vehicle{

    /**
     * This constructor creates the car setting the cost and base MPG.
     * The super constructor is also called and provided with the make and model
     */
    public SeatIbiza() {
        super("Seat", "Ibiza");
        cost = 15000.00;
        mpg = 45;
    }
    
}

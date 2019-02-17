/*
 * 
 */
package ooassignment3.accessoryclasses;

import ooassignment3.vehicleclasses.Vehicle;

/**
 * This class represents an air conditioning accessory.
 * @author Douglas Williams
 */
public class AirConditioning extends Accessory{

    /**
     * This constructor creates the accessory setting the cost and calls the super constructor providing the child Vehicle object.
     * @param vehicle The child Vehicle object, which will either be a car ({@link Vehicle}) or an accessory.
     */
    public AirConditioning(Vehicle vehicle) {
        super(vehicle);
        cost = 150.00;
    }
    
    @Override
    public String toString() {
        return vehicle+" Air Conditioning,";
    }    
}

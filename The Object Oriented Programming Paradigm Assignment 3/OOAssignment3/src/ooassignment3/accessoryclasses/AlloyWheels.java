/*
 * 
 */
package ooassignment3.accessoryclasses;

import ooassignment3.vehicleclasses.Vehicle;

/**
 * This class represents the alloy wheels accessory.
 * @author Douglas Williams
 */
public class AlloyWheels extends Accessory {
    
    /**
     * This constructor creates the accessory setting the cost and calls the super constructor providing the child {@link Vehicle} object.
     * @param vehicle The child Vehicle object, which will either be a car ({@link Vehicle}) or an accessory.
     */
    public AlloyWheels(Vehicle vehicle) {
        super(vehicle);
        cost = 400.00;
    }
    
    @Override
    public String toString() {
        return vehicle+" Alloy Wheels,";
    }
}

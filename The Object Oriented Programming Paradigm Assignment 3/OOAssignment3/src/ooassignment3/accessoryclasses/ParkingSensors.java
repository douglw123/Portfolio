/*
 * 
 */
package ooassignment3.accessoryclasses;

import ooassignment3.vehicleclasses.Vehicle;

/**
 * This class represents the parking sensors accessory.
 * @author Douglas Williams
 */
public class ParkingSensors extends Accessory {
    
    /**
     * This constructor creates the accessory setting the cost and calls the super constructor providing the child {@link Vehicle} object.
     * @param vehicle The child Vehicle object, which will either be a car ({@link Vehicle}) or an accessory.
     */
    public ParkingSensors(Vehicle vehicle) {
        super(vehicle);
        cost = 75.00;
    }
    
    @Override
    public String toString() {
        return vehicle+" Parking Sensors,";
    }
}

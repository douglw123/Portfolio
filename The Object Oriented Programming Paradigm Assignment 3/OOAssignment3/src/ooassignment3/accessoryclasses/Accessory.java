/*
 * 
 */
package ooassignment3.accessoryclasses;

import ooassignment3.vehicleclasses.Vehicle;

/**
 * This abstract class is the parent class of all concrete accessories.
 * It extends {@link Vehicle} as the decorator patten is being used.
 * @author Douglas Williams
 */
public abstract class Accessory extends Vehicle{
    
    /**
     * The child accessory or car
     */
    protected Vehicle vehicle;

    /**
     * Creates the accessory with the provided child object
     * @param vehicle a child car or an accessory
     */
    public Accessory(Vehicle vehicle) {
        this.vehicle = vehicle;
    }
 
    /**
     * Calculates the cost of the child Vehicle object and this Accessory
     * @return the cost of the child accessory or car + the cost of this accessory
     */
    @Override
    public double calculateCost() {
        return vehicle.calculateCost() + cost;
    }
}

package ooassignment3.vehicleclasses;

import ooassignment3.gearboxclasses.GearBox;
import ooassignment3.fueltypeclasses.FuelTypeInterface;

/**
 * This abstract class is the parent class of all concrete class representations of specific cars/vehicles.
 * @author Douglas Williams
 */
public abstract class Vehicle {

    
    /**
     * This constructor creates the car and sets the make and model.
     * @param make The vehicle's make.
     * @param model The vehicle's model.
     */
    public Vehicle(String make,String model) {
        this.make = make;
        this.model = model;
    }

    /**
     * Vehicle's default constructor.
     */
    public Vehicle() {
    }
    
    /**
     * The vehicle's model.
     */
    protected String model;

    /**
     *The vehicle's make.
     */
    protected String make;

    /**
     * The vehicle's miles per gallon.
     */
    protected int mpg;

    /**
     * The cost of the vehicle.
     */
    protected double cost;

    /**
     * The type of fuel/engine the vehicle uses.
     */
    protected FuelTypeInterface fuelType;

    /**
     * The type of gearbox the vehicle has.
     */
    protected GearBox gearBox;

    /**
     * Sets the fuel type.
     * @param fuelType The fuel type to be set.
     */
    public void setFuelType(FuelTypeInterface fuelType) {
        this.fuelType = fuelType;
    }

    /**
     * Sets the gearBox type.
     * @param gearBox The type of gearbox to be set.
     */
    public void setGearBox(GearBox gearBox) {
        this.gearBox = gearBox;
    }
    
    /**
     * Calculates the MPG. 
     * If the car has its fuel/engine type set, the MPG will be the base MPG + the adjustment amount from the fuel type.
     * Otherwise it just be the base MPG.
     * @return the MPG of this car.
     */
    public int calculateMPG(){
        if (fuelType != null) {
            return mpg+fuelType.getMPGAdjuster();
        }
        return mpg;
    }

    @Override
    public String toString() {
        return "This vehicle is a " + gearBox + " " + make + " " + model + " its mpg is \n" + calculateMPG() + " and " +fuelType + "\nwith";
    }
    
    /**
     * Calculates the cost of the vehicle.
     * If the car has its fuel/engine type set, the cost will be the base price * the discount associated with that fuel/engine type.
     * Otherwise it just be the base cost.
     * @return The calculated cost of the vehicle
     */
    public double calculateCost(){
        if (fuelType != null) {
            return cost * fuelType.getDiscountMultiplier();
        }
        return cost;
    }
    
}

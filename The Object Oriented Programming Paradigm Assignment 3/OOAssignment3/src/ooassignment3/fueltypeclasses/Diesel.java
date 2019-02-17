/*
 * 
 */
package ooassignment3.fueltypeclasses;

/**
 * This class represents the diesel fuel type.
 * @author Douglas Williams
 */
public class Diesel extends FuelTypeAbstract{

    /**
     * This constructor creates the fuel type and sets the mpgAdjustment which is how much this fuel/engine type effects the miles per gallon of the car.
     */
    public Diesel() {
        mpgAdjustment = 20;
    }

    
    
    @Override
    public String toString() {
        return "this car runs on diesel";
    }
    
}

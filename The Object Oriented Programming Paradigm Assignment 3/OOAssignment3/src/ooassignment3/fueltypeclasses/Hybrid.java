/*
 * 
 */
package ooassignment3.fueltypeclasses;

/**
 * This class represents the hybrid engine fuel type.
 * @author Douglas Williams
 */
public class Hybrid extends FuelTypeAbstract{

    /**
     * This constructor creates the fuel type and sets the mpgAdjustment which is how much this fuel/engine type effects the miles per gallon of the car.
     */
    public Hybrid() {
        mpgAdjustment = 25;
        discountMultiplier = 0.9;
    }


    @Override
    public String toString() {
        return "this car is a hybrid";
    }
    
}

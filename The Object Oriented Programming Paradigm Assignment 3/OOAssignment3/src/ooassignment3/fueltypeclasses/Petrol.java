/*
 * 
 */
package ooassignment3.fueltypeclasses;

/**
 * This class represents the petrol fuel type.
 * @author Douglas Williams
 */
public class Petrol extends FuelTypeAbstract{

    /**
     * This constructor creates the fuel type and sets the mpgAdjustment which is how much this fuel/engine type effects the miles per gallon of the car.
     */
    public Petrol() {
        mpgAdjustment = -10;
    }
    
    

    @Override
    public String toString() {
        return "this car runs on petrol";        
    }
    
}

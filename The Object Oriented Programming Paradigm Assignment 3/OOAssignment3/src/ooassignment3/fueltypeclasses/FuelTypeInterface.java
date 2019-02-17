package ooassignment3.fueltypeclasses;

/**
 * This is the interface version of fuel type, allowing for classes that use different default implementations than the ones provided in the abstract class variant. 
 * @author Douglas Williams
 */
public interface FuelTypeInterface {

    @Override
    public String toString();
    
    /**
     * returns the mpgAdjustment.
     * @return the amount this engine/fuel type will alter the miles per gallon of the car.
     */
    public int getMPGAdjuster();
    
    /**
     * returns the discountMultiplier
     * @return The discount this fuel/engine has on the base cost of the car. 
     */
    public double getDiscountMultiplier();
}
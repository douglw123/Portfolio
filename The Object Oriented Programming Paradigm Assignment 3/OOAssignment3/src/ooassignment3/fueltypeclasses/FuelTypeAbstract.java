package ooassignment3.fueltypeclasses;

/**
 * This abstract class is the parent class of all concrete fuel types that don't directly use the FuelTypeInterface.
 * @author Douglas Williams
 */
public class FuelTypeAbstract implements FuelTypeInterface {

    /**
     * How much this fuel/engine type effects the miles per gallon of the car.
     * This can be negative or positive.
     */
    protected int mpgAdjustment;

    /**
     * The discount this fuel/engine has on the base cost of the car. 
     * The default value is 1.0 meaning there is no discount. 
     */
    protected double discountMultiplier = 1.0;
    
    /**
     * returns the mpgAdjustment.
     * @return the amount this engine/fuel type will alter the miles per gallon of the car.
     */
    @Override
    public int getMPGAdjuster() {
        return mpgAdjustment;
    }

    /**
     * returns the discountMultiplier
     * @return The discount this fuel/engine has on the base cost of the car. 
     */
    @Override
    public double getDiscountMultiplier() {
        return discountMultiplier;
    }
    
}

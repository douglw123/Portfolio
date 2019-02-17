package ooassignment3.accessoryclasses;

import ooassignment3.vehicleclasses.SeatIbiza;
import ooassignment3.vehicleclasses.Vehicle;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Tests the {@link Accessory} class.
 * @author Douglas Williams
 */
public class AccessoryTest {
    
    private final Vehicle testVehicle = new SeatIbiza(); 
    private final Accessory testAccessory = new AirConditioning(testVehicle);
    
    public AccessoryTest() {
    }

    /**
     * Test of calculateCost method, of class Accessory.
     */
    @Test
    public void testCalculateCost() {
        System.out.println("calculateCost");
        
        assertTrue(testAccessory.calculateCost() == 15150.00);
        
    }
    
}

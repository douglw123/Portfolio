package ooassignment3.accessoryclasses;

import ooassignment3.vehicleclasses.AstonMartinDB9;
import ooassignment3.vehicleclasses.Vehicle;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Tests the {@link AccessoryFactory} class.
 * @author Douglas Williams
 */
public class AccessoryFactoryTest {
    
    private final AccessoryFactory testAccessoryFactory = new AccessoryFactory();
    
    public AccessoryFactoryTest() {
    }

    /**
     * Test of createAccessory method, of class AccessoryFactory.
     */
    @Test
    public void testCreateAccessory() {
        System.out.println("createAccessory");
        Vehicle testVehicle = new AstonMartinDB9();
        assertTrue(testAccessoryFactory.createAccessory(AccessoryEnum.AlloyWheels, testVehicle) instanceof AlloyWheels);
        Accessory testAccessory = new DigitalRadio(testVehicle);
        assertTrue(testAccessoryFactory.createAccessory(AccessoryEnum.AirConditioning, testAccessory) instanceof AirConditioning);
    }
    
}

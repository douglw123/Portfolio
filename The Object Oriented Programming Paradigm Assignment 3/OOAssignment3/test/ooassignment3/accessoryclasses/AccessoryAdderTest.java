package ooassignment3.accessoryclasses;

import ooassignment3.vehicleclasses.FordEscort;
import ooassignment3.vehicleclasses.Vehicle;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Tests the {@link AccessoryAdder} class.
 * @author Douglas Williams
 */
public class AccessoryAdderTest {
    
    private final Vehicle testVehicle = new FordEscort(); 
    private final AccessoryAdder testAccessoryAdder = new AccessoryAdder(testVehicle, AccessoryEnum.ParkingSensors);
    
    public AccessoryAdderTest() {
    }

    /**
     * Test of addAccessory method, of class AccessoryAdder.
     */
    @Test
    public void testAddAccessory() {
        System.out.println("addAccessory");
        assertTrue(testAccessoryAdder.getTopAccessory() instanceof ParkingSensors);
        testAccessoryAdder.addAccessory(AccessoryEnum.DigitalRadio);
        assertTrue(testAccessoryAdder.getTopAccessory() instanceof DigitalRadio);
    }

    /**
     * Test of getTopAccessory method, of class AccessoryAdder.
     */
    @Test
    public void testGetTopAccessory() {
        System.out.println("getTopAccessory");
        assertTrue(testAccessoryAdder.getTopAccessory() instanceof ParkingSensors);
        testAccessoryAdder.addAccessory(AccessoryEnum.DigitalRadio);
        testAccessoryAdder.addAccessory(AccessoryEnum.AlloyWheels);
        assertTrue(testAccessoryAdder.getTopAccessory() instanceof AlloyWheels);
    }
    
}

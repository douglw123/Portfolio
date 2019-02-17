package ooassignment3.vehicleclasses;

import ooassignment3.fueltypeclasses.FuelTypeAbstract;
import ooassignment3.fueltypeclasses.Petrol;
import ooassignment3.gearboxclasses.Automatic;
import ooassignment3.gearboxclasses.GearBox;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Tests the {@link Vehicle} class.
 * @author Douglas Williams
 */
public class VehicleTest {
    
    private final Vehicle testVehicle = new McLarenF1();
    
    public VehicleTest() {
    }

    /**
     * Test of setFuelType method, of class Vehicle.
     */
    @Test
    public void testSetFuelType() {
        System.out.println("setFuelType");
        FuelTypeAbstract fuelType = new Petrol();
        
        testVehicle.setFuelType(fuelType);
        assertTrue(testVehicle.toString().contains("petrol"));
    }

    /**
     * Test of setGearBox method, of class Vehicle.
     */
    @Test
    public void testSetGearBox() {
        System.out.println("setGearBox");
        GearBox gearBox = new Automatic();
        testVehicle.setGearBox(gearBox);
        assertTrue(testVehicle.toString().contains("automatic"));
    }

    /**
     * Test of calculateMPG method, of class Vehicle.
     */
    @Test
    public void testCalculateMPG() {
        System.out.println("calculateMPG");
        
        assertTrue(testVehicle.calculateMPG() == 20);
        
        FuelTypeAbstract fuelType = new Petrol();
        testVehicle.setFuelType(fuelType);
        
        assertTrue(testVehicle.calculateMPG() == 10);
        
    }

    /**
     * Test of calculateCost method, of class Vehicle.
     */
    @Test
    public void testCalculateCost() {
        System.out.println("calculateCost");
        assertEquals(1000000, testVehicle.calculateCost(), 0.01);        
    }
}

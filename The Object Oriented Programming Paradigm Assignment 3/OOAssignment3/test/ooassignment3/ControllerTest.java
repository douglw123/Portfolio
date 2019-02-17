package ooassignment3;

import ooassignment3.accessoryclasses.AccessoryEnum;
import ooassignment3.accessoryclasses.AlloyWheels;
import ooassignment3.fueltypeclasses.FuelTypeEnum;
import ooassignment3.gearboxclasses.GearBoxEnum;
import ooassignment3.vehicleclasses.AstonMartinDB9;
import ooassignment3.vehicleclasses.FordEscort;
import ooassignment3.vehicleclasses.VehicleEnum;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Tests the {@link Controller} class.
 * @author Douglas Williams
 */
public class ControllerTest {
    
    private final Controller testController = new Controller();
    
    public ControllerTest() {
    }
    
    @Before
    public void setUp() {
        VehicleEnum vehicleType = VehicleEnum.AstonMartinDB9;
        testController.createCar(vehicleType);
    }

    /**
     * Test of createCar method, of class Controller.
     */
    @Test
    public void testCreateCar() {
        System.out.println("createCar");
        assertTrue(testController.getCar() instanceof AstonMartinDB9);
        testController.createCar(VehicleEnum.FordEscort);
        assertTrue(testController.getCar() instanceof FordEscort);
    }

    /**
     * Test of getCar method, of class Controller.
     */
    @Test
    public void testGetCar() {
        System.out.println("getCar");
        assertTrue(testController.getCar() instanceof AstonMartinDB9);
        testController.addAccessory(AccessoryEnum.AlloyWheels);
        testController.addAllCarAccessories();
        assertFalse(testController.getCar() instanceof AstonMartinDB9);
        assertTrue(testController.getCar() instanceof AlloyWheels);
        
    }

    /**
     * Test of addGearBox method, of class Controller.
     */
    @Test
    public void testAddGearBox() {
        System.out.println("addGearBox");
        GearBoxEnum gearBoxType = GearBoxEnum.Manual;
        testController.addGearBox(gearBoxType);
        assertTrue(testController.getCar().toString().contains("manual"));
    }

    /**
     * Test of addFuelType method, of class Controller.
     */
    @Test
    public void testAddFuelType() {
        System.out.println("addEngineType");
        FuelTypeEnum fuelTypeEnum = FuelTypeEnum.Petrol;
        testController.addFuelType(fuelTypeEnum);
        assertTrue(testController.getCar().toString().contains("petrol"));
    }

    /**
     * Test of addAccessory method, of class Controller.
     */
    @Test
    public void testAddAccessory() {
        System.out.println("addAccessory");
        testController.addAccessory(AccessoryEnum.AirConditioning);
        testController.addAccessory(AccessoryEnum.AlloyWheels);
        assertTrue(testController.getAccessoryEnums().get(0) == AccessoryEnum.AirConditioning);
        assertTrue(testController.getAccessoryEnums().get(1) == AccessoryEnum.AlloyWheels);
    }

    /**
     * Test of removedAccessory method, of class Controller.
     */
    @Test
    public void testRemovedAccessory() {
        System.out.println("removedAccessory");
        testController.addAccessory(AccessoryEnum.AirConditioning);
        testController.addAccessory(AccessoryEnum.AlloyWheels);
        assertTrue(testController.getAccessoryEnums().size() == 2);
        testController.removedAccessory(AccessoryEnum.AirConditioning);
        assertTrue(testController.getAccessoryEnums().size() == 1);
        assertFalse(testController.getAccessoryEnums().contains(AccessoryEnum.AirConditioning));
    }

    /**
     * Test of getAccessoryEnums method, of class Controller.
     */
    @Test
    public void testGetAccessoryEnums() {
        System.out.println("getAccessoryEnums");
        assertTrue(testController.getAccessoryEnums().isEmpty());
        testController.addAccessory(AccessoryEnum.AirConditioning);
        testController.addAccessory(AccessoryEnum.AlloyWheels);
        assertTrue(testController.getAccessoryEnums().size() == 2);
        assertTrue(testController.getAccessoryEnums().contains(AccessoryEnum.AirConditioning));
        assertTrue(testController.getAccessoryEnums().contains(AccessoryEnum.AlloyWheels));
    }

    /**
     * Test of clearAccessoryEnums method, of class Controller.
     */
    @Test
    public void testClearAccessoryEnums() {
        System.out.println("clearAccessoryEnums");
        assertTrue(testController.getAccessoryEnums().isEmpty());
        testController.addAccessory(AccessoryEnum.AirConditioning);
        testController.addAccessory(AccessoryEnum.AlloyWheels);
        assertTrue(testController.getAccessoryEnums().size() == 2);
        testController.clearAccessoryEnums();
        assertTrue(testController.getAccessoryEnums().isEmpty());
    }

    /**
     * Test of addAllCarAccessories method, of class Controller.
     */
    @Test
    public void testAddAllCarAccessories() {
        System.out.println("addAllCarAccessories");
        testController.addAccessory(AccessoryEnum.ParkingSensors);
        testController.addAccessory(AccessoryEnum.DigitalRadio);
        assertFalse(testController.getCar().toString().contains("Parking Sensors"));
        assertFalse(testController.getCar().toString().contains("Digital Radio"));
        testController.addAllCarAccessories();
        assertTrue(testController.getCar().toString().contains("Parking Sensors"));
        assertTrue(testController.getCar().toString().contains("Digital Radio"));
    }
    
}

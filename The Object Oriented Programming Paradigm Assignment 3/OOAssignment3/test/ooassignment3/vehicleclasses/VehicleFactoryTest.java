package ooassignment3.vehicleclasses;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Tests the {@link VehicleFactory} class.
 * @author Douglas Williams
 */
public class VehicleFactoryTest {
    
    private final VehicleFactory testVehicleFactory = new VehicleFactory();
    
    public VehicleFactoryTest() {
    }

    /**
     * Test of createVehicle method, of class VehicleFactory.
     */
    @Test
    public void testCreateVehicle() {
        assertTrue(testVehicleFactory.createVehicle(VehicleEnum.SeatIbiza) instanceof  SeatIbiza);
        assertTrue(testVehicleFactory.createVehicle(VehicleEnum.AstonMartinDB9) instanceof  AstonMartinDB9);
        assertTrue(testVehicleFactory.createVehicle(VehicleEnum.McLarenF1) instanceof  McLarenF1);
        assertTrue(testVehicleFactory.createVehicle(VehicleEnum.FordEscort) instanceof  FordEscort);
    }
    
}

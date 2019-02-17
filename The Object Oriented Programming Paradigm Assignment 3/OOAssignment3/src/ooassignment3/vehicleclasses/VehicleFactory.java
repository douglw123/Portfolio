package ooassignment3.vehicleclasses;

/**
 * This is a factory which instantiates vehicles.
 * @author Douglas Williams
 */
public class VehicleFactory {
   
    /**
     * The factory that instantiates vehicles from the provided {@link VehicleEnum} parameter.
     * @param vehicleType The type of vehicle to be created.
     * @return The created vehicle.
     */
    public Vehicle createVehicle(VehicleEnum vehicleType){
        if (null != vehicleType) switch (vehicleType) {
            case AstonMartinDB9:
                return new AstonMartinDB9();
            case FordEscort:
                return new FordEscort();
            case SeatIbiza:
                return new SeatIbiza();
            case McLarenF1:
                return new McLarenF1();
            default:
                break;
        }
        return null;
    }
}

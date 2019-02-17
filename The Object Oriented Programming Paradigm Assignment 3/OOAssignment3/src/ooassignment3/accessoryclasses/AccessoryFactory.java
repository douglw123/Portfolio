package ooassignment3.accessoryclasses;

import ooassignment3.vehicleclasses.Vehicle;

/**
 * This is a factory which instantiates accessories.
 * @author Douglas Williams
 */
public class AccessoryFactory {

    /**
     * The factory that instantiates accessories from the provided AccessoryEnum and Vehicle parameters.
     * @param accessoryType the type of accessory to be instantiated. 
     * @param vehicleOrAccessory the child accessory or car ({@link Vehicle}).
     * @return the created accessory.
     */
    public Accessory createAccessory(AccessoryEnum accessoryType,Vehicle vehicleOrAccessory){
        if (null != accessoryType) switch (accessoryType) {
            case AirConditioning:
                return new AirConditioning(vehicleOrAccessory);
            case AlloyWheels:
                return new AlloyWheels(vehicleOrAccessory);
            case DigitalRadio:
                return new DigitalRadio(vehicleOrAccessory);
            case ParkingSensors:
                return new ParkingSensors(vehicleOrAccessory);
            default:
                break;
        }
        return null;
    }
}

package ooassignment3;

import java.util.ArrayList;
import ooassignment3.accessoryclasses.AccessoryAdder;
import ooassignment3.vehicleclasses.Vehicle;
import ooassignment3.vehicleclasses.VehicleEnum;
import ooassignment3.vehicleclasses.VehicleFactory;
import ooassignment3.accessoryclasses.AccessoryEnum;
import ooassignment3.fueltypeclasses.Diesel;
import ooassignment3.fueltypeclasses.Electric;
import ooassignment3.fueltypeclasses.FuelTypeEnum;
import ooassignment3.fueltypeclasses.Hybrid;
import ooassignment3.fueltypeclasses.Petrol;
import ooassignment3.gearboxclasses.Automatic;
import ooassignment3.gearboxclasses.GearBox;
import ooassignment3.gearboxclasses.GearBoxEnum;
import ooassignment3.gearboxclasses.Manual;
import ooassignment3.fueltypeclasses.FuelTypeInterface;

/**
 * This class uses the actions from the user received from the views to operate the application. 
 * @author Douglas Williams
 */
public class Controller {
    private AccessoryAdder accessoryAdder;
    private final VehicleFactory vehicleFactory = new VehicleFactory();
    private Vehicle car;
    private final ArrayList<AccessoryEnum> accessoryEnums = new ArrayList<>();
    
    /**
     * Creates a new vehicle instance specified by the enum {@link VehicleEnum} parameter and stores in the private car variable. This instance is created using a {@link VehicleFactory}
     * @param vehicleType the type of vehicle to be created
     */
    public void createCar(VehicleEnum vehicleType){
        car = vehicleFactory.createVehicle(vehicleType);
    }
    
    /**
     * Returns the vehicle object stored in car variable. 
     * @return This can be a car or the "top" accessory (in a decorator pattern sense) once all the accessories have been added.
     */
    public Vehicle getCar(){
        return car;
    }
    
    /**
     * Creates and sets the gearbox of the car variable.
     * @param gearBoxType the type of gear box.
     */
    public void addGearBox(GearBoxEnum gearBoxType){
        GearBox gearBox;
        if (gearBoxType == GearBoxEnum.Manual) {
            gearBox = new Manual();
        }
        else{
            gearBox = new Automatic();
        }
        car.setGearBox(gearBox);
    }
    
    /**
     * Creates and sets the fuelType of the car variable.
     * @param fuelTypeEnum the type of fuel. 
     */
    public void addFuelType(FuelTypeEnum fuelTypeEnum){
        FuelTypeInterface fuelType;
        if (null != fuelTypeEnum) switch (fuelTypeEnum) {
            case Diesel:
                fuelType = new Diesel();
                break;
            case Electric:
                fuelType = new Electric();
                break;
            case Hybrid:
                fuelType = new Hybrid();
                break;
            case Petrol:
                fuelType = new Petrol();
                break;
            default:
                fuelType = new Petrol();
                break;
        }
        else{
            fuelType = new Petrol();
        }
        car.setFuelType(fuelType);
    }
    
    /**
     * Adds an {@link AccessoryEnum} to the array. 
     * <p>
     * This needs to be stored as an enum because accessories require a child accessory or vehicle to be instantiated, also the decorator chain is not easily separated. 
     * @param accessoryType the type of accessory to be added.
     */
    public void addAccessory(AccessoryEnum accessoryType){
        accessoryEnums.add(accessoryType);
    }
    
    /**
     * Removes an {@link AccessoryEnum} from the array.
     * @param accessoryType the type of accessory to be removed
     */
    public void removedAccessory(AccessoryEnum accessoryType){
        for (AccessoryEnum accessoryEnum : accessoryEnums) {
            if (accessoryEnum == accessoryType) {
                accessoryEnums.remove(accessoryEnum);
            }
        }
    }
    
    /**
     * Returns the {@link ArrayList} of {@link AccessoryEnum}.
     * @return {@link ArrayList} of {@link AccessoryEnum}.
     */
    public ArrayList<AccessoryEnum> getAccessoryEnums(){
        return accessoryEnums;
    }
    
    /**
     * Removes all {@link AccessoryEnum} from the {@link ArrayList}.
     */
    public void clearAccessoryEnums(){
        accessoryEnums.clear();
    }
    
    /**
     * Creates the decorator chain comprising of the accessories represented with {@link AccessoryEnum} in the {@link ArrayList}.
     * Loops through the {@link ArrayList} providing the {@link AccessoryEnum} to the {@link AccessoryAdder} object 
     * Which instantiates the accessories and constructing the decorator chain.
     * The "top" accessory is then set and stored in the private car variable.
     */
    public void addAllCarAccessories(){
        if (!accessoryEnums.isEmpty()) {
            accessoryAdder = new AccessoryAdder(car, accessoryEnums.get(0));
            for (int i = 1; i < accessoryEnums.size(); i++) {
                accessoryAdder.addAccessory(accessoryEnums.get(i));
            }
            car = accessoryAdder.getTopAccessory();
        }
    }
    
}

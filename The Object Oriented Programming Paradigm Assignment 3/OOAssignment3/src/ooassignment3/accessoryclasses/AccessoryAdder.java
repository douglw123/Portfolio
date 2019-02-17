package ooassignment3.accessoryclasses;

import ooassignment3.vehicleclasses.Vehicle;

/**
 * This class constructs the decorator chain of accessories and a car, holding the instance of the top accessory in the decorator chain.
 * @author Douglas Williams
 */
public class AccessoryAdder {
    private Accessory topAccessory;
    private final AccessoryFactory accessoryFactory = new AccessoryFactory();

    /**
     * This constructor starts the decorator chain with an accessory and a child car ({@link Vehicle}).
     * @param car the {@link Vehicle} which will be at the end of the decorator chain.
     * @param firstAccessory the first accessory in the decorator chain which holds the car variable.
     */
    public AccessoryAdder(Vehicle car,AccessoryEnum firstAccessory) {
        topAccessory = accessoryFactory.createAccessory(firstAccessory, car);
    }
    
    /**
     * Adds an accessory ({@link AccessoryEnum}) to the decorator chain, which becomes the the top accessory.
     * @param accessory the accessory to be instantiated (using an {@link AccessoryFactory}) and added to the decorator chain
     */
    public void addAccessory(AccessoryEnum accessory){
        topAccessory = accessoryFactory.createAccessory(accessory, topAccessory);
    }

    /**
     * returns the top accessory.
     * @return the top accessory.
     */
    public Accessory getTopAccessory() {
        return topAccessory;
    }
    
}

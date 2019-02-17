package ooassignment3.gui;

import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javafx.application.Application;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.control.RadioButton;
import javafx.scene.control.Toggle;
import javafx.scene.control.ToggleGroup;
import javafx.scene.image.ImageView;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.text.Text;
import javafx.stage.Stage;
import ooassignment3.accessoryclasses.AccessoryEnum;
import ooassignment3.fueltypeclasses.FuelTypeEnum;
import ooassignment3.gearboxclasses.GearBoxEnum;
import ooassignment3.vehicleclasses.VehicleEnum;

/**
 * This class constructs the GUI that allows the user to make choices on a chosen car. Providing feedback on how their choice effects price and MPG. 
 * @author Douglas Williams
 */
public class AccessoryView extends Application {
    
    private final GridPane grid = new GridPane();
    private final Label costLabel = new Label("Cost: £0.00");
    private final Label mpgLabel = new Label("MPG: 0");
    private final String carURL;
    private final VBox accessoriesWithRemoveButtons = new VBox(10);
    private ComboBox accessoryComboBox;
    private final VehicleEnum chosenVehicle;
    private ToggleGroup gearBoxRadiogroup;
    private ComboBox fuelTypeComboBox;

    /**
     * This constructor creates the GUI, and from the parameters sets the variables that describe details of the car chosen from the previous GUI view
     * @param carUrl The local file location of the chosen car's image file. Should the image not be found a label will takes its place.  
     * @param chosenVehicle The chosen car.
     */
    public AccessoryView(String carUrl,VehicleEnum chosenVehicle) {
        this.carURL = carUrl;
        this.chosenVehicle = chosenVehicle;
        MainView.getController().createCar(chosenVehicle);
    }
    
    @Override
    public void start(Stage primaryStage) {
        primaryStage.setTitle("Car Builder");
        
        
        grid.setAlignment(Pos.TOP_LEFT);
        grid.setHgap(10);
        grid.setVgap(10);
        grid.setPadding(new Insets(25, 25, 25, 25));
        Scene scene = new Scene(grid, 600, 550);

        Text sceneTitle = new Text("Accessories");
        sceneTitle.setId("welcome-text");
        Button backButton = new Button("Back");
        grid.add(backButton, 0, 1);
        
        
        HBox hBox = new HBox(0, sceneTitle);
        hBox.setAlignment(Pos.CENTER);
        grid.add(hBox, 0, 0,2,1);
        
        backButton.setOnAction((ActionEvent event) -> {
            reset();
            MainView mainView = new MainView();
            mainView.start(primaryStage);
            try {
                this.stop();
            }
            catch (Exception ex) {
                Logger.getLogger(AccessoryView.class.getName()).log(Level.SEVERE, null, ex);
            }
        });
        
        ObservableList<AccessoryEnum> accessoryList
                = FXCollections.observableArrayList(
                       AccessoryEnum.AirConditioning,
                        AccessoryEnum.AlloyWheels,
                        AccessoryEnum.DigitalRadio,
                       AccessoryEnum.ParkingSensors
                );
        accessoryComboBox = new ComboBox(accessoryList);
        
        accessoryComboBox.getSelectionModel().selectFirst();
        HBox costAndMpgLables = new HBox(5, costLabel,mpgLabel);
        
        grid.add(costAndMpgLables, 1, 2);            
        
        Button addButton = new Button("Add");

        gearBoxRadiogroup = new ToggleGroup();
        
        RadioButton gearBox1 = new RadioButton("Manual");
        gearBox1.setSelected(true);
        RadioButton gearBox2 = new RadioButton("Automatic");
        gearBox1.setToggleGroup(gearBoxRadiogroup);
        gearBox2.setToggleGroup(gearBoxRadiogroup);
        gearBox1.setUserData(GearBoxEnum.Manual);
        gearBox2.setUserData(GearBoxEnum.Automatic);
        
        
        gearBoxRadiogroup.selectedToggleProperty().addListener((ObservableValue<? extends Toggle> observable, Toggle oldValue, Toggle newValue) -> {
            MainView.getController().addGearBox((GearBoxEnum) newValue.getUserData());
            updateCost();
            updateMPG();
        });

        fuelTypeComboBox = new ComboBox();
        fuelTypeComboBox.getItems().addAll(
            FuelTypeEnum.Petrol,
            FuelTypeEnum.Diesel,
            FuelTypeEnum.Electric,
            FuelTypeEnum.Hybrid
        );
        fuelTypeComboBox.getSelectionModel().selectFirst();
        
        fuelTypeComboBox.valueProperty().addListener(new ChangeListener<FuelTypeEnum>(){
            @Override
            public void changed(ObservableValue<? extends FuelTypeEnum> observable, FuelTypeEnum oldValue, FuelTypeEnum newValue) {
                MainView.getController().addFuelType((FuelTypeEnum) newValue);
                updateCost();
                updateMPG();
            }
            
        });
        
        Label toStringLabel = new Label();
        grid.add(toStringLabel, 1, 5);
        
        Button resetButton = new Button("Reset");
        resetButton.setDisable(true);
        
        Button confirmButton = new Button("Confirm");
        
        resetButton.setOnAction((ActionEvent event) -> {
            reset();
            resetButton.setDisable(true);
            confirmButton.setDisable(false);
            toStringLabel.setText("");
        });
        
        HBox radialBox = new HBox(5, gearBox1,gearBox2);
        HBox accessoryComboAndButton = new HBox(10, accessoryComboBox,addButton);
        
        VBox carEditingBox = new VBox(14, radialBox,fuelTypeComboBox,accessoryComboAndButton,confirmButton,resetButton);
        carEditingBox.setAlignment(Pos.TOP_LEFT);
        grid.add(carEditingBox, 1, 4);
        
        try {
            ImageView imageView = new ImageView(carURL);
            imageView.setId("imageViews");
            grid.add(imageView, 0, 4);
            
        }
        catch (IllegalArgumentException e) {
            Label chosenCar = new Label("Sorry the car photo was not found");
            grid.add(chosenCar, 0, 4);
        }    
        
        confirmButton.setOnAction((ActionEvent event) -> {
            MainView.getController().addAllCarAccessories();
            updateCost();
            resetButton.setDisable(false);
            confirmButton.setDisable(true); 
            toStringLabel.setText(MainView.getController().getCar().toString());
        });
        
        
        grid.add(accessoriesWithRemoveButtons, 0, 5);
        
        addButton.setOnAction((ActionEvent event) -> {
            AccessoryEnum accessoryEnumToBeAdded = (AccessoryEnum) accessoryComboBox.getValue();
            if (accessoryEnumToBeAdded != null) {
                MainView.getController().addAccessory(accessoryEnumToBeAdded);
                accessoriesWithRemoveButtons.getChildren().add(createAccessoryRemoveHbox(accessoryEnumToBeAdded));
                accessoryComboBox.getItems().remove(accessoryEnumToBeAdded);
                accessoryComboBox.getSelectionModel().selectFirst();
            }
            
        });
        
        MainView.getController().addGearBox((GearBoxEnum)gearBoxRadiogroup.getSelectedToggle().getUserData());
        MainView.getController().addFuelType((FuelTypeEnum) fuelTypeComboBox.getValue());
        updateCost();
        updateMPG();
        
        grid.setGridLinesVisible(false);

        primaryStage.setScene(scene);
        scene.getStylesheets().add(MainView.class.getResource("CarBuilderCSS.css").toExternalForm());
        primaryStage.show();
    }
    
    /**
     * Updates the cost displayed to the user.
     */
    public void updateCost(){
        double cost = MainView.getController().getCar().calculateCost();
        costLabel.setText("Cost: £"+cost);
    }
    
    /**
     * Updates the miles per gallon displayed to the user.
     */
    public void updateMPG(){
        int mpg = MainView.getController().getCar().calculateMPG();
        mpgLabel.setText("MPG: "+mpg);
    }
    
    /**
     * Allows the user to reset their choices after confirmation. 
     */
    public void reset(){
        ArrayList<AccessoryEnum> accessoryEnums = MainView.getController().getAccessoryEnums();
        if (!accessoryEnums.isEmpty()) {
            for (AccessoryEnum accessoryEnum : accessoryEnums) {
                accessoryComboBox.getItems().add(accessoryEnum);
            }
            accessoryComboBox.getSelectionModel().selectFirst();
        }
        accessoriesWithRemoveButtons.getChildren().clear();
        MainView.getController().clearAccessoryEnums();
        MainView.getController().createCar(chosenVehicle);  
        MainView.getController().addGearBox((GearBoxEnum)gearBoxRadiogroup.getSelectedToggle().getUserData());
        MainView.getController().addFuelType((FuelTypeEnum) fuelTypeComboBox.getValue());
        updateCost();
        updateMPG();
    }
    
    /**
     * Creates an accessory label with an adjacent remove button. These are held in a horizontal box.
     * The remove button allows the user to change their mind by removing a previously chosen accessory.
     * @param accessoryEnum The type of accessory the user has added
     * @return The horizontal box containing the label and paired remove button.
     */
    public HBox createAccessoryRemoveHbox(AccessoryEnum accessoryEnum){
        Label accessoryLabel = new Label(accessoryEnum.toString());
        Button removeButton = new Button("Remove");
        removeButton.setUserData(accessoryEnum);
        HBox accessoryHbox = new HBox(10, accessoryLabel,removeButton);
        accessoryHbox.setAlignment(Pos.CENTER_LEFT);
        
        removeButton.setOnAction((ActionEvent event) -> {
            AccessoryEnum accessoryEnumToBeRemoved = (AccessoryEnum) removeButton.getUserData();
            try {
                MainView.getController().removedAccessory(accessoryEnumToBeRemoved);
            }
            catch (Exception e) {
            }
            accessoriesWithRemoveButtons.getChildren().remove(accessoryHbox);
            accessoryComboBox.getItems().add(accessoryEnumToBeRemoved);
            accessoryComboBox.getSelectionModel().selectFirst();
        });
        
        return accessoryHbox;
    }
    
    
}
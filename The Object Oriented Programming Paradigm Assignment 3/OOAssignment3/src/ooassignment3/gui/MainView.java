package ooassignment3.gui;

import java.util.logging.Level;
import java.util.logging.Logger;
import javafx.application.Application;
import javafx.event.ActionEvent;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;
import javafx.scene.text.Text;
import javafx.stage.Stage;
import ooassignment3.Controller;
import ooassignment3.vehicleclasses.VehicleEnum;

/**
 * This class constructs the GUI that allows the user to chose a car.
 * It also holds a static instance of the Controller allowing other view to influence the same model. 
 * @author Douglas Williams
 */
public class MainView extends Application {
    
    private final GridPane grid = new GridPane();
    private final Label costLabel = new Label("Cost: £0.00");
    private static final Controller CONTROLLER = new Controller();
    
    @Override
    public void start(Stage primaryStage) {
        
        primaryStage.setTitle("Car Builder");
        grid.setAlignment(Pos.TOP_LEFT);
        grid.setHgap(10);
        grid.setVgap(10);
        grid.setPadding(new Insets(25, 25, 25, 25));
        Scene scene = new Scene(grid, 600, 550);
        
        Text sceneTitle = new Text("Welcome to car builder");
        sceneTitle.setId("welcome-text");
        Button backButton = new Button("Back");
        backButton.setDisable(true);
        grid.add(backButton, 0, 1);
        
        
        HBox hBox = new HBox(0, sceneTitle);
        hBox.setAlignment(Pos.CENTER);
        grid.add(hBox, 0, 0,2,1);
        
        Label chooseCar = new Label("Please choose a car");
        grid.add(chooseCar, 0, 2);
        
        grid.add(costLabel, 1, 2);
        
        
        //Aston Martin
        try {
            ImageView imageView = new ImageView("ooassignment3/gui/aston_martin.jpg");
            imageView.setId("imageViews");
            grid.add(imageView, 0, 3);
            imageView.setOnMouseClicked((MouseEvent event) -> {
                changeToAccessoryView(primaryStage,"ooassignment3/gui/aston_martin.jpg",VehicleEnum.AstonMartinDB9);
            });
        }
        catch (IllegalArgumentException e) {
            Button button = new Button("Aston Martin DB9");
            button.setPrefSize(256, 179);
            grid.add(button, 0, 3);
            button.setOnAction((ActionEvent event) -> {
                changeToAccessoryView(primaryStage,"",VehicleEnum.AstonMartinDB9);
            });
        }
        
        //Mclaren F1
        try {
            ImageView imageView2 = new ImageView("ooassignment3/gui/mclaren-f1.jpg");
            imageView2.setId("imageViews");
            grid.add(imageView2, 1, 3);
            imageView2.setOnMouseClicked((MouseEvent event) -> {
                changeToAccessoryView(primaryStage,"ooassignment3/gui/mclaren-f1.jpg",VehicleEnum.McLarenF1);
            });
        }
        catch (IllegalArgumentException e) {
            Button button2 = new Button("Mclaren F1");
            button2.setPrefSize(256, 179);
            grid.add(button2, 1, 3);
            button2.setOnAction((ActionEvent event) -> {
                changeToAccessoryView(primaryStage,"",VehicleEnum.McLarenF1);
            });
        }

        //Seat Ibiza
        try {
            ImageView imageView3 = new ImageView("ooassignment3/gui/seat-ibiza.jpg");
            imageView3.setId("imageViews");
            grid.add(imageView3, 0, 4);
            imageView3.setOnMouseClicked((MouseEvent event) -> {
                changeToAccessoryView(primaryStage,"ooassignment3/gui/seat-ibiza.jpg",VehicleEnum.SeatIbiza);
            });
        }
        catch (IllegalArgumentException e) {
            Button button3 = new Button("Seat Ibiza");
            button3.setPrefSize(256, 170);
            grid.add(button3, 0, 4);
            button3.setOnAction((ActionEvent event) -> {
                changeToAccessoryView(primaryStage,"",VehicleEnum.SeatIbiza);
            });
        }

        //Ford Escort
        try {
            ImageView imageView4 = new ImageView("ooassignment3/gui/ford-escort.jpg");
            imageView4.setId("imageViews");
            grid.add(imageView4, 1, 4);
            imageView4.setOnMouseClicked((MouseEvent event) -> {
                changeToAccessoryView(primaryStage,"ooassignment3/gui/ford-escort.jpg",VehicleEnum.FordEscort);
            });
        }
        catch (Exception e) {
            Button button4 = new Button("Ford Escort");
            button4.setPrefSize(256, 170);
            grid.add(button4, 1, 4);
            button4.setOnAction((ActionEvent event) -> {
                //CONTROLLER.getCar().
                changeToAccessoryView(primaryStage,"",VehicleEnum.FordEscort);
            });
        }

        grid.setGridLinesVisible(false);

        primaryStage.setScene(scene);
        scene.getStylesheets().add(MainView.class.getResource("CarBuilderCSS.css").toExternalForm());
        primaryStage.show();
        
    }
    
    /**
     * Updates the cost displayed to the user.
     * @param cost The new cost to display to the user
     */
    public void updateCost(double cost){
        costLabel.setText("Cost: £"+cost);
    }
    
    /**
     * Changes from this view to the accessory view. Used once a car is selected.
     * @param primaryStage The primary stage the accessory view will use.
     * @param carURL The local file location of the chosen car's image file. 
     * @param vehicleEnum The chosen car.
     */
    public void changeToAccessoryView(Stage primaryStage,String carURL,VehicleEnum vehicleEnum){
        AccessoryView accessoryView = new AccessoryView(carURL, vehicleEnum);
        accessoryView.start(primaryStage);
        try {
            this.stop();
        }
        catch (Exception ex) {
            Logger.getLogger(MainView.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    /**
     * Returns the statically stored instance of the controller.
     * @return The statically stored instance of a {@link Controller}
     */
    public static Controller getController(){
        return CONTROLLER;
    }
    
    /**
     * The main method which launches the application.
     * @param args The command line arguments. 
     */
    public static void main(String[] args) {
        launch(args);
    }
    
}

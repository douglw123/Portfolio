//
//  MapTabVC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 21/08/2017.
//  Copyright © 2017 Doug Williams. All rights reserved.
//

import UIKit
import MapKit


class MapTabVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    var doneButtonItem:UIBarButtonItem?
    
    var trackingMode:MKUserTrackingMode = .none
    
    var tappedPointOfInterest:PointOfInterest?
    
    var mapButtonItem:MKUserTrackingBarButtonItem?
    
    var locationManager:CLLocationManager!
    //var currentLocation:CLLocation?
    var currentAndLastLocation:[CLLocation?] = [nil,nil]
    
    let area:Double = 125.00
    var newPointOfInterestPin:MKPin?
    var newPointOfInterestTitle:String?
    
    let databaseHandler:DatabaseHandler = DatabaseHandler()
    let coreDataHandler:CoreDataHandler = CoreDataHandler()
    var editPointOfInterestController:EditPointOfInterestTVC?
    
    var isEditingPointOfInterestLocation:Bool = false
    
    let colours = [UIColor.red:"red", UIColor.blue:"blue", UIColor.black:"black",UIColor.green:"green"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        addMapButton()
        
    }
    
    func addMapButton() {
        mapButtonItem = MKUserTrackingBarButtonItem(mapView: mapView)
        mapButtonItem?.customView?.tintColor = UIColor.black
        mapButtonItem?.style = UIBarButtonItemStyle.plain
        //mapButtonItem?.customView?.sizeThatFits(CGSize(width: 35, height: 35))
        let roundedSquareSize = CGSize(width: 50, height: 50)
        let tabBarHeight = ((tabBarController?.tabBar.frame.size.height != nil) ? tabBarController?.tabBar.frame.size.height : 0)
        
        let originPoint: CGPoint = CGPoint(x: 0,y:mapView.frame.size.height-(roundedSquareSize.height+(tabBarHeight)!))
        
        let lighterGreyColor: UIColor = UIColor(colorLiteralRed: 125, green: 125, blue: 125, alpha: 1.0)
        
        let roundedSquare: UIView = UIView(frame: CGRect(origin: originPoint, size: roundedSquareSize))
        roundedSquare.backgroundColor = lighterGreyColor
        roundedSquare.layer.cornerRadius = 5
        roundedSquare.layer.masksToBounds = true
        
        let toolBarFrame = CGRect(origin: CGPoint(x: 3, y: 3) , size: CGSize(width: 46, height: 46))
        //You may have to subclass toolbar in order to get the right coloring
        let toolbar = UIToolbar.init(frame: toolBarFrame)
        toolbar.backgroundColor = lighterGreyColor
        let flex: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [flex, mapButtonItem!, flex]
        mapButtonItem?.customView?.sizeToFit()
        roundedSquare.addSubview(toolbar)
        mapView.addSubview(roundedSquare)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let allPins = mapView.annotations
        mapView.removeAnnotations(allPins)
        if !databaseHandler.serverConnectionAttemptInProgress {
            self.databaseHandler.synchronieLocalAndServerDatabase(synchronieCompleted:{ isSuccessful in
                OperationQueue.main.addOperation{
                    self.locationManager.startUpdatingLocation()
                    //self.addPointsOfInterestToMap()
                    //self.locationManager.stopUpdatingLocation()
                }
            })
        }
}
    
    override func viewDidAppear(_ animated: Bool) {
        if navigationBar.rightBarButtonItem != nil {
            navigationBar.rightBarButtonItem?.isEnabled = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        OperationQueue.main.addOperation{
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func addSaveButtonItem() {
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(MapTabVC.saveButtonPressed))
        doneButtonItem.isEnabled = false
        self.doneButtonItem = doneButtonItem
        navigationBar.rightBarButtonItem = doneButtonItem
    }
    func saveButtonPressed()  {
        if isEditingPointOfInterestLocation {
            editPointOfInterestController?.newLocationPin = newPointOfInterestPin
            performSegue(withIdentifier: "exitMapViewToEditPointOfInterest", sender: nil)
        }
        else {
            performSegue(withIdentifier: "exitMapViewToAddPointsOfInterest", sender: nil)
        }
        
    }
    
    func addPointsOfInterestToMap() {
        OperationQueue.main.addOperation {
//            print("no annoatations adding them ...")
            
            let pointsOfInterest = self.coreDataHandler.getAllPointsOfinterest()
            var count:Int = 0
            for pointOfInterest in pointsOfInterest {
//                print("about to add point of interest \(count) to map")
                var colour:UIColor = UIColor.red
                if self.currentAndLastLocation[0] != nil {
                    if self.isCoordinateWithinArea(latitude: pointOfInterest.latitude, longitude: pointOfInterest.longitude) {
                        colour = UIColor.green
                    }
                }
                let distanceFromUser = self.getCoordinateDistanceFromArea(latitude: pointOfInterest.latitude, longitude: pointOfInterest.longitude)
                
                let distanceFromUserString = String(format: "%.1f", distanceFromUser ?? 7893)
                //let distanceFromUserString = distanceFromUser != nil ? "\(distanceFromUser!)m" : "N/A"
                
                self.addPinToMapCurrentTheard(latitude: pointOfInterest.latitude, longitude: pointOfInterest.longitude, title: "\(pointOfInterest.title!): \(distanceFromUserString)m", subtitle: "There are \(pointOfInterest.quizzes?.count ?? 0) quizzes", colour: colour)
//                print("finished adding point of interest \(count) to map")
                count += 1
            }
//            print("there are now \(self.mapView.annotations.count) annoatations and there are \(self.coreDataHandler.getAllPointsOfinterest().count) points of interest ")
        }
    }
    
    func isCoordinateWithinArea(latitude:Double, longitude:Double) -> Bool {
        let distanceFromUser = currentAndLastLocation[0]?.distance(from: CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)))
        if (distanceFromUser?.isLess(than: area))!{
            return true
        }
        return false
    }
    
    func getCoordinateDistanceFromArea(latitude:Double, longitude:Double) -> CLLocationDistance? {
        let distanceFromUser = currentAndLastLocation[0]?.distance(from: CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)))
        return distanceFromUser
    }
    
    func updatePointsOfInterestOnLocationChange(completion: @escaping (_ updatedPins: [MKAnnotation]) -> Void) {
        OperationQueue.main.addOperation {
            
            let pins = self.mapView.annotations
            //let pinsCopy = NSArray(array: pins, copyItems: true)
            var pinsCopy = [MKAnnotation]()
            
//            print("there are \(self.mapView.annotations.count) annotations")
            var count:Int = 0
            for pin in pins {
                if pin is MKPin {
                    let mkPin:MKPin = pin as! MKPin
                    
                    count += 1
                    
                    let mkPinLatitude = mkPin.coordinate.latitude
                    let mkPinLongitude = mkPin.coordinate.longitude
                    
                    let titleArray = mkPin.title!.components(separatedBy: ":")
                    
                    let distanceFromUser = self.getCoordinateDistanceFromArea(latitude: mkPin.coordinate.latitude, longitude: mkPin.coordinate.longitude)
                    
                    let distanceFromUserString = String(format: "%.1f", distanceFromUser!)
                    
                    let modifiedTitle = "\(titleArray[0]): \(distanceFromUserString)m"
                    
//                    print("old title = \(mkPin.title!)")
//                    print(("\(count) modified title = \(modifiedTitle)"))
                    
                    let newPin = MKPin(coordinate: mkPin.coordinate, title: modifiedTitle, subtitle: mkPin.subtitle!, colour: self.isCoordinateWithinArea(latitude: mkPinLatitude, longitude: mkPinLongitude) ? UIColor.green : UIColor.red)
                    pinsCopy.append(newPin)
                    
                }
            }
            completion(pinsCopy)
        }

        
    }
    
    func addPinToMap(latitude:Double, longitude:Double, title:String, subtitle:String, colour:UIColor){
        OperationQueue.main.addOperation {
//            print("add")
            let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
            let pin = MKPin(coordinate: location, title: title, subtitle: subtitle, colour: colour)
            if colour == UIColor.yellow {
                if self.newPointOfInterestPin != nil {
                    self.removePinFromMap(pinToBeRemoved: self.newPointOfInterestPin!)
                }
                self.newPointOfInterestPin = pin
            }
            self.mapView.addAnnotation(pin)
            if self.doneButtonItem != nil {
                self.doneButtonItem?.isEnabled = true
            }
        }
    }
    
    func addPinToMapCurrentTheard(latitude:Double, longitude:Double, title:String, subtitle:String, colour:UIColor){
        
//            print("adding point to map")
            let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
            let pin = MKPin(coordinate: location, title: title, subtitle: subtitle, colour: colour)
            if colour == UIColor.yellow {
                if self.newPointOfInterestPin != nil {
                    self.removePinFromMapCurrentTheard(pinToBeRemoved: self.newPointOfInterestPin!)
                }
                self.newPointOfInterestPin = pin
            }
            self.mapView.addAnnotation(pin)
            if self.doneButtonItem != nil {
                self.doneButtonItem?.isEnabled = true
            }
        
    }

    
    func removePinFromMap(pinToBeRemoved:MKPin) {
        OperationQueue.main.addOperation {
//            print("remove")
            self.mapView.removeAnnotation(pinToBeRemoved)
        }
    }
    
    func removePinFromMapCurrentTheard(pinToBeRemoved:MKPin) {
//            print("remove")
            self.mapView.removeAnnotation(pinToBeRemoved)
    }
    
    @IBAction func revealRegionDetailsWithLongPressOnMap(sender: UILongPressGestureRecognizer) {
        if coreDataHandler.getLoggedInUser() != nil && navigationBar.rightBarButtonItem != nil {
            if sender.state != UIGestureRecognizerState.began { return }
            let touchLocation = sender.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            addPinToMap(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude, title: "New Point Of Interest", subtitle: "", colour: UIColor.yellow)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? UINavigationController {
            if let quizzesWithinPointOfInterest = controller.viewControllers.first as? QuizzesWithinPointOfInterestAreaListTVC {
                if tappedPointOfInterest != nil {
                    quizzesWithinPointOfInterest.pointOfInterest = tappedPointOfInterest
                }
            }
        }
        else if let addPointsOfInterestTVC = segue.destination as? AddPointOfInterestTVC {
            addPointsOfInterestTVC.latitude = newPointOfInterestPin?.coordinate.latitude
            addPointsOfInterestTVC.longitude = newPointOfInterestPin?.coordinate.longitude
//            if newPointOfInterestTitle != nil {
//                addPointsOfInterestTVC.titleString = newPointOfInterestTitle
//            }
        }
    }
    
}


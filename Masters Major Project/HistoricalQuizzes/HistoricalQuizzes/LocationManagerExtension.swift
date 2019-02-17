//
//  LocationManagerExtension.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 21/08/2017.
//  Copyright © 2017 Doug Williams. All rights reserved.
//

import Foundation
import MapKit


extension MapTabVC: CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        //currentLocation = location
        self.currentAndLastLocation[1] = currentAndLastLocation[0]
        self.currentAndLastLocation[0] = location
        
        //mapView.annotations.isEmpty ? addPointsOfInterestToMap() : updatePointsOfInterestOnLocationChange()
        
//        print("current and last location count is \(currentAndLastLocation.count)")
//        if currentAndLastLocation[1] != nil  {
//            print(currentAndLastLocation[0]!.distance(from: currentAndLastLocation[1]!))
//        }
        
//        if mapView.annotations.count - 1 != coreDataHandler.getAllPointsOfinterest().count {
//            print("annotations = \(mapView.annotations.count)")
//            print("points of interest = \(coreDataHandler.getAllPointsOfinterest().count)")
//            let allPins = self.mapView.annotations
//            self.mapView.removeAnnotations(allPins)
//            addPointsOfInterestToMap()
//        }
        if mapView.annotations.count <= 1 {
            if mapView.annotations.isEmpty || (mapView.annotations.first is MKUserLocation) {
                addPointsOfInterestToMap()
            }
        }
        else if currentAndLastLocation[1] != nil ? (currentAndLastLocation[0]?.distance(from: currentAndLastLocation[1]!) ?? 0 > CLLocationDistance(0.5)) : false {
            
            
            updatePointsOfInterestOnLocationChange() {
                (updatedPins: [MKAnnotation]) in
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(updatedPins)
                //print("update to points of interst was completed")
            }
        }
        
        if trackingMode == .follow {
            let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01,0.01)
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
            mapView.setRegion(region, animated: true)
            self.mapView.showsUserLocation = true
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading){
        if trackingMode == .followWithHeading {
            if(CLLocationCoordinate2DIsValid(mapView.centerCoordinate)){
                mapView.camera.heading = newHeading.trueHeading
            }
        }
    }
}

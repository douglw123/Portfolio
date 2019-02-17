//
//  MapViewExtension.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 22/08/2017.
//  Copyright © 2017 Doug Williams. All rights reserved.
//

import Foundation
import MapKit

extension MapTabVC: MKMapViewDelegate {
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MKPin {
            let identifier = "pin"
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView{
//                 print("received mkpin \(annotation.title ?? "no title") with colour \(colours[annotation.colour!] ?? "no colour") and the dequeuedView annoation has the colour \(colours[dequeuedView.pinTintColor] ?? "no colour") ")
                //print(dequeuedView.annotation?.title ?? "there was not title")
                dequeuedView.annotation = annotation
                dequeuedView.pinTintColor = annotation.colour
                if annotation.colour == UIColor.green {
                    dequeuedView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                    
                }
                else {
                    dequeuedView.rightCalloutAccessoryView = nil
                }
                
                view = dequeuedView
            }
            else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                if annotation.colour == UIColor.green {
                    view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                    
                }
                view.pinTintColor = annotation.colour ?? UIColor.red
                
                
                
//                if colours.keys.contains(annotation.colour!){
//                    print(colours[annotation.colour!]!)
//                }
//                if colours.keys.contains(view.pinTintColor){
//                    print(colours[view.pinTintColor!]!)
//                    print("\n")
//                }
                
                //print(annotation.colour ?? "nil")
                //print(view.pinTintColor)
            }
            //print(view.pinTintColor.debugDescription)
            //print(annotation.title ?? "there was no title for annoation")
            view.reloadInputViews()
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let pointOfInterestPin = view.annotation as! MKPin
        
        //print(pointOfInterestPin.title ?? "no title" )
        //print("this will begin a segue to a quiz screen")
        
        let titleAndDistance = pointOfInterestPin.title!.components(separatedBy: ":")
        
        let pointOfInterest = coreDataHandler.getPointOfInterestWithTitle(title: titleAndDistance[0])
        
        if pointOfInterest != nil {
            tappedPointOfInterest = pointOfInterest
            performSegue(withIdentifier: "showQuizzesForPointOfInterest", sender: nil)
        }
    }
    
    
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
//        print("tracking mode changed, tracking mode: \(mode.rawValue), animated: \(animated)")
        trackingMode = mode
//        if trackingMode == .none {
//            print(trackingMode)
//            OperationQueue.main.addOperation{
//                self.locationManager.stopUpdatingLocation()
//                self.locationManager.stopUpdatingHeading()
//            }
//        }
//        else if trackingMode == .follow || trackingMode == .followWithHeading {
//            OperationQueue.main.addOperation{
//                self.locationManager.startUpdatingLocation()
//                if self.trackingMode == . followWithHeading {
//                    self.locationManager.startUpdatingHeading()
//                }
//            }
//        }
    }
    
}

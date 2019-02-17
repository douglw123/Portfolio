//
//  ViewController.swift
//  NotificationSpike
//
//  Created by Doug Williams on 06/08/2017.
//  Copyright © 2017 Doug Williams. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

class ViewController: UIViewController {

    let manager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate=self as? CLLocationManagerDelegate
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (didAllow, error) in
            if didAllow {
                print("User granted permission")
            }
            else{
                print("User did not grant permission")
            }
        }
    }
    
    @IBAction func notifyButtonPressed(_ sender: UIButton) {
        notifyUser()
    }
    

    func notifyUser(){
        let content = UNMutableNotificationContent()
        content.title = "There is a quiz available in your area"
        content.subtitle = "This is subtitle, to view how its displayed"
        content.body = "The body of the notification"
        content.badge = 1
        
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 6, repeats: false)
        //let locationTrigger =UNLocationNotificationTrigger
        
        let center = CLLocationCoordinate2D(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!)
        print("Notification latitude = \(center.latitude)\n Notification longitude = \(center.longitude)")

        let region = CLCircularRegion(center: center, radius: 2000.0, identifier: "currentLocation")
        region.notifyOnEntry = true
        region.notifyOnExit = true
        let locationTrigger = UNLocationNotificationTrigger(region: region, repeats: true)
        
        let locationRequest = UNNotificationRequest(identifier: "quizAreaEntered", content: content, trigger: locationTrigger)
        
        //let request = UNNotificationRequest(identifier: "quizAvailable", content: content, trigger: trigger)
        
        
        //UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        UNUserNotificationCenter.current().add(locationRequest, withCompletionHandler: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        print("latitude = \(myLocation.latitude) \n longitude = \(myLocation.longitude)")
       }


}


//
//  MKPin.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 22/08/2017.
//  Copyright © 2017 Doug Williams. All rights reserved.
//

import Foundation
import MapKit

class MKPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var colour:UIColor?
    
    init(coordinate:CLLocationCoordinate2D, title:String, subtitle:String, colour:UIColor) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.colour = colour
    }
}

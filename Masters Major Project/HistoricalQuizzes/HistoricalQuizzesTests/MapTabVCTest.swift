//
//  MapTabVCTest.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 21/08/2017.
//  Copyright © 2017 Doug Williams. All rights reserved.
//

import XCTest
import MapKit
@testable import HistoricalQuizzes

class MapTabVCTest: XCTestCase {
    
    var mapTabVCTestObject :MapTabVC!
    let coreDataHandler = CoreDataHandler()
    
    override func setUp() {
        super.setUp()
        //mapTabVCTestObject = MapTabVC()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        mapTabVCTestObject = storyboard.instantiateViewController(withIdentifier: "mapTabVCObject") as! MapTabVC
        if(mapTabVCTestObject != nil) {
            
            mapTabVCTestObject.loadView()
            mapTabVCTestObject.viewDidLoad()
        }
    }
    
    func testMapTabVCHasMapViewObject() {
        XCTAssertNotNil(mapTabVCTestObject.mapView, "MapTabVC has no mapView object")
    }
    
    func testMapTabConformsToCLLocationManagerDelegate() {
        XCTAssert(mapTabVCTestObject.conforms(to: CLLocationManagerDelegate.self),"The mapTabVCTestObject doesn't conform to CLLocationManagerDelegate protocol")
    }
    
    func testMapTabConformsToMKMapViewDelegate() {
        XCTAssert(mapTabVCTestObject.conforms(to: MKMapViewDelegate.self),"The mapTabVCTestObject doesn't conform to MKMapViewDelegate protocol")
    }
    
    func testLocationManagerDelegateIsSet() {
        
        XCTAssertNotNil(self.mapTabVCTestObject.locationManager.delegate)
    }
    
    func testMapViewDelegateIsSet() {
        
        XCTAssertNotNil(self.mapTabVCTestObject.mapView.delegate)
    }
    
    func testAddingNoPinsToMapView() {
        let annotationsOnMap = mapTabVCTestObject.mapView.annotations
        XCTAssertEqual(annotationsOnMap.count, 0)
    }
    
    func testAddingSinglePinToMapView() {
        mapTabVCTestObject.addPinToMapCurrentTheard(latitude: 5.001, longitude: 5.001, title: "test title 1", subtitle: "test subtitle 1", colour: UIColor.black)
    
        let annotationsOnMap = mapTabVCTestObject.mapView.annotations
        XCTAssertEqual(annotationsOnMap.count, 1)
    }
    
    func testAddingMultiplePinsToMapView() {
        
        mapTabVCTestObject.addPinToMapCurrentTheard(latitude: 4.001, longitude: 4.001, title: "test title 1", subtitle: "test subtitle 1", colour: UIColor.black)
        
        mapTabVCTestObject.addPinToMapCurrentTheard(latitude: 7.001, longitude: 7.001, title: "test title 2", subtitle: "test subtitle 2", colour: UIColor.black)
        
        mapTabVCTestObject.addPinToMapCurrentTheard(latitude: 8.501, longitude: 8.501, title: "test title 3", subtitle: "test subtitle 3", colour: UIColor.black)

        let annotationsOnMap = mapTabVCTestObject.mapView.annotations
        XCTAssertEqual(annotationsOnMap.count, 3)
    }
    
    func testRemovePinFromMap(){
        
        mapTabVCTestObject.addPinToMapCurrentTheard(latitude: 4.001, longitude: 4.001, title: "test title 1", subtitle: "test subtitle 1", colour: UIColor.black)
        
        mapTabVCTestObject.addPinToMapCurrentTheard(latitude: 7.001, longitude: 7.001, title: "test title 2", subtitle: "test subtitle 2", colour: UIColor.black)
        
        let pin = mapTabVCTestObject.mapView.annotations.first
        
        //mapTabVCTestObject.removePinFromMap(pinToBeRemoved: pin as! MKPin)
        mapTabVCTestObject.removePinFromMapCurrentTheard(pinToBeRemoved: pin as! MKPin)
        let annotationsOnMap = mapTabVCTestObject.mapView.annotations
        XCTAssertEqual(annotationsOnMap.count, 1)
    }
    
    func testAddSaveButtonItem() {
        XCTAssertNil(mapTabVCTestObject.navigationBar.rightBarButtonItem)
        mapTabVCTestObject.addSaveButtonItem()
        XCTAssertNotNil(mapTabVCTestObject.navigationBar.rightBarButtonItem)
    }
    
    func testAddPointsOfInterestToMap() {
        mapTabVCTestObject.addPointsOfInterestToMap()
        
        let annotationsOnMap = mapTabVCTestObject.mapView.annotations
        XCTAssertEqual(annotationsOnMap.count, coreDataHandler.getAllPointsOfinterest().count)
    }
    
}

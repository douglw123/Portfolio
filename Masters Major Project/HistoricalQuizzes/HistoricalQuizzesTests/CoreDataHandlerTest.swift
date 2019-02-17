//
//  CoreDataHandlerTest.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 17/09/2017.
//  Copyright © 2017 Doug Williams. All rights reserved.
//

import XCTest
import CoreData
@testable import HistoricalQuizzes

class CoreDataHandlerTest: XCTestCase {
    
    var coreDataHandlerTestObject:CoreDataHandler!
    var managedContext:NSManagedObjectContext?
    
    override func setUp() {
        super.setUp()
        coreDataHandlerTestObject = CoreDataHandler()
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("access error")
            exit(EXIT_FAILURE)
        }
        managedContext = delegate.persistentContainer.viewContext
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        managedContext?.rollback()
    }
    
    
    func testAddPointOfInterest() {
        let objectsInsertedIntoManagedContextBefore = managedContext?.insertedObjects.count ?? 0
        //pointOfInterestID: Int, title: String, latitude: Double, longitude: Double
        let testPoint = coreDataHandlerTestObject.addPointOfInterest(pointOfInterestID: 7, title: "testPoint", latitude: 7.0, longitude: 9.0)
        
        let objectsInsertedIntoManagedContextAfter = managedContext?.insertedObjects.count ?? -1
        
        let numberOfInsertedObjects = objectsInsertedIntoManagedContextAfter - objectsInsertedIntoManagedContextBefore
        
        XCTAssertEqual(numberOfInsertedObjects, 1)
        
        let retrivedTestObject:PointOfInterest = managedContext?.insertedObjects.first as! PointOfInterest
        XCTAssertEqual(testPoint.pointOfInterestID, retrivedTestObject.pointOfInterestID)
    }
    
    func testAddQuiz() {
        //quizID: Int, name: String
        let objectsInsertedIntoManagedContextBefore = managedContext?.insertedObjects.count ?? 0
    
        let testQuiz = coreDataHandlerTestObject.addQuiz(quizID: 5, name: "testQuiz")
        
        let objectsInsertedIntoManagedContextAfter = managedContext?.insertedObjects.count ?? -1
        
        let numberOfInsertedObjects = objectsInsertedIntoManagedContextAfter - objectsInsertedIntoManagedContextBefore
        
        XCTAssertEqual(numberOfInsertedObjects, 1)
        
        let retrivedTestObject:Quiz = managedContext?.insertedObjects.first as! Quiz
        XCTAssertEqual(testQuiz.quizID, retrivedTestObject.quizID)
    }

    func testAddQuestion() {
        //questionID: Int, quizID: Int, questionString: String, answer: String
        let objectsInsertedIntoManagedContextBefore = managedContext?.insertedObjects.count ?? 0
        
        let testQuestion = coreDataHandlerTestObject.addQuestion(questionID: 3, quizID: 0, questionString: "test question", answer: "test answer")
        
        let objectsInsertedIntoManagedContextAfter = managedContext?.insertedObjects.count ?? -1
        
        let numberOfInsertedObjects = objectsInsertedIntoManagedContextAfter - objectsInsertedIntoManagedContextBefore
        
        XCTAssertEqual(numberOfInsertedObjects, 1)
        
        let retrivedTestObject:Question = managedContext?.insertedObjects.first as! Question
        XCTAssertEqual(testQuestion.questionID, retrivedTestObject.questionID)
    }
    
}

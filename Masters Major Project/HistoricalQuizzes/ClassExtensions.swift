//
//  ClassExtension.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 20/04/2018.
//  Copyright © 2018 Doug Williams. All rights reserved.
//

import Foundation

extension PointOfInterest {
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.dateCreated = NSDate()
    }
    
    func jsonFormat() -> JSON {
        var pointOfInterestDictionary = [String:String]()
        
        pointOfInterestDictionary["pointOfInterestID"] = "\(self.pointOfInterestID)"
        pointOfInterestDictionary["title"] = "\(self.title ?? "")"
        pointOfInterestDictionary["latitude"] = "\(self.latitude)"
        pointOfInterestDictionary["longitude"] = "\(self.longitude)"
        pointOfInterestDictionary["dateCreated"] = self.dateCreated?.formattedString() ?? ""
        pointOfInterestDictionary["userID"] = "\(self.userID)"
        
        let jsonEncodeOfPointOfInterestDictionary = JSON(pointOfInterestDictionary)
        return jsonEncodeOfPointOfInterestDictionary
    }
}

extension Quiz {
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.dateCreated = NSDate()
    }
    
    func jsonFormat() -> JSON {
        var quizDictionary = [String:String]()
        
        quizDictionary["quizID"] = "\(self.quizID)"
        quizDictionary["name"] = "\(self.name ?? "")"
        quizDictionary["dateCreated"] = self.dateCreated?.formattedString() ?? ""
        quizDictionary["userID"] = "\(self.userID)"
        
        let pointsOfInterestArray = self.pointsOfInterest?.allObjects as! [PointOfInterest]
        
        let coreDataHandler = CoreDataHandler()
        
        let dictionaryOfPoints = coreDataHandler.pointsOfInterestArrayToDictionaryArrayForUpload(pointsOfInterest: pointsOfInterestArray)
        let jsonOfPoints:JSON = JSON(dictionaryOfPoints)
        let stringRepOfJson = jsonOfPoints.rawString() ?? ""
        quizDictionary["pointsOfInterest"] = stringRepOfJson
        
        let jsonEncodeOfQuizDictionary = JSON(quizDictionary)
        return jsonEncodeOfQuizDictionary
    }
    
}
extension Question {
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.dateCreated = NSDate()
    }
    
    func jsonFormat() -> JSON {
        var questionDictionary = [String:String]()
        
        questionDictionary["questionID"] = "\(self.questionID)"
        questionDictionary["quizID"] = "\(self.quiz?.quizID ?? 0)"
        questionDictionary["question"] = "\(self.question ?? "")"
        questionDictionary["answer"] = "\(self.answer ?? "")"
        questionDictionary["dateCreated"] = self.dateCreated?.formattedString() ?? ""
        questionDictionary["userID"] = "\(self.userID)"
        
        let jsonEncodeOfQuestionDictionary = JSON(questionDictionary)
        return jsonEncodeOfQuestionDictionary
    }

    
}
extension WrongAnswer {
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.dateCreated = NSDate()
    }
    
    func jsonFormat() -> JSON {
        var wrongAnswerDictionary = [String:String]()
        
        wrongAnswerDictionary["wrongAnswerID"] = "\(self.wrongAnswerID)"
        wrongAnswerDictionary["questionID"] = "\(self.question?.questionID ?? 0)"
        wrongAnswerDictionary["wrongAnswer"] = "\(self.wrongAnswer ?? "")"
        wrongAnswerDictionary["dateCreated"] = self.dateCreated?.formattedString() ?? ""
        wrongAnswerDictionary["userID"] = "\(self.userID)"
        
        let jsonEncodeOfWrongAnswerDictionary = JSON(wrongAnswerDictionary)
        return jsonEncodeOfWrongAnswerDictionary
    }
    
}
extension PointOfInterestChangeRequest {
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.dateCreated = NSDate()
    }
    
    func jsonFormat() -> JSON {
        var pointOfInterestChangeRequestDictionary = [String:String]()
        pointOfInterestChangeRequestDictionary["userID"] = "\(self.userID)"
        pointOfInterestChangeRequestDictionary["pointOfInterestID"] = "\(self.pointOfInterestID)"
        pointOfInterestChangeRequestDictionary["message"] = self.message ?? ""
        pointOfInterestChangeRequestDictionary["dateCreated"] = self.dateCreated?.formattedString() ?? ""
        
        let jsonEncodeOfPointOfInterestChangeRequest = JSON(pointOfInterestChangeRequestDictionary)
        return jsonEncodeOfPointOfInterestChangeRequest
    }
    
}

extension QuizChangeRequest {
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.dateCreated = NSDate()
    }
    
    func jsonFormat() -> JSON {
        var quizChangeRequestDictionary = [String:String]()
        quizChangeRequestDictionary["userID"] = "\(self.userID)"
        quizChangeRequestDictionary["quizID"] = "\(self.quizID)"
        quizChangeRequestDictionary["message"] = self.message ?? ""
        quizChangeRequestDictionary["dateCreated"] = self.dateCreated?.formattedString() ?? ""
        
        let jsonEncodeOfQuizChangeRequest = JSON(quizChangeRequestDictionary)
        return jsonEncodeOfQuizChangeRequest
    }
}

extension QuestionChangeRequest {
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.dateCreated = NSDate()
    }
    
    func jsonFormat() -> JSON {
        var questionChangeRequestDictionary = [String:String]()
        questionChangeRequestDictionary["userID"] = "\(self.userID)"
        questionChangeRequestDictionary["questionID"] = "\(self.questionID)"
        questionChangeRequestDictionary["message"] = self.message ?? ""
        questionChangeRequestDictionary["dateCreated"] = self.dateCreated?.formattedString() ?? ""
        
        let jsonEncodeOfQuestionChangeRequest = JSON(questionChangeRequestDictionary)
        return jsonEncodeOfQuestionChangeRequest
    }
}

extension User {
    func jsonFormat() -> JSON {
        var userDictionary = [String:String]()
        userDictionary["username"] = self.username ?? ""
        userDictionary["password"] = self.password ?? ""
        userDictionary["firstName"] = self.firstName ?? ""
        userDictionary["lastName"] = self.lastName ?? ""
        userDictionary["email"] = self.email ?? ""
        userDictionary["isBanned"] = "\(self.isBanned)"
        
        let jsonEncodeOfUser = JSON(userDictionary)
        return jsonEncodeOfUser
    }
}

extension NSDate {
    convenience public init(dateAsString:String) throws {
        if !dateAsString.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            let date = dateFormatter.date(from: dateAsString)
            if date != nil {
                let timeSince1970 = date?.timeIntervalSince1970
                self.init(timeIntervalSince1970:timeSince1970!)
            }
            else{
                throw NSDateStringError.invalidStringFormat(invalidString: dateAsString)
            }
        }
        else{
            throw NSDateStringError.emptyString
        }
    }
    
    func formattedString() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let dateAsString = dateFormatter.string(from: self as Date)
        return dateAsString
    }
}

extension Array {
    
    //code based on https://stackoverflow.com/questions/40010345/in-swift-an-efficient-function-that-separates-an-array-into-2-arrays-based-on-a
    
    func separate(predicate: (Generator.Element) -> Bool) -> (matching: [Generator.Element], notMatching: [Generator.Element]) {
        var groups: ([Generator.Element],[Generator.Element]) = ([],[])
        for element in self {
            if predicate(element) {
                groups.0.append(element)
            } else {
                groups.1.append(element)
            }
        }
        return groups
    }
    
    mutating func removeIf(predicate: (Element) -> Bool) -> [Element] {
        let groups = self.separate(predicate: predicate)
        self = groups.notMatching
        return groups.matching
    }
    
}

enum NSDateStringError: Error {
    case invalidStringFormat(invalidString:String)
    case emptyString
}


//
//  DatabaseHandler.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 28/08/2017.
//  Copyright © 2017 Doug Williams. All rights reserved.
//

import Foundation
import UIKit

class DatabaseHandler {
    var session:URLSession?
    let urlStringPath:String = "http://127.0.0.1:8888/database_php/MainServerSidePDO.php"
    
    var serverConnectionAttemptInProgress:Bool = false
    let coreDataHandler = CoreDataHandler()
    static var userInfo:(isLoggedIn:Bool,isAdministrator:Bool) = (isLoggedIn:false,isAdministrator:false)
    
    init() {
        let user = coreDataHandler.getLoggedInUser()
        if user != nil {
            if user?.userID != 0 {
                DatabaseHandler.userInfo = (isLoggedIn:true,isAdministrator:(user?.isAdministrator)!)
            }
        }
        else{
            DatabaseHandler.userInfo = (isLoggedIn:false,isAdministrator:false)
        }
    }
    
    func login(username:String, password:String,loginSuccessful: @escaping (_ isSuccessful:Bool) -> ()) {
        var isSuccessful:Bool = false
        let userFromCoreData = coreDataHandler.getUserWith(username: username)
        
        if userFromCoreData == nil{
            getUser(username: username, password: password) { user in
                if user != nil {
                    isSuccessful = true
                    DatabaseHandler.userInfo = (isLoggedIn:true,isAdministrator:(user?.isAdministrator)!)
                    user?.isLoggedIn = true
                }
                else{
                    isSuccessful = false
                    DatabaseHandler.userInfo = (isLoggedIn:false,isAdministrator:false)
                }
                
                loginSuccessful(isSuccessful)
            }
        }
        else{
            isSuccessful = true
            DatabaseHandler.userInfo = (isLoggedIn:true,isAdministrator:(userFromCoreData?.isAdministrator)!)
            userFromCoreData?.isLoggedIn = true
            loginSuccessful(isSuccessful)
        }
    }
    
    func registerUser(user:User,completionHandler: @escaping (_ registerSuccessful: Bool,_ databaseViolationReason:String?) -> ()) {
        let post:PostDictionary = PostDictionary()
        post.add(key: "type", data: "register")
        
        let stringRepresentationOfNewUserJson:String = user.jsonFormat().rawString() ?? ""
        post.add(key: "newUserJSON", data: stringRepresentationOfNewUserJson)
        
        postDataToServer(postString: post.getAsString()) { (json,isSuccesful) in
            

            if isSuccesful{
                
                for (_, violation) in json["databaseViolations"] {
                    
                    if violation["table"].stringValue == "Users" {
                        print("register failed")
                        completionHandler(false,violation["reason"].stringValue)
                        return
                    }
                    else{
                        print(violation.debugDescription)
                    }
                    
                }
                print(json["userRegister"].debugDescription)
                for (_, user) in json["userRegister"] {
                    let username:String = user["username"].stringValue
                    let userID:Int16 = user["userID"].int16Value
                    let newUser = self.coreDataHandler.getUserWith(username: username)
                    newUser?.userID = userID
                    print("user registered with id \(newUser?.userID ?? 0)")
                }
                completionHandler(true,nil)
            }
            else{
                completionHandler(false,nil)
            }
        }
    }

    
    
    func logOut() {
        coreDataHandler.removeAllUsers()
        DatabaseHandler.userInfo = (isLoggedIn:false,isAdministrator:false)
    }
    
    func getUser(username:String,password:String,completionHandler: @escaping (_ user: User?) -> ()) {
        postDataToServer(postString: "username=\(username)&password=\(password)&type=user") { (json,isSuccesful) in
            
            var userLoggedIn:User?
            if isSuccesful{
                for (_, user) in json["user"] {
                    let firstName:String = user["firstname"].stringValue
                    let lastName:String = user["lastname"].stringValue
                    let username:String = user["username"].stringValue
                    let email:String = user["email"].stringValue
                    let userID:Int = user["userid"].intValue
                    let isAdministrator:Bool = user["isadministrator"].boolValue
                    
                    userLoggedIn = self.coreDataHandler.addUser(userID: userID, username: username, password: password, email: email, firstName: firstName, lastName: lastName, isAdministrator: isAdministrator)
                }
            }
            completionHandler(userLoggedIn)
        }
    }
    
    func getAllUser(adminUser:User,completionHandler: @escaping (_ users: [User]?) -> ()) {
        
        var usersArray:[User]?
        if adminUser.isAdministrator {
            let post:PostDictionary = PostDictionary()
            post.add(key: "type", data: "getAllUsers")
            post.add(key: "adminUser", data: adminUser.jsonFormat().rawString() ?? "")
            
            postDataToServer(postString: post.getAsString()) { (json,isSuccesful) in
                
                if isSuccesful{
                    usersArray = [User]()
                    for (_, user) in json["user"] {
                        let firstName:String = user["firstname"].stringValue
                        let lastName:String = user["lastname"].stringValue
                        let username:String = user["username"].stringValue
                        let email:String = user["email"].stringValue
                        let userID:Int = user["userid"].intValue
                        let isAdministrator:Bool = user["isadministrator"].boolValue
                        let isBanned:Bool = user["isbanned"].boolValue
                        
                        usersArray!.append(self.coreDataHandler.createUserNotInMangedContext(userID: userID, username: username, email: email, firstName: firstName, lastName: lastName, isAdministrator: isAdministrator, isBanned: isBanned))
                    }
                    completionHandler(usersArray)
                }
                else{
                    completionHandler(usersArray)
                }
            }
        }
    }
    
    func changeBanStatusForUser(user:User,adminUser:User,completionHandler: @escaping (_ newStatus: Bool?) -> ()) {
        user.isBanned = !user.isBanned
        var newStatus:Bool?
        if adminUser.isAdministrator {
            let post:PostDictionary = PostDictionary()
            post.add(key: "type", data: "changeBanStatus")
            post.add(key: "adminUser", data: adminUser.jsonFormat().rawString() ?? "")
            post.add(key: "user", data: user.jsonFormat().rawString() ?? "")
            
            postDataToServer(postString: post.getAsString()) { (json,isSuccesful) in
                
                if isSuccesful{
                    newStatus = json["isbanned"].bool
                    completionHandler(newStatus)
                }
                else{
                    completionHandler(newStatus)
                }
            }
        }
    }
    
    func synchronieLocalAndServerDatabase(synchronieCompleted: @escaping (_ isSuccessful:Bool) -> Void) {
        let maxLocalIds = self.coreDataHandler.getMaxLocals()
        let post:PostDictionary = PostDictionary()
        post.add(key: "type", data: "sync")
        post.add(key: "pointsOfInterestMaxIDLocal", data: "\(maxLocalIds.maxPointOfinterestID)")
        post.add(key: "quizzesMaxIDLocal", data: "\(maxLocalIds.maxQuizID)")
        post.add(key: "questionsMaxIDLocal", data: "\(maxLocalIds.maxQuestionID)")
        post.add(key: "pointOfInterestChangeRequestsIDLocal", data: "\(maxLocalIds.maxPointOfInterestChangeRequestID)")
        post.add(key: "quizChangeRequestsIDLocal", data: "\(maxLocalIds.maxQuizChangeRequestID)")
        post.add(key: "questionChangeRequestsIDLocal", data: "\(maxLocalIds.maxQuestionChangeRequestID)")
        
        post.add(key: "pointOfInterestTombstoneMaxIDLocal", data: coreDataHandler.retrieveFromUserDefaults(key: "pointOfInterestTombstoneMaxIDLocal"))
        post.add(key: "quizTombstoneMaxIDLocal", data: coreDataHandler.retrieveFromUserDefaults(key: "quizTombstoneMaxIDLocal"))
        post.add(key: "questionTombstoneMaxIDLocal", data: coreDataHandler.retrieveFromUserDefaults(key: "questionTombstoneMaxIDLocal"))
        post.add(key: "lastConnectionTimestampLocal", data: coreDataHandler.retrieveFromUserDefaults(key: "lastConnectionTimestampLocal"))
        post.add(key: "wrongAnswerMaxIDLocal", data: "\(maxLocalIds.maxWrongAnswerID)")
        post.add(key: "wrongAnswerTombstoneMaxIDLocal", data: coreDataHandler.retrieveFromUserDefaults(key: "wrongAnswerTombstoneMaxIDLocal"))
        
        //change requests tombstone
        post.add(key: "pointOfInterestChangeRequestTombstoneMaxIDLocal", data: coreDataHandler.retrieveFromUserDefaults(key: "pointOfInterestChangeRequestTombstoneMaxIDLocal"))
        
        post.add(key: "quizChangeRequestTombstoneMaxIDLocal", data: coreDataHandler.retrieveFromUserDefaults(key: "quizChangeRequestTombstoneMaxIDLocal"))
        
        post.add(key: "questionChangeRequestTombstoneMaxIDLocal", data: coreDataHandler.retrieveFromUserDefaults(key: "questionChangeRequestTombstoneMaxIDLocal"))
        
        /*
         Points of interest inserts
        */
        let pointsOfInterestNotAddedToServer = coreDataHandler.getPointsNotAddedToServer()
        let jsonEncodeOfPointsNotAddedToServer = JSON(pointsOfInterestNotAddedToServer!)
        let stringRepresentationOfPointsNotAddToServerJson:String = jsonEncodeOfPointsNotAddedToServer.rawString() ?? ""
        post.add(key: "pointOfInterestJSON", data: stringRepresentationOfPointsNotAddToServerJson)
        
        /*
         Quizzes inserts
         */
        
        let quizzesNotAddedToServer = coreDataHandler.getQuizzesNotAddedToServer()
        
        let jsonEncodeOfQuizzesNotAddedToServer = JSON(quizzesNotAddedToServer!)
        let stringRepresentationOfQuizzesNotAddToServerJson:String = jsonEncodeOfQuizzesNotAddedToServer.rawString() ?? ""
        
        post.add(key: "quizzesJSON", data: stringRepresentationOfQuizzesNotAddToServerJson)
        
        /*
         Questions inserts
         */
        
        let questionsNotAddedToServer = coreDataHandler.getQuestionsNotAddedToServer()
        
        let jsonEncodeOfQuestionsNotAddedToServer = JSON(questionsNotAddedToServer!)
        let stringRepresentationOfQuestinosNotAddedToServerJson:String = jsonEncodeOfQuestionsNotAddedToServer.rawString() ?? ""
        
        post.add(key: "questionsJSON", data: stringRepresentationOfQuestinosNotAddedToServerJson)
        
        /*
         Wrong Answers inserts
         */
        
        let wrongAnswersNotAddedToServer = coreDataHandler.getWrongAnswersNotAddedToServer()
        
        let jsonEncodeOfWrongAnswersNotAddedToServer = JSON(wrongAnswersNotAddedToServer!)
        let stringRepresentationOfWrongAnswersNotAddedToServerJson:String = jsonEncodeOfWrongAnswersNotAddedToServer.rawString() ?? ""
        
        post.add(key: "wrongAnswersJSON", data: stringRepresentationOfWrongAnswersNotAddedToServerJson)
        
        /* 
        Point of interest change requests inserts
        */
        
        let pointsOfinterestChangeRequests = coreDataHandler.getPointsOfInterestChangeRequestsNotAddedToServer()
        
        let jsonEncodeOfpointsOfinterestChangeRequests = JSON(pointsOfinterestChangeRequests)
        let stringRepresentationOfPointsOfinterestChangeRequestsNotAddedToServerJson:String = jsonEncodeOfpointsOfinterestChangeRequests.rawString() ?? ""
        
        post.add(key: "changeRequestsPointOfInterestJSON", data: stringRepresentationOfPointsOfinterestChangeRequestsNotAddedToServerJson)
        
        /*
         Quizzes change requests inserts
         */
        
        let quizzesChangeRequests = coreDataHandler.getQuizzesChangeRequestsNotAddedToServer()
        
        let jsonEncodeOfQuizzesChangeRequests = JSON(quizzesChangeRequests)
        let stringRepresentationOfQuizzesChangeRequestsNotAddedToServerJson:String = jsonEncodeOfQuizzesChangeRequests.rawString() ?? ""
        
        post.add(key: "changeRequestsQuizzesJSON", data: stringRepresentationOfQuizzesChangeRequestsNotAddedToServerJson)
        
        /*
         Questions change requests inserts
         */
        
        let questionsChangeRequests = coreDataHandler.getQuestionsChangeRequestsNotAddedToServer()
        
        let jsonEncodeOfQuestionsChangeRequests = JSON(questionsChangeRequests)
        let stringRepresentationOfQuestionsChangeRequestsNotAddedToServerJson:String = jsonEncodeOfQuestionsChangeRequests.rawString() ?? ""
        
        post.add(key: "changeRequestsQuestionsJSON", data: stringRepresentationOfQuestionsChangeRequestsNotAddedToServerJson)
        
        
        /*
         Deletions
        */
        
        //points of interest
        
        let pointsOfInterestIDsToBeDeleted = coreDataHandler.getPointsOfInterestMarkedForDeletion()
        let jsonEncodeOfPointsOfInterestIDs = JSON(pointsOfInterestIDsToBeDeleted)
        let stringRepresentationOfPointsOfInterestIDsToBeDeleted = jsonEncodeOfPointsOfInterestIDs.rawString() ?? ""
        
        post.add(key: "pointOfInterestIDsToBeDeletedJSON", data: stringRepresentationOfPointsOfInterestIDsToBeDeleted)
        
        //Quizzes
        
        let quizIDsToBeDeleted = coreDataHandler.getQuizzesMarkedForDeletion()
        let jsonEncodeOfQuizIDs = JSON(quizIDsToBeDeleted)
        let stringRepresentationOfQuizIDsToBeDeleted = jsonEncodeOfQuizIDs.rawString() ?? ""
        
        post.add(key: "quizIDsToBeDeletedJSON", data: stringRepresentationOfQuizIDsToBeDeleted)
        
        //Questions
        
        let questionIDsToBeDeleted = coreDataHandler.getQuestionsMarkedForDeletion()
        let jsonEncodeOfQuestionIDs = JSON(questionIDsToBeDeleted)
        let stringRepresentationOfQuestionIDsToBeDeleted = jsonEncodeOfQuestionIDs.rawString() ?? ""
        
        post.add(key: "questionIDsToBeDeletedJSON", data: stringRepresentationOfQuestionIDsToBeDeleted)
        
        //Point of interest change requests
        
        let pointOfInterestChangeRequestIDsToBeDeleted = coreDataHandler.getPointOfInterestChangeRequestsMarkedForDeletion()
        let jsonEncodeOfPointOfInterestChangeRequestIDs = JSON(pointOfInterestChangeRequestIDsToBeDeleted)
        let stringRepresentationOfPointOfInterestChangeRequestIDsToBeDeleted = jsonEncodeOfPointOfInterestChangeRequestIDs.rawString() ?? ""
        
        post.add(key: "pointOfInterestChangeRequestIDsToBeDeletedJSON", data: stringRepresentationOfPointOfInterestChangeRequestIDsToBeDeleted)
        
        //Quiz change requests
        
        let quizChangeRequestIDsToBeDeleted = coreDataHandler.getQuizChangeRequestsMarkedForDeletion()
        let jsonEncodeOfQuizChangeRequestIDs = JSON(quizChangeRequestIDsToBeDeleted)
        let stringRepresentationOfQuizChangeRequestIDsToBeDeleted = jsonEncodeOfQuizChangeRequestIDs.rawString() ?? ""
        
        post.add(key: "quizChangeRequestIDsToBeDeletedJSON", data: stringRepresentationOfQuizChangeRequestIDsToBeDeleted)
        
        //Question change requests
        
        let questionChangeRequestIDsToBeDeleted = coreDataHandler.getQuestionChangeRequestsMarkedForDeletion()
        let jsonEncodeOfQuestionChangeRequestIDs = JSON(questionChangeRequestIDsToBeDeleted)
        let stringRepresentationOfQuestionChangeRequestIDsToBeDeleted = jsonEncodeOfQuestionChangeRequestIDs.rawString() ?? ""
        
        post.add(key: "questionChangeRequestIDsToBeDeletedJSON", data: stringRepresentationOfQuestionChangeRequestIDsToBeDeleted)

        
        /*
         Updates
         points of interest
        */
        
        let pointsOfInterestToBeUpdatedArray = self.coreDataHandler.getPointsOfInterestUpdates()
        let jsonEncodeOfPointsToBeUpdated = JSON(pointsOfInterestToBeUpdatedArray)
        let stringRepresentationOfPointsToBeUpdated = jsonEncodeOfPointsToBeUpdated.rawString() ?? ""
        
        post.add(key: "pointsOfInterestToBeUpdatedJSON", data: stringRepresentationOfPointsToBeUpdated)
        
        //quizzes
        
        let quizzesToBeUpdatedArray = self.coreDataHandler.getQuizUpdates()
        let jsonEncodeOfQuizzesToBeUpdated = JSON(quizzesToBeUpdatedArray)
        let stringRepresentationOfQuizzesToBeUpdated = jsonEncodeOfQuizzesToBeUpdated.rawString() ?? ""
        
        post.add(key: "quizzesToBeUpdatedJSON", data: stringRepresentationOfQuizzesToBeUpdated)
        
        //questions
        
        let questionsToBeUpdatedArray = self.coreDataHandler.getQuestionUpdates()
        let jsonEncodeOfQuestionsToBeUpdated = JSON(questionsToBeUpdatedArray)
        let stringRepresentationOfQuestionsToBeUpdated = jsonEncodeOfQuestionsToBeUpdated.rawString() ?? ""
        
        post.add(key: "questionsToBeUpdatedJSON", data: stringRepresentationOfQuestionsToBeUpdated)

        //wrong answers
        
        let wrongAnswersToBeUpdatedArray = self.coreDataHandler.getWrongAnswerUpdates()
        let jsonEncodeOfWrongAnswersToBeUpdated = JSON(wrongAnswersToBeUpdatedArray)
        let stringRepresentationOfWrongAnswersToBeUpdated = jsonEncodeOfWrongAnswersToBeUpdated.rawString() ?? ""
        
        post.add(key: "wrongAnswersToBeUpdatedJSON", data: stringRepresentationOfWrongAnswersToBeUpdated)
        
        //begin post
        
        postDataToServer(postString: post.getAsString()) { (json, isSuccessful) in
            if isSuccessful {
                let user = self.coreDataHandler.getLoggedInUser()
                
                for (_, pointOfInterest) in json["pointsOfInterest"] {
                    let pointOfInterestID:Int = pointOfInterest["pointofinterestid"].intValue
                    let title:String = pointOfInterest["title"].stringValue
                    let latitude:Double = Double(String(format: "%.6f", pointOfInterest["latitude"].doubleValue))!
                    let longitude:Double = Double(String(format: "%.6f", pointOfInterest["longitude"].doubleValue))!
                    
                    var isNewPoint:Bool = true
                    for point in pointsOfInterestNotAddedToServer! {
                        
                        if(Double(point["latitude"]!)!.isEqual(to: latitude) ) && (Double(point["longitude"]!)!.isEqual(to: longitude) ){
                            isNewPoint = false
                            break
                        }
                    }
                    var addedPointOfInterest:PointOfInterest
                    
                    if isNewPoint{
                        
                        addedPointOfInterest = self.coreDataHandler.addPointOfInterest(pointOfInterestID: pointOfInterestID, title: title, latitude: latitude, longitude: longitude)
                        //print("title = \(title) latitude \(latitude) longitude = \(longitude)")
                        
                    }
                    else {

                        //change id's to set ones from server
                        addedPointOfInterest = self.coreDataHandler.getPointOfInterestWithTitle(title: title)!
                        addedPointOfInterest.pointOfInterestID = Int16(pointOfInterestID)
                        //print(addedPointOfInterest.pointOfInterestID)
                    }
                    let userID = pointOfInterest["userid"].int16Value
                    let loggedInUserID = user?.userID
                    addedPointOfInterest.userID = userID
                    if loggedInUserID != nil {
                        if userID == loggedInUserID {
                            addedPointOfInterest.user = user
                            
                        }
                    }
                }
                for (_, quiz) in json["quizzes"] {
                    
                    let quizID:Int = quiz["quizid"].intValue
                    let name:String = quiz["name"].stringValue
                    let dateCreatedString:String = quiz["datecreatedondevicetimestamp"].stringValue
                    let userID = quiz["userid"].int16Value
                    let loggedInUserID = user?.userID
                    
                    let isNewQuiz:Bool = self.coreDataHandler.isQuizNewWithNameCreatedOn(name: name, createdOn: dateCreatedString)
                   
                    var addedQuiz:Quiz?
                    
                    if isNewQuiz{
                        addedQuiz = self.coreDataHandler.addQuiz(quizID: quizID, name: name)
                        addedQuiz?.userID = userID
                        if loggedInUserID != nil {
                            if userID == loggedInUserID {
                                addedQuiz?.user = user
                            }
                        }
                        
                        do {
                            let convertedDateCreated = try NSDate(dateAsString: dateCreatedString)
                            addedQuiz?.dateCreated = convertedDateCreated
                        }
                        catch NSDateStringError.emptyString{
                            print("date string was empty")
                            //addedQuiz?.dateCreated = nil
                        }
                        catch NSDateStringError.invalidStringFormat(let invalidString){
                            print("date string was in wrong format --> \(invalidString)")
                            //addedQuiz?.dateCreated = nil
                        }
                        catch{
                            print("an unforeseen error occurred \(error)")
                            //addedQuiz?.dateCreated = nil
                        }
                        
                    }
                    else {
                        addedQuiz = self.coreDataHandler.getQuizWithNameCreatedOn(name: name, createdOn:dateCreatedString)
                        if addedQuiz != nil {
                            addedQuiz?.quizID = Int16(quizID)
                            addedQuiz?.userID = userID
                            if loggedInUserID != nil {
                                if userID == loggedInUserID {
                                    addedQuiz?.user = user
                                }
                            }
                        }
                    }
                }
                self.coreDataHandler.saveManagedContext()
                
                for (_, pointOfInterestQuizzes) in json["pointsOfInterestQuizzes"] {
                    let pointOfInterestID:Int = pointOfInterestQuizzes["pointofinterestid"].intValue
                    let quizID:Int = pointOfInterestQuizzes["quizid"].intValue
                    
                    let pointOfInterest = self.coreDataHandler.getPointOfInterestWithID(pointOfInterestID: pointOfInterestID)
                    let quiz = self.coreDataHandler.getQuizWithID(quizID: quizID)
                    if quiz != nil && pointOfInterest != nil {
                        pointOfInterest?.addToQuizzes(quiz!)
                    }
                }
                self.coreDataHandler.saveManagedContext()
                for (_, question) in json["questions"] {
                    let questionID:Int = question["questionid"].intValue
                    let quizID:Int = question["quizid"].intValue
                    let questionString:String = question["question"].stringValue
                    let answer:String = question["answer"].stringValue
                    let dateCreatedString:String = question["datecreatedondevicetimestamp"].stringValue
                    let userID = question["userid"].int16Value
                    let loggedInUserID = user?.userID
                    
                    var retrievedQuestionIfExists:Question? = self.coreDataHandler.getQuestionWithQuestionStringCreatedOn(questionString: questionString, createdOn: dateCreatedString)
                    
                    if retrievedQuestionIfExists == nil{
                        retrievedQuestionIfExists = self.coreDataHandler.addQuestion(questionID: questionID, quizID: quizID, questionString: questionString, answer: answer)
                        retrievedQuestionIfExists?.userID = userID
                        if loggedInUserID != nil {
                            if userID == loggedInUserID {
                                retrievedQuestionIfExists?.user = user
                            }
                        }
                        
                        do {
                            let convertedDateCreated = try NSDate(dateAsString: dateCreatedString)
                            retrievedQuestionIfExists?.dateCreated = convertedDateCreated
                        }
                        catch NSDateStringError.emptyString{
                            print("date string was empty")
                        }
                        catch NSDateStringError.invalidStringFormat(let invalidString){
                            print("date string was in wrong format --> \(invalidString)")
                        }
                        catch{
                            print("an unforeseen error occurred \(error)")
                        }
                    }
                    else {
                        retrievedQuestionIfExists?.questionID = Int16(questionID)
                        if loggedInUserID != nil {
                            if userID == loggedInUserID {
                                retrievedQuestionIfExists?.user = user
                            }
                        }
                    }

                }
                //wrong answers
                self.coreDataHandler.saveManagedContext()
                
                for (_, wrongAnswer) in json["wrongAnswers"] {
                    
                    let wrongAnswerID:Int = wrongAnswer["wronganswerid"].intValue
                    let questionID:Int = wrongAnswer["questionid"].intValue
                    let wrongAnswerString:String = wrongAnswer["wronganswer"].stringValue
                    let dateCreatedString:String = wrongAnswer["datecreatedondevicetimestamp"].stringValue
                    let userID = wrongAnswer["userid"].int16Value
                    let loggedInUserID = user?.userID
                    
                    var retrievedWrongAnswerIfExists:WrongAnswer? = self.coreDataHandler.getWrongAnswerWithWrongAnswerStringCreatedOn(wrongAnswerString: wrongAnswerString, createdOn: dateCreatedString)
                    
                    if retrievedWrongAnswerIfExists == nil{
//                        print("wrong answer was new \(wrongAnswerString)")
                        retrievedWrongAnswerIfExists = self.coreDataHandler.addWrongAnswer(wrongAnswerID: wrongAnswerID, questionID: questionID, wrongAnswerString: wrongAnswerString)
                        retrievedWrongAnswerIfExists?.userID = userID
                        if loggedInUserID != nil {
                            if userID == loggedInUserID {
                                retrievedWrongAnswerIfExists?.user = user
                            }
                        }
                        
                        do {
                            let convertedDateCreated = try NSDate(dateAsString: dateCreatedString)
                            retrievedWrongAnswerIfExists?.dateCreated = convertedDateCreated
                        }
                        catch NSDateStringError.emptyString{
                            print("date string was empty")
                        }
                        catch NSDateStringError.invalidStringFormat(let invalidString){
                            print("date string was in wrong format --> \(invalidString)")
                        }
                        catch{
                            print("an unforeseen error occurred \(error)")
                        }
                        
                    }
                    else {
                        retrievedWrongAnswerIfExists?.wrongAnswerID = Int16(wrongAnswerID)
                        if loggedInUserID != nil {
                            if userID == loggedInUserID {
                                retrievedWrongAnswerIfExists?.user = user
                            }
                        }
                    }
                }
                /*
                 pointsOfInterestChangeRequests
                */
                for (_, pointOfInterestChangeRequest) in json["pointsOfInterestChangeRequests"] {
                    
                    let pointOfInterestChangeRequestID:Int = pointOfInterestChangeRequest["pointofinterestchangerequestid"].intValue
                    let userID = pointOfInterestChangeRequest["userid"].int16Value
                    let pointOfInterestID:Int = pointOfInterestChangeRequest["pointofinterestid"].intValue
                    let message:String = pointOfInterestChangeRequest["message"].stringValue
                    let dateCreatedString:String = pointOfInterestChangeRequest["datecreatedondevicetimestamp"].stringValue
                    
                    let loggedInUserID = user?.userID
                    
                    
                    var retrievedPointOfInterestChangeRequestIfExists:PointOfInterestChangeRequest? = self.coreDataHandler.getPointOfInterestChangeRequestWithMessageCreatedOn(message: message, createdOn: dateCreatedString)

                    if retrievedPointOfInterestChangeRequestIfExists == nil{
                        retrievedPointOfInterestChangeRequestIfExists = self.coreDataHandler.addPointOfInterestChangeRequest(pointOfInterestChangeRequestID: pointOfInterestChangeRequestID, pointOfInterest: self.coreDataHandler.getPointOfInterestWithID(pointOfInterestID: pointOfInterestID)!, user: nil, message: message)
                        
                        retrievedPointOfInterestChangeRequestIfExists?.userID = userID
                        if loggedInUserID != nil {
                            if userID == loggedInUserID {
                                retrievedPointOfInterestChangeRequestIfExists?.user = user
                            }
                        }
                        
                        do {
                            let convertedDateCreated = try NSDate(dateAsString: dateCreatedString)
                            retrievedPointOfInterestChangeRequestIfExists?.dateCreated = convertedDateCreated
                        }
                        catch NSDateStringError.emptyString{
                            print("date string was empty")
                        }
                        catch NSDateStringError.invalidStringFormat(let invalidString){
                            print("date string was in wrong format --> \(invalidString)")
                        }
                        catch{
                            print("an unforeseen error occurred \(error)")
                        }
                        
                    }
                    else {
                        retrievedPointOfInterestChangeRequestIfExists?.pointOfInterestChangeRequestID = Int16(pointOfInterestChangeRequestID)
                        if loggedInUserID != nil {
                            if userID == loggedInUserID {
                                retrievedPointOfInterestChangeRequestIfExists?.user = user
                            }
                        }
                    }
                }
                
                /*
                 quizzesChangeRequests
                 */
                for (_, quizChangeRequest) in json["quizzesChangeRequests"] {
                    
                    let quizChangeRequestID:Int = quizChangeRequest["quizchangerequestid"].intValue
                    let userID = quizChangeRequest["userid"].int16Value
                    let quizID:Int = quizChangeRequest["quizid"].intValue
                    let message:String = quizChangeRequest["message"].stringValue
                    let dateCreatedString:String = quizChangeRequest["datecreatedondevicetimestamp"].stringValue
                    
                    let loggedInUserID = user?.userID
                    
                    var retrievedQuizChangeRequestIfExists:QuizChangeRequest? = self.coreDataHandler.getQuizChangeRequestWithMessageCreatedOn(message: message, createdOn: dateCreatedString)
                    
                    if retrievedQuizChangeRequestIfExists == nil{
                        retrievedQuizChangeRequestIfExists = self.coreDataHandler.addQuizChangeRequest(quizChangeRequestID: quizChangeRequestID, quiz: self.coreDataHandler.getQuizWithID(quizID: quizID)!, user: nil, message: message)
                        
                        retrievedQuizChangeRequestIfExists?.userID = userID
                        if loggedInUserID != nil {
                            if userID == loggedInUserID {
                                retrievedQuizChangeRequestIfExists?.user = user
                            }
                        }
                        
                        do {
                            let convertedDateCreated = try NSDate(dateAsString: dateCreatedString)
                            retrievedQuizChangeRequestIfExists?.dateCreated = convertedDateCreated
                        }
                        catch NSDateStringError.emptyString{
                            print("date string was empty")
                        }
                        catch NSDateStringError.invalidStringFormat(let invalidString){
                            print("date string was in wrong format --> \(invalidString)")
                        }
                        catch{
                            print("an unforeseen error occurred \(error)")
                        }
                        
                    }
                    else {
                        retrievedQuizChangeRequestIfExists?.quizChangeRequestID = Int16(quizChangeRequestID)
                        if loggedInUserID != nil {
                            if userID == loggedInUserID {
                                retrievedQuizChangeRequestIfExists?.user = user
                            }
                        }
                    }
                }
                
                /*
                 questionsChangeRequests
                 */
                for (_, questionChangeRequest) in json["questionsChangeRequests"] {
                    
                    let questionChangeRequestID:Int = questionChangeRequest["questionchangerequestid"].intValue
                    let userID = questionChangeRequest["userid"].int16Value
                    let questionID:Int = questionChangeRequest["questionid"].intValue
                    let message:String = questionChangeRequest["message"].stringValue
                    let dateCreatedString:String = questionChangeRequest["datecreatedondevicetimestamp"].stringValue
                    
                    let loggedInUserID = user?.userID
                    
                    var retrievedQuestionChangeRequestIfExists:QuestionChangeRequest? = self.coreDataHandler.getQuestionChangeRequestWithMessageCreatedOn(message: message, createdOn: dateCreatedString)
                    
                    if retrievedQuestionChangeRequestIfExists == nil {
                        
//                        print("Question Change Request was new \(message)")
                        retrievedQuestionChangeRequestIfExists = self.coreDataHandler.addQuestionChangeRequest(questionChangeRequestID: questionChangeRequestID, question: self.coreDataHandler.getQuestionWithID(questionID: questionID)!, user: nil, message: message)
                        
                        retrievedQuestionChangeRequestIfExists?.userID = userID
                        if loggedInUserID != nil {
                            if userID == loggedInUserID {
                                retrievedQuestionChangeRequestIfExists?.user = user
                            }
                        }
                        
                        do {
                            let convertedDateCreated = try NSDate(dateAsString: dateCreatedString)
                            retrievedQuestionChangeRequestIfExists?.dateCreated = convertedDateCreated
                        }
                        catch NSDateStringError.emptyString{
                            print("date string was empty")
                        }
                        catch NSDateStringError.invalidStringFormat(let invalidString){
                            print("date string was in wrong format --> \(invalidString)")
                        }
                        catch{
                            print("an unforeseen error occurred \(error)")
                        }
                        
                    }
                    else {
//                        print("Question Change Request was NOT new \(message) and has the id \(questionChangeRequestID)")
                        retrievedQuestionChangeRequestIfExists?.questionChangeRequestID = Int16(questionChangeRequestID)
                        if loggedInUserID != nil {
                            if userID == loggedInUserID {
                                retrievedQuestionChangeRequestIfExists?.user = user
                            }
                        }
                    }
                }

            
                //pointsOfInterestTombstone
                for (_, pointOfInterest) in json["pointsOfInterestTombstone"] {
                    let pointOfInterestID:Int = pointOfInterest["pointofinterestid"].intValue
                    let pointOfInterestTombstoneID = pointOfInterest["pointofinteresttombstoneid"].intValue
                    
//                    print("point of interest with id -> \(pointOfInterestID) is going to be deleted")
                    
                    self.coreDataHandler.removePointOfInterestWith(pointOfInterestID: pointOfInterestID)
                    
//                    print("point of interest with id -> \(pointOfInterestID) has been deleted")
                    
                    if pointOfInterestTombstoneID > Int(self.coreDataHandler.retrieveFromUserDefaults(key: "pointOfInterestTombstoneMaxIDLocal"))!{
                        
//                        print("tomb stone id (\(pointOfInterestTombstoneID)) is being updated in the core data")
                        
                        self.coreDataHandler.storeInUserDefaults(key: "pointOfInterestTombstoneMaxIDLocal", data: "\(pointOfInterestTombstoneID)")
                    }
                    self.coreDataHandler.saveManagedContext()
                }
                
                //quizTombstoneMaxIDLocal
                for (_, quiz) in json["quizTombstone"] {
                    let quizID:Int = quiz["quizid"].intValue
                    let quizTombstoneID:Int = quiz["quiztombstoneid"].intValue
                    self.coreDataHandler.removeQuizWith(quizID: quizID)
                    if quizTombstoneID > Int(self.coreDataHandler.retrieveFromUserDefaults(key: "quizTombstoneMaxIDLocal"))!{
                        self.coreDataHandler.storeInUserDefaults(key: "quizTombstoneMaxIDLocal", data: "\(quizTombstoneID)")
                    }
                }
                //questionsTombstone
                for (_, question) in json["questionsTombstone"] {
                    let questionID:Int = question["questionid"].intValue
                    let questionTombstoneID:Int = question["questiontombstoneid"].intValue
                    
                    self.coreDataHandler.removeQuestionWith(questionID: questionID)
                    if questionTombstoneID > Int(self.coreDataHandler.retrieveFromUserDefaults(key: "questionTombstoneMaxIDLocal"))!{
                        self.coreDataHandler.storeInUserDefaults(key: "questionTombstoneMaxIDLocal", data: "\(questionTombstoneID)")
                    }
                }
                //wrongAnswersTombstone
                for (_, wrongAnswer) in json["wrongAnswersTombstone"] {
                    let wrongAnswerID:Int = wrongAnswer["wronganswerid"].intValue
                    let wrongAnswerTombstoneID:Int = wrongAnswer["wronganswertombstoneid"].intValue
                    
                    self.coreDataHandler.removeWrongAnswerWith(wrongAnswerID: wrongAnswerID)
                    if wrongAnswerTombstoneID > Int(self.coreDataHandler.retrieveFromUserDefaults(key: "wrongAnswerTombstoneMaxIDLocal"))!{
                        self.coreDataHandler.storeInUserDefaults(key: "wrongAnswerTombstoneMaxIDLocal", data: "\(wrongAnswerTombstoneID)")
                    }
                }
                //point of interest change request tombstones
                for (_, pointOfInterestChangeRequest) in json["pointOfInterestChangeRequestsTombstone"] {
                    let pointOfInterestChangeRequestID:Int = pointOfInterestChangeRequest["pointofinterestchangerequestid"].intValue
                    let pointOfInterestChangeRequestTombstoneID:Int = pointOfInterestChangeRequest["pointofinterestchangerequesttombstoneid"].intValue
                    
                    self.coreDataHandler.removePointOfInterestChangeRequestWith(pointOfInterestChangeRequestID: pointOfInterestChangeRequestID)
                    self.coreDataHandler.saveManagedContext()
                    if pointOfInterestChangeRequestTombstoneID > Int(self.coreDataHandler.retrieveFromUserDefaults(key: "pointOfInterestChangeRequestTombstoneMaxIDLocal"))!{
                        self.coreDataHandler.storeInUserDefaults(key: "pointOfInterestChangeRequestTombstoneMaxIDLocal", data: "\(pointOfInterestChangeRequestTombstoneID)")
                    }
                }
                
                //quiz change request tombstones
                
                for (_, quizChangeRequest) in json["quizChangeRequestsTombstone"] {
                    let quizChangeRequestID:Int = quizChangeRequest["quizchangerequestid"].intValue
                    let quizChangeRequestTombstoneID:Int = quizChangeRequest["quizchangerequesttombstoneid"].intValue
                    
                    self.coreDataHandler.removeQuizChangeRequestWith(quizChangeRequestID: quizChangeRequestID)
                    self.coreDataHandler.saveManagedContext()
                    if quizChangeRequestTombstoneID > Int(self.coreDataHandler.retrieveFromUserDefaults(key: "quizChangeRequestTombstoneMaxIDLocal"))!{
                        self.coreDataHandler.storeInUserDefaults(key: "quizChangeRequestTombstoneMaxIDLocal", data: "\(quizChangeRequestTombstoneID)")
                    }
                }
                
                //question change request tombstones
                
                for (_, questionChangeRequest) in json["questionChangeRequestsTombstone"] {
                    let questionChangeRequestID:Int = questionChangeRequest["questionchangerequestid"].intValue
                    let questionChangeRequestTombstoneID:Int = questionChangeRequest["questionchangerequesttombstoneid"].intValue
                    
                    self.coreDataHandler.removeQuestionChangeRequestWith(questionChangeRequestID: questionChangeRequestID)
                    self.coreDataHandler.saveManagedContext()
                    if questionChangeRequestTombstoneID > Int(self.coreDataHandler.retrieveFromUserDefaults(key: "questionChangeRequestTombstoneMaxIDLocal"))!{
                        self.coreDataHandler.storeInUserDefaults(key: "questionChangeRequestTombstoneMaxIDLocal", data: "\(questionChangeRequestTombstoneID)")
                    }
                }
                
                self.coreDataHandler.saveManagedContext()
                
                //updatePointsOfInterest
                for (_, pointOfInterest) in json["updatePointsOfInterest"] {
                    let pointOfInterestID:Int = pointOfInterest["pointofinterestid"].intValue
                    let title:String = pointOfInterest["title"].stringValue
                    let latitude:Double = pointOfInterest["latitude"].doubleValue
                    let longitude:Double = pointOfInterest["longitude"].doubleValue
                    
                    let pointOfInterestToUpdate = self.coreDataHandler.getPointOfInterestWithID(pointOfInterestID: pointOfInterestID)
                    
                    pointOfInterestToUpdate?.title = title
                    pointOfInterestToUpdate?.latitude = latitude
                    pointOfInterestToUpdate?.longitude = longitude
                    
//                    print("title = \(title) latitude \(latitude) longitude = \(longitude)")
                }
                //updateQuizzes
                for (_, quiz) in json["updateQuizzes"] {
                    let quizID:Int = quiz["quizid"].intValue
                    let name:String = quiz["name"].stringValue
                    
                    let quizToUpdate = self.coreDataHandler.getQuizWithID(quizID: quizID)
                    quizToUpdate?.name = name
                }
                //updateQuestions
                for (_, question) in json["updateQuestions"] {
                    let questionID:Int = question["questionid"].intValue
                    let quizID:Int = question["quizid"].intValue
                    let questionString:String = question["question"].stringValue
                    let answer:String = question["answer"].stringValue
                    
                    let questionToUpdate = self.coreDataHandler.getQuestionWithID(questionID: questionID)
                    questionToUpdate?.quiz = self.coreDataHandler.getQuizWithID(quizID: quizID)
                    questionToUpdate?.question = questionString
                    questionToUpdate?.answer = answer
                }
                //updateWrongAnswers
                for (_, wrongAnswer) in json["updateWrongAnswers"] {
                    let wrongAnswerID:Int = wrongAnswer["wronganswerid"].intValue
                    let questionID:Int = wrongAnswer["questionid"].intValue
                    let wrongAnswerString:String = wrongAnswer["wronganswer"].stringValue
                    
                    
                    let wrongAnswerToUpdate = self.coreDataHandler.getWrongAnswerWithID(wrongAnswerID: wrongAnswerID)
                    wrongAnswerToUpdate?.question = self.coreDataHandler.getQuestionWithID(questionID: questionID)
                    wrongAnswerToUpdate?.wrongAnswer = wrongAnswerString
                }
                
                for (_, violation) in json["databaseViolations"] {
                    
                    if violation["table"].stringValue == "PointsOfInterest" {
                        print("is point of interest")
                        for pointOfinterest in pointsOfInterestNotAddedToServer! {
                            print("for point of interest \(pointOfinterest["title"] ?? "no title")\n")
                            print(violation["unique_attribute"].stringValue)
                            print(pointOfinterest["title"] == violation["unique_attribute"].stringValue)
                            
                            if pointOfinterest["title"] == violation["unique_attribute"].stringValue {
                                let object = self.coreDataHandler.getPointOfInterestWithTitle(title: violation["unique_attribute"].stringValue)
                                
                                self.coreDataHandler.removeObjectFromManagedContext(object: object!)
                                print("removed \(violation["unique_attribute"].stringValue) due to \(violation["reason"])")
                            }
                        }
                    }
                    else{
                        print(violation.debugDescription)
                    }
                    
                }
                
                self.coreDataHandler.storeInUserDefaults(key: "lastConnectionTimestampLocal", data: json["lastConnectionTimestampLocal"].stringValue)
                
                self.coreDataHandler.saveManagedContext()
                //self.coreDataHandler.printAllObjects()
                synchronieCompleted(true)
            }
            else{
                synchronieCompleted(false)
            }
        }
    }
    
    func postDataToServer(postString:String, completionHandler: @escaping (_ json:JSON,_ wasSuccessful:Bool) -> ()) {
        //serverConnectionAttemptInProgress = true
        //code based on https://stackoverflow.com/questions/39643334/how-do-you-write-a-completion-handler-in-swift-3
        //https://stackoverflow.com/questions/25203556/returning-data-from-async-call-in-swift-function
        //https://stackoverflow.com/questions/40014830/function-with-datatask-returning-a-value
        //post data source url
        let url:URL = URL(string: urlStringPath)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("fundamental networking error=\(String(describing: error))")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.serverConnectionAttemptInProgress = false
                completionHandler(JSON.null,false)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200 for ok, but it is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            do {
                guard let json = try? JSON(data: data) else {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.serverConnectionAttemptInProgress = false
                    print("could not change data to json")
                    print(data.debugDescription)
                    completionHandler(JSON.null,false)
                    //exit(EXIT_FAILURE)
                    return
                }
                completionHandler(json,true)
                
            }
            DispatchQueue.main.async { // Correct
               UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            self.serverConnectionAttemptInProgress = false
        }
        task.resume()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.serverConnectionAttemptInProgress = true
    }
    
}

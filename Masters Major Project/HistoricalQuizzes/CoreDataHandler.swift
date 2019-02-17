//
//  CoreDataHandler.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 16/09/2017.
//  Copyright © 2017 Doug Williams. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHandler  {
    var managedContext:NSManagedObjectContext?
    var fetchedResultsControllerQuiz:NSFetchedResultsController<Quiz>!
    var fetchedResultsControllerPointOfInterest:NSFetchedResultsController<PointOfInterest>!
    var fetchedResultsControllerPointOfInterestChangeRequest:NSFetchedResultsController<PointOfInterestChangeRequest>!
    var fetchedResultsControllerQuizzesChangeRequests:NSFetchedResultsController<QuizChangeRequest>!
    var fetchedResultsControllerQuestionsChangeRequests:NSFetchedResultsController<QuestionChangeRequest>!
    var fetchedResultsControllerQuestion:NSFetchedResultsController<Question>!
    var fetchedResultsControllerWrongAnswer:NSFetchedResultsController<WrongAnswer>!
    var fetchedResultsControllerUser:NSFetchedResultsController<User>!
    let defaults = UserDefaults.standard
    
    init() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("access error")
            exit(EXIT_FAILURE)
        }
        managedContext = delegate.persistentContainer.viewContext
    }
    func addPointOfInterest(pointOfInterestID:Int,title:String,latitude:Double,longitude:Double) -> PointOfInterest{
        let pointOfinterest = PointOfInterest(entity: PointOfInterest.entity(), insertInto: managedContext)
        
        pointOfinterest.pointOfInterestID = Int16(pointOfInterestID)
        pointOfinterest.title = title
        pointOfinterest.latitude = latitude
        pointOfinterest.longitude = longitude
        
        return pointOfinterest
    }
    
    func addPointOfInterestChangeRequest(pointOfInterestChangeRequestID:Int, pointOfInterest:PointOfInterest, user:User?, message:String) -> PointOfInterestChangeRequest{
        let pointOfinterestChangeRequest = PointOfInterestChangeRequest(entity: PointOfInterestChangeRequest.entity(), insertInto: managedContext)
        
        pointOfinterestChangeRequest.pointOfInterestChangeRequestID = Int16(pointOfInterestChangeRequestID)
        pointOfinterestChangeRequest.pointOfInterestID = pointOfInterest.pointOfInterestID
        pointOfinterestChangeRequest.pointOfInterest = pointOfInterest
        pointOfinterestChangeRequest.user = user
        pointOfinterestChangeRequest.userID = user == nil ? 0 : (user?.userID)!
        pointOfinterestChangeRequest.message = message
        
        return pointOfinterestChangeRequest
    }
    
    func addQuizChangeRequest(quizChangeRequestID:Int, quiz:Quiz, user:User?, message:String) -> QuizChangeRequest{
        let quizChangeRequest = QuizChangeRequest(entity: QuizChangeRequest.entity(), insertInto: managedContext)
        
        quizChangeRequest.quizChangeRequestID = Int16(quizChangeRequestID)
        quizChangeRequest.quizID = quiz.quizID
        quizChangeRequest.quiz = quiz
        quizChangeRequest.user = user
        quizChangeRequest.userID = user == nil ? 0 : (user?.userID)!
        quizChangeRequest.message = message
        
        return quizChangeRequest
    }
    
    //question
    
    func addQuestionChangeRequest(questionChangeRequestID:Int, question:Question, user:User?, message:String) -> QuestionChangeRequest{
        let questionChangeRequest = QuestionChangeRequest(entity: QuestionChangeRequest.entity(), insertInto: managedContext)
        
        questionChangeRequest.questionChangeRequestID = Int16(questionChangeRequestID)
        questionChangeRequest.questionID = question.questionID
        questionChangeRequest.question = question
        questionChangeRequest.user = user
        questionChangeRequest.userID = user == nil ? 0 : (user?.userID)!
        questionChangeRequest.message = message
        
        return questionChangeRequest
    }
    
    func addQuiz(quizID:Int, name:String) -> Quiz {
        let quiz = Quiz(entity: Quiz.entity(), insertInto: managedContext)
        
        quiz.quizID = Int16(quizID)
        quiz.name = name
        
        return quiz
    }
    
    func printAllObjects() {
        print("----------------------------")
        let maxLocalIds = getMaxLocals()
        print("Max point of interest id: \(maxLocalIds.maxPointOfinterestID) Max number of point of interest objects: \(fetchedResultsControllerPointOfInterest.fetchedObjects!.count)")
        print("Max quiz id: \(maxLocalIds.maxQuizID) Max number of quiz objects: \(fetchedResultsControllerQuiz.fetchedObjects!.count)")
        print("Max question id: \(maxLocalIds.maxQuestionID)  Max number of question objects: \(fetchedResultsControllerQuestion.fetchedObjects!.count)")
        print("Max wrong answer id: \(maxLocalIds.maxWrongAnswerID)  Max number of wrong answer objects: \(fetchedResultsControllerWrongAnswer.fetchedObjects!.count)")
        print("----------------------------")
    }
    
    func getMaxLocals() -> (maxPointOfinterestID:Int, maxQuizID:Int, maxQuestionID:Int,maxWrongAnswerID:Int, maxPointOfInterestChangeRequestID:Int, maxQuizChangeRequestID:Int, maxQuestionChangeRequestID:Int) {
        loadPointsOfInterestCoreData()
        let maxPointOfinterestID:Int = Int(fetchedResultsControllerPointOfInterest.fetchedObjects!.first?.pointOfInterestID ?? 0)
        
        loadQuizzesCoreData()
        let maxQuizID:Int = Int(fetchedResultsControllerQuiz.fetchedObjects!.first?.quizID ?? 0)
        
        loadQuestionsCoreData()
        let maxQuestionID:Int = Int(fetchedResultsControllerQuestion.fetchedObjects!.first?.questionID ?? 0)
        
        loadWrongAnswersCoreData()
        let maxWrongAnswerID:Int = Int(fetchedResultsControllerWrongAnswer.fetchedObjects!.first?.wrongAnswerID ?? 0)
        
        
        loadPointOfInterestChangeRequestCoreData()
        let maxPointOfInterestChangeRequestID:Int = Int(fetchedResultsControllerPointOfInterestChangeRequest.fetchedObjects!.first?.pointOfInterestChangeRequestID ?? 0)
        
        loadQuizzesChangeRequestsCoreData()
        let maxQuizChangeRequestID:Int = Int(fetchedResultsControllerQuizzesChangeRequests.fetchedObjects!.first?.quizChangeRequestID ?? 0)
        
        loadQuestionsChangeRequestsCoreData()
        let maxQuestionChangeRequestID:Int = Int(fetchedResultsControllerQuestionsChangeRequests.fetchedObjects!.first?.questionChangeRequestID ?? 0)
        
        return (maxPointOfinterestID, maxQuizID, maxQuestionID, maxWrongAnswerID, maxPointOfInterestChangeRequestID, maxQuizChangeRequestID, maxQuestionChangeRequestID)
    }
    
    func addQuestion(questionID:Int, quizID:Int, questionString:String, answer:String) -> Question {
        let question = Question(entity: Question.entity(), insertInto: managedContext)
        
        question.questionID = Int16(questionID)
        question.quiz = getQuizWithID(quizID: quizID)
        question.question = questionString
        question.answer = answer
        
        return question
        
    }
    
    func addWrongAnswer(wrongAnswerID:Int, questionID:Int, wrongAnswerString:String) -> WrongAnswer {
        let wrongAnswer = WrongAnswer(entity: WrongAnswer.entity(), insertInto: managedContext)
        
        wrongAnswer.wrongAnswerID = Int16(wrongAnswerID)
        wrongAnswer.question = getQuestionWithID(questionID: questionID)
        wrongAnswer.wrongAnswer = wrongAnswerString
        
        return wrongAnswer
        
    }
    
    func addUser(userID:Int, username:String, password:String,email:String, firstName:String,lastName:String,isAdministrator:Bool) -> User {
        let user = User(entity: User.entity(), insertInto: managedContext)
        //getQuestionWithID(questionID: questionID)
        user.userID = Int16(userID)
        user.username = username
        user.password = password
        user.firstName = firstName
        user.lastName = lastName
        user.email = email
        user.isAdministrator = isAdministrator
        saveManagedContext()
        return user
        
    }
    
    func createUserNotInMangedContext(userID:Int, username:String,email:String, firstName:String,lastName:String,isAdministrator:Bool,isBanned:Bool) -> User {
        let user = User(entity: User.entity(), insertInto: nil)
        user.userID = Int16(userID)
        user.username = username
        user.firstName = firstName
        user.lastName = lastName
        user.email = email
        user.isAdministrator = isAdministrator
        user.isBanned = isBanned
        return user
    }

    
    func getPointOfInterestWithTitle(title:String) -> PointOfInterest? {
        loadPointsOfInterestCoreData()
        for pointOfInterest in fetchedResultsControllerPointOfInterest.fetchedObjects! {
            if pointOfInterest.title! == title  {
                return pointOfInterest
            }
        }
        return nil
    }

    
    func getPointOfInterestWithID(pointOfInterestID:Int) -> PointOfInterest? {
        loadPointsOfInterestCoreData()
        for pointOfInterest in fetchedResultsControllerPointOfInterest.fetchedObjects! {
            if pointOfInterest.pointOfInterestID == Int16(pointOfInterestID)  {
                return pointOfInterest
            }
        }
        return nil
    }
    
    
    func getQuizWithID(quizID:Int) -> Quiz? {
        loadQuizzesCoreData()
        for quiz in fetchedResultsControllerQuiz.fetchedObjects! {
            if quiz.quizID == Int16(quizID)  {
                return quiz
            }
        }
        return nil
    }
    
    func getQuestionWithID(questionID:Int) -> Question? {
        loadQuestionsCoreData()
        for question in fetchedResultsControllerQuestion.fetchedObjects! {
            if question.questionID == Int16(questionID)  {
                return question
            }
        }
        return nil
    }
    
    func getQuestionWithQuestionStringCreatedOn(questionString:String,createdOn:String) -> Question? {
        loadQuestionsCoreData()
        
        //must convert to prevent this issue 2018-05-25 11:43:49.56 | 2018-05-25 11:43:49.560 to insure correct format is provided
        do {
            let convertedCreatedOn = try NSDate(dateAsString: createdOn).formattedString()
            for question in fetchedResultsControllerQuestion.fetchedObjects! {
                if question.question! == questionString && (question.dateCreated?.formattedString() == convertedCreatedOn) {
                    return question
                }
            }
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
        
        return nil
    }
    
    func getQuizWithNameCreatedOn(name:String,createdOn:String) -> Quiz? {
        loadQuizzesCoreData()
        
        //must convert to prevent this issue 2018-05-25 11:43:49.56 | 2018-05-25 11:43:49.560 to insure correct format is provided
        do {
            let convertedCreatedOn = try NSDate(dateAsString: createdOn).formattedString()
            for quiz in fetchedResultsControllerQuiz.fetchedObjects! {
                if quiz.name! == name && (quiz.dateCreated?.formattedString() == convertedCreatedOn) {
                    return quiz
                }
            }
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
        
        return nil
    }

    func isQuizNewWithNameCreatedOn(name:String,createdOn:String) -> Bool {
        for quiz in getQuizzesNotAddedToServer()! {
            if(quiz["name"] == name && quiz["dateCreated"] == createdOn){
                return false
            }
        }
        return true
    }
    
    func getWrongAnswerWithID(wrongAnswerID:Int) -> WrongAnswer? {
        loadWrongAnswersCoreData()
        for wrongAnswer in fetchedResultsControllerWrongAnswer.fetchedObjects! {
            if wrongAnswer.wrongAnswerID == Int16(wrongAnswerID)  {
                return wrongAnswer
            }
        }
        return nil
    }
    
    func getPointOfInterestChangeRequestWithID(pointOfInterestChangeRequestID:Int) -> PointOfInterestChangeRequest? {
        loadPointOfInterestChangeRequestCoreData()
        for pointOfInterestChangeRequest in fetchedResultsControllerPointOfInterestChangeRequest.fetchedObjects! {
            if pointOfInterestChangeRequest.pointOfInterestChangeRequestID == Int16(pointOfInterestChangeRequestID)  {
                return pointOfInterestChangeRequest
            }
        }
        return nil
    }
    
    //quiz
    
    func getQuizChangeRequestWithID(quizChangeRequestID:Int) -> QuizChangeRequest? {
        loadQuizzesChangeRequestsCoreData()
        for quizChangeRequest in fetchedResultsControllerQuizzesChangeRequests.fetchedObjects! {
            if quizChangeRequest.quizChangeRequestID == Int16(quizChangeRequestID)  {
                return quizChangeRequest
            }
        }
        return nil
    }
    
    //question
    
    func getQuestionChangeRequestWithID(questionChangeRequestID:Int) -> QuestionChangeRequest? {
        loadQuestionsChangeRequestsCoreData()
        for questionChangeRequest in fetchedResultsControllerQuestionsChangeRequests.fetchedObjects! {
            if questionChangeRequest.questionChangeRequestID == Int16(questionChangeRequestID)  {
                return questionChangeRequest
            }
        }
        return nil
    }
    
    func getWrongAnswerWithWrongAnswerStringCreatedOn(wrongAnswerString:String,createdOn:String) -> WrongAnswer? {
        loadWrongAnswersCoreData()
        
        //must convert to prevent this issue 2018-05-25 11:43:49.56 | 2018-05-25 11:43:49.560 to insure correct format is provided
        do {
            let convertedCreatedOn = try NSDate(dateAsString: createdOn).formattedString()
            for wrongAnswer in fetchedResultsControllerWrongAnswer.fetchedObjects! {
                if wrongAnswer.wrongAnswer! == wrongAnswerString && (wrongAnswer.dateCreated?.formattedString() == convertedCreatedOn) {
                    return wrongAnswer
                }
            }
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
        
        return nil
    }
    
    /*
     Change requests
    */
    
    func getPointOfInterestChangeRequestWithMessageCreatedOn(message:String,createdOn:String) -> PointOfInterestChangeRequest? {
        loadPointOfInterestChangeRequestCoreData()
        
        //must convert to prevent this issue 2018-05-25 11:43:49.56 | 2018-05-25 11:43:49.560 to insure correct format is provided
        do {
            let convertedCreatedOn = try NSDate(dateAsString: createdOn).formattedString()
            for pointOfInterestChangeRequest in fetchedResultsControllerPointOfInterestChangeRequest.fetchedObjects! {
                if pointOfInterestChangeRequest.message! == message && (pointOfInterestChangeRequest.dateCreated?.formattedString() == convertedCreatedOn) {
                    return pointOfInterestChangeRequest
                }
            }
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
        
        return nil
    }
    
    //quiz
    
    func getQuizChangeRequestWithMessageCreatedOn(message:String,createdOn:String) -> QuizChangeRequest? {
        loadQuizzesChangeRequestsCoreData()
        
        //must convert to prevent this issue 2018-05-25 11:43:49.56 | 2018-05-25 11:43:49.560 to insure correct format is provided
        do {
            let convertedCreatedOn = try NSDate(dateAsString: createdOn).formattedString()
            for quizChangeRequest in fetchedResultsControllerQuizzesChangeRequests.fetchedObjects! {
                if quizChangeRequest.message! == message && (quizChangeRequest.dateCreated?.formattedString() == convertedCreatedOn) {
                    return quizChangeRequest
                }
            }
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
        
        return nil
    }
    
    //question
    
    func getQuestionChangeRequestWithMessageCreatedOn(message:String,createdOn:String) -> QuestionChangeRequest? {
        loadQuestionsChangeRequestsCoreData()
        
        //must convert to prevent this issue 2018-05-25 11:43:49.56 | 2018-05-25 11:43:49.560 to insure correct format is provided
        do {
            let convertedCreatedOn = try NSDate(dateAsString: createdOn).formattedString()
            for questionChangeRequest in fetchedResultsControllerQuestionsChangeRequests.fetchedObjects! {
                if questionChangeRequest.message! == message && (questionChangeRequest.dateCreated?.formattedString() == convertedCreatedOn) {
                    return questionChangeRequest
                }
            }
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
        
        return nil
    }

    
    
//    func getLoggedInUser() -> User? {
//        loadUserCoreData()
//        if fetchedResultsControllerUser.fetchedObjects!.count == 1 {
//            return fetchedResultsControllerUser.fetchedObjects!.first
//        }
//        else if fetchedResultsControllerUser.fetchedObjects!.count > 1 {
//            print("error more than one user logged in, all users have now been deleted")
//            removeAllUsers()
//            return nil
//        }
//        else{
//            return nil
//        }
//    }
    
    func getLoggedInUser() -> User? {
        loadUserCoreData()
        
        for user in fetchedResultsControllerUser.fetchedObjects! {
            if user.isLoggedIn {
                return user
            }
        }
        return nil
    }

    
    func removeAllUsers() {
        loadUserCoreData()
        for user in fetchedResultsControllerUser.fetchedObjects! {
            managedContext?.delete(user)
        }
        saveManagedContext()
    }
    
    func removeUserWith(username:String) {
        let user = getUserWith(username: username)
        if user != nil {
            managedContext?.delete(user!)
        }
    }
    
    func getUserWith(username:String) -> User? {
        loadUserCoreData()
        for user in fetchedResultsControllerUser.fetchedObjects! {
            if user.username == username  {
                return user
            }
        }
        return nil
    }
    
    
    func removePointOfInterestWith(pointOfInterestID:Int){
        let pointOfInterest = getPointOfInterestWithID(pointOfInterestID: pointOfInterestID)
        if pointOfInterest != nil {
            managedContext?.delete(pointOfInterest!)
        }
    }
    
    func removeObjectFromManagedContext(object:NSManagedObject){
        managedContext?.delete(object)
        saveManagedContext()
        
    }
    
    func removeQuizWith(quizID:Int){
        let quiz = getQuizWithID(quizID: quizID)
        if quiz != nil {
            managedContext?.delete(quiz!)
        }
    }
    
    func removeQuestionWith(questionID:Int){
        let question = getQuestionWithID(questionID: questionID)
        if question != nil {
            managedContext?.delete(question!)
        }
    }
    
    func removeWrongAnswerWith(wrongAnswerID:Int){
        let wrongAnswer = getWrongAnswerWithID(wrongAnswerID: wrongAnswerID)
        if wrongAnswer != nil {
            managedContext?.delete(wrongAnswer!)
        }
    }
    
    func removePointOfInterestChangeRequestWith(pointOfInterestChangeRequestID:Int){
        let pointOfInterestChangeRequest = getPointOfInterestChangeRequestWithID(pointOfInterestChangeRequestID: pointOfInterestChangeRequestID)
        if pointOfInterestChangeRequest != nil {
            managedContext?.delete(pointOfInterestChangeRequest!)
        }
    }
    
    //quiz
    
    func removeQuizChangeRequestWith(quizChangeRequestID:Int){
        let quizChangeRequest = getQuizChangeRequestWithID(quizChangeRequestID: quizChangeRequestID)
        if quizChangeRequest != nil {
            managedContext?.delete(quizChangeRequest!)
        }
    }
    
    //question
    
    func removeQuestionChangeRequestWith(questionChangeRequestID:Int){
        let questionChangeRequest = getQuestionChangeRequestWithID(questionChangeRequestID: questionChangeRequestID)
        if questionChangeRequest != nil {
            managedContext?.delete(questionChangeRequest!)
        }
    }
    
    
    func getAllPointsOfinterest() -> [PointOfInterest] {
        loadPointsOfInterestCoreData()
        return fetchedResultsControllerPointOfInterest.fetchedObjects!
    }
    
    func getAllPointsOfInterestChangeRequests() -> [PointOfInterestChangeRequest] {
        loadPointOfInterestChangeRequestCoreData()
        return fetchedResultsControllerPointOfInterestChangeRequest.fetchedObjects!
    }
    
    func getAllQuizzes() -> [Quiz] {
        loadQuizzesCoreData()
        return fetchedResultsControllerQuiz.fetchedObjects!
    }
    
    func getAllQuestions() -> [Question] {
        loadQuestionsCoreData()
        return fetchedResultsControllerQuestion.fetchedObjects!
    }
    
    func setUserForPointsOfInterest() {
        let user = getLoggedInUser()
        if user != nil {
            let userID = user?.userID
            let pointsOfInterest = getPointsOfInterestForUser(userID: userID!)
            
            if pointsOfInterest != nil {
                for pointOfInterest in pointsOfInterest! {
                    pointOfInterest.user = user
                }
                saveManagedContext()
            }
        }
    }
    
    func setUserForQuizzes() {
        let user = getLoggedInUser()
        if user != nil {
            let userID = user?.userID
            let quizzes:[Quiz]? = getQuizzesForUser(userID: userID!)
            if quizzes != nil {
                for quiz in quizzes! {
                    quiz.user = user
                }
                saveManagedContext()
            }
        }
    }
    
    func setUserForQuestions() {
        let user = getLoggedInUser()
        if user != nil {
            let userID = user?.userID
            let questions:[Question]? = getQuestionsForUser(userID: userID!)
            if questions != nil {
                for question in questions! {
                    question.user = user
                }
                saveManagedContext()
            }
        }
    }
    
    func getPointsOfInterestForUser(userID:Int16) -> [PointOfInterest]? {
        loadPointsOfInterestCoreDataForUser(userID: userID)
        return fetchedResultsControllerPointOfInterest.fetchedObjects
    }
    
    func getPointsNotAddedToServer() -> [Dictionary<String, String>]? {
        loadPointsOfInterestCoreDataNotAddedToServer()
        let pointsNotAddedToServerDictionaryArray = pointsOfInterestArrayToDictionaryArrayForUpload(pointsOfInterest: fetchedResultsControllerPointOfInterest.fetchedObjects!)
        
//        for point in fetchedResultsControllerPointOfInterest.fetchedObjects! {
//            var newPointDictionary = [String:String]()
//            newPointDictionary["title"] = point.title
//            newPointDictionary["latitude"] = "\(point.latitude)"
//            newPointDictionary["longitude"] = "\(point.longitude)"
//            newPointDictionary["userID"] = "\(point.user!.userID)"
//            pointsNotAddedToServerDictionaryArray.append(newPointDictionary)
//        }
        return pointsNotAddedToServerDictionaryArray
        //return fetchedResultsControllerPointOfInterest.fetchedObjects
    }
    
    func getQuizzesNotAddedToServer() -> [Dictionary<String, String>]? {
        loadQuizzesCoreDataNotAddedToServer()
        var quizzesNotAddedToServerDictionaryArray = [Dictionary<String, String>]()
        
        for quiz in fetchedResultsControllerQuiz.fetchedObjects! {
            var newQuizDictionary = [String:String]()
            newQuizDictionary["name"] = quiz.name
            newQuizDictionary["userID"] = "\(quiz.user!.userID)"
            newQuizDictionary["dateCreated"] = quiz.dateCreated?.formattedString()
//            newQuizDictionary["pointsOfInterest"] = ("\((quiz.pointsOfInterest?.allObjects.first as! PointOfInterest).pointOfInterestID)")
            
            let pointsOfInterestArray = quiz.pointsOfInterest?.allObjects as! [PointOfInterest]
            //let dictionaryOfPoints = pointsOfInterestArray.toDictionary { [String($0.pointOfInterestID) : String($0.title!)] }
            let dictionaryOfPoints = pointsOfInterestArrayToDictionaryArrayForUpload(pointsOfInterest: pointsOfInterestArray)
            let jsonOfPoints:JSON = JSON(dictionaryOfPoints)
            let stringRepOfJson = jsonOfPoints.rawString() ?? ""
            newQuizDictionary["pointsOfInterest"] = stringRepOfJson
            
            //print(newQuizDictionary["pointsOfInterest"] ?? "no points of interest for quiz")
            
            quizzesNotAddedToServerDictionaryArray.append(newQuizDictionary)
        }
        return quizzesNotAddedToServerDictionaryArray
        //return fetchedResultsControllerPointOfInterest.fetchedObjects
    }
    
    func getPointsOfInterestChangeRequestsNotAddedToServer() -> [JSON] {
        loadPointOfInterestChangeRequestsCoreDataNotAddedToServer()
        
        var pointsOfInterestChangeRequestJSONArray = [JSON]()
        
        for changeRequest in fetchedResultsControllerPointOfInterestChangeRequest.fetchedObjects! {
            pointsOfInterestChangeRequestJSONArray.append(changeRequest.jsonFormat())
        }
        
        return pointsOfInterestChangeRequestJSONArray
    }
    
    //quizzes
    
    func getQuizzesChangeRequestsNotAddedToServer() -> [JSON] {
        loadQuizzesChangeRequestsCoreDataNotAddedToServer()
        
        var quizzesChangeRequestJSONArray = [JSON]()
        
        for changeRequest in fetchedResultsControllerQuizzesChangeRequests.fetchedObjects! {
            quizzesChangeRequestJSONArray.append(changeRequest.jsonFormat())
        }
        
        return quizzesChangeRequestJSONArray
    }
    
    //questions

    func getQuestionsChangeRequestsNotAddedToServer() -> [JSON] {
        loadQuestionsChangeRequestsCoreDataNotAddedToServer()
        
        var questionsChangeRequestsJSONArray = [JSON]()
        
        for changeRequest in fetchedResultsControllerQuestionsChangeRequests.fetchedObjects! {
            questionsChangeRequestsJSONArray.append(changeRequest.jsonFormat())
        }
        
        return questionsChangeRequestsJSONArray
    }
    
    /*
     Deletions
    */
    
    //points of interest
    
    func getPointsOfInterestMarkedForDeletion() -> [Int] {
        loadPointsOfInterestCoreData()
        
        var pointsOfInterestIDsToBeDeletedArray = [Int]()
        
        for pointToBeDeleted in fetchedResultsControllerPointOfInterest.fetchedObjects! {
            if pointToBeDeleted.deleteOnNextSync == true {
                 pointsOfInterestIDsToBeDeletedArray.append(Int(pointToBeDeleted.pointOfInterestID))
            }
        }
        
        return pointsOfInterestIDsToBeDeletedArray
    }
    
    //quizzes
    
    func getQuizzesMarkedForDeletion() -> [Int] {
        loadQuizzesCoreData()
        
        var quizIDsToBeDeletedArray = [Int]()
        
        for quizToBeDeleted in fetchedResultsControllerQuiz.fetchedObjects! {
            if quizToBeDeleted.deleteOnNextSync == true {
                quizIDsToBeDeletedArray.append(Int(quizToBeDeleted.quizID))
            }
        }
        
        return quizIDsToBeDeletedArray
    }
    
    //questions
    
    func getQuestionsMarkedForDeletion() -> [Int] {
        loadQuestionsCoreData()
        
        var questionIDsToBeDeletedArray = [Int]()
        
        for questionToBeDeleted in fetchedResultsControllerQuestion.fetchedObjects! {
            if questionToBeDeleted.deleteOnNextSync == true {
                questionIDsToBeDeletedArray.append(Int(questionToBeDeleted.questionID))
            }
        }
        
        return questionIDsToBeDeletedArray
    }
    
    //Point of interest change requests
    
    func getPointOfInterestChangeRequestsMarkedForDeletion() -> [Int] {
        loadPointOfInterestChangeRequestCoreData()
        
        var pointOfInterestChangeRequestsIDsToBeDeletedArray = [Int]()
        
        for pointOfInterestChangeRequest in fetchedResultsControllerPointOfInterestChangeRequest.fetchedObjects! {
            if pointOfInterestChangeRequest.deleteOnNextSync == true {
                pointOfInterestChangeRequestsIDsToBeDeletedArray.append(Int(pointOfInterestChangeRequest.pointOfInterestChangeRequestID))
            }
        }
        
        return pointOfInterestChangeRequestsIDsToBeDeletedArray
    }
    
    //Quiz change requests
    
    func getQuizChangeRequestsMarkedForDeletion() -> [Int] {
        loadQuizzesChangeRequestsCoreData()
        
        var quizChangeRequestsIDsToBeDeletedArray = [Int]()
        
        for quizChangeRequest in fetchedResultsControllerQuizzesChangeRequests.fetchedObjects! {
            if quizChangeRequest.deleteOnNextSync == true {
                quizChangeRequestsIDsToBeDeletedArray.append(Int(quizChangeRequest.quizChangeRequestID))
            }
        }
        
        return quizChangeRequestsIDsToBeDeletedArray
    }
    
    //Question change requests
    
    func getQuestionChangeRequestsMarkedForDeletion() -> [Int] {
        loadQuestionsChangeRequestsCoreData()
        
        var questionChangeRequestsIDsToBeDeletedArray = [Int]()
        
        for questionChangeRequest in fetchedResultsControllerQuestionsChangeRequests.fetchedObjects! {
            if questionChangeRequest.deleteOnNextSync == true {
                questionChangeRequestsIDsToBeDeletedArray.append(Int(questionChangeRequest.questionChangeRequestID))
            }
        }
        
        return questionChangeRequestsIDsToBeDeletedArray
    }
    
    /*
     Updates
    */
    
    func getPointsOfInterestUpdates() -> [JSON] {
        loadPointsOfInterestCoreData()
        
        var pointsOfInterestUpdatesJSONArray = [JSON]()
        
        for pointOfInterest in fetchedResultsControllerPointOfInterest.fetchedObjects! {
            
            
            if pointOfInterest.updateTimeStamp != nil {
                
                do {
                    let lastConnectedToServerTimeStamp = try NSDate(dateAsString: retrieveFromUserDefaults(key: "lastConnectionTimestampLocal"))
                    
                    let compare = pointOfInterest.updateTimeStamp!.compare(lastConnectedToServerTimeStamp as Date)
                    
                    
                    if compare == .orderedDescending{
                        print(pointOfInterest.title ?? "no title")
                        pointsOfInterestUpdatesJSONArray.append(pointOfInterest.jsonFormat())
                    }
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
        }
        
        return pointsOfInterestUpdatesJSONArray
    }
    
    //quizzes
    
    func getQuizUpdates() -> [JSON] {
        loadQuizzesCoreData()
        
        var quizUpdatesJSONArray = [JSON]()
        
        for quiz in fetchedResultsControllerQuiz.fetchedObjects! {
            
            
            if quiz.updateTimeStamp != nil {
                
                do {
                    let lastConnectedToServerTimeStamp = try NSDate(dateAsString: retrieveFromUserDefaults(key: "lastConnectionTimestampLocal"))
                    
                    let compare = quiz.updateTimeStamp!.compare(lastConnectedToServerTimeStamp as Date)
                    
                    
                    if compare == .orderedDescending{
                        print(quiz.name ?? "no name")
                        quizUpdatesJSONArray.append(quiz.jsonFormat())
                    }
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
        }
        
        return quizUpdatesJSONArray
    }
    
    //questions
    
    func getQuestionUpdates() -> [JSON] {
        loadQuestionsCoreData()
        
        var questionUpdatesJSONArray = [JSON]()
        
        for question in fetchedResultsControllerQuestion.fetchedObjects! {
            if question.updateTimeStamp != nil {
                
                do {
                    let lastConnectedToServerTimeStamp = try NSDate(dateAsString: retrieveFromUserDefaults(key: "lastConnectionTimestampLocal"))
                    
                    let compare = question.updateTimeStamp!.compare(lastConnectedToServerTimeStamp as Date)
                    
                    if compare == .orderedDescending{
                        print(question.question ?? "no question")
                        questionUpdatesJSONArray.append(question.jsonFormat())
                    }
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
        }
        
        return questionUpdatesJSONArray
    }
    
    //wrongAnswers
    
    func getWrongAnswerUpdates() -> [JSON] {
        loadWrongAnswersCoreData()
        var wrongAnswerUpdatesJSONArray = [JSON]()
        
        for wrongAnswer in fetchedResultsControllerWrongAnswer.fetchedObjects! {
            if wrongAnswer.updateTimeStamp != nil {
                do {
                    let lastConnectedToServerTimeStamp = try NSDate(dateAsString: retrieveFromUserDefaults(key: "lastConnectionTimestampLocal"))
                    
                    let compare = wrongAnswer.updateTimeStamp!.compare(lastConnectedToServerTimeStamp as Date)
                    
                    if compare == .orderedDescending{
                        print(wrongAnswer.wrongAnswer ?? "no wrong answer")
                        wrongAnswerUpdatesJSONArray.append(wrongAnswer.jsonFormat())
                    }
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
        }
        return wrongAnswerUpdatesJSONArray
    }


    
    func pointsOfInterestArrayToDictionaryArrayForUpload(pointsOfInterest:[PointOfInterest]) -> [Dictionary<String, String>] {
        var pointsNotAddedToServerDictionaryArray = [Dictionary<String, String>]()
        
        for point in pointsOfInterest {
            var newPointDictionary = [String:String]()
            newPointDictionary["pointOfInterestID"] = "\(point.pointOfInterestID)"
            newPointDictionary["title"] = point.title
            newPointDictionary["latitude"] = "\(point.latitude)"
            newPointDictionary["longitude"] = "\(point.longitude)"
            newPointDictionary["userID"] = "\(point.userID)"
            pointsNotAddedToServerDictionaryArray.append(newPointDictionary)
        }
        return pointsNotAddedToServerDictionaryArray
    }
    
    func getQuestionsNotAddedToServer() -> [Dictionary<String, String>]? {
        loadQuestionsCoreDataNotAddedToServer()
        var questionsNotAddedToServerDictionaryArray = [Dictionary<String, String>]()
        
        for question in fetchedResultsControllerQuestion.fetchedObjects! {
            var newQuestionDictionary = [String:String]()
            newQuestionDictionary["question"] = question.question
            newQuestionDictionary["answer"] = question.answer
            newQuestionDictionary["userID"] = "\(question.userID)"
            newQuestionDictionary["quizID"] = "\(question.quiz?.quizID ?? 0)"
            newQuestionDictionary["dateCreated"] = question.dateCreated?.formattedString()
            newQuestionDictionary["quizName"] = "\(question.quiz?.name ?? "")"
            newQuestionDictionary["quizDateCreatedOnDevice"] = "\(question.quiz?.dateCreated?.formattedString() ?? "")"
            
            questionsNotAddedToServerDictionaryArray.append(newQuestionDictionary)
        }
        return questionsNotAddedToServerDictionaryArray
    }

    func getWrongAnswersNotAddedToServer() -> [Dictionary<String, String>]? {
        loadWrongAnswersCoreDataNotAddedToServer()
        var wrongAnswersNotAddedToServerDictionaryArray = [Dictionary<String, String>]()
        
        for wrongAnswer in fetchedResultsControllerWrongAnswer.fetchedObjects! {
            var newWrongAnswerDictionary = [String:String]()
            newWrongAnswerDictionary["wrongAnswer"] = wrongAnswer.wrongAnswer
            newWrongAnswerDictionary["userID"] = "\(wrongAnswer.userID)"
            newWrongAnswerDictionary["questionID"] = "\(wrongAnswer.question?.questionID ?? 0)"
            newWrongAnswerDictionary["questionString"] = wrongAnswer.question?.question
            newWrongAnswerDictionary["questionDateCreated"] = wrongAnswer.question?.dateCreated?.formattedString()
            newWrongAnswerDictionary["dateCreated"] = wrongAnswer.dateCreated?.formattedString()
            
            
            wrongAnswersNotAddedToServerDictionaryArray.append(newWrongAnswerDictionary)
        }
        return wrongAnswersNotAddedToServerDictionaryArray
    }
    
    func getQuizzesForUser(userID:Int16) -> [Quiz]? {
        loadQuizzesCoreDataForUser(userID: userID)
        return fetchedResultsControllerQuiz.fetchedObjects
    }
    
    func getQuestionsForUser(userID:Int16) -> [Question]? {
        loadQuestionsCoreDataForUser(userID: userID)
        return fetchedResultsControllerQuestion.fetchedObjects
    }
    
    func loadQuizzesCoreData() {
        let fetchRequest: NSFetchRequest<Quiz> = Quiz.fetchRequest()
        
        let sortDescription = NSSortDescriptor(key: "quizID", ascending: false)
        fetchRequest.sortDescriptors = [sortDescription]
        
        fetchedResultsControllerQuiz =  NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        preformFetchForControllerQuiz()
    }
    
    func loadPointsOfInterestCoreData() {
        let fetchRequest: NSFetchRequest<PointOfInterest> = PointOfInterest.fetchRequest()
        
        let sortDescription = NSSortDescriptor(key: "pointOfInterestID", ascending: false)
        fetchRequest.sortDescriptors = [sortDescription]
        
        fetchedResultsControllerPointOfInterest =  NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        preformFetchForControllerPointOfInterest()
    }
    
    func loadQuestionsCoreData() {
        let fetchRequest: NSFetchRequest<Question> = Question.fetchRequest()
        
        let sortDescription = NSSortDescriptor(key: "questionID", ascending: false)
        fetchRequest.sortDescriptors = [sortDescription]
        
        fetchedResultsControllerQuestion = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        preformFetchForControllerQuestion()
    }
    
    /*
     load points of interest which have no user set which have the same userID as the logged in user
     */
    
    func loadPointsOfInterestCoreDataForUser(userID:Int16) {
        let fetchRequest: NSFetchRequest<PointOfInterest> = PointOfInterest.fetchRequest()
        let sortDescription = NSSortDescriptor(key: "pointOfInterestID", ascending: true)
        
        
        let showOnlyPointsWithNoUserSetPredicate = NSPredicate(format: "user == nil")
        let showOnlyPointsForUserPredicate = NSPredicate(format: "userID == \(userID)")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [showOnlyPointsWithNoUserSetPredicate,showOnlyPointsForUserPredicate])
        
        fetchRequest.sortDescriptors = [sortDescription]
        
        fetchRequest.predicate = compoundPredicate
        
        fetchedResultsControllerPointOfInterest =  NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        preformFetchForControllerPointOfInterest()
    }
    
    /*
     load points of interest with a id of 0 and thus are not uploaded to server
    */
    
    func loadPointsOfInterestCoreDataNotAddedToServer() {
        let fetchRequest: NSFetchRequest<PointOfInterest> = PointOfInterest.fetchRequest()
        let sortDescription = NSSortDescriptor(key: "pointOfInterestID", ascending: true)
        
        
        let showOnlyPointsWithZeroIdPredicate = NSPredicate(format: "pointOfInterestID == 0")
        
        fetchRequest.sortDescriptors = [sortDescription]
        
        fetchRequest.predicate = showOnlyPointsWithZeroIdPredicate
        
        fetchedResultsControllerPointOfInterest =  NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        preformFetchForControllerPointOfInterest()
    }
    
    func loadPointOfInterestChangeRequestsCoreDataNotAddedToServer() {
        let fetchRequest: NSFetchRequest<PointOfInterestChangeRequest> = PointOfInterestChangeRequest.fetchRequest()
        let sortDescription = NSSortDescriptor(key: "pointOfInterestChangeRequestID", ascending: true)
        
        let showOnlyChangeRequestsWithZeroIdPredicate = NSPredicate(format: "pointOfInterestChangeRequestID == 0")
        
        fetchRequest.sortDescriptors = [sortDescription]
        
        fetchRequest.predicate = showOnlyChangeRequestsWithZeroIdPredicate
        
        fetchedResultsControllerPointOfInterestChangeRequest =  NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        preformFetchForControllerPointOfInterestChangeRequest()
    }
    
    //ordered by change requests
    
    func loadAllPointsOfInterestOrderedByChangeRequestsCoreData() {
        let fetchRequest: NSFetchRequest<PointOfInterest> = PointOfInterest.fetchRequest()
        let sortDescription = NSSortDescriptor(key: "pointOfInterestID", ascending: true)
        
        
//        let showOnlyPointsWithChangeRequests = NSPredicate(format: "changeRequests.@count != 0")
//        let showOnlyPointsWithChangeRequestsNotNil = NSPredicate(format: "changeRequests != nil")
        
//        sortedArrayUsingDescriptors
//        changeRequests.@count
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [showOnlyPointsWithChangeRequests,showOnlyPointsWithChangeRequestsNotNil])
        
        fetchRequest.sortDescriptors = [sortDescription]
        
//        fetchRequest.predicate = compoundPredicate
//        fetchRequest.predicate = showOnlyPointsWithChangeRequestsNotNil
        
        fetchedResultsControllerPointOfInterest =  NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        preformFetchForControllerPointOfInterest()
    }
    
    func descendingPointOfInterestChangeRequests(value1: PointOfInterest, value2: PointOfInterest) -> Bool {
        return value1.changeRequests?.count ?? 0 > value2.changeRequests?.count ?? 0
    }
    
    func descendingQuizChangeRequests(value1: Quiz, value2: Quiz) -> Bool {
        return value1.changeRequests?.count ?? 0 > value2.changeRequests?.count ?? 0
    }
    
    func descendingQuestionChangeRequests(value1: Question, value2: Question) -> Bool {
        return value1.changeRequests?.count ?? 0 > value2.changeRequests?.count ?? 0
    }
    
    func getAllPointsOfinterestOrderedByChangeRequests() -> [PointOfInterest] {
        loadAllPointsOfInterestOrderedByChangeRequestsCoreData()
        var results = fetchedResultsControllerPointOfInterest.fetchedObjects!
        
        //removedZeroChangeRequests.sort({ $0.changeRequests.@count > $1.changeRequests.@count })
        var pointsToReturnArray:[PointOfInterest] = [PointOfInterest]()
        for i in 0..<results.count{
            if results[i].changeRequests?.count ?? 0 > 0 {
                pointsToReturnArray.append(results[i])
            }
        }
        
//        results.remove(at: i)
        //        sortedArrayUsingDescriptors
        //        changeRequests.@count
        
        return pointsToReturnArray.sorted(by: descendingPointOfInterestChangeRequests)
    }
    
    //quizzes
    
    func getAllQuizzesOrderedByChangeRequests() -> [Quiz] {
        loadQuizzesCoreData()
        var results = fetchedResultsControllerQuiz.fetchedObjects!

        var quizzesToReturnArray:[Quiz] = [Quiz]()
        for i in 0..<results.count{
            if results[i].changeRequests?.count ?? 0 > 0 {
                quizzesToReturnArray.append(results[i])
            }
        }
        
        return quizzesToReturnArray.sorted(by: descendingQuizChangeRequests)
    }

    
    func loadQuizzesChangeRequestsCoreDataNotAddedToServer() {
        let fetchRequest: NSFetchRequest<QuizChangeRequest> = QuizChangeRequest.fetchRequest()
        let sortDescription = NSSortDescriptor(key: "quizChangeRequestID", ascending: true)
        
        let showOnlyChangeRequestsWithZeroIdPredicate = NSPredicate(format: "quizChangeRequestID == 0")
        
        fetchRequest.sortDescriptors = [sortDescription]
        
        fetchRequest.predicate = showOnlyChangeRequestsWithZeroIdPredicate
        
        fetchedResultsControllerQuizzesChangeRequests =  NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        preformFetchForControllerQuizzesChangeRequests()
    }
    
    //questions
    
    func getAllQuestionsOrderedByChangeRequests() -> [Question] {
        loadQuestionsCoreData()
        var results = fetchedResultsControllerQuestion.fetchedObjects!
        
        var questionsToReturnArray:[Question] = [Question]()
        for i in 0..<results.count{
            if results[i].changeRequests?.count ?? 0 > 0 {
                questionsToReturnArray.append(results[i])
            }
        }
        
        return questionsToReturnArray.sorted(by: descendingQuestionChangeRequests)
    }

    
    func loadQuestionsChangeRequestsCoreDataNotAddedToServer() {
        let fetchRequest: NSFetchRequest<QuestionChangeRequest> = QuestionChangeRequest.fetchRequest()
        let sortDescription = NSSortDescriptor(key: "questionChangeRequestID", ascending: true)
        
        let showOnlyChangeRequestsWithZeroIdPredicate = NSPredicate(format: "questionChangeRequestID == 0")
        
        fetchRequest.sortDescriptors = [sortDescription]
        
        fetchRequest.predicate = showOnlyChangeRequestsWithZeroIdPredicate
        
        fetchedResultsControllerQuestionsChangeRequests =  NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        preformFetchForControllerQuestionsChangeRequests()
    }
    
    func loadQuizzesCoreDataNotAddedToServer() {
        let fetchRequest: NSFetchRequest<Quiz> = Quiz.fetchRequest()
        let sortDescription = NSSortDescriptor(key: "quizID", ascending: true)
        
        let showOnlyQuizzesWithZeroIdPredicate = NSPredicate(format: "quizID == 0")
        
        fetchRequest.sortDescriptors = [sortDescription]
        
        fetchRequest.predicate = showOnlyQuizzesWithZeroIdPredicate
        
        fetchedResultsControllerQuiz = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        preformFetchForControllerQuiz()
    }

    func loadQuestionsCoreDataNotAddedToServer() {
        let fetchRequest: NSFetchRequest<Question> = Question.fetchRequest()
        let sortDescription = NSSortDescriptor(key: "questionID", ascending: true)
        
        let showOnlyQuestionsWithZeroIdPredicate = NSPredicate(format: "questionID == 0")
        
        fetchRequest.sortDescriptors = [sortDescription]
        
        fetchRequest.predicate = showOnlyQuestionsWithZeroIdPredicate
        
        fetchedResultsControllerQuestion = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        preformFetchForControllerQuestion()
    }
    
    func loadWrongAnswersCoreDataNotAddedToServer() {
        let fetchRequest: NSFetchRequest<WrongAnswer> = WrongAnswer.fetchRequest()
        let sortDescription = NSSortDescriptor(key: "wrongAnswerID", ascending: true)
        
        let showOnlyWrongAnswersWithZeroIdPredicate = NSPredicate(format: "wrongAnswerID == 0")
        
        fetchRequest.sortDescriptors = [sortDescription]
        
        fetchRequest.predicate = showOnlyWrongAnswersWithZeroIdPredicate
        
        fetchedResultsControllerWrongAnswer = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        preformFetchForControllerWrongAnswers()
    }
    
    /*
     load quizzes which have no user set which have the same userID as the logged in user
    */
    
    func loadQuizzesCoreDataForUser(userID:Int16) {
        let fetchRequest: NSFetchRequest<Quiz> = Quiz.fetchRequest()
        
        let sortDescription = NSSortDescriptor(key: "quizID", ascending: true)
        
        let showOnlyQuizzesWithNoUserSetPredicate = NSPredicate(format: "user == nil")
        let showOnlyQuizzesForUserPredicate = NSPredicate(format: "userID == \(userID)")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [showOnlyQuizzesWithNoUserSetPredicate,showOnlyQuizzesForUserPredicate])
        
        fetchRequest.sortDescriptors = [sortDescription]
        
        fetchRequest.predicate = compoundPredicate
        
        fetchedResultsControllerQuiz = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        preformFetchForControllerQuiz()
    }
    
    /*
     load questions which have no user set which have the same userID as the logged in user
    */
    
    func loadQuestionsCoreDataForUser(userID:Int16) {
        let fetchRequest: NSFetchRequest<Question> = Question.fetchRequest()
        
        let sortDescription = NSSortDescriptor(key: "questionID", ascending: true)
        
        let showOnlyQuestionsWithNoUserSetPredicate = NSPredicate(format: "user == nil")
        let showOnlyQuestionsForUserPredicate = NSPredicate(format: "userID == \(userID)")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [showOnlyQuestionsWithNoUserSetPredicate,showOnlyQuestionsForUserPredicate])
        
        fetchRequest.sortDescriptors = [sortDescription]
        
        fetchRequest.predicate = compoundPredicate
        
        fetchedResultsControllerQuestion = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        preformFetchForControllerQuestion()
    }

    
    func loadWrongAnswersCoreData() {
        let fetchRequest: NSFetchRequest<WrongAnswer> = WrongAnswer.fetchRequest()
        
        let sortDescription = NSSortDescriptor(key: "wrongAnswerID", ascending: false)
        fetchRequest.sortDescriptors = [sortDescription]
        
        fetchedResultsControllerWrongAnswer = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        preformFetchForControllerWrongAnswers()
    }
    
    func loadUserCoreData() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        let sortDescription = NSSortDescriptor(key: "username", ascending: true)
        fetchRequest.sortDescriptors = [sortDescription]
        
        fetchedResultsControllerUser =  NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        preformFetchForControllerUser()
    }
    
    func loadPointOfInterestChangeRequestCoreData() {
        let fetchRequest: NSFetchRequest<PointOfInterestChangeRequest> = PointOfInterestChangeRequest.fetchRequest()
        
        let sortDescription = NSSortDescriptor(key: "pointOfInterestChangeRequestID", ascending: false)
        fetchRequest.sortDescriptors = [sortDescription]
        
        fetchedResultsControllerPointOfInterestChangeRequest = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        preformFetchForControllerPointOfInterestChangeRequest()
    }
    
    //quiz change requests
    
    func loadQuizzesChangeRequestsCoreData() {
        let fetchRequest: NSFetchRequest<QuizChangeRequest> = QuizChangeRequest.fetchRequest()
        
        let sortDescription = NSSortDescriptor(key: "quizChangeRequestID", ascending: false)
        fetchRequest.sortDescriptors = [sortDescription]
        
        fetchedResultsControllerQuizzesChangeRequests = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        preformFetchForControllerQuizzesChangeRequests()
    }
    
    // questions
    
    func loadQuestionsChangeRequestsCoreData() {
        let fetchRequest: NSFetchRequest<QuestionChangeRequest> = QuestionChangeRequest.fetchRequest()
        
        let sortDescription = NSSortDescriptor(key: "questionChangeRequestID", ascending: false)
        fetchRequest.sortDescriptors = [sortDescription]
        
        fetchedResultsControllerQuestionsChangeRequests = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        preformFetchForControllerQuestionsChangeRequests()
    }
    
    
    func preformFetchForControllerPointOfInterest(){
        do{
            try fetchedResultsControllerPointOfInterest.performFetch()
        }
        catch let error as NSError {
            print("The error was : \(error)")
        }
    }
    
    func preformFetchForControllerPointOfInterestChangeRequest(){
        do{
            try fetchedResultsControllerPointOfInterestChangeRequest.performFetch()
        }
        catch let error as NSError {
            print("The error was : \(error)")
        }
    }
    
    func preformFetchForControllerQuizzesChangeRequests(){
        do{
            try fetchedResultsControllerQuizzesChangeRequests.performFetch()
        }
        catch let error as NSError {
            print("The error was : \(error)")
        }
    }
    
    //question
    
    func preformFetchForControllerQuestionsChangeRequests(){
        do{
            try fetchedResultsControllerQuestionsChangeRequests.performFetch()
        }
        catch let error as NSError {
            print("The error was : \(error)")
        }
    }
    
    func preformFetchForControllerQuiz(){
        do{
            try fetchedResultsControllerQuiz.performFetch()
        }
        catch let error as NSError {
            print("The error was : \(error)")
        }
    }
    
    func preformFetchForControllerQuestion(){
        do{
            try fetchedResultsControllerQuestion.performFetch()
        }
        catch let error as NSError {
            print("The error was : \(error)")
        }
    }
    
    func preformFetchForControllerWrongAnswers(){
        do{
            try fetchedResultsControllerWrongAnswer.performFetch()
        }
        catch let error as NSError {
            print("The error was : \(error)")
        }
    }
    
    func preformFetchForControllerUser(){
        do{
            try fetchedResultsControllerUser.performFetch()
        }
        catch let error as NSError {
            print("The error was : \(error)")
        }
    }
    
    func saveManagedContext(){
        do {
            try managedContext?.save()
        } catch let error as NSError {
            print("error with \(error)")
        }
    }
    
    func storeInUserDefaults(key:String,data:String) {
        defaults.set(data, forKey: key)
    }
    
    /**
     
     Retrives data from provided key from user defaults as a String if nil returns "0".
     
     - Parameter key: The String key for the key value pair.
     
     - Returns: The String data associated with the String `key`.
     
     
    */
    func retrieveFromUserDefaults(key:String) -> String {
        let data = defaults.object(forKey: key) as? String ?? "0"
        return data
    }

    
}
extension Array {
    
    func toDictionary<K, V>(transform:(_ element: Iterator.Element) -> [K : V]) -> [K : V] {
        var dictionary = [K : V]()
        self.forEach { element in
            for (key, value) in transform(element) {
                dictionary[key] = value
            }
        }
        return dictionary
    }
    
//    public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key:Element] {
//        var dict = [Key:Element]()
//        for element in self {
//            dict[selectKey(element)] = element
//        }
//        return dict
//    }

//    public func toStringDictionary () -> [Dictionary<String, String>] {
//        
//        var stringDictionary = [Dictionary<String, String>]()
//        
//        
//        for (arrayObject) in self {
//            var dict = [String:String]()
//            let manobj = arrayObject as! NSManagedObject
//            //manobj.classForCoder.prop
//            let m = Mirror(reflecting: arrayObject)
//            //m.subjectType
//            
//            //let classOfObject = type(of: arrayObject)
//            //let a = arrayObject
////            for objectVar in  {
////                <#code#>
////            }
//            //dict[object] = object
//        }
//        return stringDictionary
//        
////        for point in fetchedResultsControllerPointOfInterest.fetchedObjects! {
////            var newPointDictionary = [String:String]()
////            newPointDictionary["title"] = point.title
////            newPointDictionary["latitude"] = "\(point.latitude)"
////            newPointDictionary["longitude"] = "\(point.longitude)"
////            newPointDictionary["userID"] = "\(point.user!.userID)"
////            stringDictionary.append(newPointDictionary)
////        }
//        
//        
//        
//    }
    
}

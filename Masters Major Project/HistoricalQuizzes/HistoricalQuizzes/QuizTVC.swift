//
//  QuizTVC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 16/03/2018.
//  Copyright © 2018 Doug Williams. All rights reserved.
//

import UIKit

class QuizTVC: UITableViewController {
    
    @IBOutlet weak var nextQuestionButton: UIBarButtonItem!
    
    let coreDataHandler = CoreDataHandler()
    var quiz:Quiz?
    var questions:[Question]!
    var questionNumber:Int = 0
    var wrongAnswers:[WrongAnswer]!
    
    let choiceAlert = UIAlertController(title: "Request a Change", message: "Which item needs changing?", preferredStyle: UIAlertControllerStyle.alert)
    
    var correctAnswerIndex:Int!
    var randomisedWrongAnswersForCurrentQuestion:[WrongAnswer?] = [WrongAnswer]()
    var randomisedQuestions:[Question] = [Question]()
    
    var chosenAnswers:[WrongAnswer?] = [WrongAnswer]()
    
    let alert = UIAlertController(title: "Request a Change", message: "Please describe the change that is needed", preferredStyle: UIAlertControllerStyle.alert)
    
    var isChangeRequestForQuiz:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuiz()
//        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
//        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Enter your change request message"
            self.alert.addAction(UIAlertAction(title: "Send Request", style: UIAlertActionStyle.default) { (alertAction:UIAlertAction) in
                
                let text:String? = self.alert.textFields?.first?.text
                let textWithNoWhiteSpaces = text?.trimmingCharacters(in: .whitespaces)
                let textCharCount = text?.characters.count ?? 257
                
                if !(textWithNoWhiteSpaces?.isEmpty)! && textCharCount < 256 && textWithNoWhiteSpaces != nil{
                    self.alert.message = "Please describe the change that is needed"
                    
                    if self.isChangeRequestForQuiz {
                        //quiz
                        _ = self.coreDataHandler.addQuizChangeRequest(quizChangeRequestID: 0, quiz: self.quiz!, user: self.coreDataHandler.getLoggedInUser(), message: text!)
                    }
                    else{
                        //question
                        _ = self.coreDataHandler.addQuestionChangeRequest(questionChangeRequestID: 0, question: self.randomisedQuestions[self.questionNumber], user: self.coreDataHandler.getLoggedInUser(), message: text!)
                    }
                    
                    self.coreDataHandler.saveManagedContext()
                    
                    //print(text!)
                    self.alert.textFields?.first?.text?.removeAll()
                }
                else{
                    self.alert.message = "Your change request message must not be empty or be more than 255 characters, please try again"
                    self.present(self.alert, animated: true, completion: nil)
                }
            })
            self.alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        })
        
        choiceAlert.addAction(UIAlertAction(title: "Quiz", style: UIAlertActionStyle.default, handler: { action in
            self.isChangeRequestForQuiz = true
            self.present(self.alert, animated: true, completion: nil)
        }))
        
        
        choiceAlert.addAction(UIAlertAction(title: "Question", style: UIAlertActionStyle.default, handler: { action in
            self.isChangeRequestForQuiz = false
            self.present(self.alert, animated: true, completion: nil)
        }))
        
        
        choiceAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextQuestionButtonPressed(_ sender: UIBarButtonItem) {
        if nextQuestionButton.title == "Finish" {
            print("go to results screen")
            print("you selected")
            
            for i in 0 ..< chosenAnswers.count {
                if chosenAnswers[i] != nil {
                    print("You choose... poorly => \(chosenAnswers[i]?.wrongAnswer ?? "")")
                }
                else{
                    print("You choose... wisely => \(randomisedQuestions[i].answer ?? "")")
                }
            }
            performSegue(withIdentifier: "goToResultsScreen", sender: nil)
        }
        else {
            questionNumber += 1
            setupRandomisedWrongAnswersForCurrentQuestion()
            tableView.reloadData()
            if (questionNumber + 1) > randomisedQuestions.count - 1 {
                nextQuestionButton.title = "Finish"
            }
        }
        nextQuestionButton.isEnabled = false
    }
    
    @IBAction func changeRequestButtonPressed(_ sender: UIBarButtonItem) {
        self.present(self.choiceAlert, animated: true, completion: nil)
        }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? UINavigationController {
            if let quizResultsVC = controller.viewControllers.first as? QuizResultsVC {
                quizResultsVC.percentage = calculatePercentage()
            }
        }
    }
    
    func calculatePercentage() -> Int {
        var rightCount:Double = 0
        //var wrongCount:Int = 0
        let totalAnswers = Double(chosenAnswers.count)
        
        for i in 0 ..< chosenAnswers.count {
            if chosenAnswers[i] == nil {
                rightCount += 1
            }
        }
        let percentage = (rightCount/totalAnswers)*100
        print("\(percentage)%")
        
        return Int(percentage.rounded())
    }
    
    func setupQuiz() {
        questions = quiz?.questions?.allObjects as! [Question]
        pickUpToFourRandomQuestions()
        setupRandomisedWrongAnswersForCurrentQuestion()
        if randomisedQuestions.count <= 1 {
            nextQuestionButton.title = "Finish"
        }
    }
    
    func setupRandomisedWrongAnswersForCurrentQuestion() {
        //wrongAnswers = questions[questionNumber].wrongAnswers?.allObjects as! [WrongAnswer]
        wrongAnswers = randomisedQuestions[questionNumber].wrongAnswers?.allObjects as! [WrongAnswer]
        randomisedWrongAnswers()
        correctAnswerIndex = Int(arc4random_uniform(UInt32(randomisedWrongAnswersForCurrentQuestion.count + 1)))
        randomisedWrongAnswersForCurrentQuestion.insert(nil, at: correctAnswerIndex)
    }
    
    
    func pickUpToFourRandomQuestions() {
        randomisedQuestions.removeAll()
        var numberArray:[Int] = [Int]()
        for i in 0 ..< questions.count {
            numberArray.append(i)
        }

        if questions.count > 4 {
            for _ in 0 ..< 4 {
                let randomIndex = Int(arc4random_uniform(UInt32(numberArray.count)))
                let randomIndexResult = numberArray[randomIndex]
                randomisedQuestions.append(questions[randomIndexResult])
                numberArray.remove(at: randomIndex)
            }
        }
        else{
            for _ in 0 ..< questions.count {
                let randomIndex = Int(arc4random_uniform(UInt32(numberArray.count)))
                let randomIndexResult = numberArray[randomIndex]
                randomisedQuestions.append(questions[randomIndexResult])
                numberArray.remove(at: randomIndex)
            }
        }
    }
    
    func randomisedWrongAnswers() {
        randomisedWrongAnswersForCurrentQuestion.removeAll()
        
        var numberArray:[Int] = [Int]()
        let numberOfWrongAnswers = randomisedQuestions[questionNumber].wrongAnswers?.count ?? 0
        for i in 0 ..< numberOfWrongAnswers {
            numberArray.append(i)
        }
        
        for _ in 0 ..< wrongAnswers.count {
            let randomIndex = Int(arc4random_uniform(UInt32(numberArray.count)))
            let randomIndexResult = numberArray[randomIndex]
            randomisedWrongAnswersForCurrentQuestion.append(wrongAnswers[randomIndexResult])
            numberArray.remove(at: randomIndex)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if questions.count != 0 {
            // #warning Incomplete implementation, return the number of sections
            if questions[questionNumber].question != nil {
                return 1
            }
            return 0
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if randomisedQuestions.count != 0 {
            // #warning Incomplete implementation, return the number of rows
            if randomisedQuestions[questionNumber].answer != nil {
                return (randomisedQuestions[questionNumber].wrongAnswers?.count)! + 1
            }
            return 0
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .none
        
        if randomisedWrongAnswersForCurrentQuestion[indexPath.row] != nil || indexPath.row == randomisedWrongAnswersForCurrentQuestion.count{
            cell.textLabel?.text = randomisedWrongAnswersForCurrentQuestion[indexPath.row]?.wrongAnswer
        }
        else{
            cell.textLabel?.text = randomisedQuestions[questionNumber].answer
        }
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if randomisedQuestions[questionNumber].question != nil {
//            return randomisedQuestions[questionNumber].question
//        }
//        return ""
//    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = Bundle.main.loadNibNamed("HeaderCellTableViewCell", owner: self, options: nil)?.first as! HeaderCellTableViewCell
        
        if randomisedQuestions[questionNumber].question != nil {
            headerView.questionLabel.text = randomisedQuestions[questionNumber].question
        }

        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 88
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if chosenAnswers.endIndex - 1 == questionNumber {
            var pointIndex:Int = 0
            if chosenAnswers[questionNumber] != nil {
                for i in 0 ..< randomisedWrongAnswersForCurrentQuestion.count {
                    if randomisedWrongAnswersForCurrentQuestion[i] == chosenAnswers[questionNumber] {
                        pointIndex = i
                    }
                }
            }
            else{
                pointIndex = correctAnswerIndex
            }
            
            let cell = tableView.cellForRow(at: IndexPath(row: pointIndex, section: 0))
            cell?.accessoryType = .none
            chosenAnswers.remove(at: questionNumber)
        }
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        chosenAnswers.append(randomisedWrongAnswersForCurrentQuestion[indexPath.row])
        nextQuestionButton.isEnabled = true
    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        if questions.count != 0 {
//            // #warning Incomplete implementation, return the number of sections
//            if questions[questionNumber].question != nil {
//                return 1
//            }
//            return 0
//        }
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if questions.count != 0 {
//            // #warning Incomplete implementation, return the number of rows
//            if questions[questionNumber].answer != nil {
//                return (questions[questionNumber].wrongAnswers?.count)! + 1
//            }
//            return 0
//        }
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        
//        if indexPath.row < wrongAnswers.count {
//            cell.textLabel?.text = wrongAnswers[indexPath.row].wrongAnswer
//        }
//        else{
//            cell.textLabel?.text = questions[questionNumber].answer
//        }
//        
//        
//        return cell
//    }
//    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if questions[questionNumber].question != nil {
//            return questions[questionNumber].question
//        }
//        return ""
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

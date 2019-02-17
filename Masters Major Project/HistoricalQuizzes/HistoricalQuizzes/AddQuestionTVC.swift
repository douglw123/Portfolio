//
//  AddQuestionTVC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 04/04/2018.
//  Copyright © 2018 Doug Williams. All rights reserved.
//

import UIKit

class AddQuestionTVC: UITableViewController {

    
    @IBOutlet weak var doneButton: UIBarButtonItem!
 
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    
    @IBOutlet weak var wrongAnswer1TextField: UITextField!
    @IBOutlet weak var wrongAnswer2TextField: UITextField!
    @IBOutlet weak var wrongAnswer3TextField: UITextField!
    
    @IBOutlet weak var QuizCell: UITableViewCell!
    
    var selectedQuiz:Quiz?
    
    let coreDataHandler = CoreDataHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargetsToTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setQuizNameOnQuizCell()
    }
    
    func setQuizNameOnQuizCell() {
        if selectedQuiz != nil {
            QuizCell.detailTextLabel?.text = selectedQuiz?.name
            textFieldsAreNotEmpty(sender: nil)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        let user = coreDataHandler.getLoggedInUser()
        if user != nil {
            let quizID = Int((selectedQuiz?.quizID) ?? 0)
            
            let newQuestion = coreDataHandler.addQuestion(questionID: 0, quizID: quizID, questionString: questionTextField.text!, answer: answerTextField.text!)
            
            let newWrongAnswer1 = coreDataHandler.addWrongAnswer(wrongAnswerID: 0, questionID: 0, wrongAnswerString: wrongAnswer1TextField.text!)
            let newWrongAnswer2 = coreDataHandler.addWrongAnswer(wrongAnswerID: 0, questionID: 0, wrongAnswerString: wrongAnswer2TextField.text!)
            let newWrongAnswer3 = coreDataHandler.addWrongAnswer(wrongAnswerID: 0, questionID: 0, wrongAnswerString: wrongAnswer3TextField.text!)
            
            newQuestion.user = user
            newQuestion.userID = (user?.userID)!
            newQuestion.quiz = selectedQuiz
            
            newWrongAnswer1.user = user
            newWrongAnswer2.user = user
            newWrongAnswer3.user = user
            
            newWrongAnswer1.userID = (user?.userID)!
            newWrongAnswer2.userID = (user?.userID)!
            newWrongAnswer3.userID = (user?.userID)!
            
            newWrongAnswer1.question = newQuestion
            newWrongAnswer2.question = newQuestion
            newWrongAnswer3.question = newQuestion
            
            
            coreDataHandler.saveManagedContext()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func addTargetsToTextFields() {
        questionTextField.addTarget(self, action: #selector(textFieldsAreNotEmpty),
                                for: .editingChanged)
        answerTextField.addTarget(self, action: #selector(textFieldsAreNotEmpty),
                               for: .editingChanged)
        wrongAnswer1TextField.addTarget(self, action: #selector(textFieldsAreNotEmpty),
                                     for: .editingChanged)
        wrongAnswer2TextField.addTarget(self, action: #selector(textFieldsAreNotEmpty),
                                     for: .editingChanged)
        wrongAnswer3TextField.addTarget(self, action: #selector(textFieldsAreNotEmpty),
                                     for: .editingChanged)
    }
    
    func textFieldsAreNotEmpty(sender: UITextField?) {
        //based on code from http://stackoverflow.com/questions/34941069/enable-a-button-in-swift-only-if-all-text-fields-have-been-filled-out
        
        guard
            //let text = sender.text?.trimmingCharacters(in: .whitespaces), !text.isEmpty,
            let questionText = questionTextField.text?.trimmingCharacters(in: .whitespaces), !questionText.isEmpty,
            let answerText = answerTextField.text?.trimmingCharacters(in: .whitespaces), !answerText.isEmpty,
            let wrongAnswerText1 = wrongAnswer1TextField.text?.trimmingCharacters(in: .whitespaces), !wrongAnswerText1.isEmpty,
            let wrongAnswerText2 = wrongAnswer2TextField.text?.trimmingCharacters(in: .whitespaces), !wrongAnswerText2.isEmpty,
            let wrongAnswerText3 = wrongAnswer3TextField.text?.trimmingCharacters(in: .whitespaces), !wrongAnswerText3.isEmpty,
            let _ = selectedQuiz
            else{
                self.doneButton.isEnabled = false
                return
        }
        doneButton.isEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? UINavigationController {
            if let quizzesList = controller.viewControllers.first as? QuizzesListTVC {
                quizzesList.selectedQuiz = selectedQuiz
                quizzesList.isAddingQuestion = true
                //removed question data
            }
        }
    }
    
    @IBAction func addQuestionExitAction(_ segue:UIStoryboardSegue){
        //        if let controller = segue.source as? (?) {
        //
        //        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        else if section == 1 {
            return 3
        }
        else if section == 2 {
            return 1
        }
        else {
            return 0
        }

    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

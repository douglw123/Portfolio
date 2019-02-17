//
//  EditQuestionTVC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 12/06/2018.
//  Copyright © 2018 Doug Williams. All rights reserved.
//

import UIKit

class EditQuestionTVC: AddQuestionTVC {

    @IBOutlet weak var deleteCell: UITableViewCell!
    
    var selectedQuestion:Question?
    var wrongAnswersForSelectedQuestion:[WrongAnswer]?
    
    let areYouSureAlert = UIAlertController(title: "Deleting Question", message: "Are you sure you want to delete this question?", preferredStyle: UIAlertControllerStyle.alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wrongAnswersForSelectedQuestion = selectedQuestion?.wrongAnswers?.allObjects as? [WrongAnswer]
        selectedQuiz = selectedQuestion?.quiz
        
        if (selectedQuestion?.deleteOnNextSync)! {
            deleteCell.isUserInteractionEnabled = false
            deleteCell.contentView.backgroundColor = UIColor.gray
        }
        
        areYouSureAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
            self.selectedQuestion?.deleteOnNextSync = true
            self.coreDataHandler.saveManagedContext()
            self.deleteCell.isUserInteractionEnabled = false
            self.deleteCell.contentView.backgroundColor = UIColor.gray
        }))
        
        areYouSureAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))

        
        questionTextField.text = selectedQuestion?.question
        answerTextField.text = selectedQuestion?.answer
        if wrongAnswersForSelectedQuestion?.count ?? 0 != 0  {
            wrongAnswer1TextField.text = wrongAnswersForSelectedQuestion?[0].wrongAnswer ?? ""
            
            if wrongAnswersForSelectedQuestion?.count ?? 0 > 1 {
                wrongAnswer2TextField.text = wrongAnswersForSelectedQuestion?[1].wrongAnswer ?? ""

                if wrongAnswersForSelectedQuestion?.count ?? 0 > 2 {
                    wrongAnswer3TextField.text = wrongAnswersForSelectedQuestion?[2].wrongAnswer ?? ""
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedQuiz != selectedQuestion?.quiz {
            doneButton.isEnabled = true
        }
        setQuizNameOnQuizCell()
    }
    
    override func doneButtonPressed(_ sender: UIBarButtonItem){
        if questionTextField.text != selectedQuestion?.question {
            selectedQuestion?.question = questionTextField.text!
            selectedQuestion?.updateTimeStamp = NSDate()
        }
        
        if answerTextField.text != selectedQuestion?.answer {
            selectedQuestion?.answer = answerTextField.text!
            selectedQuestion?.updateTimeStamp = NSDate()
        }
        
        if selectedQuiz != nil {
            if selectedQuestion?.quiz != selectedQuiz {
                selectedQuestion?.quiz = selectedQuiz
                selectedQuestion?.updateTimeStamp = NSDate()
            }
        }
        
        if wrongAnswersForSelectedQuestion?.count ?? 0 >= 3 {
            if wrongAnswersForSelectedQuestion?[0].wrongAnswer != wrongAnswer1TextField.text {
                wrongAnswersForSelectedQuestion?[0].wrongAnswer = wrongAnswer1TextField.text
                wrongAnswersForSelectedQuestion?[0].updateTimeStamp = NSDate()
            }
            if wrongAnswersForSelectedQuestion?[1].wrongAnswer != wrongAnswer2TextField.text {
                wrongAnswersForSelectedQuestion?[1].wrongAnswer = wrongAnswer2TextField.text
                wrongAnswersForSelectedQuestion?[1].updateTimeStamp = NSDate()
            }
            if wrongAnswersForSelectedQuestion?[2].wrongAnswer != wrongAnswer3TextField.text {
                wrongAnswersForSelectedQuestion?[2].wrongAnswer = wrongAnswer3TextField.text
                wrongAnswersForSelectedQuestion?[2].updateTimeStamp = NSDate()
            }
            
        }
        coreDataHandler.saveManagedContext()
        dismiss(animated: true, completion: nil)
    }
    
    override func textFieldsAreNotEmpty(sender: UITextField?) {
        //based on code from http://stackoverflow.com/questions/34941069/enable-a-button-in-swift-only-if-all-text-fields-have-been-filled-out
        
        guard
            let questionText = questionTextField.text?.trimmingCharacters(in: .whitespaces), !questionText.isEmpty,
            let answerText = answerTextField.text?.trimmingCharacters(in: .whitespaces), !answerText.isEmpty,
            let wrongAnswerText1 = wrongAnswer1TextField.text?.trimmingCharacters(in: .whitespaces), !wrongAnswerText1.isEmpty,
            let wrongAnswerText2 = wrongAnswer2TextField.text?.trimmingCharacters(in: .whitespaces), !wrongAnswerText2.isEmpty,
            let wrongAnswerText3 = wrongAnswer3TextField.text?.trimmingCharacters(in: .whitespaces), !wrongAnswerText3.isEmpty,
            let _ = selectedQuiz,
            selectedQuestion?.quiz != selectedQuiz ||
            aTextFieldChangedValue()
            
            else{
                self.doneButton.isEnabled = false
                return
        }
        doneButton.isEnabled = true
    }
    
    func aTextFieldChangedValue() -> Bool {
        if questionTextField.text != selectedQuestion?.question || answerTextField.text != selectedQuestion?.answer {
            return true
        }
        else if wrongAnswersForSelectedQuestion?.count ?? 0 >= 3 {
            if wrongAnswer1TextField.text != wrongAnswersForSelectedQuestion?[0].wrongAnswer ||
                wrongAnswer2TextField.text != wrongAnswersForSelectedQuestion?[1].wrongAnswer ||
                wrongAnswer3TextField.text != wrongAnswersForSelectedQuestion?[2].wrongAnswer {
                return true
            }
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? UINavigationController {
            if let quizzesList = controller.viewControllers.first as? QuizzesListTVC {
                quizzesList.isEditingQuestion = true
                quizzesList.editQuestionTVC = self
                quizzesList.selectedQuiz = selectedQuiz
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
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
        else if section == 3 {
            return 1
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            performSegue(withIdentifier: "showQuizListFromEditQuestion", sender: nil)
        }
        else if indexPath.section == 3{
            print("Initiate Delete Protocol")
            self.present(self.areYouSureAlert, animated: true, completion: nil)
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

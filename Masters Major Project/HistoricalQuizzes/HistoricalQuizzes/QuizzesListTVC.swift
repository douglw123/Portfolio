//
//  QuizzesListTVC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 25/09/2017.
//  Copyright © 2017 Doug Williams. All rights reserved.
//

import UIKit

class QuizzesListTVC: UITableViewController {

    
    @IBOutlet weak var yourQuizzesNavigationItem: UINavigationItem!
    
    let coreDataHandler = CoreDataHandler()
    var yourQuizzes:[Quiz]?
    
    var isAddingQuestion:Bool = false
    var questionData:[String]?
    var selectedQuiz:Quiz?
    
    var isEditingQuestion:Bool = false
    var editQuestionTVC: EditQuestionTVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        }

    override func viewWillAppear(_ animated: Bool) {
//        yourQuizzes = coreDataHandler.getLoggedInUser()?.quizzes?.allObjects as? [Quiz]
//        tableView.reloadData()
        if isAddingQuestion || isEditingQuestion {
            yourQuizzesNavigationItem.title = "Select a Quiz"
            yourQuizzes = coreDataHandler.getAllQuizzes()

        }
        else{
            yourQuizzesNavigationItem.title = "Your Quizzes"
            yourQuizzes = coreDataHandler.getLoggedInUser()?.quizzes?.allObjects as? [Quiz]

        }
        tableView.reloadData()
        if selectedQuiz != nil {
            let pointIndex = yourQuizzes?.index(of: selectedQuiz!)
            let cell = tableView.cellForRow(at: IndexPath(row: pointIndex!, section: 0))
            cell?.isSelected = true
            cell?.accessoryType = .checkmark
        }
        
    }
    
    @IBAction func cancelButtonItemPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? UINavigationController {
            if let editQuizTVC = controller.viewControllers.first as? EditQuizTVC {
                editQuizTVC.selectedQuiz = selectedQuiz
            }
        }
        else if let addQuestionTVC = segue.destination as? AddQuestionTVC {
            addQuestionTVC.selectedQuiz = selectedQuiz
            //addQuestionTVC.questionData = questionData
        }

    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return yourQuizzes?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

         cell.textLabel?.text = yourQuizzes?[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedQuiz != nil {
            let pointIndex = yourQuizzes?.index(of: selectedQuiz!)
            let cell = tableView.cellForRow(at: IndexPath(row: pointIndex!, section: 0))
            cell?.accessoryType = .none
        }
        
        selectedQuiz = yourQuizzes?[indexPath.row]
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        if isAddingQuestion {
            performSegue(withIdentifier: "exitQuizzesListToAddQuestion", sender: nil)
        }
        else if isEditingQuestion{
            editQuestionTVC?.selectedQuiz = selectedQuiz
            //editQuestionTVC?.questionData = questionData
            dismiss(animated: true, completion: nil)

        }
        else {
            performSegue(withIdentifier: "showEditQuizTVC", sender: nil)
        }
    }
}

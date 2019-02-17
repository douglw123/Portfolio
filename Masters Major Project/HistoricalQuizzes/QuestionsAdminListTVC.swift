//
//  QuestionsAdminListTVC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 13/07/2018.
//  Copyright © 2018 Doug Williams. All rights reserved.
//

import UIKit

class QuestionsAdminListTVC: UITableViewController {

    let coreDataHandler = CoreDataHandler()
    var inChangeRequestMode:Bool = false
    var allQuestions:[Question]?
    
    var selectedQuestion:Question?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allQuestions = !inChangeRequestMode ? coreDataHandler.getAllQuestions() : coreDataHandler.getAllQuestionsOrderedByChangeRequests()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allQuestions?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !inChangeRequestMode {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            cell.textLabel?.text = allQuestions?[indexPath.row].question
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailedCell", for: indexPath)
            cell.textLabel?.text = allQuestions?[indexPath.row].question
            cell.detailTextLabel?.text = "CR: \(allQuestions?[indexPath.row].changeRequests?.count ?? 0)"
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedQuestion = allQuestions?[indexPath.row]
        if inChangeRequestMode {
            performSegue(withIdentifier: "showChangeRequestsForQuestion", sender: self)
            
        }
        else{
            performSegue(withIdentifier: "showEditQuestionFromAdminList", sender: self)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? UINavigationController {
            if let questionsChangeRequestsTVC = controller.viewControllers.first as? QuestionsChangeRequestsTVC {
                questionsChangeRequestsTVC.selectedQuestion = selectedQuestion
            }
            else if let editQuestionTVC = controller.viewControllers.first as? EditQuestionTVC {
                editQuestionTVC.selectedQuestion = selectedQuestion
            }
        }
    }

}

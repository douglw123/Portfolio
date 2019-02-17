//
//  QuizzesAdminListTVC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 13/07/2018.
//  Copyright © 2018 Doug Williams. All rights reserved.
//

import UIKit

class QuizzesAdminListTVC: UITableViewController {

    let coreDataHandler = CoreDataHandler()
    var inChangeRequestMode:Bool = false
    var allQuizzes:[Quiz]?
    
    var selectedQuiz:Quiz?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allQuizzes = !inChangeRequestMode ? coreDataHandler.getAllQuizzes() : coreDataHandler.getAllQuizzesOrderedByChangeRequests()
        tableView.reloadData()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return allQuizzes?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !inChangeRequestMode {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            cell.textLabel?.text = allQuizzes?[indexPath.row].name
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailedCell", for: indexPath)
            cell.textLabel?.text = allQuizzes?[indexPath.row].name
            cell.detailTextLabel?.text = "CR: \(allQuizzes?[indexPath.row].changeRequests?.count ?? 0)"
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedQuiz = allQuizzes?[indexPath.row]
        if inChangeRequestMode {
            performSegue(withIdentifier: "showChangeRequestsForQuiz", sender: self)
            
        }
        else{
            performSegue(withIdentifier: "showEditQuizFromAdminList", sender: self)
        }
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? UINavigationController {
            if let quizzesChangeRequestsTVC = controller.viewControllers.first as? QuizzesChangeRequestsTVC {
                quizzesChangeRequestsTVC.selectedQuiz = selectedQuiz
            }
            else if let editQuizTVC = controller.viewControllers.first as? EditQuizTVC {
                editQuizTVC.selectedQuiz = selectedQuiz
            }
        }
    }

}

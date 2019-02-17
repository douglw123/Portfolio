//
//  QuestionsListTVC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 25/09/2017.
//  Copyright © 2017 Doug Williams. All rights reserved.
//

import UIKit

class QuestionsListTVC: UITableViewController {

    let coreDataHandler = CoreDataHandler()
    var yourQuestions:[Question]?
    var selectedQuestion:Question?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        yourQuestions = coreDataHandler.getLoggedInUser()?.questions?.allObjects as? [Question]
        tableView.reloadData()
    }
    
    @IBAction func cancelButtonItemPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? UINavigationController {
            if let editQuestionTVC = controller.viewControllers.first as? EditQuestionTVC {
                editQuestionTVC.selectedQuestion = selectedQuestion
            }
        }
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return yourQuestions?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = yourQuestions?[indexPath.row].question

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedQuestion = yourQuestions?[indexPath.row]
        performSegue(withIdentifier: "showEditQuestionTVC", sender: nil)

    }

}

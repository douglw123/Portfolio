//
//  QuizzesChangeRequestsTVC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 12/07/2018.
//  Copyright © 2018 Doug Williams. All rights reserved.
//

import UIKit

class QuizzesChangeRequestsTVC: UITableViewController {

    let coreDataHandler = CoreDataHandler()
    var selectedQuiz:Quiz?
    var quizChangeRequests:[QuizChangeRequest]?
    
    var changeRequestToComplete:QuizChangeRequest?
    let areYouSureAlert = UIAlertController(title: "Change request completed", message: "Are you sure this request has been completed?", preferredStyle: UIAlertControllerStyle.alert)
    var changeRequestCell:ChangeRequestTVCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ChangeRequestTVCell", bundle: nil), forCellReuseIdentifier: "ChangeRequestCell")
        areYouSureAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
            self.changeRequestToComplete?.deleteOnNextSync = true
            self.coreDataHandler.saveManagedContext()
            self.changeRequestCell?.setButtonAsCompleted()
        }))
        
        areYouSureAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        quizChangeRequests = selectedQuiz?.changeRequests?.allObjects as? [QuizChangeRequest]
        tableView.reloadData()
    }

    func presentAreYouSureAlert(changeRequestCell:ChangeRequestTVCell) {
        self.changeRequestCell = changeRequestCell
        self.changeRequestToComplete = changeRequestCell.changeRequest as? QuizChangeRequest
        OperationQueue.main.addOperation{
            self.present(self.areYouSureAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizChangeRequests?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeRequestCell", for: indexPath)
        let changeRequestCustomCell = cell as! ChangeRequestTVCell
        
        let selectedQuizChangeRequest = quizChangeRequests?[indexPath.row]
        
        changeRequestCustomCell.messageLabel.text = selectedQuizChangeRequest?.message
        changeRequestCustomCell.changeRequestTVC = self
        changeRequestCustomCell.changeRequest = selectedQuizChangeRequest
        
        if (selectedQuizChangeRequest?.deleteOnNextSync)! {
            changeRequestCustomCell.setButtonAsCompleted()
        }
        
        return changeRequestCustomCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? UINavigationController {
            if let editQuizTVC = controller.viewControllers.first as? EditQuizTVC {
                editQuizTVC.selectedQuiz = selectedQuiz
            }
        }
    }
    

}

//
//  AdministratorPanelTVC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 13/07/2018.
//  Copyright © 2018 Doug Williams. All rights reserved.
//

import UIKit

class AdministratorPanelTVC: UITableViewController {

    @IBOutlet weak var pointOfInterestChangeRequestsCell: UITableViewCell!

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1{
            return 3
        }
        else if section == 2{
            return 3
        }
        else {
            return 0
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? UINavigationController {
            if let pointsOfInterestAdminListTVC = controller.viewControllers.first as? PointsOfInterestAdminListTVC {
                if let sender = sender as? UITableViewCell {
                    if sender == pointOfInterestChangeRequestsCell {
                        pointsOfInterestAdminListTVC.inChangeRequestMode = true
                    }
                }
            }
            else if let quizAdminListTVC = controller.viewControllers.first as? QuizzesAdminListTVC {
                if segue.identifier == "showQuizzesOrderedByChangeRequests" {
                    quizAdminListTVC.inChangeRequestMode = true
                }
            }
            else if let questionAdminListTVC = controller.viewControllers.first as? QuestionsAdminListTVC {
                if segue.identifier == "showQuestionsOrderedByChangeRequests" {
                    questionAdminListTVC.inChangeRequestMode = true
                }
            }
        }
    }

}

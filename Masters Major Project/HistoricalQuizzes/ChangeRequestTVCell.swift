//
//  ChangeRequestTVCell.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 13/07/2018.
//  Copyright © 2018 Doug Williams. All rights reserved.
//

import UIKit

class ChangeRequestTVCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var completedButton: UIButton!
    
    var changeRequest:ChangeRequest?
    var changeRequestTVC:UITableViewController?
    
    func setButtonAsCompleted() {
        completedButton.isEnabled = false
        completedButton.backgroundColor = UIColor.gray
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if let pointOfInterestChangeRequestTVC = changeRequestTVC as? PointsOfInterestChangeRequestsTVC {
            pointOfInterestChangeRequestTVC.presentAreYouSureAlert(changeRequestCell: self)
        }
        else if let quizChangeRequestTVC = changeRequestTVC as? QuizzesChangeRequestsTVC {
            quizChangeRequestTVC.presentAreYouSureAlert(changeRequestCell: self)
        }
        else if let questionChangeRequestTVC = changeRequestTVC as? QuestionsChangeRequestsTVC {
            questionChangeRequestTVC.presentAreYouSureAlert(changeRequestCell: self)
        }
    }
    
}

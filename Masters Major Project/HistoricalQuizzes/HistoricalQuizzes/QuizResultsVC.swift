//
//  QuizResultsVC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 02/06/2018.
//  Copyright © 2018 Doug Williams. All rights reserved.
//

import UIKit

class QuizResultsVC: UIViewController {
    
    @IBOutlet weak var resultsCircle: ResultsCircle!
    @IBOutlet weak var percentageLabel: UILabel!
    
    var percentage:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsCircle.percentage = percentage
        percentageLabel.text = "\(percentage)%"
        resultsCircle.animateCircle()
    }
    
    @IBAction func backToMapButtonPressed(_ sender: UIButton) {
        let coreDataHandler = CoreDataHandler()
        if coreDataHandler.getLoggedInUser()?.isAdministrator ?? false {
            performSegue(withIdentifier: "exitQuizResultsToAdministratorUserTabBar", sender: nil)
        }
        else{
            performSegue(withIdentifier: "exitQuizResultsToAuthorisedUserTabBar", sender: nil)
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

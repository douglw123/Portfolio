//
//  AddQuizTVC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 04/04/2018.
//  Copyright © 2018 Doug Williams. All rights reserved.
//

import UIKit

class AddQuizTVC: UITableViewController {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pointOfinterestDetailTextField: UILabel!
    
    
    var selectedPointOfinterest:PointOfInterest?
    var selectedPointsOfInterest:[TableMultipleSlectionPointOfInterest]?
    //var quizNameString:String?
    
    let coreDataHandler = CoreDataHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargetsToTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if selectedPointOfinterest != nil {
//            pointOfinterestDetailTextField.text = selectedPointOfinterest?.title
//        }
        if selectedPointsOfInterest != nil {
            var count = 0
            for point in selectedPointsOfInterest! {
                if point.isSelected {
                    count += 1
                }
            }
            pointOfinterestDetailTextField.text = "\(count)"
        }
        textFieldsAreNotEmpty(sender: nil)
    }

    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        let user = coreDataHandler.getLoggedInUser()
        if user != nil {
            let newQuiz = coreDataHandler.addQuiz(quizID: 0, name: nameTextField.text!)
            
//            newQuiz.addToPointsOfInterest(selectedPointOfinterest!)
            
            for point in selectedPointsOfInterest! {
                if point.isSelected {
                    newQuiz.addToPointsOfInterest(point.pointOfInterest!)
                }
            }
            
            newQuiz.user = user
            newQuiz.userID = (user?.userID)!
            coreDataHandler.saveManagedContext()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func addTargetsToTextFields() {
        nameTextField.addTarget(self, action: #selector(textFieldsAreNotEmpty),
                                 for: .editingChanged)
    }
    
    func textFieldsAreNotEmpty(sender: UITextField?) {
        //based on code from http://stackoverflow.com/questions/34941069/enable-a-button-in-swift-only-if-all-text-fields-have-been-filled-out
        
        guard
            let nameString = nameTextField.text?.trimmingCharacters(in: .whitespaces), !nameString.isEmpty,selectedPointsOfInterest != nil
            else{
                self.doneButton.isEnabled = false
                return
        }
        doneButton.isEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? UINavigationController {
            if let pointsOfInterestList = controller.viewControllers.first as? PointsOfInterestListTVC {
                pointsOfInterestList.selectedPointOfinterest = selectedPointOfinterest
                pointsOfInterestList.selectedPointsOfInterest = selectedPointsOfInterest ?? nil
                pointsOfInterestList.isAddingQuiz = true
                //pointsOfInterestList.quizName = nameTextField.text
                pointsOfInterestList.addQuizTVC = self
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        else if section == 1 {
            return 1
        }
        else {
            return 0
        }
    }

}

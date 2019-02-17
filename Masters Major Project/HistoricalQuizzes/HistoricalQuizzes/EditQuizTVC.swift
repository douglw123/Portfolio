//
//  EditQuizTVC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 09/06/2018.
//  Copyright © 2018 Doug Williams. All rights reserved.
//

import UIKit

class EditQuizTVC: UITableViewController {

    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var quizNameTextField: UITextField!
    @IBOutlet weak var deleteCell: UITableViewCell!
    
    var selectedQuiz:Quiz?
    let coreDataHandler = CoreDataHandler()
    let areYouSureAlert = UIAlertController(title: "Deleting Quiz", message: "Are you sure you want to delete this quiz?", preferredStyle: UIAlertControllerStyle.alert)
    
    let deleteNotPossibleAlert = UIAlertController(title: "Deleting Quiz", message: "You can not delete this quiz, you must first delete all associated questions", preferredStyle: UIAlertControllerStyle.alert)
    
    var selectedPointsOfInterest:[TableMultipleSlectionPointOfInterest]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quizNameTextField.text = selectedQuiz?.name
        addTargetsToTextFields()
        
        if (selectedQuiz?.deleteOnNextSync)! {
            deleteCell.isUserInteractionEnabled = false
            deleteCell.contentView.backgroundColor = UIColor.gray
        }
        
        areYouSureAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
            self.selectedQuiz?.deleteOnNextSync = true
            self.coreDataHandler.saveManagedContext()
            self.deleteCell.isUserInteractionEnabled = false
            self.deleteCell.contentView.backgroundColor = UIColor.gray
        }))
        
        areYouSureAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        deleteNotPossibleAlert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler: nil))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedPointsOfInterest != nil {
            saveButton.isEnabled = true
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        if quizNameTextField.text != selectedQuiz?.name {
            selectedQuiz?.name = quizNameTextField.text!
        }
        
        if selectedPointsOfInterest != nil {
            print("selected points not nil")
            let oldPoints = selectedQuiz?.pointsOfInterest?.allObjects as? [PointOfInterest]
            if oldPoints != nil {
                for oldPoint in oldPoints! {
                    selectedQuiz?.removeFromPointsOfInterest(oldPoint)
                }
            }
            for newPoint in selectedPointsOfInterest! {
                if newPoint.isSelected {
                    selectedQuiz?.addToPointsOfInterest(newPoint.pointOfInterest!)
                }
            }
        }
        selectedQuiz?.updateTimeStamp = NSDate()
        
        coreDataHandler.saveManagedContext()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func addTargetsToTextFields() {
        quizNameTextField.addTarget(self, action: #selector(nameTextFieldIsNotEmptyOrTheSameAsStoredName),
                                 for: .editingChanged)
    }
    
    func nameTextFieldIsNotEmptyOrTheSameAsStoredName(sender: UITextField) {
        //based on code from http://stackoverflow.com/questions/34941069/enable-a-button-in-swift-only-if-all-text-fields-have-been-filled-out
        
        guard
            let nameString = quizNameTextField.text?.trimmingCharacters(in: .whitespaces), !nameString.isEmpty,
            quizNameTextField.text != selectedQuiz?.name
            else{
                self.saveButton.isEnabled = false
                return
        }
        saveButton.isEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? UINavigationController {
            if let pointsOfInterstListTVC = controller.viewControllers.first as? PointsOfInterestListTVC {
                pointsOfInterstListTVC.editQuizTVC = self
                pointsOfInterstListTVC.isEditingQuiz = true
                pointsOfInterstListTVC.editingQuizPoints = selectedQuiz?.pointsOfInterest?.allObjects as? [PointOfInterest]
            }
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            performSegue(withIdentifier: "showPointsOfInterestFromEditQuiz", sender: nil)
        }
        else if indexPath.row == 2 {
            print("Initiate Delete Protocol")
            if selectedQuiz?.questions?.count ?? 0 > 0 {
                self.present(self.deleteNotPossibleAlert, animated: true, completion: nil)
            }
            else{
                self.present(self.areYouSureAlert, animated: true, completion: nil)
            }
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

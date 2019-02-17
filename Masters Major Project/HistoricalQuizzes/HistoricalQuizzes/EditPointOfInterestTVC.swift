//
//  EditPointOfInterestTVC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 05/04/2018.
//  Copyright © 2018 Doug Williams. All rights reserved.
//

import UIKit

class EditPointOfInterestTVC: UITableViewController {

    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var deleteCell: UITableViewCell!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var isFromAdmin:Bool = false
    let coreDataHandler = CoreDataHandler()
    
//    var locationChanged:Bool = false
    var newLocationPin:MKPin?
    
    let areYouSureAlert = UIAlertController(title: "Deleting Point Of Interest", message: "Are you sure you want to delete this point of interest?", preferredStyle: UIAlertControllerStyle.alert)

    let deleteNotPossibleAlert = UIAlertController(title: "Deleting Point Of Interest", message: "You can not delete this point of interest, you must first delete the associated quizzes", preferredStyle: UIAlertControllerStyle.alert)
    
    var selectedPointOfinterest:PointOfInterest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.text = selectedPointOfinterest?.title
        //titleTextField.isEnabled = true
        addTargetsToTextFields()
        
        if (selectedPointOfinterest?.deleteOnNextSync)! {
            deleteCell.isUserInteractionEnabled = false
            deleteCell.contentView.backgroundColor = UIColor.gray
        }
        
        areYouSureAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
            self.selectedPointOfinterest?.deleteOnNextSync = true
            self.coreDataHandler.saveManagedContext()
            self.deleteCell.isUserInteractionEnabled = false
            self.deleteCell.contentView.backgroundColor = UIColor.gray
        }))
        
        areYouSureAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        deleteNotPossibleAlert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler: nil))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if newLocationPin != nil {
            saveButton.isEnabled = true
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if titleTextField.text != selectedPointOfinterest?.title {
            selectedPointOfinterest?.title = titleTextField.text!
        }
        
        if newLocationPin != nil {
            let latitude = (newLocationPin?.coordinate.latitude)!
            let longitude = (newLocationPin?.coordinate.longitude)!
            
            selectedPointOfinterest?.latitude = Double(String(format: "%.6f", latitude))!
            selectedPointOfinterest?.longitude = Double(String(format: "%.6f", longitude))!
        }
        selectedPointOfinterest?.updateTimeStamp = NSDate()
        
        coreDataHandler.saveManagedContext()
        
        if isFromAdmin {
            dismiss(animated: true, completion: nil)
        }
        else{
            performSegue(withIdentifier: "exitEditPointOfInterestToPointsOfInterestList", sender: nil)
        }
        
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        if isFromAdmin {
            dismiss(animated: true, completion: nil)
        }
        else{
            performSegue(withIdentifier: "exitEditPointOfInterestToPointsOfInterestList", sender: nil)
        }
    }
    
    func addTargetsToTextFields() {
        titleTextField.addTarget(self, action: #selector(tieleTextFieldISNotEmptyOrTheSameAsStoredTitle),
                                 for: .editingChanged)
    }
    
    func tieleTextFieldISNotEmptyOrTheSameAsStoredTitle(sender: UITextField) {
        //based on code from http://stackoverflow.com/questions/34941069/enable-a-button-in-swift-only-if-all-text-fields-have-been-filled-out
        
        guard
            let tileString = titleTextField.text?.trimmingCharacters(in: .whitespaces), !tileString.isEmpty,
            titleTextField.text != selectedPointOfinterest?.title
            else{
                self.saveButton.isEnabled = newLocationPin == nil ? false : true
                return
        }
        saveButton.isEnabled = true
    }
    
    @IBAction func editPointOfInterestExitAction(_ segue:UIStoryboardSegue){
        //        if let controller = segue.source as? (?) {
        //
        //        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        if indexPath.row == 1 {
            print("Go to map selection screen")
            //goToMapToEditPointOfInterestLocation
            performSegue(withIdentifier: "goToMapToEditPointOfInterestLocation", sender: nil)
        }
        else if indexPath.row == 2 {
            print("Initiate Delete Protocol")
            if selectedPointOfinterest?.quizzes?.count ?? 0 > 0 {
                self.present(self.deleteNotPossibleAlert, animated: true, completion: nil)
            }
            else{
                self.present(self.areYouSureAlert, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? UINavigationController {
            if let mapTabVC = controller.viewControllers.first as? MapTabVC {
                mapTabVC.addSaveButtonItem()
                mapTabVC.isEditingPointOfInterestLocation = true
                mapTabVC.editPointOfInterestController = self
//                if !(titleTextField.text?.isEmpty)! {
//                    mapTabVC.newPointOfInterestTitle = titleTextField.text
//                }
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

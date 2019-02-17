//
//  AddPointOfInterestTVC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 25/09/2017.
//  Copyright © 2017 Doug Williams. All rights reserved.
//

import UIKit

class AddPointOfInterestTVC: UITableViewController {

    
    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    
    
    let coreDataHandler = CoreDataHandler()
    var latitude:Double?
    var longitude:Double?
    var titleString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargetsToTextFields()
        if titleString != nil {
            titleTextField.text = titleString
            doneButtonItem.isEnabled = true
        }
    }
    
    @IBAction func doneButtonItemPressed(_ sender: UIBarButtonItem) {
        let user = coreDataHandler.getLoggedInUser()
        if user != nil {
            let newPointOfInterest = coreDataHandler.addPointOfInterest(pointOfInterestID: 0, title: titleTextField.text!, latitude: Double(String(format: "%.6f", latitude!))!, longitude: Double(String(format: "%.6f", longitude!))!)
            
            newPointOfInterest.user = user
            newPointOfInterest.userID = (user?.userID)!
            coreDataHandler.saveManagedContext()
        }
        
        performSegue(withIdentifier: "exitAddPointOfInterestToPointsOfInterestList", sender: nil)
    }
    
    func addTargetsToTextFields() {
        titleTextField.addTarget(self, action: #selector(textFieldsAreNotEmpty),
                                         for: .editingChanged)
    }
    
    func textFieldsAreNotEmpty(sender: UITextField?) {
        //based on code from http://stackoverflow.com/questions/34941069/enable-a-button-in-swift-only-if-all-text-fields-have-been-filled-out
        
        guard
            let tileString = titleTextField.text?.trimmingCharacters(in: .whitespaces), !tileString.isEmpty,
            latitude != nil, longitude != nil
            else{
                self.doneButtonItem.isEnabled = false
                return
        }
        doneButtonItem.isEnabled = true
    }
    
    @IBAction func cancelButtonItemPressed(_ sender: UIBarButtonItem) {
        //self.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "exitAddPointOfInterestToPointsOfInterestList", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? UINavigationController {
            if let mapTabVC = controller.viewControllers.first as? MapTabVC {
                mapTabVC.addSaveButtonItem()
                if !(titleTextField.text?.isEmpty)! {
                    mapTabVC.newPointOfInterestTitle = titleTextField.text
                }
            }
        }
    }
    
    @IBAction func addPointOfInterestExitAction(_ segue:UIStoryboardSegue){
        textFieldsAreNotEmpty(sender: nil)
        //        if let controller = segue.source as? (?) {
        //
        //        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 1
        }
        else {
            return 1
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

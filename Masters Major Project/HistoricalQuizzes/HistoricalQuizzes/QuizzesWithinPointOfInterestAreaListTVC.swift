//
//  QuizzesWithinPointOfInterestAreaListTVC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 29/09/2017.
//  Copyright © 2017 Doug Williams. All rights reserved.
//

import UIKit

class QuizzesWithinPointOfInterestAreaListTVC: UITableViewController {

    let coreDataHandler = CoreDataHandler()
    var pointOfInterest:PointOfInterest?
    var quizzesInPointOfInterestArea:[Quiz]?
    var selectedQuiz:Quiz?
    let alert = UIAlertController(title: "Request a Change", message: "Please describe the change that is needed", preferredStyle: UIAlertControllerStyle.alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Enter your change request message"
            self.alert.addAction(UIAlertAction(title: "Send Request", style: UIAlertActionStyle.default) { (alertAction:UIAlertAction) in
                
                let text:String? = self.alert.textFields?.first?.text
                let textWithNoWhiteSpaces = text?.trimmingCharacters(in: .whitespaces)
                let textCharCount = text?.characters.count ?? 257

                if !(textWithNoWhiteSpaces?.isEmpty)! && textCharCount < 256 && textWithNoWhiteSpaces != nil{
                    self.alert.message = "Please describe the change that is needed"
                    
                    _ = self.coreDataHandler.addPointOfInterestChangeRequest(pointOfInterestChangeRequestID: 0, pointOfInterest: self.pointOfInterest!, user: self.coreDataHandler.getLoggedInUser(), message: text!)
                    
                    
                    self.coreDataHandler.saveManagedContext()
                    
                    //print(text!)
                    self.alert.textFields?.first?.text?.removeAll()
                }
                else{
                    print("empty")
                    self.alert.message = "Your change request message must not be empty or be more than 255 characters, please try again"
                    self.present(self.alert, animated: true, completion: nil)
                }
            })
            self.alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let allQuizzesInArea = pointOfInterest?.quizzes?.allObjects as? [Quiz]
        quizzesInPointOfInterestArea = [Quiz]()
        if allQuizzesInArea != nil {
            
            for quizInArea in allQuizzesInArea! {
                if quizInArea.questions != nil && quizInArea.questions?.count != 0 {
                    quizzesInPointOfInterestArea?.append(quizInArea)
                }
            }
            
        }
        tableView.reloadData()
    }
    
    @IBAction func cancelButtonItemPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeRequestButtonPressed(_ sender: UIBarButtonItem) {
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? UINavigationController {
            if let quizTVC = controller.viewControllers.first as? QuizTVC {
                quizTVC.quiz = selectedQuiz
            }
        }
    }
    
    @IBAction func quizzesWithinPointOfInterestAreaListExitAction(_ segue:UIStoryboardSegue){
        //        if let controller = segue.source as? (?) {
        //
        //        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzesInPointOfInterestArea?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = quizzesInPointOfInterestArea?[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedQuiz = quizzesInPointOfInterestArea?[indexPath.row]
        performSegue(withIdentifier: "showQuizTable", sender: nil)
    }
    

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

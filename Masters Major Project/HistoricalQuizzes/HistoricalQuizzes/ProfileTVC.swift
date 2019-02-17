//
//  ProfileTVC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 24/09/2017.
//  Copyright © 2017 Doug Williams. All rights reserved.
//

import UIKit

class ProfileTVC: UITableViewController {

    @IBOutlet weak var firstNameCell: UITableViewCell!
    @IBOutlet weak var lastNameCell: UITableViewCell!
    @IBOutlet weak var userNameCell: UITableViewCell!
    @IBOutlet weak var passwordCell: UITableViewCell!
    @IBOutlet weak var emailCell: UITableViewCell!
    
    let coreDataHandler = CoreDataHandler()
    let databaseHandler = DatabaseHandler()
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var editAndCancelButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var logoutButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //print(coreDataHandler.getLoggedInUser()?.firstName)
        editAndCancelButtonItem.possibleTitles = NSSet(objects: "Edit","Cancel") as? Set<String>
        logoutButtonItem.possibleTitles = NSSet(objects: "Log out","Done") as? Set<String>
        firstNameCell.selectionStyle = .none
        lastNameCell.selectionStyle = .none
        userNameCell.selectionStyle = .none
        passwordCell.selectionStyle = .none
        emailCell.selectionStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
       setTextFieldsTextValues()
    }

    @IBAction func editButtonItemPressed(_ sender: UIBarButtonItem) {
        if sender.title == "Cancel" {
            setTextFieldsTextValues()
        }
        
        sender.title = sender.title == "Edit" ? "Cancel" : "Edit"
        logoutButtonItem.title = logoutButtonItem.title == "Log out" ? "Done" : "Log out"
        
        firstNameTextField.isEnabled = !firstNameTextField.isEnabled
        lastNameTextField.isEnabled = !lastNameTextField.isEnabled
        usernameTextField.isEnabled = !usernameTextField.isEnabled
        passwordTextField.isEnabled = !passwordTextField.isEnabled
        emailTextField.isEnabled = !emailTextField.isEnabled
        
    }

    @IBAction func logoutButtonItemPressed(_ sender: UIBarButtonItem) {
        if sender.title == "Log out" {
            if self.view.window?.rootViewController is BasicUserTBC{
                performSegue(withIdentifier: "exitYourProfileToBasicUserTabBar", sender: nil)
            }
            else{
                performSegue(withIdentifier: "logoutSegue", sender: nil)
            }
            
            databaseHandler.logOut()
        }
        else{
            print(firstNameTextField.text!)
            sender.title = sender.title == "Log out" ? "Done" : "Log out"
        }
        
    }
    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        print(identifier)
//        if identifier == "exitYourProfileToBasicUserTabBar" {
//            print("exit to basic")
//            if self.view.window?.rootViewController is BasicUserTBC{
//                print("is basic tab bar")
//            }
//            else if self.view.window?.rootViewController is ProfileTVC{
//                print("is profile")
//            }
//            else {
//                print("is NOT basic tab bar")
//            }
//        }
//        return true
//    }
    
    
    
    func setTextFieldsTextValues() {
        let user = coreDataHandler.getLoggedInUser()
        firstNameTextField.text = user?.firstName ?? ""
        lastNameTextField.text = user?.lastName ?? ""
        usernameTextField.text = user?.username ?? ""
        passwordTextField.text = user?.password ?? ""
        emailTextField.text = user?.email ?? ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPointsOfInterestList" {
            coreDataHandler.setUserForPointsOfInterest()
        }
        else if segue.identifier == "showQuizzesList" {
            coreDataHandler.setUserForQuizzes()
        }
        else if segue.identifier == "showQuestionsList" {
            coreDataHandler.setUserForQuestions()
        }
    }
    
    @IBAction func yourProfileExitAction(_ segue:UIStoryboardSegue){
//        if let controller = segue.source as? (?) {
//            
//        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }
        else{
            return 3
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

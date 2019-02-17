//
//  RegisterTVC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 25/05/2018.
//  Copyright © 2018 Doug Williams. All rights reserved.
//

import UIKit

class RegisterTVC: UITableViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    let coreDataHandler = CoreDataHandler()
    let databaseHandler = DatabaseHandler()

    override func viewDidLoad() {
        super.viewDidLoad()
        addTargetsToTextFields()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        let newUser = coreDataHandler.addUser(userID: 0, username: userNameTextField.text!, password: passwordTextField.text!, email: emailTextField.text!, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, isAdministrator: false)
        databaseHandler.registerUser(user: newUser) { (registerSuccessful:Bool,databaseViolationReason:String?) in
            if(registerSuccessful){
                self.dismiss(animated: true, completion: nil)
            }
            else{
                self.coreDataHandler.removeAllUsers()
                OperationQueue.main.addOperation{
                    var message:String
                    if databaseViolationReason == "duplicate" {
                        message = "The username or email address you provided already exists please choose a diffrent one"
                    }
                    else if databaseViolationReason == "exceeded varchar limit" {
                        message = "You have excceed the 20 character limit on one or more of your name entries, or your email is more than 255 characters. "
                    }
                    else if databaseViolationReason == nil{
                        message = "You currently have no internet connect or the server is unavailable. Please check you have internet connection before trying again."
                    }
                    else{
                        message = "An unknown error has prevented you from registering please check the information you have provided."
                    }
                    
                    let alert = UIAlertController(title: "Registering Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func addTargetsToTextFields() {
        firstNameTextField.addTarget(self, action: #selector(textFieldsAreNotEmpty),
                                    for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldsAreNotEmpty),
                                  for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldsAreNotEmpty),
                                        for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(textFieldsAreNotEmpty),
                                    for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldsAreNotEmpty),
                                        for: .editingChanged)
    }
    
    func textFieldsAreNotEmpty(sender: UITextField?) {
        //based on code from http://stackoverflow.com/questions/34941069/enable-a-button-in-swift-only-if-all-text-fields-have-been-filled-out
        
        guard
            //let text = sender.text?.trimmingCharacters(in: .whitespaces), !text.isEmpty,
            let firstNameText = firstNameTextField.text?.trimmingCharacters(in: .whitespaces), !firstNameText.isEmpty,
            let lastNameText = lastNameTextField.text?.trimmingCharacters(in: .whitespaces),!lastNameText.isEmpty,
            let emailText = emailTextField.text?.trimmingCharacters(in: .whitespaces),!emailText.isEmpty,
            let usernameText = userNameTextField.text?.trimmingCharacters(in: .whitespaces),!usernameText.isEmpty,
            let passwordText = passwordTextField.text?.trimmingCharacters(in: .whitespaces),!passwordText.isEmpty
            else{
                self.doneButton.isEnabled = false
                return
        }
        doneButton.isEnabled = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 0 {
            let header = view as! UITableViewHeaderFooterView
            header.textLabel?.textColor = UIColor.white
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

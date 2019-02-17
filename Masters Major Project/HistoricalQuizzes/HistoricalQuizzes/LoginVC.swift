//
//  LoginVC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 22/09/2017.
//  Copyright © 2017 Doug Williams. All rights reserved.
//

import UIKit
class LoginVC: UIViewController {
    
    let databaseHandler = DatabaseHandler()

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        if (username != nil) && (password != nil) {
            databaseHandler.login(username: username!, password: password!) { (isSuccessful) in
                if(isSuccessful){
                    //print("user logged in")
                    let segueID:String = DatabaseHandler.userInfo.isAdministrator ? "showAdministratorTBC" : "showAuthorisedUserTBC"
                    OperationQueue.main.addOperation{
                    self.performSegue(withIdentifier: segueID, sender: nil)
                    }
                }
                else{
                    OperationQueue.main.addOperation{
                        let alert = UIAlertController(title: "Login Failed", message: "Username or password didn't match", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    //print("user was not logged in")
                    //add red text with explanation is banned or wrong password ect
                }
            }
        }
    }

}

//
//  ViewController.swift
//  PHPConectionWithPostDataSpike
//
//  Created by Doug Williams on 07/09/2017.
//  Copyright © 2017 Doug Williams. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let databaseHandler:DatabaseHandler = DatabaseHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func buttonPressed(_ sender: UIButton) {
         databaseHandler.getUser(urlStringPath: "http://localhost:8888/HistoricalQuizzesServerSidePDO.php", username: "testUserName1", password: "password")
    }
    


}


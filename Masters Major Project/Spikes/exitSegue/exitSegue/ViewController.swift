//
//  ViewController.swift
//  exitSegue
//
//  Created by Doug Williams on 11/07/2018.
//  Copyright © 2018 Doug Williams. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func redButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func exitFromExitVC2(_ segue: UIStoryboardSegue) {
        print("exit")
        if let exitVC = segue.source as? ExitVC {
            print(exitVC.textField.text ?? "no text")
        }
    }


}


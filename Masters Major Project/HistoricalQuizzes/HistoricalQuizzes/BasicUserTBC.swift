//
//  BasicUserTBC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 11/07/2018.
//  Copyright © 2018 Doug Williams. All rights reserved.
//

import UIKit

class BasicUserTBC: UITabBarController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let rootViewController = appDelegate.window?.rootViewController
        
        if rootViewController != nil {
            let isOfTypeBasicUserTBC = rootViewController is BasicUserTBC
            
            if !isOfTypeBasicUserTBC {
                appDelegate.window?.rootViewController = self
                appDelegate.window?.makeKeyAndVisible()
            }
        }

    }
    
    @IBAction func basicUserTabBarExitAction(_ segue:UIStoryboardSegue){
        if let controller = segue.destination as? BasicUserTBC {
            if let loginVC = controller.viewControllers?.first as? LoginVC {
                loginVC.passwordTextField.text?.removeAll()
            }
        }
    }
    
    
    
}

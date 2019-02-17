//
//  Introduction1VC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 15/08/2018.
//  Copyright © 2018 Doug Williams. All rights reserved.
//

import UIKit

class Introduction1VC: UIViewController {
    
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        let coreDataHandler = CoreDataHandler()
        coreDataHandler.storeInUserDefaults(key: "dontShowOnboardingScreensOnStartUp", data: "1")
        
        //self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

        
        let TBCIDString = AppDelegate.determineUserType()
        
        let TBC:UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: TBCIDString) as! UITabBarController
        
        self.view.window?.rootViewController = TBC
        self.view.window?.makeKeyAndVisible()
    }

}

//
//  IntroductionPVC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 09/08/2018.
//  Copyright © 2018 Doug Williams. All rights reserved.
//

import UIKit

class IntroductionPVC: UIPageViewController, UIPageViewControllerDataSource {

    lazy var introductionViewControllers:[UIViewController] = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let intro1 = storyboard.instantiateViewController(withIdentifier: "intro1")
        let intro2 = storyboard.instantiateViewController(withIdentifier: "intro2")
        let intro3 = storyboard.instantiateViewController(withIdentifier: "intro3")
        let intro4 = storyboard.instantiateViewController(withIdentifier: "intro4")
        let intro5 = storyboard.instantiateViewController(withIdentifier: "intro5")
        
        return [intro1,intro2,intro3,intro4,intro5]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        if let firstVC = introductionViewControllers.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        //corrects scrollview frame to allow for full-screen view controller pages
        for subView in self.view.subviews {
            if subView is UIScrollView {
                subView.frame = self.view.bounds
            }
        }
        super.viewDidLayoutSubviews()
    }

    // MARK: - DataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = introductionViewControllers.index(of: viewController) else {
            return nil
        }
        
        let indexBefore = vcIndex - 1
        
        guard indexBefore >= 0 else {
            return nil
        }
        
        guard introductionViewControllers.count > indexBefore else {
            return nil
        }
        
        return introductionViewControllers[indexBefore]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = introductionViewControllers.index(of: viewController) else {
            return nil
        }
        
        let indexAfter = vcIndex + 1
        
        guard indexAfter >= 0 else {
            return nil
        }
        
        guard introductionViewControllers.count != indexAfter else {
            return nil
        }
        
        guard introductionViewControllers.count > indexAfter else {
            return nil
        }
        
        return introductionViewControllers[indexAfter]
        
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return introductionViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let currentVC = viewControllers?.first else{
            return 0
        }
        
        guard let vcIndex = introductionViewControllers.index(of: currentVC) else {
            return 0
        }
        
        return vcIndex
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

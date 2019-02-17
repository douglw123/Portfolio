//
//  PointsOfInterestListTVC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 25/09/2017.
//  Copyright © 2017 Doug Williams. All rights reserved.
//

import UIKit

class PointsOfInterestListTVC: UITableViewController {
    
    @IBOutlet weak var yourPointsNavigationItem: UINavigationItem!
    
    var saveButtonItem:UIBarButtonItem?
    
    let coreDataHandler = CoreDataHandler()
    var yourPointsOfInterest:[PointOfInterest]?
    
    var isAddingQuiz:Bool = false
    var isEditingQuiz:Bool = false
    var quizName:String?
    var selectedPointOfinterest:PointOfInterest?
    
    //var selectedPointsOfInterest = [PointOfInterest]()
    var selectedPointsOfInterest:[TableMultipleSlectionPointOfInterest]?
    var addQuizTVC:AddQuizTVC?
    var editQuizTVC:EditQuizTVC?
    var editingQuizPoints:[PointOfInterest]?

    override func viewDidLoad() {
        super.viewDidLoad()
        if isAddingQuiz || isEditingQuiz {
            tableView.allowsMultipleSelection = true
            yourPointsNavigationItem.title = "Select a Point of Interest"
            addSaveButtonItem()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        yourPointsOfInterest = isAddingQuiz || isEditingQuiz ? coreDataHandler.getAllPointsOfinterest() : coreDataHandler.getLoggedInUser()?.pointsOfInterest?.allObjects as? [PointOfInterest]

        if selectedPointsOfInterest == nil {
            if yourPointsOfInterest != nil {
                selectedPointsOfInterest = [TableMultipleSlectionPointOfInterest]()
                if isEditingQuiz && editingQuizPoints != nil {
                    
                    for point in yourPointsOfInterest! {
                        if isPointOfInterestLinkedToQuiz(pointOfInterest: point) {
                            selectedPointsOfInterest?.append(TableMultipleSlectionPointOfInterest(pointOfInterest: point, isSelected: true))
                            
                        }
                        else{
                            selectedPointsOfInterest?.append(TableMultipleSlectionPointOfInterest(pointOfInterest: point))
                        }
                    }
                }
                else{
                    for point in yourPointsOfInterest! {
                        selectedPointsOfInterest?.append(TableMultipleSlectionPointOfInterest(pointOfInterest: point))
                    }
                }
                
            }
        }
        
        
        tableView.reloadData()
//        if selectedPointOfinterest != nil {
//            let pointIndex = yourPointsOfInterest?.index(of: selectedPointOfinterest!)
//            let cell = tableView.cellForRow(at: IndexPath(row: pointIndex!, section: 0))
//            cell?.accessoryType = .checkmark
//        }
    }
    
    @IBAction func cancelButtonItemPressed(_ sender: UIBarButtonItem) {
    
        if !isAddingQuiz && !isEditingQuiz {
            performSegue(withIdentifier: "exitYourPointsOfInterestToYourProfile", sender: nil)
        }
        else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    func addSaveButtonItem() {
        let saveButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(PointsOfInterestListTVC.saveButtonPressed))
        saveButtonItem.isEnabled = true
        self.saveButtonItem = saveButtonItem
        navigationItem.rightBarButtonItem = saveButtonItem
    }
    
    func saveButtonPressed()  {
        for point in selectedPointsOfInterest! {
            if point.isSelected {
                print(point.pointOfInterest?.title ?? "")
            }
        }
        
        if isAddingQuiz {
            if checkSomePointSelected() {
                addQuizTVC?.selectedPointsOfInterest = selectedPointsOfInterest
            }
        }
        else if isEditingQuiz{
            if checkSomePointSelected() {
                editQuizTVC?.selectedPointsOfInterest = selectedPointsOfInterest
            }
        }
        
//        self.view.window!.rootViewController?.presentedViewController?.presentedViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func isPointOfInterestLinkedToQuiz(pointOfInterest:PointOfInterest) -> Bool{
        if editingQuizPoints != nil {
            for point in editingQuizPoints! {
                if pointOfInterest == point {
                    return true
                }
            }
            return false
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? UINavigationController {
            if let addQuizTVC = controller.viewControllers.first as? AddQuizTVC {
                //addQuizTVC.selectedPointOfinterest = selectedPointOfinterest
                addQuizTVC.selectedPointsOfInterest = selectedPointsOfInterest
            }
            else if let editPointOfInterestTVC = controller.viewControllers.first as? EditPointOfInterestTVC {
                editPointOfInterestTVC.selectedPointOfinterest = selectedPointOfinterest
            }
        }
    }
    
    func checkSomePointSelected() -> Bool {
        if selectedPointsOfInterest != nil {
            for point in selectedPointsOfInterest! {
                if point.isSelected {
                    return true
                }
            }
            return false
        }
        return false
    }
    
    @IBAction func pointsOfInterestListExitAction(_ segue:UIStoryboardSegue){
        
        //        if let controller = segue.source as? (?) {
        //
        //        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return yourPointsOfInterest?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = yourPointsOfInterest?[indexPath.row].title
        
        if selectedPointsOfInterest != nil {
            if isAddingQuiz {
                if (selectedPointsOfInterest?[indexPath.row].isSelected)! {
                    cell.accessoryType = .checkmark
                    cell.isSelected = true
                }
                else{
                    cell.accessoryType = .none
                    cell.isSelected = false
                }
            }
            else if isEditingQuiz {
                if (selectedPointsOfInterest?[indexPath.row].isSelected)! {
                    cell.accessoryType = .checkmark
                    cell.isSelected = true
                }
                else {
                    cell.accessoryType = .none
                    cell.isSelected = false
                }
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !(isAddingQuiz || isEditingQuiz) {
            selectedPointOfinterest = yourPointsOfInterest?[indexPath.row]
            performSegue(withIdentifier: "showEditPointOfInterestTVC", sender: nil)
        }
        else{
            selectedPointsOfInterest?[indexPath.row].isSelected = true
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
        }
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if isAddingQuiz || isEditingQuiz {
            selectedPointsOfInterest?[indexPath.row].isSelected = false
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .none
        }
    }
}
struct TableMultipleSlectionPointOfInterest {
    var pointOfInterest:PointOfInterest?
    var isSelected:Bool = false
    
    init(pointOfInterest: PointOfInterest) {
        self.pointOfInterest = pointOfInterest
    }
    
    init(pointOfInterest: PointOfInterest, isSelected: Bool) {
        self.pointOfInterest = pointOfInterest
        self.isSelected = isSelected
    }
    
    mutating func setIsSelected(isSelected:Bool){
        self.isSelected = isSelected
    }
    
}

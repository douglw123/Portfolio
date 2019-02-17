//
//  PointsOfInterestAdminListTVC.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 13/07/2018.
//  Copyright © 2018 Doug Williams. All rights reserved.
//

import UIKit

class PointsOfInterestAdminListTVC: UITableViewController {
    
    let coreDataHandler = CoreDataHandler()
    var inChangeRequestMode:Bool = false
    var allPointsOfInterest:[PointOfInterest]?
    
    var selectedPointOfInterest:PointOfInterest?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allPointsOfInterest = !inChangeRequestMode ? coreDataHandler.getAllPointsOfinterest() : coreDataHandler.getAllPointsOfinterestOrderedByChangeRequests()
        tableView.reloadData()
    }

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return allPointsOfInterest?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !inChangeRequestMode {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            cell.textLabel?.text = allPointsOfInterest?[indexPath.row].title
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailedCell", for: indexPath)
            cell.textLabel?.text = allPointsOfInterest?[indexPath.row].title
            cell.detailTextLabel?.text = "CR: \(allPointsOfInterest?[indexPath.row].changeRequests?.count ?? 0)"
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print("showChangeRequestsForPointOfInterest for \(allPointsOfInterest?[indexPath.row].title ?? "no title")")
        selectedPointOfInterest = allPointsOfInterest?[indexPath.row]
        if inChangeRequestMode {
            performSegue(withIdentifier: "showChangeRequestsForPointOfInterest", sender: self)

        }
        else{
            performSegue(withIdentifier: "showEditPointOfInterestFromAdminList", sender: self)
        }
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? UINavigationController {
            if let pointsOfInterestChangeRequestsTVC = controller.viewControllers.first as? PointsOfInterestChangeRequestsTVC {
              pointsOfInterestChangeRequestsTVC.selectedPointOfInterest = selectedPointOfInterest
            }
            else if let editPointOfInterestTVC = controller.viewControllers.first as? EditPointOfInterestTVC {
                editPointOfInterestTVC.selectedPointOfinterest = selectedPointOfInterest
                editPointOfInterestTVC.isFromAdmin = true
            }
        }
    }
    
}

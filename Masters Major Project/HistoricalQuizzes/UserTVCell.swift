//
//  UserTVCell.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 19/07/2018.
//  Copyright © 2018 Doug Williams. All rights reserved.
//

import UIKit

class UserTVCell: UITableViewCell {

    @IBOutlet weak var userNameTextField: UILabel!
    @IBOutlet weak var banButton: UIButton!
    
    var usersTVC:UsersTVC?
    var user:User?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        banButton.addTarget(self, action: #selector(UsersTVC.bannedButtonPressed(_:)), for: .touchUpInside)
    }
    
//    func changeBanButtonStatus() {
//        banButton.setTitle((user?.isBanned)! ? "Unban" : "Ban", for: .normal)
//        banButton.backgroundColor = (user?.isBanned)! ? UIColor.green : UIColor.red
//    }
    
    func setBanButtonToBan() {
        banButton.setTitle("Ban", for: .normal)
        banButton.backgroundColor = UIColor.red

    }
    
    func setBanButtonToUnban() {
        banButton.setTitle("Unban", for: .normal)
        banButton.backgroundColor = UIColor.green
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func bannedButtonPressed(_ sender: UIButton) {
        usersTVC?.changeBanStatusForUser(user: user!)
    }
    

}

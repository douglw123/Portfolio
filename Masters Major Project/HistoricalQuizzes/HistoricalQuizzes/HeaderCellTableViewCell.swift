//
//  HeaderCellTableViewCell.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 01/06/2018.
//  Copyright © 2018 Doug Williams. All rights reserved.
//

import UIKit

class HeaderCellTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  HistoryTableViewCell.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/21/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var iconVIew: UIImageView!
    
    @IBOutlet weak var filenameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

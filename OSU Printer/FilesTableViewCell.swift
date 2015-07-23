//
//  FilesTableViewCell.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/18/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import UIKit

class FilesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var fileDescriptionLabel: UILabel!
    
    @IBOutlet weak var filenameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

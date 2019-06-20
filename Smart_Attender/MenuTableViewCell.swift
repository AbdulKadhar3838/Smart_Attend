//
//  MenuTableViewCell.swift
//  Smart_Attender
//
//  Created by CIPL-258-MOBILITY on 16/12/16.
//  Copyright © 2016 Colan. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgvwIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.contentView.backgroundColor = sky_Blue
        }
        else
        {
            self.contentView.backgroundColor = theme_color
        }
    }
}

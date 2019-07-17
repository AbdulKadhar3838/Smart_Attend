//
//  QuickPopUpTableViewCell.swift
//  SA-ADMIN
//
//  Created by CIPL0590 on 09/07/19.
//  Copyright © 2019 Colan. All rights reserved.
//

import UIKit

class QuickPopUpTableViewCell: UITableViewCell {
    
    
    @IBOutlet var checkBtn: UIButton!
    
    @IBOutlet var dataLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

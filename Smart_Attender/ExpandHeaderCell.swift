//
//  ExpandHeaderCell.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 16/11/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class ExpandHeaderCell: UITableViewCell {
    @IBOutlet weak var btnText: UIButton!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var lblCheckbox: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

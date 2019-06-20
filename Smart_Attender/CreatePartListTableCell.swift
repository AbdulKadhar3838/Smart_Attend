//
//  CreatePartListTableCell.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 13/12/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class CreatePartListTableCell: UITableViewCell {
    
    @IBOutlet weak var lblGroupId: UILabel!
    @IBOutlet weak var lblPartNo: UILabel!
    @IBOutlet weak var lblCavity: UILabel!
    @IBOutlet weak var lblCycleTime: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnSpacer: UIButton!
    
    @IBOutlet weak var constraintWidthSpacerBtn: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblPartNo.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

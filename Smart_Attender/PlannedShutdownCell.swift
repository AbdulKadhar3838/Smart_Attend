//
//  PlannedShutdownCell.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 14/11/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class PlannedShutdownCell: UITableViewCell {
    @IBOutlet weak var lblDeviceID: UILabel!
    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var btnAction: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnAction.layer.cornerRadius = 6
        self.btnAction.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

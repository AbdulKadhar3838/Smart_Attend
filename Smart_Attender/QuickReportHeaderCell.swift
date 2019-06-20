//
//  QuickReportHeaderCell.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 07/12/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class QuickReportHeaderCell: UITableViewCell {
    @IBOutlet weak var btnIncident: UIButton!
    @IBOutlet weak var btnMachineName: UIButton!
    @IBOutlet weak var btnPartNo: UIButton!
    @IBOutlet weak var btnDescription: UIButton!
    @IBOutlet weak var btnProductionHrs: UIButton!
    @IBOutlet weak var btnPartsProduced: UIButton!
    @IBOutlet weak var btnAvgCycle: UIButton!
    @IBOutlet weak var btnOEE: UIButton!
    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var btnEnddate: UIButton!
    @IBOutlet weak var btnScarp: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

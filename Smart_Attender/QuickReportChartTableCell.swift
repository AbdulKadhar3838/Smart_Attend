//
//  QuickReportChartTable.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 11/12/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class QuickReportChartTableCell: UITableViewCell {
    @IBOutlet weak var lblBox: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblIncident: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblBox.backgroundColor = UIColor.clear
        self.lblBox.layer.cornerRadius = 4
        self.lblBox.layer.masksToBounds = true
        self.lblIncident.text = ""
        self.lblName.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

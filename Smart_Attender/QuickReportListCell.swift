//
//  QuickReportListCell.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 07/12/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class QuickReportListCell: UITableViewCell {
    @IBOutlet weak var btnIncident: UIButton!
    @IBOutlet weak var lblMachineName: UILabel!
    @IBOutlet weak var lblPartNo: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblProductionHrs: UILabel!
    @IBOutlet weak var lblPartsProduced: UILabel!
    @IBOutlet weak var lblAvgCycle: UILabel!
    @IBOutlet weak var lblOEE: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEnddate: UILabel!
    
    @IBOutlet weak var lblScarp: UILabel!
    @IBOutlet weak var lblTotalValue: UILabel!
    @IBOutlet weak var lblTotalCost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblMachineName.text = ""
        self.lblPartNo.text = ""
        self.lblDescription.text = ""
        self.lblProductionHrs.text = ""
        self.lblPartsProduced.text = ""
        
        self.lblAvgCycle.text = ""
        self.lblOEE.text = ""
        self.lblStartDate.text = ""
        self.lblEnddate.text = ""
        self.btnIncident.setTitle("", for: .normal)
        self.lblScarp.text = ""
        self.lblTotalValue.text = ""
        self.lblTotalCost.text = ""
        
        self.lblStartDate.numberOfLines = 0
        self.lblEnddate.numberOfLines = 0
        self.lblStartDate.lineBreakMode = .byWordWrapping
        self.lblEnddate.lineBreakMode = .byWordWrapping
        self.lblMachineName.adjustsFontSizeToFitWidth = true
        self.lblPartNo.adjustsFontSizeToFitWidth = true
        self.lblPartsProduced.adjustsFontSizeToFitWidth = true
        self.lblProductionHrs.adjustsFontSizeToFitWidth = true
        self.lblStartDate.adjustsFontSizeToFitWidth = true
        self.lblEnddate.adjustsFontSizeToFitWidth = true
        
        self.lblOEE.adjustsFontSizeToFitWidth = true
        self.lblAvgCycle.adjustsFontSizeToFitWidth = true
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


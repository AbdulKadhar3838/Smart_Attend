
//
//  Dashboard_CollectionViewCell.swift
//  Smart_Attender
//
//  Created by CIPL-258-MOBILITY on 16/12/16.
//  Copyright © 2016 Colan. All rights reserved.
//

import UIKit

class Dashboard2_CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var machine_namelbl: UILabel!
    @IBOutlet weak var machine_statuslbl: UILabel!
    @IBOutlet weak var circlenumber_label: UILabel!
    @IBOutlet weak var cellTopView: UIView!
    @IBOutlet weak var circularProgressView    : KDCircularProgress!
    
    
    @IBOutlet weak var lblEfficiency: UILabel!
    @IBOutlet weak var lblCycleTime: UILabel!
    @IBOutlet weak var lblDowntimeDuration: UILabel!
    @IBOutlet weak var lblETA: UILabel!
    @IBOutlet weak var lblPartNumber: UILabel!
    @IBOutlet weak var lblCompletedQuantity: UILabel!
    @IBOutlet weak var imgvwDown: UIImageView!
    
    @IBOutlet weak var lblCenterSeparator: UILabel!
    @IBOutlet weak var lblCenterLine: UILabel!
   
    
    @IBOutlet weak var lblEfficiencyForNA: UILabel!
    @IBOutlet weak var machineStatuslblForNA: UILabel!
    @IBOutlet weak var circlenumberlblForNA: UILabel!
    
    
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
    }
    
    override func awakeFromNib() {
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1.0
        lblPartNumber.adjustsFontSizeToFitWidth = true
        machine_namelbl.adjustsFontSizeToFitWidth = true
        
        machine_statuslbl.adjustsFontSizeToFitWidth = true
        lblCompletedQuantity.adjustsFontSizeToFitWidth = true
        lblETA.adjustsFontSizeToFitWidth = true
    }
    
    
}


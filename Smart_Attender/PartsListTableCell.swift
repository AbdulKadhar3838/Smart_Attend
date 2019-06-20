//
//  PartsListTableCell.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 12/10/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class PartsListTableCell: UITableViewCell {
    @IBOutlet weak var lblScarp: UILabel!
    
    @IBOutlet weak var lblPartNumber: UILabel!
    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var lblCavity: UILabel!
    @IBOutlet weak var lblCycle: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblReqQty: UILabel!
    @IBOutlet weak var viewAction: UIView!
    @IBOutlet weak var viewBtnAction: UIView!
    
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var btnAssign: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization codecell.lblDeviceName.text = ""
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

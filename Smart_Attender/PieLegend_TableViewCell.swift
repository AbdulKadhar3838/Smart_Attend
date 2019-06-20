//
//  Dashboard1_TableViewCell.swift
//  Smart_Attender
//
//  Created by CIPL-258-MOBILITY on 16/12/16.
//  Copyright © 2016 Colan. All rights reserved.
//

import UIKit

class PieLegend_TableViewCell: UITableViewCell {

    @IBOutlet weak var machine_colorlbl: UILabel!
    @IBOutlet weak var machine_statuslbl: UILabel!
    
    @IBOutlet weak var machine_runtimelbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.machine_colorlbl.clipsToBounds=true
        self.machine_colorlbl.layer.cornerRadius=2
        self.machine_colorlbl.layer.borderWidth=1.5
        self.machine_colorlbl.layer.borderColor=UIColor.white.cgColor
        machine_runtimelbl.adjustsFontSizeToFitWidth = true
        machine_statuslbl.adjustsFontSizeToFitWidth = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
   }

}

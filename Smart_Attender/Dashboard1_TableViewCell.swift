//
//  Dashboard1_TableViewCell.swift
//  Smart_Attender
//
//  Created by CIPL-258-MOBILITY on 16/12/16.
//  Copyright © 2016 Colan. All rights reserved.
//

import UIKit

class Dashboard1_TableViewCell: UITableViewCell {

    @IBOutlet weak var machine_namelbl: UILabel!
    @IBOutlet weak var machine_statuslbl: UILabel!
    
    @IBOutlet weak var machine_descrptnlbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

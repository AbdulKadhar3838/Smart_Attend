//
//  ScarpTableCell.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 21/11/18.
//  Copyright © 2018 Colan. All rights reserved.
//

import UIKit

class ScarpTableCell: UITableViewCell {

    @IBOutlet weak var txtQuantity: UITextField!
    @IBOutlet weak var lblPartNo: UILabel!
    @IBOutlet weak var lblAccumulate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  MenuTableViewCell.swift
//  Smart_Attender
//
//  Created by CIPL-258-MOBILITY on 16/12/16.
//  Copyright © 2016 Colan. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgvwIcon: UIImageView!
    
   // imgvwIcon.image = selectedMenuImg[indexPath.row]
    var selectedMenuImg:[UIImage] = [#imageLiteral(resourceName: "Dashboard"),#imageLiteral(resourceName: "notification-1"),#imageLiteral(resourceName: "partList-1"),#imageLiteral(resourceName: "partAssign"),#imageLiteral(resourceName: "quickreport-1"),#imageLiteral(resourceName: "User"),#imageLiteral(resourceName: "Settings"),#imageLiteral(resourceName: "wifi-1"),#imageLiteral(resourceName: "resetPassword"),#imageLiteral(resourceName: "logoutt")]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.contentView.backgroundColor = newDarkGray_color
            self.lblTitle.textColor = UIColor.white
            self.imgvwIcon.tintColor = UIColor.white
         //   self.imgvwIcon.image = UIImage(named: selectedMenuImg[i])
        }
        else
        {
            self.contentView.backgroundColor = newGray_color
            self.lblTitle.textColor = SlidemenuNav_color
            self.imgvwIcon.tintColor = UIColor.black

            

        }
    }
}

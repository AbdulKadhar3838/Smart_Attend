//
//  UserListCollectionCell.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 09/10/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class UserListCollectionCell: UICollectionViewCell {
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var cellTopView: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
    }
   override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        self.imgProfile.layer.masksToBounds = true
        self.imgProfile.layer.cornerRadius = (self.imgProfile.frame.size.width / 2.0)
    }
    override func awakeFromNib() {
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.lblUserName.adjustsFontSizeToFitWidth = true
    }
    
}



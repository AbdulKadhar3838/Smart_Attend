//
//  custom_layout.swift
//  Smart_Attender
//
//  Created by Rajith Kumar on 20/12/16.
//  Copyright © 2016 Colan. All rights reserved.
//

import UIKit

class custom_layout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    func setup() {
        // setting up some inherited values
        
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 10
        self.sectionInset.left = 10.0
        self.sectionInset.right = 10.0
        
    }
    
//    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        let bounds = self.collectionView!.bounds;
//        return ((newBounds.width != bounds.width ||
//            (newBounds.height != bounds.height)));
//    }
//    
//    override public func invalidateLayout() {
//        super.invalidateLayout()
//    }
}

//
//  Replace Segues.swift
//  Mtopo_Merchant
//
//  Created by CIPL-258-MOBILITY on 02/12/16.
//  Copyright © 2016 Peer Mohamed Thabib. All rights reserved.
//

import UIKit

class Replace_Segues: UIStoryboardSegue {
    override func perform() {
        let fromVC = source 
        let toVC = destination
        
        var vcs = fromVC.navigationController?.viewControllers
        vcs?.removeLast()
        vcs?.append(toVC)
        
        fromVC.navigationController?.setViewControllers(vcs!,
                                                        animated: true)
    }
}

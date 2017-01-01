//
//  LCPlanDetailRouteCell.swift
//  LinkCity
//
//  Created by Roy on 1/16/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit

class LCPlanDetailRouteCell: UITableViewCell {

    @IBOutlet weak var routeLabel: UILabel!
    
    @IBOutlet weak var bottomLineLeading: NSLayoutConstraint!
    @IBOutlet weak var bottomLineTrailing: NSLayoutConstraint!
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateShow(routeStr : String, isLastCell : Bool) {
        routeLabel.text = LCStringUtil.getNotNullStr(routeStr)
        
        if isLastCell {
            bottomLineLeading.constant = 0
            bottomLineTrailing.constant = 0
            bottomSpace.constant = 10
        }else {
            bottomLineLeading.constant = 12
            bottomLineTrailing.constant = 12
            bottomSpace.constant = 0
        }
    }
    
}

//
//  LCSendFreePlanImageSeatCell.swift
//  LinkCity
//
//  Created by Roy on 1/12/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit

class LCSendFreePlanImageSeatCell: UITableViewCell {
    weak var delegate : LCSendFreePlanImageSeatCellDelegate?
    
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var seatNumLabel: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func minusBtnAction(sender: AnyObject) {
        delegate?.sendFreePlanImageSeatCellDidClickMinus()
    }
    
    @IBAction func plusBtnAction(sender: AnyObject) {
        delegate?.sendFreePlanImageSeatCellDidClickPlus()
    }
    
    

}



@objc protocol LCSendFreePlanImageSeatCellDelegate {
    func sendFreePlanImageSeatCellDidClickPlus()
    func sendFreePlanImageSeatCellDidClickMinus()
}

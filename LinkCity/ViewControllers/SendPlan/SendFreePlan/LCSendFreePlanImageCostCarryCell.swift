//
//  LCSendFreePlanImageCostCarryCell.swift
//  LinkCity
//
//  Created by Roy on 1/12/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit

class LCSendFreePlanImageCostCarryCell: UITableViewCell, UITextFieldDelegate {

    weak var delegate : LCSendFreePlanImageCostCarryCellDelegate?
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        priceTextField.delegate = self;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK : TextField Delegate
    func textFieldDidEndEditing(textField: UITextField) {
        delegate?.sendFreePlanImageCostCarryCellDidEditPrice()
    }

}

@objc protocol LCSendFreePlanImageCostCarryCellDelegate {
    func sendFreePlanImageCostCarryCellDidEditPrice()
}

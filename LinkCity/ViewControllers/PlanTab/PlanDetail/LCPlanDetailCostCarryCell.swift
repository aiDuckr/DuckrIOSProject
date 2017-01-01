//
//  LCPlanDetailCostCarryCell.swift
//  LinkCity
//
//  Created by Roy on 1/13/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit

class LCPlanDetailCostCarryCell: UITableViewCell {
    
    var plan : LCPlanModel?
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bottomLineLeading: NSLayoutConstraint!
    @IBOutlet weak var bottomLineTrailing: NSLayoutConstraint!
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    @IBOutlet weak var phoneCallView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func phoneCallBtnAction(sender: AnyObject) {
        let creater = plan?.memberList.first as? LCUserModel
        
        if plan?.isAllowPhoneContact == 1 && LCStringUtil.isNotNullString(creater?.telephone) {
            
            LCSharedFuncUtil.dialPhoneNumber(creater!.telephone)
        }else{
            YSAlertUtil.tipOneMessage("发起人未允许电话联系")
        }
        
    }
    
    func updateShowWithPlan(plan : LCPlanModel, isLastCell : Bool) {
        self.plan = plan
        
        if self.plan?.getPlanRelation() == LCPlanRelation.Creater {
            phoneCallView.hidden = true
        }else{
            phoneCallView.hidden = false
        }
        
        if LCDecimalUtil.isOverZero(plan.costPrice) {
            priceLabel.text = String(format: "￥%@/人", plan.costPrice.stringValue)
        }else {
            priceLabel.text = "免费"
        }
        
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

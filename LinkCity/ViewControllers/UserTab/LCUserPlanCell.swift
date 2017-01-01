//
//  LCUserPlanCell.swift
//  LinkCity
//
//  Created by 张宗硕 on 1/13/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit

class LCUserPlanCell: UITableViewCell {

    @IBOutlet weak var confirmArrivalButton: UIButton!
    @IBOutlet weak var planDescLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var orderViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmArrivalView: UIView!
    @IBOutlet weak var confirmArrivalHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageUpperView: UIView!
    @IBOutlet weak var imageUpperLabel: UILabel!
    @IBOutlet weak var contactButton: UIButton!

    
    var delegate: LCUserPlanCellDelegate?
    var plan: LCPlanModel = LCPlanModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initContactButton()
        self.initConfirmArrivalButton()
        self.initDefaultLabelValue()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func initContactButton() {
        self.contactButton.layer.borderColor = LCSSharedFuncUtil.colorFromRGBA(0x6cbc0f, alpha: 1.0).CGColor
        self.contactButton.layer.borderWidth = 0.5
        self.contactButton.layer.cornerRadius = 3.0
        self.contactButton.layer.masksToBounds = true
    }
   
    private func initDefaultLabelValue() {
        self.placeLabel.text = ""
        self.dateLabel.text = ""
        self.planDescLabel.text = ""
    }
    
    private func initConfirmArrivalButton() {
        self.confirmArrivalButton.layer.borderWidth = 0.5
        self.confirmArrivalButton.layer.cornerRadius = 3.0
        self.confirmArrivalButton.layer.masksToBounds = true
    }
    
    internal func updateShowUserPlanCell(plan: LCPlanModel) {
        self.plan = plan
        self.placeLabel.text = plan.getDepartAndDestString()
        self.dateLabel.text = plan.getPlanStartDateText()
        self.planDescLabel.text = plan.descriptionStr
        self.coverImageView.setImageWithURL(NSURL(string: plan.firstPhotoThumbUrl)!)
        if true == self.plan.isMerchantCostPlan() {
            self.updateMerchantView()
        } else if true == self.plan.isCostCarryPlan() {
            self.updateCarSharingView()
        } else {
            self.updateNormalPlanView()
        }
    }
    
    private func updateMerchantView() {
        self.imageUpperView.backgroundColor = LCSSharedFuncUtil.colorFromRGBA(0xff0000, alpha: 1.0)
        self.imageUpperLabel.text = "￥\(self.plan.costPrice)/人"
        
        self.orderView.hidden = false
        self.orderViewHeightConstraint.constant = 39
        self.confirmArrivalView.hidden = true
        self.confirmArrivalHeightConstraint.constant = 0
    }
    
    private func updateCarSharingView() {
        self.imageUpperView.backgroundColor = LCSSharedFuncUtil.colorFromRGBA(0xff0000, alpha: 1.0)
        self.imageUpperLabel.text = "￥\(self.plan.costPrice)/人"
        
        self.orderView.hidden = false
        self.orderViewHeightConstraint.constant = 39
        self.confirmArrivalView.hidden = false
        self.confirmArrivalHeightConstraint.constant = 45
        
        if 1 == self.plan.isArrived {
            self.confirmArrivalButton.setTitle("已结束", forState: .Normal)
            self.confirmArrivalButton.enabled = false
            self.confirmArrivalButton.setTitleColor(LCSSharedFuncUtil.colorFromRGBA(0xaba7a2, alpha: 1.0), forState: .Normal)
            self.confirmArrivalButton.layer.borderColor = LCSSharedFuncUtil.colorFromRGBA(0xc9c5c1, alpha: 1.0).CGColor
            
            self.contactButton.hidden = true
        } else {
            self.confirmArrivalButton.setTitle("确认到达", forState: .Normal)
            self.confirmArrivalButton.enabled = true
            self.confirmArrivalButton.setTitleColor(LCSSharedFuncUtil.colorFromRGBA(0xff5a4d, alpha: 1.0), forState: .Normal)
            self.confirmArrivalButton.layer.borderColor = LCSSharedFuncUtil.colorFromRGBA(0xff5a4d, alpha: 1.0).CGColor
            
            self.contactButton.hidden = false
        }
    }
    
    private func updateNormalPlanView() {
        self.imageUpperView.backgroundColor = LCSSharedFuncUtil.colorFromRGBA(0x000000, alpha: 0.4)
        self.imageUpperLabel.text = "我加入的"
        if self.plan.memberList.count > 0 {
            let user = self.plan.memberList[0] as! LCUserModel
            if user.uUID == LCDataManager.sharedInstance().userInfo.uUID {
                self.imageUpperLabel.text = "由我发起"
            }
        }
        
        self.orderView.hidden = true
        self.orderViewHeightConstraint.constant = 0
        self.confirmArrivalView.hidden = true
        self.confirmArrivalHeightConstraint.constant = 0
    }
    
    @IBAction func orderDetailButtonAction(sender: AnyObject) {
        self.delegate?.orderDetailButtonPressed(self)
    }
    
    @IBAction func confirmArrivalButtonAction(sender: AnyObject) {
        self.delegate?.confirmArrivalButtonPressed(self)
    }
    
    @IBAction func contactButtonAction(sender: AnyObject) {
        LCSharedFuncUtil.dialPhoneNumber(DUCKR_SERVICE_TEL)
    }
    
}

protocol LCUserPlanCellDelegate {
    func orderDetailButtonPressed(userPlanCell: LCUserPlanCell)
    func confirmArrivalButtonPressed(userPlanCell: LCUserPlanCell)
}

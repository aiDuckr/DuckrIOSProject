//
//  LCPlanDetailCarCell.swift
//  LinkCity
//
//  Created by Roy on 1/13/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit

class LCPlanDetailCarCell: UITableViewCell {
    
    
    @IBOutlet weak var carInfoLabel: UILabel!
    @IBOutlet weak var bottomLineLeading: NSLayoutConstraint!
    @IBOutlet weak var bottomLineTrailing: NSLayoutConstraint!
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    @IBOutlet weak var rightArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateShowWithPlan(plan : LCPlanModel?, isLastCell : Bool) {
        var carInfoStr = "未认证"
        
        if plan?.memberList.count > 0 {
            let creater = plan!.memberList.first!
            if UInt(creater.isCarVerify) == LCIdentityStatus_None.rawValue {
                    carInfoStr = "未认证"
                    carInfoLabel.textColor = LCSSharedFuncUtil.colorFromRGBA(0xff5a4d, alpha: 1)
            }else if (UInt(creater.isCarVerify) == LCIdentityStatus_Failed.rawValue) {
                carInfoStr = "审核失败"
                carInfoLabel.textColor = LCSSharedFuncUtil.colorFromRGBA(0xff5a4d, alpha: 1)
            }else if (UInt(creater.isCarVerify) == LCIdentityStatus_Verifying.rawValue) {
                carInfoStr = "审核中"
                carInfoLabel.textColor = LCSSharedFuncUtil.colorFromRGBA(0x6cbc0f, alpha: 1)
            }else if (UInt(creater.isCarVerify) == LCIdentityStatus_Done.rawValue) {
                if let carIdentity = plan?.carIdentity{
                    
                    let carBrand = LCStringUtil.getNotNullStr(carIdentity.carBrand)
                    let carType = LCStringUtil.getNotNullStr(carIdentity.carType)
                    var carLicense = LCStringUtil.getNotNullStr(carIdentity.carLicense) as String!
                    if carLicense.characters.count > 3 {
                        let range = Range<String.Index>(start: carLicense.startIndex.advancedBy(1), end: carLicense.endIndex.advancedBy(-1))
                        carLicense.replaceRange(range, with: "*")
                    }
                    
                    carInfoStr = NSString(format: "%@%@  %@", carBrand, carType, carLicense) as String
                    carInfoLabel.textColor = LCSSharedFuncUtil.colorFromRGBA(0x7d7975, alpha: 1)
                    rightArrow.hidden = false
                }else{
                    rightArrow.hidden = true
                }
            }
        }
        
        carInfoLabel.text = carInfoStr
        
        if let _ = plan?.carIdentity {
            rightArrow.hidden = false
        }else{
            rightArrow.hidden = true
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
    
    func setBottomSpaceHiden(hide : Bool){
        if hide {
            bottomSpace.constant = 0
        }else{
            bottomSpace.constant = 10
        }
    }
}

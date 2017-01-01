//
//  LCConfirmArrivalView.swift
//  LinkCity
//
//  Created by 张宗硕 on 1/14/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit

class LCConfirmArrivalView: UIView {
    var delegate: LCConfirmArrivalViewDelegate?
    @IBOutlet weak var confirmFirstLineLabel: UILabel!
    @IBOutlet weak var confirmSecondLineLabel: UILabel!
    
    @IBOutlet weak var notArrivalButton: UIButton!
    @IBOutlet weak var arrivalButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.notArrivalButton.layer.borderColor = LCSSharedFuncUtil.colorFromRGBA(0xc9c5c1, alpha: 1.0).CGColor
        self.notArrivalButton.layer.borderWidth = 0.5
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(280.0, 250.0)
    }
    
    class func createInstance() -> LCConfirmArrivalView? {
        var view: LCConfirmArrivalView = LCConfirmArrivalView()
        let nib = UINib(nibName: LCSSharedFuncUtil.classNameOfClass(LCConfirmArrivalView.self), bundle: nil)
        let views = nib.instantiateWithOwner(nil, options: nil)
        for object in views {
            if object is LCConfirmArrivalView {
                view = object as! LCConfirmArrivalView
            }
        }
        return view
    }
    
    func updateShowWithPlan(plan:LCPlanModel) {
        let user = plan.memberList[0] as! LCUserModel
        if user.uUID == LCDataManager.sharedInstance().userInfo.uUID {
            self.confirmFirstLineLabel.text = "司机点击确认到达后会提示用户确认"
            self.confirmSecondLineLabel.text = "用户确认后将付款打到您的账户"
        } else {
            self.confirmFirstLineLabel.text = "确认到达后，达客旅行将会全额"
            self.confirmSecondLineLabel.text = "付款到司机师傅账户"
        }
    }

    @IBAction func confirmButtonAction(sender: AnyObject) {
        self.delegate?.confirmArrivalDidArrival()
    }
    
    @IBAction func notArrivalButtonAction(sender: AnyObject) {
        self.delegate?.confirmArrivalDidNotArrival()
    }
}

@objc protocol LCConfirmArrivalViewDelegate {
    func confirmArrivalDidNotArrival()
    func confirmArrivalDidArrival()
}

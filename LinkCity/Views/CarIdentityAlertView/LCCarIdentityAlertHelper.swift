//
//  LCCarIdentityAlertHelper.swift
//  LinkCity
//
//  Created by Roy on 1/13/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit

class LCCarIdentityAlertHelper: NSObject, LCCarIdentityAlertViewDelegate {
    private var carIdAlertView : LCCarIdentityAlertView!
    private var carIdAlertPopup : KLCPopup!
    private var shownOnVC : UIViewController!
    
    static let sharedInstance = LCCarIdentityAlertHelper()
    
    class func showCarIdentityAlertViewAsJustPublishPlanOn(vc : UIViewController){
        sharedInstance.carIdAlertView = LCCarIdentityAlertView.createInstance()
        sharedInstance.carIdAlertView.delegate = sharedInstance
        sharedInstance.carIdAlertView.iconImageView.image = UIImage(named: "CarIconGray")
        sharedInstance.carIdAlertView.titleLabel.text = "认证车辆信息"
        sharedInstance.carIdAlertView.contentLabel.text = "会提高90%的拼车邀约成功率"
        sharedInstance.carIdAlertView.submitBtn.setTitle("去认证", forState: UIControlState.Normal)
        
        sharedInstance.shownOnVC = vc
        sharedInstance.carIdAlertPopup = KLCPopup(contentView: sharedInstance.carIdAlertView,
            showType: KLCPopupShowType.BounceInFromTop,
            dismissType: KLCPopupDismissType.BounceOutToBottom,
            maskType: KLCPopupMaskType.Dimmed,
            dismissOnBackgroundTouch: false,
            dismissOnContentTouch: false)
        sharedInstance.carIdAlertPopup.dimmedMaskAlpha = 0.4
        sharedInstance.carIdAlertPopup.showAtCenter(CGPointMake(LCSSharedFuncUtil.deviceWidth()/2.0, LCSSharedFuncUtil.deviceHeight()/2.0), inView: nil)
    }
    
    class func showCarIdentityAlertViewAsLaterWarnOn(vc : UIViewController){
        sharedInstance.carIdAlertView = LCCarIdentityAlertView.createInstance()
        sharedInstance.carIdAlertView.delegate = sharedInstance
        sharedInstance.carIdAlertView.iconImageView.image = UIImage(named: "CarIconYellow")
        sharedInstance.carIdAlertView.titleLabel.text = "车辆信息会极大提高拼车成功率哦"
        sharedInstance.carIdAlertView.contentLabel.text = "快去进行车辆认证吧~"
        sharedInstance.carIdAlertView.submitBtn.setTitle("现在就去", forState: UIControlState.Normal)
        
        sharedInstance.shownOnVC = vc
        sharedInstance.carIdAlertPopup = KLCPopup(contentView: sharedInstance.carIdAlertView,
            showType: KLCPopupShowType.BounceInFromTop,
            dismissType: KLCPopupDismissType.BounceOutToBottom,
            maskType: KLCPopupMaskType.Dimmed,
            dismissOnBackgroundTouch: false,
            dismissOnContentTouch: false)
        sharedInstance.carIdAlertPopup.dimmedMaskAlpha = 0.4
        sharedInstance.carIdAlertPopup.showAtCenter(CGPointMake(LCSSharedFuncUtil.deviceWidth()/2.0, LCSSharedFuncUtil.deviceHeight()/2.0), inView: nil)
    }
    
    
    
    //MARK: LCCarIdentityAlertViewDelegate
    func carIdentityAlertViewDidSubmit() {
        carIdAlertPopup.dismissPresentingPopup()
        
        LCUserIdentityHelper.sharedInstance().startCarIdentityWithUser(LCDataManager.sharedInstance().userInfo, fromVC: shownOnVC)
    }
    
    func carIdentityAlertViewDidCancel() {
        carIdAlertPopup.dismissPresentingPopup()
        
    }
}

//
//  LCDialogHelper.swift
//  LinkCity
//
//  Created by Roy on 1/16/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit

class LCDialogHelper: NSObject {
    
    var dialogView : LCDialogView?
    var popUp : KLCPopup?
    
    static let sharedInstance = LCDialogHelper()
    
    class func dismissDialog() {
        LCDialogHelper.sharedInstance.popUp?.dismiss(true)
    }
    
    class func showOneBtnDialogHideCancelBtn(hideCancelBtn:Bool,
        dismissOnBgTouch:Bool,
        iconImageName:String,
        title:String,
        msg:String,
        miniBtnTitle:String?,
        btnTitle:String,
        cancelBtnCallBack:()->Void,
        miniBtnCallBack:()->Void,
        submitBtnCallBack:()->Void)
    {
        //Config Dialog
        var v = LCDialogView.createInstanceFromNib()
        v.translatesAutoresizingMaskIntoConstraints = false
        LCDialogHelper.sharedInstance.dialogView = v
        
        v.cancelBtn.hidden = hideCancelBtn
        v.iconImageView.image = UIImage(named: iconImageName)
        v.titleLabel.setText(title, withLineSpace: 9, textAlignment: NSTextAlignment.Center)
        v.msgLabel.setText(msg, withLineSpace: 9, textAlignment: NSTextAlignment.Center)
        v.oneBtnView.hidden = false
        v.twoBtnView.hidden = true
        v.oneBtnViewBtnA.setTitle(btnTitle, forState: .Normal)
        v.cancelBtnCallBack = cancelBtnCallBack
        
        if LCStringUtil.isNullString(miniBtnTitle) {
            v.miniBtn.hidden = true
            v.oneBtnViewTop.constant = CGFloat(LCDialogViewSubmitBtnTop.WithoutMiniBtn.rawValue)
        }else{
            v.miniBtn.hidden = false
            v.miniBtn.setTitle(miniBtnTitle, forState: .Normal)
            v.oneBtnViewTop.constant = CGFloat(LCDialogViewSubmitBtnTop.WithMiniBtn.rawValue)
        }
        
        v.miniBtnCallBack = miniBtnCallBack
        
        func submitBtnCallBackInDialog(sender : UIButton) -> Void{
            if sender === v.oneBtnViewBtnA {
                submitBtnCallBack()
            }
        }
        v.submitBtnCallBack = submitBtnCallBackInDialog
        
        
        //Config Popup
        let popUp = KLCPopup(contentView: v, showType: .BounceInFromTop, dismissType: .BounceOutToBottom, maskType: .Dimmed, dismissOnBackgroundTouch: dismissOnBgTouch, dismissOnContentTouch: false)
        popUp.dimmedMaskAlpha = 0.4
        LCDialogHelper.sharedInstance.popUp = popUp
        
        
        //Show popup
        LCDialogHelper.sharedInstance.popUp!.showAtCenter(CGPointMake(LCSSharedFuncUtil.deviceWidth()/2.0, LCSSharedFuncUtil.deviceHeight()/2.0), inView: nil)
        
        
    }
    
    /*
    e.g.
    [LCDialogHelper showTwoBtnDialogHideCancelBtn:NO
    dismissOnBgTouch:YES
    iconImageName:@"SendPlanIconBrown"
    title:@"ttttt"
    msg:@"mm"
    miniBtnTitle:@""
    btnATitle:@"a"
    btnAHighlight:YES
    btnBTitle:@"b"
    btnBHighLight:NO
    cancelBtnCallBack:^{
    
    [LCDialogHelper dismissDialog];
    } miniBtnCallBack:^{
    
    LCLogInfo(@"minibtn");
    [LCDialogHelper dismissDialog];
    } submitBtnCallBack:^(NSInteger selection) {
    
    LCLogInfo(@"infobtn %ld", (long)selection);
    [LCDialogHelper dismissDialog];
    }];
    */
    
    class func showTwoBtnDialogHideCancelBtn(hideCancelBtn:Bool,
        dismissOnBgTouch:Bool,
        iconImageName:String,
        title:String,
        msg:String,
        miniBtnTitle:String?,
        btnATitle:String,
        btnAHighlight:Bool,
        btnBTitle:String,
        btnBHighlight:Bool,
        cancelBtnCallBack:()->Void,
        miniBtnCallBack:()->Void,
        submitBtnCallBack:(Int)->Void)
    {
        //Config Dialog
        var v = LCDialogView.createInstanceFromNib()
        v.translatesAutoresizingMaskIntoConstraints = false
        LCDialogHelper.sharedInstance.dialogView = v
        
        v.cancelBtn.hidden = hideCancelBtn
        v.iconImageView.image = UIImage(named: iconImageName)
        v.titleLabel.setText(title, withLineSpace: 9, textAlignment: NSTextAlignment.Center)
        v.msgLabel.setText(msg, withLineSpace: 9, textAlignment: NSTextAlignment.Center)
        v.oneBtnView.hidden = true
        v.twoBtnView.hidden = false
        v.twoBtnViewBtnA.setTitle(btnATitle, forState: .Normal)
        LCDialogHelper.setBtnHighlight(v.twoBtnViewBtnA, highlight: btnAHighlight)
        v.twoBtnViewBtnB.setTitle(btnBTitle, forState: .Normal)
        LCDialogHelper.setBtnHighlight(v.twoBtnViewBtnB, highlight: btnBHighlight)
        v.cancelBtnCallBack = cancelBtnCallBack
        
        if LCStringUtil.isNullString(miniBtnTitle) {
            v.miniBtn.hidden = true
            v.oneBtnViewTop.constant = CGFloat(LCDialogViewSubmitBtnTop.WithoutMiniBtn.rawValue)
        }else{
            v.miniBtn.hidden = false
            v.miniBtn.setTitle(miniBtnTitle, forState: .Normal)
            v.oneBtnViewTop.constant = CGFloat(LCDialogViewSubmitBtnTop.WithMiniBtn.rawValue)
        }
        
        v.miniBtnCallBack = miniBtnCallBack
        
        func submitBtnCallBackInDialog(sender : UIButton) -> Void{
            if sender === v.twoBtnViewBtnA {
                submitBtnCallBack(0)
            }else if sender === v.twoBtnViewBtnB {
                submitBtnCallBack(1)
            }
        }
        v.submitBtnCallBack = submitBtnCallBackInDialog
        
        
        //Config Popup
        let popUp = KLCPopup(contentView: v, showType: .BounceInFromTop, dismissType: .BounceOutToBottom, maskType: .Dimmed, dismissOnBackgroundTouch: dismissOnBgTouch, dismissOnContentTouch: false)
        popUp.dimmedMaskAlpha = 0.4
        LCDialogHelper.sharedInstance.popUp = popUp
        
        
        //Show popup
        LCDialogHelper.sharedInstance.popUp!.showAtCenter(CGPointMake(LCSSharedFuncUtil.deviceWidth()/2.0, LCSSharedFuncUtil.deviceHeight()/2.0), inView: nil)
        
        
    }
    
    class func setBtnHighlight(btn :UIButton, highlight :Bool) {
        if highlight {
            btn.setTitleColor(LCSSharedFuncUtil.colorFromRGBA(0x6b450a, alpha: 1), forState: .Normal)
            btn.backgroundColor = LCSSharedFuncUtil.colorFromRGBA(0xFEE100, alpha: 1)
            btn.layer.borderWidth = 0
            btn.layer.borderColor = UIColor.clearColor().CGColor
        }else{
            btn.setTitleColor(LCSSharedFuncUtil.colorFromRGBA(0x2c2a28, alpha: 1), forState: .Normal)
            btn.backgroundColor = LCSSharedFuncUtil.colorFromRGBA(0xFEE100, alpha: 0)
            btn.layer.borderWidth = 1
            btn.layer.borderColor = LCSSharedFuncUtil.colorFromRGBA(0xc9c5c1, alpha: 1).CGColor
        }
    }
}

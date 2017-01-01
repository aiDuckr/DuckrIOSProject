//
//  LCUserMarginVC.swift
//  LinkCity
//
//  Created by Roy on 1/17/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit


class LCUserMarginVC: LCAutoRefreshVC, LCPaymentChooseViewDelegate, LCPaymentHelperDelegate {
    
    
    @IBOutlet weak var unpayScrollView: UIScrollView!
    @IBOutlet weak var payedScrollView: UIScrollView!
    
    @IBOutlet weak var marginBannerTop: NSLayoutConstraint!
    let marginBannerTopHide = 29
    let marginBannerTopShow = 64
    
    @IBOutlet weak var marginLabel: UILabel!
    @IBOutlet weak var marginBtn: UIButton!
    @IBOutlet weak var backToHomeBtn: UIButton!
    
    var paymentPopup : KLCPopup?
    var paymentView : LCPaymentChooseView?
    var paymentHelper : LCPaymentHelper?
    
    override class func createInstance() -> LCUserMarginVC!{
        return LCUserMarginVC(nibName: "LCUserMarginVC", bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "缴纳保证金"
        marginBannerTop.constant = CGFloat(marginBannerTopHide)
        LCUIConstants.sharedInstance().setButtonAsSubmitButtonEnableStyle(marginBtn)
        LCUIConstants.sharedInstance().setButtonAsSubmitButtonEnableStyle(backToHomeBtn)
        
        let marginNum = LCDataManager .sharedInstance().orderRule.marginValue
        if LCDecimalUtil.isOverZero(marginNum) {
            marginLabel.text = String(format: "￥%@", marginNum)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController!.tabBar.hidden = true
        
        updateShow()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        marginBannerTop.constant = CGFloat(marginBannerTopShow)
        UIView.animateWithDuration(1.0) { () -> Void in
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    func updateShow(){
        
        let user = LCDataManager.sharedInstance().userInfo
        if LCDecimalUtil.isOverZero(user.marginValue) {
            unpayScrollView.hidden = true
            payedScrollView.hidden = false
        }else {
            unpayScrollView.hidden = false
            payedScrollView.hidden = true
        }
    }

    
    @IBAction func marginBtnAction(sender: AnyObject) {
        showPaymentPopup()
        
    }

    @IBAction func agreementBtnAction(sender: AnyObject) {
        let url = LCConstants.serverHost() + LCUserMarginAgreementURL
        LCViewSwitcher.pushWebVCtoShowURL(url, withTitle: "达客旅行保证金协议", on: self.navigationController)
    }
    
    @IBAction func backToHomeBtnAction(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(false)
        LCSharedFuncUtil.getAppDelegate().tabBarVC.selectedIndex = 0
    }
    
    
    //MARK: - Payment Choose View
    func showPaymentPopup(){
        if (paymentPopup == nil) {
            paymentView = LCPaymentChooseView.createInstance()
            paymentView!.delegate = self
            paymentPopup = KLCPopup(contentView: paymentView, showType: .SlideInFromBottom, dismissType: .SlideOutToBottom, maskType: .Dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
            
        }
        
        let centerY = LCSSharedFuncUtil.deviceHeight() - paymentView!.intrinsicContentSize().height / 2.0
        paymentPopup!.showAtCenter(CGPointMake(LCSSharedFuncUtil.deviceWidth()/2.0, centerY), inView: nil)
    }
    
    func paymentChooseViewDidCancel(view: LCPaymentChooseView!) {
        NSLog("cancel")
        paymentPopup!.dismiss(true)
    }
    
    func paymentChooseViewDidChooseAliPay(view: LCPaymentChooseView!) {
        NSLog("ali")
        paymentPopup!.dismiss(true)
        paymentHelper = LCAliPaymentHelper(delegate: self)
        paymentHelper!.payMarginWithMarginValue(LCDataManager.sharedInstance().orderRule.marginValue)
    }
    
    func paymentChooseViewDidChooseWechatPay(view: LCPaymentChooseView!) {
        NSLog("wechat")
        paymentPopup!.dismiss(true)
        paymentHelper = LCWechatPaymentHelper(delegate: self)
        paymentHelper!.payMarginWithMarginValue(LCDataManager.sharedInstance().orderRule.marginValue)
    }
    
    //MARK: LCPaymentHelper Delegate
    func paymentHelper(paymentHelper: LCPaymentHelper!, didPayMarginSucceed succeed: Bool, error: NSError!) {
        
        //更新用户信息后更新显示
        LCNetRequester.getUserInfo(LCDataManager.sharedInstance().userInfo.uUID) { (retUser : LCUserModel?, error : NSError?) -> Void in
            
            if error == nil {
                LCDataManager.sharedInstance().userInfo = retUser
                self.updateShow()
            }
        }
        
        if succeed {
            YSAlertUtil.tipOneMessage("支付成功!")
            self.navigationController?.popViewControllerAnimated(true)
        }else {
            if error != nil &&
                LCStringUtil.isNotNullString(error.domain) {
                    YSAlertUtil.tipOneMessage(error.domain)
            }else{
                YSAlertUtil.tipOneMessage("支付失败")
            }
        }
    }
}










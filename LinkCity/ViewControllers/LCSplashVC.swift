//
//  LCSplashVC.swift
//  LinkCity
//
//  Created by 张宗硕 on 1/10/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit

class LCSplashVC: LCAutoRefreshVC {
    
    @IBOutlet weak var termButton: UIButton!
    @IBOutlet var tapView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTermButton()
        self.initGestureRecognizer()
    }
    
    override class func createInstance() -> LCSplashVC {
        return LCStoryboardManager.viewControllerWithFileName(SBNameMain, identifier: VCIDSplashVC) as! LCSplashVC
    }
    
    // MARK: Init Functions.
    internal func initTermButton() {
        let attributedString = NSMutableAttributedString(string: "使用条款和隐私政策")
        attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleDouble.rawValue, range: NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: LCSSharedFuncUtil.colorFromRGBA(0xad7f2d, alpha: 1.0), range: NSMakeRange(0, attributedString.length))
        self.termButton.setAttributedTitle(attributedString, forState: .Normal)
    }
    
    internal func initGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(LCSplashVC.longPressGestureAction))
        longPressGesture.minimumPressDuration = 3
        self.tapView.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: Common Functions.
    func longPressGestureAction(gestureRecognizer: UILongPressGestureRecognizer) {
        print("did block UMent with error")
        /// 长按则相当于按跳过按钮，并永远关闭本App的友盟统计.
//        LCDataManager.sharedInstance().shouldUMengActive = 0
        LCDataManager.sharedInstance().saveData()
        LCNetRequester.didBlockUMengWithCallBack { (error: NSError?) -> Void in
            print("did block UMent with error: %@", error)
        }
        
        let appDelegate = LCSharedFuncUtil.getAppDelegate()
        appDelegate.showTabBarVC()
    }
    
    // MARK: UIButton Functions.
    @IBAction func registerButtonAction(sender: AnyObject) {
//        LCUMengHelper.sharedInstance().setup()
        
        let appDelegate = LCSharedFuncUtil.getAppDelegate()
        appDelegate.showTabBarVC()
    }
    
    @IBAction func loginButtonAction(sender: AnyObject) {
//        LCUMengHelper.sharedInstance().setup()
        
        LCDataManager.sharedInstance().isFirstInUseLogin = true
        let appDelegate = LCSharedFuncUtil.getAppDelegate()
        appDelegate.showTabBarVC()
    }
    
    @IBAction func tryButtonAction(sender: AnyObject) {
        LCDataManager.sharedInstance().isFirstTimeOpenApp = 0
        LCDataManager.sharedInstance().saveData()
        
//        LCUMengHelper.sharedInstance().setup()
        
        let appDelegate = LCSharedFuncUtil.getAppDelegate()
        appDelegate.showTabBarVC()
    }
    
    @IBAction func termButtonAction(sender: AnyObject) {
        LCViewSwitcher.presentWebVCtoShowURL(LCSSharedFuncUtil.serverUrl(LCConstants.serverHost(), suffix:LCUserUseAgreementURL), withTitle: "使用条款和隐私策略")
    }
}

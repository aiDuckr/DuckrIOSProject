//
//  LCSendMultiMsgVC.swift
//  LinkCity
//
//  Created by Roy on 1/14/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit

class LCSendMultiMsgVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var phoneTextField: UITextView!
    @IBOutlet weak var msgTextField: UITextView!
    
    class func createInstance() -> LCSendMultiMsgVC{
        let vc = LCSendMultiMsgVC(nibName: "LCSendMultiMsgVC", bundle: nil)
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let cancelBtn = UIBarButtonItem(title: "退出", style: .Plain, target: self, action: "cancelBtnAction:")
        self.navigationItem.rightBarButtonItem = cancelBtn
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tap"))
        self.scrollView.delegate = self
    }

    func cancelBtnAction(sender : UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tap(){
        self.view.endEditing(true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }

    @IBAction func sendBtnAction(sender: AnyObject) {
        self.view.endEditing(true)
        
        let phones = phoneTextField.text
        let msg = msgTextField.text
        
        if LCStringUtil.isNullString(phones) ||
            LCStringUtil.isNullString(msg) {
                YSAlertUtil.tipOneMessage("input phone NO.,  input msg to send")
                
                return
        }
        
        let phoneArray = phones.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: ",/ ，。."))
        for anPhone in phoneArray {
            let openfireID = anPhone + "@" + LCConstants.xmppServerName()
            
            LCXMPPMessageHelper.sharedInstance().sendChatMessage(msg, toBareJidString: openfireID)
            NSLog("just send: \(msg) to: \(openfireID) \r\n")
        }
        
        YSAlertUtil.tipOneMessage("Finish!")
    }
  
    

}

//
//  LCCarIdentityAlertView.swift
//  LinkCity
//
//  Created by Roy on 1/13/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit

class LCCarIdentityAlertView: UIView {
    weak var delegate : LCCarIdentityAlertViewDelegate?
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    
    class func createInstance() -> LCCarIdentityAlertView {
        var ret : LCCarIdentityAlertView?
        let nib = UINib(nibName: "LCCarIdentityAlertViews", bundle: nil)
        let views = nib.instantiateWithOwner(nil, options: nil)
        
        for v in views {
            if v.isKindOfClass(LCCarIdentityAlertView) {
                ret = v as? LCCarIdentityAlertView
            }
        }
        
        return ret!
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(300, 250)
    }
    
    @IBAction func submitBtnAction(sender: AnyObject) {
        delegate?.carIdentityAlertViewDidSubmit()
    }
    
    @IBAction func cancelBtnAction(sender: AnyObject) {
        delegate?.carIdentityAlertViewDidCancel()
    }

}

@objc protocol LCCarIdentityAlertViewDelegate {
    func carIdentityAlertViewDidSubmit()
    func carIdentityAlertViewDidCancel()
}

//
//  LCDialogView.swift
//  LinkCity
//
//  Created by Roy on 1/16/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit

public enum LCDialogViewSubmitBtnTop : Int {
    case WithMiniBtn = 50
    case WithoutMiniBtn = 22
}

class LCDialogView: UIView {

    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var miniBtn: UIButton!
    
    
    @IBOutlet weak var oneBtnView: UIView!
    @IBOutlet weak var oneBtnViewTop: NSLayoutConstraint!
    @IBOutlet weak var oneBtnViewBtnA: UIButton!
    
    @IBOutlet weak var twoBtnView: UIView!
    @IBOutlet weak var twoBtnViewTop: NSLayoutConstraint!
    @IBOutlet weak var twoBtnViewBtnA: UIButton!
    @IBOutlet weak var twoBtnViewBtnB: UIButton!
    
    var cancelBtnCallBack : (() -> Void)?
    var miniBtnCallBack : (() -> Void)?
    var submitBtnCallBack : ((UIButton) -> Void)?
    
    
    required init?(coder aDecoder: NSCoder) {
        cancelBtnCallBack = nil
        miniBtnCallBack = nil
        submitBtnCallBack = nil
        
        super.init(coder: aDecoder)
    }
    
    class func createInstanceFromNib() -> LCDialogView{
        var ret : LCDialogView?
        let nib = UINib(nibName: "LCDialogView", bundle: nil)
        let views = nib.instantiateWithOwner(nil, options: nil)
        
        for v in views {
            if v.isKindOfClass(LCDialogView) {
                ret = v as? LCDialogView
            }
        }
        
        return ret!
    }
    

    @IBAction func cancelBtnAction(sender: AnyObject) {
        cancelBtnCallBack?()
    }
    
    
    @IBAction func miniBtnAction(sender: AnyObject) {
        miniBtnCallBack?()
    }
    
    
    @IBAction func submitBtnAction(sender: UIButton) {
        submitBtnCallBack?(sender)
    }
    
    
}

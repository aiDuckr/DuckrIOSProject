//
//  LCChatLocationBubble.swift
//  LinkCity
//
//  Created by Roy on 2/20/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit

class LCChatLocationBubble: LCChatBaseBubble {
    //MARK: property
    var oBgImageView : UIImageView?
    var oAddressLabel : UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: override fun
    override class func createInstance() -> LCChatLocationBubble {
        let bubbleView = LCChatLocationBubble(frame: CGRectZero)
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        return bubbleView
    }
    
    override func updateShow(){
        if let bgImageView = oBgImageView {
            bgImageView.removeFromSuperview()
        }
        
        if let addressLabel = oAddressLabel {
            addressLabel.removeFromSuperview()
        }
        
        if let msgModel = oMsgModel {
            oBgImageView = UIImageView(frame: CGRectZero)
            oBgImageView?.translatesAutoresizingMaskIntoConstraints = false
            oBgImageView?.contentMode = .ScaleAspectFill
            oBgImageView?.layer.masksToBounds = true
            self.addSubview(oBgImageView!)
            
            oAddressLabel = UILabel(frame: CGRectZero)
            oAddressLabel?.translatesAutoresizingMaskIntoConstraints = false
            oAddressLabel?.font = UIFont(name: LCFontLANTINGBLACK, size: LCChatConstants.locationBubbleFontSize())
            oAddressLabel?.textColor = UIColor.whiteColor()
            oAddressLabel?.numberOfLines = 1
            oAddressLabel?.backgroundColor = UIColor.clearColor()
            self.addSubview(oAddressLabel!)
            
            oAddressLabel?.text = LCStringUtil.getNotNullStr(msgModel.address)
            
            var hBgImageConstraintStr: String?
            var hAddressLabelConstraintStr: String?
            
            if msgModel.isSender {
                oBgImageView?.image = UIImage(named: LCChatConstants.locationBubbleRightBgImageName())
                
                
                hBgImageConstraintStr = "H:[oBgImageView(==\(LCChatConstants.locationBubbleWidth()))]-(\(LCChatConstants.locationBubbleLeading()))-|"
                
                hAddressLabelConstraintStr = "H:[oAddressLabel(==\(LCChatConstants.locationBubbleWidth()-20))]-(15)-|"
            } else {
                oBgImageView?.image = UIImage(named: LCChatConstants.locationBubbleLeftBgImageName())
                
                hBgImageConstraintStr = "H:|-(\(LCChatConstants.locationBubbleLeading()))-[oBgImageView(==\(LCChatConstants.locationBubbleWidth()))]"
                
                hAddressLabelConstraintStr = "H:|-(15)-[oAddressLabel(==\(LCChatConstants.locationBubbleWidth()-20))]"
            }
            
            
            let hBgImageConstraint = NSLayoutConstraint.constraintsWithVisualFormat(hBgImageConstraintStr!, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["oBgImageView" : oBgImageView!])
            self.addConstraints(hBgImageConstraint)
            
            let vBgImageConstraintStr = "V:|-(0)-[oBgImageView(==\(LCChatConstants.locationBubbleHeight()))]-(0)-|"
            let vBgImageConstraint = NSLayoutConstraint.constraintsWithVisualFormat(vBgImageConstraintStr, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["oBgImageView" : oBgImageView!])
            self.addConstraints(vBgImageConstraint)
            
            
            let hAddressLabelConstraint = NSLayoutConstraint.constraintsWithVisualFormat(hAddressLabelConstraintStr!, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["oAddressLabel" : oAddressLabel!])
            self.addConstraints(hAddressLabelConstraint)
            
            let vAddressLabelConstraintStr = "V:[oAddressLabel(==25)]-(0)-|"
            let vAddressLabelConstraint = NSLayoutConstraint.constraintsWithVisualFormat(vAddressLabelConstraintStr, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["oAddressLabel" : oAddressLabel!])
            self.addConstraints(vAddressLabelConstraint)
        }
    }
    
    override func tapAction(sender: AnyObject) {
        self.routerEventWithName(LCChatConstants.eventLocationBubbleTapEventName(), userInfo: [LCChatConstants.eventMessageKey(): self.oMsgModel!])
    }
}

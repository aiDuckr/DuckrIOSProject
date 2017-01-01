//
//  LCChatTextBubble.swift
//  LinkCity
//
//  Created by Roy on 1/11/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit

class LCChatTextBubble: LCChatBaseBubble {
    //MARK: property
    var bgImageView : UIImageView?
    var textLabel : LCCopyableLabel?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: override fun
    override class func createInstance() -> LCChatTextBubble {
        let bubbleView = LCChatTextBubble(frame: CGRectZero)
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        return bubbleView
    }
    
    override func updateShow(){
        if let bgIV = bgImageView {
            bgIV.removeFromSuperview()
        }
        
        if let txtL = textLabel {
            txtL.removeFromSuperview()
        }
        
        if let msgModel = oMsgModel {
            if msgModel.isSender{
                bgImageView = UIImageView(frame: CGRectZero)
                bgImageView!.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(bgImageView!)
                
                textLabel = LCCopyableLabel(frame: CGRectZero)
                textLabel!.translatesAutoresizingMaskIntoConstraints = false
                textLabel!.numberOfLines = 0
                self.addSubview(textLabel!)
                
                
                
                
                let hTextConstraintStr = "H:|-(>=\(LCChatConstants.textBubbleLabelToTrail()))-[textLabel]-(\(LCChatConstants.textBubbleLabelToLeading()))-|"
                let hTextConstraint = NSLayoutConstraint.constraintsWithVisualFormat(hTextConstraintStr, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bgImageView":bgImageView!, "textLabel":textLabel!])
                self.addConstraints(hTextConstraint)
                
                let vTextConstraintStr = "V:|-(6)-[textLabel]-(6)-|"
                let vTextConstraint = NSLayoutConstraint.constraintsWithVisualFormat(vTextConstraintStr, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bgImageView":bgImageView!, "textLabel":textLabel!])
                self.addConstraints(vTextConstraint)
                
                self.addConstraint(NSLayoutConstraint(item: bgImageView!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: textLabel!, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0-LCChatConstants.textBubbleLabelToTrail()))
                
                self.addConstraint(NSLayoutConstraint(item: bgImageView!, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: textLabel!, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: LCChatConstants.textBubbleLabelToLeading()))
                
                let vImageConstraintStr = "V:|-(0)-[bgImageView]-(0)-|"
                let vImageConstraint = NSLayoutConstraint.constraintsWithVisualFormat(vImageConstraintStr, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bgImageView":bgImageView!, "textLabel":textLabel!])
                self.addConstraints(vImageConstraint)
                
                
                
                bgImageView!.image = UIImage(named: LCChatConstants.textBubbleRightBgImageName())?.resizableImageWithCapInsets(UIEdgeInsetsMake(20, 23, 20, 23))
                textLabel!.text = msgModel.content
            }else{
                
                bgImageView = UIImageView(frame: CGRectZero)
                bgImageView!.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(bgImageView!)
                
                textLabel = LCCopyableLabel(frame: CGRectZero)
                textLabel!.translatesAutoresizingMaskIntoConstraints = false
                textLabel!.numberOfLines = 0
                self.addSubview(textLabel!)
                
                
                
                
                let hTextConstraintStr = "H:|-(\(LCChatConstants.textBubbleLabelToLeading()))-[textLabel]-(>=\(LCChatConstants.textBubbleLabelToTrail()))-|"
                let hTextConstraint = NSLayoutConstraint.constraintsWithVisualFormat(hTextConstraintStr, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bgImageView":bgImageView!, "textLabel":textLabel!])
                self.addConstraints(hTextConstraint)
                
                let vTextConstraintStr = "V:|-(6)-[textLabel]-(6)-|"
                let vTextConstraint = NSLayoutConstraint.constraintsWithVisualFormat(vTextConstraintStr, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bgImageView":bgImageView!, "textLabel":textLabel!])
                self.addConstraints(vTextConstraint)
                
                self.addConstraint(NSLayoutConstraint(item: bgImageView!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: textLabel!, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0-LCChatConstants.textBubbleLabelToLeading()))
                
                self.addConstraint(NSLayoutConstraint(item: bgImageView!, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: textLabel!, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: LCChatConstants.textBubbleLabelToTrail()))
                
                let vImageConstraintStr = "V:|-(0)-[bgImageView]-(0)-|"
                let vImageConstraint = NSLayoutConstraint.constraintsWithVisualFormat(vImageConstraintStr, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bgImageView":bgImageView!, "textLabel":textLabel!])
                self.addConstraints(vImageConstraint)
                
                
                
                bgImageView!.image = UIImage(named: LCChatConstants.textBubbleLeftBgImageName())?.resizableImageWithCapInsets(UIEdgeInsetsMake(20, 23, 20, 23))
                textLabel!.text = msgModel.content
            }
        }
    }

}

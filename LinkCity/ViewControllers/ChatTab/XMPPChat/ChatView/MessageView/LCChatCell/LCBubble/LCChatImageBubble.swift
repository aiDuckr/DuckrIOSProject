//
//  LCChatImageBubble.swift
//  LinkCity
//
//  Created by Roy on 2/20/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit

class LCChatImageBubble: LCChatBaseBubble {
    //MARK: property
    var oImageView : UIImageView?
    var oImageCoverView : UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: override fun
    override class func createInstance() -> LCChatImageBubble {
        let bubbleView = LCChatImageBubble(frame: CGRectZero)
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        return bubbleView
    }
    
    override func updateShow(){
        if let imageView = oImageView {
            imageView.removeFromSuperview()
        }
        
        if let imageCoverView = oImageCoverView {
            imageCoverView.removeFromSuperview()
        }
        
        if let msgModel = oMsgModel {
            oImageView = UIImageView(frame: CGRectZero)
            oImageView!.contentMode = .ScaleAspectFill
            oImageView?.layer.masksToBounds = true
            oImageView!.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(oImageView!)
            
            oImageCoverView = UIImageView(frame: CGRectZero)
            oImageCoverView!.contentMode = .ScaleAspectFill
            oImageCoverView?.layer.masksToBounds = true
            oImageCoverView!.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(oImageCoverView!)
            
            var hImageConstraintStr: String?
            var hCoverConstraintStr: String?
            
            if msgModel.isSender {
                if let tURL = msgModel.thumbnailRemoteURL {
                    oImageView?.setImageWithURL(tURL, placeholderImage: msgModel.thumbnailImage)
                }else{
                    oImageView?.image = msgModel.thumbnailImage
                }
                
                oImageCoverView?.image = UIImage(named: LCChatConstants.imageBubbleRightBgImageName())?.resizableImageWithCapInsets(UIEdgeInsetsMake(20, 23, 20, 23))
                
                hImageConstraintStr = "[oImageView(==\(LCChatConstants.imageBubbleImageWidth()))]-(\(LCChatConstants.imageBubbleImageLeading()))-|"
                
                hCoverConstraintStr = "H:[oImageCoverView(==\(LCChatConstants.imageBubbleImageWidth()))]-(\(LCChatConstants.imageBubbleImageLeading()))-|"
            } else {
                if let tURL = msgModel.thumbnailRemoteURL {
                    oImageView?.setImageWithURL(tURL, placeholderImage: UIImage(named: LCChatConstants.imageBubbleDownloadFail()))
                }else{
                    oImageView?.image = UIImage(named: LCChatConstants.imageBubbleDownloadFail())
                }
                
                oImageCoverView?.image = UIImage(named: LCChatConstants.imageBubbleLeftBgImageName())?.resizableImageWithCapInsets(UIEdgeInsetsMake(20, 23, 20, 23))
                
                hImageConstraintStr = "H:|-(\(LCChatConstants.imageBubbleImageLeading()))-[oImageView(==\(LCChatConstants.imageBubbleImageWidth()))]"
                
                hCoverConstraintStr = "H:|-(\(LCChatConstants.imageBubbleImageLeading()))-[oImageCoverView(==\(LCChatConstants.imageBubbleImageWidth()))]"
            }
            
            
            let hImageConstraint = NSLayoutConstraint.constraintsWithVisualFormat(hImageConstraintStr!, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["oImageView":oImageView!])
            self.addConstraints(hImageConstraint)
            
            let vImageConstraintStr = "V:|-(0)-[oImageView(==\(LCChatConstants.imageBubbleImageHeight()))]-(0)-|"
            let vImageConstraint = NSLayoutConstraint.constraintsWithVisualFormat(vImageConstraintStr, options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["oImageView":oImageView!])
            self.addConstraints(vImageConstraint)
            
            
            
            let hCoverConstraint = NSLayoutConstraint.constraintsWithVisualFormat(hCoverConstraintStr!, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["oImageCoverView":oImageCoverView!])
            self.addConstraints(hCoverConstraint)
            
            let vCoverConstraintStr = "V:|-(0)-[oImageCoverView(==\(LCChatConstants.imageBubbleImageHeight()))]-(0)-|"
            let vCoverConstraint = NSLayoutConstraint.constraintsWithVisualFormat(vCoverConstraintStr, options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["oImageCoverView":oImageCoverView!])
            self.addConstraints(vCoverConstraint)
        }
        
    }
    
    override func tapAction(sender: AnyObject) {
        self.routerEventWithName(LCChatConstants.eventImageTapEventName(), userInfo: [LCChatConstants.eventMessageKey(): self.oMsgModel!])
    }

}






//
//  LCChatPlanBubble.swift
//  LinkCity
//
//  Created by Roy on 2/20/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit

class LCChatPlanBubble: LCChatBaseBubble {
    //MARK: property
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var planImageView: UIImageView!
    @IBOutlet weak var planImageViewLeading: NSLayoutConstraint!
    @IBOutlet weak var descViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var destLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var shareLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var shareLabelTrailing: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: override fun
    override class func createInstance() -> LCChatPlanBubble {
        
        var ret: LCChatPlanBubble?
        let nib = UINib(nibName: "LCChatPlanBubble", bundle: nil)
        let viewArr = nib.instantiateWithOwner(nil, options: nil)
        for v in viewArr {
            if v.isKindOfClass(LCChatPlanBubble) {
                ret = v as? LCChatPlanBubble
                ret?.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        
        return ret!
    }
    
    override func updateShow(){
        if let msgModel = oMsgModel {
            
            if msgModel.isSender {
                self.bgImageView.image = UIImage(named: "ChatTextRightWhite")?.resizableImageWithCapInsets(UIEdgeInsetsMake(20, 23, 20, 23))
                
                planImageViewLeading.constant = 10
                descViewTrailing.constant = 20
                shareLabelLeading.priority = 100
                shareLabelTrailing.priority = 1000
                shareLabelTrailing.constant = 10
            } else {
                self.bgImageView.image = UIImage(named: LCChatConstants.textBubbleLeftBgImageName())?.resizableImageWithCapInsets(UIEdgeInsetsMake(20, 23, 20, 23))
                
                planImageViewLeading.constant = 20
                descViewTrailing.constant = 10
                shareLabelLeading.priority = 1000
                shareLabelTrailing.priority = 100
                shareLabelLeading.constant = 10
            }
            
            self.planImageView.setImageWithURL(NSURL(string: msgModel.plan.firstPhotoThumbUrl)!)
            self.timeLabel.text = LCStringUtil.getNotNullStr(msgModel.plan.startTime)
            
            
            let destStr = msgModel.plan.getDestinationsStringWithSeparator("-")
            var routeStr: String?
            if (LCStringUtil.isNotNullString(msgModel.plan.departName)) {
                routeStr = msgModel.plan.departName + "-" + destStr
            } else{
                routeStr = "目的地:" + destStr
            }
            self.destLabel.text = routeStr
            
            self.descLabel.text = msgModel.plan.descriptionStr
        }
    }
    
    override func tapAction(sender: AnyObject) {
        self.routerEventWithName(LCChatConstants.eventPlanBubbleTapEventName(), userInfo: [LCChatConstants.eventMessageKey(): self.oMsgModel!])
    }
}

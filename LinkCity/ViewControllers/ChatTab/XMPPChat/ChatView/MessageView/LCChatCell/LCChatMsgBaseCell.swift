//
//  LCChatMsgBaseCell.swift
//  LinkCity
//
//  Created by Roy on 1/11/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit

class LCChatMsgBaseCell: UITableViewCell, MessageModelDelegate {
    //MARK: UI
    var oBubbleView : AnyObject?
    var baseAvatarBtn: UIButton!
    var baseAvatarBtnTop: NSLayoutConstraint!
    var baseNickLabel: UILabel!
    var baseBubbleHolder: UIView!
    var baseBubbleHolderTop: NSLayoutConstraint!
    var baseActivityView: UIActivityIndicatorView!
    
    //MARK: data
    var msgModel : MessageModel? {
        
        didSet {
            msgModel?.removeMessageModelDelegate(self)
            msgModel?.addMessageModelDelegate(self)
            updateShowByMsgModel()
        }
        
    }
    
    func updateShowByMsgModel(){
        if let bubbleView = oBubbleView as? UIView{
            bubbleView.removeFromSuperview()
        }
        
        let bubbleView = self.bubbleViewForMessageModel(self.msgModel)
        oBubbleView = bubbleView
        bubbleView.oMsgModel = msgModel
        baseBubbleHolder.addSubview(bubbleView)
        
        let hContraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[bubbleView]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bubbleView":bubbleView])
        baseBubbleHolder.addConstraints(hContraints)
        let vContraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[bubbleView]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bubbleView":bubbleView])
        baseBubbleHolder.addConstraints(vContraints)
        
        if let headImageURL = msgModel?.headImageURL {
            baseAvatarBtn.setImageForState(.Normal, withURL: headImageURL, placeholderImage: UIImage(named: LCDefaultAvatarImageName))
        } else {
            baseAvatarBtn.setImage(UIImage(named: LCDefaultAvatarImageName), forState: .Normal)
        }
        baseAvatarBtn.addTarget(self, action: "avatarBtnAction:", forControlEvents: .TouchUpInside)
        
        let isChatGroup = msgModel!.isChatGroup
        if isChatGroup {
            baseNickLabel.hidden = false
            baseBubbleHolderTop.constant = 20
        } else {
            baseNickLabel.hidden = true
            baseBubbleHolderTop.constant =  0
        }
        baseNickLabel.text = LCStringUtil.getNotNullStr(msgModel?.username)
        
        self.hideLoading()
        //如果是发送图片消息，并且未上传完成图片，显示loading
        if msgModel?.type == eMessageBodyType_Image &&
        (msgModel?.imageRemoteURL==nil || LCStringUtil.isNullString(msgModel?.imageRemoteURL.absoluteString)) &&
            (msgModel?.thumbnailRemoteURL==nil || LCStringUtil.isNullString(msgModel?.thumbnailRemoteURL.absoluteString)) {
                self.showLoading()
        }
    }
    
    func bubbleViewForMessageModel(omsgModel: MessageModel?) -> LCChatBaseBubble {
        
        if let msgModel = omsgModel {
            switch msgModel.type {
            case eMessageBodyType_Text:
                return LCChatTextBubble.createInstance()
            case eMessageBodyType_Image:
                return LCChatImageBubble.createInstance()
            case eMessageBodyType_Location:
                return LCChatLocationBubble.createInstance()
            case eMessageBodyType_Plan:
                return LCChatPlanBubble.createInstance()
            case eMessageBodyType_Voice:
                return LCChatVoiceBubble.createInstance()
            default:
                return LCChatTextBubble.createInstance()
            }
        }else {
            return LCChatTextBubble.createInstance()
        }
        
    }
    
    
    func showLoading(){
        self.baseActivityView.hidden = false
        self.baseActivityView.startAnimating()
        self.userInteractionEnabled = false
    }
    
    func hideLoading(){
        self.baseActivityView.hidden = true
        self.baseActivityView.stopAnimating()
        self.userInteractionEnabled = true
    }
    
    //MARK: button action
    func avatarBtnAction(sender: AnyObject) {
        self.routerEventWithName(LCChatConstants.eventHeadImageTapEventName(), userInfo: [LCChatConstants.eventMessageKey(): self.msgModel!])
    }
    
    //MARK: MessageModelDelegate
    func uploadImageFinished(model: MessageModel!) {
        if model == self.msgModel {
            self.hideLoading()
        }
    }
    
}

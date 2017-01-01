//
//  LCChatMsgCell.swift
//  LinkCity
//
//  Created by Roy on 1/9/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit

class LCChatMsgLeftCell: LCChatMsgBaseCell {
    
    //MARK: UI
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var avatarBtnTop: NSLayoutConstraint!
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var bubbleHolder: UIView!
    @IBOutlet weak var bubbleHolderTop: NSLayoutConstraint!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        commonInit()
    }
    
    func commonInit(){
        self.baseAvatarBtn = avatarBtn
        self.baseAvatarBtnTop = avatarBtnTop
        self.baseNickLabel = nickLabel
        self.baseBubbleHolder = bubbleHolder
        self.baseBubbleHolderTop = bubbleHolderTop
        self.baseActivityView = activityView
    }
}

//
//  LCChatBaseBubble.swift
//  LinkCity
//
//  Created by Roy on 1/12/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit

class LCChatBaseBubble: UIView {

    class func createInstance() -> LCChatBaseBubble {
        fatalError("must override updateShow")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit(){
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapAction:")
        self.addGestureRecognizer(tapGesture)
    }
    
    var oMsgModel : MessageModel? {
        didSet{
            updateShow()
        }
    }
    
    func updateShow(){
        fatalError("must override updateShow")
    }
    
    //MARK: tap action
    func tapAction(sender: AnyObject){
        
    }

}

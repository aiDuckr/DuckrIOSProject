//
//  LCChatVoiceBubble.swift
//  LinkCity
//
//  Created by Roy on 2/20/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit

class LCChatVoiceBubble: LCChatBaseBubble {
    //MARK: property
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var leftBgImageView: UIImageView!
    @IBOutlet weak var leftBgImageWidth: NSLayoutConstraint!
    @IBOutlet weak var leftAudioIcon: UIImageView!
    @IBOutlet weak var leftTimeLabel: UILabel!
    
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var rightBgImageView: UIImageView!
    @IBOutlet weak var rightBgImageWidth: NSLayoutConstraint!
    @IBOutlet weak var rightAudioIcon: UIImageView!
    @IBOutlet weak var rightTimeLabel: UILabel!
    
    var animationTimer: NSTimer?
    var animationTimerTickNum: NSInteger?
    var animationTimerTickNumMax: NSInteger?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        
        self.leftBgImageView.image = UIImage(named: "ChatAudioBgLeft")!.resizableImageWithCapInsets(UIEdgeInsetsMake(15, 18, 5, 8))
        self.rightBgImageView.image = UIImage(named: "ChatAudioBgRight")!.resizableImageWithCapInsets(UIEdgeInsetsMake(15, 8, 5, 18))
    }
    
    //MARK: override fun
    override class func createInstance() -> LCChatVoiceBubble {
        var ret: LCChatVoiceBubble?
        let nib = UINib(nibName: "LCChatVoiceBubble", bundle: nil)
        let viewArr = nib.instantiateWithOwner(nil, options: nil)
        for v in viewArr {
            if v.isKindOfClass(LCChatVoiceBubble) {
                ret = v as? LCChatVoiceBubble
                ret?.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        
        return ret!
    }
    
    override func updateShow(){
        if let msgModel = oMsgModel {
            let voiceData = RecordAudio.getDataFromString(msgModel.voice)
            let voiceTime = RecordAudio.getAudioTime(voiceData)
            
            let minBgLength:CGFloat = 50.0
            var length = CGFloat(voiceTime / 10 ) * (LCSSharedFuncUtil.deviceWidth() - CGFloat(170))
            length = max(minBgLength, length)
            
            print("voiceTime:\(voiceTime)    length:\(length)")
            
            if msgModel.isSender {
                //隐藏在左的显示，宽度设为minBgLength，使得bubble通过右侧计算获得
                leftView.hidden = true
                leftBgImageWidth.constant = minBgLength
                
                rightView.hidden = false
                rightBgImageWidth.constant = length
                rightTimeLabel.text = "\(Int(voiceTime))\""
            }else{
                leftView.hidden = false
                leftBgImageWidth.constant = length
                leftTimeLabel.text = "\(Int(voiceTime))\""
                
                //隐藏在右的显示，宽度设为0，使得bubble通过左侧计算获得
                rightView.hidden = true
                rightBgImageWidth.constant = minBgLength
            }
        }
    }
    
    override func tapAction(sender: AnyObject) {
        self.routerEventWithName(LCChatConstants.eventVoiceBubbleTapEventName(), userInfo: [LCChatConstants.eventMessageKey(): self.oMsgModel!])
        self.startPlayAnimation()
    }
    
    func startPlayAnimation() {
        if let msgModel = oMsgModel {
            let voiceData = RecordAudio.getDataFromString(msgModel.voice)
            let voiceTime = RecordAudio.getAudioTime(voiceData)
            
            if let at = animationTimer {
                at.invalidate()
            }
            animationTimerTickNum = 0;
            animationTimerTickNumMax = Int(voiceTime) * 4
            animationTimer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Selector("animationTimerAction:"), userInfo: nil, repeats: true)
        }
    }
    
    func animationTimerAction(timer: NSTimer) {
        
        animationTimerTickNum! += 1
        let animalStep = animationTimerTickNum! % 3
        
        if animalStep == 0 {
            leftAudioIcon.image = UIImage(named: "ChatAudioIconGrayA")
            rightAudioIcon.image = UIImage(named: "ChatAudioIconBrownA")
        }else if animalStep == 1 {
            leftAudioIcon.image = UIImage(named: "ChatAudioIconGrayB")
            rightAudioIcon.image = UIImage(named: "ChatAudioIconBrownB")
        }else if animalStep == 2 {
            leftAudioIcon.image = UIImage(named: "ChatAudioIconGrayC")
            rightAudioIcon.image = UIImage(named: "ChatAudioIconBrownC")
        }
        
        if animationTimerTickNum >= animationTimerTickNumMax {
            animationTimer?.invalidate()
            leftAudioIcon.image = UIImage(named: "ChatAudioIconGrayC")
            rightAudioIcon.image = UIImage(named: "ChatAudioIconBrownC")
        }
    }
}

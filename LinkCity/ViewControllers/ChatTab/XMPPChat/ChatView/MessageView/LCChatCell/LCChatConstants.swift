//
//  LCChatConstants.swift
//  LinkCity
//
//  Created by Roy on 1/11/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import UIKit

class LCChatConstants: NSObject {
//    private init() {}
    
    class func deviceWidth() -> CGFloat {return UIScreen.mainScreen().bounds.size.width }
    class func deviceHeight() -> CGFloat {return UIScreen.mainScreen().bounds.size.height }
    class func bubbleMaxWidth() -> CGFloat {return LCChatConstants.deviceWidth() - CGFloat(50) - CGFloat(70) }
    
    //MARK: text bubble
    class func textBubbleLeftBgImageName() -> String { return "ChatTextLeft" }
    class func textBubbleRightBgImageName() -> String { return "ChatTextRight" }
    class func textBubbleLabelToLeading() -> CGFloat {return 20 }
    class func textBubbleLabelToTrail() -> CGFloat {return 8 }
    
    //MARK: image bubble
    class func imageBubbleLeftBgImageName() -> String { return "ChatImageLeft" }
    class func imageBubbleRightBgImageName() -> String { return "ChatImageRight" }
    class func imageBubbleDownloadFail() -> String { return "imageDownloadFail" }
    class func imageBubbleImageLeading() -> CGFloat {return 2 }
    class func imageBubbleImageWidth() -> CGFloat {return 150 }
    class func imageBubbleImageHeight() -> CGFloat {return 94 }
    
    
    //MARK: location bubble
    class func locationBubbleLeftBgImageName() -> String { return "ChatLocationLeft" }
    class func locationBubbleRightBgImageName() -> String { return "ChatLocationRight" }
    class func locationBubbleLeading() -> CGFloat {return 2 }
    class func locationBubbleWidth() -> CGFloat {return 150 }
    class func locationBubbleHeight() -> CGFloat {return 94 }
    
    class func locationBubbleFontSize() -> CGFloat {return 14 } // 位置字体大小
    class func locationBubbleTextPadding() -> CGFloat {return 2 }   // 位置文字与外边间距
    class func locationBubbleTextBgHeight() -> CGFloat {return 25 } // 位置文字显示外框的高度
    
    //MARK: plan bubble
    class func planBubbleImageWidth() -> CGFloat {return 90 }
    class func planBubbleImageHeight() -> CGFloat {return 86 }
    class func planBubbleImageGap() -> CGFloat {return 10 }
    
    //MARK: event
    class func eventMessageKey() -> String { return "message" }
    class func eventHeadImageTapEventName() -> String { return "kRouterEventChatHeadImageTapEventName" }
    class func eventImageTapEventName() -> String { return "kRouterEventImageBubbleTapEventName" }
    class func eventPlanBubbleTapEventName() -> String { return "kRouterEventPlanBubbleTapEventName" }
    class func eventLocationBubbleTapEventName() -> String { return "kRouterEventLocationBubbleTapEventName" }
    class func eventVoiceBubbleTapEventName() -> String { return "kRouterEventVoiceBubbleTapEventName" }
}



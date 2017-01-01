//
//  LCSSharedFuncUtil.swift
//  LinkCity
//
//  Created by 张宗硕 on 1/11/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

import Foundation

class LCSSharedFuncUtil {
    class func colorFromRGBA(rgbValue: Int, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(((rgbValue & 0xFF0000) >> 16)) / 255.0, green: CGFloat(((rgbValue & 0xFF00) >> 8)) / 255.0, blue: CGFloat((rgbValue & 0xFF)) / 255.0, alpha: alpha)
    }
//    class func colorFromHexString(hexString:String) -> UIColor {
//        return UIColor()
//    }
    class func serverUrl(prefix: String, suffix: String) -> String {
        return prefix + suffix
    }
    
    class func deviceWidth() -> CGFloat {
        return UIScreen.mainScreen().bounds.size.width
    }
    
    class func deviceHeight() -> CGFloat {
        return UIScreen.mainScreen().bounds.size.height
    }
    
    class func classNameOfClass(theClass: AnyClass) -> String {
        return NSStringFromClass(theClass).componentsSeparatedByString(".").last!
    }
    class func adaptBy6sWidthForAllDevice(widthFor6s:CGFloat) -> CGFloat {
         return widthFor6s / 375.0 * UIScreen.mainScreen().bounds.size.width
    }

    class func adaptBy6sHeightForAllDevice(heightFor6s:CGFloat) -> CGFloat {
        return heightFor6s / 667.0 * UIScreen.mainScreen().bounds.size.height
    }
    
}


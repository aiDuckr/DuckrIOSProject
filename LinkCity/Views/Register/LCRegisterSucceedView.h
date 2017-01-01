//
//  LCRegisterSucceedView.h
//  LinkCity
//
//  Created by roy on 2/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCRegisterSucceedView : UIView
+ (instancetype)createInstanceWithCallBack:(void(^)(LCRegisterSucceedView *succeedView))callBack;
@end

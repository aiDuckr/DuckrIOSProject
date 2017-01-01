//
//  LCCreateRouteAlertView.h
//  LinkCity
//
//  Created by roy on 3/13/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCCreateRouteAlertView : UIView
@property (nonatomic, strong) void(^callBack)(BOOL didConfirm);

+ (instancetype)createInstance;
@end

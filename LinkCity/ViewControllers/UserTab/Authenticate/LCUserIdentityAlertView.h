//
//  LCUserIdentityAlertView.h
//  LinkCity
//
//  Created by roy on 3/12/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCUserIdentityAlertView : UIView
@property (nonatomic, strong) void(^callBack)(BOOL didConfirm);

+ (instancetype)createInstance;
@end

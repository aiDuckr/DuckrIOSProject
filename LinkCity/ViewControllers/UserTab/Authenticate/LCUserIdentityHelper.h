//
//  LCUserIdentityHelper.h
//  LinkCity
//
//  Created by roy on 3/12/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCUserIdentityHelper : NSObject
+ (instancetype)sharedInstance;
- (void)startUserIdentityWithUser:(LCUserModel *)user fromVC:(UIViewController *)vc;
- (void)startCarIdentityWithUser:(LCUserModel *)user fromVC:(UIViewController *)vc;
- (void)starGuideIdentityWithUser:(LCUserModel *)user fromVC:(UIViewController *)vc;



@end

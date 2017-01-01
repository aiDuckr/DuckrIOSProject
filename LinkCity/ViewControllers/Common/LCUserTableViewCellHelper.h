//
//  LCUserDetailTableCellHelper.h
//  LinkCity
//
//  Created by roy on 3/17/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCUserTableViewCell.h"

@interface LCUserTableViewCellHelper : NSObject

+ (void)setUserTableViewCell:(LCUserTableViewCell *)userCell shownAsChatContactWithUser:(LCUserModel *)user;
+ (void)setUserTableViewCell:(LCUserTableViewCell *)userCell shownAsAddRecommendedFriendWithUser:(LCUserModel *)user;
+ (void)setUserTalbeViewCell:(LCUserTableViewCell *)userCell shownAsUserTableViewCell:(LCUserModel *)user;

+ (void)setUserTableViewCell:(LCUserTableViewCell *)userCell shownAsRecommendUserWhenRegister:(LCUserModel *)user;
+ (void)setUserTableViewCell:(LCUserTableViewCell *)userCell shownAsRecommendUserWhenRegisterSelected:(BOOL)selected;
@end

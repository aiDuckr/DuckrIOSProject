//
//  LCChatTabNotificationCell.h
//  LinkCity
//
//  Created by lhr on 16/6/16.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCNotificationModel;
@interface LCChatTabNotificationCell : UITableViewCell
@property (strong, nonatomic) LCNotificationModel* model;
- (void)updateShowWithNotificationModel:(LCNotificationModel *)model;

@end

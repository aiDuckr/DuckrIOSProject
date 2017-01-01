//
//  LCChatWithUserCell.h
//  LinkCity
//
//  Created by roy on 3/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCChatContactModel.h"
#import "XMPPMessageArchiving_Contact_CoreDataObject.h"

typedef enum : NSUInteger {
    LCRecentChatCellType_User,
    LCRecentChatCellType_Plan,
    LCRecentChatCellType_Group,
} LCRecentChatCellType;


@interface LCRecentChatCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIView *dotView;
@property (weak, nonatomic) IBOutlet UILabel *dotLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)updateShowWithChatContact:(LCChatContactModel *)chatContact coreDataContact:(XMPPMessageArchiving_Contact_CoreDataObject *)coreDataContact unreadNum:(NSInteger)unreadNum;
- (void)updateShowWithTitle:(NSString *)title imageName:(NSString *)imageName updateTime:(NSString *)timeStr descString:(NSString *)descString unreadNum:(NSInteger)unreadNum;
+ (CGFloat)getCellHeight;
@end

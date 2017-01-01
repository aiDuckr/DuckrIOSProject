//
//  LCHomeUserCell.h
//  LinkCity
//
//  Created by 张宗硕 on 5/16/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LCHomeUserCellViewType_HomepageRecm,            //!< 首页推荐，一级.
    LCHomeUserCellViewType_HomeRecmOnlineDuckr,     //!< 首页推荐，在线达客.
    LCHomeUserCellViewType_HomepageDuckr,           //!< 首页达客，一级页面人气达客.
    LCHomeUserCellViewType_HomeDuckrBoard,          //!< 首页达客，达客榜.
    LCHomeUserCellViewType_HomeDuckrLocal,          //!< 首页达客，同城达客.
    LCHomeUserCellViewType_UserFansFavor,           //!< 用户关注or粉丝
    LCHomeUserCellViewType_ChatAddFriend,           //!< 消息 添加关注
    LCHomeUserCellViewType_ChatAddFriendSearch,     //!< 消息 添加关注搜索
    LCHomeUserCellViewType_ChatAddFriendNearbyDuckr,//!< 消息 添加关注附近达客
} LCHomeUserCellType;

@interface LCHomeUserCell : UITableViewCell

@property (nonatomic, assign) LCHomeUserCellType cellType;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIView *sexView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIButton *focusButton;
@property (weak, nonatomic) IBOutlet UIView *lineSplitView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSplitHeightConstraint;

@property (strong, nonatomic) LCUserModel *user;

- (void)updateShowCell:(LCUserModel *)user withType:(LCHomeUserCellType)type;
- (void)updateShowCell:(LCUserModel *)user withIndex:(NSInteger)index withType:(LCHomeUserCellType)type;
- (void)updateChatAddFriendLabelWithMixedNumber:(NSInteger)num;
- (void)updateChatAddFriendSearchLabelWithKeyWord:(NSString *)keyWord;
@end

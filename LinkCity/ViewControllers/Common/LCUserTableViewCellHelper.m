//
//  LCUserDetailTableCellHelper.m
//  LinkCity
//
//  Created by roy on 3/17/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserTableViewCellHelper.h"

@implementation LCUserTableViewCellHelper

+ (void)setUserTableViewCell:(LCUserTableViewCell *)userCell shownAsChatContactWithUser:(LCUserModel *)user{
    if (!user) {
        return;
    }
    
    userCell.user = user;
    
    userCell.topContentLabe.hidden = NO;
    userCell.topContentLabelTrailing.constant = UserTableViewCellTopContentTrailingToEdge;
    
    if ([LCStringUtil isNotNullString:user.livingPlace]) {
        userCell.topContentLabe.text = [NSString stringWithFormat:@"来自%@",user.livingPlace];
    }else{
        userCell.topContentLabe.text = @"";
    }
    
    userCell.bottomContentLabel.hidden = NO;
    userCell.bottomContentLabel.text = [LCStringUtil getNotNullStr:user.signature];
}

+ (void)setUserTableViewCell:(LCUserTableViewCell *)userCell shownAsAddRecommendedFriendWithUser:(LCUserModel *)user{
    if (!user) {
        return;
    }
    
    userCell.user = user;
    
    userCell.topContentLabe.hidden = NO;
    userCell.topContentLabelTrailing.constant = UserTableViewCellTopContentTrailingToBtn;
    if ([LCStringUtil isNotNullString:user.livingPlace]) {
        userCell.topContentLabe.text = [NSString stringWithFormat:@"来自%@",user.livingPlace];
    }else{
        userCell.topContentLabe.text = @"";
    }
    
    userCell.bottomContentLabel.hidden = NO;
    NSString *bottomContent = @"";
//  不显示距离
//    if (user.distance >= 0) {
//        bottomContent = [bottomContent stringByAppendingFormat:@"%.1fkm ",user.distance/1000.0f];
//    }
    bottomContent = [bottomContent stringByAppendingString:[user getUserRelationString]];
    userCell.bottomContentLabel.text = bottomContent;
    
    userCell.rightTopButton.hidden = NO;
    if (user.isFavored) {
        userCell.rightTopButton.backgroundColor = [UIColor clearColor];
        userCell.rightTopButton.layer.borderWidth = 0;
        [userCell.rightTopButton setTitle:@"已关注" forState:UIControlStateNormal];
        [userCell.rightTopButton setTitleColor:UIColorFromR_G_B_A(201, 197, 193, 1) forState:UIControlStateNormal];
    } else if ([user.uUID isEqualToString:[LCDataManager sharedInstance].userInfo.uUID]) {
        userCell.rightTopButton.hidden = YES;
    } else {
        userCell.rightTopButton.backgroundColor = [UIColor clearColor];
        userCell.rightTopButton.layer.borderColor = UIColorFromRGBA(LCDarkTextColor, 1).CGColor;
        userCell.rightTopButton.layer.borderWidth = 0.5;
        [userCell.rightTopButton setTitle:@"关注" forState:UIControlStateNormal];
        [userCell.rightTopButton setTitleColor:UIColorFromRGBA(LCDarkTextColor, 1) forState:UIControlStateNormal];
    }
}

+ (void)setUserTalbeViewCell:(LCUserTableViewCell *)userCell shownAsUserTableViewCell:(LCUserModel *)user{
    [self setUserTableViewCell:userCell shownAsChatContactWithUser:user];
}



+ (void)setUserTableViewCell:(LCUserTableViewCell *)userCell shownAsRecommendUserWhenRegister:(LCUserModel *)user{
    if (!user) {
        return;
    }
    
    userCell.user = user;
    
    userCell.topContentLabe.hidden = NO;
    userCell.topContentLabelTrailing.constant = UserTableViewCellTopContentTrailingToBtn;
    if ([LCStringUtil isNotNullString:user.livingPlace]) {
        userCell.topContentLabe.text = [NSString stringWithFormat:@"来自%@",user.livingPlace];
    }else{
        userCell.topContentLabe.text = @"";
    }
    
    userCell.bottomContentLabel.hidden = NO;
    NSString *bottomContent = @"";
//  不显示距离
//    if (user.distance >= 0) {
//        bottomContent = [bottomContent stringByAppendingFormat:@"%.1fkm ",user.distance/1000.0f];
//    }
    bottomContent = [bottomContent stringByAppendingString:[user getUserRelationString]];
    userCell.bottomContentLabel.text = bottomContent;
    
    userCell.rightSelectionImageView.hidden = NO;
}
+ (void)setUserTableViewCell:(LCUserTableViewCell *)userCell shownAsRecommendUserWhenRegisterSelected:(BOOL)selected{
    if (selected) {
        userCell.rightSelectionImageView.image = [UIImage imageNamed:@"RecommendUserSelect"];
    }else{
        userCell.rightSelectionImageView.image = [UIImage imageNamed:@"RecommendUserDeselect"];
    }
}


@end

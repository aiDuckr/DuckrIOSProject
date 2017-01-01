//
//  LCSendFreePlanFinishAUserCell.m
//  LinkCity
//
//  Created by Roy on 12/14/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCSendFreePlanFinishAUserCell.h"

@implementation LCSendFreePlanFinishAUserCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateShowWithUser:(LCUserModel *)user selected:(BOOL)selected{
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
    self.nickLabel.text = [LCStringUtil getNotNullStr:user.nick];
    
    if (selected) {
        self.selectionImageView.image = [UIImage imageNamed:@"SendPlanFinishRecmdUserChooseIcon"];
    }else{
        self.selectionImageView.image = [UIImage new];
    }
}

@end

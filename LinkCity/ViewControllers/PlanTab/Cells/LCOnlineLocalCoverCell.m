//
//  LCOnlineLocalCoverCell.m
//  LinkCity
//
//  Created by 张宗硕 on 5/18/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCOnlineLocalCoverCell.h"

@implementation LCOnlineLocalCoverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowCell:(LCHomeCategoryModel *)leftCategory withRightCategory:(LCHomeCategoryModel *)rightCategory {
    if (nil != leftCategory && [LCStringUtil isNotNullString:leftCategory.coverThumbUrl]) {
        [self.leftCoverImageView setImageWithURL:[NSURL URLWithString:leftCategory.coverThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    }
    if (nil != rightCategory && [LCStringUtil isNotNullString:rightCategory.coverThumbUrl]) {
        [self.rightCoverImageView setImageWithURL:[NSURL URLWithString:rightCategory.coverThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    }
}

- (IBAction)onlineDuckrAction:(id)sender {
    [LCViewSwitcher pushToShowHomeRecmOnlineDuckrsOn:[LCSharedFuncUtil getTopMostNavigationController]];
}

- (IBAction)cityDuckrAction:(id)sender {
    [LCViewSwitcher pushToShowHomeRecmLocalDuckrsOn:[LCSharedFuncUtil getTopMostNavigationController]];
}


@end

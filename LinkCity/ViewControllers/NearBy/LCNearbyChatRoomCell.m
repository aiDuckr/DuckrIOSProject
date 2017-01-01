//
//  LCNearbyCharRoomCell.m
//  LinkCity
//
//  Created by roy on 3/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCNearbyChatRoomCell.h"

@implementation LCNearbyChatRoomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setChatGroupModel:(LCChatGroupModel *)chatGroupModel{
    _chatGroupModel = chatGroupModel;
    
    [self updateShow];
}

- (void)updateShow{
    if (self.chatGroupModel){
    [self.iconImageView setImageWithURL:[NSURL URLWithString:self.chatGroupModel.coverThumbUrl] placeholderImage:nil];
        self.titleLabel.text = [LCStringUtil getNotNullStr:self.chatGroupModel.name];
        self.memberNumLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.chatGroupModel.userNum,(long)self.chatGroupModel.maxScale];
        self.contentLabel.text = [LCStringUtil getNotNullStr:self.chatGroupModel.descriptionStr];
        if (self.chatGroupModel.distance >= 0){
            self.distanceLabel.hidden = NO;
            self.distanceLabel.text = [NSString stringWithFormat:@"%.1fkm",self.chatGroupModel.distance/1000.0f];
        }
    }
}

+ (CGFloat)getCellHeight{
    return 90;
}


@end

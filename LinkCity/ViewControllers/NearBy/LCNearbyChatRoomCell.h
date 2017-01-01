//
//  LCNearbyCharRoomCell.h
//  LinkCity
//
//  Created by roy on 3/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCChatGroupModel.h"

@interface LCNearbyChatRoomCell : UITableViewCell
@property (nonatomic, strong) LCChatGroupModel *chatGroupModel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineLead;

+ (CGFloat)getCellHeight;
@end

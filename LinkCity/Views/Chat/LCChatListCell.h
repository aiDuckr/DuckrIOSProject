//
//  LCChatListCell.h
//  LinkCity
//
//  Created by 张宗硕 on 11/20/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface LCChatListCell : UITableViewCell

@property (nonatomic, retain) UINavigationController *naviVC;
@property (nonatomic, retain) id cellObj;
@property (weak, nonatomic) IBOutlet EGOImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *dotView;
@property (weak, nonatomic) IBOutlet UILabel *numberHintLabel;

@end

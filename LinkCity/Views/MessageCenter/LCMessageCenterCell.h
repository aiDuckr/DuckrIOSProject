//
//  LCMessageCenterCell.h
//  LinkCity
//
//  Created by zzs on 14/12/2.
//  Copyright (c) 2014年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "LCNotification.h"

@interface LCMessageCenterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet EGOImageButton *avatarButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *dotView;
@property (nonatomic, retain) LCNotification *notif;
@property (nonatomic, retain) UINavigationController *naviController;
@end

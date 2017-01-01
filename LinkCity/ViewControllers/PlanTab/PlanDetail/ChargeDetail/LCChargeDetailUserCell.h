//
//  LCChargeDetailUserCell.h
//  LinkCity
//
//  Created by Roy on 6/25/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCChargeDetailUserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *borderBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *borderBgViewBottom;
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *withOtherLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *chargeLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@property (nonatomic, strong) LCUserModel *user;


- (void)updateShowWithUser:(LCUserModel *)user isLastCell:(BOOL)isLast;
+ (CGFloat)getCellHeightForUser:(LCUserModel *)user;
@end

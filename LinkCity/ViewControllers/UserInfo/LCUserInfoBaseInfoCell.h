//
//  LCUserInfoBaseInfoCell.h
//  LinkCity
//
//  Created by roy on 3/3/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUserModel.h"

@interface LCUserInfoBaseInfoCell : UITableViewCell

@property (nonatomic, strong) LCUserModel *user;


@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *livingPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *slogonLabel;
@property (weak, nonatomic) IBOutlet UILabel *wantToBeLabel;
@property (weak, nonatomic) IBOutlet UILabel *haveBeenLabel;


@property (weak, nonatomic) IBOutlet UIImageView *professionImageView;

@property (weak, nonatomic) IBOutlet UILabel *professionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *professionLabelLeading;

@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomLine;

- (void)updateShowWithUser:(LCUserModel *)user showBottomGap:(BOOL)bottomGap;
+ (CGFloat)getCellHeightForUser:(LCUserModel *)user showBottomGap:(BOOL)bottomGap;
@end

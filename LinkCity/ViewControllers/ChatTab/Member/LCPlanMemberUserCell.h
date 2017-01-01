//
//  LCPlanMemberUserCell.h
//  LinkCity
//
//  Created by roy on 3/17/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUserModel.h"

@interface LCPlanMemberUserCell : UICollectionViewCell
@property (nonatomic, strong) LCUserModel *user;
@property (nonatomic, assign) BOOL isInEditState;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIImageView *kickUserIcon;

+ (CGFloat)getCellHeight;
@end

//
//  GroupUserCollectionCell.h
//  LinkCity
//
//  Created by zzs on 14/11/30.
//  Copyright (c) 2014年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@protocol LCGroupUserCollectionCellDelegate <NSObject>
@required
- (void)goToUserPage:(LCUserInfo *)userInfo;
- (void)kickOffBtnClicked;
- (void)cancelKickOffUser;
- (void)kickOffUserClicked:(LCUserInfo *)userInfo;
@end

@interface LCGroupUserCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet EGOImageButton *avatarButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *kickOffMinusSignBtn;

@property (nonatomic, retain) LCUserInfo *userInfo;
@property (nonatomic, retain) id<LCGroupUserCollectionCellDelegate> delegate;
@end

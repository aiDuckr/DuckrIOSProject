//
//  LCMerchantOrderDetailCell.h
//  LinkCity
//
//  Created by 张宗硕 on 12/25/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCMerchantOrderDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *avatarImageButton;
@property (weak, nonatomic) IBOutlet UILabel *payNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLabel;
@property (weak, nonatomic) IBOutlet UIView *usersListView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userListViewHeightConstraint;

@property (retain, nonatomic) LCUserModel *user;

- (void)updateShowOrderCell:(LCUserModel *)user;
@end

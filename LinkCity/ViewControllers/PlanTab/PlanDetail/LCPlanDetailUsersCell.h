//
//  LCPlanDetailUsersCell.h
//  LinkCity
//
//  Created by 张宗硕 on 12/15/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCPlanDetailUsersCellDelegate;

@interface LCPlanDetailUsersCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userNumLabel;
@property (weak, nonatomic) IBOutlet UIView *usersView;
@property (weak, nonatomic) IBOutlet UIButton *userNumButton;
@property (retain, nonatomic) LCPlanModel *plan;
@property (retain, nonatomic) id<LCPlanDetailUsersCellDelegate> delegate;

- (void)updateShowDetailUsers:(LCPlanModel *)plan;
@end

@protocol LCPlanDetailUsersCellDelegate <NSObject>
- (void)planDetailUsersCellToViewMoreUsersDetail:(LCPlanDetailUsersCell *)cell;
- (void)planDetailUsersCellToViewUserDetail:(LCUserModel *)user;
@end
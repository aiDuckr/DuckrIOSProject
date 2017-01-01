//
//  LCMerchantRefundCell.h
//  LinkCity
//
//  Created by 张宗硕 on 6/14/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCMerchantRefundCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *tilteLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (void)updateShowCell:(LCPlanModel *)plan withUser:(LCUserModel *)user;
@end

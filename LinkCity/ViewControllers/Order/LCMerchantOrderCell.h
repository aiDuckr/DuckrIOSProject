//
//  LCMerchantOrderCell.h
//  LinkCity
//
//  Created by 张宗硕 on 12/25/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCMerchantOrderCellDelegate;

@interface LCMerchantOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *planTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *planStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *startEndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) LCPlanModel *plan;
@property (retain, nonatomic) id<LCMerchantOrderCellDelegate> delegate;

- (void)updateShowMerchantOrder:(LCPlanModel *)plan;

@end

@protocol LCMerchantOrderCellDelegate <NSObject>
- (void)viewPlanDetail:(LCMerchantOrderCell *)cell;
- (void)viewMerchantOrderDetail:(LCMerchantOrderCell *)cell;

@end

//
//  LCMerchantBillCell.h
//  LinkCity
//
//  Created by godhangyu on 16/6/15.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPlanBillModel.h"

@interface LCMerchantBillCell : UITableViewCell

// UI
@property (weak, nonatomic) IBOutlet UILabel *planLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceAndMemberNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatedTimeLabel;


// Data
@property (strong, nonatomic) LCPlanBillModel *planBill;

- (void)updateCellWithPlanBill:(LCPlanBillModel *)planBill;

@end

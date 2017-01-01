//
//  LCBillCell.h
//  LinkCity
//
//  Created by Roy on 6/25/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCBillCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *borderBg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *borderBgBottom;


@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UILabel *inBillLabel;
@property (weak, nonatomic) IBOutlet UILabel *notInBillLabel;
@property (weak, nonatomic) IBOutlet UILabel *planInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentInfoLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@property (nonatomic, strong) LCPlanModel *plan;

- (void)updateShowWithPlan:(LCPlanModel *)plan isLastCell:(BOOL)isLast;
+ (CGFloat)getCellHeight;
@end

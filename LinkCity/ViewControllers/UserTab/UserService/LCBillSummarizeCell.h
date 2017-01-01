//
//  LCBillSummarizeCell.h
//  LinkCity
//
//  Created by Roy on 6/25/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCBillSummarizeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *borderBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *borderBgBottom;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;


- (void)updateShowWithProfitIn:(NSDecimalNumber *)profitIn  isLastCell:(BOOL)isLast;

+ (CGFloat)getCellHeight;


@end

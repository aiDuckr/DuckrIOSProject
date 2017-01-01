//
//  LCPlanDetailChargeIntroCell.h
//  LinkCity
//
//  Created by roy on 2/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPlanDetailBaseCell.h"

@interface LCPlanDetailChargeIntroCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *chargeIntroLabel;

- (void)setChargeIntro:(NSString *)chargeIntro;
+ (CGFloat)getCellHeightForChargeIntro:(NSString *)chargeIntro;
@end

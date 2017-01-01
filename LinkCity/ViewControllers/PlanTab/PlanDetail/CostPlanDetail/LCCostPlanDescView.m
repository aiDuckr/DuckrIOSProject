//
//  LCCostPlanDescView.m
//  LinkCity
//
//  Created by Roy on 12/21/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCCostPlanDescView.h"

@implementation LCCostPlanDescView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCCostPlanDescView class]) bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCCostPlanDescView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            return (LCCostPlanDescView *)v;
        }
    }
    
    return nil;
}

- (void)updateShowWithPlan:(LCPlanModel *)plan{
    self.plan = plan;
    
    //depart and dest label
    self.departAndDestLabel.text = [self.plan getDepartAndDestString];
    
    if (self.plan.daysLong == 0) {
        self.plan.daysLong = 1;
    }
    //time label
    NSString *timeStr = [NSString stringWithFormat:@"%@   全程%ld天",
                         [LCDateUtil getDotDateFromHorizontalLineStr:self.plan.startTime],
                         (long)self.plan.daysLong];
    self.timeLabel.text = timeStr;
    
    self.numLabel.text = [NSString stringWithFormat:@"邀约%ld人",(long)self.plan.scaleMax];
    
    //creater info
    if (self.plan.memberList.count > 0) {
        LCUserModel *creater = [self.plan.memberList objectAtIndex:0];
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:creater.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
        self.nickLabel.text = creater.nick;
    }
    
    self.descLabel.text = [LCStringUtil getNotNullStr:self.plan.descriptionStr];
    
    self.includeLabel.text = [LCStringUtil getNotNullStr:self.plan.costInclude];
    self.excludeLabel.text = [LCStringUtil getNotNullStr:self.plan.costExclude];
    self.refundLabel.text = [LCStringUtil getNotNullStr:[LCDataManager sharedInstance].orderRule.refundDescription];
    
}

- (CGFloat)getHeightForPlan:(LCPlanModel *)plan{
    CGFloat height = 0;
    
    [self updateShowWithPlan:plan];
    self.bounds = CGRectMake(0, 0, DEVICE_WIDTH, 100);
    [self setNeedsLayout];
    [self layoutIfNeeded];
    height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    
    
    return height;
}

@end

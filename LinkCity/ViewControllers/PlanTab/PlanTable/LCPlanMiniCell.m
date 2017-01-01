//
//  LCPlanMiniCell.m
//  LinkCity
//
//  Created by roy on 6/1/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanMiniCell.h"

@implementation LCPlanMiniCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    
    [[LCUIConstants sharedInstance] setViewAsInputBg:self.holderWithBorderView];
    
    self.planImageView.layer.masksToBounds = YES;
    self.planImageView.layer.cornerRadius = 4;
    self.labelMaskView.layer.masksToBounds = YES;
    self.labelMaskView.layer.cornerRadius = 4;
    self.labelMaskView.image = [[UIImage imageNamed:@"BottomMaskImage"] resizableImageWithCapInsets:UIEdgeInsetsMake(34, 5, 1, 5)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setPlan:(LCPlanModel *)plan{
    _plan = plan;
    
    if (plan) {
        [self.planImageView setImageWithURL:[NSURL URLWithString:self.plan.firstPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
        
        if ([self.plan isStagePlan]) {
            if (self.plan.daysLong == 0) {
                self.plan.daysLong = 1;
            }
            self.timeLabel.text = [NSString stringWithFormat:@"多期 玩%ld天",(long)self.plan.daysLong];
        }else{
            NSString *timeStr = [LCDateUtil getDotDateFromHorizontalLineStr:self.plan.startTime];
            self.timeLabel.text = [LCStringUtil getNotNullStr:timeStr];
        }
        
        //路线
        NSString *destinationStr = [self.plan getDestinationsStringWithSeparator:@"-"];
        NSString *routeStr = nil;
        if ([LCStringUtil isNotNullString:self.plan.departName]) {
            routeStr = [NSString stringWithFormat:@"%@-%@",self.plan.departName,destinationStr];
        }else{
            routeStr = [NSString stringWithFormat:@"目的地:%@",destinationStr];
        }
        self.destinationLabel.text = [LCStringUtil getNotNullStr:routeStr];
        
        self.descriptionLabel.text = [LCStringUtil getNotNullStr:self.plan.descriptionStr];
        
        if ([plan getPlanRelation] == LCPlanRelationCreater) {
            self.labelMaskView.hidden = NO;
            self.createrLabel.hidden = NO;
        }else{
            self.labelMaskView.hidden = YES;
            self.createrLabel.hidden = YES;
        }
        
        if ([LCDecimalUtil isOverZero:self.plan.costPrice]) {
            
            self.priceLabel.hidden = NO;
            self.priceLabel.text = [NSString stringWithFormat:@"￥%@/人",plan.costPrice];
        }else{
            self.priceLabel.hidden = YES;
        }
    }
}

+ (CGFloat)getCellHeight{
    return 120;
}

@end

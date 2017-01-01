//
//  LCCostPlanStageCell.m
//  LinkCity
//
//  Created by Roy on 12/21/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCCostPlanStageCell.h"

@implementation LCCostPlanStageCell

- (void)awakeFromNib {
    UIImage *topBgImage = [UIImage imageNamed:@"PlanDetailTicketTop"];
    topBgImage = [topBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(2, 40, 25, 40) resizingMode:UIImageResizingModeStretch];
    self.topBg.image = topBgImage;
    
    UIImage *bottomImage = [UIImage imageNamed:@"PlanDetailTicketBottom"];
    bottomImage = [bottomImage resizableImageWithCapInsets:UIEdgeInsetsMake(6, 40, 10, 40) resizingMode:UIImageResizingModeStretch];
    self.bottomBg.image = bottomImage;
}

- (void)updateShowWithStage:(LCPartnerStageModel *)stage isCreater:(BOOL)isMeCreater{
    self.stage = stage;
    
    self.timeLabel.text = [LCDateUtil getDotDateFromHorizontalLineStr:stage.startTime];
    
    if ([LCDecimalUtil isOverZero:stage.price]) {
        self.priceLabel.text = [NSString stringWithFormat:@"%@",stage.price];
    }else{
        self.priceLabel.text = @"";
    }
    
    NSInteger remainTicket = stage.totalNumber - stage.joinNumber;
    if (remainTicket > 0) {
        // not full
        self.ticketNumLabel.hidden = NO;
        if (remainTicket >= 10) {
            self.ticketNumLabel.text = @"票量充足";
        }else{
            self.ticketNumLabel.text = [NSString stringWithFormat:@"仅剩%ld张",remainTicket];
        }
        
        self.btnLabel.text = @"查看成员";
    }else{
        // full
        self.ticketNumLabel.hidden = YES;
        self.btnLabel.text = @"已报满";
    }
    
    if (isMeCreater) {
        self.btnLabel.text = @"编辑";
    }
}

@end







//
//  LCOrderChooseStageCell.m
//  LinkCity
//
//  Created by Roy on 12/22/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCOrderChooseStageCell.h"

@implementation LCOrderChooseStageCell

- (void)awakeFromNib {
    UIImage *topBgImage = [UIImage imageNamed:@"PlanDetailTicketTop"];
    topBgImage = [topBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(2, 40, 25, 40) resizingMode:UIImageResizingModeStretch];
    self.topBg.image = topBgImage;
    
    UIImage *bottomImage = [UIImage imageNamed:@"PlanDetailTicketBottom"];
    bottomImage = [bottomImage resizableImageWithCapInsets:UIEdgeInsetsMake(6, 40, 10, 40) resizingMode:UIImageResizingModeStretch];
    self.bottomBg.image = bottomImage;
}

- (void)updateShowWithStage:(LCPartnerStageModel *)stage{
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
    }else{
        // full
        self.ticketNumLabel.hidden = YES;
    }
}

@end

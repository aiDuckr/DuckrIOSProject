//
//  LCPlanDetailChargeTitleCell.m
//  LinkCity
//
//  Created by Roy on 6/26/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanDetailChargeTitleCell.h"

@implementation LCPlanDetailChargeTitleCell

- (void)awakeFromNib {
    
    self.borderBgView.layer.borderColor = UIColorFromRGBA(LCCellBorderColor, 1).CGColor;
    self.borderBgView.layer.borderWidth = LCCellBorderWidth;
    self.borderBgView.layer.masksToBounds = YES;
    self.borderBgView.layer.cornerRadius = LCCellCornerRadius;
    
    UIImage *topBgImage = [UIImage imageNamed:LCCellTopBg];
    topBgImage = [topBgImage resizableImageWithCapInsets:LCCellTopBgResizeEdge resizingMode:UIImageResizingModeStretch];
    self.imageBgView.image = topBgImage;
    
    self.borderBgView.hidden = NO;
    self.imageBgView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)animateToFolded:(BOOL)toFolded{
    if (toFolded) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.cellBottom.constant = 5;
            self.borderBgView.hidden = NO;
            self.imageBgView.hidden = YES;
            self.arrowImage.transform = CGAffineTransformMakeRotation(0);
        } completion:nil];
        
    }else{
        
        [UIView animateWithDuration:0.2 animations:^{
            self.cellBottom.constant = 0;
            self.borderBgView.hidden = YES;
            self.imageBgView.hidden = NO;
            self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:nil];
        
    }
}

+ (CGFloat)getCellHeight{
    return 56;
}
@end

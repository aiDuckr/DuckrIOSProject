//
//  LCPlanRouteCellForDay.m
//  LinkCity
//
//  Created by roy on 2/10/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanRouteCellForDay.h"

@implementation LCPlanRouteCellForDay

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setFolded:(BOOL)folded{
    if (folded) {
        self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
    }else{
        self.arrowImageView.transform = CGAffineTransformMakeRotation(-M_PI/2);
    }
}
- (void)animateToFolded{
    [UIView animateWithDuration:0.2 animations:^{
        self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
    } completion:nil];
}
- (void)animateToUnfolded{
    [UIView animateWithDuration:0.2 animations:^{
        self.arrowImageView.transform = CGAffineTransformMakeRotation(-M_PI/2);
    } completion:nil];
}
@end

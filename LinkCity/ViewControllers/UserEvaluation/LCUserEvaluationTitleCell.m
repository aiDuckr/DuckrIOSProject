//
//  LCUserInfoEvaluationTitleCell.m
//  LinkCity
//
//  Created by roy on 3/3/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserEvaluationTitleCell.h"

@implementation LCUserEvaluationTitleCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getCellHeightWithTopSpace:(CGFloat)topSpace{
    return 50 + topSpace;
}

- (void)setUserEvaluationNum:(NSInteger)evaluationNum{
    NSString *titleStr = [NSString stringWithFormat:@"评价（%ld）",(long)evaluationNum];
    self.titleLabel.text = titleStr;
}


@end

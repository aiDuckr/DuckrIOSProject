//
//  LCPlanSubjectPageSubjectCell.m
//  LinkCity
//
//  Created by roy on 2/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserEvaluationTagCell.h"

@implementation LCUserEvaluationTagCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.isSubjectSelected = NO;
    
    self.subjectLabel.layer.borderWidth = 1;
    self.subjectLabel.font = [UIFont fontWithName:FONT_LANTINGBLACK size:14];
    
    //默认未选中
    [self setSubjectSelected:NO];
}

- (void)setSubjectSelected:(BOOL)selected{
    self.isSubjectSelected = selected;
    if (selected) {
        self.subjectLabel.backgroundColor = UIColorFromRGBA(DUCKER_YELLOW, 1);
        self.subjectLabel.layer.borderColor = [UIColor clearColor].CGColor;
        self.subjectLabel.textColor = UIColorFromR_G_B_A(112, 107, 102, 1);
    }else{
        self.subjectLabel.backgroundColor = [UIColor clearColor];
        self.subjectLabel.layer.borderColor = UIColorFromR_G_B_A(232, 228, 221, 1).CGColor;
        self.subjectLabel.textColor = UIColorFromR_G_B_A(168, 164, 160, 1);
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end

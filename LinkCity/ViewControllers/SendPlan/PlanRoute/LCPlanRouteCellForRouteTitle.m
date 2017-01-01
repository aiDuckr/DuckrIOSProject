//
//  LCPlanRouteCellForRouteTitle.m
//  LinkCity
//
//  Created by roy on 3/6/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanRouteCellForRouteTitle.h"

@implementation LCPlanRouteCellForRouteTitle

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleTextField.delegate = self;
    [[LCUIConstants sharedInstance] setViewAsInputBg:self.titleTextFieldHolder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (CGFloat)getCellHeight{
    return 114;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self.titleTextField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(planRouteCellForRouteTitleDidEndEdit:)]) {
        [self.delegate planRouteCellForRouteTitleDidEndEdit:self];
    }
    
    return YES;
}

@end

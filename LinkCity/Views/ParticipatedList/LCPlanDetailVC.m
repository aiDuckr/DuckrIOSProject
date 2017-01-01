//
//  LCPlanDetailVC.m
//  LinkCity
//
//  Created by roy on 12/4/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCPlanDetailVC.h"
#import "LCDateUtil.h"

@interface LCPlanDetailVC ()

@end

@implementation LCPlanDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollType = PlanDetailNotScroll;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSAttributedString *)getTimeLabelAttributedString:(LCPlan *)plan{
    NSInteger days = [LCDateUtil numberOfDaysFromTwoStr:plan.startTime withAnotherStr:plan.endTime];
    
    NSMutableAttributedString *timeText = [[NSMutableAttributedString alloc]initWithString:[LCDateUtil getDotDateFromHorizontalLineStr:plan.startTime] attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_FUTURA size:15]}];
    [timeText appendAttributedString:[[NSAttributedString alloc]initWithString:@" 玩" attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_LANTINGBLACK size:15]}]];
    [timeText appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%tu",days] attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_FUTURA size:15]}]];
    [timeText appendAttributedString:[[NSAttributedString alloc]initWithString:@"天" attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_LANTINGBLACK size:15]}]];
    return timeText;
}

@end

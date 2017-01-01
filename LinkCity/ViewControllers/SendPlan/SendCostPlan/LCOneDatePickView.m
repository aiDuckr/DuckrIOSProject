//
//  LCOneDatePickView.m
//  LinkCity
//
//  Created by Roy on 12/15/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCOneDatePickView.h"

@implementation LCOneDatePickView

+ (instancetype)createInstanceWithVC:(UIViewController *)vc{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCOneDatePickView class]) bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views){
        if ([v isKindOfClass:[LCOneDatePickView class]]) {
            LCOneDatePickView *pickV = (LCOneDatePickView *)v;
            pickV.translatesAutoresizingMaskIntoConstraints = NO;
            pickV.holderVC = vc;
            [pickV updateNextBtnShow];
            return pickV;
        }
    }
    
    return nil;
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT - 200);
}

- (void)awakeFromNib{
    self.calendarHomeVC = [[CalendarHomeViewController alloc] init];
    self.calendarHomeVC.delegate = self;
    [self.calendarHomeVC setAirPlaneToDay:365 ToDateforString:nil];
    
    [self.calendarHomeVC willMoveToParentViewController:self.holderVC];
    self.calendarHomeVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.calHolderView addSubview:self.calendarHomeVC.view];
    [self.calendarHomeVC didMoveToParentViewController:self.holderVC];
    
    UIView *calHolderView = self.calHolderView;
    UIView *calView = self.calendarHomeVC.view;
    [calHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[calView]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(calView)]];
    
    [calHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-66)-[calView]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(calView)]];
    
    if ([LCDataManager sharedInstance].userInfo && [[LCDataManager sharedInstance].userInfo isMerchant]) {
        self.calBottomConstraint.constant = 0.0f;
        self.titleLabel.text = @"查看开始日期";
    } else {
        self.calBottomConstraint.constant = 43.0f;
        self.titleLabel.text = @"选择开始日期";
    }
}

- (void)updateNextBtnShow{
    if (self.calendarHomeVC.Logic.startCalendarDay) {
        //input correct
        [[LCUIConstants sharedInstance] setButtonAsSubmitButtonEnableStyle:self.submitBtn];
    }else{
        //input error
        [[LCUIConstants sharedInstance] setButtonAsSubmitButtonDisableStyle:self.submitBtn];
    }
}

- (void)setStartDate:(NSString *)dateStr{
    [self.calendarHomeVC setAirPlaneToDay:365 ToDateforString:dateStr];
    [self updateNextBtnShow];
}

- (void)calendarHomeVCDidSelectOneDate:(CalendarHomeViewController *)controller{
    NSString *startStr = [controller.Logic.startCalendarDay toString];
    NSString *endStr = [controller.Logic.endCalendarDay toString];
    LCLogInfo(@"Date: %@ - %@",startStr,endStr);
    [self updateNextBtnShow];
}

- (void)chooseDateFinished:(CalendarHomeViewController *)controller{
    LCLogInfo(@"%@",[NSThread callStackSymbols][0]);
}

- (IBAction)submitBtnAction:(id)sender {
    if (!self.calendarHomeVC.Logic.startCalendarDay) {
        [YSAlertUtil tipOneMessage:@"请选择开始日期"];
    }else{
        if ([self.delegate respondsToSelector:@selector(oneDatePickView:didSelectOneDate:)]) {
            [self.delegate oneDatePickView:self didSelectOneDate:[self.calendarHomeVC.Logic.startCalendarDay toString]];
        }
    }
}


@end

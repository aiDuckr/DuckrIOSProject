//
//  LCOneDatePickView.h
//  LinkCity
//
//  Created by Roy on 12/15/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarHomeViewController.h"

@protocol LCOneDatePickViewDelegate;
@interface LCOneDatePickView : UIView<CalendarHomeViewDelegate>
@property (nonatomic, weak) id<LCOneDatePickViewDelegate> delegate;
@property (nonatomic, strong) UIViewController *holderVC;
@property (weak, nonatomic) IBOutlet UIView *calHolderView;
@property (nonatomic, strong) CalendarHomeViewController *calendarHomeVC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calBottomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


+ (instancetype)createInstanceWithVC:(UIViewController *)vc;
- (void)setStartDate:(NSString *)dateStr;
@end



@protocol LCOneDatePickViewDelegate <NSObject>

- (void)oneDatePickView:(LCOneDatePickView *)v didSelectOneDate:(NSString *)dateStr;

@end

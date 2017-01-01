//
//  LCCalendarChooseDateView.m
//  LinkCity
//
//  Created by lhr on 16/5/16.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCCalendarChooseDateView.h"
#import "FSCalendar.h"
#import "UIView+BlocksKit.h"
@interface LCCalendarChooseDateView()<FSCalendarDataSource, FSCalendarDelegate ,UIGestureRecognizerDelegate>

//@property (nonatomic, strong) FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;

@property (weak, nonatomic) IBOutlet UIButton *previousButton;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIView *middleView;

@property (nonatomic,strong) NSDate *selectedDate;

//@property (strong, nonatomic) UIButton *previousButton;
//@property (strong, nonatomic) UIButton *nextButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *previousButtonMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextButtonMargin;

@end

@implementation LCCalendarChooseDateView

+ (LCCalendarChooseDateView *)createInstance {
    UINib *nib = [UINib nibWithNibName:@"LCChooseDateView" bundle:nil];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCCalendarChooseDateView class]]) {
            //v.translatesAutoresizingMaskIntoConstraints = NO;
            LCCalendarChooseDateView *chooseDateView = (LCCalendarChooseDateView *)v;
            return chooseDateView;
        }
    }
    return nil;
}

- (IBAction)dismissButtonAction:(id)sender {
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarChooseDateViewCancel:)]) {
        [self.delegate calendarChooseDateViewCancel:self];
    }
}

- (IBAction)chooseButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedDate:)]) {
        [self.delegate didSelectedDate:self.selectedDate];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedDates:)]) {
        [self.delegate didSelectedDates:self.calendar.selectedDates];
    }
    [self removeFromSuperview];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self loadCalendarView];
    [self.calendar appearance].canSelectBefore = NO;
    //__weak typeof(self) weakSelf = self;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    self.previousButtonMargin.constant = [LCSharedFuncUtil adaptBy6sHeightForAllDevice:72.0f];
    self.nextButtonMargin.constant = [LCSharedFuncUtil adaptBy6sHeightForAllDevice:72.0f];
    
//    [self bk_whenTapped:^{
//        [weakSelf removeFromSuperview];
//    }];
}
- (void)viewTapAction {
    [self removeFromSuperview];
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection {
    _allowsMultipleSelection = allowsMultipleSelection;
    self.calendar.allowsMultipleSelection = allowsMultipleSelection;
}

- (void)setCanSelectedDateBefore:(BOOL)canSelectedDateBefore {
    _canSelectedDateBefore = canSelectedDateBefore;
    [self.calendar appearance].canSelectBefore = canSelectedDateBefore;
}
#pragma mark - Calendar FSCalendarDelegate
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    self.selectedDate = date;
    LCLogInfo(@"did select date %@", [calendar stringFromDate:date format:@"yyyy/MM/dd"]);
    // TODO:yhy
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date {
    LCLogInfo(@"did deselect date %@", [calendar stringFromDate:date format:@"yyyy/MM/dd"]);
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    LCLogInfo(@"%s %@", __FUNCTION__, [calendar stringFromDate:calendar.currentPage]);
}

#pragma mark 点击事件

- (IBAction)previousClicked:(id)sender {
    LCLogInfo(@"previous button clicked!");
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.calendar dateBySubstractingMonths:1 fromDate:currentMonth];
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

- (IBAction)nextClicked:(id)sender {
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.calendar dateByAddingMonths:1 toDate:currentMonth];
    [self.calendar setCurrentPage:nextMonth animated:YES];
    
}

- (void)loadCalendarView {
//    [_calendar selectDate:[NSDate date]];
    [_calendar selectDatearray:[LCDataManager sharedInstance].currentSelectedArray];
//    self.selectedDate = [NSDate date];
    _calendar.dataSource = self;
    _calendar.delegate = self;
    _calendar.appearance.headerMinimumDissolvedAlpha = 0;
    _calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
    
    [_previousButton setImage:[UIImage imageNamed:@"PlanTabCalendarPreviousIcon"] forState:UIControlStateNormal];
    [_previousButton setTitle:nil forState:UIControlStateNormal];
    [_calendar bringSubviewToFront:_previousButton];
    
    
    [_nextButton setImage:[UIImage imageNamed:@"PlanTabCalendarNextIcon"] forState:UIControlStateNormal];
    [_nextButton setTitle:nil forState:UIControlStateNormal];
    [_calendar bringSubviewToFront:_nextButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self];
    return !CGRectContainsPoint(self.middleView.frame, point);
   
}

@end

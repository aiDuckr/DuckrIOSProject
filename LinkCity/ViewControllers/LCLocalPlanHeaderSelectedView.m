//
//  LCLocalPlanHeaderSelectedView.m
//  LinkCity
//
//  Created by whb on 16/8/5.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCLocalPlanHeaderSelectedView.h"


@interface LCLocalPlanHeaderSelectedView ()<LCCalendarChooseDateViewDelegate,LCFilterTagButtonDelegate>
@property (strong, nonatomic) NSArray *timeButtonArr;
@property (strong, nonatomic) NSArray *priceButtonArr;
@property (strong, nonatomic) NSArray *orderButtonArr;
@property (strong, nonatomic) NSMutableArray *timeBtnArry;//今天、明天、本周末三个按钮状态

@property (strong, nonatomic) NSArray *dateArr;
@property (strong, nonatomic) NSArray *priceArr;
@property (assign, nonatomic) LCPlanOrderType orderType;
@end

@implementation LCLocalPlanHeaderSelectedView
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.dateArr = [[NSArray alloc] init];
    self.priceArr =[[NSArray alloc] init];
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    [mutArr addObject:self.timeTodayButton];
    [mutArr addObject:self.timeTomorrowButton];
    [mutArr addObject:self.timeWeekButton];
    [mutArr addObject:self.timeDatesButton];
    self.timeButtonArr = mutArr;
    for (LCFilterTagButton *btn in self.timeButtonArr) {
        btn.delegate = self;
        btn.type = FilterTagButtonType_Default;
        btn.appearance = FilterTagButtonAppearance_SearchGray;
    }
    
    mutArr = [[NSMutableArray alloc] init];
    [mutArr addObject:self.priceFreeButton];
    [mutArr addObject:self.priceOneButton];
    [mutArr addObject:self.priceTwoButton];
    [mutArr addObject:self.priceThreeButton];
    [mutArr addObject:self.priceFourButton];
    self.priceButtonArr = mutArr;
    for (LCFilterTagButton *btn in self.priceButtonArr) {
        btn.delegate = self;
        btn.type = FilterTagButtonType_Default;
        btn.appearance = FilterTagButtonAppearance_SearchGray;
    }
}

+ (instancetype)createInstance {
    UINib *nib = [UINib nibWithNibName:@"LCLocalPlanHeaderSelectedView" bundle:nil];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCLocalPlanHeaderSelectedView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = YES;
            return (LCLocalPlanHeaderSelectedView *)v;
        }
    }
    return nil;
}

#pragma mark - LCCalendarChooseDateView Delegate.
- (void)didSelectedDates:(NSArray *)dates {
    /// 日历上选择了日期，取消选择其他的明天，本周，本月的选中状态.
    if (nil != dates && dates.count > 0) {
        for (LCFilterTagButton *btn in self.timeButtonArr) {
            if (btn != self.timeDatesButton) {
                [btn updateFilterTagButtonApperance:NO];
            } else {
                [self.timeDatesButton updateFilterTagButtonApperance:YES];
            }
        }
    }
    
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    for (NSDate *date in dates) {
        NSString *dateStr = [LCDateUtil stringFromDate:date];
        [mutArr addObject:dateStr];
    }
    self.dateArr = mutArr;
    
    if (self.dateArr.count > 0) {
        //更新
    }
}

- (void)calendarChooseDateViewCancel:(LCCalendarChooseDateView *)view {
    
}

#pragma mark - LCFilterTagButton Delegate.
- (void)filterTagButtonSelected:(LCFilterTagButton *)button {
    if (NSNotFound != [self.timeButtonArr indexOfObject:button]) {
        [button updateShowButtons:self.timeButtonArr];
        if (button == self.timeDatesButton) {
            [[LCPopViewHelper sharedInstance] popDateSelectedView:self];
        }
    }
    if (NSNotFound != [self.orderButtonArr indexOfObject:button]) {
        [button updateShowButtons:self.orderButtonArr];
    }

    if (NSNotFound != [self.priceButtonArr indexOfObject:button]) {
        [button updateShowButtons:self.priceButtonArr];
    }
    if (button != self.timeDatesButton) {//若不点击日历按钮则使用代理请求数据
        [self updateRequestVariable];
    }
}

- (void)filterTagButtonUnSelected:(LCFilterTagButton *)button {
    if (button != self.timeDatesButton) {
        [self updateRequestVariable];
    }
}

/// 根据视图填的内容获取相应的请求Server的变量数据.
- (void)updateRequestVariable {
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    self.timeBtnArry=[NSMutableArray arrayWithObjects:@"0",@"0",@"0", nil];

    /// 选择的今天的时间.
    if (YES == self.timeTodayButton.selected) {
        [self.timeBtnArry replaceObjectAtIndex:0 withObject:@"1"];
        NSArray *dayArr = [LCDateUtil getTodayDateStrs];
        for (NSString *str in dayArr) {
                [mutArr addObject:str];
        }
    }
    /// 选择的明天的时间.
    if (YES == self.timeTomorrowButton.selected) {
        [self.timeBtnArry replaceObjectAtIndex:1 withObject:@"1"];
        NSArray *dayArr = [LCDateUtil getTomorrowDateStrs];
        for (NSString *str in dayArr) {
                [mutArr addObject:str];
        }
    }
    /// 选择的本周的时间.
    if (YES == self.timeWeekButton.selected) {
        [self.timeBtnArry replaceObjectAtIndex:2 withObject:@"1"];
        NSArray *dayArr = [LCDateUtil getWeekDateStrs];
        for (NSString *str in dayArr) {
            if (NSNotFound == [mutArr indexOfObject:str]) {
                [mutArr addObject:str];
            }
        }
    }
    self.dateArr = mutArr;
    
    /// 选择的价格.
    mutArr = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < self.priceButtonArr.count; ++index) {
        LCFilterTagButton *btn = (LCFilterTagButton *)[self.priceButtonArr objectAtIndex:index];
        if (YES == btn.selected) {
            [mutArr addObject:[NSString stringWithFormat:@"%zd", btn.tag]];
        }
    }
    self.priceArr = mutArr;

    /// 选择的排序方式.
    self.orderType = LCPlanOrderType_Default;
    for (NSInteger index = 0; index < self.orderButtonArr.count; ++index) {
        LCFilterTagButton *btn = (LCFilterTagButton *)[self.orderButtonArr objectAtIndex:index];
        if (YES == btn.selected) {
            self.orderType = btn.tag;
        }
    }
    if ([self.delegate respondsToSelector:@selector(openLocalSelectedTheme:priceArray:orderType:timeBtnArry:)]) {
        [self.delegate openLocalSelectedTheme:self.dateArr priceArray:self.priceArr orderType:self.orderType timeBtnArry:self.timeBtnArry];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

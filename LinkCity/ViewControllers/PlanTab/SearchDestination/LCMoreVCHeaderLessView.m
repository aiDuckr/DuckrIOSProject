//
//  LCLocalClosePlanView.m
//  LinkCity
//
//  Created by whb on 16/8/6.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCMoreVCHeaderLessView.h"
@interface LCMoreVCHeaderLessView ()<LCFilterTagButtonDelegate>
@property (strong, nonatomic) NSArray *timeButtonArr;
@property (strong, nonatomic) NSArray *dateArr;
@property (strong, nonatomic) NSMutableArray *timeBtnArry;//今天、明天、本周末三个按钮状态


@end

@implementation LCMoreVCHeaderLessView
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.openBtn.delegate = self;
    self.openBtn.type = FilterTagButtonType_Default;
    self.openBtn.appearance = FilterTagButtonAppearance_SearchWhite;

    for (LCFilterTagButton *btn in self.timeButtonArr) {
        btn.delegate = self;
        btn.type = FilterTagButtonType_Default;
    }
    self.dateArr=[[NSArray alloc] init];
}

- (NSArray *)timeBtnArry {
    if (nil == _timeButtonArr) {
        _timeBtnArry=[NSMutableArray arrayWithObjects:@"0",@"0",@"0", nil];
    }
    return _timeBtnArry;
}

- (NSArray *)timeButtonArr {
    if (nil == _timeButtonArr) {
        NSMutableArray *mutArr = [[NSMutableArray alloc] init];
        [mutArr addObject:self.timeTodayButton];
        [mutArr addObject:self.timeTomorrowButton];
        [mutArr addObject:self.timeWeekButton];
        _timeButtonArr = mutArr;
    }
    return _timeButtonArr;
}

+ (instancetype)createInstance {
    UINib *nib = [UINib nibWithNibName:@"LCMoreVCHeaderLessView" bundle:nil];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCMoreVCHeaderLessView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = YES;
            return (LCMoreVCHeaderLessView *)v;
        }
    }
    return nil;
}

#pragma mark - LCFilterTagButton Delegate.
- (void)filterTagButtonSelected:(LCFilterTagButton *)button {
    if(button == self.openBtn){
        //展开
        [self.openBtn updateFilterTagButtonApperance:NO];//不需要吧？点三个点需要更新样式么？？
        if ([self.delegate respondsToSelector:@selector(sendStateToVCWithHeaderOpened:dateArray:timeBtnArry:)]) {
            [self.delegate sendStateToVCWithHeaderOpened:YES dateArray:self.dateArr timeBtnArry:self.timeBtnArry];//传送状态，header展开，并传当前选择时间
        }
    } else if (NSNotFound != [self.timeButtonArr indexOfObject:button]) {
        [button updateShowButtons:self.timeButtonArr];//更新按钮状态
        [self updateRequestVariable];//更新数据
    }
}

- (void)filterTagButtonUnSelected:(LCFilterTagButton *)button {
    if (button != self.openBtn) {
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
    if ([self.delegate respondsToSelector:@selector(sendStateToVCWithHeaderOpened:dateArray:timeBtnArry:)]) {
        [self.delegate sendStateToVCWithHeaderOpened:NO dateArray:self.dateArr timeBtnArry:self.timeBtnArry];//传送状态，header非展开，并传当前选择时间
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

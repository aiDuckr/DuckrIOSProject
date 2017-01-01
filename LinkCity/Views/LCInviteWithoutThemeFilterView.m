//
//  LCInviteFilterView.m
//  LinkCity
//
//  Created by 张宗硕 on 8/1/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCInviteWithoutThemeFilterView.h"
#import "LCFilterTagButtonCell.h"

@interface LCInviteWithoutThemeFilterView()<LCFilterTagButtonDelegate>
@property (strong, nonatomic) NSArray *sexButtonArr;
@property (strong, nonatomic) NSArray *orderButtonArr;
@property (assign, nonatomic) UserSex filterSex;
@property (assign, nonatomic) LCPlanOrderType filterOrderType;


@end

@implementation LCInviteWithoutThemeFilterView

+ (instancetype)createInstance {
    UINib *nib = [UINib nibWithNibName:@"LCInviteWithoutThemeFilterView" bundle:nil];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCInviteWithoutThemeFilterView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            return (LCInviteWithoutThemeFilterView *)v;
        }
    }
    return nil;
}

- (void)awakeFromNib {
    for (LCFilterTagButton *btn in self.sexButtonArr) {
        btn.delegate = self;
        btn.type = FilterTagButtonType_Radio;
    }
    for (LCFilterTagButton *btn in self.orderButtonArr) {
        btn.delegate = self;
        btn.type = FilterTagButtonType_Radio;
    }
    [self.sexDefaultButton updateFilterTagButtonStatus:YES];
    [self.orderDefaultButton updateFilterTagButtonStatus:YES];
    
    LCRouteThemeModel *allTheme = [[LCRouteThemeModel alloc] init];
    allTheme.title = @"全部";
    allTheme.tourThemeId = 0;
    
    [self intrinsicContentSize];
    
    self.filterOrderType = 0;
    self.filterSex = UserSex_Male;
    
    self.sexDefaultButton.tag = UserSex_Default;
    self.sexMaleButton.tag = UserSex_Male;
    self.sexFemaleButton.tag = UserSex_Female;
    
    self.orderDefaultButton.tag = LCPlanOrderType_Default;
    self.orderDistanceButton.tag = LCPlanOrderType_Distance;
    self.orderCreatedTimeButton.tag = LCPlanOrderType_CreateTime;
    self.orderDepartTimeButton.tag = LCPlanOrderType_DepartTime;
}

- (NSArray *)sexButtonArr {
    if (nil == _sexButtonArr) {
        NSMutableArray *mutArr = [[NSMutableArray alloc] init];
        [mutArr addObject:self.sexDefaultButton];
        [mutArr addObject:self.sexMaleButton];
        [mutArr addObject:self.sexFemaleButton];
        _sexButtonArr = mutArr;
    }
    return _sexButtonArr;
}

- (NSArray *)orderButtonArr {
    if (nil == _orderButtonArr) {
        NSMutableArray *mutArr = [[NSMutableArray alloc] init];
        [mutArr addObject:self.orderDefaultButton];//热度
        [mutArr addObject:self.orderCreatedTimeButton];//最近出发
        [mutArr addObject:self.orderDistanceButton];//距离排序
        [mutArr addObject:self.orderDepartTimeButton];//时间排序
        _orderButtonArr = mutArr;
    }
    return _orderButtonArr;
}

- (void)inviteDidFitler {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inviteFilterViewDidFilter:userSex:filtType:)]) {
        self.filterSex = UserSex_Default;
        for (LCFilterTagButton *btn in self.sexButtonArr) {
            if (btn.selected) {
                self.filterSex = btn.tag;
                break ;
            }
        }
        self.filterOrderType = LCPlanOrderType_Default;
        for (LCFilterTagButton *btn in self.orderButtonArr) {
            if (btn.selected) {
                self.filterOrderType = btn.tag;
                break ;
            }
        }
        [self.delegate inviteFilterViewDidFilter:self userSex:self.filterSex filtType:self.filterOrderType];
    }
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(DEVICE_WIDTH, 136.0f);
}

#pragma mark - LCFilterTagButton Delegate.
- (void)filterTagButtonSelected:(LCFilterTagButton *)button {
    if (NSNotFound != [self.sexButtonArr indexOfObject:button]) {
        [button updateShowButtons:self.sexButtonArr];
    }
    if (NSNotFound != [self.orderButtonArr indexOfObject:button]) {
        [button updateShowButtons:self.orderButtonArr];
    }
    [self inviteDidFitler];
}
@end

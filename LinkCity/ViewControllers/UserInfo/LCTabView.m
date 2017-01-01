//
//  LCUserInfoVCTabView.m
//  LinkCity
//
//  Created by roy on 3/2/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCTabView.h"

#define AnimationTime (0.1)
@interface LCTabView()
@property (nonatomic, strong) NSMutableArray *badgeViews;
@property (nonatomic, strong) NSMutableArray *verticalLines;
@property (nonatomic, strong) UIImageView *markView;
@end

@implementation LCTabView

+ (instancetype)createInstance {
    LCTabView *tabView = [[LCTabView alloc] initWithFrame:CGRectZero];
    tabView.backgroundColor = [UIColor whiteColor];
    tabView.highlightButtonTitleColor = LCTabViewHightLightButtonTitleColor;
    tabView.defaultButtonTitleColor = LCTabViewDefaultButtonTitleColor;
    return tabView;
}

- (void)updateButtons:(NSArray *)buttonTitles withMargin:(NSInteger)margin {
    self.margin = margin;
    _buttonTitles = buttonTitles;
    
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    if (_buttonTitles.count <= 0) {
        return;
    }
    
    CGFloat btnWidth = (self.frame.size.width - 2 * margin) / _buttonTitles.count;
    self.buttons = [[NSMutableArray alloc] initWithCapacity:_buttonTitles.count];
    self.badgeViews = [[NSMutableArray alloc] initWithCapacity:_buttonTitles.count];
    self.verticalLines = [[NSMutableArray alloc] init];
    [_buttonTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *title = (NSString *)obj;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(margin + btnWidth * idx, 0, btnWidth, self.frame.size.height)];
        [btn setTitle:title forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"ButtonHighlightBg"] forState:UIControlStateHighlighted];
        [btn setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont fontWithName:FONT_LANTINGBLACK size:15];
        [_buttons addObject:btn];
        [self addSubview:btn];
        
        if (idx != 0) {
            //button 中间的竖直分隔线
            CGFloat lineHeight = 18;
            UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height-lineHeight)/2, 0.5, lineHeight)];
            verticalLine.backgroundColor = UIColorFromR_G_B_A(255, 255, 255, 0.4);
            [btn addSubview:verticalLine];
            verticalLine.hidden = YES;
            [_verticalLines addObject:verticalLine];
        }
        CGSize fontSize = [title sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}];
        UIImageView *badgeView = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.size.width/2.0+fontSize.width/2.0+2,
                                                                               (btn.frame.size.height-LCTabBarBadgeSize)/2.0,
                                                                               LCTabBarBadgeSize,
                                                                               LCTabBarBadgeSize)];
        badgeView.image = [UIImage imageNamed:@"TabBarMarkLine"];
        badgeView.backgroundColor = [UIColor clearColor];
        badgeView.hidden = YES;
        [_badgeViews addObject:badgeView];
        [btn addSubview:badgeView];
    }];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5)];
    bottomLine.backgroundColor = DefaultSpalineColor;
    [self addSubview:bottomLine];
    
    self.markView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height-3, LCTabBarMarkWidth, LCTabBarMarkHeight)];
    self.markView.layer.masksToBounds = YES;
    self.markView.contentMode = UIViewContentModeScaleToFill;
    self.markView.image = [UIImage imageNamed:LCTabBarMarkImageName];
    [self addSubview:self.markView];
    
    [self updateShow];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    
    [self updateShow];
}

- (void)setDefaultButtonTitleColor:(UIColor *)defaultButtonTitleColor {
    _defaultButtonTitleColor = defaultButtonTitleColor;
    [self updateShow];
}

- (void)setHighlightButtonTitleColor:(UIColor *)highlightButtonTitleColor {
    _highlightButtonTitleColor = highlightButtonTitleColor;
    [self updateShow];
}

- (void)setBadgeHiden:(BOOL)hiden atIndex:(NSInteger)index {
    if (index < self.badgeViews.count) {
        UIView *badgeView = [self.badgeViews objectAtIndex:index];
        badgeView.hidden = hiden;
    }
}

- (void)setVerticalLineHiden:(BOOL)hiden{
    for (UIView *aVerticalLine in self.verticalLines){
        aVerticalLine.hidden = hiden;
    }
}

- (void)updateShow {
    [UIView animateWithDuration:AnimationTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGFloat btnWidth = (self.frame.size.width - 2 * self.margin) / _buttonTitles.count;
        CGRect markViewFrame = self.markView.frame;
        markViewFrame.origin.x = self.margin + self.selectIndex * btnWidth + (btnWidth - LCTabBarMarkWidth) / 2.0f;
        self.markView.frame = markViewFrame;
    } completion:nil];
    
    [self.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = (UIButton *)obj;
        
        [UIView transitionWithView:btn duration:AnimationTime options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut animations:^{
            if (idx == self.selectIndex) {
                [btn setTitleColor:self.highlightButtonTitleColor forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont fontWithName:FONT_LANTINGBLACK size:17.0f];
            } else {
                [btn setTitleColor:self.defaultButtonTitleColor forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont fontWithName:FONT_LANTINGBLACK size:15.0f];
            }
        } completion:nil];
    }];
}

- (void)buttonAction:(UIButton *)sender {
    [self.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = (UIButton *)obj;
        if (btn == sender) {
            self.selectIndex = idx;
            if ([self.delegate respondsToSelector:@selector(tabView:didSelectIndex:)]) {
                [self.delegate tabView:self didSelectIndex:idx];
            }
        }
    }];
}

@end

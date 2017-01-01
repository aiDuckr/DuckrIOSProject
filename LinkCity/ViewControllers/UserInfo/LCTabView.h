//
//  LCUserInfoVCTabView.h
//  LinkCity
//
//  Created by roy on 3/2/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LCTabViewHightLightButtonTitleColor UIColorFromRGBA(LCDarkTextColor, 1)
#define LCTabViewDefaultButtonTitleColor UIColorFromRGBA(LCLightTextColor, 1)

@protocol LCTabViewDelegate;
@interface LCTabView : UIView

@property (nonatomic, weak) id<LCTabViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSArray *buttonTitles;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) NSInteger margin;

@property (nonatomic, strong) UIColor *defaultButtonTitleColor;
@property (nonatomic, strong) UIColor *highlightButtonTitleColor;


+ (instancetype)createInstance;
- (void)setBadgeHiden:(BOOL)hiden atIndex:(NSInteger)index;
- (void)setVerticalLineHiden:(BOOL)hiden;
- (void)setSelectIndex:(NSInteger)selectIndex;
- (void)updateButtons:(NSArray *)buttonTitles withMargin:(NSInteger)margin;
@end


@protocol LCTabViewDelegate <NSObject>
@optional
- (void)tabView:(LCTabView *)tabView didSelectIndex:(NSInteger)index;

@end
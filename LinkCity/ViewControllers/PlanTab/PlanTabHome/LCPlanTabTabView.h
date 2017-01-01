//
//  LCPlanTabTabView.h
//  LinkCity
//
//  Created by Roy on 12/9/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCPlanTabTabViewDelegate;
@interface LCPlanTabTabView : UIView
@property (nonatomic, weak) id<LCPlanTabTabViewDelegate> delegate;

@property (nonatomic, assign) NSInteger selectedThemeIndex;
@property (nonatomic, strong) NSMutableArray *selectedSortIndexArray;   //array of NSNumber

+ (instancetype)createInstance;
- (void)updateShowWithThemes:(NSArray *)themes;

- (void)setThemeIndex:(NSInteger)themeIndex asSelectedWithAnimation:(BOOL)animate;
- (void)setSortIndex:(NSInteger)sortIndex asSelectedWithAnimation:(BOOL)animate;
- (void)setSortViewHiden:(BOOL)hiden withAnimation:(BOOL)animate;
@end


@protocol LCPlanTabTabViewDelegate <NSObject>
- (void)planTabTabView:(LCPlanTabTabView *)tabView didSelectThemeIndex:(NSInteger)themeIndex;
- (void)planTabTabView:(LCPlanTabTabView *)tabView didSelectSortIndex:(NSInteger)sortIndex;

@end

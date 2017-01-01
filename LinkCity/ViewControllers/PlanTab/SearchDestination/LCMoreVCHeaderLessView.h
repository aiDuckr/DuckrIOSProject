//
//  LCLocalClosePlanView.h
//  LinkCity
//
//  Created by whb on 16/8/6.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFilterTagButton.h"

@protocol LCMoreVCHeaderLessViewDelegate;

@interface LCMoreVCHeaderLessView : UIView
@property (nonatomic, weak) id<LCMoreVCHeaderLessViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *timeTodayButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *timeTomorrowButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *timeWeekButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *openBtn;

+ (instancetype)createInstance;
@end

@protocol LCMoreVCHeaderLessViewDelegate <NSObject>
- (void)sendStateToVCWithHeaderOpened:(BOOL)isOpen dateArray:(NSArray*)dateArry timeBtnArry:(NSMutableArray*)timeBtnArry;
@end
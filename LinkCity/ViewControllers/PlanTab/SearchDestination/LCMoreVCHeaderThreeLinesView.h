//
//  LCLocalPlanHeaderSelectedView.h
//  LinkCity
//
//  Created by whb on 16/8/5.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCalendarChooseDateView.h"
#import "LCFilterTagButton.h"

@protocol LCMoreVCHeaderThreeLinesViewDelegate;

@interface LCMoreVCHeaderThreeLinesView : UIView

@property (nonatomic, weak) id<LCMoreVCHeaderThreeLinesViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;

@property (weak, nonatomic) IBOutlet LCFilterTagButton *timeTodayButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *timeTomorrowButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *timeWeekButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *timeDatesButton;

@property (weak, nonatomic) IBOutlet LCFilterTagButton *orderHotButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *orderDistanceButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *orderCreatedTimeButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *orderPriceButton;

@property (weak, nonatomic) IBOutlet LCFilterTagButton *priceFreeButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *priceOneButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *priceTwoButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *priceThreeButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *priceFourButton;

+ (instancetype)createInstance;

@end

@protocol LCMoreVCHeaderThreeLinesViewDelegate <NSObject>
- (void)sendStateToVCFromThreeLinesViewWithDateArray:(NSArray*)dateArry priceArray:(NSArray*)priceArray orderType:(NSInteger)orderType timeBtnArry:(NSMutableArray*)timeBtnArry;//open状态下选择
@end
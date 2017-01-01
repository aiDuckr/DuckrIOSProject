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

@protocol LCLocalPlanHeaderSelectedViewDelegate;

@interface LCLocalPlanHeaderSelectedView : UIView

@property (nonatomic, weak) id<LCLocalPlanHeaderSelectedViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *headerView;

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

@protocol LCLocalPlanHeaderSelectedViewDelegate <NSObject>
- (void)openLocalSelectedTheme:(NSArray*)dateArry priceArray:(NSArray*)priceArray orderType:(NSInteger)orderType timeBtnArry:(NSMutableArray*)timeBtnArry;//open状态下选择
@end
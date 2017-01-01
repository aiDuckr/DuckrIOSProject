//
//  LCPlanSecondaryThemePickView.h
//  LinkCity
//
//  Created by Roy on 12/12/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCPlanSecondaryThemePickViewDelegate;
@interface LCPlanSecondaryThemePickView : UIView
@property (nonatomic, strong) NSArray *themeArray; //array of LCRouteThemeModel

@property (weak, nonatomic) IBOutlet UIButton *themeBtnA;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnB;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnC;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnD;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnE;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnF;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnG;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnH;
@property (nonatomic, strong) NSArray *themeBtnArray;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;



@property (nonatomic, weak) id<LCPlanSecondaryThemePickViewDelegate> delegate;

+ (instancetype)createInstance;
@end


@protocol LCPlanSecondaryThemePickViewDelegate <NSObject>
@optional
- (void)planSecondaryThemePickViewDidBack:(LCPlanSecondaryThemePickView *)view;
- (void)planSecondaryThemePickView:(LCPlanSecondaryThemePickView *)view didSelectTheme:(LCRouteThemeModel *)theme;

@end
//
//  LCPlanMainThemePickView.h
//  LinkCity
//
//  Created by Roy on 12/12/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,mainThemePickItem) {
    mainThemePickItemSendPlan = 0,
    //mainThemePickItemSameCitySendPlan = 1,
    //mainThemePickItemCarSharing = 2,
    mainThemePickItemSendTourPic = 1,
    mainThemePickItemSendVideo = 2,
    
    
};

@protocol LCPlanMainThemePickViewDelegate;
@interface LCPlanMainThemePickView : UIView
@property (nonatomic, strong) NSArray *themeArray; //array of LCRouteThemeModel
@property (weak, nonatomic) IBOutlet UIView *MainView;

@property (weak, nonatomic) IBOutlet UIButton *themeBtnA;
//@property (weak, nonatomic) IBOutlet UIButton *themeBtnB;
//@property (weak, nonatomic) IBOutlet UIButton *themeBtnC;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnD;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnE;
@property (nonatomic, strong) NSArray *themeBtnArray;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewA;
//@property (weak, nonatomic) IBOutlet UIImageView *imgViewB;
//@property (weak, nonatomic) IBOutlet UIImageView *imgViewC;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewD;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewE;
@property (nonatomic, strong) NSArray *imgViewArray;

@property (weak, nonatomic) IBOutlet UILabel *nameLabelA;
//@property (weak, nonatomic) IBOutlet UILabel *nameLabelB;
//@property (weak, nonatomic) IBOutlet UILabel *nameLabelC;
@property (weak, nonatomic) IBOutlet UILabel *nameLabelD;
@property (weak, nonatomic) IBOutlet UILabel *nameLabelE;
@property (nonatomic, strong) NSArray *nameLabelArray;

@property (weak, nonatomic) IBOutlet UIButton *dismissButton;


@property (nonatomic, weak) id<LCPlanMainThemePickViewDelegate> delegate;

+ (instancetype)createInstance;
- (void)pushPlusAnimation;
@end


@protocol LCPlanMainThemePickViewDelegate <NSObject>
@optional
- (void)planMainThemePickView:(LCPlanMainThemePickView *)view didSelectTheme:(mainThemePickItem)item;   //(LCRouteThemeModel *)theme;

- (void)shouldDismissThemePickView;

@end
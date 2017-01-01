//
//  LCUIConstants.m
//  LinkCity
//
//  Created by roy on 2/15/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUIConstants.h"



NSString *const LCDefaultAvatarImageName = @"DefaultAvatar";
NSString *const LCDefaultUploadImageName = @"DefaultUploadImage";
NSString *const LCDefaultUploadImageWhiteBg = @"DefultUploadImageWhiteBg";
NSString *const LCDefaultImageName = @"DefaultImage";
NSString *const LCDefaultPlaceImageName = @"DefaultPlaceImage";
NSString *const LCDefaultTourpicImageName = @"DefaultTourpic";

NSString *const LCCellTopBg = @"CardTop";
NSString *const LCCellBottomBg = @"CardBottom";
NSString *const LCPlanCellTopBg = @"PlanCellTopBg";
NSString *const LCPlanCellBottomBg = @"PlanCellBottomBg";

NSString *const LCSexMaleImageName = @"UserSexMale";
NSString *const LCSexFemaleImageName = @"UserSexFemale";

NSString *const LCNavBarBackBarButtonImageName = @"NavigationBarBackBtn";


#pragma Font
/// 兰亭黑字体.
NSString *const LCFontLANTINGBLACK = @"FZLanTingHeiS-R-GB";
/// 系统英文字体.
NSString *const LCFontFUTURA = @"Futura";
/// 平方中文
NSString *const LCFontPINGFANG = @"PingFangSC-Regular";



@implementation LCUIConstants

+ (instancetype)sharedInstance{
    static LCUIConstants *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LCUIConstants alloc] init];
    });
    return instance;
}

- (UIImage *)navBarOpaqueImage{
    if (!_navBarOpaqueImage) {
        _navBarOpaqueImage = [[[UIImage imageNamed:@"White"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    }
    return _navBarOpaqueImage;
}
- (UIImage *)navBarTranslucentImage{
    if (!_navBarTranslucentImage) {
        _navBarTranslucentImage = [[[UIImage imageNamed:@"UserInfoNavBarBg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    }
    return _navBarTranslucentImage;
}

- (void)setButtonAsSubmitButtonEnableStyle:(UIButton *)btn{
    btn.backgroundColor = UIColorFromRGBA(0xfee100, 1);
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    [btn setTitleColor:UIColorFromRGBA(0x6b450a, 1) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:FONT_LANTINGBLACK size:19];
    [btn setBackgroundImage:[UIImage imageNamed:@"ButtonHighlightBg"] forState:UIControlStateHighlighted];
}
- (void)setButtonAsSubmitButtonDisableStyle:(UIButton *)btn{
    btn.backgroundColor = UIColorFromRGBA(0xd9d5d1, 1);
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    [btn setTitleColor:UIColorFromRGBA(0xffffff, 1) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:FONT_LANTINGBLACK size:19];
    [btn setBackgroundImage:[UIImage imageNamed:@"ButtonHighlightBg"] forState:UIControlStateHighlighted];
}

- (void)setViewAsInputBg:(UIView *)view{
    view.layer.cornerRadius = 4;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 1;
    view.layer.borderColor = DefaultSpalineColor.CGColor;
}


#pragma mark SystemMessage
+ (NSString *)getJoinPlanMessageWithUserNick:(NSString *)userNick{
    return [NSString stringWithFormat:@"%@加入了群聊",userNick];
}
+ (NSString *)getAgreeApplyPlanMessageWithManagerNick:(NSString *)managerNick applicant:(NSString *)applicantNick{
    return [NSString stringWithFormat:@"%@允许%@加入群聊",managerNick , applicantNick];
}
//+ (NSString *)getQuitPlanMessageWithUserNick:(NSString *)userNick{
//    return [NSString stringWithFormat:@"%@退出了群聊",userNick];
//}
+ (NSString *)getKickOffUserFromPlanMessageWithUserNick:(NSString *)userNick{
    return [NSString stringWithFormat:@"%@被移出了群聊",userNick];
}


#pragma mark UIFont For Navigation
+ (NSDictionary *)getBarButtonItemFontDic{
    return @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0],
             NSForegroundColorAttributeName: [UIColor whiteColor]};
    
}

+ (UIFont *)getPingFangFont:(CGFloat)size{
    UIFont *res = [UIFont fontWithName:FONT_PINGFANG size:size];
    if (!res) {
        res = [UIFont fontWithName:FONT_LANTINGBLACK size:size];
    }
    return res;
}



@end

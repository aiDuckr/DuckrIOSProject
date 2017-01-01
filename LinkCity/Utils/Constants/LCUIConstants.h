//
//  LCUIConstants.h
//  LinkCity
//
//  Created by roy on 2/15/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LCCellTopBgResizeEdge   UIEdgeInsetsMake(20, 100, 20, 100)
#define LCCellBottomBgResizeEdge UIEdgeInsetsMake(20, 100, 20, 100)

#define LCDarkTextColor 0xad7f2d
#define LCLightTextColor 0x2c2a28

#define LCButtonEnableBgColor 0xB6D827
#define LCButtonDisableBgColor 0xE8E4DD
#define LCButtonBorderColor 0x706B66
#define LCButtonHighLightBgImageName @"ButtonHighlightBg"

#define LCThemeBtnHighlightBg 0xffe100
#define LCThemeBtnNormalBg 0xffffff
#define LCFilterBtnNormalBg 0xf6f5f3

#define LCViewBackGroundColor 0xF7F5F3
#define LCBottomLineColor 0xE8E4DD

#define LCSearchBarBgColor 0xDFDBD3
#define LCSearchBarHeight 44

#define LCNumKeyboardHeight 216
#define LCTextKeyboardHeight 250

#define LCAlertViewMaskAlpha 0.7
#define LCPopViewShadowAlpha 0.6

#define LCTabBarMarkImageName @"TabBarMarkLine"
#define LCTabBarMarkWidth 46
#define LCTabBarMarkHeight 3
#define LCTabBarBadgeSize 4

#define LCTextFieldLineSpace 9
#define LCTextFieldLineSpace_V_3_3 (4)

#define LCQuitPlanButtonTitle @"退出"
#define LCJoinPlanButtonTitle @"立即加入"
#define LCApplyPlanButtonTitle @"申请加入"
#define LCDeletePlanButtonTitle @"删除并退出"
#define LCApplyingPlanButtonTitle @"正在申请中"

#define LCQuitPlanAlertConfirmBtnTitle @"退出"
#define LCQuitPlanAlertCancelBtnTitle @"取消"
#define LCQuitPlanAlertMsg @"您真的要退出邀约吗?"
#define LCDeletePlanAlertConfirmBtnTitle @"删除"
#define LCDeletePlanAlertCancelBtnTitle @"取消"
#define LCDeletePlanAlertMsg @"您真的要退出并删除邀约吗?"

#define LCInnerCellSeparatorLineLead 15
#define LCBottomCellSeparatorLineLead 0

#define LCFooterRefreshEmptyTip @"没有更多了"

//#define LCChatContactUpdateTimeInterval (60*60*24)
#define LCChatContactUpdateTimeInterval (60)

//TabView
#define LCTabViewHeight 44

//TableView
#define LCCellBorderColor (0xe8e4dd)    //232 228 221
#define LCCellBorderWidth (1)
#define LCCellCornerRadius  (6)

//BlankContent
#define BlankContentMarginTop 100
#define BlankContentImageA @"BlankContentIconA"
#define BlankContentImageB @"BlankContentIconB"
#define BlankContentImageC @"BlankContentIconC"
#define BlankContentImageD @"BlankContentIconD"
#define BlankContentImageE @"BlankContentIconE"
#define BlankContentIconNotify @"BlankContentIconNotify"


extern NSString *const LCDefaultAvatarImageName;
extern NSString *const LCDefaultUploadImageName;
extern NSString *const LCDefaultImageName;
extern NSString *const LCDefaultPlaceImageName;
extern NSString *const LCDefaultUploadImageWhiteBg;
extern NSString *const LCDefaultTourpicImageName;

extern NSString *const LCCellTopBg;
extern NSString *const LCCellBottomBg;
extern NSString *const LCPlanCellTopBg;
extern NSString *const LCPlanCellBottomBg;

extern NSString *const LCSexMaleImageName;
extern NSString *const LCSexFemaleImageName;

extern NSString *const LCNavBarBackBarButtonImageName;

#pragma Font
/// 兰亭黑字体.
extern NSString *const LCFontLANTINGBLACK;
/// 系统英文字体.
extern NSString *const LCFontFUTURA;
/// 平方中文
extern NSString *const LCFontPINGFANG;

//chat
#define LCChatTextLeftBgImageName @"ChatTextLeft"
#define LCChatTextRightBgImageName @"ChatTextRight"
#define LCChatLocationLeftBgImageName @"ChatLocationLeft"
#define LCChatLocationRightBgImageName @"ChatLocationRight"
#define LCChatCheckInLeftBgImageName @"ChatCheckInLeft"
#define LCChatCheckInRightBgImageName @"ChatCheckInRight"
#define LCChatImageLeftBgImageName @"ChatImageLeft"
#define LCChatImageRightBgImageName @"ChatImageRight"

#define LCChatSendMessageFailToast @"发送消息失败，请检查网络连接"



@interface LCUIConstants : NSObject
@property (nonatomic, strong) UIImage *navBarTranslucentImage;
@property (nonatomic, strong) UIImage *navBarOpaqueImage;

+ (instancetype)sharedInstance;
- (void)setButtonAsSubmitButtonEnableStyle:(UIButton *)btn;
- (void)setButtonAsSubmitButtonDisableStyle:(UIButton *)btn;

- (void)setViewAsInputBg:(UIView *)view;


#pragma mark SystemMessage
+ (NSString *)getJoinPlanMessageWithUserNick:(NSString *)userNick;
+ (NSString *)getAgreeApplyPlanMessageWithManagerNick:(NSString *)managerNick applicant:(NSString *)applicantNick;
+ (NSString *)getQuitPlanMessageWithUserNick:(NSString *)userNick;
+ (NSString *)getKickOffUserFromPlanMessageWithUserNick:(NSString *)userNick;

#pragma mark UIFont For Navigation
+ (NSDictionary *)getBarButtonItemFontDic;

+ (UIFont *)getPingFangFont:(CGFloat)size;

@end

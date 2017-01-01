//
//  LCSendPlanHelper.m
//  LinkCity
//
//  Created by Roy on 12/12/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCSendPlanHelper.h"
#import "KLCPopup.h"
#import "LCPlanMainThemePickView.h"
#import "LCPlanSecondaryThemePickView.h"
#import "LCSendPlanDetailVC.h"
#import "LCSendFreePlanDestVC.h"
#import "LCSendCostPlanDestVC.h"
#import "LCSendTourPicVCViewController.h"
#import "LCSystemPermissionUtil.h"
#import "WechatShortVideoController.h"
#import "LCPickMultiImageHelper.h"
#import "LCSendPlanInSameCityVC.h"
#import "LinkCity-Swift.h"

@interface LCSendPlanHelper()<LCPlanMainThemePickViewDelegate, LCPlanSecondaryThemePickViewDelegate,WechatShortVideoDelegate>
@property (nonatomic, strong) LCPlanMainThemePickView *mainThemePickView;
@property (nonatomic, strong) KLCPopup *mainThemePickPopup;
@property (nonatomic, strong) LCPlanSecondaryThemePickView *secondaryThemePickView;
@property (nonatomic, strong) KLCPopup *secondaryThemePickPopup;

@property (nonatomic, assign) BOOL isSendingPlan;   // YES:发新计划    NO:编辑现有计划
@property (nonatomic, strong) LCPlanModel *curPlan; //当前正在操作的Plan
@property (nonatomic, strong) NSString *defaultDepartPlaceName;
@property (nonatomic, strong) LCRouteThemeModel *selectedMainTheme;

@property (nonatomic, strong) NSString *filePath;
@end

@implementation LCSendPlanHelper

#pragma mark - Public Interface
+ (instancetype)sharedInstance{
    static LCSendPlanHelper *staticInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[LCSendPlanHelper alloc] init];
    });
    return staticInstance;
}


- (void)sendNewPlanWithPlaceName:(NSString *)placeName{
    self.isSendingPlan = YES;
    self.defaultDepartPlaceName = placeName;
    
    //如果没有草稿，创建一个新的
    [self showMainThemePickView];
//    
//    if ([[LCDataManager sharedInstance].userInfo isMerchant]) {
//        //send cost plan
//        [self showMainThemePickView];
//    }else{
        //send free plan
    
//    }
}

- (void)modify:(LCPlanModel *)plan{
    self.isSendingPlan = NO;
    
    //如果是编辑已经发布的计划，创建一个拷贝再编辑
    //使得编辑不影响原来的计划
    self.curPlan = [plan createNewInstance];
    
    if ([[LCDataManager sharedInstance].userInfo isMerchant]) {
        //send cost plan
        [self presentSendCostPlanDestVC];
    }else{
        //send free plan
        [self pushToSendFreePlanDestVCWithPlan:self.curPlan];
//        LCSendPlanInSameCityVC * vc = [LCSendPlanInSameCityVC createInstance];
//        vc.isSendingPlan = YES;
//        [[LCSharedFuncUtil getTopMostViewController].navigationController pushViewController:vc animated:APP_ANIMATION];
        //[self pushToSendFreePlanDestVC];
    }
}


#pragma mark Set&Get
- (LCPlanModel *)curPlan{
    if (self.isSendingPlan) {
        return [LCDataManager sharedInstance].sendingPlan;
    }else{
        return [LCDataManager sharedInstance].modifyingPlan;
    }
}
- (void)setCurPlan:(LCPlanModel *)curPlan{
    if (self.isSendingPlan) {
        [LCDataManager sharedInstance].sendingPlan = curPlan;
    }else{
        [LCDataManager sharedInstance].modifyingPlan = curPlan;
    }
}

- (void)showMainThemePickView{
    self.mainThemePickView = [LCPlanMainThemePickView createInstance];
    self.mainThemePickView.delegate = self;
    //self.mainThemePickView.themeArray = [LCDataManager sharedInstance].appInitData.freePlanThemes;
    self.mainThemePickPopup = [KLCPopup popupWithContentView:self.mainThemePickView
                                                    showType:KLCPopupShowTypeBounceIn
                                                 dismissType:KLCPopupDismissTypeFadeOut
                                                    maskType:KLCPopupMaskTypeDimmed
                                    dismissOnBackgroundTouch:YES
                                       dismissOnContentTouch:NO];
    self.mainThemePickPopup.dimmedMaskAlpha = 0.5;
    
    [self.mainThemePickPopup showAtCenter:CGPointMake(DEVICE_WIDTH/2.0, DEVICE_HEIGHT/2.0) inView:nil];
    //[self.mainThemePickView pushPlusAnimation];
}

- (void)showSecondaryThemePickView{
    self.secondaryThemePickView = [LCPlanSecondaryThemePickView createInstance];
    self.secondaryThemePickView.delegate = self;
    self.secondaryThemePickView.themeArray = self.selectedMainTheme.childThemeArr;
    self.secondaryThemePickPopup = [KLCPopup popupWithContentView:self.secondaryThemePickView
                                                    showType:KLCPopupShowTypeBounceIn
                                                 dismissType:KLCPopupDismissTypeFadeOut
                                                    maskType:KLCPopupMaskTypeDimmed
                                    dismissOnBackgroundTouch:YES
                                       dismissOnContentTouch:NO];
    self.secondaryThemePickPopup.dimmedMaskAlpha = 0.5;
    
    [self.secondaryThemePickPopup showAtCenter:CGPointMake(DEVICE_WIDTH/2.0, DEVICE_HEIGHT/2.0) inView:nil];

}

#pragma mark PlanMainThemePickView Delegate
- (void)planMainThemePickView:(LCPlanMainThemePickView *)view didSelectTheme:(mainThemePickItem)item {
    [self.mainThemePickPopup dismiss:YES];
    switch (item) {
        case mainThemePickItemSendPlan:
            [MobClick event:V5_ADD_PLAN_CLICK];
            [self pushToSendFreePlanDestVC];
            break;
//        case mainThemePickItemSameCitySendPlan:
//            [self sendPlanInSameCity];
//            break;
//        case mainThemePickItemCarSharing:
//            break;
        case mainThemePickItemSendTourPic:
            [MobClick event:V5_ADD_TOURPIC_CLICK];
            [self pickTourPic];

            break;
        case mainThemePickItemSendVideo:
            [MobClick event:V5_ADD_VIDEO_CLICK];
            [self checkPermissionOfSystem];
    }
}

- (void)shouldDismissThemePickView {
    [self.mainThemePickPopup dismiss:YES];
}

- (void)pickTourPic {
    __weak typeof(self) weakSelf = self;
    UIViewController * vc = [LCSharedFuncUtil getTopMostViewController];
    [[LCPickMultiImageHelper sharedInstance] pickImageWithMaxNum:9 completion:^(NSArray *pickedImageArray){
        [weakSelf sendTourPicWithImageArray:pickedImageArray viewController:vc];
    }];
}

#pragma mark PlanSecondaryThemePickView Delegate
- (void)planSecondaryThemePickViewDidBack:(LCPlanSecondaryThemePickView *)view{
    self.curPlan.tourThemes = nil;
    
    [self.secondaryThemePickPopup dismiss:YES];
    [self showMainThemePickView];
}

- (void)planSecondaryThemePickView:(LCPlanSecondaryThemePickView *)view didSelectTheme:(LCRouteThemeModel *)theme{
    [self.secondaryThemePickPopup dismiss:YES];
    
    //更换主题了，不使用草稿，建新邀约
    if (![self.curPlan haveTheme:theme.tourThemeId]) {
        self.curPlan = [LCPlanModel createEmptyPlanForEdit];
        //设置发邀约中的默认目的地和主题
//        if ([LCStringUtil isNotNullString:self.defaultDepartPlaceName]) {
//            self.curPlan.departName = self.defaultDepartPlaceName;
//        }
        
        //添加之前选择的一级主题
        [self.curPlan addRouteTheme:self.selectedMainTheme];
    }
    
    [self.curPlan addRouteTheme:theme];
    
    
    if ([[LCDataManager sharedInstance].userInfo isMerchant]) {
        //send cost plan
        [self presentSendCostPlanDestVC];
    }else{
        //send free plan
        [self verifyIdentityAndSendFreePlan];
    }
}

#pragma mark InnerFunc
- (void)verifyIdentityAndSendFreePlan{
    if ([self.curPlan isCostCarryPlan]) {
        LCUserModel *user = [LCDataManager sharedInstance].userInfo;
        if (user.isCarVerify == LCIdentityStatus_Failed ||
            user.isCarVerify == LCIdentityStatus_None) {
            //去认证
            [LCDialogHelper showOneBtnDialogHideCancelBtn:NO dismissOnBgTouch:NO iconImageName:@"CarIconGray" title:@"认证车辆信息" msg:@"会提高90%的拼车邀约成功率" miniBtnTitle:nil btnTitle:@"去认证" cancelBtnCallBack:^{
                [LCDialogHelper dismissDialog];
            } miniBtnCallBack:^{
                [LCDialogHelper dismissDialog];
            } submitBtnCallBack:^{
                [LCDialogHelper dismissDialog];
                
                UIViewController *topVC = [LCSharedFuncUtil getTopMostViewController];
                [[LCUserIdentityHelper sharedInstance] startCarIdentityWithUser:[LCDataManager sharedInstance].userInfo fromVC:topVC];
            }];
        }else if (![LCDecimalUtil isOverZero:user.marginValue]){
            //去交保证金
            LCUserMarginVC *marginVC = [LCUserMarginVC createInstance];
            [[LCSharedFuncUtil getTopMostViewController].navigationController pushViewController:marginVC animated:YES];
        }else{
            //发邀约
            [self pushToSendFreePlanDestVC];
        }
    }else {
        [self pushToSendFreePlanDestVC];
    }
}

- (void)pushToSendFreePlanDestVC {
    if (!self.curPlan) {
        self.curPlan = [LCPlanModel createEmptyPlanForEdit];
    }

    LCSendPlanInSameCityVC * vc = [LCSendPlanInSameCityVC createInstance];
    vc.isSendingPlan = YES;
    vc.curPlan = self.curPlan;
    
    [[LCSharedFuncUtil getTopMostViewController].navigationController pushViewController:vc animated:APP_ANIMATION];

}

- (void)presentSendCostPlanDestVC {
    LCSendCostPlanDestVC *destVC = [LCSendCostPlanDestVC createInstance];
    destVC.curPlan = self.curPlan;
    destVC.isSendingPlan = self.isSendingPlan;
    
    [[LCSharedFuncUtil getTopMostViewController] presentViewController:[[UINavigationController alloc] initWithRootViewController:destVC] animated:YES completion:nil];
}
#pragma mark Video&TourPic Controller handler
- (void)checkPermissionOfSystem {
    if (![LCSystemPermissionUtil isHaveCameraPermission]) {
        return ;
    }
    if (![LCSystemPermissionUtil isHaveAlbumPermission]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [LCSystemPermissionUtil isHaveVoicePermission:^(BOOL isHavePermission) {
        if (isHavePermission) {
            //可以拍摄视频
            WechatShortVideoController *wechatShortVideoController = [[WechatShortVideoController alloc] init];
            wechatShortVideoController.delegate = weakSelf;
            [[LCSharedFuncUtil getTopMostViewController] presentViewController:wechatShortVideoController animated:YES completion:^{}];
        }
    }];
}

- (void)sendTourPicWithImageArray:(NSArray *)imageArray viewController:(UIViewController *)vc{
    if (imageArray && imageArray.count>0) {
        //在block里面进行controller级别的寻找会出错。bylhr
        LCSendTourPicVCViewController *sendTourPicVC = [LCSendTourPicVCViewController createInstance];
        sendTourPicVC.type = LCTourpicType_Photo;
        sendTourPicVC.photoArray = [NSMutableArray arrayWithArray:imageArray];
        [vc.navigationController pushViewController:sendTourPicVC animated:YES];//[imageArray mutableCopy];
        //        LCTourpicDescVC *vc = (LCTourpicDescVC *)[LCStoryboardManager viewControllerWithFileName:SBNameTourpicTab identifier:VCIDTourpicDescVC];
        //[sendTourPicVC setPickedImages:imageArray];
//        [[LCSharedFuncUtil getTopMostViewController].navigationController pushViewController:sendTourPicVC animated:APP_ANIMATION];
    }
}
//同城约人
//- (void)sendPlanInSameCity {

//}
- (void)pushToSendFreePlanDestVCWithPlan:(LCPlanModel *)plan{
    BOOL isInSameCity = YES;
    if (plan.routeType == LCRouteTypeFreePlanCommon) {
        isInSameCity = NO;
    }
    if (isInSameCity == NO) {
        if (!plan.photoUrls) {
            NSMutableArray * urlArray = [NSMutableArray arrayWithCapacity:0];
            if ([LCStringUtil isNotNullString:plan.firstPhotoUrl]) {
                [urlArray addObject:plan.firstPhotoUrl];
            }
            if ([LCStringUtil isNotNullString:plan.secondPhotoUrl]) {
                [urlArray addObject:plan.secondPhotoUrl];
            }
            if ([LCStringUtil isNotNullString:plan.thirdPhotoUrl]) {
                [urlArray addObject:plan.thirdPhotoUrl];
            }
            plan.photoUrls = urlArray;
        }

        LCSendFreePlanDestVC *destVC = [LCSendFreePlanDestVC createInstance];
        //self.curPlan.departName = @"";
        destVC.curPlan = plan;
        destVC.isSendingPlan = self.isSendingPlan;
        [[LCSharedFuncUtil getTopMostViewController].navigationController pushViewController:destVC animated:YES];
        //            [[LCSharedFuncUtil getTopMostViewController] presentViewController:[[UINavigationController alloc] initWithRootViewController:destVC] animated:YES completion:nil];
    } else {
        self.curPlan.departName = [[[LCDataManager sharedInstance] userLocation] cityName];
        //destVC.isSendingPlan = self.isSendingPlan;
        LCSendPlanDetailVC *vc = [LCSendPlanDetailVC createInstance];
        vc.curPlan = self.curPlan;

        //        if ([[LCDataManager sharedInstance] userLocation]) {
        //            vc.curPlan.location = userLocation;
        //        }
        vc.isInSameCity = isInSameCity;
        vc.isSendingPlan = NO;
        [[LCSharedFuncUtil getTopMostViewController].navigationController pushViewController:vc animated:YES];
        
        return;
    }

}
//    LCSendPlanDetailVC *vc = [LCSendPlanDetailVC createInstance];
//    
//    self.curPlan.photoUrls = nil;
//    self.curPlan.imageUnits = nil;
//    vc.curPlan = self.curPlan;
//    
//    //        if ([[LCDataManager sharedInstance] userLocation]) {
//    //            vc.curPlan.location = userLocation;
//    //        }
//    vc.isInSameCity = self.isInSameCity;
//    vc.isSendingPlan = self.isSendingPlan;
//    [self.navigationController pushViewController:vc animated:YES];
//}


#pragma mark - WechatShortVideoDelegate
- (void)finishWechatShortVideoCapture:(NSString *)filePath {
    self.filePath = filePath;
}

- (void)finishWechatShortVideoCaptureWithAsset:(AVAsset *)asset {
    LCSendTourPicVCViewController *sendTourPicVC = [LCSendTourPicVCViewController createInstance];
    sendTourPicVC.type = LCTourpicType_Video;
    sendTourPicVC.filePath = self.filePath;
    [sendTourPicVC setVideoPath:asset];
    [[LCSharedFuncUtil getTopMostViewController].navigationController pushViewController:sendTourPicVC animated:APP_ANIMATION];
}
@end

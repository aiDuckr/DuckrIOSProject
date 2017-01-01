//
//  LCUserIdentityHelper.m
//  LinkCity
//
//  Created by roy on 3/12/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserIdentityHelper.h"
#import "LCAgreementVC.h"
#import "LCUserIdentifyVC.h"
#import "LCUserIdentityAlertView.h"
#import "LCCreateRouteAlertView.h"
#import "LCPlanRouteEditVC.h"
#import "LCCarIdentityVC.h"
#import "LCUserRouteListVC.h"
#import "LCGuideIdentityVC.h"


@interface LCUserIdentityHelper()<LCPlanRouteEditVCDelegate>
@property (nonatomic, strong) UIViewController *baseVC;
@property (nonatomic, strong) LCAgreementVC *agreementVC;
@property (nonatomic, strong) LCUserIdentityAlertView *userIdentityAlertView;
@property (nonatomic, strong) LCPlanRouteEditVC *sendRouteVC;
@property (nonatomic, strong) LCCarIdentityVC *carIdentityVC;
@property (nonatomic, strong) LCGuideIdentityVC *guideIdentityVC;
@property (nonatomic, strong) KLCPopup *createRouteAlerViewPopup;
@end



@implementation LCUserIdentityHelper
+ (instancetype)sharedInstance{
    static LCUserIdentityHelper *staticInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[LCUserIdentityHelper alloc] init];
    });
    
    return staticInstance;
}

- (void)startUserIdentityWithUser:(LCUserModel *)user fromVC:(UIViewController *)vc{
    self.baseVC = vc;
    if (!user || [user getUserIdentityStatus] == LCIdentityStatus_None) {
        //显示用户协议页
        [self showUserIdentityAgreementVCWithCallBack:^(BOOL didConfirm) {
            if (didConfirm) {
                LCUserIdentifyVC *userIdentifyVC = [LCUserIdentifyVC createInstance];
                userIdentifyVC.popToVC = vc;
                [vc.navigationController pushViewController:userIdentifyVC animated:YES];
            }else{
                
            }
        }];
    }else{
        //已经提交过实名认证
        LCUserIdentifyVC *userIdentifyVC = [LCUserIdentifyVC createInstance];
        userIdentifyVC.popToVC = vc;
        [vc.navigationController pushViewController:userIdentifyVC animated:YES];
    }
}


- (void)startCarIdentityWithUser:(LCUserModel *)user fromVC:(UIViewController *)vc{
    self.baseVC = vc;
    LCCarIdentityVC *carAuthenticateVC = [LCCarIdentityVC createInstance];
    [vc.navigationController pushViewController:carAuthenticateVC animated:YES];
}


- (void)starGuideIdentityWithUser:(LCUserModel *)user fromVC:(UIViewController *)vc{
    self.baseVC = vc;
    
    //检查是否实名认证过，如果没有，进行实名认证
    if ([self checkAndDoUserIdentityWithUser:user fromVC:vc]) {
        //进行领队认证
        if (user.isTourGuideVerify == LCIdentityStatus_None) {
            //如果从来没有进行过领队认证，显示协议
            [self showGuideIdentityAgreementVCWithCallBack:^(BOOL didConfirm) {
                if (didConfirm) {
                    //如果同意了协议，进行认证
                    LCGuideIdentityVC *guideIdentityVC = [LCGuideIdentityVC createInstance];
                    [vc.navigationController pushViewController:guideIdentityVC animated:YES];
                }
            }];
        }else if (LCIdentityStatus_Done == user.isTourGuideVerify ||
                  user.isTourGuideVerify == LCIdentityStatus_Verifying ||
                  user.isTourGuideVerify == LCIdentityStatus_Failed){
            
            //如果正在审核，或者审核失败，进入认证页面
            LCGuideIdentityVC *guideIdentityVC = [LCGuideIdentityVC createInstance];
            [vc.navigationController pushViewController:guideIdentityVC animated:YES];
        }
    }
}




- (BOOL)checkAndDoUserIdentityWithUser:(LCUserModel *)user fromVC:(UIViewController *)vc{
    BOOL isIdentity = NO;
    if (!user || [user getUserIdentityStatus] != LCIdentityStatus_Done) {
        isIdentity = NO;
        
        //还没有实名认证
        // show user identity alertView
        LCUserIdentityAlertView *alertView = [LCUserIdentityAlertView createInstance];
        __block KLCPopup *popUp = [KLCPopup popupWithContentView:alertView
                                                        showType:KLCPopupShowTypeBounceInFromTop
                                                     dismissType:KLCPopupDismissTypeBounceOutToBottom
                                                        maskType:KLCPopupMaskTypeDimmed
                                        dismissOnBackgroundTouch:NO
                                           dismissOnContentTouch:NO];
        popUp.dimmedMaskAlpha = LCAlertViewMaskAlpha;
        
        
        alertView.callBack = ^(BOOL didConfirm){
            [popUp dismissPresentingPopup];
            
            if (didConfirm) {
                // start to do UserIdentity
                [self startUserIdentityWithUser:user fromVC:vc];
            }else{
                // do nothing
            }
        };
        
        [popUp showAtCenter:CGPointMake(DEVICE_WIDTH/2, DEVICE_HEIGHT/2) inView:nil];
    }else{
        isIdentity = YES;
    }
    
    return isIdentity;
}

- (void)showUserIdentityAgreementVCWithCallBack:(void(^)(BOOL didConfirm))callBack{
    self.agreementVC = [LCAgreementVC createInstance];
    self.agreementVC.title = @"身份认证";
    self.agreementVC.urlStr = server_url([LCConstants serverHost], LCUserIdentityAgreementURL);
    self.agreementVC.showCancelBarButton = NO;
    self.agreementVC.callBack = callBack;
    [self.baseVC.navigationController pushViewController:self.agreementVC animated:YES];
}
- (void)showGuideIdentityAgreementVCWithCallBack:(void(^)(BOOL didConfirm))callBack{
    self.agreementVC = [LCAgreementVC createInstance];
    self.agreementVC.title = @"领队服务认证";
    self.agreementVC.urlStr = server_url([LCConstants serverHost], LCGuideIdentityAgreementURL);
    self.agreementVC.showCancelBarButton = NO;
    self.agreementVC.callBack = callBack;
    [self.baseVC.navigationController pushViewController:self.agreementVC animated:YES];
}
- (void)showCreateRouteAlertViewWithCallBack:(void(^)(BOOL didConfirm))callBack{
    
    LCCreateRouteAlertView *alertView = [LCCreateRouteAlertView createInstance];
    alertView.callBack = callBack;
    self.createRouteAlerViewPopup = [KLCPopup popupWithContentView:alertView
                                                    showType:KLCPopupShowTypeBounceInFromTop
                                                 dismissType:KLCPopupDismissTypeBounceOutToBottom
                                                    maskType:KLCPopupMaskTypeDimmed
                                    dismissOnBackgroundTouch:NO
                                       dismissOnContentTouch:NO];
    self.createRouteAlerViewPopup.dimmedMaskAlpha = LCAlertViewMaskAlpha;
    [self.createRouteAlerViewPopup showAtCenter:CGPointMake(DEVICE_WIDTH/2, DEVICE_HEIGHT/2) inView:nil];
}





#pragma mark - LCPlanRouteEditVC Delegate
- (void)planRouteEditVCDidCancel:(LCPlanRouteEditVC *)routeEditVC{
    
}
- (void)planRouteEditVC:(LCPlanRouteEditVC *)routeEditVC didSaveUserRoute:(LCUserRouteModel *)userRoute{
    //弹出到发起领队认证的页面，再push到路线列表页
    [self.baseVC.navigationController popToViewController:self.baseVC animated:NO];
    [LCViewSwitcher pushToShowRouteListVCOn:self.baseVC.navigationController];
    
    [YSAlertUtil tipOneMessage:@"领队认证成功!" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
}






@end

//
//  LCDuckrShareCodeHelper.m
//  LinkCity
//
//  Created by Roy on 12/24/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCDuckrShareCodeHelper.h"
#import "LCShareCodePlanView.h"


@interface LCDuckrShareCodeHelper()
@property (nonatomic, strong) LCShareCodePlanView *shareCodeView;
@property (nonatomic, strong) KLCPopup *shareCodePopup;
@end



@implementation LCDuckrShareCodeHelper

+ (instancetype)sharedInstance{
    static LCDuckrShareCodeHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LCDuckrShareCodeHelper alloc] init];
    });
    
    return instance;
}

- (void)detectDuckrShareCode{
    UIPasteboard *pasteBoard =[UIPasteboard generalPasteboard];
    NSData *data = [pasteBoard dataForPasteboardType:(NSString *)kUTTypeText];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if ([str containsString:@"【达客旅行】"]){
        NSRange range = [str rangeOfString:@"#.*#" options:NSRegularExpressionSearch];
        if (range.location != NSNotFound &&
            range.length > 2) {
            
            //是达客口令
            [pasteBoard setValue:@"" forPasteboardType:(NSString *)kUTTypeText];
            NSString *shareCode = [str substringWithRange:NSMakeRange(range.location+1, range.length-2)];
            
            
            __weak typeof(self) weakSelf = self;
            [LCNetRequester analysisShareCode:shareCode callBack:^(LCPlanModel *plan, NSString *recmdUuid, NSError *error) {
                if (!weakSelf) {
                    return;
                }
                __strong typeof(weakSelf) strongSelf = self;
                
                if (error) {
                    [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
                }else{
                    [strongSelf showShareCodePopupWithPlan:plan recmdUuid:recmdUuid];
                }
            }];
        }
    }
}

- (void)showShareCodePopupWithPlan:(LCPlanModel *)plan recmdUuid:(NSString *)recmdUuid{
    
    self.shareCodeView = [LCShareCodePlanView createInstance];
    
    __weak typeof(self) weakSelf = self;
    [self.shareCodeView updateShowWith:plan callBack:^(BOOL confirmed) {
        if (!weakSelf) {
            return;
        }
        __strong typeof(weakSelf) strongSelf = self;
        
        if (confirmed) {
            [strongSelf.shareCodePopup dismiss:YES];
            UIViewController *topMostVC = [LCSharedFuncUtil getTopMostViewController];
            if (topMostVC.presentingViewController) {
                topMostVC = topMostVC.presentingViewController;
                [topMostVC dismissViewControllerAnimated:NO completion:^{
                    [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:recmdUuid on:[LCSharedFuncUtil getTopMostViewController].navigationController];
                }];
            }else{
                [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:recmdUuid on:topMostVC.navigationController];
            }
            
        }else{
            [strongSelf.shareCodePopup dismiss:YES];
        }
    }];
    
    [KLCPopup dismissAllPopups];
    self.shareCodePopup = [KLCPopup popupWithContentView:self.shareCodeView
                                            showType:KLCPopupShowTypeSlideInFromTop
                                         dismissType:KLCPopupDismissTypeSlideOutToBottom
                                            maskType:KLCPopupMaskTypeDimmed
                            dismissOnBackgroundTouch:YES
                               dismissOnContentTouch:NO];
    self.shareCodePopup.dimmedMaskAlpha = 0.5;
    [self.shareCodePopup showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter)];
}




@end


















//
//  LCShareUtil.m
//  LinkCity
//
//  Created by zzs on 14/11/30.
//  Copyright (c) 2014年 linkcity. All rights reserved.
//

#import "LCShareUtil.h"
#import "UMSocial.h"

@implementation LCShareUtil
+ (void)shareWeixinAction:(LCPlanModel *)plan presentedController:(UIViewController *)controller {
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = plan.planShareUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = plan.planShareTitle;
    [UMSocialData defaultData].extConfig.wechatSessionData.shareImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:plan.firstPhotoThumbUrl]];
//    [[UMSocialData defaultData].extConfig.wechatSessionData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:plan.firstPhotoThumbUrl];
    if ([LCStringUtil isNotNullString:plan.descriptionStr]) {
        NSInteger maxStrLength = 25;
        NSString *strToShare = [NSString stringWithString:plan.descriptionStr];
        if (strToShare.length > maxStrLength) {
            strToShare = [strToShare substringWithRange:NSMakeRange(0, maxStrLength)];
        }
        [UMSocialData defaultData].extConfig.wechatSessionData.shareText = strToShare;
    }
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:nil image:nil location:nil urlResource:nil presentedController:controller completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            ZLog(@"微信分享成功！");
            [YSAlertUtil tipOneMessage:@"微信分享成功！" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            
            [LCNetRequester forwardPlan:plan.planGuid callBack:^(NSInteger forwardNum, NSError *error) {
                LCLogInfo(@"forwardPlanNum:%ld, error:%@",(long)forwardNum, error);
            }];
        }
    }];
}

+ (void)shareWeixinTimeLineAction:(LCPlanModel *)plan presentedController:(UIViewController *)controller {
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = plan.planShareUrl;
    NSString *contentStr = plan.planShareTitle;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:contentStr image:[NSData dataWithContentsOfURL:[NSURL URLWithString:plan.firstPhotoThumbUrl]] location:nil urlResource:nil presentedController:controller completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            ZLog(@"微信朋友圈分享成功！");
            ZLog(@"resonse data is %@", response.data);
            [YSAlertUtil tipOneMessage:@"微信朋友圈分享成功！" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            
            [LCNetRequester forwardPlan:plan.planGuid callBack:^(NSInteger forwardNum, NSError *error) {
                LCLogInfo(@"forwardPlanNum:%ld, error:%@",(long)forwardNum, error);
            }];
        }
    }];
}

+ (void)shareWeiboAction:(LCPlanModel *)plan presentedController:(UIViewController *)controller {
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:plan.firstPhotoUrl];
    [[UMSocialData defaultData].extConfig.sinaData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:plan.firstPhotoThumbUrl];

    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@ %@", plan.planShareTitle, plan.planShareUrl] image:nil location:nil urlResource:urlResource presentedController:controller completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            ZLog(@"微博分享成功！");
            [YSAlertUtil tipOneMessage:@"微博分享成功！" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            
            [LCNetRequester forwardPlan:plan.planGuid callBack:^(NSInteger forwardNum, NSError *error) {
                LCLogInfo(@"forwardPlanNum:%ld, error:%@",(long)forwardNum, error);
            }];
        }
    }];
}

+ (void)shareQQAction:(LCPlanModel *)plan presentedController:(UIViewController *)controller {
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    [UMSocialData defaultData].extConfig.qqData.url = plan.planShareUrl;
    [UMSocialData defaultData].extConfig.qqData.title = plan.planShareTitle;
    [[UMSocialData defaultData].extConfig.qqData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:plan.firstPhotoThumbUrl];
    
    if ([LCStringUtil isNotNullString:plan.descriptionStr]) {
        [UMSocialData defaultData].extConfig.qqData.shareText = plan.descriptionStr;
    }
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:nil image:nil location:nil urlResource:nil presentedController:controller completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            ZLog(@"QQ分享成功！");
            [YSAlertUtil tipOneMessage:@"QQ分享成功！" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            
            [LCNetRequester forwardPlan:plan.planGuid callBack:^(NSInteger forwardNum, NSError *error) {
                LCLogInfo(@"forwardPlanNum:%ld, error:%@",(long)forwardNum, error);
            }];
        }
    }];
}

+ (void)shareDuckrAction:(LCPlanModel *)plan presentedController:(UIViewController *)controller {
    LCSharePlanToVC *sharePlanToVC = [LCSharePlanToVC createInstance];
    sharePlanToVC.planToShare = plan;
    [controller.navigationController pushViewController:sharePlanToVC animated:YES];
}

+ (void)shareTourpicWeixinAction:(LCTourpic *)tourpic presentedController:(UIViewController *)controller callBack:(void(^)(NSInteger forwardNum, NSError *error))callBack {
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = tourpic.shareUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = tourpic.shareTitle;
    [UMSocialData defaultData].extConfig.wechatSessionData.shareImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:tourpic.thumbPicUrl]];
    if ([LCStringUtil isNotNullString:tourpic.desc]) {
        [UMSocialData defaultData].extConfig.wechatSessionData.shareText = tourpic.desc;
    }
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:nil image:nil location:nil urlResource:nil presentedController:controller completion:^(UMSocialResponseEntity *response) {
        NSError *error = nil;
        if (response.responseCode == UMSResponseCodeSuccess) {
            [YSAlertUtil tipOneMessage:@"微信分享成功！"];
            [LCNetRequester likeTourpic:tourpic.guid withType:@"2" callBack:^(NSInteger likeNum, NSInteger forwardNum, NSInteger isLike, NSError *error) {
                if (error) {
                    callBack(0, error);
                } else {
                    callBack(forwardNum, error);
                }
            }];
        } else {
            error = [NSError errorWithDomain:@"分享失败！" code:response.responseCode userInfo:nil];
            callBack(0, error);
        }
    }];
}

+ (void)shareTourpicWeixinTimeLine:(LCTourpic *)tourpic presentedController:(UIViewController *)controller callBack:(void(^)(NSInteger forwardNum, NSError *error))callBack {
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = tourpic.shareUrl;
    NSString *contentStr = tourpic.shareTitle;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:contentStr image:[NSData dataWithContentsOfURL:[NSURL URLWithString:tourpic.thumbPicUrl]] location:nil urlResource:nil presentedController:controller completion:^(UMSocialResponseEntity *response){
        NSError *error = nil;
        if (response.responseCode == UMSResponseCodeSuccess) {
            ZLog(@"微信朋友圈分享成功！");
            [YSAlertUtil tipOneMessage:@"微信朋友圈分享成功！"];
            [LCNetRequester likeTourpic:tourpic.guid withType:@"2" callBack:^(NSInteger likeNum, NSInteger forwardNum, NSInteger isLike, NSError *error) {
                if (error) {
                    callBack(0, error);
                } else {
                    callBack(forwardNum, error);
                }
            }];
        } else {
            error = [NSError errorWithDomain:@"分享失败！" code:response.responseCode userInfo:nil];
            callBack(0, error);
        }
    }];
}

+ (void)shareTourpicWeibo:(LCTourpic *)tourpic presentedController:(UIViewController *)controller callBack:(void(^)(NSInteger forwardNum, NSError *error))callBack {
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url: tourpic.picUrl];
    [[UMSocialData defaultData].extConfig.sinaData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:tourpic.thumbPicUrl];
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@ %@", tourpic.shareTitle, tourpic.shareUrl] image:nil location:nil urlResource:urlResource presentedController:controller completion:^(UMSocialResponseEntity *shareResponse) {
        NSError *error = nil;
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            ZLog(@"微博分享成功！");
            [YSAlertUtil tipOneMessage:@"微博分享成功！"];
            [LCNetRequester likeTourpic:tourpic.guid withType:@"2" callBack:^(NSInteger likeNum, NSInteger forwardNum, NSInteger isLike, NSError *error) {
                if (error) {
                    callBack(0, error);
                } else {
                    callBack(forwardNum, error);
                }
            }];
        } else {
            error = [NSError errorWithDomain:@"分享失败！" code:shareResponse.responseCode userInfo:nil];
            callBack(0, error);
        }
    }];
}

+ (void)shareTourpicQQ:(LCTourpic *)tourpic presentedController:(UIViewController *)controller callBack:(void (^)(NSInteger, NSError *))callBack{
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    [UMSocialData defaultData].extConfig.qqData.url = tourpic.shareUrl;
    [UMSocialData defaultData].extConfig.qqData.title = tourpic.shareTitle;
    [[UMSocialData defaultData].extConfig.qqData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:tourpic.thumbPicUrl];
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:tourpic.shareTitle image:nil location:nil urlResource:nil presentedController:controller completion:^(UMSocialResponseEntity *response){
        
        NSError *error = nil;
        if (response.responseCode == UMSResponseCodeSuccess) {
            ZLog(@"QQ分享成功！");
            [YSAlertUtil tipOneMessage:@"QQ分享成功！"];
            [LCNetRequester likeTourpic:tourpic.guid withType:@"2" callBack:^(NSInteger likeNum, NSInteger forwardNum, NSInteger isLike, NSError *error) {
                if (error) {
                    callBack(0, error);
                } else {
                    callBack(forwardNum, error);
                }
            }];
        } else {
            error = [NSError errorWithDomain:@"分享失败！" code:response.responseCode userInfo:nil];
            callBack(0, error);
        }
    }];
}



#pragma mark -
+ (void)shareToWeiXinWith:(NSString *)shareTitle content:(NSString *)shareContent url:(NSString *)shareUrl img:(NSString *)imgUrl callBack:(void(^)(BOOL succeed))callBackFunc{
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
    if ([LCStringUtil isNotNullString:shareContent]) {
        [UMSocialData defaultData].extConfig.wechatSessionData.shareText = shareContent;
    }
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:nil image:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]] location:nil urlResource:nil presentedController:[LCSharedFuncUtil getTopMostViewController] completion:^(UMSocialResponseEntity *response) {
        
        if (callBackFunc) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                callBackFunc(YES);
            }else{
                callBackFunc(NO);
            }
        }
    }];
}
+ (void)shareToWeiXinTimeLineWith:(NSString *)shareTitle content:(NSString *)shareContent url:(NSString *)shareUrl img:(NSString *)imgUrl callBack:(void(^)(BOOL succeed))callBackFunc{
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
    NSString *contentStr = shareTitle;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:contentStr image:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]] location:nil urlResource:nil presentedController:[LCSharedFuncUtil getTopMostViewController] completion:^(UMSocialResponseEntity *response){
        
        if (callBackFunc) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                callBackFunc(YES);
            }else{
                callBackFunc(NO);
            }
        }
    }];
}
+ (void)shareToWeiboWith:(NSString *)shareTitle content:(NSString *)shareContent url:(NSString *)shareUrl img:(NSString *)imgUrl callBack:(void(^)(BOOL succeed))callBackFunc{
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:imgUrl];
    [[UMSocialData defaultData].extConfig.sinaData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:imgUrl];
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@ %@", shareTitle, shareUrl] image:nil location:nil urlResource:urlResource presentedController:[LCSharedFuncUtil getTopMostViewController] completion:^(UMSocialResponseEntity *response) {
        
        if (callBackFunc) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                callBackFunc(YES);
            }else{
                callBackFunc(NO);
            }
        }
    }];
}
+ (void)shareToQQWith:(NSString *)shareTitle content:(NSString *)shareContent url:(NSString *)shareUrl img:(NSString *)imgUrl callBack:(void(^)(BOOL succeed))callBackFunc{
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
    [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
    [[UMSocialData defaultData].extConfig.qqData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:imgUrl];
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:shareContent image:nil location:nil urlResource:nil presentedController:[LCSharedFuncUtil getTopMostViewController] completion:^(UMSocialResponseEntity *response){
        
        if (callBackFunc) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                callBackFunc(YES);
            }else{
                callBackFunc(NO);
            }
        }
    }];
}


@end

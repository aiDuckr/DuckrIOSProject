//
//  LCShareUtil.h
//  LinkCity
//
//  Created by zzs on 14/11/30.
//  Copyright (c) 2014年 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCPlanModel.h"
#import "LCTourpic.h"
#import "LCSharePlanToVC.h"

@interface LCShareUtil : NSObject
+ (void)shareWeixinAction:(LCPlanModel *)plan presentedController:(UIViewController *)controller;
+ (void)shareWeixinTimeLineAction:(LCPlanModel *)plan presentedController:(UIViewController *)controller;
+ (void)shareWeiboAction:(LCPlanModel *)plan presentedController:(UIViewController *)controller;
+ (void)shareQQAction:(LCPlanModel *)plan presentedController:(UIViewController *)controller;
+ (void)shareDuckrAction:(LCPlanModel *)plan presentedController:(UIViewController *)controller;

+ (void)shareTourpicWeixinAction:(LCTourpic *)tourpic presentedController:(UIViewController *)controller callBack:(void(^)(NSInteger forwardNum, NSError *error))callBack;
+ (void)shareTourpicWeixinTimeLine:(LCTourpic *)tourpic presentedController:(UIViewController *)controller callBack:(void(^)(NSInteger forwardNum, NSError *error))callBack;
+ (void)shareTourpicWeibo:(LCTourpic *)tourpic presentedController:(UIViewController *)controller callBack:(void(^)(NSInteger forwardNum, NSError *error))callBack;
+ (void)shareTourpicQQ:(LCTourpic *)tourpic presentedController:(UIViewController *)controller callBack:(void(^)(NSInteger forwardNum, NSError *error))callBack;



+ (void)shareToWeiXinWith:(NSString *)shareTitle content:(NSString *)shareContent url:(NSString *)shareUrl img:(NSString *)imgUrl callBack:(void(^)(BOOL succeed))callBackFunc;
+ (void)shareToWeiXinTimeLineWith:(NSString *)shareTitle content:(NSString *)shareContent url:(NSString *)shareUrl img:(NSString *)imgUrl callBack:(void(^)(BOOL succeed))callBackFunc;
+ (void)shareToWeiboWith:(NSString *)shareTitle content:(NSString *)shareContent url:(NSString *)shareUrl img:(NSString *)imgUrl callBack:(void(^)(BOOL succeed))callBackFunc;
+ (void)shareToQQWith:(NSString *)shareTitle content:(NSString *)shareContent url:(NSString *)shareUrl img:(NSString *)imgUrl callBack:(void(^)(BOOL succeed))callBackFunc;

@end

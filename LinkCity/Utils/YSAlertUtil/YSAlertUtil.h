//
//  YSAlertUtil.h
//  MissYou
//
//  Created by zzs on 14-6-24.
//  Copyright (c) 2014年 yunshuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#define TipDefaultDelay 1.0
#define TipRightDelay 0.6
#define TipErrorDelay 1.6
#define TipDefaultYoffset 150
#define TipAboveKeyboardYoffset -20
typedef void (^AlertCallback)(NSInteger chooseIndex);

@interface YSAlertUtil : NSObject
+ (instancetype)sharedInstance;

/**
 * @brief   弹出一条消息.
 *
 * @param   str 消息内容.
 *
 * @return  无.
 */
+ (void)alertOneMessage:(NSString*)str;

+ (void)alertOneButton:(NSString *)btnOne
             withTitle:(NSString *)title
                   msg:(NSString *)msg
              callBack:(AlertCallback)callBack;
+ (void)alertTwoButton:(NSString *)btnOne
                btnTwo:(NSString *)btnTwo
             withTitle:(NSString *)title
                   msg:(NSString *)msg
              callBack:(AlertCallback)callBack;

+ (void)tipOneMessage:(NSString *)str;
+ (void)tipOneMessage:(NSString *)str delay:(float)delay    __attribute__((deprecated("3.0")));
+ (void)tipOneMessage:(NSString *)str onView:(UIView *)view yoffset:(float)yoffset  __attribute__((deprecated("3.0")));


+ (void)tipOneMessage:(NSString *)str yoffset:(float)yoffset delay:(float)delay;
+ (void)tipOneMessage:(NSString *)str onView:(UIView *)view yoffset:(float)yoffset delay:(float)delay;

+ (void)showHudWithHint:(NSString *)hint inView:(UIView *)view enableUserInteraction:(BOOL)enable;
+ (void)showHudWithHint:(NSString *)hint inView:(UIView *)view;
+ (void)showHudWithHint:(NSString *)hint;
+ (void)hideHud;

+ (BOOL)isShowingHud;

+ (void)showActionSheetWithCallBack:(void(^)(NSInteger selectIndex))callBack cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSArray *)otherButtonTitles;
@end

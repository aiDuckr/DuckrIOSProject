 //
//  YSAlertUtil.m
//  MissYou
//
//  Created by zzs on 14-6-24.
//  Copyright (c) 2014年 yunshuo. All rights reserved.
//

//#import "YSAlertUtil.h"

@interface YSAlertUtil()<UIAlertViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) AlertCallback alertCallback;
@property (nonatomic, strong) void (^actionSheetCallback)(NSInteger);
@property (nonatomic, strong) MBProgressHUD *showingHud;
@end
@implementation YSAlertUtil
+ (instancetype)sharedInstance {
    static YSAlertUtil *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YSAlertUtil alloc]init];
    });
    return instance;
}


#pragma mark - Toast
+ (void)tipOneMessage:(NSString *)str onView:(UIView *)view yoffset:(float)yoffset delay:(float)delay {
    if (nil != view) {
        //显示提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = str;
        hud.detailsLabelFont = [UIFont fontWithName:FONT_LANTINGBLACK size:14];
        hud.margin = 10.f;
        hud.yOffset = yoffset;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:delay];
    }
}
+ (void)tipOneMessage:(NSString *)str yoffset:(float)yoffset delay:(float)delay{
//    LCLogInfo(@"tipOneMessage:%@, callStack:%@",str,[NSThread callStackSymbols]);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = str;
    hud.detailsLabelFont = [UIFont fontWithName:FONT_LANTINGBLACK size:14];
    hud.margin = 10.f;
    hud.yOffset = yoffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:delay];
}



+ (void)tipOneMessage:(NSString *)str onView:(UIView *)view yoffset:(float)yoffset {
    [YSAlertUtil tipOneMessage:str onView:view yoffset:yoffset delay:TipDefaultDelay];
}

+ (void)tipOneMessage:(NSString *)str delay:(float)delay {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    
    UIView *view = result.view;
    if (nil != view)
    {
        [YSAlertUtil tipOneMessage:str onView:view yoffset:150.0 delay:delay];
    }
}

+ (void)tipOneMessage:(NSString *)str {
    if ([LCStringUtil isNotNullString:str]) {
        [YSAlertUtil tipOneMessage:str delay:TipDefaultDelay];
    }
}



#pragma mark - AlertView
+ (void)alertOneMessage:(NSString*)str {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

+ (void)alertOneButton:(NSString *)btnOne
             withTitle:(NSString *)title
                   msg:(NSString *)msg
              callBack:(AlertCallback)callBack{
    [YSAlertUtil sharedInstance].alertCallback = callBack;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:[YSAlertUtil sharedInstance] cancelButtonTitle:btnOne otherButtonTitles:nil];
    [alert show];
}
+ (void)alertTwoButton:(NSString *)btnOne
                btnTwo:(NSString *)btnTwo
             withTitle:(NSString *)title
                   msg:(NSString *)msg
              callBack:(AlertCallback)callBack{
    [YSAlertUtil sharedInstance].alertCallback = callBack;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:[YSAlertUtil sharedInstance] cancelButtonTitle:btnOne otherButtonTitles:btnTwo, nil];
    [alert show];
}

#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    AlertCallback callback = [YSAlertUtil sharedInstance].alertCallback;
    if (callback) {
        callback(buttonIndex);
        callback = nil;
    }
}



#pragma mark - Hud
+ (void)showHudWithHint:(NSString *)hint inView:(UIView *)view enableUserInteraction:(BOOL)enable{
    //如果有正在显示的Hud，不创建新的
    MBProgressHUD *hud = [YSAlertUtil sharedInstance].showingHud;
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:view];
    }
    
    hud.labelText = hint;
    hud.userInteractionEnabled = !enable;
    [view addSubview:hud];
    [hud show:YES];
    [YSAlertUtil sharedInstance].showingHud = hud;
}
+ (void)showHudWithHint:(NSString *)hint inView:(UIView *)view{
    [self showHudWithHint:hint inView:view enableUserInteraction:NO];
}
+ (void)showHudWithHint:(NSString *)hint{
    [YSAlertUtil showHudWithHint:hint inView:[UIApplication sharedApplication].delegate.window];
}
+ (void)hideHud{
    [[YSAlertUtil sharedInstance].showingHud hide:YES];
    [YSAlertUtil sharedInstance].showingHud = nil;
}
+ (BOOL)isShowingHud{
    return [YSAlertUtil sharedInstance].showingHud!=nil;
}


#pragma mark - ActionSheet
+ (void)showActionSheetWithCallBack:(void (^)(NSInteger))callBack cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSArray *)otherButtonTitles{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:[YSAlertUtil sharedInstance] cancelButtonTitle:cancelTitle destructiveButtonTitle:nil otherButtonTitles:nil];
    [YSAlertUtil sharedInstance].actionSheetCallback = callBack;
    for (NSString *btnTitle in otherButtonTitles){
        [actionSheet addButtonWithTitle:btnTitle];
    }
    [actionSheet showInView:[UIApplication sharedApplication].delegate.window];
}



#pragma mark UIActionSheetDelegate
//- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
//{
//    for (UIView *subViwe in actionSheet.subviews) {
//        if ([subViwe isKindOfClass:[UIButton class]]) {
//            UIButton *button = (UIButton*)subViwe;
//            [button setTitleColor:UIColorFromRGBA(BUTTON_TITLE_COLOR, 1.0) forState:UIControlStateNormal];
//        }
//    }
//}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.actionSheetCallback) {
        self.actionSheetCallback(buttonIndex);
    }
}


@end

//
//  LCSharedFuncUtil.m
//  LinkCity
//
//  Created by roy on 11/25/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCSharedFuncUtil.h"
#import <AdSupport/ASIdentifierManager.h>  
#import "sys/sysctl.h"


@implementation LCSharedFuncUtil

+ (LCSharedFuncUtil *)sharedInstance{
    static LCSharedFuncUtil *sharedInstance;
    static dispatch_once_t onceToken;
    if (!sharedInstance) {
        dispatch_once(&onceToken, ^{
            sharedInstance = [[LCSharedFuncUtil alloc]init];
        });
    }
    return sharedInstance;
}

+ (void)quitLoginApp {
    [LCDataManager sharedInstance].userInfo = nil;
    
    //删除UserDefaults数据
    [[LCDataManager sharedInstance] clearUserDefaultForLogout];
    //删除聊天数据库信息
//    [LCXMPPUtil deleteAllChatContact];
//    [LCXMPPUtil deleteAllChatMsg];
    //下线所有的群聊，清除本地记录的群聊数据
//    [[LCXMPPMessageHelper sharedInstance] getAllRoomOffline];
    //下线xmppStream，不然其它用户登录时，直接goOnline，还是登的以前的账号stream
    [[LCXMPPMessageHelper sharedInstance] disconnect];
    
    //删除红点数
    [LCDataManager sharedInstance].redDot = nil;
    //删除聊天红点数
    [[LCDataManager sharedInstance] clearUnreadNumForAll];

    [LCDataManager sharedInstance].sendingPlan = nil;
    [LCDataManager sharedInstance].modifyingPlan = nil;
    
    [[LCDataManager sharedInstance] saveData];
}

+ (AppDelegate *)getAppDelegate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (UINavigationController *)getTopMostNavigationController {
    UIViewController *vc = [LCSharedFuncUtil getTopMostViewController];
    if (nil != vc) {
        return vc.navigationController;
    }
    return nil;
}

+ (UIViewController *)getTopMostViewController{
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    return [LCSharedFuncUtil topViewControllerWithRootViewController:rootViewController];
}

+ (UIViewController *)getRootViewController{
    return [[[UIApplication sharedApplication] keyWindow] rootViewController];
}

+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    }else {
        return rootViewController;
    }
}

+ (void)dialPhoneNumber:(NSString *)phoneNumber{
    if ([LCStringUtil isNullString:phoneNumber]) {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:nil message:@"号码错误" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [notPermitted show];
    }
    
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [YSAlertUtil alertTwoButton:@"取消" btnTwo:@"呼叫" withTitle:nil msg:phoneNumber callBack:^(NSInteger chooseIndex) {
            if (chooseIndex == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]]];
            }
        }];
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:nil message:@"您的设备不能拨打电话" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [notPermitted show];
    }
}

+ (void)sendMessage:(NSString *)message{
    if ([LCStringUtil isNullString:message]) {
        [YSAlertUtil tipOneMessage:@"短信内容不能为空"];
    }else{
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",message]]];
    }
}

+ (void)gotoAppDownloadPage{
    NSString *urlStr = [NSString stringWithFormat:APP_DOWNLOAD_URL];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}


+ (id)decodeObjectFromJsonString:(NSString *)jsonString{
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id ret = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    return ret;
}

+ (NSString *)getDevicePlatform {
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    return platform;
}

+ (NSString *)getIdfa {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

+ (NSString *)getIMEI {
    return @"";
}

+ (NSString *)getMacAddress {
    return @"";
}

+ (NSString *)getCPUType {
    return @"";
}

+ (NSString *)getDeviceName {
    UIDevice *device = [UIDevice currentDevice];
    return device.name;
}

+ (NSString *)getDeviceModel {
    UIDevice *device = [UIDevice currentDevice];
    return device.model;
}

+ (NSString *)getScreenResolution {
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    NSString *str = [NSString stringWithFormat:@"%fx%f", DEVICE_WIDTH * scale_screen, DEVICE_HEIGHT * scale_screen];
    return str;
}

+ (NSString *)classNameOfClass:(Class)theClass{
    return [[NSStringFromClass(theClass) componentsSeparatedByString:@"."] lastObject];
}

+ (CGFloat)adaptBy6sWidthForAllDevice:(CGFloat)widthFor6s  {
    return widthFor6s / 375.0 * DEVICE_WIDTH;
}

+ (CGFloat)adaptBy6sHeightForAllDevice:(CGFloat)heightFor6s  {
    return heightFor6s / 667.0 * DEVICE_HEIGHT;
}

+ (NSArray *)addFiltedArrayToArray:(NSArray *)sourceArray withUnfiltedArray:(NSArray *)destArray {
    //你以为是过滤数组。其实是取了sourceArray和destArray的并集。
    
    if (nil == sourceArray) {
        sourceArray = [[NSArray alloc] init];
    }
    
    if (nil == destArray || destArray.count <= 0) {
        return sourceArray;
    }
    NSMutableArray *finalArray = [[NSMutableArray alloc] initWithArray:sourceArray];//先把sourceArray加进去
    
    //初始化三个字典，键为对象的唯一标示（），值为该对象
    NSMutableDictionary *planDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *tourpicDic =  [[NSMutableDictionary alloc] init];
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc] init];
    
    //把sourceArray全部存入3个可变字典。
    for (id obj in sourceArray) {
        if ([obj isKindOfClass:[LCPlanModel class]]) {
            LCPlanModel *plan = (LCPlanModel *)obj;
            [planDic setObject:plan forKey:plan.stageMaster];//主邀约的Guid就是stageMaster
        } else if ([obj isKindOfClass:[LCTourpic class]]) {
            LCTourpic *tourpic = (LCTourpic *)obj;
            [tourpicDic setObject:tourpic forKey:tourpic.guid];
        } else if ([obj isKindOfClass:[LCUserModel class]]) {
            LCUserModel *user = (LCUserModel *)obj;
            [userDic setObject:user forKey:user.uUID];
        }
    }
    for (id obj in destArray) {
        //判断destArray每个元素是否存在于某个可变字典（因为三个可变字典都来自于sourceArray）里。如果不存在，则加到可变字典里（最终可变字典里是仅仅三种类型的对象，而且是两个集合的交集），也加到finalArray里面（也包含非此三种对象的对象）。
        if ([obj isKindOfClass:[LCPlanModel class]]) {
            LCPlanModel *plan = (LCPlanModel *)obj;
            if (NSNotFound == ([[planDic allKeys] indexOfObject:plan.stageMaster])) {
                [planDic setObject:plan forKey:plan.stageMaster];
                [finalArray addObject:plan];
            }
        } else if ([obj isKindOfClass:[LCTourpic class]]) {
            LCTourpic *tourpic = (LCTourpic *)obj;
            if (NSNotFound == ([[tourpicDic allKeys] indexOfObject:tourpic.guid])) {
                [tourpicDic setObject:tourpic forKey:tourpic.guid];
                [finalArray addObject:tourpic];
            }
        } else if ([obj isKindOfClass:[LCUserModel class]]) {
            LCUserModel *user = (LCUserModel *)obj;
            if (NSNotFound == ([[userDic allKeys] indexOfObject:user.uUID])) {
                [userDic setObject:user forKey:user.uUID];
                [finalArray addObject:user];
            }
        } else {
            //不是三种模型的也要加进去？
            [finalArray addObject:obj];
        }
    }
    return finalArray;
}

+ (void)updateButtonTextImageRight:(UIButton *)btn withSpacing:(CGFloat)spacing {
    /// 文字和图片的距离.
//    CGFloat spacing = 6.0;
    // 图片右移(图片在文字右侧)
    CGSize imageSize = btn.imageView.frame.size;
//    btn.titleLabel.backgroundColor = [UIColor redColor];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width * 2 - spacing, 0.0, 0.0);
    // 文字左移
    CGSize titleSize = btn.titleLabel.frame.size;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleSize.width * 2 - spacing);
}



- (UIView *)getGrayView {
    static UIView * grayView;
    static dispatch_once_t onceToken;
    if (!grayView) {
        _dispatch_once(&onceToken, ^{
            grayView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT, DEVICE_WIDTH, DEVICE_HEIGHT)];
            grayView.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeGrayViewfromSuperview)];
            [grayView addGestureRecognizer:tap];
            UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(removeGrayViewfromSuperview)];
            [grayView addGestureRecognizer:swipe];
        });
    }
    return grayView;
}

- (void)removeGrayViewfromSuperview{
    [[self getGrayView] removeFromSuperview];
    /// 键盘缩回去
    if ([LCSharedFuncUtil sharedInstance].delegate && [[LCSharedFuncUtil sharedInstance].delegate respondsToSelector:@selector(hideKeyboard)]) {
        [[LCSharedFuncUtil sharedInstance].delegate hideKeyboard];
    }
    
}

//允许多个手势混搭
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
@end

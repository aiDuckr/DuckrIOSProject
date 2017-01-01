//
//  SystemPermissionUtil.m
//  LinkCity
//
//  Created by 张宗硕 on 4/8/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCSystemPermissionUtil.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation LCSystemPermissionUtil

+ (BOOL)isHaveAlbumPermission {
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusAuthorized) {
        return YES;
    } else {
        [YSAlertUtil alertTwoButton:@"取消" btnTwo:@"开启相册访问" withTitle:@"相册访问权限未开启" msg:@"相册开启后才能存储小视频。" callBack:^(NSInteger chooseIndex) {
            if (chooseIndex == 0 ){
                return ;
            } else if (chooseIndex == 1) {
                [[UIApplication sharedApplication] openURL:[ NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                //@"prefs:root=LOCATION_SERVICES"]];
                //UIApplicationOpenSettingsURLString
            }
        }];

        //[YSAlertUtil tipOneMessage:@"无法打开相册，请去设置-达客旅行中开启照片访问。"];
        return NO;
    }
}

+ (BOOL)isHaveCameraPermission {
    BOOL isAllow = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusAuthorized) {
        isAllow = YES;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                
            } else {
                return ;
            }
        }];
        isAllow = NO;
    } else if (authStatus == AVAuthorizationStatusDenied) {
        [YSAlertUtil alertTwoButton:@"取消" btnTwo:@"开启摄像头" withTitle:@"相机访问未开启" msg:@"相机开启后才能录制小视频。" callBack:^(NSInteger chooseIndex) {
            if (chooseIndex == 0 ){
                return ;
            } else if (chooseIndex == 1) {
                 [[UIApplication sharedApplication] openURL:[ NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"]];
            }
        }];

        isAllow = NO;
    } else {
        isAllow = NO;
    }
    return isAllow;
}

+ (void)isHaveVoicePermission:(void(^)(BOOL isHavePermission))callBack {
    //AVAudioSession *avSession = [AVAudioSession sharedInstance];
    
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                NSLog(@"允许使用麦克风！");
            } else {
                [YSAlertUtil alertTwoButton:@"取消" btnTwo:@"开启麦克风" withTitle:@"麦克风访问未开启" msg:@"麦克风开启后才能录制小视频。" callBack:^(NSInteger chooseIndex) {
                    if (chooseIndex == 0 ){
                        return ;
                    } else if (chooseIndex == 1) {
                        [[UIApplication sharedApplication] openURL:[ NSURL URLWithString:@"prefs:root=Privacy&path=MICROPHONE"]];
                        //[[UIApplication sharedApplication] openURL:[ NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                        //@"prefs:root=LOCATION_SERVICES"]];
                        //UIApplicationOpenSettingsURLString
                    }
                }];
                //[YSAlertUtil tipOneMessage:@"未打开麦克风访问权限，请去设置-达客旅行中开启麦克风访问。"];
                NSLog(@"不允许使用麦克风！");
            }
            callBack(granted);
        }];
    }
    //return NO;
}

#pragma mark - Setup Location Sevice

+ (void)isHaveLocationServicePermission:(BOOL)isSettingURL withText:(NSString *)text {
    [YSAlertUtil alertTwoButton:@"取消" btnTwo:@"开启定位" withTitle:@"定位服务未开启" msg:text callBack:^(NSInteger chooseIndex) {
        if (chooseIndex == 0 ){
            return;
        } else if (chooseIndex == 1) {
            if (isSettingURL) {
                [[UIApplication sharedApplication] openURL:[ NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
            } else {
                [[UIApplication sharedApplication] openURL:[ NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
            //return NO;
        }
    }];
}


//- (void)setUpUserLocation:(BOOL)isSettingURL {
//   }
@end

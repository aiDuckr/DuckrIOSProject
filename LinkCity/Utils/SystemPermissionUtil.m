//
//  SystemPermissionUtil.m
//  LinkCity
//
//  Created by 张宗硕 on 4/8/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "SystemPermissionUtil.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation SystemPermissionUtil

+ (BOOL)isHaveAlbumPermission {
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusAuthorized) {
        return YES;
    } else {
        [YSAlertUtil tipOneMessage:@"未打开相册访问权限，请去设置-达客旅行-照片中开启照片访问。"];
        return NO;
    }
}

+ (BOOL)isHaveCameraPermission {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
     if(authStatus == AVAuthorizationStatusAuthorized) {
         
         return YES;
     } else {
         [YSAlertUtil alertOneMessage:@"无法打开相机。请去设置-达客旅行打开照片访问。"];
         return NO;
     }
}

+ (void)isHaveVoicePermission:(void(^)(BOOL isHavePermission))callBack {
    //AVAudioSession *avSession = [AVAudioSession sharedInstance];
    
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                NSLog(@"允许使用麦克风！");
               
            }
            else {
                [YSAlertUtil tipOneMessage:@"未打开麦克风访问权限，请去设置-达客旅行中开启麦克风访问。"];
                NSLog(@"不允许使用麦克风！");
            }
             callBack(granted);
        }];
    }
    //return NO;
}
@end

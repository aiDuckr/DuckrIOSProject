//
//  SystemPermissionUtil.h
//  LinkCity
//
//  Created by 张宗硕 on 4/8/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
//to do:将提醒语句改为直接跳转到设置页的提醒弹框
@interface LCSystemPermissionUtil : NSObject

+(BOOL)isHaveCameraPermission;

+(BOOL)isHaveAlbumPermission;

+ (void)isHaveLocationServicePermission:(BOOL)isSettingURL withText:(NSString *)text;
/**
 * 获取是否有麦克风的权限
 */
+ (void)isHaveVoicePermission:(void(^)(BOOL isHavePermission)) callBack;
@end

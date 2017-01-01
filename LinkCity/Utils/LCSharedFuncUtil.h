//
//  LCSharedFuncUtil.h
//  LinkCity
//
//  Created by roy on 11/25/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@protocol LCSharedFuncUtilForGrayview;

@interface LCSharedFuncUtil : NSObject<UIGestureRecognizerDelegate>
+ (AppDelegate *)getAppDelegate;
+ (void)quitLoginApp;
+ (UINavigationController *)getTopMostNavigationController;
+ (UIViewController *)getTopMostViewController;
+ (UIViewController *)getRootViewController;
+ (void)dialPhoneNumber:(NSString *)phoneNumber;
+ (void)sendMessage:(NSString *)message;
+ (void)gotoAppDownloadPage;
+ (LCSharedFuncUtil *)sharedInstance;
- (UIView *)getGrayView;
- (void)removeGrayViewfromSuperview;
+ (id)decodeObjectFromJsonString:(NSString *)jsonString;

+ (NSString *)getDevicePlatform;
+ (NSString *)getIdfa;
+ (NSString *)getIMEI;
+ (NSString *)getMacAddress;
+ (NSString *)getScreenResolution;
+ (NSString *)getCPUType;
+ (NSString *)getDeviceName;
+ (NSString *)getDeviceModel;
+ (UIView *)getGrayView;
+ (NSString *)classNameOfClass:(Class)theClass;
+ (CGFloat)adaptBy6sHeightForAllDevice:(CGFloat)heightFor6s;
+ (CGFloat)adaptBy6sWidthForAllDevice:(CGFloat)widthFor6s;

+ (void)updateButtonTextImageRight:(UIButton *)btn withSpacing:(CGFloat)spacing;

/// 支持Array含有plan，user，tourpic
+ (NSArray *)addFiltedArrayToArray:(NSArray *)sourceArray withUnfiltedArray:(NSArray *)destArray;
@property (nonatomic, assign) id<LCSharedFuncUtilForGrayview> delegate;

@end

@protocol LCSharedFuncUtilForGrayview <NSObject>

- (void)hideKeyboard;

@end
//
//  LCPickOneImageHelper.h
//  LinkCity
//
//  Created by roy on 2/11/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCPickOneImageHelper : NSObject
+ (instancetype)sharedInstance;
- (void)pickImageFromAlbum:(BOOL)album camera:(BOOL)camera completion:(void(^)(UIImage *image))comp;
- (void)pickImageFromAlbum:(BOOL)album camera:(BOOL)camera allowEdit:(BOOL)allowEdit completion:(void(^)(UIImage *image))comp;
@end

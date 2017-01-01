//
//  LCPhotoScanner.h
//  LinkCity
//
//  Created by roy on 11/27/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCImageModel.h"

@interface LCPhotoScanner : LCBaseCollectionVC
@property (nonatomic,strong) NSArray *imageModels;
+ (instancetype)createInstance;
/**
 * 有URL使用
 */
- (void)showImageModels:(NSArray *)imageModels fromIndex:(NSInteger)index;
/**
 *有图片使用
 */
- (void)showImage:(NSArray *)imageArray fromIndex:(NSInteger)index;
@end

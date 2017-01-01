//
//  UIImage+Compress.h
//  JiaoYou
//
//  Created by Qihe Bian on 2012-11-08.
//  Copyright (c) 2012年 NetEase.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compress)
- (UIImage*)scaleToSize:(CGSize)size;
- (UIImage *)imageByScaleProportionalToSize: (CGSize)size;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage *)compressedImage;
@end

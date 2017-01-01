//
//  UIImage+Compress.m
//  JiaoYou
//
//  Created by Qihe Bian on 2012-11-08.
//  Copyright (c) 2012年 NetEase.com, Inc. All rights reserved.
//

#import "UIImage+Compress.h"

@implementation UIImage (Compress)
-(UIImage*)scaleToSize:(CGSize)size
{
  // Create a bitmap graphics context
  // This will also set it as the current context
//  UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);

  // Draw the scaled image in the current context
  [self drawInRect:CGRectMake(0, 0, size.width, size.height)];

  // Create a new image from current context
  UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();

  // Pop the current context from the stack
  UIGraphicsEndImageContext();
    
  NSData *imagedata = UIImageJPEGRepresentation(scaledImage, 1.0);
  UIImage *jpegImage = [UIImage imageWithData:imagedata];

  // Return our new scaled image
  return jpegImage;
}

- (UIImage *) imageByScaleProportionalToSize: (CGSize)size
{
  float widthRatio = size.width/self.size.width;
  float heightRatio = size.height/self.size.height;

  if(widthRatio > heightRatio)
  {
    size=CGSizeMake(self.size.width*heightRatio,self.size.height*heightRatio);
  } else {
    size=CGSizeMake(self.size.width*widthRatio,self.size.height*widthRatio);
  }

  return [self scaleToSize:size];
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
  UIImage *sourceImage = self;
  UIImage *newImage = nil;
  CGSize imageSize = sourceImage.size;
  CGFloat width = imageSize.width;
  CGFloat height = imageSize.height;
  CGFloat targetWidth = targetSize.width;
  CGFloat targetHeight = targetSize.height;
  CGFloat scaleFactor = 0.0;
  CGFloat scaledWidth = targetWidth;
  CGFloat scaledHeight = targetHeight;
  CGPoint thumbnailPoint = CGPointMake(0.0,0.0);

  if (CGSizeEqualToSize(imageSize, targetSize) == NO)
  {
    CGFloat widthFactor = targetWidth / width;
    CGFloat heightFactor = targetHeight / height;

    if (widthFactor > heightFactor)
      scaleFactor = widthFactor; // scale to fit height
    else
      scaleFactor = heightFactor; // scale to fit width
    scaledWidth  = width * scaleFactor;
    scaledHeight = height * scaleFactor;

    // center the image
    if (widthFactor > heightFactor)
    {
      thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
    }
    else
      if (widthFactor < heightFactor)
      {
        thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
      }
  }

//  UIGraphicsBeginImageContext(targetSize); // this will crop
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, [UIScreen mainScreen].scale);

  CGRect thumbnailRect = CGRectZero;
  thumbnailRect.origin = thumbnailPoint;
  thumbnailRect.size.width  = scaledWidth;
  thumbnailRect.size.height = scaledHeight;

  [sourceImage drawInRect:thumbnailRect];

  newImage = UIGraphicsGetImageFromCurrentImageContext();

  //pop the context to get back to the default
  UIGraphicsEndImageContext();
  return newImage;
}

- (UIImage *)compressedImage
{
  int size = 1024*1024/2;
  int current_size = 0;
  float actual_size = 0.0;

  NSData *imagedata = UIImageJPEGRepresentation(self, 1.0);
  current_size = [imagedata length];
  if (current_size > size) {
    actual_size = (float)((float)size/(float)current_size);
    imagedata = UIImageJPEGRepresentation(self, actual_size);
  }
  return [UIImage imageWithData:imagedata];
}
@end

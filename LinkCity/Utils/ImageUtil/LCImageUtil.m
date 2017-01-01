//
//  YSImageUtil.m
//  MissYou
//
//  Created by zzs on 14-6-24.
//  Copyright (c) 2014年 yunshuo. All rights reserved.
//

#import "LCImageUtil.h"
#import "UIImage+Compress.h"

@implementation LCImageUtil
+ (UIImage *)createScreenShot{
    UIGraphicsBeginImageContext([UIApplication sharedApplication].keyWindow.bounds.size);
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (UIImage *)roteImage:(UIImage*)src toOrientation:(NSInteger)orientation
{
    UIImage * portraitImage = [[UIImage alloc] initWithCGImage: src.CGImage
                                                         scale: 1.0
                                                   orientation: orientation];
    return portraitImage;
}

+ (NSData *)getImageDataFromUIImage:(UIImage *)image
{
    return UIImageJPEGRepresentation(image, 1.0);
    //    NSData *imageData = nil;
    //    // 将图片转换为JPG格式的二进制数据
    //    NSLog(@"come in PIC_QUALITY is %f", PIC_QUALITY);
    //    imageData = UIImageJPEGRepresentation(image, 1.0);
    //    return imageData;
}

+ (UIColor *)getColorFromColorStr:(NSString *)colorStr
{
    NSString *str = [colorStr stringByReplacingOccurrencesOfString:@"" withString:@" "];
    NSArray *arr = [str componentsSeparatedByString:@","];
    if (4 == arr.count)
    {
        return [UIColor colorWithRed:([arr[0] intValue]/255.0f) green:([arr[1] intValue]/255.0f) blue:([arr[2] intValue]/255.0f) alpha:([arr[3] intValue]/255.0f)];
    }
    return UIColorFromRGBA(COVER_DEFAULT_BG_COLOR, 1.0f);
}

+ (NSString *)getMostColorStr:(UIImage *)image
{
#pragma mark - NOTE: 牛逼啊，获取一张图片最多的颜色。
    
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(50, 50);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData(context);
    
    if (data == NULL) return nil;
    NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    for (int x=0; x<thumbSize.width; x++) {
        for (int y=0; y<thumbSize.height; y++) {
            
            int offset = 4*(x*y);
            
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha =  data[offset+3];
            
            NSArray *clr=@[@(red),@(green),@(blue),@(alpha)];
            [cls addObject:clr];
            
        }
    }
    CGContextRelease(context);
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    
    NSArray *MaxColor=nil;
    NSUInteger MaxCount=0;
    
    while ( (curColor = [enumerator nextObject]) != nil )
    {
        NSUInteger tmpCount = [cls countForObject:curColor];
        
        if ( tmpCount < MaxCount ) continue;
        
        MaxCount=tmpCount;
        MaxColor=curColor;
        
    }
    if (4 == MaxColor.count)
    {
        NSString *str = [NSString stringWithFormat:@"%@", MaxColor[0]];
        str = [NSString stringWithFormat:@"%@,%@", str, MaxColor[1]];
        str = [NSString stringWithFormat:@"%@,%@", str, MaxColor[2]];
        str = [NSString stringWithFormat:@"%@,%@", str, MaxColor[3]];
        return str;
    }
    return @"";
}

+ (UIImage *)getImageFromColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)blurWithCoreImage:(UIImage *)sourceImage withRect:(CGRect)rect pixel:(NSInteger)pixel
{
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    // Apply Affine-Clamp filter to stretch the image so that it does not
    // look shrunken when gaussian blur is applied
    CGAffineTransform transform = CGAffineTransformIdentity;
    CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    [clampFilter setValue:inputImage forKey:@"inputImage"];
    [clampFilter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    
    // Apply gaussian blur filter with radius of 30
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:clampFilter.outputImage forKey: @"inputImage"];
    [gaussianBlurFilter setValue:[NSNumber numberWithInteger:pixel] forKey:@"inputRadius"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:gaussianBlurFilter.outputImage fromRect:[inputImage extent]];
    
    // Set up output context.
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    
    // Invert image coordinates
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -rect.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, rect, cgImage);
    
    // Apply white tint
    CGContextSaveGState(outputContext);
    CGContextSetFillColorWithColor(outputContext, [UIColor clearColor].CGColor);
    CGContextFillRect(outputContext, rect);
    CGContextRestoreGState(outputContext);
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    /***
     Zzs 2015.1.18
     release the cgImage
     */
    CGImageRelease(cgImage);
    
    return outputImage;
}

+ (UIImage *)getCropImage:(UIImage *)image withRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *cropImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropImage;
}

+ (UIImage*)scaleImage:(UIImage*)image toSize:(CGSize)size
{
    /// 创建一个bitmap的context，并把它设置成为当前正在使用的context.
    UIGraphicsBeginImageContext(size);
    
    /// 绘制改变大小的图片.
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    /// 从当前context中创建一个改变大小后的图片.
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    /// 使当前的context出堆栈.
    UIGraphicsEndImageContext();
    
    /// 返回新的改变大小后的图片.
    return scaledImage;
}

+ (UIImage*)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    ZLog(@"the image size is %@", NSStringFromCGSize(image.size));
    CGSize desSize = CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize);
    UIImage *scaledImage = [LCImageUtil scaleImage:image toSize:desSize];
    ZLog(@"the scaledImage size is %@", NSStringFromCGSize(scaledImage.size));
    return scaledImage;
}

+ (UIImage *)getCenterImage:(UIImage *)image withRect:(CGRect)rect {
    UIImage *centerImage;
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    
    CGRect cutRect;
    if ((rect.size.width / rect.size.height) > (imageWidth / imageHeight)) {
        float height = (imageWidth * rect.size.height) / rect.size.width;
        cutRect.origin.x = 0;
        cutRect.origin.y = (imageHeight - height) / 2;
        cutRect.size.width = imageWidth;
        cutRect.size.height = height;
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cutRect);
        centerImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
    } else {
        float width = (rect.size.width * imageHeight) / rect.size.height;
        cutRect.origin.x = (imageWidth - width) / 2;
        cutRect.origin.y = 0;
        cutRect.size.width = width;
        cutRect.size.height = imageHeight;
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cutRect);
        centerImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
    }
    return centerImage;
}

+ (NSString *)getImageCategoryStringFromEnum:(ImageCategory)category{
    switch (category) {
        case ImageCategoryDefault:
            return @"default";
            break;
        case ImageCategoryAvatar:
            return @"avatar";
            break;
        case ImageCategoryCover:
            return @"cover";
            break;
        case ImageCategoryPlace:
            return @"place";
            break;
        case ImageCategoryPhoto:
            return @"photo";
            break;
        case ImageCategoryPlan:
            return @"plan";
            break;
        case ImageCategoryTourpic:
            return @"tourpic";
            break;
        case ImageCategoryChat:
            return @"chat";
            break;
        case ImageCategoryIdentity:
            return @"identity";
            break;
        case ImageCategoryCarProvider:
            return @"carprovider";
            break;
        case ImageCategoryTourGuide:
            return @"tourguide";
            break;
        case ImageCategoryVideo:
            return @"video";
            break;
    }
    return @"default";
}


+ (NSData *)getDataOfCompressImage:(UIImage *)image toSize:(NSInteger)maxImageSize {
    CGFloat compression = 1.0f;
    CGFloat maxCompression = 0.1;
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    LCLogInfo(@"CompressImage origion size:%lu",(unsigned long)[imageData length]);
    
    //压缩图片质量
    while ([imageData length] > maxImageSize && compression > maxCompression) {
        //compression quality 0.1最小，1最大，图片大小减小的情况是非线性的
        //这样最多尝试5次，质量还可以
        if (compression > 0.81) {
            compression = 0.79;
        }else if(compression > 0.61){
            compression = 0.59;
        }else if(compression > 0.11){
            compression = 0.09;
        }
        
        imageData = UIImageJPEGRepresentation(image, compression);
        LCLogInfo(@"CompressImage compression: %f，size:%lu",compression,(unsigned long)[imageData length]);
    }
    
    //压缩图片大小
    if ([imageData length] > maxImageSize) {
        float scale = 1.0 * maxImageSize / [imageData length];
        scale = powl(scale, 0.5);
        UIImage *scaledImage = [UIImage imageWithData:imageData];
        scaledImage = [LCImageUtil scaleImage:scaledImage toScale:scale];
        imageData = UIImageJPEGRepresentation(scaledImage, compression);
        scaledImage = nil;
        
        LCLogInfo(@"CompressImage scale: %f，size:%lu",scale,(unsigned long)[imageData length]);
    }
    
    
    return imageData;
}

+ (UIImage *)getImageOfCompressImage:(UIImage *)image toSize:(NSInteger)maxImageSize{
    NSData *compressedImageData = [LCImageUtil getDataOfCompressImage:image toSize:maxImageSize];
    return [UIImage imageWithData:compressedImageData];
}



+ (NSString *)getThumbImageUrlFromOrigionalImageUrl:(NSString *)origionalImageUrl{
    return [NSString stringWithFormat:@"%@?imageView2/2/w/200", origionalImageUrl];
}


+ (void)uploadVideoToQiniu:(NSString *)filePath completion:(void(^)(NSString *videoStr))comp {
    [LCImageUtil uploadFileToQiniu:filePath fileType:ImageCategoryVideo completion:comp];
}

+ (void)uploadFileToQiniu:(NSString *)filePath fileType:(ImageCategory)category completion:(void(^)(NSString *fileUrl))comp {
    [LCNetRequester getQiniuUploadTokenOfImageType:[LCImageUtil getImageCategoryStringFromEnum:category]
                                          callBack:^(NSString *uploadToken, NSString *picKey, NSError *error)
     {
         if (error) {
             LCLogWarn(@"get qiniu upload token error:%@",error);
             if (comp) {
                 comp(nil);
             }
             return;
         }
         
         picKey = [NSString stringWithFormat:@"%@.mp4", picKey];
         // did get qiniu upload token
         QNUploadManager *upManager = [[QNUploadManager alloc] init];
         [upManager putFile:filePath
                        key:picKey
                      token:uploadToken
                   complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp)
          {
              NSString *fileUrl = nil;
              if ([[resp allKeys] containsObject:@"key"]) {
                  NSString *key = [resp objectForKey:@"key"];
                  
                  /*
                   Server 中有记录邀约中的ImageUrls
                   ["http:\/\/download.duckr.cn\/(null)","http:\/\/download.duckr.cn\/(null)","http:\/\/download.duckr.cn\/(null)"]
                   因此检查  (null)
                   */
                  if ([LCStringUtil isNotNullString:key] &&
                      ![key isEqualToString:@"(null)"]) {
                      
                      fileUrl = [NSString stringWithFormat:@"%@%@", QINIU_VIDEO_DOMAIN, [resp objectForKey:@"key"]];
                  }
              }
              
              if (comp) {
                  comp(fileUrl);
              }
          }
                     option:nil];
     }];
}

+ (void)uploadImageToQinu:(UIImage *)img imageType:(ImageCategory)category completion:(void (^)(NSString *))comp{
    NSData *imgData = [LCImageUtil getImageDataFromUIImage:img];
    [LCImageUtil uploadImageDataToQinu:imgData imageType:category completion:comp];
}

+ (void)uploadImageDataToQinu:(NSData *)imgData imageType:(ImageCategory)category completion:(void (^)(NSString *))comp{
    [LCNetRequester getQiniuUploadTokenOfImageType:[LCImageUtil getImageCategoryStringFromEnum:category]
                                          callBack:^(NSString *uploadToken, NSString *picKey, NSError *error)
     {
         if (error) {
             LCLogWarn(@"get qiniu upload token error:%@",error);
             if (comp) {
                 comp(nil);
             }
             return;
         }
         
         // did get qiniu upload token
         QNUploadManager *upManager = [[QNUploadManager alloc] init];
         [upManager putData:imgData
                        key:picKey
                      token:uploadToken
                   complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp)
          {
              NSString *imageUrlStr = nil;
              if ([[resp allKeys] containsObject:@"key"]) {
                  NSString *key = [resp objectForKey:@"key"];
                  
                  /*
                   Server 中有记录邀约中的ImageUrls
                   ["http:\/\/download.duckr.cn\/(null)","http:\/\/download.duckr.cn\/(null)","http:\/\/download.duckr.cn\/(null)"]
                   因此检查  (null)
                   */
                  if ([LCStringUtil isNotNullString:key] &&
                      ![key isEqualToString:@"(null)"]) {
                      
                      imageUrlStr = [NSString stringWithFormat:@"%@%@", QINIU_DOMAIN, [resp objectForKey:@"key"]];
                  }
              }
              
              if (comp) {
                  comp(imageUrlStr);
              }
          }
                     option:nil];
     }];
}

+ (void)compressImagesWithData:(NSArray *)originArray complete:(void (^)(NSArray *compressArray))complete
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *result = [NSMutableArray array];
        for (UIImage *originImage in originArray) {
            //UIImage *originImage = [dic objectForKey:UIImagePickerControllerOriginalImage];
            NSData *compressData = [self compressImage:originImage];
            [result addObject:compressData];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(result);
        });
    });
}
+ (NSData *)compressImage:(UIImage *)originImage
{
    // NTESJYAppDelegate *delegate = (NTESJYAppDelegate *)[UIApplication sharedApplication].delegate;
    UIImage *origin = originImage;
    NSData *compressData = nil;
    CGFloat factor = 1000000.0/(origin.size.width * origin.size.height);
    CGFloat compress = 0.5;
    //    if (delegate.isReachableViaWiFi) {
    //        factor = 2000000.0/(origin.size.width * origin.size.height);
    //        compress = 0.6;
    //    }
    
    if (factor < 1) {
        CGFloat targetWidth = origin.size.width * factor;
        CGFloat targetHeight = origin.size.height * factor;
        UIImage *compressImage = [origin imageByScaleProportionalToSize:CGSizeMake(targetWidth, targetHeight)];
        compressData = UIImageJPEGRepresentation(compressImage, compress);
    } else {
        compressData = UIImageJPEGRepresentation(origin, compress);
    }
    
    return compressData;
}



@end

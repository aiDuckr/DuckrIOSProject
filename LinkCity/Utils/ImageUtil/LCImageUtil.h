//
//  YSImageUtil.h
//  MissYou
//
//  Created by zzs on 14-6-24.
//  Copyright (c) 2014年 yunshuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/*
 Type: "default"    
 // 分类文件夹，avatar：头像，cover：计划封面，place：地点封面，photo：个人相册， plan: 新版发邀约配图，tourpic: 新版旅图配图，chat: 聊天配图，identity: 身份认证，carprovider: 司机认证，tourguide: 领队认证
 */
typedef enum : NSUInteger {
    ImageCategoryDefault = 0,
    ImageCategoryAvatar = 1,
    ImageCategoryCover,
    ImageCategoryPlace,
    ImageCategoryPhoto,
    ImageCategoryPlan,
    ImageCategoryTourpic,
    ImageCategoryChat,
    ImageCategoryIdentity,
    ImageCategoryCarProvider,
    ImageCategoryTourGuide,
    ImageCategoryVideo,
} ImageCategory;

typedef enum MERGE_DIRECTION {MERGE_RIGHT_DIRECTION, MERGE_DOWN_DIRECTION} MergeDirection;

@interface LCImageUtil : NSObject
+ (UIImage *)createScreenShot;

+ (UIImage *)fixOrientation:(UIImage *)aImage;
+ (UIImage *)roteImage:(UIImage*)src toOrientation:(NSInteger)orientation;
+ (UIColor *)getColorFromColorStr:(NSString *)colorStr;
+ (NSString *)getMostColorStr:(UIImage *)image;
+ (UIImage *)getImageFromColor:(UIColor *)color;

/**
 * @brief   放大缩小图像.
 *
 * @param   image   需要放大缩小的图像.
 * @param   size    放大缩小后的图片尺寸.
 *
 * @return  放大缩小后的图像.
 */
+ (UIImage*)scaleImage:(UIImage*)image toSize:(CGSize)size;

/**
 * @brief   按照比例放大缩小图像.
 *
 * @param   image       需要放大缩小的图像.
 * @param   scaleSize   放大的倍数.
 *
 * @return  放大缩小后的图像.
 */
+ (UIImage*)scaleImage:(UIImage *)image toScale:(float)scaleSize;

+ (UIImage *)getCenterImage:(UIImage *)image withRect:(CGRect)rect;

+ (UIImage *)getCropImage:(UIImage *)image withRect:(CGRect)rect;

/**
 @brief 毛玻璃化一张图片
 @param sourceImage
 @param rect    进行模糊的区域，一般传入imageView的bounds
 @param pixel  
 */
+ (UIImage *)blurWithCoreImage:(UIImage *)sourceImage withRect:(CGRect)rect pixel:(NSInteger)pixel;


+ (NSString *)getImageCategoryStringFromEnum:(ImageCategory)category;

+ (NSData *)getImageDataFromUIImage:(UIImage *)image;
+ (NSData *)getDataOfCompressImage:(UIImage *)image toSize:(NSInteger)maxImageSize;
+ (UIImage *)getImageOfCompressImage:(UIImage *)image toSize:(NSInteger)maxImageSize;

+ (NSString *)getThumbImageUrlFromOrigionalImageUrl:(NSString *)origionalImageUrl;

+ (void)uploadImageToQinu:(UIImage *)img imageType:(ImageCategory)category completion:(void(^)(NSString *imgUrl))comp;
+ (void)uploadImageDataToQinu:(NSData *)imgData imageType:(ImageCategory)category completion:(void(^)(NSString *imgUrl))comp;
+ (void)uploadVideoToQiniu:(NSString *)filePath completion:(void(^)(NSString *videoStr))comp;
+ (void)uploadFileToQiniu:(NSString *)filePath fileType:(ImageCategory)category completion:(void(^)(NSString *fileUrl))comp;
+ (void)compressImagesWithData:(NSArray *)originArray complete:(void (^)(NSArray *compressArray))complete;
@end

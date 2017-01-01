//
//  LCAFNBlurredImageView.m
//  LinkCity
//
//  Created by roy on 1/7/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCAFNBlurredImageView.h"

#define BLURED_CACHE_SUFFIX @"blurred_image_cache_suffix"

@interface UIImageView (_AFNetworking)
@property (readwrite, nonatomic, strong, setter = af_setImageRequestOperation:) AFHTTPRequestOperation *af_imageRequestOperation;
+ (NSOperationQueue *)af_sharedImageRequestOperationQueue;
@end

@implementation LCAFNBlurredImageView


#pragma mark - GET && SET
- (void)setImageType:(AFNImageType)imageType{
    objc_setAssociatedObject(self, @"AFNImageType", [NSNumber numberWithInteger:imageType], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    //如果已经被设置了URL，有了要显示的图片
    //更改显示类型后，重新显示
    if (self.imageURL) {
        [self setImageWithURL:self.imageURL];
    }
}
- (AFNImageType)imageType{
    NSNumber *numImageType = objc_getAssociatedObject(self, @"AFNImageType");
    if (!numImageType) {
        return AFNImageTypeNormal;
    }
    
    NSInteger intImageType = [numImageType integerValue];
    if (intImageType == 1) {
        return AFNImageTypeBlurredShowNormal;
    }else if(intImageType == 2){
        return AFNImageTypeBlurredShowBlured;
    }else{
        return AFNImageTypeNormal;
    }
}
- (void)setImageURL:(NSURL *)imageURL{
    objc_setAssociatedObject(self, @"AFNImageURL", imageURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSURL *)imageURL{
    return objc_getAssociatedObject(self, @"AFNImageURL");
}



- (NSURLRequest *)getBlurredRequestFromNormal:(NSURLRequest *)request{
    //NSLog(@"OrigionRequest:%@",[[request URL]absoluteString]);
    NSString *urlString = request.URL.absoluteString;
    urlString = [urlString stringByAppendingString:BLURED_CACHE_SUFFIX];
    NSURL *blurredURL = [NSURL URLWithString:urlString];
    NSURLRequest *retRequest = [NSURLRequest requestWithURL:blurredURL];
    //NSLog(@"retRequest:%@",[[retRequest URL]absoluteString]);
    return retRequest;
}



#pragma mark - Override
- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    self.imageURL = urlRequest.URL;
    
    [self cancelImageRequestOperation];
    
    UIImage *cachedImage = nil;
    switch (self.imageType) {
        case AFNImageTypeNormal:
            cachedImage = [[[self class] sharedImageCache] cachedImageForRequest:urlRequest];
            break;
        case AFNImageTypeBlurredShowNormal:
            cachedImage = [[[self class] sharedImageCache] cachedImageForRequest:urlRequest];
            break;
        case AFNImageTypeBlurredShowBlured:
            cachedImage = [[[self class] sharedImageCache] cachedImageForRequest:[self getBlurredRequestFromNormal:urlRequest]];
            break;
        default:
            break;
    }
    
    if (cachedImage) {
        if (success) {
            success(nil, nil, cachedImage);
        } else {
            self.image = cachedImage;
        }
        
        self.af_imageRequestOperation = nil;
    } else {
        if (placeholderImage) {
            self.image = placeholderImage;
        }
        
        __weak __typeof(self)weakSelf = self;
        self.af_imageRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        self.af_imageRequestOperation.responseSerializer = self.imageResponseSerializer;
        [self.af_imageRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            UIImage *img = responseObject;
            
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            [[[strongSelf class] sharedImageCache] cacheImage:img forRequest:urlRequest];
            if ([[urlRequest URL] isEqual:[strongSelf.af_imageRequestOperation.request URL]]) {
                switch (strongSelf.imageType) {
                    case AFNImageTypeNormal:
                        if (success) {
                            success(urlRequest, operation.response, img);
                        } else if (responseObject) {
                            strongSelf.image = img;
                        }
                        break;
                    case AFNImageTypeBlurredShowNormal:
                    {
                        UIImage *blurredImg = [LCImageUtil blurWithCoreImage:responseObject withRect:CGRectMake(0, 0, DEVICE_WIDTH, (DEVICE_WIDTH * 18.0f) / 25.0f) pixel:BLUR_IMAGE_PIXEL];
                        [[[strongSelf class] sharedImageCache] cacheImage:blurredImg forRequest:[strongSelf getBlurredRequestFromNormal:urlRequest]];
                        if (success) {
                            success(urlRequest, operation.response, img);
                        } else if (responseObject) {
                            strongSelf.image = blurredImg;
                        }
                    }
                        break;
                    case AFNImageTypeBlurredShowBlured:
                    {
                        UIImage *blurredImg = [LCImageUtil blurWithCoreImage:responseObject withRect:CGRectMake(0, 0, DEVICE_WIDTH, (DEVICE_WIDTH * 18.0f) / 25.0f) pixel:BLUR_IMAGE_PIXEL];
                        [[[strongSelf class] sharedImageCache] cacheImage:blurredImg forRequest:[strongSelf getBlurredRequestFromNormal:urlRequest]];
                        if (success) {
                            success(urlRequest, operation.response, blurredImg);
                        } else if (responseObject) {
                            strongSelf.image = blurredImg;
                        }
                    }
                        break;
                }
                
                if (operation == strongSelf.af_imageRequestOperation){
                    strongSelf.af_imageRequestOperation = nil;
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if ([[urlRequest URL] isEqual:[strongSelf.af_imageRequestOperation.request URL]]) {
                if (failure) {
                    failure(urlRequest, operation.response, error);
                }
                
                if (operation == strongSelf.af_imageRequestOperation){
                    strongSelf.af_imageRequestOperation = nil;
                }
            }
            
            strongSelf.image = nil;
        }];
        
        [[[self class] af_sharedImageRequestOperationQueue] addOperation:self.af_imageRequestOperation];
    }
}

@end

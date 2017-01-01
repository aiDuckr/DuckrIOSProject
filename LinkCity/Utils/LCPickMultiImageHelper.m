//
//  LCPickMultiImageHelper.m
//  LinkCity
//
//  Created by Roy on 8/7/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPickMultiImageHelper.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "LinkCity-Swift.h"

@interface LCPickMultiImageHelper()

@property (nonatomic, assign) NSInteger maxImageNum;
@property (nonatomic, strong) void(^comp)(NSArray *);


@property (nonatomic, strong) PHImageRequestOptions *requestOptions;
@property (nonatomic, strong) NSMutableArray *pickedImageArr;

@end



@implementation LCPickMultiImageHelper

+ (instancetype)sharedInstance{
    static LCPickMultiImageHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LCPickMultiImageHelper alloc] init];
    });
    
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.requestOptions = [[PHImageRequestOptions alloc] init];
        self.requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
        self.requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    }
    return self;
}


- (void)pickImageWithMaxNum:(NSInteger)num completion:(void (^)(NSArray *))comp{
    self.maxImageNum = num;
    self.comp = comp;
    self.pickedImageArr = [NSMutableArray new];
    __weak typeof(self) weakSelf = self;
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // TODO: yhy   remove inface of CTAssetsPickerControllerDelegate
            DKImagePickerController *pickerController = [DKImagePickerController new];
            pickerController.maxSelectableCount = num;
            pickerController.assetType = DKImagePickerControllerAssetTypeAllPhotos;
            pickerController.showsCancelButton = NO;
            pickerController.showsEmptyAlbums = YES;
            pickerController.allowMultipleTypes = YES;
            pickerController.defaultSelectedAssets = @[];
            pickerController.sourceType = DKImagePickerControllerSourceTypeBoth;
            [pickerController setDidSelectAssets:^(NSArray * __nonnull assets) {
                LCLogInfo(@"didSelectAssets");
                // TODO assets  see DKImageManager/Data/Model/DKAsset.swift
             
                __block NSInteger correctAssetCount = assets.count;
                for (DKAsset *asset in assets){
                    [weakSelf getUIImageFromDKAsset:asset result:^(UIImage *image, NSDictionary *info) {
                        if (image) {
                            [weakSelf.pickedImageArr addObject:image];
                        }else{
                            correctAssetCount--;
                        }
                        
                        if (weakSelf.pickedImageArr.count == correctAssetCount) {
                            if (weakSelf.comp) {
                                weakSelf.comp(weakSelf.pickedImageArr);
                            }
                        }
                    }];
                }
            }];
            
            [[LCSharedFuncUtil getTopMostViewController] presentViewController:pickerController animated:YES completion:nil];
        });
    }];
}

#pragma mark Deal with image Asset
- (void)getUIImageFromDKAsset:(DKAsset *)asset result:(void(^)(UIImage *image, NSDictionary *info))resultHandler{
    if ([asset isKindOfClass:[DKAsset class]]) {
        DKAsset *ass = (DKAsset *)asset;
        [ass fetchOriginalImage:YES completeBlock:^(UIImage *image, NSDictionary *info) {
            resultHandler(image, nil);
        }];
    }
}

@end

//
//  LCUserAlbumImageView.h
//  LinkCity
//
//  Created by roy on 11/27/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "EGOImageView.h"
#import "LCImageUtil.h"
#import "QiniuSDK.h"
#import "LCUserApi.h"

@class LCUserAlbumImageView;
@protocol LCUserAlbumImageDelegate <NSObject,EGOImageViewDelegate>
@optional
//- (void)userAlbumImageViewDidPickImage:(LCUserAlbumImageView *)albumView;
- (void)userAlbumImageViewDidTapped:(LCUserAlbumImageView *)albumView;
- (void)userAlbumImageViewDidPreprocessImage:(LCUserAlbumImageView *)albumView;
- (void)userAlbumImageViewDidUploadImageToQiniu:(LCUserAlbumImageView *)albumView withError:(NSError *)error;
- (void)userAlbumImageViewAddImageToServer:(LCUserAlbumImageView *)albumView withError:(NSError *)error;
@end



@interface LCUserAlbumImageView : EGOImageView<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,LCUserApiDelegate>
@property (nonatomic,weak) id<LCUserAlbumImageDelegate> delegate;

@property (nonatomic,strong) UIImage *preprocessedImage;
@property (nonatomic,strong) NSData *preprocessedImageData;
@property (nonatomic,strong) NSString *imageType; //png, jpg
@property (nonatomic,strong) NSString *imageURLOfQiNiu;
@property (nonatomic,assign) ImageCategory imageCategory; //avatar, userphoto etc.
@property (nonatomic,strong) UIActivityIndicatorView *activityView;

- (void)showAddPhotoActionSheet;
@end
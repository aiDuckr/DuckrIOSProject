//
//  LCUserInfoPageAlbumCell.m
//  LinkCity
//
//  Created by roy on 11/23/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCUserInfoPageAlbumCell.h"
#import "YSAlbumImageView.h"
#import "LCUserApi.h"
#import "YSAlertUtil.h"

@interface LCUserInfoPageAlbumCell()<LCUserAlbumImageDelegate,LCUserApiDelegate>
@property (nonatomic,strong) UILongPressGestureRecognizer *longPressGesture;
@end
@implementation LCUserInfoPageAlbumCell

- (void)awakeFromNib{
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.imageView.delegate = self;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.userInteractionEnabled = YES;
    
    self.longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressed:)];
    [self.imageView addGestureRecognizer:self.longPressGesture];
}
- (void)showAddPhoto{
    self.imageView.contentMode = UIViewContentModeCenter;
    self.imageView.imageURL = nil;
    self.imageModel = nil;
    self.imageView.image = [UIImage imageNamed:@"UserUploadPhoto"];
}
- (void)showImage:(LCImageModel *)imageModel{
    self.imageView.image = nil;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageModel = imageModel;
    self.imageView.imageURL = [NSURL URLWithString:imageModel.imageUrlThumb];
}

- (void)longPressed:(UILongPressGestureRecognizer *)sender{
    NSLog(@"%d",sender.state);
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(userInfoPageAlbumCellDidLongPressed:)]) {
            [self.delegate userInfoPageAlbumCellDidLongPressed:self];
        }
    }
}
#pragma mark - YSAlbumImageView Delegate
- (void)imageViewReadyImage:(UIImage *)image {
    self.imageView.image = nil;
    self.imageView.imageURL = [NSURL URLWithString:@""];
    self.imageView.image = image;
}
- (void)imageViewReadyUploadURL:(YSAlbumImageView *)imageView{
    RLog(@"did upload image to qiniu %@",imageView.uploadImageURL);
    LCUserApi *userApi = [[LCUserApi alloc]initWithDelegate:self];
    [userApi addUserPhotoWithImageURL:imageView.uploadImageURL];
}

#pragma mark - LCUserAlbumImageDelegate
- (void)userAlbumImageViewDidTapped:(LCUserAlbumImageView *)albumView{
    RLog(@"userAlbumImageViewDidTapped");
    if (self.imageModel) {
        //showing image, then show big photo
    }else{
        //showing add photo, then show action sheet
        [albumView showAddPhotoActionSheet];
    }
}
- (void)userAlbumImageViewDidPreprocessImage:(LCUserAlbumImageView *)albumView{
    RLog(@"userAlbumImageViewDidPreprocessImage");
}
- (void)userAlbumImageViewDidUploadImageToQiniu:(LCUserAlbumImageView *)albumView withError:(NSError *)error{
    RLog(@"userAlbumImageViewDidUploadImageToQiniu");
}
- (void)userAlbumImageViewAddImageToServer:(LCUserAlbumImageView *)albumView withError:(NSError *)error{
    RLog(@"userAlbumImageViewAddImageToServer");
}

#pragma mark - LCUserApi Delegate
- (void)userApi:(LCUserApi *)userApi didAddPhotoWithError:(NSError *)error{
    if (error) {
        RLog(@"add photo to server failed. %@",error);
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }else{
        RLog(@"Add photo to server succeed!");
    }
}
@end

//
//  LCUserAlbumImageView.m
//  LinkCity
//
//  Created by roy on 11/27/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCUserAlbumImageView.h"
#import "LCCommonApi.h"

@interface LCUserAlbumImageView()<LCCommonApiDelegate>

@end

@implementation LCUserAlbumImageView



@synthesize preprocessedImage;
@synthesize preprocessedImageData;
@synthesize imageType; //png, jpg
@synthesize imageURLOfQiNiu;
@synthesize imageCategory; //avatar, userphoto etc.

#pragma mark - LifeCycle
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

#pragma mark - Public Interface
- (void)showAddPhotoActionSheet{
    UIActionSheet *choiceSheet = nil;
    choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:self
                                     cancelButtonTitle:@"取消"
                                destructiveButtonTitle:nil
                                     otherButtonTitles:@"拍照", @"从相册中选取", nil];
    
    [choiceSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)setup
{
    preprocessedImage = nil;
    imageCategory = ImageCategoryUserPhoto;
//    self.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
//    [self addGestureRecognizer:tap];
    
    self.activityView = [[UIActivityIndicatorView alloc]initWithFrame:self.bounds];
    self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.activityView stopAnimating];
    [self addSubview:self.activityView];
}

- (void)tapped:(UITapGestureRecognizer *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(userAlbumImageViewDidTapped:)]) {
        [self.delegate userAlbumImageViewDidTapped:self];
    }
}

#pragma mark - UIActionSheet Delegate
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subViwe in actionSheet.subviews) {
        if ([subViwe isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subViwe;
            [button setTitleColor:UIColorFromRGBA(BUTTON_TITLE_COLOR, 1.0) forState:UIControlStateNormal];
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger index = 0;
    
    if (buttonIndex == index)
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        //controller.allowsEditing = YES;
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.delegate = self;
        [[self viewController] presentViewController:controller
                                            animated:YES
                                          completion:nil];
    }
    else if (buttonIndex == index + 1)
    {
        // 从相册中选取
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        //controller.allowsEditing = YES;
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.delegate = self;
        [[self viewController] presentViewController:controller
                                            animated:YES
                                          completion:nil];
    }
}
#pragma mark - ImagePickerController Delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[self viewController] dismissViewControllerAnimated:YES completion:NULL];
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    [self.activityView startAnimating];
    
    preprocessedImage = nil;
    imageURLOfQiNiu = @"";
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([LCStringUtil isNotNullString:mediaType] && [mediaType isEqualToString:@"public.image"])
    {
        preprocessedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        preprocessedImage = [LCImageUtil scaleImage:preprocessedImage toScale:SCALE_VALUE];
        self.image = [LCImageUtil getCenterImage:preprocessedImage withRect:self.frame];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            imageType = PIC_JPG_TYPE;
            // 将图片转换为JPG格式的二进制数据
            NSLog(@"come in PIC_QUALITY is %f", PIC_QUALITY);
            preprocessedImageData = UIImageJPEGRepresentation(self.image, PIC_QUALITY);
            
            // 通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(userAlbumImageViewDidPreprocessImage:)])
                {
                    [self.delegate userAlbumImageViewDidPreprocessImage:self];
                }
            });
            [self uploadImageToQiniu];
        });
    }
    [picker dismissViewControllerAnimated:APP_ANIMATION completion:nil];
}

#pragma mark - Network Function
- (void)uploadImageToQiniu
{
    LCCommonApi *api = [[LCCommonApi alloc] initWithDelegate:self];
    NSDictionary *dic = @{@"Type":[LCImageUtil getImageCategoryStringFromEnum:imageCategory]};
    [api getQiniuUploadToken:dic];
}

- (void)commonApi:(LCCommonApi *)api didGetQiniuUploadToken:(NSString *)uploadToken picKey:(NSString *)key withError:(NSError *)error
{
    if (!error)
    {
        NSString *uploadTokenStr = uploadToken;
        NSString *picKey = key;
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        [upManager putData:preprocessedImageData key:picKey
                     token:uploadTokenStr
                  complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp)
        {
             RLog(@"the info is %@", info);
             RLog(@"the resp is %@", resp);
             self.imageURLOfQiNiu = [NSString stringWithFormat:@"%@%@", QINIU_DOMAIN, [resp objectForKey:@"key"]];
             RLog(@"upload url is %@", self.imageURLOfQiNiu);
             if ([LCStringUtil isNotNullString:self.imageURLOfQiNiu] &&
                 self.delegate &&
                 [self.delegate respondsToSelector:@selector(userAlbumImageViewDidUploadImageToQiniu:withError:)])
             {
                 [self.delegate userAlbumImageViewDidUploadImageToQiniu:self withError:nil];
                 [self addImageToUserAlbum];
             }
         }
                    option:nil];
    }
    else
    {
        [YSAlertUtil tipOneMessage:@"上传图片出错!" delay:TIME_FOR_ERROR_TIP];
    }
}

- (void)addImageToUserAlbum{
    LCUserApi *userApi = [[LCUserApi alloc]initWithDelegate:self];
    [userApi addUserPhotoWithImageURL:imageURLOfQiNiu];
}

- (void)userApi:(LCUserApi *)userApi didAddPhotoWithError:(NSError *)error{
    [self.activityView stopAnimating];
    
    if (error) {
        RLog(@"add image to userAlbum failed. %@",error);
    }else{
        RLog(@"add image to userAlbum succeed!");
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(userAlbumImageViewAddImageToServer:withError:)]) {
        [self.delegate userAlbumImageViewAddImageToServer:self withError:error];
    }
}
#pragma mark - Inner Function
- (UIViewController *)viewController
{
    /// Finds the view's view controller.
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    // If the view controller isn't found, return nil.
    return nil;
}
@end

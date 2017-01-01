//
//  LCPickAndUploadImageView.m
//  LinkCity
//
//  Created by roy on 2/6/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPickAndUploadImageView.h"
#import "QNUploadManager.h"

@interface LCPickAndUploadImageView()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) NSString *uploadedImageURL;
@end


@implementation LCPickAndUploadImageView

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)didTap:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickImageDidTaped:)]) {
        [self.delegate pickImageDidTaped:self];
    }
    UIActionSheet *pickImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
    [pickImageSheet showInView:[UIApplication sharedApplication].delegate.window];
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subViwe in actionSheet.subviews) {
        if ([subViwe isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subViwe;
            [button setTitleColor:UIColorFromRGBA(BUTTON_TITLE_COLOR, 1.0) forState:UIControlStateNormal];
        }
    }
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)viewController {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    
    return result;
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickSheetClicked:atIndex:)]) {
        [self.delegate pickSheetClicked:self atIndex:buttonIndex];
    }
    NSInteger index = 0;
    
    if (buttonIndex == index) {
        //拍照
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.allowsEditing = YES;
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.delegate = self;
        [[self viewController] presentViewController:controller
                                            animated:YES
                                          completion:nil];
    } else if (buttonIndex == index + 1) {
        //从相册中选取
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.allowsEditing = YES;
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.delegate = self;
        [[self viewController] presentViewController:controller
                                            animated:YES
                                          completion:nil];
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickSheetClicked:atIndex:)]) {
        [self.delegate pickSheetClicked:self atIndex:-1];
    }
}

#pragma UIImagePicker Delegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([LCStringUtil isNotNullString:mediaType] && [mediaType isEqualToString:@"public.image"]) {
        UIImage *origionImage = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImage *compressedImage = [LCImageUtil getImageOfCompressImage:origionImage toSize:MAX_IMAGE_SIZE_TO_UPLOAD];
        NSData *imageDataToUpload = UIImageJPEGRepresentation(compressedImage, PIC_QUALITY);
        
        [self setImageWithURL:[NSURL URLWithString:@""] placeholderImage:compressedImage];
        
        if ([self.delegate respondsToSelector:@selector(pickAndUploadImageView:didPickImage:)]) {
            [self.delegate pickAndUploadImageView:self didPickImage:origionImage];
        }
        
        [self uploadImageToQiniu:imageDataToUpload];
    }
    [picker dismissViewControllerAnimated:APP_ANIMATION completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(dissmissPickViewController:)]) {
        [self.delegate dissmissPickViewController:self];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [[self viewController] dismissViewControllerAnimated:YES completion:NULL];
    if (self.delegate && [self.delegate respondsToSelector:@selector(dissmissPickViewController:)]) {
        [self.delegate dissmissPickViewController:self];
    }
}


#pragma mark Upload Image
- (void)uploadImageToQiniu:(NSData *)imageData{
    [LCNetRequester getQiniuUploadTokenOfImageType:[LCImageUtil getImageCategoryStringFromEnum:self.imageCategory]
                                          callBack:^(NSString *uploadToken, NSString *picKey, NSError *error)
     {
         if (!error) {
             QNUploadManager *upManager = [[QNUploadManager alloc] init];
            
             [upManager putData:imageData
                            key:picKey
                          token:uploadToken
                       complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp)
              {
                  self.uploadedImageURL = [NSString stringWithFormat:@"%@%@", QINIU_DOMAIN, [resp objectForKey:@"key"]];
                  LCLogInfo(@"QiNiu upload info:%@\r\n resp:%@\r\n url:%@",info,resp,self.uploadedImageURL);
                  if ([LCStringUtil isNotNullString:self.uploadedImageURL] && [self.delegate respondsToSelector:@selector(pickAndUploadImageView:didUploadImage:withError:)]) {
                      [self.delegate pickAndUploadImageView:self didUploadImage:self.uploadedImageURL withError:nil];
                  }
              }
                         option:nil];
         } else {
             if ([self.delegate respondsToSelector:@selector(pickAndUploadImageView:didUploadImage:withError:)]) {
                 [self.delegate pickAndUploadImageView:self didUploadImage:nil withError:error];
             }
             [YSAlertUtil alertOneMessage:@"上传图片出错!"];
         }
     }];
}
@end

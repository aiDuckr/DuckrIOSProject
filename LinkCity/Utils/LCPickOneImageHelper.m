//
//  LCPickOneImageHelper.m
//  LinkCity
//
//  Created by roy on 2/11/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPickOneImageHelper.h"

@interface LCPickOneImageHelper()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) void(^comp)(UIImage *image);
@property (nonatomic, assign) BOOL allowEdit;
@end
@implementation LCPickOneImageHelper
+ (instancetype)sharedInstance{
    static LCPickOneImageHelper *staticInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[LCPickOneImageHelper alloc] init];
    });
    return staticInstance;
}

- (void)pickImageFromAlbum:(BOOL)album camera:(BOOL)camera completion:(void(^)(UIImage *image))comp{
    [self pickImageFromAlbum:album camera:camera allowEdit:NO completion:comp];
}
- (void)pickImageFromAlbum:(BOOL)album camera:(BOOL)camera allowEdit:(BOOL)allowEdit completion:(void(^)(UIImage *image))comp{
    self.allowEdit = allowEdit;
    
    self.comp = comp;
    
    
    if (album && camera) {
        UIActionSheet *pickImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
        [pickImageSheet showInView:[UIApplication sharedApplication].delegate.window];
    }else if(album){
        [self pickImageFromAlbum];
    }else if(camera){
        [self pickImageFromCamera];
    }
}

- (UIViewController *)rootViewController {
    return [LCSharedFuncUtil getTopMostViewController];
}

- (void)pickImageFromAlbum{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.allowsEditing = self.allowEdit;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    
    UIViewController *topMostVC = [LCSharedFuncUtil getTopMostViewController];
    [topMostVC presentViewController:controller
                                            animated:YES
                                          completion:nil];
}
- (void)pickImageFromCamera{
   
    
    
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusAuthorized) {
        // authorized
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.allowsEditing = self.allowEdit;
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.delegate = self;
        
        UIViewController *topMostVC = [LCSharedFuncUtil getTopMostViewController];
        [topMostVC presentViewController:controller
                                animated:YES
                              completion:nil];
    } else if(status == AVAuthorizationStatusDenied){
        // denied
        [YSAlertUtil alertOneMessage:@"无法打开相机。请去设置-隐私-相机-打开'达客旅行'权限"];
        return ;
    } else if(status == AVAuthorizationStatusRestricted){
        // restricted
    } else if(status == AVAuthorizationStatusNotDetermined){
        // not determined
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.allowsEditing = self.allowEdit;
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                controller.delegate = self;
                
                UIViewController *topMostVC = [LCSharedFuncUtil getTopMostViewController];
                [topMostVC presentViewController:controller
                                        animated:YES
                                      completion:nil];
            } else {
                return;
            }
        }];
    }
}

#pragma mark UIActionSheetDelegate
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subViwe in actionSheet.subviews) {
        if ([subViwe isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subViwe;
            [button setTitleColor:UIColorFromRGBA(BUTTON_TITLE_COLOR, 1.0) forState:UIControlStateNormal];
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //拍照
        [self pickImageFromCamera];
    } else if (buttonIndex == 1) {
        //从相册中选取
        [self pickImageFromAlbum];
    }
}
#pragma UIImagePicker Delegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    UIImage *img = nil;
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([LCStringUtil isNotNullString:mediaType] && [mediaType isEqualToString:@"public.image"]) {
        if (self.allowEdit) {
            img = [info objectForKey:UIImagePickerControllerEditedImage];
        }else{
            img = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.comp) {
        self.comp(img);
        self.comp = nil;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.comp) {
        self.comp(nil);
        self.comp = nil;
    }
}
@end

//
//  LCUploadPicButton.m
//  LinkCity
//
//  Created by roy on 3/12/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUploadPicButton.h"


@interface LCUploadPicButton()

@property (nonatomic, strong) UIActionSheet *pickImageActionSheet;
@end
@implementation LCUploadPicButton

//- (instancetype)init{
//    self = [super init];
//    if (self) {
//        [self commonInit];
//    }
//    return self;
//}
//- (id)initWithCoder:(NSCoder *)aDecoder{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        [self commonInit];
//    }
//    return self;
//}
//- (instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self commonInit];
//    }
//    return self;
//}
//
//- (void)commonInit{
//    [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//}
//
//- (void)buttonAction:(UIButton *)sender{
//    [self pickImage];
//}
//
//#pragma mark - PickImage
//- (void)pickImage{
//    
//    
//    if (!self.pickImageActionSheet) {
//        self.pickImageActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
//    }
//    [self.pickImageActionSheet showInView:[UIApplication sharedApplication].delegate.window];
//}
//- (void)pickImageFromAlbum{
//    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
//    controller.allowsEditing = YES;
//    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    controller.delegate = self;
//    
//    UIViewController *topMostVC = [LCSharedFuncUtil getTopMostViewController];
//    [topMostVC presentViewController:controller
//                            animated:YES
//                          completion:nil];
//    
//}
//- (void)pickImageFromCamera{
//    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
//    controller.allowsEditing = YES;
//    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
//    controller.delegate = self;
//    
//    UIViewController *topMostVC = [LCSharedFuncUtil getTopMostViewController];
//    [topMostVC presentViewController:controller
//                            animated:YES
//                          completion:nil];
//}
//- (void)didPickImage:(UIImage *)img{
//    if (img) {
//        self.imageState = ImageStateProcessing;
//        [self.avatarButton setImageForState:UIControlStateNormal withURL:nil placeholderImage:img];
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSData *imageDataToUpload = [LCImageUtil getDataOfCompressImage:img toSize:MAX_IMAGE_SIZE_TO_UPLOAD];
//            [LCImageUtil uploadImageDataToQinu:imageDataToUpload imageType:ImageCategoryPlace completion:^(NSString *imgUrl) {
//                if ([LCStringUtil isNullString:imgUrl]) {
//                    LCLogWarn(@"upload image failed");
//                    self.imageState = ImageStateFinish;
//                }else{
//                    self.imageState = ImageStateFinish;
//                    //这里都设为url，为了方便上传
//                    self.editingUser.avatarUrl = imgUrl;
//                    self.editingUser.avatarThumbUrl = imgUrl;
//                    LCLogInfo(@"Finish Upload Image: %@",imgUrl);
//                }
//                
//                //如果已经点过FinishButton，说明在上传图片过程中，用户点过FinishButton
//                //现在上传完成了，继续更新用户信息
//                if (self.haveClickFinishButton) {
//                    [self saveButtonAction];
//                }
//            }];
//        });
//    }
//}
//
//#pragma mark UIActionSheetDelegate
//- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
//{
//    for (UIView *subViwe in actionSheet.subviews) {
//        if ([subViwe isKindOfClass:[UIButton class]]) {
//            UIButton *button = (UIButton*)subViwe;
//            [button setTitleColor:UIColorFromRGBA(BUTTON_TITLE_COLOR, 1.0) forState:UIControlStateNormal];
//        }
//    }
//}
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (actionSheet == self.sexActionSheet) {
//        if (buttonIndex == 0) {
//            self.editingUser.sex = 1;
//            self.sexLabel.text = @"男";
//        }else if(buttonIndex == 1){
//            self.editingUser.sex = 2;
//            self.sexLabel.text = @"女";
//        }
//    }else if(actionSheet == self.pickImageActionSheet){
//        if (buttonIndex == 0) {
//            //拍照
//            [self pickImageFromCamera];
//        } else if (buttonIndex == 1) {
//            //从相册中选取
//            [self pickImageFromAlbum];
//        }
//    }
//}
//
//#pragma UIImagePicker Delegate
//-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
//    UIImage *img = nil;
//    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//    if([LCStringUtil isNotNullString:mediaType] && [mediaType isEqualToString:@"public.image"]) {
//        img = [info objectForKey:UIImagePickerControllerEditedImage];
//    }
//    [picker dismissViewControllerAnimated:YES completion:^{
//        
//    }];
//    
//    [self didPickImage:img];
//}
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}

@end

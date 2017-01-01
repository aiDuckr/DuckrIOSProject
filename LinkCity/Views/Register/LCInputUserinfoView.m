//
//  LCInputUserinfoView.m
//  LinkCity
//
//  Created by roy on 2/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCInputUserinfoView.h"
#import "LCPickOneImageHelper.h"
#import "KLCPopup.h"

typedef enum : NSUInteger {
    ImageStateOrigional,
    ImageStateProcessing,
    ImageStateFinish
} ImageState;

@interface LCInputUserinfoView()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, assign) BOOL sexIsMale;
@property (nonatomic, assign) ImageState imageState;
@property (nonatomic, retain) NSString *avatarImageURL;
@property (nonatomic, assign) BOOL haveClickFinishButton;
@end


@implementation LCInputUserinfoView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:@"LCRegisterAndLoginViews" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCInputUserinfoView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            LCInputUserinfoView *inputUserinfoView = (LCInputUserinfoView *)v;
            return inputUserinfoView;
        }
    }
    
    return nil;
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(320, 318);
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    //初始化性别为女
    self.sexIsMale = NO;
    self.imageState = ImageStateOrigional;
    self.haveClickFinishButton = NO;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tipGestureAction:)];
    [self addGestureRecognizer:tapGesture];
    
    [self updateShow];
}

- (void)updateShow{
    if (self.sexIsMale) {
        [self setSexButton:self.maleButton selected:YES];
        [self setSexButton:self.femaleButton selected:NO];
    }else{
        [self setSexButton:self.maleButton selected:NO];
        [self setSexButton:self.femaleButton selected:YES];
    }
}
- (void)setSexButton:(UIButton *)btn selected:(BOOL)selected{
    if (selected) {
        [btn setImage:[UIImage imageNamed:@"RegisterSexSelected"] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromR_G_B_A(112, 107, 102, 1) forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"RegisterSexDeselect"] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromR_G_B_A(168, 164, 160, 1) forState:UIControlStateNormal];
    }
}



- (IBAction)avatarButtonAction:(id)sender {
    [self pickImage];
}
- (IBAction)maleButtonAction:(id)sender {
    self.sexIsMale = YES;
    [self updateShow];
}
- (IBAction)famaleButtonAction:(id)sender {
    self.sexIsMale = NO;
    [self updateShow];
}
- (IBAction)livingPlaceButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(inputUserinfoViewDidClickLivingPlaceButton:)]) {
        [self.delegate inputUserinfoViewDidClickLivingPlaceButton:self];
    }
}

- (IBAction)finishButtonAction:(id)sender {
    
    if ([self checkInput]) {
        self.haveClickFinishButton = YES;
        
        
        [YSAlertUtil showHudWithHint:nil];
        if (self.imageState == ImageStateProcessing) {
            //等图片上传完
        }else{
            [self doUpdateUserInfo];
        }
    }
}
- (IBAction)passButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(inputUserinfoViewDidClickPass:)]) {
        [self.delegate inputUserinfoViewDidClickPass:self];
    }
}
- (IBAction)cancelButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(inputUserinfoViewDidClickCancel:)]) {
        [self.delegate inputUserinfoViewDidClickCancel:self];
    }
}

- (void)tipGestureAction:(id)sender{
    [self endEditing:YES];
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
        img = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    [self setMyPopupHide:NO];
    [self.nickTextField becomeFirstResponder];
    [self didPickImage:img];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self setMyPopupHide:NO];
    [self.nickTextField becomeFirstResponder];
}

#pragma mark Inner Function
// PopUp 在 window上， 会遮住present出来的ImagePicker
// 在present之前，不得不隐藏PopUp和键盘
// 在dismiss之后，再显示PopUp和键盘
- (void)setMyPopupHide:(BOOL)hide{
    UIView *popUpView = self;
    while (![popUpView isKindOfClass:[KLCPopup class]]) {
        popUpView = popUpView.superview;
    }
    
    popUpView.hidden = hide;
}

- (void)dismissKeyboard{
    [self.nickTextField resignFirstResponder];
    [self.livingPlaceTextField resignFirstResponder];
}


- (void)pickImage{
    [self endEditing:YES];
    UIActionSheet *pickImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
    [pickImageSheet showInView:[UIApplication sharedApplication].delegate.window];
}
- (void)pickImageFromAlbum{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.allowsEditing = YES;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    
    UIViewController *topMostVC = [LCSharedFuncUtil getTopMostViewController];
    [topMostVC presentViewController:controller
                            animated:YES
                          completion:nil];
    
    [self setMyPopupHide:YES];
    [self dismissKeyboard];
}
- (void)pickImageFromCamera{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.allowsEditing = YES;
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    
    UIViewController *topMostVC = [LCSharedFuncUtil getTopMostViewController];
    [topMostVC presentViewController:controller
                            animated:YES
                          completion:nil];
    
    [self setMyPopupHide:YES];
    [self dismissKeyboard];
}

- (void)didPickImage:(UIImage *)img{
    if (img) {
        self.imageState = ImageStateProcessing;
        [self.avatarButton setImageForState:UIControlStateNormal withURL:nil placeholderImage:img];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageDataToUpload = [LCImageUtil getDataOfCompressImage:img toSize:MAX_IMAGE_SIZE_TO_UPLOAD];
            [LCImageUtil uploadImageDataToQinu:imageDataToUpload imageType:ImageCategoryAvatar completion:^(NSString *imgUrl) {
                if ([LCStringUtil isNullString:imgUrl]) {
                    LCLogWarn(@"upload image failed");
                    self.imageState = ImageStateFinish;
                }else{
                    self.imageState = ImageStateFinish;
                    self.avatarImageURL = imgUrl;
                    LCLogInfo(@"Finish Upload Image: %@",imgUrl);
                }
                
                //如果已经点过FinishButton，说明在上传图片过程中，用户点过FinishButton
                //现在上传完成了，继续更新用户信息
                if (self.haveClickFinishButton) {
                    [self doUpdateUserInfo];
                }
            }];
        });
    }
}

- (BOOL)checkInput{
    NSString *nick = self.nickTextField.text;
    NSString *errorMsg = nil;
    
    if ([LCStringUtil isNullString:nick] ||
        [nick length] < MinNickLength ||
        [nick length] > MaxNickLength) {
        errorMsg = NickLengthErrMsg;
    }
//  头像选填
//    else if(self.imageState == ImageStateOrigional){
//        errorMsg = @"请上传图片";
//    }
    
    if (errorMsg) {
        [YSAlertUtil tipOneMessage:errorMsg yoffset:TipAboveKeyboardYoffset delay:TipErrorDelay];
        return NO;
    }else{
        return YES;
    }
}

- (void)doUpdateUserInfo{
    self.haveClickFinishButton = NO;
    
    NSString *placeStr = self.livingPlaceTextField.text;
    NSString *province = @"";
    NSString *city = @"";
    if ([LCStringUtil isNotNullString:placeStr]) {
        NSArray *strArr = [placeStr componentsSeparatedByString:LOCATION_CITY_SEPARATER];
        if (strArr && strArr.count>=2) {
            province = [LCStringUtil getNotNullStr:[strArr objectAtIndex:0]];
            city = [LCStringUtil getNotNullStr:[strArr objectAtIndex:1]];
        }else{
            city = placeStr;
        }
    }
    
    [LCNetRequester updateUserInfoWithNick:self.nickTextField.text
                                       sex:(self.sexIsMale?1:2)
                                 avatarURL:self.avatarImageURL
                            livingProvince:province
                               livingPlace:city
                                  realName:nil
                                    school:nil
                                   company:nil
                                  birthday:nil
                                 signature:nil
                                profession:nil
                              wantGoPlaces:nil
                              haveGoPlaces:nil
                                  callBack:^(LCUserModel *user, NSError *error)
    {
        [YSAlertUtil hideHud];
        
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipAboveKeyboardYoffset delay:TipErrorDelay];
        }else{
            if ([self.delegate respondsToSelector:@selector(inputUserinfoView:didUpdateUserinfo:)]) {
                [self.delegate inputUserinfoView:self didUpdateUserinfo:user];
            }
        }
    }];
}



@end

//
//  LCPlanRouteEditVC.m
//  LinkCity
//
//  Created by roy on 2/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanRouteEditPlaceVC.h"
#import "LCPickOneImageHelper.h"
#import "LCImageUtil.h"
#import "QNUploadManager.h"
#import "SZTextView.h"

typedef enum : NSUInteger {
    WorkMode_Edit,
    WorkMode_Add
} WorkMode;

typedef enum : NSUInteger {
    ImageStateOrigional,
    ImageStateProcessing,
    ImageStateFinish
} ImageState;

@interface LCPlanRouteEditPlaceVC ()<UIScrollViewDelegate,UIActionSheetDelegate,UITextViewDelegate,UITextFieldDelegate>
//Data
@property (nonatomic, assign) WorkMode workMode;
@property (nonatomic, assign) ImageState imageState;
@property (nonatomic, strong) UIImage *currentProcessingImage;

//UI
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *placeNameBgView;
@property (weak, nonatomic) IBOutlet UITextField *placeNameTextField;
@property (weak, nonatomic) IBOutlet UIView *placeDetailBgView;
@property (weak, nonatomic) IBOutlet SZTextView *placeDetailTextView;

@property (weak, nonatomic) IBOutlet UIButton *addImageButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;



@end


static NSString *const DefaultPlaceImage = @"UploadPlacePhoto";


@implementation LCPlanRouteEditPlaceVC

+ (instancetype)createInstance{
    return (LCPlanRouteEditPlaceVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSendPlan identifier:VCIDPlanRouteEditVC];
}

- (void)addPlaceAtDay:(NSInteger)routeDay{
    self.placeModel = [LCRoutePlaceModel createInstanceForEdit];
    self.placeModel.routeDay = routeDay;
    self.workMode = WorkMode_Add;
    self.imageState = ImageStateOrigional;
    [self updateShow];
}

- (void)editPlace:(LCRoutePlaceModel *)place{
    self.placeModel = place;
    self.workMode = WorkMode_Edit;
    if ([LCStringUtil isNotNullString:place.placeCoverUrl]) {
        self.imageState = ImageStateFinish;
    }else{
        self.imageState = ImageStateOrigional;
    }
    
    [self updateShow];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"添加当日行程";
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    
    UIBarButtonItem *deleteBarButton = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAction:)];
    self.navigationItem.rightBarButtonItem = deleteBarButton;
    
    self.scrollView.delegate = self;
    
    [[LCUIConstants sharedInstance] setViewAsInputBg:self.placeNameBgView];
    self.placeNameTextField.delegate = self;
    
    self.addImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.addImageButton addTarget:self action:@selector(addImageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.submitButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [[LCUIConstants sharedInstance] setViewAsInputBg:self.placeDetailBgView];
    self.placeDetailTextView.delegate = self;
    self.placeDetailTextView.placeholder = @"输入行程安排";
    
    [[LCUIConstants sharedInstance] setButtonAsSubmitButtonEnableStyle:self.submitButton];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateShow];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.placeModel.placeName = self.placeNameTextField.text;
    self.placeModel.descriptionStr = self.placeDetailTextView.text;
}

- (void)updateShow{
    if (self.view) {
        // have finish load views
        
        if (self.placeModel && [LCStringUtil isNotNullString:self.placeModel.placeName]) {
            self.placeNameTextField.text = self.placeModel.placeName;
        }else{
            self.placeNameTextField.text = @"";
        }
        
        if (self.placeModel && [LCStringUtil isNotNullString:self.placeModel.descriptionStr]) {
            self.placeDetailTextView.text = self.placeModel.descriptionStr;
        }else{
            self.placeDetailTextView.text = @"";
        }
        
        if (self.imageState == ImageStateOrigional || self.imageState == ImageStateFinish) {
            if (self.placeModel && [LCStringUtil isNotNullString:self.placeModel.placeCoverThumbUrl]) {
                [self.addImageButton setImageForState:UIControlStateNormal
                                              withURL:[NSURL URLWithString:self.placeModel.placeCoverThumbUrl]
                                     placeholderImage:[UIImage imageNamed:DefaultPlaceImage]];
            }else{
                [self.addImageButton setImageForState:UIControlStateNormal
                                              withURL:nil
                                     placeholderImage:[UIImage imageNamed:DefaultPlaceImage]];
            }
        }else if(self.imageState == ImageStateProcessing){
            // 如果正在处理图片，PickImage时已经设置过，不再设置图片显示
        }
        
        
        if (self.workMode == WorkMode_Add) {
            [self.submitButton setTitle:@"添加" forState:UIControlStateNormal];
        }else if(self.workMode == WorkMode_Edit) {
            [self.submitButton setTitle:@"更新" forState:UIControlStateNormal];
        }
    }
}

#pragma mark Button Actions
- (void)addImageButtonAction:(id)sender{
    if (self.imageState == ImageStateOrigional) {
        //Pick Image
        [[LCPickOneImageHelper sharedInstance] pickImageFromAlbum:YES camera:NO allowEdit:NO completion:^(UIImage *image) {
            [self didPickImage:image];
        }];
    }else if(self.imageState == ImageStateProcessing || self.imageState == ImageStateFinish) {
        //Delete or Pick Image
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"重选",@"删除", nil];
        [actionSheet showInView:[UIApplication sharedApplication].delegate.window];
    }
}

- (void)deleteAction:(id)sender {
    LCLogInfo(@"delete");
    [YSAlertUtil alertTwoButton:@"取消" btnTwo:@"删除" withTitle:nil msg:@"真的要删除吗?" callBack:^(NSInteger chooseIndex) {
        if (chooseIndex == 1) {
            if (self.workMode == WorkMode_Add) {
                
            }else if(self.workMode == WorkMode_Edit) {
                if ([self.delegate respondsToSelector:@selector(planRouteEditPlace:didDeletePlace:)]) {
                    [self.delegate planRouteEditPlace:self didDeletePlace:self.placeModel];
                }
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
- (void)submitButtonAction:(id)sender {
    self.placeModel.placeName = self.placeNameTextField.text;
    self.placeModel.descriptionStr = self.placeDetailTextView.text;
    
    if (![self checkInput]) {
        return;
    }
    
    if (self.imageState == ImageStateProcessing) {
        [YSAlertUtil showHudWithHint:@"正在上传图片"];
    }else{
        if (self.workMode == WorkMode_Add) {
            if ([self.delegate respondsToSelector:@selector(planRouteEditPlace:didAddPlace:)]) {
                [self.delegate planRouteEditPlace:self didAddPlace:self.placeModel];
            }
        }else if(self.workMode == WorkMode_Edit) {
            if ([self.delegate respondsToSelector:@selector(planRouteEditPlace:didEditPlace:)]) {
                [self.delegate planRouteEditPlace:self didEditPlace:self.placeModel];
            }
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (BOOL)checkInput{
    BOOL valid = YES;
    NSString *errorToastString = @"";
    
    if ([LCStringUtil isNullString:self.placeNameTextField.text]) {
        valid = NO;
        errorToastString = [errorToastString stringByAppendingString:@"请输入地点名称"];
    }
    
    if (!valid) {
        [YSAlertUtil tipOneMessage:errorToastString yoffset:TipDefaultYoffset delay:TipErrorDelay];
    }
    
    return valid;
}

- (void)dismissKeyboard{
    [self.placeNameTextField resignFirstResponder];
    [self.placeDetailTextView resignFirstResponder];
}


- (void)didPickImage:(UIImage *)img{
    if (img) {
        self.imageState = ImageStateProcessing;
        [self.addImageButton setImageForState:UIControlStateNormal withURL:nil placeholderImage:img];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageDataToUpload = [LCImageUtil getDataOfCompressImage:img toSize:MAX_IMAGE_SIZE_TO_UPLOAD];
            [LCImageUtil uploadImageDataToQinu:imageDataToUpload imageType:ImageCategoryPlace completion:^(NSString *imgUrl) {
                if ([LCStringUtil isNullString:imgUrl]) {
                    LCLogWarn(@"upload image failed");
                    self.imageState = ImageStateFinish;
                }else{
                    self.placeModel.placeCoverUrl = imgUrl;
                    self.placeModel.placeCoverThumbUrl = [LCImageUtil getThumbImageUrlFromOrigionalImageUrl:imgUrl];
                    self.imageState = ImageStateFinish;
                    LCLogInfo(@"Finish Upload Image: %@",imgUrl);
                    [self didUploadImage];
                }
            }];
        });
    }
}

- (void)didUploadImage{
    if ([YSAlertUtil isShowingHud]) {
        //如果上传完图片时，正在显示hud，说明用户已经点了添加按钮
        //传完图片后，调用一下添加按钮
        [self submitButtonAction:nil];
    }
    [YSAlertUtil hideHud];
}

#pragma mark - UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    LCLogInfo(@"should begin edit");
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    CGRect rect = textView.bounds;
    rect = [textView convertRect:textView.bounds toView:self.scrollView];
    [self.scrollView setContentOffset:CGPointMake(0, rect.origin.y-60) animated:YES];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self.view endEditing:YES];
}
#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //Roy 2015.5.30
    //如果直接执行，在点目的地输入框时，有时候会被键盘挡住——因为scrollview距底部的距离还没调整，就滚动，造成结果不确定
    //所以改成延时执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGRect rect = textField.bounds;
        rect = [textField convertRect:textField.bounds toView:self.scrollView];
        [self.scrollView setContentOffset:CGPointMake(0, rect.origin.y-60) animated:YES];
    });
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.placeNameTextField) {
        [self.placeDetailTextView becomeFirstResponder];
    }
    return YES;
}


#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.scrollView == scrollView) {
        [self dismissKeyboard];
    }
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        // repick
        //Pick Image
        [[LCPickOneImageHelper sharedInstance] pickImageFromAlbum:YES camera:NO completion:^(UIImage *image) {
            [self didPickImage:image];
        }];
    }else if(buttonIndex == 1){
        // delete
        [self.addImageButton setImageForState:UIControlStateNormal withURL:nil placeholderImage:[UIImage imageNamed:DefaultPlaceImage]];
        self.placeModel.placeCoverUrl = nil;
        self.placeModel.placeCoverThumbUrl = nil;
        self.imageState = ImageStateOrigional;
    }
}

@end

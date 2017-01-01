//
//  LCMerchantIdentifyVC.m
//  LinkCity
//
//  Created by godhangyu on 16/6/29.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCMerchantIdentifyVC.h"
#import "LCPickMultiImageHelper.h"
@interface IdentifyTextView : SZTextView
@end
@implementation IdentifyTextView : SZTextView

+ (UIEdgeInsets)textViewEdgeInsets {
    return UIEdgeInsetsMake(8, 4, 8, 4);
}

@end

@interface LCMerchantIdentifyVC ()

// UI
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIImageView *exampleImage;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImage;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) IBOutlet UILabel *uploadLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet IdentifyTextView *bottomTextView;

// Data
@property (strong, nonatomic) UIImage *uploadImg;
@property (assign, nonatomic) BOOL isUploadingImage;
@property (strong, nonatomic) NSString *uploadImageUrl;


@end

@implementation LCMerchantIdentifyVC

+ (instancetype)createInstance {
    return (LCMerchantIdentifyVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDMerchantIdentifyVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavigationBar];
    [self initUI];
}


#pragma mark - Common Init

- (void)initNavigationBar {
    switch (self.vcType) {
        case LCMerchantIdentifyType_TravelAgency:
            self.title = @"旅行社/俱乐部";
            break;
        case LCMerchantIdentifyType_Guide:
            self.title = @"导游/领队";
            break;
        case LCMerchantIdentifyType_LocalEntertainment:
            self.title = @"本地娱乐活动提供商";
            break;
    }
}

- (void)initUI {
    switch (self.vcType) {
        case LCMerchantIdentifyType_TravelAgency:
            self.topLabel.text = @"旅行社、俱乐部认证请上传营业执照";
            self.exampleImage.image = [UIImage imageNamed:@"MerchantIdentifyTravelAgency"];
            self.uploadImage.image = [UIImage imageNamed:@"MerchantIdentifyAddPhoto"];
            self.uploadLabel.text = @"上传营业执照照片";
            self.bottomLabel.text = @"商家简介";
            [self initTextFieldWithPlaceHolderStr:@"请写下你的商家简介、特色路线及活动"];
            break;
        case LCMerchantIdentifyType_Guide:
            self.topLabel.text = @"导游、领队认证请上传相关的证件照";
            self.exampleImage.image = [UIImage imageNamed:@"MerchantIdentifyGuide"];
            self.uploadImage.image = [UIImage imageNamed:@"MerchantIdentifyAddPhoto"];
            self.uploadLabel.text = @"上传导游证或领队证照片";
            self.bottomLabel.text = @"自我介绍";
            [self initTextFieldWithPlaceHolderStr:@"请写下你的特长、常带路线描述"];
            break;
        case LCMerchantIdentifyType_LocalEntertainment:
            self.topLabel.text = @"本地商家认证请上传营业执照";
            self.exampleImage.image = [UIImage imageNamed:@"MerchantIdentifyTravelAgency"];
            self.uploadImage.image = [UIImage imageNamed:@"MerchantIdentifyAddPhoto"];
            self.uploadLabel.text = @"上传营业执照照片";
            self.bottomLabel.text = @"商家简介";
            [self initTextFieldWithPlaceHolderStr:@"请写下你的商家简介、特色路线及活动"];
            break;
    }
}

- (void)initTextFieldWithPlaceHolderStr:(NSString *)placeholderStr {
    NSMutableAttributedString *attributedPlaceholderStr = [[NSMutableAttributedString alloc] initWithString:placeholderStr];
    NSRange range = NSMakeRange(0, [placeholderStr length]);
    
    [attributedPlaceholderStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBA(0xaba7a2, 1) range:range];
    [attributedPlaceholderStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"FZLTHJW--GB1-0" size:14.0f] range:range];
    
    self.bottomTextView.textContainerInset = [IdentifyTextView textViewEdgeInsets];
    
    [self.bottomTextView setAttributedPlaceholder:attributedPlaceholderStr];
}

- (void)startUploadImage {
    self.isUploadingImage = YES;
    __weak typeof(self) weakSelf = self;
    [LCImageUtil compressImagesWithData:@[self.uploadImg] complete:^(NSArray *compressArray) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [compressArray objectAtIndex:0];
            [LCImageUtil uploadImageDataToQinu:imageData imageType:ImageCategoryPlan completion:^(NSString *imgUrl) {
                weakSelf.isUploadingImage = NO;
                if ([LCStringUtil isNullString:imgUrl]) {
                    [YSAlertUtil tipOneMessage:@"上传图片失败"];
                } else {
                    weakSelf.uploadImageUrl = imgUrl;
                }
            }];
        });
    }];
}

- (IBAction)uploadImageButton:(id)sender {
    [self.bottomTextView resignFirstResponder];
    if (self.uploadImg) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [[LCPickMultiImageHelper sharedInstance] pickImageWithMaxNum:1 completion:^(NSArray *pickerImageArray){
        for (int i = 0; i < pickerImageArray.count; i++) {
            UIImage * image = [pickerImageArray objectAtIndex:i];
            weakSelf.uploadImg = image;
        }
        [self startUploadImage];
        weakSelf.uploadImage.image = weakSelf.uploadImg;
    }];
    
}

- (IBAction)sendAction:(id)sender {
    
    [self.bottomTextView resignFirstResponder];
    
    if (self.isUploadingImage) {
        [YSAlertUtil tipOneMessage:@"正在上传图片"];
        return;
    }
    
    if ([LCStringUtil isNullString:self.uploadImageUrl]) {
        [YSAlertUtil tipOneMessage:@"请上传相关证件"];
        return;
    }
    
    if ([LCStringUtil isNullString:self.bottomTextView.text]) {
        [YSAlertUtil tipOneMessage:@"请填写相关信息"];
        return;
    }
    
    LCGuideIdentityModel *guideIdentity = [[LCGuideIdentityModel alloc] init];
    guideIdentity.clubPhotoUrl = self.uploadImageUrl;
    guideIdentity.note = self.bottomTextView.text;
    
    switch (self.vcType) {
        case LCMerchantIdentifyType_Guide:
            guideIdentity.type = @"0";
            break;
        case LCMerchantIdentifyType_TravelAgency:
            guideIdentity.type = @"1";
            break;
        case LCMerchantIdentifyType_LocalEntertainment:
            guideIdentity.type = @"2";
    }
    
    [LCNetRequester guideIdentityWith:guideIdentity callBack:^(LCGuideIdentityModel *guideIdentity, LCUserModel *user, NSError *error) {
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        }else{
            [YSAlertUtil tipOneMessage:@"提交审核成功，正在等待管理员审核" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
    
    
}

@end

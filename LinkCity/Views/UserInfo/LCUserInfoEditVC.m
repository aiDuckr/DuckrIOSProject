//
//  LCUserInfoEditVC.m
//  LinkCity
//
//  Created by roy on 11/28/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCUserInfoEditVC.h"
#import "YSAlbumImageView.h"
#import "LCDatePicker.h"
#import "LCDateUtil.h"
#import "LCUserApi.h"
#import "LCUserInfoInputVC.h"
#import "YSAlertUtil.h"
#import "LCProvincePickerVC.h"
#import "LCCityPicker.h"

typedef enum : NSUInteger {
    AvatarStateNormal,
    AvatarStateChanged,
    AvatarStateUploaded,
} AvatarState;
@interface LCUserInfoEditVC ()<YSAlbumImageViewDelegate,UIActionSheetDelegate,LCDatePickerDelegate,LCUserInfoInputVCDelegate,LCUserApiDelegate,LCProvincePickerDelegate>
@property (nonatomic, strong) LCUserInfo *editedUserInfo;

@property (nonatomic ,strong) UIBarButtonItem *cancelBarButton;
@property (nonatomic, strong) UIBarButtonItem *saveBarButton;

@property (weak, nonatomic) IBOutlet YSAlbumImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIButton *editAvatarButton;

@property (weak, nonatomic) IBOutlet UIButton *nickNameButton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;

@property (weak, nonatomic) IBOutlet UIButton *realNameButton;
@property (weak, nonatomic) IBOutlet UIButton *sexButton;
@property (weak, nonatomic) IBOutlet UIButton *ageButton;
@property (weak, nonatomic) IBOutlet UIButton *schoolButton;
@property (weak, nonatomic) IBOutlet UIButton *companyButton;

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) LCDatePicker *datePickerView;
@property (nonatomic, strong) LCUserInfoInputVC *inputVC;
@property (nonatomic, strong) LCProvincePickerVC *provincePickerVC;

@property (nonatomic, assign) AvatarState avatarState;  //标记当前头像的状态：未修改，已经修改未上传，已修改并完成上传
@end

@implementation LCUserInfoEditVC

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.saveBarButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
    self.cancelBarButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    self.navigationItem.leftBarButtonItem = self.cancelBarButton;
    self.navigationItem.rightBarButtonItem = self.saveBarButton;
    
    self.title = @"编辑个人信息";
    
    self.avatarImageView.albumDelegate = self;
    self.avatarImageView.imageCategory = ImageCategoryAvatar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self updateShow];
}

#pragma mark - Public Interface
+ (UINavigationController *)createNavigationVCInstance{
    UINavigationController *navC = (UINavigationController *)[LCStoryboardManager viewControllerWithFileName:SBNameUserinfo identifier:VCIDUserInfoEditNavigationVC];
    return navC;
}
+ (LCUserInfoEditVC *)createVCInstance{
    return (LCUserInfoEditVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserinfo identifier:VCIDUserInfoEditVC];
}
- (void)setUserInfo:(LCUserInfo *)userInfo{
    _userInfo = userInfo;
    
    if (!self.editedUserInfo) {
        self.editedUserInfo = [[LCUserInfo alloc]init];
    }
    [self.editedUserInfo updateValueWithObject:userInfo];
    
    if (self.view) {
        [self updateShow];
    }
}

- (LCProvincePickerVC *)provincePickerVC{
    if (!_provincePickerVC) {
        _provincePickerVC = [LCProvincePickerVC createInstance];
    }
    return _provincePickerVC;
}
- (LCUserInfoInputVC *)inputVC{
    if (!_inputVC) {
        _inputVC = [LCUserInfoInputVC createInstance];
    }
    return _inputVC;
}
#pragma mark - InnerFuncation
- (void)updateShow{
    if (self.editedUserInfo) {
        self.avatarImageView.imageURL = [NSURL URLWithString:self.editedUserInfo.avatarThumbUrl];
        self.nickLabel.text = [LCStringUtil getShowStringFromMayNullString:self.editedUserInfo.nick];
        [self.nickNameButton setTitle:[LCStringUtil getShowStringFromMayNullString:self.editedUserInfo.nick] forState:UIControlStateNormal];
        
        
        [self.locationButton setTitle:[LCStringUtil getShowStringFromMayNullString:self.editedUserInfo.livingPlace] forState:UIControlStateNormal];
        self.signLabel.text = [LCStringUtil getShowStringFromMayNullString:self.editedUserInfo.signature];
        [self.realNameButton setTitle:[LCStringUtil getShowStringFromMayNullString:self.editedUserInfo.realName] forState:UIControlStateNormal];
        [self.sexButton setTitle:[self.editedUserInfo getSexStringForChinese] forState:UIControlStateNormal];
        
//        if (self.userInfo.age<0) {
//            [self.ageButton setTitle:[LCStringUtil getShowStringFromMayNullString:nil] forState:UIControlStateNormal];
//        }else{
//            [self.ageButton setTitle:[NSString stringWithFormat:@"%lu",self.editedUserInfo.age] forState:UIControlStateNormal];
//        }
        [self.ageButton setTitle:[LCStringUtil getShowStringFromMayNullString:self.editedUserInfo.birthday] forState:UIControlStateNormal];
        
        [self.schoolButton setTitle:[LCStringUtil getShowStringFromMayNullString:self.editedUserInfo.school] forState:UIControlStateNormal];
        [self.companyButton setTitle:[LCStringUtil getShowStringFromMayNullString:self.editedUserInfo.company] forState:UIControlStateNormal];
    }
}

- (void)cancelAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)saveAction:(id)sender{
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    LCUserApi *userApi = [[LCUserApi alloc]initWithDelegate:self];
    [userApi updateUserInfoForNick:self.editedUserInfo.nick
                          realName:self.editedUserInfo.realName
                         avatarUrl:self.editedUserInfo.avatarUrl
                            school:self.editedUserInfo.school
                           company:self.editedUserInfo.company
                              sign:self.editedUserInfo.signature
                       livingPlace:self.editedUserInfo.livingPlace
                               sex:self.editedUserInfo.sex
                          birthday:self.editedUserInfo.birthday];
    [self showHudInView:self.view hint:nil];
}
- (IBAction)editAvatarButtonClick:(id)sender {
    [self.avatarImageView editPortrait];
}
- (IBAction)nickButtonClick:(id)sender {
    [self.navigationController pushViewController:self.inputVC animated:YES];
    [self.inputVC setInputType:InputTypeNick forUser:self.editedUserInfo withDelegate:self];
}
- (IBAction)locationButtonClick:(id)sender {
    self.provincePickerVC.delegate = self;
    [self.navigationController pushViewController:self.provincePickerVC animated:YES];
}
- (IBAction)signTapAction:(id)sender {
    [self.navigationController pushViewController:self.inputVC animated:YES];
    [self.inputVC setInputType:InputTypeSigh forUser:self.editedUserInfo withDelegate:self];
}
- (IBAction)realNameButtonClick:(id)sender {
    [self.navigationController pushViewController:self.inputVC animated:YES];
    [self.inputVC setInputType:InputTypeRealName forUser:self.editedUserInfo withDelegate:self];
}
- (IBAction)sexButtonClick:(id)sender {
    [self showSexActionSheet];
}
- (IBAction)ageButtonClick:(id)sender {
    [self showBirthdayPicker];
}
- (IBAction)schoolButtonClick:(id)sender {
    [self.navigationController pushViewController:self.inputVC animated:YES];
    [self.inputVC setInputType:InputTypeSchool forUser:self.editedUserInfo withDelegate:self];
}
- (IBAction)companyButtonClick:(id)sender {
    [self.navigationController pushViewController:self.inputVC animated:YES];
    [self.inputVC setInputType:InputTypeCompany forUser:self.editedUserInfo withDelegate:self];
}

#pragma mark - LCUserApi Delegate
- (void)userApi:(LCUserApi *)userApi didUpdateUserInfo:(LCUserInfo *)userInfo withError:(NSError *)error{
    [self hideHudInView];
    if (error) {
        RLog(@"update user info failed. %@",error);
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }else{
        RLog(@"update user info succeed. ");
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - LCUserInfoInputDelegate
- (void)userInfoInputVC:(LCUserInfoInputVC *)inputVC didUpdateUserInfo:(LCUserInfo *)userInfo withInputType:(UserInfoInputType)inputType{
    [self updateShow];
}

#pragma mark - Fox Sex
- (void)showSexActionSheet{
    UIActionSheet *choiceSheet = nil;
    choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:self
                                     cancelButtonTitle:@"取消"
                                destructiveButtonTitle:nil
                                     otherButtonTitles:@"男", @"女", nil];
    
    [choiceSheet showInView:[UIApplication sharedApplication].keyWindow];
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
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger index = 0;
    
    if (buttonIndex == index){
        self.editedUserInfo.sex = SEX_MALE_STRING;
    }else if (buttonIndex == index + 1){
        self.editedUserInfo.sex = SEX_FEMALE_STRING;
    }
    
    [self updateShow];
}
#pragma mark - For Birthday
- (void)showBirthdayPicker{
    if (!self.datePickerView) {
        self.datePickerView = [LCDatePicker createInstance];
        self.datePickerView.delegate = self;
    }
    self.datePickerView.frame = self.view.bounds;
    self.datePickerView.backgroundColor = UIColorFromRGBA(0x000000, 0);
    CGRect f = self.datePickerView.datePickerContainerView.frame;
    f.origin.y += f.size.height;
    self.datePickerView.datePickerContainerView.frame = f;
    [self.view addSubview:self.datePickerView];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^(){
        self.datePickerView.backgroundColor = UIColorFromRGBA(0x000000, 0.3);
        CGRect f = self.datePickerView.datePickerContainerView.frame;
        f.origin.y -= f.size.height;
        self.datePickerView.datePickerContainerView.frame = f;
    } completion:nil];
}
- (void)dismissBirthdayPicker{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(){
        self.datePickerView.backgroundColor = UIColorFromRGBA(0x000000, 0);
        CGRect f = self.datePickerView.datePickerContainerView.frame;
        f.origin.y += f.size.height;
        self.datePickerView.datePickerContainerView.frame = f;
    } completion:^(BOOL finished){
        [self.datePickerView removeFromSuperview];
    }];
}
- (void)datePickerDidTap:(LCDatePicker *)datePicker{
    [self dismissBirthdayPicker];
}
- (void)datePickerDidCancel:(LCDatePicker *)datePicker{
    [self dismissBirthdayPicker];
}
- (void)datePickerDidConfirm:(LCDatePicker *)datePicker{
    [self dismissBirthdayPicker];
    NSDate *d = [datePicker.datePicker date];
    self.editedUserInfo.birthday = [LCDateUtil stringFromDate:d];
    //NSLog(@"%@,%@",d,self.editedUserInfo.birthday);
    [self updateShow];
}

#pragma mark - YSAlbumImageView Delegate
//已经上传图片到七牛
- (void)imageViewReadyImage:(UIImage *)image {
    [self showHudInView:self.view hint:nil];
    self.avatarImageView.image = nil;
    self.avatarImageView.imageURL = [NSURL URLWithString:@""];
    self.avatarImageView.image = image;
    RLog(@"finish compress image");
}
- (void)imageViewReadyUploadURL:(YSAlbumImageView *)imageView{
    [self hideHudInView];
    
    self.editedUserInfo.avatarUrl = imageView.uploadImageURL;
    
    self.avatarImageView.imageURL = nil;
    self.avatarImageView.imageURL = [NSURL URLWithString:self.editedUserInfo.avatarUrl];
    RLog(@"finish upload image %@",[imageView.imageURL absoluteString]);
}

#pragma mark - LCProvincePicker Delegate
- (void)provincePrcker:(LCProvincePickerVC *)provincePickerVC didSelectCity:(NSString *)cityName{
    self.editedUserInfo.livingPlace = cityName;
    //[self updateShow];
}

//#pragma mark - Hud
//- (void)showHud{
//    if (self.hud) {
//        [self.hud hide:NO];
//    }
//    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
//    [self.view addSubview:self.hud];
//    [self.hud show:YES];
//}
//- (void)hideHud{
//    [self.hud hide:YES];
//}
@end

//
//  LCEditUserInfo.m
//  LinkCity
//
//  Created by roy on 3/4/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCEditUserInfoVC.h"
#import "LCRoutePlaceAddCell.h"
#import "LCRoutePlaceDeleteCell.h"
#import "LCPlanDestinationCollectionLayout.h"
#import "LCDialogInputter.h"
#import "LCDatePicker.h"
#import "LCUserInfoInputVC.h"
#import "LCChooseProfessionVC.h"
#import "LCProvincePickerVC.h"
#import "LCSchoolPickerVC.h"

typedef enum : NSUInteger {
    ImageStateOrigional,
    ImageStateProcessing,
    ImageStateFinish
} ImageState;
@interface LCEditUserInfoVC ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,LCDatePickerDelegate,LCUserInfoInputVCDelegate,LCChooseProfessionVCDelegate,LCProvincePickerDelegate,LCSchoolPickerVCDelegate>
@property (nonatomic, retain) LCUserModel *editingUser;
//Data
@property (nonatomic, assign) ImageState imageState;
@property (nonatomic, assign) BOOL haveClickFinishButton;

@property (nonatomic, strong) NSMutableArray *wantToList;
@property (nonatomic, strong) NSMutableArray *haveBeenList;

//UI
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIButton *nickButton;

@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UIButton *sexButton;

@property (weak, nonatomic) IBOutlet UILabel *birthLabel;
@property (weak, nonatomic) IBOutlet UIButton *birthButton;

@property (weak, nonatomic) IBOutlet UILabel *livingPlaceLabel;
@property (weak, nonatomic) IBOutlet UIButton *livingPlaceButton;

@property (weak, nonatomic) IBOutlet UILabel *slogonLabel;
@property (weak, nonatomic) IBOutlet UIButton *slogonButton;


@property (weak, nonatomic) IBOutlet UILabel *professionLabel;
@property (weak, nonatomic) IBOutlet UIButton *professionButton;

@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UIButton *schoolButton;


@property (weak, nonatomic) IBOutlet UICollectionView *wantToCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wantToCollectionViewHeight;

@property (weak, nonatomic) IBOutlet UICollectionView *haveBeenCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *haveBeenCollectionViewHeight;

@property (nonatomic, strong) UIActionSheet *pickImageActionSheet;
@property (nonatomic, strong) UIActionSheet *sexActionSheet;
@property (nonatomic, strong) LCDatePicker *datePickerView;
@property (nonatomic, strong) LCUserInfoInputVC *inputVC;
@property (nonatomic, strong) LCChooseProfessionVC *chooseProfessionVC;
@property (nonatomic, strong) LCProvincePickerVC *provincePickerVC;
@end

@implementation LCEditUserInfoVC

+ (instancetype)createInstance{
    return (LCEditUserInfoVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUser identifier:VCIDEditUserInfoVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initEditUser];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"个人主页";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonAction)];
    
    self.scrollView.delegate = self;
    
    self.imageState = ImageStateOrigional;
    self.haveClickFinishButton = NO;
    self.wantToList = [[NSMutableArray alloc] initWithCapacity:0];
    self.haveBeenList = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.wantToCollectionView.delegate = self;
    self.wantToCollectionView.dataSource = self;
    self.wantToCollectionView.scrollEnabled = NO;
    self.wantToCollectionView.collectionViewLayout = [[LCPlanDestinationCollectionLayout alloc] init];
    [self.wantToCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LCRoutePlaceAddCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LCRoutePlaceAddCell class])];
    [self.wantToCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LCRoutePlaceDeleteCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LCRoutePlaceDeleteCell class])];
    
    self.haveBeenCollectionView.delegate = self;
    self.haveBeenCollectionView.dataSource = self;
    self.haveBeenCollectionView.scrollEnabled = NO;
    self.haveBeenCollectionView.collectionViewLayout = [[LCPlanDestinationCollectionLayout alloc] init];
    [self.haveBeenCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LCRoutePlaceAddCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LCRoutePlaceAddCell class])];
    [self.haveBeenCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LCRoutePlaceDeleteCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LCRoutePlaceDeleteCell class])];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.haveClickFinishButton = NO;
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[LCUIConstants sharedInstance].navBarTranslucentImage forBarMetrics:UIBarMetricsDefault];
    
    [self updateShow];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    
    [YSAlertUtil hideHud];
    
    //NavBar变白
    [self.navigationController.navigationBar setBackgroundImage:[LCUIConstants sharedInstance].navBarOpaqueImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = UIColorFromRGBA(NavigationBarTintColor, 1);
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGBA(NavigationBarTintColor, 1), NSForegroundColorAttributeName, [UIFont fontWithName:FONT_LANTINGBLACK size:17], NSFontAttributeName, nil];
    
    [self mergeUIToModel];
}

- (void)initEditUser {
    self.editingUser = [[LCUserModel alloc] init];
    self.editingUser.avatarThumbUrl = self.currentUser.avatarThumbUrl;
    self.editingUser.nick = self.currentUser.nick;
    self.editingUser.sex = self.currentUser.sex;
    self.editingUser.birthday = self.currentUser.birthday;
    self.editingUser.livingPlace = self.currentUser.livingPlace;
    self.editingUser.signature = self.currentUser.signature;
    self.editingUser.professional = self.currentUser.professional;
    self.editingUser.school = self.currentUser.school;
    self.editingUser.wantGoList = [NSMutableArray arrayWithArray:self.currentUser.wantGoList];
    self.editingUser.haveGoList = [NSMutableArray arrayWithArray:self.currentUser.haveGoList];
}

- (void)updateShow{
    [self updateNavigationBarAppearance];
    
    if (self.editingUser) {
        [self.avatarButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.editingUser.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
        self.nickLabel.text = [LCStringUtil getShowStringFromMayNullString:self.editingUser.nick];
        
        self.sexLabel.text = [self.editingUser getSexStringForChinese];
        self.birthLabel.text = [LCStringUtil getShowStringFromMayNullString:self.editingUser.birthday];
        self.livingPlaceLabel.text = [LCStringUtil getShowStringFromMayNullString:self.editingUser.livingPlace];
        self.slogonLabel.text = [LCStringUtil getShowStringFromMayNullString:self.editingUser.signature];
        
        self.professionLabel.text = [LCStringUtil getShowStringFromMayNullString:self.editingUser.professional];
        self.schoolLabel.text = [LCStringUtil getShowStringFromMayNullString:self.editingUser.school];
        
        self.wantToList = [NSMutableArray arrayWithArray:self.editingUser.wantGoList];
        self.haveBeenList = [NSMutableArray arrayWithArray:self.editingUser.haveGoList];
        [self.wantToCollectionView reloadData];
        [self.haveBeenCollectionView reloadData];
        [self updateCollectionHeight];
    }
}

- (void)updateNavigationBarAppearance{
    CGFloat tableOffsetY = self.scrollView.contentOffset.y;
    
    if (tableOffsetY > self.topViewHeight.constant-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT) {
        //上滑后，NavBar变白
        [self.navigationController.navigationBar setBackgroundImage:[LCUIConstants sharedInstance].navBarOpaqueImage forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.tintColor = UIColorFromRGBA(NavigationBarTintColor, 1);
        self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGBA(NavigationBarTintColor, 1), NSForegroundColorAttributeName, [UIFont fontWithName:FONT_LANTINGBLACK size:17], NSFontAttributeName, nil];
    }else{
        //下滑后，NavBar变透明
        [self.navigationController.navigationBar setBackgroundImage:[LCUIConstants sharedInstance].navBarTranslucentImage forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:FONT_LANTINGBLACK size:17], NSFontAttributeName, nil];
    }
}

- (LCUserInfoInputVC *)inputVC{
    if (!_inputVC) {
        _inputVC = [LCUserInfoInputVC createInstance];
    }
    return _inputVC;
}
- (LCChooseProfessionVC *)chooseProfessionVC{
    if (!_chooseProfessionVC) {
        _chooseProfessionVC = [LCChooseProfessionVC createInstance];
        _chooseProfessionVC.delegate = self;
    }
    return _chooseProfessionVC;
}

- (void)mergeUIToModel{
    self.editingUser.wantGoList = self.wantToList;
    self.editingUser.haveGoList = self.haveBeenList;
}

#pragma mark Button Action
- (void)saveButtonAction{
    [self mergeUIToModel];
    
    if (uploadingImageNum > 0) {
        self.haveClickFinishButton = YES;
        [YSAlertUtil showHudWithHint:@"正在上传图片" inView:self.view enableUserInteraction:YES];
        return;
    }
    
    if ([YSAlertUtil isShowingHud]) {
        [YSAlertUtil hideHud];
    }
    
    if ([self checkInput]) {
        NSString *placeStr = self.editingUser.livingPlace;
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
        
        
        [LCNetRequester updateUserInfoWithNick:self.editingUser.nick
                                           sex:self.editingUser.sex
                                     avatarURL:self.editingUser.avatarUrl
                                livingProvince:province
                                   livingPlace:city
                                      realName:self.editingUser.realName
                                        school:self.editingUser.school
                                       company:nil
                                      birthday:self.editingUser.birthday
                                     signature:self.editingUser.signature
                                    profession:self.editingUser.professional
                                  wantGoPlaces:self.wantToList
                                  haveGoPlaces:self.haveBeenList
                                      callBack:^(LCUserModel *user, NSError *error) {
                                          if (error) {
                                              [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
                                          }else{
                                              self.currentUser = user;
                                              [LCDataManager sharedInstance].userInfo = user;
                                              [self.navigationController popViewControllerAnimated:YES];
                                          }
                                      }];
    }
}
- (IBAction)avatarButtonAction:(id)sender {
    [self pickImage];
}
- (IBAction)nickButtonAction:(id)sender {
    [[LCDialogInputter sharedInstance] showInputterWithDefaultText:nil placeHolder:nil title:@"输入昵称" completion:^(NSString *comp) {
        self.editingUser.nick = comp;
        self.nickLabel.text = comp;
    }];
}
- (IBAction)sexButtonAction:(id)sender {
    if (!self.sexActionSheet) {
        self.sexActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    }
    [self.sexActionSheet showInView:[UIApplication sharedApplication].delegate.window];
}
- (IBAction)birthButtonAction:(id)sender {
    [self showBirthdayPicker];
}
- (IBAction)livingPlaceButtonAction:(id)sender {
    if (!self.provincePickerVC) {
        self.provincePickerVC = [LCProvincePickerVC createInstance];
        self.provincePickerVC.isChosingLocalCity = NO;
        self.provincePickerVC.delegate = self;
    }
    [self.navigationController pushViewController:self.provincePickerVC animated:YES];
}
- (IBAction)slogonButtonAction:(id)sender {
    [self.navigationController pushViewController:self.inputVC animated:YES];
    [self.inputVC setInputType:InputTypeSigh forUser:self.editingUser withDelegate:self];
}
- (IBAction)professionButtonAction:(id)sender {
    [self.navigationController pushViewController:self.chooseProfessionVC animated:YES];
}
- (IBAction)schoolButtonAction:(id)sender {
    LCSchoolPickerVC *schoolPickerVC = [LCSchoolPickerVC createInstance];
    schoolPickerVC.defaultSearchStr = self.editingUser.school;
    schoolPickerVC.delegate = self;
    [self.navigationController pushViewController:schoolPickerVC animated:YES];
}


- (BOOL)checkInput{
    NSString *nick = self.nickLabel.text;
    NSString *errorMsg = nil;
    
    if ([LCStringUtil isNullString:nick] ||
        [nick length] < MinNickLength ||
        [nick length] > MaxNickLength) {
        errorMsg = NickLengthErrMsg;
    }
    
    if (errorMsg) {
        [YSAlertUtil tipOneMessage:errorMsg yoffset:TipAboveKeyboardYoffset delay:TipErrorDelay];
        return NO;
    }else{
        return YES;
    }
}


#pragma mark - LCUserInfoInputDelegate
- (void)userInfoInputVC:(LCUserInfoInputVC *)inputVC didUpdateUserInfo:(LCUserModel *)userInfo withInputType:(UserInfoInputType)inputType{
    [self updateShow];
}
#pragma mark - LCChooseProfessionVC Delegate
- (void)chooseProfessionVC:(LCChooseProfessionVC *)chooseProfessionVC didChooseProfession:(NSString *)pro{
    self.editingUser.professional = pro;
    self.professionLabel.text = pro;
}
#pragma mark - BirthDay
- (void)showBirthdayPicker{
    if (!self.datePickerView) {
        self.datePickerView = [LCDatePicker createInstance];
        self.datePickerView.delegate = self;
        //self.datePickerView.withWeekDayLabel = NO;
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
    self.editingUser.birthday = [LCDateUtil stringFromDate:d];
    self.birthLabel.text = self.editingUser.birthday;
}

#pragma mark - PickImage
- (void)pickImage{
    if (!self.pickImageActionSheet) {
        self.pickImageActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
    }
    [self.pickImageActionSheet showInView:[UIApplication sharedApplication].delegate.window];
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
}

static int uploadingImageNum = 0;
- (void)didPickImage:(UIImage *)img{
    if (img) {
        self.imageState = ImageStateProcessing;
        [self.avatarButton setImage:img forState:UIControlStateNormal];
        
        uploadingImageNum ++;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageDataToUpload = [LCImageUtil getDataOfCompressImage:img toSize:MAX_IMAGE_SIZE_TO_UPLOAD];
            [LCImageUtil uploadImageDataToQinu:imageDataToUpload imageType:ImageCategoryAvatar completion:^(NSString *imgUrl) {
                uploadingImageNum --;
                
                if ([LCStringUtil isNullString:imgUrl]) {
                    LCLogWarn(@"upload image failed");
                    self.imageState = ImageStateFinish;
                }else{
                    self.imageState = ImageStateFinish;
                    //这里都设为url，为了方便上传
                    self.editingUser.avatarUrl = imgUrl;
                    self.editingUser.avatarThumbUrl = imgUrl;
                    LCLogInfo(@"Finish Upload Image: %@",imgUrl);
                }
                [YSAlertUtil hideHud];
                //如果已经点过FinishButton，说明在上传图片过程中，用户点过FinishButton
                //现在上传完成了，继续更新用户信息
                if (self.haveClickFinishButton && uploadingImageNum<=0) {
                    [self saveButtonAction];
                }
            }];
        });
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
    if (actionSheet == self.sexActionSheet) {
        if (buttonIndex == 0) {
            self.editingUser.sex = 1;
            self.sexLabel.text = @"男";
        }else if(buttonIndex == 1){
            self.editingUser.sex = 2;
            self.sexLabel.text = @"女";
        }
    }else if(actionSheet == self.pickImageActionSheet){
        if (buttonIndex == 0) {
            //拍照
            [self pickImageFromCamera];
        } else if (buttonIndex == 1) {
            //从相册中选取
            [self pickImageFromAlbum];
        }
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
    
    [self didPickImage:img];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger itemNum = 0;
    if (collectionView == self.wantToCollectionView) {
        itemNum = self.wantToList.count+1;
    }else if(collectionView == self.haveBeenCollectionView){
        itemNum = self.haveBeenList.count+1;
    }
    return itemNum;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    
    if (collectionView == self.wantToCollectionView) {
        if (indexPath.item < self.wantToList.count) {
            // place delete cell
            LCRoutePlaceDeleteCell *deleteCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCRoutePlaceDeleteCell class]) forIndexPath:indexPath];
            deleteCell.placeLabel.text = [self.wantToList objectAtIndex:indexPath.item];
            
            cell = deleteCell;
        }else if(indexPath.item == self.wantToList.count){
            // add place cell
            LCRoutePlaceAddCell *addCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCRoutePlaceAddCell class]) forIndexPath:indexPath];
            cell = addCell;
        }
    }else if(collectionView == self.haveBeenCollectionView){
        if (indexPath.item < self.haveBeenList.count) {
            // place delete cell
            LCRoutePlaceDeleteCell *deleteCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCRoutePlaceDeleteCell class]) forIndexPath:indexPath];
            deleteCell.placeLabel.text = [self.haveBeenList objectAtIndex:indexPath.item];
            
            cell = deleteCell;
        }else if(indexPath.item == self.haveBeenList.count){
            // add place cell
            LCRoutePlaceAddCell *addCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCRoutePlaceAddCell class]) forIndexPath:indexPath];
            cell = addCell;
        }
    }
    
    
    [cell invalidateIntrinsicContentSize];
    LCLogInfo(@"cellForItemAtItem:%ld",(long)indexPath.item);
    
    return cell;
}
#pragma mark UICollectionView Layout
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeZero;
    
    if (collectionView == self.wantToCollectionView) {
        if (indexPath.item < self.wantToList.count) {
            // delete place cell
            NSString *place = [self.wantToList objectAtIndex:indexPath.item];
            UIFont *font = [UIFont fontWithName:FONT_LANTINGBLACK size:15];
            CGRect textRect = [place boundingRectWithSize:CGSizeMake(MAXFLOAT, 54)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:font}
                                                  context:nil];
            CGFloat width = MIN(textRect.size.width+54, collectionView.frame.size.width);
            LCLogInfo(@"text:%@,textsize:%@,collectionSize:%@",place,NSStringFromCGRect(textRect),NSStringFromCGRect(collectionView.frame));
            
            size = CGSizeMake(width, 40);
        }else if(indexPath.item == self.wantToList.count) {
            // add place cell
            size = CGSizeMake(100, 40);
        }
    }else if(collectionView == self.haveBeenCollectionView){
        if (indexPath.item < self.haveBeenList.count) {
            // delete place cell
            NSString *place = [self.haveBeenList objectAtIndex:indexPath.item];
            UIFont *font = [UIFont fontWithName:FONT_LANTINGBLACK size:15];
            CGRect textRect = [place boundingRectWithSize:CGSizeMake(MAXFLOAT, 54)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:font}
                                                  context:nil];
            CGFloat width = MIN(textRect.size.width+54, collectionView.frame.size.width);
            LCLogInfo(@"text:%@,textsize:%@,collectionSize:%@",place,NSStringFromCGRect(textRect),NSStringFromCGRect(collectionView.frame));
            
            size = CGSizeMake(width, 40);
        }else if(indexPath.item == self.haveBeenList.count) {
            // add place cell
            size = CGSizeMake(100, 40);
        }
    }
    
    LCLogInfo(@"sizeForItemAtItem:%ld size:%@",(long)indexPath.item,NSStringFromCGSize(size));
    return size;
}

#pragma mark UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LCLogInfo(@"didSelectItem:%ld",(long)indexPath.item);
    
    if (collectionView == self.wantToCollectionView) {
        if (indexPath.item < self.wantToList.count) {
            // delete destination
            [self.wantToList removeObjectAtIndex:indexPath.item];
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
            
            [self updateCollectionHeight];
        }else if(indexPath.item == self.wantToList.count){
            // add destination
            [[LCDialogInputter sharedInstance] showInputterWithDefaultText:nil placeHolder:nil title:@"输入地名" completion:^(NSString *place) {
                [self.wantToList addObject:place];
                [self.wantToCollectionView insertItemsAtIndexPaths:@[indexPath]];
                
                [self updateCollectionHeight];
            }];
        }
    }else if(collectionView == self.haveBeenCollectionView){
        if (indexPath.item < self.haveBeenList.count) {
            // delete destination
            [self.haveBeenList removeObjectAtIndex:indexPath.item];
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
            
            [self updateCollectionHeight];
        }else if(indexPath.item == self.haveBeenList.count){
            // add destination
            [[LCDialogInputter sharedInstance] showInputterWithDefaultText:nil placeHolder:nil title:@"输入地名" completion:^(NSString *place) {
                [self.haveBeenList addObject:place];
                [self.haveBeenCollectionView insertItemsAtIndexPaths:@[indexPath]];
                
                [self updateCollectionHeight];
            }];
        }
    }
    
}

#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //手往下，内容往下滚，contentOffset变负
    [self updateNavigationBarAppearance];
}

- (void)updateCollectionHeight{
    [self.wantToCollectionView reloadData];
    [self.haveBeenCollectionView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.wantToCollectionViewHeight.constant = self.wantToCollectionView.contentSize.height;
        self.haveBeenCollectionViewHeight.constant = self.haveBeenCollectionView.contentSize.height;
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
        }];
        
        
        for (UICollectionViewCell *cell in [self.wantToCollectionView visibleCells]){
            [cell setNeedsUpdateConstraints];
        }
        for (UICollectionViewCell *cell in [self.haveBeenCollectionView visibleCells]){
            [cell setNeedsUpdateConstraints];
        }
    });
}

#pragma mark - LCProvincePicker Delegate
- (void)provincePicker:(LCProvincePickerVC *)provincePickerVC didSelectProvince:(NSString *)provinceName didSelectCity:(LCCityModel *)city {
    self.editingUser.livingPlace = [NSString stringWithFormat:@"%@%@%@", provinceName, LOCATION_CITY_SEPARATER, city.cityName];
    self.livingPlaceLabel.text = [NSString stringWithFormat:@"%@%@%@", provinceName, LOCATION_CITY_SEPARATER, city.cityName];
    
//    [self.navigationController popToViewController:self animated:YES];
}

#pragma mark LCSchoolPickerVC Delegate
- (void)schoolPickerVC:(LCSchoolPickerVC *)schoolPickerVC didPickSchool:(NSString *)school{
    self.editingUser.school = school;
    [self.navigationController popToViewController:self animated:YES];
}
- (void)schoolPickerVCDidCancel:(LCSchoolPickerVC *)schoolPickerVC{
    [self.navigationController popToViewController:self animated:YES];
}

@end

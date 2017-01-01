//
//  LCNewReceptionPlanVC.m
//  LinkCity
//
//  Created by 张宗硕 on 11/12/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCNewReceptionPlanVC.h"
#import "LCTextView.h"

#define DECLARATION_MAX_LENGTH 16
/// 服务中选中的时候的颜色.(108,105,101)
#define SERVICE_CHOOSE_CONTENT_COLOR 0x6c6965
/// 服务中未选中的时候的颜色.(217,204,201)
#define SERVICE_UNCHOOSE_CONTENT_COLOR 0xd9ccc9

@interface LCNewReceptionPlanVC ()<UITextFieldDelegate, UIScrollViewDelegate, UITextViewDelegate, CalendarHomeViewDelegate, YSAlbumImageViewDelegate> {
    BOOL keyboardIsShown;   //!> 键盘是否弹出来.
    UILabel *sliderLabel;   //!> 选择人数上限上面展示的数字.
    BOOL isClickPublish;    //!> 是否点击发布.
    BOOL isClickUploadImage;    //!> 是否点击上传封面.
    BOOL isCompanyPlay;         //!> 是否陪玩.
    BOOL isProvideHome;         //!> 是否提供住宿.
    BOOL isProvideCar;          //!> 是否提供包车.
    BOOL isProvideMeal;         //!> 是否提供包饭.
    
    BOOL isChooseCover;
    BOOL isClickNextBtn;
    NSString *coverImageURLString;
}

/// 滚动视图.
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/// 滚动视图整体容器.
@property (weak, nonatomic) IBOutlet UIView *frameView;
/// 左上角返回按钮.
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButtonItem;
/// 目的地文本.
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
/// 上传图片整体视图.
@property (weak, nonatomic) IBOutlet UIView *addPhotoView;
/// 上传封面图片控件.
@property (weak, nonatomic) IBOutlet YSAlbumImageView *coverImageView;
/// 约伴宣言输入框.
@property (weak, nonatomic) IBOutlet UITextField *declarationTextField;
/// 旅行描述图标.
@property (weak, nonatomic) IBOutlet UIImageView *tourDescImageView;
/// 旅行描述输入试图.
@property (weak, nonatomic) IBOutlet LCTextView *tourDescTextView;
/// 日历图标.
@property (weak, nonatomic) IBOutlet UIImageView *calendarImageView;
/// 开始时间文本框.
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
/// 结束时间展示文本.
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
/// 出发时间提示文本.
@property (weak, nonatomic) IBOutlet UILabel *startDateHintLabel;
/// 结束时间提示文本.
@property (weak, nonatomic) IBOutlet UILabel *endDateHintLabel;
/// 旅行宣言提示图标.
@property (weak, nonatomic) IBOutlet UIImageView *tourDeclarationImageView;
/// 招待服务图标.
@property (weak, nonatomic) IBOutlet UIImageView *companyHintImageView;
/// 陪玩按钮.
@property (weak, nonatomic) IBOutlet UIButton *servicePlayBtn;
/// 包住按钮.
@property (weak, nonatomic) IBOutlet UIButton *serviceHomeBtn;
/// 包车按钮.
@property (weak, nonatomic) IBOutlet UIButton *serviceCarBtn;
/// 管饭按钮.
@property (weak, nonatomic) IBOutlet UIButton *serviceMealBtn;
/// 陪玩字体提示.
@property (weak, nonatomic) IBOutlet UILabel *servicePlayHintLabel;
/// 包住字体提示.
@property (weak, nonatomic) IBOutlet UILabel *serviceHomeHintLabel;
/// 包车字体提示.
@property (weak, nonatomic) IBOutlet UILabel *serviceCarHintLabel;
/// 管饭字体提示.
@property (weak, nonatomic) IBOutlet UILabel *serviceMealHintLabel;
/// 招待服务备注.
@property (weak, nonatomic) IBOutlet LCTextView *noteTextView;
/// 人数上限提示图标.
@property (weak, nonatomic) IBOutlet UIImageView *upperMemberImageView;
/// 选择人数上限滑块.
@property (weak, nonatomic) IBOutlet UISlider *numberSlider;
/// 选择人数上限视图.
@property (weak, nonatomic) IBOutlet UIView *chooseNumberView;
/// 下一步按钮.
@property (weak, nonatomic) IBOutlet UIButton *publishButton;

/// 起止时间高度.
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startAndEndDateViewHeightConstraint;
/// 出发时间展示文本离上层视图的高度.
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startDateTopConstraint;
/// 出发时间提示文本宽度.
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startDateWidthConstraint;
/// 出发时间提示文本离上层视图的高度.
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startDateHintTopConstraint;
/// 出发和回程的视图提示图标.
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateHintImageViewConstraint;
/// 包住和陪玩的间距.
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstCompanyGapConstraint;
/// 包车和包住的间距.
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondConmpanyGapConstraint;

@end


@implementation LCNewReceptionPlanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 初始化变量.
    [self initVariable];
    /// 初始化返回按钮图片.
//    [self initButtonItem];
    /// 调整滚动视图上面的没有缝隙.
    [self initSliderHintView];
    /// 初始化滚动视图.
    [self initScrollView];
    /// 初始化宣言输入视图.
    [self initDeclarationTextField];
    /// 初始化旅行描述信息.
    [self initTourDescTextView];
    /// 初始化详细服务描述.
    [self initNoteTextView];
    /// 初始化封面视图.
    [self initCoverImageView];
    /// 初始化发布按钮.
    [self initPublishButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /// 更新各个控件的初始值.
    [self updateAllViewData];
    /// 更新招待按钮的间距.
    [self updateCompanyGap];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[self updateData];
    /// 更新人数上限.
    [self updateSliderHintView];
    /// 更新起止时间的显示.
    [self updateStartEndTime];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    /// 保存输入的信息.
    [self saveReceptionPlan];
}

/// 初始化变量.
- (void)initVariable {
    /// 适配iOS7.0上面没有缝隙.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    isCompanyPlay = YES;
    isProvideCar = NO;
    isProvideHome = NO;
    isProvideMeal = NO;

    isChooseCover = NO;
    coverImageURLString = @"";
    isClickNextBtn = NO;
}

/// 初始化返回按钮图片.
- (void)initButtonItem {
    /// 使用资源原图片.
    UIImage *backImage = [[UIImage imageNamed:@"NavigationBackBG"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.backButtonItem setImage:backImage];
}

/// 初始化显示人数上限数字.
- (void)initSliderHintView {
    sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 48.0, 50.0, 15.0)];
    sliderLabel.textAlignment = NSTextAlignmentCenter;
    sliderLabel.font = [UIFont systemFontOfSize:15.0f];
    sliderLabel.text = [NSString stringWithFormat:@"%d", PLAN_MAX_SCALE];
    sliderLabel.textColor = UIColorFromRGBA(CONTENT_HINT_COLOR, 1.0f);
    [self.chooseNumberView addSubview:sliderLabel];
}

/// 初始化滚动视图.
- (void)initScrollView {
    self.scrollView.delegate = self;
}

/// 初始化宣言输入视图.
- (void)initDeclarationTextField {
    self.declarationTextField.delegate = self;
}

/// 初始化旅行描述信息.
- (void)initTourDescTextView {
    self.tourDescTextView.delegate = self;
    self.tourDescTextView.placeholder = @"可选填";
    self.tourDescTextView.placeHolderLabel.font = [UIFont fontWithName:APP_CHINESE_FONT size:14.0];
}

/// 初始化详细服务描述.
- (void)initNoteTextView {
    self.noteTextView.delegate = self;
    self.noteTextView.placeholder = @"详细服务描述";
}

/// 初始化封面视图.
- (void)initCoverImageView {
    self.coverImageView.albumDelegate = self;
    self.coverImageView.imageCategory = ImageCategoryCover;
}

/// 初始化发布按钮.
- (void)initPublishButton {
    self.publishButton.layer.borderWidth = 0.5f;
    self.publishButton.layer.borderColor = [UIColorFromRGBA(APP_COLOR, 1.0f) CGColor];
}

/// 更新各个控件的初始值.
- (void)updateAllViewData {
    LCReceptionPlan *receptionPlan = [LCDataManager sharedInstance].receptionPlan;
    if ([LCStringUtil isNotNullString:receptionPlan.destinationName]) {
        self.destinationLabel.text = receptionPlan.destinationName;
    }
    if ([LCStringUtil isNotNullString:receptionPlan.imageCover]) {
        self.coverImageView.imageURL = [NSURL URLWithString:receptionPlan.imageCover];
        coverImageURLString = receptionPlan.imageCover;
    }
    if ([LCStringUtil isNotNullString:receptionPlan.declaration]) {
        self.declarationTextField.text = receptionPlan.declaration;
    }
    if ([LCStringUtil isNotNullString:receptionPlan.descriptionStr]) {
        self.tourDescTextView.text = receptionPlan.descriptionStr;
    }
    if ([LCStringUtil isNotNullString:receptionPlan.startTime]) {
        self.startDateLabel.text = receptionPlan.startTime;
    }
    if ([LCStringUtil isNotNullString:receptionPlan.endTime]) {
        self.endDateLabel.text = receptionPlan.endTime;
    }
    sliderLabel.text = [NSString stringWithFormat:@"%ld", (long)receptionPlan.scaleMax];
    self.numberSlider.value = (receptionPlan.scaleMax - 2.0) / (PLAN_MAX_SCALE - 2.0);
    isCompanyPlay = receptionPlan.serviceAccompany;
    [self updatePlayBtn];
    isProvideCar = receptionPlan.serviceCar;
    [self updateCarBtn];
    isProvideHome = receptionPlan.serviceHotel;
    [self updateHomeBtn];
    isProvideMeal = receptionPlan.serviceDinner;
    [self updateMealBtn];
    self.noteTextView.text = receptionPlan.serviceDesc;
}

/// 更新起止时间显示.
- (void)updateStartEndTime {
    LCReceptionPlan *receptionPlan = [LCDataManager sharedInstance].receptionPlan;
    if ([LCStringUtil isNullString:receptionPlan.endTime]) {
        return ;
    }
    
    self.startDateHintLabel.text = @"开始";
    self.endDateLabel.hidden = NO;
    self.endDateHintLabel.hidden = NO;
    self.startDateWidthConstraint.constant = 36;
    self.startDateTopConstraint.constant = 20;
    self.startAndEndDateViewHeightConstraint.constant = 90;
    self.startDateHintTopConstraint.constant = 20;
    self.dateHintImageViewConstraint.constant = 20;
    self.startDateLabel.textColor = UIColorFromRGBA(CONTENT_TITLE_COLOR, 1.0);
    self.calendarImageView.image = [UIImage imageNamed:@"PartnerCalendarHL"];
}

/// 更新选择人数上线进度条.
- (void)updateSliderHintView {
    CGFloat value = self.numberSlider.value;
    CGFloat x = 17.0 + (self.chooseNumberView.frame.size.width - 36.0) * value;
    sliderLabel.center = CGPointMake(x, sliderLabel.center.y);
    
    CGFloat labelValue = (PLAN_MAX_SCALE - 2.0) * value + 2.0;
    sliderLabel.text = [NSString stringWithFormat:@"%.f", labelValue];
}

/// 更新招待按钮的间距.
- (void)updateCompanyGap {
    CGFloat gap = (DEVICE_WIDTH - 2 * 15.0f - 4 * 50.0f) / 3.0f;
    self.firstCompanyGapConstraint.constant = gap;
    self.secondConmpanyGapConstraint.constant = gap;
}

/// 更新管饭按钮展示.
- (void)updateMealBtn {
    if (isProvideMeal) {
        [self.serviceMealBtn setImage:[UIImage imageNamed:@"ReceptionProvideMealHL"] forState:UIControlStateNormal];
        self.serviceMealHintLabel.textColor = UIColorFromRGBA(SERVICE_CHOOSE_CONTENT_COLOR, 1.0);
    } else {
        [self.serviceMealBtn setImage:[UIImage imageNamed:@"ReceptionProvideMeal"] forState:UIControlStateNormal];
        self.serviceMealHintLabel.textColor = UIColorFromRGBA(SERVICE_UNCHOOSE_CONTENT_COLOR, 1.0);
    }
}

/// 更新包车按钮展示.
- (void)updateCarBtn {
    if (isProvideCar) {
        [self.serviceCarBtn setImage:[UIImage imageNamed:@"RecptionProvideCarHL"] forState:UIControlStateNormal];
        self.serviceCarHintLabel.textColor = UIColorFromRGBA(SERVICE_CHOOSE_CONTENT_COLOR, 1.0);
    } else {
        [self.serviceCarBtn setImage:[UIImage imageNamed:@"RecptionProvideCar"] forState:UIControlStateNormal];
        self.serviceCarHintLabel.textColor = UIColorFromRGBA(SERVICE_UNCHOOSE_CONTENT_COLOR, 1.0);
    }
}

/// 更新包住按钮展示.
- (void)updateHomeBtn {
    if (isProvideHome) {
        [self.serviceHomeBtn setImage:[UIImage imageNamed:@"ReceptionProvideHomeHL"] forState:UIControlStateNormal];
        self.serviceHomeHintLabel.textColor = UIColorFromRGBA(SERVICE_CHOOSE_CONTENT_COLOR, 1.0);
    } else {
        [self.serviceHomeBtn setImage:[UIImage imageNamed:@"ReceptionProvideHome"] forState:UIControlStateNormal];
        self.serviceHomeHintLabel.textColor = UIColorFromRGBA(SERVICE_UNCHOOSE_CONTENT_COLOR, 1.0);
    }
}

/// 更新陪玩按钮展示.
- (void)updatePlayBtn {
    if (isCompanyPlay) {
        [self.servicePlayBtn setImage:[UIImage imageNamed:@"ReceptionCompanyPlayHL"] forState:UIControlStateNormal];
        self.servicePlayHintLabel.textColor = UIColorFromRGBA(SERVICE_CHOOSE_CONTENT_COLOR, 1.0);
    } else {
        [self.servicePlayBtn setImage:[UIImage imageNamed:@"ReceptionCompanyPlay"] forState:UIControlStateNormal];
        self.servicePlayHintLabel.textColor = UIColorFromRGBA(SERVICE_UNCHOOSE_CONTENT_COLOR, 1.0);
    }
}

/// 隐藏键盘.
- (void)hiddenKeyboard {
    [self.declarationTextField resignFirstResponder];
    [self.tourDescTextView resignFirstResponder];
    [self.noteTextView resignFirstResponder];
}

/// 跳转添加景点页面.
- (void)goToAddPlacesPage {
    [self hiddenKeyboard];
    [self hideHudInView];
    
    LCAddPlacesVC *controller = (LCAddPlacesVC *)[LCStoryboardManager viewControllerWithFileName:SBNameReceptionPlan identifier:VCIDAddPlacesVC];
    [self.navigationController pushViewController:controller animated:APP_ANIMATION];
}

/// 保存输入的信息.
- (void)saveReceptionPlan {
    LCReceptionPlan *receptionPlan = [LCDataManager sharedInstance].receptionPlan;
    if (nil != receptionPlan) {
        receptionPlan.declaration = self.declarationTextField.text;
        receptionPlan.descriptionStr = self.tourDescTextView.text;
        if (NO == [LCStringUtil isNotNullString:self.endDateLabel.text]) {
            receptionPlan.startTime = @"";
            receptionPlan.endTime = @"";
        } else {
            receptionPlan.startTime = self.startDateLabel.text;
            receptionPlan.endTime = self.endDateLabel.text;
        }
        receptionPlan.scaleMax = [sliderLabel.text integerValue];
        receptionPlan.serviceAccompany = isCompanyPlay;
        receptionPlan.serviceDinner = isProvideMeal;
        receptionPlan.serviceHotel = isProvideHome;
        receptionPlan.serviceCar = isProvideCar;
        receptionPlan.serviceDesc = self.noteTextView.text;
        
        if ([LCStringUtil isNotNullString:coverImageURLString]) {
            receptionPlan.imageCover = coverImageURLString;
            NSString *coverColor = [LCImageUtil getMostColorStr:self.coverImageView.image];
            receptionPlan.coverColor = coverColor;
        }
    }
}

#pragma mark - Actions
/// 滚动人数上限进度条.
- (IBAction)numberSliderValueChangeAction:(id)sender {
    [self hiddenKeyboard];
    self.upperMemberImageView.image = [UIImage imageNamed:@"PartnerUpperMemberHL"];
    [self updateSliderHintView];
    UISlider *slider = (UISlider *)sender;
    CGFloat value = slider.value;
    CGFloat labelValue = (PLAN_MAX_SCALE - 2.0) * value + 2.0;
    sliderLabel.text = [NSString stringWithFormat:@"%.f", labelValue];
}

/// 是否提供管饭招待.
- (IBAction)provideMealAction:(id)sender {
    isProvideMeal = !isProvideMeal;
    [self updateMealBtn];
}

/// 提供包车招待.
- (IBAction)provideCarAction:(id)sender {
    isProvideCar = !isProvideCar;
    [self updateCarBtn];
}

/// 提供包住招待.
- (IBAction)provideHomeAction:(id)sender {
    isProvideHome = !isProvideHome;
    [self updateHomeBtn];
}

/// 提供陪玩招待.
- (IBAction)companyPlayAction:(id)sender {
    isCompanyPlay = !isCompanyPlay;
    [self updatePlayBtn];
}

/// 点击下一步按钮.
- (IBAction)nextStepAction:(id)sender {
    [self hiddenKeyboard];
    if ([LCStringUtil isNullString:self.destinationLabel.text]) {
        [YSAlertUtil alertOneMessage:@"目的地不能为空！"];
        return ;
    }
    
    if ([LCStringUtil isNullString:self.declarationTextField.text]) {
        [YSAlertUtil alertOneMessage:@"未填写招待宣言！"];
        return ;
    }
    LCReceptionPlan *receptionPlan = [LCDataManager sharedInstance].receptionPlan;
    if ([LCStringUtil isNullString:receptionPlan.planGuid]) {
        [self showHudInView:self.view hint:@"发布招待计划..."];
    } else {
        [self showHudInView:self.view hint:@"修改招待计划..."];
    }
    
    if (isChooseCover && [LCStringUtil isNotNullString:coverImageURLString]) {
        [self goToAddPlacesPage];
    }
    
    if (NO == isChooseCover) {
        [self goToAddPlacesPage];
        return ;
    }
    isClickNextBtn = YES;
}

/// 选择时间.
- (IBAction)chooseDayAction:(id)sender {
    [self hiddenKeyboard];
    CalendarHomeViewController *controller = [[CalendarHomeViewController alloc] init];
    controller.delegate = self;
    [controller setHotelToDay:365 selectStartDateforString:self.startDateLabel.text selectEndDateforString:self.endDateLabel.text];
    [self.navigationController pushViewController:controller animated:YES];
}

/// 点击键盘的完成按钮.
- (IBAction)textFieldReturnEditing:(id)sender {
    [sender resignFirstResponder];
    //isClickUploadImage = NO;
}

/// 返回上一个页面.
- (IBAction)backAction:(id)sender {
    [self hiddenKeyboard];
    [self.navigationController popViewControllerAnimated:APP_ANIMATION];
}

#pragma mark - CalendarHomeView Delegate
/// 选择起止时间完成.
- (void)chooseDateFinished:(CalendarHomeViewController *)controller {
    LCReceptionPlan *receptionPlan = [LCDataManager sharedInstance].receptionPlan;
    receptionPlan.startTime = controller.startDateStr;
    receptionPlan.endTime = controller.endDateStr;
    [self updateStartEndTime];
}

#pragma mark - UITextField Delegate
/// 结束输入旅行宣言.
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.declarationTextField) {
        if (textField.text.length > DECLARATION_MAX_LENGTH) {
            [YSAlertUtil alertOneMessage:@"输入的宣言不能超过16个字符！"];
            textField.text = [textField.text substringToIndex:DECLARATION_MAX_LENGTH];
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    CGPoint scrollPoint = CGPointMake(0, textView.superview.frame.origin.y - APP_NAVIGATION_HEIGHT - APP_NAVIGATION_STATUS_HEIGHT);
    [self.scrollView setContentOffset:scrollPoint animated:NO];
    
    if (textView == self.tourDescTextView) {
        self.tourDescImageView.image = [UIImage imageNamed:@"PartnerTourDescHL"];
    }
    if (textView == self.noteTextView) {
        self.companyHintImageView.image = [UIImage imageNamed:@"ReceptionServiceHL"];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.declarationTextField) {
        CGPoint scrollPoint = CGPointMake(0, textField.superview.frame.origin.y - APP_NAVIGATION_HEIGHT - APP_NAVIGATION_STATUS_HEIGHT);
        [self.scrollView setContentOffset:scrollPoint animated:NO];
        self.tourDeclarationImageView.image = [UIImage imageNamed:@"PartnerTourDeclarationHL"];
    }
}

#pragma mark - UIScrollView Delegate
/// 滚动消失键盘.
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.scrollView == scrollView) {
        [self hiddenKeyboard];
    }
}

#pragma mark - YSAlbumImageView Delegate
- (void)imageViewReadyUploadURL:(YSAlbumImageView *)imageView {
    coverImageURLString = imageView.uploadImageURL;
    if (isClickNextBtn) {
        [self goToAddPlacesPage];
    }
}

- (void)imageViewReadyImage:(UIImage *)image {
    isChooseCover = YES;
    coverImageURLString = @"";
    self.coverImageView.image = nil;
    self.coverImageView.imageURL = [NSURL URLWithString:@""];
    self.coverImageView.image = image;
}


/// 如果是更改接待计划，默认显示原来计划的值.
/*- (void)updateData {
 if (nil != self.receptionPlan) {
 self.title = @"修改招待计划";
 self.destinationLabel.text = self.receptionPlan.destinationName;
 if (nil == self.coverImageView.imageURL) {
 self.coverImageView.imageURL = [NSURL URLWithString:self.receptionPlan.imageCover];
 coverImageURL = self.receptionPlan.imageCover;
 }
 self.declarationTextField.text = self.receptionPlan.declaration;
 self.tourDescTextView.text = self.receptionPlan.descriptionStr;
 self.startDateLabel.text = self.receptionPlan.startTime;
 self.endDateLabel.text = self.receptionPlan.endTime;
 ZLog(@"the reception plan scale max is %tu", self.receptionPlan.scaleMax);
 self.numberSlider.value = (self.receptionPlan.scaleMax - 2.0) / 18.0;
 isProvideMeal = self.receptionPlan.serviceDinner;
 isProvideHome = self.receptionPlan.serviceHotel;
 isProvideCar = self.receptionPlan.serviceCar;
 isCompanyPlay = self.receptionPlan.serviceAccompany;
 [self updatePlayBtn];
 [self updateHomeBtn];
 [self updateMealBtn];
 [self updateCarBtn];
 
 self.noteTextView.text = self.receptionPlan.serviceDesc;
 }
 }*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  LCNewParnterPlanVC.m
//  LinkCity
//
//  Created by 张宗硕 on 11/2/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCNewPartnerPlanVC.h"
#import "LCXMPPUtil.h"
#import "UIScrollView+UITouchEvent.h"

#define kTabBarHeight 49
#define DECLARATION_MAX_LENGTH 16

@interface LCNewPartnerPlanVC () <UITextFieldDelegate, UIScrollViewDelegate, UITextViewDelegate, CalendarHomeViewDelegate, LCPartnerApiDelegate, YSAlbumImageViewDelegate> {
    BOOL keyboardIsShown;   //!> 键盘是否弹出来.
    UILabel *sliderLabel;   //!> 选择人数上限上面展示的数字.
    BOOL isClickPublish;    //!> 是否点击发布.
    NSString *imageCoverURLString;   //!> 封面地址.
    BOOL isClickUploadCover;    //!> 是否点击上传封面.
}

/// 滚动视图.
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/// 左上角返回按钮.
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButtonItem;
/// 目的地文本.
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
/// 约伴宣言输入框.
@property (weak, nonatomic) IBOutlet UITextField *declarationTextField;
/// 旅行描述输入试图.
@property (weak, nonatomic) IBOutlet LCTextView *tourDescTextView;
@property (weak, nonatomic) IBOutlet UIView *frameView;
/// 上传头像试图.
@property (weak, nonatomic) IBOutlet UIView *addPhotoView;
/// 开始时间文本框.
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
/// 起止时间高度.
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startAndEndDateViewHeightConstraint;
/// 出发时间提示文本.
@property (weak, nonatomic) IBOutlet UILabel *startDateHintLabel;
/// 出发时间提示文本宽度.
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startDateWidthConstraint;
/// 出发时间展示文本离上层视图的高度.
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startDateTopConstraint;
/// 出发时间提示文本离上层视图的高度.
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startDateHintTopConstraint;
/// 出发和回程的视图提示图标.
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateHintImageViewConstraint;
/// 结束时间展示文本.
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
/// 结束时间提示文本.
@property (weak, nonatomic) IBOutlet UILabel *endDateHintLabel;
/// 选择人数上限视图.
@property (weak, nonatomic) IBOutlet UIView *chooseNumberView;
/// 选择人数上限滑块.
@property (weak, nonatomic) IBOutlet UISlider *numberSlider;
/// 旅行宣言提示图标.
@property (weak, nonatomic) IBOutlet UIImageView *tourDeclarationImageView;
/// 旅行描述图标.
@property (weak, nonatomic) IBOutlet UIImageView *tourDescImageView;
/// 日历图标.
@property (weak, nonatomic) IBOutlet UIImageView *calendarImageView;
/// 人数上限提示图标.
@property (weak, nonatomic) IBOutlet UIImageView *upperMemberImageView;
/// 封面照片.
@property (weak, nonatomic) IBOutlet YSAlbumImageView *coverImageView;
/// 发布按钮.
@property (weak, nonatomic) IBOutlet UIButton *publishButton;

@end

@implementation LCNewPartnerPlanVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /// 初始化变量.
    [self initVariable];
    /// 初始化返回按钮图片.
//    [self initButtonItem];
    /// 调整滚动视图上面的没有缝隙.
    [self initSliderHintView];
    /// 初始化旅行描述信息.
    [self initAdjustsScrollView];
    /// 初始化旅行描述信息.
    [self initTourDescTextView];
    /// 初始化封面视图.
    [self initCoverImageView];
    /// 初始化滚动视图.
    [self initScrollView];
    /// 初始化宣言输入视图.
    [self initDeclarationTextField];
    /// 初始化发布按钮.
    [self initPublishButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /// 更新各个控件的初始值.
    [self updateAllViewData];
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
    [self savePartnerPlan];
}

/// 初始化变量.
- (void)initVariable {
    /// 初始状态没有点击发布按钮.
    isClickPublish = NO;
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

/// 调整滚动视图上面的没有缝隙.
- (void)initAdjustsScrollView {
    /// 适配iOS7.0上面没有缝隙.
    self.automaticallyAdjustsScrollViewInsets = NO;
}

/// 初始化旅行描述信息.
- (void)initTourDescTextView {
    self.tourDescTextView.delegate = self;
    self.tourDescTextView.placeholder = @"可选填";
    self.tourDescTextView.placeHolderLabel.font = [UIFont fontWithName:APP_CHINESE_FONT size:14.0];
}

/// 初始化封面视图.
- (void)initCoverImageView {
    self.coverImageView.albumDelegate = self;
    self.coverImageView.imageCategory = ImageCategoryCover;
}

/// 初始化滚动视图.
- (void)initScrollView {
    self.scrollView.delegate = self;
}

/// 初始化宣言输入视图.
- (void)initDeclarationTextField {
    self.declarationTextField.delegate = self;
}

/// 初始化发布按钮.
- (void)initPublishButton {
    self.publishButton.layer.borderWidth = 0.5f;
    self.publishButton.layer.borderColor = [UIColorFromRGBA(APP_COLOR, 1.0f) CGColor];
}

/// 更新各个控件的初始值.
- (void)updateAllViewData {
    LCPartnerPlan *partnerPlan = [LCDataManager sharedInstance].partnerPlan;
    if ([LCStringUtil isNotNullString:partnerPlan.destinationName]) {
        self.destinationLabel.text = partnerPlan.destinationName;
    }
    if ([LCStringUtil isNotNullString:partnerPlan.imageCover]) {
        self.coverImageView.imageURL = [NSURL URLWithString:partnerPlan.imageCover];
        imageCoverURLString = partnerPlan.imageCover;
    }
    if ([LCStringUtil isNotNullString:partnerPlan.declaration]) {
        self.declarationTextField.text = partnerPlan.declaration;
    }
    if ([LCStringUtil isNotNullString:partnerPlan.descriptionStr]) {
        self.tourDescTextView.text = partnerPlan.descriptionStr;
    }
    if ([LCStringUtil isNotNullString:partnerPlan.startTime]) {
        self.startDateLabel.text = partnerPlan.startTime;
    }
    if ([LCStringUtil isNotNullString:partnerPlan.endTime]) {
        self.endDateLabel.text = partnerPlan.endTime;
    }
    sliderLabel.text = [NSString stringWithFormat:@"%ld", (long)partnerPlan.scaleMax];
    self.numberSlider.value = (partnerPlan.scaleMax - 2.0) / (PLAN_MAX_SCALE - 2.0);
}

/// 保存输入的信息.
- (void)savePartnerPlan {
    LCPartnerPlan *partnerPlan = [LCDataManager sharedInstance].partnerPlan;
    if (nil != partnerPlan) {
        partnerPlan.destinationName = self.destinationLabel.text;
        partnerPlan.imageCover = imageCoverURLString;
        partnerPlan.declaration = self.declarationTextField.text;
        partnerPlan.descriptionStr = self.tourDescTextView.text;
        partnerPlan.startTime = self.startDateLabel.text;
        partnerPlan.endTime = self.endDateLabel.text;
        partnerPlan.scaleMax = [sliderLabel.text integerValue];
    }
}

/// 消失键盘.
- (void)hiddenKeyboard {
    [self.declarationTextField resignFirstResponder];
    [self.tourDescTextView resignFirstResponder];
}

/// 更新起止时间的视图.
- (void)updateStartEndTime {
    LCPartnerPlan *partnerPlan = [LCDataManager sharedInstance].partnerPlan;
    if ([LCStringUtil isNullString:partnerPlan.endTime]) {
        return ;
    }
    
    self.startDateLabel.text = partnerPlan.startTime;
    self.endDateLabel.text = partnerPlan.endTime;
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

/// 更新人数上限.
- (void)updateSliderHintView {
    CGFloat value = self.numberSlider.value;
    CGFloat x = 17.0 + (self.chooseNumberView.frame.size.width - 36.0) * value;
    sliderLabel.center = CGPointMake(x, sliderLabel.center.y);
    CGFloat labelValue = (PLAN_MAX_SCALE - 2.0) * value + 2.0;
    sliderLabel.text = [NSString stringWithFormat:@"%.f", labelValue];
}

/// 发布一个约伴计划.
- (void)publishNewPartner {
    LCPartnerPlan *partnerPlan = [LCDataManager sharedInstance].partnerPlan;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (NPT_EDIT_PARTNER == self.type) {
        [dic setObject:partnerPlan.planGuid forKey:@"PlanGuid"];
    }
    [dic setObject:partnerPlan.destinationId forKey:@"DestinationId"];
    [dic setObject:partnerPlan.destinationName forKey:@"DestinationName"];
    
    if (NO == [LCStringUtil isNotNullString:self.endDateLabel.text]) {
        [dic setObject:@"" forKey:@"StartTime"];
        [dic setObject:@"" forKey:@"EndTime"];
    } else {
        [dic setObject:self.startDateLabel.text forKey:@"StartTime"];
        [dic setObject:self.endDateLabel.text forKey:@"EndTime"];
    }
    [dic setObject:sliderLabel.text forKey:@"ScaleMax"];
    if ([LCStringUtil isNotNullString:imageCoverURLString]) {
        [dic setObject:[LCStringUtil getNotNullStr:imageCoverURLString] forKey:@"ImageCover"];
        NSString *coverColor = [LCImageUtil getMostColorStr:self.coverImageView.image];
        [dic setObject:coverColor forKey:@"CoverColor"];
    }
    [dic setObject:self.declarationTextField.text forKey:@"Declaration"];
    [dic setObject:self.tourDescTextView.text forKey:@"Description"];
    
    LCPartnerApi *api = [[LCPartnerApi alloc] init];
    api.delegate = self;
    [api publishNewPartner:dic];
}


#pragma mark - Actions
/// 点击完成按钮.
- (IBAction)publishPartnerAction:(id)sender {
    [self hiddenKeyboard];
    if ([LCStringUtil isNullString:self.destinationLabel.text]) {
        [YSAlertUtil alertOneMessage:@"目的地不能为空！"];
        return ;
    }
    if ([LCStringUtil isNullString:self.declarationTextField.text]) {
        [YSAlertUtil alertOneMessage:@"未填写约伴宣言！"];
        return ;
    }
    if (NPT_NEW_PARTNER == self.type) {
        [self showHudInView:self.view hint:@"正在发布约伴计划..."];
    } else {
        [self showHudInView:self.view hint:@"正在修改约伴计划..."];
    }
    if (NO == isClickUploadCover) {
        [self publishNewPartner];
        return ;
    }
    if ([LCStringUtil isNotNullString:imageCoverURLString]) {
        [self publishNewPartner];
    } else {
        isClickPublish = YES;
    }
}

/// 滚动人数上限进度条.
- (IBAction)numberSliderValueChangeAction:(id)sender {
    self.upperMemberImageView.image = [UIImage imageNamed:@"PartnerUpperMemberHL"];
    [self updateSliderHintView];
    [self hiddenKeyboard];
}

- (IBAction)textFieldReturnEditing:(id)sender {
    [sender resignFirstResponder];
    //isClickUploadCover = NO;
}

/// 返回上一个页面.
- (IBAction)backAction:(id)sender {
    [self hiddenKeyboard];
    [self.navigationController popViewControllerAnimated:APP_ANIMATION];
}

/// 选择起止时间.
- (IBAction)chooseDayAction:(id)sender {
    [self hiddenKeyboard];
    CalendarHomeViewController *controller = [[CalendarHomeViewController alloc] init];
    controller.delegate = self;
    [controller setHotelToDay:365 selectStartDateforString:self.startDateLabel.text selectEndDateforString:self.endDateLabel.text];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UIScrollView Delegate
/// 滚动消失键盘.
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.scrollView == scrollView) {
        [self hiddenKeyboard];
    }
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

#pragma mark - YSAlbumImageView Delegate
/// 已经选择了封面图片.
- (void)imageViewReadyImage:(UIImage *)image {
    isClickUploadCover = YES;
    self.coverImageView.image = nil;
    self.coverImageView.imageURL = [NSURL URLWithString:@""];
    self.coverImageView.image = image;
}

/// 已经上传好了封面图片.
- (void)imageViewReadyUploadURL:(YSAlbumImageView *)imageView {
    imageCoverURLString = imageView.uploadImageURL;
    if (YES == isClickPublish) {
        [self publishNewPartner];
    }
}

#pragma mark - UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView == self.tourDescTextView) {
        CGPoint scrollPoint = CGPointMake(0, textView.superview.frame.origin.y - APP_NAVIGATION_HEIGHT - APP_NAVIGATION_STATUS_HEIGHT);
        [self.scrollView setContentOffset:scrollPoint animated:NO];
        self.tourDescImageView.image = [UIImage imageNamed:@"PartnerTourDescHL"];
    }
}

#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.declarationTextField) {
        CGPoint scrollPoint = CGPointMake(0, textField.superview.frame.origin.y - APP_NAVIGATION_HEIGHT - APP_NAVIGATION_STATUS_HEIGHT);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
        self.tourDeclarationImageView.image = [UIImage imageNamed:@"PartnerTourDeclarationHL"];
    }
}

#pragma mark - CalendarHomeView Delegate
/// 选择起止时间完成.
- (void)chooseDateFinished:(CalendarHomeViewController *)controller {
    LCPartnerPlan *partnerPlan = [LCDataManager sharedInstance].partnerPlan;
    partnerPlan.startTime = controller.startDateStr;
    partnerPlan.endTime = controller.endDateStr;
    [self updateStartEndTime];
}

#pragma mark - LCPartnerApi Delegate
- (void)partnerApi:(LCPartnerApi *)api didPublishNewPartner:(LCPartnerPlan *)plan withError:(NSError *)error {
    [self hideHudInView];
    if (!error) {
        if (NPT_NEW_PARTNER == self.type) {
            [self showHint:@"发布约伴计划成功！"];
        } else {
            [self showHint:@"修改约伴计划成功！"];
        }
        [LCXMPPUtil saveChatPlanGroup:plan];
        LCPartnerPlan *partnerPlan = [LCDataManager sharedInstance].partnerPlan;
        if (nil != partnerPlan && [LCStringUtil isNotNullString:partnerPlan.planGuid]) {
            [LCDataManager sharedInstance].isAutoScrollToLastestPlan = NO;
        } else {
            [LCDataManager sharedInstance].isAutoScrollToLastestPlan = YES;
        }
        [LCDataManager sharedInstance].partnerPlan = nil;
        [self.navigationController popToRootViewControllerAnimated:APP_ANIMATION];
    } else {
        [YSAlertUtil alertOneMessage:error.domain];
    }
}

@end

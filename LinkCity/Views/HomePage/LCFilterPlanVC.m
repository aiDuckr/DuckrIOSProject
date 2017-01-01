//
//  LCFilterPlanVC.m
//  LinkCity
//
//  Created by 张宗硕 on 11/15/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCFilterPlanVC.h"
#import "LCDateUtil.h"
#import "LCFilterResultVC.h"

@interface LCFilterPlanVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterPlanTypeWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *twoDayBtn;
@property (weak, nonatomic) IBOutlet UIButton *weekBtn;
@property (weak, nonatomic) IBOutlet UIButton *monthBtn;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet UISlider *numberSlider;
@property (weak, nonatomic) IBOutlet UIView *sliderUpperView;
@property (weak, nonatomic) IBOutlet UIImageView *upperMemberImageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButtonItem;
@property (weak, nonatomic) IBOutlet UIButton *allPlanBtn;
@property (weak, nonatomic) IBOutlet UIButton *partnerBtn;
@property (weak, nonatomic) IBOutlet UIButton *receptionBtn;
@property (weak, nonatomic) IBOutlet UILabel *destHintLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeHintLabel;
@property (weak, nonatomic) IBOutlet UILabel *allHintLabel;
@property (weak, nonatomic) IBOutlet UILabel *partnerHintLabel;
@property (weak, nonatomic) IBOutlet UILabel *receptionHintLabel;

@end

@implementation LCFilterPlanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 初始化成员变量.
    [self initVariable];
    /// 初始化导航栏.
//    [self initNavigationItem];
    /// 初始化人数上限
    [self initSliderHintView];
    /// 两天内.
    [self unChooseTimeBtn:self.twoDayBtn];
    /// 一周内.
    [self unChooseTimeBtn:self.weekBtn];
    /// 一月内.
    [self unChooseTimeBtn:self.monthBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /// 更新人数上限.
    [self updateSliderHintView];
}

/// 初始化成员变量.
- (void)initVariable {
    self.filterPlanTypeWidthConstraint.constant = DEVICE_WIDTH / 2.0f;
    self.timeType = TIME_TYPE_UNLIMIT;
    self.placeID = @"";
    self.startDate = @"";
    self.endDate = @"";
    self.planType = PLAN_TYPE_ALL_STR;
}

/// 初始化导航栏.
- (void)initNavigationItem {
    /// 使用资源原图片.
    UIImage *backImage = [[UIImage imageNamed:@"NavigationBackBG"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.backButtonItem setImage:backImage];
}

/// 初始化
- (void)initSliderHintView {
    sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 48.0, 50.0, 15.0)];
    sliderLabel.textAlignment = NSTextAlignmentCenter;
    sliderLabel.font = [UIFont systemFontOfSize:15.0f];
    sliderLabel.text = [NSString stringWithFormat:@"%d", PLAN_MAX_SCALE];
    sliderLabel.textColor = UIColorFromRGBA(CONTENT_HINT_COLOR, 1.0f);
    [self.sliderUpperView addSubview:sliderLabel];
}

/// 更新人数上限.
- (void)updateSliderHintView {
    CGFloat value = self.numberSlider.value;
    CGFloat x = 17.0 + 15.0 + (self.sliderUpperView.frame.size.width - 2 * 17.0f - 30.0f) * value;
    sliderLabel.center = CGPointMake(x, sliderLabel.center.y);
    
    CGFloat labelValue = (PLAN_MAX_SCALE - 2.0) * value + 2.0;
    sliderLabel.text = [NSString stringWithFormat:@"%.f", labelValue];
}

/// 选择时间.
- (void)chooseTimeBtn:(UIButton *)btn {
    self.timeHintLabel.hidden = YES;
    btn.layer.borderWidth = 0.0f;
    
    btn.layer.cornerRadius = 20.0f;
    btn.layer.masksToBounds = YES;
    
    [btn setTitleColor:UIColorFromR_G_B_A(108, 105, 101, 1.0f) forState:UIControlStateNormal];
    [btn setBackgroundColor:UIColorFromRGBA(APP_COLOR, 1.0f)];
}

/// 取消选择时间.
- (void)unChooseTimeBtn:(UIButton *)btn {
    if (TIME_TYPE_UNLIMIT == self.timeType) {
        self.timeHintLabel.hidden = NO;
    }
    btn.layer.borderColor = [UIColorFromRGBA(LINE_BG_COLOR, 1.0) CGColor];
    btn.layer.borderWidth = 0.5f;
    
    btn.layer.cornerRadius = 20.0f;
    btn.layer.masksToBounds = YES;
    
    [btn setTitleColor:UIColorFromR_G_B_A(226, 219, 204, 1.0f) forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark - Actions

/// 确定筛选.
- (IBAction)confirmFilterAction:(id)sender {
    if ([self.destinationLabel.text isEqualToString:@"目的地"]) {
        self.placeID = @"";
    }
    ZLog(@"the place id is %@", self.placeID);
    switch (self.timeType) {
        case TIME_TYPE_UNLIMIT:
            self.startDate = @"";
            self.endDate = @"";
            break;
        case TIME_TYPE_TWO_DAYS:
            self.startDate = [LCDateUtil getTodayStr];
            self.endDate = [LCDateUtil nDaysLaterStr:2];
            break;
        case TIME_TYPE_ONE_WEEK:
            self.startDate = [LCDateUtil getTodayStr];
            self.endDate = [LCDateUtil nDaysLaterStr:7];
            break;
        case TIME_TYPE_ONE_MONTH:
            self.startDate = [LCDateUtil getTodayStr];
            self.endDate = [LCDateUtil nDaysLaterStr:30];
            break;
        default:
            break;
    }
    
    self.scaleMax = [sliderLabel.text integerValue];
    LCFilterResultVC *vc = (LCFilterResultVC *)[LCStoryboardManager viewControllerWithFileName:SBNameHomePage identifier:VCIDFilterResultVC];
    vc.placeId = self.placeID;
    vc.scaleMax = self.scaleMax;
    vc.startDate = self.startDate;
    vc.endDate = self.endDate;
    vc.planType = self.planType;
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}

- (IBAction)sliderValueChange:(id)sender {
    self.upperMemberImageView.image = [UIImage imageNamed:@"PartnerUpperMemberHL"];
    [self updateSliderHintView];
}

- (IBAction)twoDaysAction:(id)sender {
    self.timeHintLabel.hidden = YES;
    UIButton *btn = (UIButton *)sender;
    if (TIME_TYPE_TWO_DAYS == self.timeType) {
        self.timeType = TIME_TYPE_UNLIMIT;
        [self unChooseTimeBtn:btn];
    } else {
        self.timeType = TIME_TYPE_TWO_DAYS;
        [self chooseTimeBtn:btn];
        [self unChooseTimeBtn:self.weekBtn];
        [self unChooseTimeBtn:self.monthBtn];
    }
}

- (IBAction)oneWeekAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (TIME_TYPE_ONE_WEEK == self.timeType) {
        self.timeType = TIME_TYPE_UNLIMIT;
        [self unChooseTimeBtn:btn];
    } else {
        self.timeType = TIME_TYPE_ONE_WEEK;
        [self chooseTimeBtn:btn];
        [self unChooseTimeBtn:self.twoDayBtn];
        [self unChooseTimeBtn:self.monthBtn];
    }
}

- (IBAction)oneMonthAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (TIME_TYPE_ONE_MONTH == self.timeType) {
        self.timeType = TIME_TYPE_UNLIMIT;
        [self unChooseTimeBtn:btn];
    } else {
        self.timeType = TIME_TYPE_ONE_MONTH;
        [self chooseTimeBtn:btn];
        [self unChooseTimeBtn:self.twoDayBtn];
        [self unChooseTimeBtn:self.weekBtn];
    }
}

- (IBAction)choosePlaceAction:(id)sender {
    LCSearchDestinationVC *controller = (LCSearchDestinationVC *)[LCStoryboardManager viewControllerWithFileName:SBNamePartnerPlan identifier:VCIDSearchDestination];
    controller.delegate = self;
    controller.searchType = SEARCH_DESTINATION_FILTER;
    [self.navigationController pushViewController:controller animated:APP_ANIMATION];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:APP_ANIMATION];
}

- (IBAction)allPlanBtnClicked:(id)sender {
    self.planType = PLAN_TYPE_ALL_STR;
    [self.allPlanBtn setImage:[UIImage imageNamed:@"HomePagePlanAllIconHL"] forState:UIControlStateNormal];
    [self.partnerBtn setImage:[UIImage imageNamed:@"HomePagePartnerIcon"] forState:UIControlStateNormal];
    [self.receptionBtn setImage:[UIImage imageNamed:@"HomePageReceptionPlanIcon"] forState:UIControlStateNormal];
    self.allHintLabel.textColor = UIColorFromR_G_B_A(108.0f, 105.0f, 101.0f, 1.0f);
    self.partnerHintLabel.textColor = UIColorFromR_G_B_A(226.0f, 219.0f, 204.0f, 1.0f);
    self.receptionHintLabel.textColor = UIColorFromR_G_B_A(226.0f, 219.0f, 204.0f, 1.0f);
}

- (IBAction)partnerBtnClicked:(id)sender {
    self.planType = PLAN_TYPE_PARNTER_STR;
    [self.allPlanBtn setImage:[UIImage imageNamed:@"HomePagePlanAllIcon"] forState:UIControlStateNormal];
    [self.partnerBtn setImage:[UIImage imageNamed:@"HomePagePartnerIconHL"] forState:UIControlStateNormal];
    [self.receptionBtn setImage:[UIImage imageNamed:@"HomePageReceptionPlanIcon"] forState:UIControlStateNormal];
    self.allHintLabel.textColor = UIColorFromR_G_B_A(226.0f, 219.0f, 204.0f, 1.0f);
    self.partnerHintLabel.textColor = UIColorFromR_G_B_A(108.0f, 105.0f, 101.0f, 1.0f);
    self.receptionHintLabel.textColor = UIColorFromR_G_B_A(226.0f, 219.0f, 204.0f, 1.0f);
}

- (IBAction)receptionBtnClicked:(id)sender {
    self.planType = PLAN_TYPE_RECEPTION_STR;
    [self.allPlanBtn setImage:[UIImage imageNamed:@"HomePagePlanAllIcon"] forState:UIControlStateNormal];
    [self.partnerBtn setImage:[UIImage imageNamed:@"HomePagePartnerIcon"] forState:UIControlStateNormal];
    [self.receptionBtn setImage:[UIImage imageNamed:@"HomePageReceptionPlanIconHL"] forState:UIControlStateNormal];
    self.allHintLabel.textColor = UIColorFromR_G_B_A(226.0f, 219.0f, 204.0f, 1.0f);
    self.partnerHintLabel.textColor = UIColorFromR_G_B_A(226.0f, 219.0f, 204.0f, 1.0f);
    self.receptionHintLabel.textColor = UIColorFromR_G_B_A(108.0f, 105.0f, 101.0f, 1.0f);
}

#pragma mark - LCSearchDestinationVC Delegate
- (void)searchDestinationFinished:(LCSearchDestinationVC *)destinationVC {
    self.destinationLabel.text = destinationVC.placeInfo.placeName;
    self.placeID = destinationVC.placeInfo.placeID;
    self.destHintLabel.hidden = YES;
    ZLog(@"the place id is %@", self.placeID);
}

@end

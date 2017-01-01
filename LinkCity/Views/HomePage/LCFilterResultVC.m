//
//  LCFilterResultVC.m
//  LinkCity
//
//  Created by 张宗硕 on 1/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCFilterResultVC.h"
#import "LCHomePagePlanCell.h"
#import "LCDateUtil.h"
#import "LCShareView.h"
#import "LCShareUtil.h"
#import "LCHomePageApi.h"

@interface LCFilterResultVC () <UITableViewDataSource, UITableViewDelegate, LCHomePagePlanCellDelegate, LCShareViewDelegate, LCHomePageApiDelegate> {
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *planArr;
/// 分享图层.
@property (strong, nonatomic) LCShareView *shareView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButtonItem;

@end

@implementation LCFilterResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 初始化导航栏.
//    [self initNavigationBar];
    /// 初始化计划列表控件.
    [self initTableView];
    /// 查询搜索结果.
    [self searchPlanListFromServer:@""];
    self.planArr = [[NSArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
//    self.planArr = [[NSArray alloc] init];
}

/// 初始化导航栏.
- (void)initNavigationBar {
    self.title = @"搜索结果";
    /// 使用资源原图片.
    UIImage *backImage = [[UIImage imageNamed:@"NavigationBackBG"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.backButtonItem setImage:backImage];
}

/// 初始化计划列表控件.
- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

/// 根据排序时间获取计划列表.
- (void)searchPlanListFromServer:(NSString *)orderTime {
    LCHomePageApi *api = [[LCHomePageApi alloc] init];
    api.delegate = self;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[LCStringUtil getNotNullStr:self.placeId] forKey:@"DestinationId"];
    [dic setObject:[LCStringUtil getNotNullStr:self.startDate] forKey:@"StartTime"];
    [dic setObject:[LCStringUtil getNotNullStr:self.endDate] forKey:@"EndTime"];
    [dic setObject:self.planType forKey:@"PlanType"];
    [dic setObject:[LCStringUtil integerToString:self.scaleMax] forKey:@"ScaleMax"];
    [dic setObject:[LCStringUtil getNotNullStr:orderTime] forKey:@"OrderTime"];
    [api searchPlanList:dic];
}

- (void)footerRereshing {
    if (!self.planArr || self.planArr.count <= 0) {
        [self searchPlanListFromServer:@""];
    } else {
        LCPlan *lastPlan = [self.planArr objectAtIndex:self.planArr.count - 1];
        ZLog(@"the last plan order time is %@", lastPlan.orderTime);
        [self searchPlanListFromServer:lastPlan.orderTime];
    }
}

/// 出行日期文字加阴影.
- (NSAttributedString *)getTimeLabelAttributedString:(LCPlan *)plan {
    if (nil == plan) {
        return [[NSAttributedString alloc] init];
    }
    NSInteger days = [LCDateUtil numberOfDaysFromTwoStr:plan.startTime withAnotherStr:plan.endTime];
    
    NSMutableAttributedString *timeText = [[NSMutableAttributedString alloc]initWithString:[LCDateUtil getDotDateFromHorizontalLineStr:plan.startTime] attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_FUTURA size:15]}];
    [timeText appendAttributedString:[[NSAttributedString alloc]initWithString:@" 玩" attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_LANTINGBLACK size:15]}]];
    [timeText appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%tu",days] attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_FUTURA size:15]}]];
    [timeText appendAttributedString:[[NSAttributedString alloc]initWithString:@"天" attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_LANTINGBLACK size:15]}]];
    return timeText;
}

/// 更新界面布局约束条件.
- (void)updateCellConstraint:(LCHomePagePlanCell *)cell {
    NSString *content = cell.declarationLabel.text;
    CGSize size = [content sizeWithAttributes: @{NSFontAttributeName:cell.declarationLabel.font}];
    cell.declarationLabelWidthConstraint.constant = size.width;
    
    if (IS_IPHONE_5_5S || IS_IPHONE_4_4S) {
        cell.destinationLabelHeightConstraint.constant = 14.0f;
    }
    if (IS_IPHONE_6_PLUS) {
        CGFloat width = (DEVICE_WIDTH - 2 * 15.0f - 6 * 40.0f) / 5;
        cell.firstGapWidthConstraint.constant = width;
        cell.secondGapWidthConstraint.constant = width;
        cell.thirdGapWidthConstraint.constant = width;
        cell.fourGapWidthConstraint.constant = width;
        cell.fiveGapWidthConstraint.constant = width;
    }
}

#pragma mark - Actions
- (IBAction)backAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:APP_ANIMATION];
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.planArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = (DEVICE_WIDTH * 18.0f) / 25.0f + 133.0f;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.planArr.count > indexPath.row) {
        LCPlan *plan = [self.planArr objectAtIndex:indexPath.row]; 
        [LCViewSwitcher pushToShowDetailOfPlan:plan onNavigationVC:self.navigationController];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"HomePagePlanCell";
    LCHomePagePlanCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[LCHomePagePlanCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }

    LCPlan *planInfo = [self.planArr objectAtIndex:indexPath.row];
    cell.plan = planInfo;
    cell.delegate = self;
    cell.controller = self;
    cell.destinationLabel.text = planInfo.destinationName;
    
    /// 封面显示封面主要颜色.
    cell.coverImageView.image = nil;
    cell.coverImageView.backgroundColor = nil;
    cell.coverImageView.backgroundColor = [LCImageUtil getColorFromColorStr:planInfo.coverColor];
    //cell.coverImageView.imageType = AFNImageTypeBlurredShowBlured;
    [cell.coverImageView setImageWithURL:[NSURL URLWithString:planInfo.imageCover]];
    cell.dateLabel.attributedText = [self getTimeLabelAttributedString:cell.plan];
    
    /// 群成员人数和规模.
    cell.planScaleLabel.text = [NSString stringWithFormat:@"%tu/%tu", planInfo.userNum, planInfo.scaleMax];
    cell.fovarLabel.text = [NSString stringWithFormat:@"%tu", planInfo.favorNum];
    cell.forwardLabel.text = [NSString stringWithFormat:@"%tu", planInfo.forwardNum];
    cell.declarationLabel.text = planInfo.declaration;
    if (planInfo.isFavored) {
        [cell.favorButton setImage:[UIImage imageNamed:@"HomePageLikeBtnHL"] forState:UIControlStateNormal];
    } else {
        [cell.favorButton setImage:[UIImage imageNamed:@"HomePageLikeBtn"] forState:UIControlStateNormal];
    }
    if ([PLAN_TYPE_PARNTER_STR isEqualToString:planInfo.planType]) {
        cell.planTypeTextLabel.text = @"约伴群";
        cell.planTypeIconImageView.image = [UIImage imageNamed:@"HomePagePartnerCellIcon"];
    } else if ([PLAN_TYPE_RECEPTION_STR isEqualToString:planInfo.planType]) {
        cell.planTypeTextLabel.text = @"招待群";
        cell.planTypeIconImageView.image = [UIImage imageNamed:@"HomePageReceptionCellIcon"];
    }
    
    UIImage *image = [UIImage imageNamed:@"HomePageEmptySeats"];
    
    for (UIButton *button in cell.avatarImageBtns) {
        [button setImage:image forState:UIControlStateNormal];
        button.hidden = YES;
    }
    
    for (UILabel *label in cell.nameLabels) {
        label.text = @"空座位";
        label.hidden = YES;
    }
    
    if (planInfo.memberList.count > 0) {
        LCUserInfo *userInfo = [planInfo.memberList objectAtIndex:0];
        cell.avatarBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        [cell.avatarBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:userInfo.avatarThumbUrl]];
    }
    
    NSInteger index = 0;
    for (LCUserInfo *user in planInfo.memberList) {
        if (index >= cell.avatarImageBtns.count) {
            break;
        }
        UIButton *button = [cell.avatarImageBtns objectAtIndex:index];
        UILabel *label = [cell.nameLabels objectAtIndex:index];
        button.hidden = NO;
        label.hidden = NO;
        [button setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:user.avatarThumbUrl]];
        label.text = user.nick;
        index++;
    }
    for ( ; index < planInfo.scaleMax && index < 6; ++index) {
        UIButton *button = [cell.avatarImageBtns objectAtIndex:index];
        UILabel *label = [cell.nameLabels objectAtIndex:index];
        button.hidden = NO;
        label.hidden = NO;
    }
    
    [self updateCellConstraint:cell];
    return cell;
}

#pragma mark - LCHomePageApi Delegate
- (void)homepageApi:(LCHomePageApi *)api didSearchPlanList:(NSArray *)planList relatePlanList:(NSArray *)relatePlan withError:(NSError *)error {
    if (error) {
        if ([LCStringUtil isNotNullString:error.domain]) {
            [self showHint:error.domain];
        }
    } else {
        if (nil == planList && 0 == planList.count && nil != relatePlan) {
            if ([LCStringUtil isNotNullString:api.msg]) {
                [self showHint:api.msg];
            }
            self.planArr = relatePlan;
        } else {
            /// 上拉加载更多.
            if(!planList || planList.count <= 0) {
                if (nil == self.planArr || 0 == self.planArr.count) {
                    [self showHint:@"没有相关的计划！"];
                } else {
                    [self showHint:@"没有更多了！"];
                }
            } else {
                self.planArr = [self.planArr arrayByAddingObjectsFromArray:planList];
            }
        }
        [self.tableView reloadData];
    }
    [self.tableView footerEndRefreshing];
}

#pragma mark - LCHomePagePlanCell Delegate
- (void)shareToSocialNetwork:(LCPlan *)plan {
    if (!self.shareView) {
        self.shareView = [LCShareView createInstance];
        self.shareView.delegate = self;
    }
    self.shareView.plan = plan;
    [LCShareView showShareView:self.shareView onViewController:self forPlan:plan];
}

#pragma mark - LCShareViewDelegate

- (void)shareWeixinAction:(LCPlan *)plan {
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareWeixinAction:plan presentedController:self];
    }];
}

- (void)shareWeixinTimeLineAction:(LCPlan *)plan {
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareWeixinTimeLineAction:plan presentedController:self];
    }];
}

- (void)shareWeiboAction:(LCPlan *)plan {
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareWeiboAction:plan presentedController:self];
    }];
}

- (void)shareRenrenAction:(LCPlan *)plan {
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareRenrenAction:plan presentedController:self];
    }];
}

- (void)shareDuckrAction:(LCPlan *)plan {
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareDuckrAction:plan presentedController:self];
    }];
}

- (void)cancelShareAction {
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){}];
}

@end

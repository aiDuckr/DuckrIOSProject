//
//  LCRecommendPlanVC.m
//  LinkCity
//
//  Created by roy on 6/1/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCRecommendPlanVC.h"
#import "LCRecommendUsersOfPlanView.h"
#import "LCPlanMiniCell.h"
#import "LCWebPlanCell.h"
#import "LCShareView.h"
#import "LCYellowSectionHeaderCell.h"

@interface LCRecommendPlanVC ()<UITableViewDataSource, UITableViewDelegate, LCRecommendUsersOfPlanViewDelegate, LCShareViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) LCRecommendUsersOfPlanView *recommendUserView;

@property (nonatomic, strong) LCShareView *shareView;
@property (nonatomic, strong) UIImage *formerNavigationBarShadowImage;

@property (nonatomic, strong) NSArray *recommendUserArray;
@property (nonatomic, strong) NSArray *recommendPlanArray;
@property (nonatomic, strong) NSArray *recommendWebPlanArray;
@end

@implementation LCRecommendPlanVC

+ (instancetype)createInstance{
    return (LCRecommendPlanVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSendPlan identifier:VCIDRecommendPlanVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGBA(LCViewBackGroundColor, 1);
    
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnAction:)];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    UIBarButtonItem *shareBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnAction:)];
    self.navigationItem.rightBarButtonItem = shareBarBtn;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCPlanMiniCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCPlanMiniCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCWebPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCWebPlanCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCYellowSectionHeaderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCYellowSectionHeaderCell class])];
    self.tableView.tableHeaderView = self.recommendUserView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.formerNavigationBarShadowImage = self.navigationController.navigationBar.shadowImage;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[LCUIConstants sharedInstance].navBarOpaqueImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = self.formerNavigationBarShadowImage;
}

- (void)updateShow{
    //当没有任何推荐内容时，到发布成功页面后，结束发约伴流程，进到约伴详情
    if (self.recommendUserArray.count<=0 &&
        self.recommendPlanArray.count<=0 &&
        self.recommendWebPlanArray.count<=0 ) {
        [YSAlertUtil tipOneMessage:@"发布成功！" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        
        [self dismissViewControllerAnimated:YES completion:^{
            [LCViewSwitcher pushToShowPlanDetailVCForPlan:self.plan on:[LCSharedFuncUtil getTopMostViewController].navigationController];
        }];
        
        return;
    }
    
    //Roy 2015.6.10
    /*根据推荐人数，调整HeaderView的高度
     当有两行、一行人时，高度可调整
     当无人时，自动计算的高度不对，因此手动设置高度为60
     */
    self.recommendUserView.userArray = self.recommendUserArray;
    [self.recommendUserView setNeedsLayout];
    [self.recommendUserView layoutIfNeeded];
    CGFloat height = [self.recommendUserView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = self.recommendUserView.frame;
    frame.size.height = height;
    if (self.recommendUserArray.count<=0) {
        frame.size.height = 60;
    }
    self.recommendUserView.frame = frame;
    self.tableView.tableHeaderView = self.recommendUserView;
    
    
    [self.tableView reloadData];
}

- (void)refreshData{
    [LCNetRequester getRecommendOfPlan:self.plan.planGuid callBack:^(NSArray *userArray, NSArray *planArray, NSArray *webPlanArray, NSError *error) {
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        }else{
            self.recommendUserArray = userArray;
            self.recommendPlanArray = planArray;
            self.recommendWebPlanArray = webPlanArray;
            [self updateShow];
        }
    }];
}

#pragma mark Setter & Getter
- (LCRecommendUsersOfPlanView *)recommendUserView{
    if (!_recommendUserView) {
        _recommendUserView = [LCRecommendUsersOfPlanView createInstance];
        _recommendUserView.delegate = self;
    }
    return _recommendUserView;
}

#pragma mark ButtonAction
- (void)leftBarBtnAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)shareBtnAction:(id)sender{
    [self sharePlan:self.plan];
}


//#pragma mark UIScrollView
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView == self.tableView) {
//        CGFloat yOffset = self.tableView.contentOffset.y;
//        yOffset = MAX(yOffset, 0);
//        yOffset = MIN(yOffset, 100);
//        CGFloat alpha = yOffset/100.0;
//        self.navigationController.navigationBar.backgroundColor = UIColorFromRGBA(0xffffff, alpha);
//    
//    }
//}
#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNum = 0;
    
    if (self.recommendPlanArray.count>0 || self.recommendWebPlanArray.count>0) {
        rowNum = self.recommendPlanArray.count + self.recommendWebPlanArray.count + 1; // section row
    }
    
    return rowNum;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    NSInteger planIndex = indexPath.row - 1;
    
    if (planIndex == -1) {
        //section row
        LCYellowSectionHeaderCell *sectionHeaderCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCYellowSectionHeaderCell class]) forIndexPath:indexPath];
        sectionHeaderCell.titleLabel.text = @"TA们也在找人";
        sectionHeaderCell.selectionStyle = UITableViewCellSelectionStyleNone;
        sectionHeaderCell.contentView.backgroundColor = [UIColor clearColor];
        cell = sectionHeaderCell;
    }else if (planIndex>=0 && planIndex < self.recommendPlanArray.count) {
        LCPlanModel *plan = [self.recommendPlanArray objectAtIndex:planIndex];
        LCPlanMiniCell *planMiniCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCPlanMiniCell class]) forIndexPath:indexPath];
        planMiniCell.plan = plan;
        cell = planMiniCell;
    }else if(planIndex >= self.recommendPlanArray.count &&
             planIndex < (self.recommendPlanArray.count + self.recommendWebPlanArray.count)){
        LCWebPlanModel *webPlan = [self.recommendWebPlanArray objectAtIndex:(planIndex - self.recommendPlanArray.count)];
        LCWebPlanCell *webPlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCWebPlanCell class]) forIndexPath:indexPath];
        webPlanCell.webPlanModel = webPlan;
        cell = webPlanCell;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 0;
    NSInteger planIndex = indexPath.row - 1;
    
    if (planIndex == -1) {
        cellHeight = [LCYellowSectionHeaderCell getCellHeight];
    }else if (planIndex < self.recommendPlanArray.count) {
        cellHeight = [LCPlanMiniCell getCellHeight];
    }else if(planIndex >= self.recommendPlanArray.count &&
             planIndex < (self.recommendPlanArray.count + self.recommendWebPlanArray.count)){
        cellHeight = [LCWebPlanCell getCellHeight];
    }
    
    return cellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger planIndex = indexPath.row - 1;
    
    
    if (planIndex < self.recommendPlanArray.count) {
        LCPlanModel *plan = [self.recommendPlanArray objectAtIndex:planIndex];
        [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan on:self.navigationController];
    }else if(planIndex >= self.recommendPlanArray.count &&
             planIndex < (self.recommendPlanArray.count + self.recommendWebPlanArray.count)){
        LCWebPlanModel *webPlan = [self.recommendWebPlanArray objectAtIndex:(planIndex - self.recommendPlanArray.count)];
        [LCViewSwitcher pushWebVCtoShowURL:webPlan.planUrl withTitle:webPlan.title on:self.navigationController];
    }
}

#pragma mark LCRecommendUsersOfPlanViewDelegate
- (void)recommendUsersOfPlanViewDidClickSeePlanDetail:(LCRecommendUsersOfPlanView *)view{
    [LCViewSwitcher pushToShowPlanDetailVCForPlan:self.plan on:self.navigationController];
}
- (void)recommendUsersOfPlanViewDidClickInvite:(LCRecommendUsersOfPlanView *)view{
    NSMutableArray *userToInvite = [[NSMutableArray alloc] init];
    for (int i=0; i<view.userArray.count; i++){
        //用户被选中了，并且被邀请用户不是自己
        if ([[view.userSelectionArray objectAtIndex:i] boolValue] &&
            ![[view.userArray[i] openfireAccount] isEqualToString:[LCDataManager sharedInstance].userInfo.openfireAccount]) {
            
            [userToInvite addObject:view.userArray[i]];
        }
    }
    
    NSString *msg;
    for (LCUserModel *user in userToInvite){
        
        NSDate *startDate = [LCDateUtil dateFromString:self.plan.startTime];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"M月dd日";
        NSString *dateString = [dateFormatter stringFromDate:startDate];
        NSString *destinationStr = @"";
        for (int i=0; i<self.plan.destinationNames.count; i++){
            if (i == 0) {
                destinationStr = self.plan.destinationNames[i];
            }else{
                destinationStr = [destinationStr stringByAppendingFormat:@"、%@",self.plan.destinationNames[i]];
            }
        }
        msg = [NSString stringWithFormat:@"Hi,%@,我%@要去%@玩儿，要不要一起？",user.nick,dateString,destinationStr];
        
        [[LCXMPPMessageHelper sharedInstance] sendChatMessage:msg toBareJidString:user.openfireAccount];
    }
    
    
    [YSAlertUtil tipOneMessage:@"邀请成功!" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
    self.recommendUserArray = nil;
    [self updateShow];
}


#pragma mark SharePlan
- (void)sharePlan:(LCPlanModel *)plan{
    if (!self.shareView) {
        self.shareView = [LCShareView createInstance];
        self.shareView.delegate = self;
    }
    [LCShareView showShareView:self.shareView onViewController:self forPlan:plan];
}

#pragma mark - LCShareViewDelegate
- (void)cancelShareAction
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){}];
}
- (void)shareWeixinAction:(LCPlanModel *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareWeixinAction:plan presentedController:self];
    }];
}

- (void)shareWeixinTimeLineAction:(LCPlanModel *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareWeixinTimeLineAction:plan presentedController:self];
    }];
}

- (void)shareWeiboAction:(LCPlanModel *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareWeiboAction:plan presentedController:self];
    }];
}

- (void)shareQQAction:(LCPlanModel *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareQQAction:plan presentedController:self];
    }];
}

- (void)shareDuckrAction:(LCPlanModel *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareDuckrAction:plan presentedController:self];
    }];
}

@end

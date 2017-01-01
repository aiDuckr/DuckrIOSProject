//
//  LCPlanRouteListVC.m
//  LinkCity
//
//  Created by roy on 2/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanRouteEditVC.h"

@interface LCPlanRouteEditVC ()<LCPlanRouteEditPlaceDelegate,LCPlanRouteCellForChargeInfoDelegate,UINavigationControllerDelegate,LCPlanRouteCellForRouteTitleDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewBottomLayoutConstraint;

@property (nonatomic, strong) LCPlanRouteCellForRouteTitle *titleCell;
@property (nonatomic, strong) LCPlanRouteCellForChargeInfo *chargeCell;
@end


static NSString *const reuseID_Day = @"LCPlanRouteCellForDay";
static NSString *const reuseID_Route = @"LCPlanRouteCellForRoute";
static NSString *const reuseID_AddRoute = @"LCPlanRouteCellForAddRoute";
static NSString *const reuseID_AddDay = @"LCPlanRouteCellForAddDay";
static NSString *const reuseID_Tip = @"LCPlanRouteCellForTips";

static const NSInteger DayCellHeight = 54;
static const NSInteger RouteCellHeight = 106;
static const NSInteger AddRouteCellHeight = 54;
static const NSInteger AddDayCellHeight = 132;
static const NSInteger TipCellHeight = 54;

@implementation LCPlanRouteEditVC

+ (instancetype)createInstance{
    return (LCPlanRouteEditVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSendPlan identifier:VCIDPlanRouteListVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"行程详情";
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    // disable swipe to pop
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:LCNavBarBackBarButtonImageName] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonAction)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBarButtonAction)];
    self.navigationItem.rightBarButtonItem = saveBarButton;
    
    LCLogInfo(@"%@,%f,%f",NSStringFromUIEdgeInsets(self.routeTableView.contentInset),self.topLayoutGuide.length,self.bottomLayoutGuide.length);
    
    self.routeTableView.delegate = self;
    self.routeTableView.dataSource = self;
    self.routeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.routeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCPlanRouteCellForRouteTitle class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCPlanRouteCellForRouteTitle class])];
    
    [self.routeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCPlanRouteCellForChargeInfo class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCPlanRouteCellForChargeInfo class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.routeTableView reloadData];
    
    LCLogInfo(@"%@,%f,%f",NSStringFromUIEdgeInsets(self.routeTableView.contentInset),self.topLayoutGuide.length,self.bottomLayoutGuide.length);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self mergeUIBackToData];
}

- (void)viewDidLayoutSubviews{
    LCLogInfo(@"viewDidLayoutSubviews %@,%f,%f",NSStringFromUIEdgeInsets(self.routeTableView.contentInset),self.topLayoutGuide.length,self.bottomLayoutGuide.length);
    
    if (self.tabBarController.tabBar.isHidden &&
        self.bottomLayoutGuide.length != 0 ) {
        self.containerViewBottomLayoutConstraint.constant = 0-self.bottomLayoutGuide.length;
        
        [self.view layoutIfNeeded];
    }
}

- (void)setEditingUserRoute:(LCUserRouteModel *)editingUserRoute{
    _editingUserRoute = editingUserRoute;
    self.planRouteDataSource = [[LCPlanRouteDataSource alloc] initWithUserRouteModel:self.editingUserRoute];
}

- (void)mergeUIBackToData{
    NSMutableArray *routeplaces = [[NSMutableArray alloc]init];
    for (LCPlanADay *aDay in self.planRouteDataSource.days){
        [routeplaces addObjectsFromArray:aDay.routes];
    }
    self.editingUserRoute.routePlaces = routeplaces;
    self.editingUserRoute.routeTitle = self.titleCell.titleTextField.text;
    self.editingUserRoute.routeCost = self.chargeCell.chargeInfoTextView.text;
}

#pragma mark UIButton Action
- (void)backBarButtonAction{
    [YSAlertUtil alertTwoButton:@"取消" btnTwo:@"退出" withTitle:nil msg:@"您还没有保存编辑的行程详情，确定要退出吗？" callBack:^(NSInteger chooseIndex) {
        if (chooseIndex == 1) {
            if ([self.delegate respondsToSelector:@selector(planRouteEditVCDidCancel:)]) {
                [self.delegate planRouteEditVCDidCancel:self];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            // user cancel to quit, do nothing
        }
    }];
}
- (void)saveBarButtonAction{
    [self mergeUIBackToData];
    
   
    if (!self.editingUserRoute.routePlaces || self.editingUserRoute.routePlaces.count<=0) {
        CGFloat tipY = TipDefaultYoffset;
        if (self.isShowingKeyboard) {
            tipY = TipAboveKeyboardYoffset;
        }
        [YSAlertUtil tipOneMessage:@"请至少添加一条当日行程" yoffset:tipY delay:TipErrorDelay];
        
        return;
    }
    
    
    [YSAlertUtil showHudWithHint:nil];
    [LCNetRequester sendRoute:self.editingUserRoute type:self.routeEditType callBack:^(LCUserModel *user, LCUserRouteModel *userRoute, NSError *error) {
        [YSAlertUtil hideHud];
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }else{
            [LCDataManager sharedInstance].userInfo = user;
            self.editingUserRoute = userRoute;
            if ([self.delegate respondsToSelector:@selector(planRouteEditVC:didSaveUserRoute:)]) {
                [self.delegate planRouteEditVC:self didSaveUserRoute:userRoute];
            }
            [YSAlertUtil tipOneMessage:@"保存路线成功" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfsections = [self.planRouteDataSource numberOfSections];
    LCLogInfo(@"numberOfSectionsInTableView %ld",(long)numberOfsections);
    
    return numberOfsections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRowsInSection = [self.planRouteDataSource numberOfRowsInSection:section];
    LCLogInfo(@"numberOfRowsInSection %ld",(long)numberOfRowsInSection);
    
    return numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCLogInfo(@"cellForRowAtIndexPath section:%ld,row:%ld",(long)indexPath.section,(long)indexPath.row);
    UITableViewCell *cell;
    
    LCPlanRouteCellType cellType = [self.planRouteDataSource getCellTypeAtIndexPath:indexPath];
    switch (cellType) {
        case LCPlanRouteCellTypeRouteTitle:
        {
            LCPlanRouteCellForRouteTitle *titleCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCPlanRouteCellForRouteTitle class]) forIndexPath:indexPath];
            titleCell.titleTextField.text = [LCStringUtil getNotNullStr:self.editingUserRoute.routeTitle];
            titleCell.delegate = self;
            self.titleCell = titleCell;
            
            if (self.isViewWillAppearCalledFirstTime) {
                [titleCell.titleTextField becomeFirstResponder];
            }
            
            cell = titleCell;
        }
            break;
        case LCPlanRouteCellTypeDay:
        {
            LCPlanRouteCellForDay *dayCell = [tableView dequeueReusableCellWithIdentifier:reuseID_Day];
            dayCell.dayTitleLabel.text = [NSString stringWithFormat:@"Day%ld",(long)[self.planRouteDataSource getRouteDayAtIndexPath:indexPath]];
            [dayCell setFolded:[self.planRouteDataSource getADayAtIndexPath:indexPath].isFolded];
            cell = dayCell;
        }
            break;
        case LCPlanRouteCellTypeRoute:
        {
            LCPlanRouteCellForRoute *routeCell = [tableView dequeueReusableCellWithIdentifier:reuseID_Route];
            routeCell.routePlace = [self.planRouteDataSource getRoutePlaceAtIndexPath:indexPath];
            cell = routeCell;
        }
            break;
        case LCPlanRouteCellTypeAddRoute:
        {
            LCPlanRouteCellForAddRoute *addRouteCell = [tableView dequeueReusableCellWithIdentifier:reuseID_AddRoute];
            cell = addRouteCell;
        }
            break;
        case LCPlanRouteCellTypeAddDay:
        {
            LCPlanRouteCellForAddDay *addDayCell = [tableView dequeueReusableCellWithIdentifier:reuseID_AddDay];
            addDayCell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell = addDayCell;
        }
            break;
        case LCPlanRouteCellTypeTips:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:reuseID_Tip];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        case LCPlanRouteCellTypeChargeInfo:
        {
            LCPlanRouteCellForChargeInfo *chargeCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCPlanRouteCellForChargeInfo class]) forIndexPath:indexPath];
            chargeCell.chargeInfoTextView.text = [LCStringUtil getNotNullStr:self.editingUserRoute.routeCost];
            chargeCell.delegate = self;
            self.chargeCell = chargeCell;
            cell = chargeCell;
        }
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LCPlanRouteCellType cellType = [self.planRouteDataSource getCellTypeAtIndexPath:indexPath];
    switch (cellType) {
        case LCPlanRouteCellTypeRouteTitle:
        {
            LCPlanRouteCellForRouteTitle *cell = (LCPlanRouteCellForRouteTitle *)[tableView cellForRowAtIndexPath:indexPath];
            [cell.titleTextField becomeFirstResponder];
        }
            break;
        case LCPlanRouteCellTypeDay:
        {
            LCPlanADay *aDay = [self.planRouteDataSource getADayAtIndexPath:indexPath];
            if (aDay.isFolded) {
                [self unfoldDayAtSection:indexPath.section];
            }else{
                [self foldDayAtSection:indexPath.section];
            }
        }
            break;
        case LCPlanRouteCellTypeRoute:
        {
            LCPlanRouteEditPlaceVC *routeEditVC = [LCPlanRouteEditPlaceVC createInstance];
            routeEditVC.delegate = self;
            [routeEditVC editPlace:[self.planRouteDataSource getRoutePlaceAtIndexPath:indexPath]];
            [self.navigationController pushViewController:routeEditVC animated:YES];
        }
            break;
        case LCPlanRouteCellTypeAddRoute:
        {
            LCPlanRouteEditPlaceVC *routeEditVC = [LCPlanRouteEditPlaceVC createInstance];
            routeEditVC.delegate = self;
            [routeEditVC addPlaceAtDay:[self.planRouteDataSource getRouteDayAtIndexPath:indexPath]];
            [self.navigationController pushViewController:routeEditVC animated:YES];
        }
            break;
        case LCPlanRouteCellTypeAddDay:
        {
            NSIndexPath *lastDayIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section-1];
            LCPlanADay *lastDay = [self.planRouteDataSource getADayAtIndexPath:lastDayIndexPath];
            if (!lastDay || lastDay.routes.count<=0) {
                // 没有上一天； 或上一天的Place个数为0；  则不能添加新的一天
                NSString *tipMsg = [NSString stringWithFormat:@"至少为Day%ld添加一个行程\r\n才能添加新的一天",(long)[self.planRouteDataSource getRouteDayAtIndexPath:lastDayIndexPath]];
                [YSAlertUtil alertOneButton:@"知道了" withTitle:nil msg:tipMsg callBack:nil];
            }else{
                for (int i=0; i<indexPath.section; i++){
                    [self foldDayAtSection:i];
                }
                [self.planRouteDataSource insertDay];
                [tableView insertSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
            break;
        case LCPlanRouteCellTypeChargeInfo:
        {
            LCPlanRouteCellForChargeInfo *cell = (LCPlanRouteCellForChargeInfo *)[tableView cellForRowAtIndexPath:indexPath];
            [cell.chargeInfoTextView becomeFirstResponder];
        }
            break;
        default:
            break;
    }
}

- (void)foldDayAtSection:(NSInteger)daySection{
    NSIndexPath *dayIndexPath = [NSIndexPath indexPathForRow:0 inSection:daySection];
    LCPlanRouteCellForDay *dayCell = (LCPlanRouteCellForDay *)[self.routeTableView cellForRowAtIndexPath:dayIndexPath];
    LCPlanADay *aDay = [self.planRouteDataSource getADayAtIndexPath:dayIndexPath];
    if (!aDay) {
        return;
    }
    if (aDay.isFolded) {
        return;
    }else{
        aDay.isFolded = YES;
        NSArray *indexPaths = [self.planRouteDataSource getFoldableIndexPathsForSection:dayIndexPath.section];
        [self.routeTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [dayCell animateToFolded];
    }
}
- (void)unfoldDayAtSection:(NSInteger)daySection{
    NSIndexPath *dayIndexPath = [NSIndexPath indexPathForRow:0 inSection:daySection];
    LCPlanRouteCellForDay *dayCell = (LCPlanRouteCellForDay *)[self.routeTableView cellForRowAtIndexPath:dayIndexPath];
    LCPlanADay *aDay = [self.planRouteDataSource getADayAtIndexPath:dayIndexPath];
    if (!aDay) {
        return;
    }
    if (aDay.isFolded) {
        aDay.isFolded = NO;
        NSArray *indexPaths = [self.planRouteDataSource getFoldableIndexPathsForSection:dayIndexPath.section];
        [self.routeTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [dayCell animateToUnfolded];
    }else{
        return;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCLogInfo(@"heightForRowAtIndexPath section:%ld,row:%ld",(long)indexPath.section,(long)indexPath.row);
    
    CGFloat height = 0;
    LCPlanRouteCellType cellType = [self.planRouteDataSource getCellTypeAtIndexPath:indexPath];
    switch (cellType) {
        case LCPlanRouteCellTypeRouteTitle:
            height = [LCPlanRouteCellForRouteTitle getCellHeight];
            break;
        case LCPlanRouteCellTypeDay:
            height = DayCellHeight;
            break;
        case LCPlanRouteCellTypeRoute:
            height = RouteCellHeight;
            break;
        case LCPlanRouteCellTypeAddRoute:
            height = AddRouteCellHeight;
            break;
        case LCPlanRouteCellTypeAddDay:
            height = AddDayCellHeight;
            break;
        case LCPlanRouteCellTypeTips:
            height = TipCellHeight;
            break;
        case LCPlanRouteCellTypeChargeInfo:
//            height = [LCPlanRouteCellForChargeInfo getCellHeight];
            //隐藏掉收费cell
            height = 0;
            break;
    }
    return height;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.routeTableView && self.isShowingKeyboard && !self.isJustShowKeyboard) {
        [self.view endEditing:YES];
    }
}

#pragma mark - LCPlanRouteEditVC Delegate
- (void)planRouteEditPlace:(LCPlanRouteEditPlaceVC *)routeEditPlaceVC didAddPlace:(LCRoutePlaceModel *)place{
    [self.planRouteDataSource insertRoutePlace:place];
    [self.routeTableView reloadData];
}
- (void)planRouteEditPlace:(LCPlanRouteEditPlaceVC *)routeEditPlaceVC didDeletePlace:(LCRoutePlaceModel *)place{
    [self.planRouteDataSource deleteRoutePlace:place];
    [self.routeTableView reloadData];
}
- (void)planRouteEditPlace:(LCPlanRouteEditPlaceVC *)routeEditPlaceVC didEditPlace:(LCRoutePlaceModel *)place{
    [self.routeTableView reloadData];
}

#pragma mark - LCPlanRouteCellForRouteTitle Delegate
- (void)planRouteCellForRouteTitleDidEndEdit:(LCPlanRouteCellForRouteTitle *)planRouteCell{
    [self mergeUIBackToData];
}
#pragma mark - LCPlanRouteCellForChargeInfo Delegate
- (void)planRouteCellForChargeInfoDidBeginEdit:(LCPlanRouteCellForChargeInfo *)cell{
    NSIndexPath *indexPath = [self.routeTableView indexPathForCell:cell];
    [self.routeTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (void)planRouteCellForChargeInfoDidEndEdit:(LCPlanRouteCellForChargeInfo *)cell{
    [self mergeUIBackToData];
}

@end

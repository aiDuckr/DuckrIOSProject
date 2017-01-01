//
//  LCCostPlanDetailVC.m
//  LinkCity
//
//  Created by Roy on 12/18/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCCostPlanDetailVC.h"
#import "LCCostPlanTabContentCell.h"
#import "LCTabView.h"
#import "AdScrollView.h"
#import "LCPrmtListCell.h"
#import "LCStarRatingView.h"
#import "LCOrderHelper.h"
#import "LCPlandetailAddStageView.h"
#import "LCCostPlanRouteAndTimeCell.h"
#import "LCCostPlanDescptionCell.h"
#import "LCCostPlanArrangementCell.h"
#import "LCCostPlanGetherCell.h"
#import "LCCostPlanTourPlanCell.h"
#import "LCPlanDetailUsersCell.h"
#import "LCCostPlanJoinIntroCell.h"
#import "LCPlanDetailTourPicInfoCell.h"
#import "LCCostPlanCommentStarCell.h"
#import "LCUserLikedListVC.h"
#import "LCTourpicLinkingPlanListVC.h"
#define TabViewHeight (40)
#define TopImageHolderViewHeight (250)
#define BottomBtnHeight (46)

@interface LCCostPlanDetailVC ()<UITableViewDataSource, UITableViewDelegate, LCTabViewDelegate, LCCostPlanTabContentCellDelegate, LCPrmtListCellDelegate, LCPlanDetailAddStageViewDelegate, LCCostPlanDescptionCellDelegate, LCCostPlanTourPlanCellDelegate,LCCostPlanArrangementCellDelegate, LCCostPlanRouteAndTimeCellDelegate, LCPlanDetailTourPicInfoCellDelegate, LCPlanDetailUsersCellDelegate>

#pragma UI
@property (nonatomic, strong) NSArray *tourPicList;
@property (nonatomic, strong) UIImage *formerNavigationBarShadowImage;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIImage *whiteShareIcon;
@property (nonatomic, strong) UIImage *grayShareIcon;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIImage *whiteEditIcon;
@property (nonatomic, strong) UIImage *grayEditIcon;
@property (nonatomic, strong) UIBarButtonItem *spaceBarBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) LCTabView *tabView;

//Header View
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (nonatomic, assign) CGFloat tableHeaderViewHeight;
@property (weak, nonatomic) IBOutlet UIView *topImageHodlerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImageHolderHeight;
@property (nonatomic, strong) LCPrmtListCell *imageListCell;
@property (nonatomic, strong) LCCostPlanRouteAndTimeCell * routeAndTimeCell;
//@property (nonatomic, strong)

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaLineViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *declarationLabel;


@property (nonatomic, strong) LCCostPlanTabContentCell *contentCell;
@property (nonatomic, strong) LCCostPlanDescptionCell *descCell;
@property (nonatomic, strong) LCCostPlanArrangementCell *arrangementCell;
@property (nonatomic, strong) LCCostPlanGetherCell *getherCell;
@property (nonatomic, strong) LCCostPlanTourPlanCell *tourPlanCell;
@property (nonatomic, strong) LCCostPlanCommentStarCell *commentStarCell;
@property (nonatomic, strong) LCPlanDetailUsersCell *userInfoCell;
@property (nonatomic, strong) LCCostPlanJoinIntroCell *joinIntroCell;
@property (nonatomic, strong) LCPlanDetailTourPicInfoCell *tourPicInfoCell;

@property (nonatomic, assign) BOOL isInSameCity;


//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottom;
@property (weak, nonatomic) IBOutlet UIView *bottomBtnView;
@property (weak, nonatomic) IBOutlet UIView *bottomCommentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCommentViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *askQuestionButton;
@property (weak, nonatomic) IBOutlet UIButton *favorButton;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;


//Edit Stage
@property (nonatomic, strong) KLCPopup *addStagePopup;
@property (nonatomic, strong) LCPlanDetailAddStageView *addStageView;


//Data
@property (nonatomic, assign) BOOL cancelAutoRefreshOnce;   //为true时，refreshData不作处理，并把cancelAutoRefresh标记为false
@property (nonatomic, strong) NSMutableArray *commentArray;    //array of LCCommentModel

@property (nonatomic, strong) LCOrderHelper *orderHelper;
@property (nonatomic, assign) BOOL didAddObserver;

@end


#pragma mark updateCellIndex

@implementation LCCostPlanDetailVC

+ (instancetype)createInstance {
    return (LCCostPlanDetailVC *)[LCStoryboardManager viewControllerWithFileName:SBNamePlanDetail identifier:NSStringFromClass([LCCostPlanDetailVC class])];
}

- (void)commonInit {
    [super commonInit];
    self.cancelAutoRefreshOnce = NO;
    self.defaultTabIndex = -1;
    self.tableHeaderViewHeight = 238;   //标题一行时，默认238
    self.didAddObserver = NO;
    self.isInSameCity = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserveToNotificationNameToRefreshData:URL_ADD_COMMENT_TO_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_DELETE_COMMENT_OF_PLAN];

    //在邀约成员页加入、退出、踢人，回到详情页需要更新
    [self addObserveToNotificationNameToRefreshData:URL_JOIN_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_DELETE_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_QUIT_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_KICKOFF_USRE_OF_PLAN];

    [self addObserveToNotificationNameToRefreshData:URL_APPROVE_JOIN_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_REFUSE_JOIN_PLAN];

    [self addObserveToNotificationNameToRefreshData:URL_FAVOR_PLAN];

    [self addObserveToNotificationNameToRefreshData:URL_CHECKIN_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_SEND_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_SEND_ROUTE];

    //支付、退款
    [self addObserveToNotificationNameToRefreshData:URL_PLAN_ORDER_NEW];
    [self addObserveToNotificationNameToRefreshData:URL_PLAN_TAIL_ORDER_NEW];
    [self addObserveToNotificationNameToRefreshData:URL_PLAN_ORDER_QUERY];
    [self addObserveToNotificationNameToRefreshData:URL_PLAN_ORDER_REFUND];

    UIView *rightBtnView                        = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 92, 44)];
    self.spaLineViewHeight.constant             = 0.5;
    self.whiteShareIcon                         = [[UIImage imageNamed:@"PlanDetailShareIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.grayShareIcon                          = [[UIImage imageNamed:@"CommonShareIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.shareBtn                               = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 40, 44)];
    [self.shareBtn setImage:self.grayShareIcon forState:UIControlStateNormal];
    [self.shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtnView addSubview:self.shareBtn];
    self.shareBtn.hidden                        = YES;

    self.whiteEditIcon                          = [[UIImage imageNamed:@"PlanDetailWhiteEditIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.grayEditIcon                           = [[UIImage imageNamed:@"PlanDetailGrayEditIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.editBtn                                = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [self.editBtn setImage:self.grayEditIcon forState:UIControlStateNormal];
    [self.editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtnView addSubview:self.editBtn];

    UIBarButtonItem *negativeSpacer             = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width                        = -20;
    self.navigationItem.rightBarButtonItems     = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:rightBtnView]];

    self.tableView.dataSource                   = self;
    self.tableView.delegate                     = self;
    //self.tableView.estimatedRowHeight = 1000;
    self.tableView.estimatedRowHeight           = 130;
    self.tableView.alwaysBounceVertical         = YES;
    self.tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight                    = UITableViewAutomaticDimension;

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanTabContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanTabContentCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanRouteAndTimeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanRouteAndTimeCell class])];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanDescptionCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanDescptionCell class])];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanArrangementCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanArrangementCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanGetherCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanGetherCell class])];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanTourPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanTourPlanCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanJoinIntroCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanJoinIntroCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCPlanDetailUsersCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCPlanDetailUsersCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCPlanDetailTourPicInfoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCPlanDetailTourPicInfoCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCommentStarCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCommentStarCell class])];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
      // [self.tableView registerN:[LCCostPlanCommentStarCell class] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCommentStarCell class])];
    //SStringFromClass([LCCostPlanCommentStarCell class])


    self.imageListCell                          = [LCPrmtListCell createInstance];
    self.imageListCell.delegate                 = self;
    self.topImageHodlerView.layer.masksToBounds = YES;
    [self.topImageHodlerView addSubview:self.imageListCell];
    UIView *listCell                            = self.imageListCell;
    UIView *holderView                          = self.topImageHodlerView;
    [holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[listCell]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(listCell)]];
    [holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[listCell]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(listCell)]];

    //button Sender
    [self.askQuestionButton addTarget:self action:@selector(askQuestionAction) forControlEvents:UIControlEventTouchUpInside];
    [self.favorButton addTarget:self action:@selector(favorAction) forControlEvents:UIControlEventTouchUpInside];
    [self.buyButton addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];


    if (self.plan.routeType == LCRouteTyoeFreePlanCostSameCityCommon) {
    self.isInSameCity                           = YES;
    }

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    LCLogInfo(@"%@",[[NSThread callStackSymbols] firstObject]);
    
    //Init navigationBar appearance
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.formerNavigationBarShadowImage = self.navigationController.navigationBar.shadowImage;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    //当滚到一半时，userInfoTopView消失，进到子页面，再回来时，userInfoTopView又出现了，需要再更新下
    [self scrollViewDidScroll:self.tableView];
    
    /// 当要显示的是空计划时，是由于deeplink跳转来的，显示hud，当从网络请求数据后会隐藏hud。
    if (!self.plan || [self.plan isEmptyPlan]) {
        [YSAlertUtil showHudWithHint:nil];
    }
    
    [self updateShow];
    
}

- (void)viewDidAppear:(BOOL)animated{
    LCLogInfo(@"%@",[[NSThread callStackSymbols] firstObject]);
    [super viewDidAppear:animated];
    
    if (!self.inputToolBar) {
        [self addInputToolbar];
    }
    
    if (self.defaultTabIndex >= 0 &&
        self.defaultTabIndex <= 2) {
        self.tabView.selectIndex = self.defaultTabIndex;
        [self.contentCell.scrollView scrollToPageIndex:self.defaultTabIndex withAnimation:NO];
        [self updateBottomBtnViewAppearance];
        
        self.defaultTabIndex = -1;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    LCLogInfo(@"%@",[[NSThread callStackSymbols] firstObject]);
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[LCUIConstants sharedInstance].navBarOpaqueImage forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.tintColor = UIColorFromRGBA(NavigationBarTintColor, 1);
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGBA(NavigationBarTintColor, 1), NSForegroundColorAttributeName, [UIFont fontWithName:FONT_LANTINGBLACK size:17], NSFontAttributeName, nil];
    self.navigationController.navigationBar.shadowImage = self.formerNavigationBarShadowImage;
    
    if (self.imageListCell) {
        [self.imageListCell stopAutoScroll];
    }
}

- (void)dealloc{
    LCLogInfo(@"%@",[[NSThread callStackSymbols] firstObject]);
    [self removeObserver];
}

- (void)refreshData {
    if (self.cancelAutoRefreshOnce) {
        self.cancelAutoRefreshOnce = NO;
        return;
    }
    
    [self requestPlanDetailByPlanGuid:self.plan.planGuid];
    [self requestPlanCommentFromOrderString:nil];
}

- (void)updateShow {
    //在个人主页狂点关注，再点聊天跳到聊天，聊天页navigationbar 会变白
    //由于网络请求延迟导致更新navigationbar 颜色
    if (!self.isAppearing) {
        return;
    }
    
    if (self.plan.isFavored == 1) {
        [self.thumbImageView setImage:[UIImage imageNamed:@"PlanDetailThumbDownIcon"]];
    } else {
        [self.thumbImageView setImage:[UIImage imageNamed:@"PlanDetailThumbUpIcon"]];
    }
    
    if ([self.plan getPlanRelation] == LCPlanRelationCreater &&
        self.plan.totalStageOrderNumber == 0) {
        self.editBtn.hidden = NO;
    }else{
        self.editBtn.hidden = YES;
    }
    
    if ([self.plan getPlanRelation] == LCPlanRelationCreater) {
        self.bottomBtnView.hidden = YES;
        if (self.contentCell) {
            self.contentCell.descTableViewBottom.constant = 0;
            self.contentCell.routeTableViewBottom.constant = 0;
            self.contentCell.commentTableViewBottom.constant = BottomBtnHeight;
        }
    }else{
        self.bottomBtnView.hidden = NO;
        if (self.contentCell) {
            self.contentCell.descTableViewBottom.constant = BottomBtnHeight;
            self.contentCell.routeTableViewBottom.constant = BottomBtnHeight;
            self.contentCell.commentTableViewBottom.constant = BottomBtnHeight;
        }
    }
    
    if ([LCStringUtil isNotNullString:_plan.planShareTitle]) {
        _shareBtn.hidden = NO;
    }
    
    // update navigation bar
    [self updateNavigationBarAppearance];
    
    // update table header
    [self.declarationLabel setText:[LCStringUtil getNotNullStr:self.plan.declaration] withLineSpace:LCTextFieldLineSpace];
//    CGFloat point = [self.plan.avgPoint floatValue];
//    CGFloat width = point * 14 + 4 * floor(point);
    //self.starYesViewWidth.constant = width;
    //self.pointLabel.text = [NSString stringWithFormat:@"%.1f分",[self.plan.avgPoint floatValue]];
    NSDecimalNumber *lowestPrice = [NSDecimalNumber maximumDecimalNumber];
    for (LCPartnerStageModel *stage in self.plan.stageArray){
        if ([LCDecimalUtil isOverZero:stage.price] &&
            [stage.price compare:lowestPrice] == NSOrderedAscending) {
            lowestPrice = stage.price;
        }
    }
//    if ([lowestPrice compare:[NSDecimalNumber maximumDecimalNumber]] == NSOrderedSame) {
//        self.priceLabel.text = @"￥-";
//    }else{
//        self.priceLabel.text = [NSString stringWithFormat:@"￥%@起",lowestPrice];
//    }
//    
//    self.buyNumLabel.text = [NSString stringWithFormat:@"%ld人已购买",(long)self.plan.totalStageOrderNumber];
    
    UIView *th = self.tableView.tableHeaderView;
    [th setNeedsLayout];
    [th layoutIfNeeded];
    self.tableHeaderViewHeight = [th systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect formerFrame = th.frame;
    formerFrame.size.height = self.tableHeaderViewHeight;
    th.frame = formerFrame;
    self.tableView.tableHeaderView = th;
    
    // update table
    [self.tableView reloadData];
    
    NSMutableArray *urlArray = [[NSMutableArray alloc] init];
    if ([LCStringUtil isNotNullString:self.plan.firstPhotoUrl]) {
        [urlArray addObject:self.plan.firstPhotoUrl];
    }
    if ([LCStringUtil isNotNullString:self.plan.secondPhotoUrl]) {
        [urlArray addObject:self.plan.secondPhotoUrl];
    }
    if ([LCStringUtil isNotNullString:self.plan.thirdPhotoUrl]) {
        [urlArray addObject:self.plan.thirdPhotoUrl];
    }
    self.imageListCell.imageUrlArray = urlArray;
    [self.imageListCell startAutoScroll];
    
    [self updateBottomBtnViewAppearance];
    if (nil == self.plan.canSelectedStage || self.plan.canSelectedStage.count <= 0) {
        [self.buyButton setTitle:@"活动结束" forState:UIControlStateNormal];
        [self.buyButton setBackgroundColor:UIColorFromRGBA(0xd9d5d1, 1.0f)];
    } else {
        [self.buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [self.buyButton setBackgroundColor:UIColorFromRGBA(0xfb4c4c, 1.0f)];
    }
}

- (void)addObserver{
    LCLogInfo(@"%@",[[NSThread callStackSymbols] firstObject]);
    if (self.didAddObserver) {
        return;
    }
    
    if (self.contentCell &&
        self.contentCell.descTableView &&
        self.contentCell.routeTableView &&
        self.contentCell.commentTableView) {
        [self.contentCell.descTableView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self.contentCell.routeTableView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self.contentCell.commentTableView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        self.didAddObserver = YES;
    }
}
- (void)removeObserver{
    LCLogInfo(@"%@",[[NSThread callStackSymbols] firstObject]);
    if (!self.didAddObserver) {
        return;
    }
    if (self.contentCell != nil &&
        self.contentCell.descTableView != nil &&
        self.contentCell.routeTableView != nil &&
        self.contentCell.commentTableView != nil) {
        @try {
            
            [self.contentCell.descTableView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
            [self.contentCell.routeTableView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
            [self.contentCell.commentTableView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
            self.didAddObserver = NO;
        }
        @catch (NSException *exception) {
            NSLog(@"exception is %@",exception);
        }
        @finally {
            
        }
    }
}

- (void)updateBottomBtnViewAppearance{
    if (self.tabView.selectIndex == 0 ||
        self.tabView.selectIndex == 1) {
        self.bottomBtnView.hidden = NO;
        self.bottomCommentView.hidden = YES;
    }else{
        self.bottomBtnView.hidden = YES;
        self.bottomCommentView.hidden = NO;
    }
    
    if ([self.plan getPlanRelation] == LCPlanRelationCreater) {
        self.bottomBtnView.hidden = YES;
    }
}

- (void)updateNavigationBarAppearance{
    
    CGFloat tableOffsetY = self.tableView.contentOffset.y;
    if (tableOffsetY > TopImageHolderViewHeight-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT) {
        //上滑后，NavBar变白
        if ([LCStringUtil isNotNullString:self.plan.declaration]) {
            self.title = self.plan.declaration;
        }else{
            self.title = @"邀约详情";
        }
        
        [self.navigationController.navigationBar setBackgroundImage:[LCUIConstants sharedInstance].navBarOpaqueImage forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.tintColor = UIColorFromRGBA(NavigationBarTintColor, 1);
        self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGBA(NavigationBarTintColor, 1), NSForegroundColorAttributeName, [UIFont fontWithName:FONT_LANTINGBLACK size:17], NSFontAttributeName, nil];
        
        [self.editBtn setImage:self.grayEditIcon forState:UIControlStateNormal];
        [self.shareBtn setImage:self.grayShareIcon forState:UIControlStateNormal];
    }else{
        //下滑后，NavBar变透明
        self.title = @"";
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:FONT_LANTINGBLACK size:17], NSFontAttributeName, nil];
        
        
        [self.editBtn setImage:self.whiteEditIcon forState:UIControlStateNormal];
        [self.shareBtn setImage:self.whiteShareIcon forState:UIControlStateNormal];
    }
}

//- (void)planDetailUsersCellToViewMoreUsersDetail:(LCPlanDetailUsersCell *)cell {
//    [MobClick event:Mob_PlanDetail_SeeMember];
//    
//    UINavigationController *nav = [LCSharedFuncUtil getTopMostNavigationController];
//    if (nil != nav) {
//        LCUserLikedListVC *vc = [LCUserLikedListVC createInstance];
//        vc.plan = self.plan;
//        [nav pushViewController:vc animated:APP_ANIMATION];
//    }
//}

#pragma mark Button Action
- (void)shareAction:(id)sender{
    [self sharePlan:self.plan];
}
- (void)editAction:(id)sender{
    if ([self.plan getPlanRelation] == LCPlanRelationCreater) {
//        [[LCSendPlanHelper sharedInstance] modify:self.plan];
        [YSAlertUtil alertOneMessage:@"请登录www.duckr.cn修改邀约商品！"];
    }
}
- (IBAction)phoneCallBtnAction:(id)sender {
    LCUserModel *creater = [self.plan.memberList firstObject];
    if (creater && [LCStringUtil isNotNullString:creater.telephone]) {
        if (self.plan.isAllowPhoneContact) {
            [LCSharedFuncUtil dialPhoneNumber:creater.telephone];
        }else{
            [YSAlertUtil tipOneMessage:@"发起人未允许电话联系" yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }
    }
}
- (IBAction)orderBtnAction:(id)sender {
    if ([self.plan getPlanRelation] == LCPlanRelationCreater) {
        [YSAlertUtil tipOneMessage:@"不能购买自己的邀约"];
        return;
    }
    
    self.orderHelper = [LCOrderHelper instanceWithNavVC:self.navigationController];
    [self.orderHelper startToOrderPlan:self.plan recmdUuid:self.recmdUuid];
}

#pragma mark Set & Get
- (void)setContentCell:(LCCostPlanTabContentCell *)contentCell{
    if (_contentCell != contentCell) {
        [self removeObserver];
        _contentCell = contentCell;
        [self addObserver];
    }
}

#pragma mark Network
- (void)requestPlanDetailByPlanGuid:(NSString *)planGuid {
    [LCNetRequester getPlanDetailFromPlanGuid:planGuid callBack:^(LCPlanModel *plan,NSArray * tourpicArray, NSError *error) {
        //从deeplink跳进来时，会显示hud，所以网络刷新后隐藏hud
        
        [YSAlertUtil hideHud];
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            
            if (error.code == ErrCodePlanNotExist) {
                //计划不存在
                
                //Roy: 当通过点通知、deeplink跳转到App，自动进详情时，如果计划不存在并退出，会导致页面错乱
                //延时退出可以。。。。。。
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            
            [self updateShow];
        } else {
            self.plan = plan;
            self.tourPicList = tourpicArray;
            
            //更新本地的聊天会话model
            LCChatContactModel *chatContactModel = [LCChatContactModel chatContactModelWithPlan:plan];
            if (nil != chatContactModel && nil != [chatContactModel getBareJidString]) {
                [[LCDataManager sharedInstance].chatContactDic setObject:chatContactModel forKey:[chatContactModel getBareJidString]];
            }
            [self updateShow];
        }
    }];
}

- (void)requestPlanCommentFromOrderString:(NSString *)orderString {
    [LCNetRequester getCommentOfPlan:self.plan.planGuid corderString:orderString callBack:^(NSArray *commentArray, NSString *orderStr, NSError *error) {
        if (self.contentCell) {
            [self.contentCell.commentTableView footerEndRefreshing];
        }
        
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        } else {
            if ([LCStringUtil isNullString:orderString]) {
                //下拉刷新
                self.commentArray = [NSMutableArray arrayWithArray:commentArray];
            }else{
                //上拉加载更多
                if (!commentArray || commentArray.count <= 0) {
                    [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                }else{
                    if (!self.commentArray) {
                        self.commentArray = [[NSMutableArray alloc] init];
                    }
                    [self.commentArray addObjectsFromArray:commentArray];
                }
            }
        }
        
        [self updateShow];
    }];
}


#pragma mark UITabView Delegate
- (void)tabView:(LCTabView *)tabView didSelectIndex:(NSInteger)index{
    if (index >= 0 && index < self.contentCell.tableViewArray.count) {
        [self.contentCell.scrollView scrollToPageIndex:index withAnimation:YES];
        [self updateBottomBtnViewAppearance];
    }
}

#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    
    //手往下，内容往下滚，contentOffset变负
    self.topImageHolderHeight.constant = TopImageHolderViewHeight - scrollView.contentOffset.y;
    
    [self updateNavigationBarAppearance];
}

#pragma mark updateCellIndex
static NSInteger sectionNum = 0;
static NSInteger commentScoreIndex = 0;
static NSInteger userInfoCellIndex = 0;
static NSInteger routeAndTimeCellIndex = 0;
static NSInteger descriptionCellIndex = 0;
static NSInteger tourPicInfoCellIndex = 0;
static NSInteger tourPlanCellIndex = 0;
static NSInteger gatherCellIndex = 0;
static NSInteger planTipCellIndex = 0;
static NSInteger arrangeCellIndex = 0;

- (void)updateTableViewCellIndex{
    sectionNum = -1;
    
    //userInfoCellIndex = sectionNum++;
    if (self.plan.commentNumber > 0 && [self.plan.avgPoint integerValue] >= 0) {
        sectionNum ++;
        commentScoreIndex = sectionNum;
    } else {
        commentScoreIndex = -1;
    }
    if (self.plan.favorNumber > 0) {
        sectionNum ++;
        userInfoCellIndex = sectionNum;
    } else {
        userInfoCellIndex = -1;
        
    }
    sectionNum ++;
    routeAndTimeCellIndex = sectionNum;
    sectionNum ++;
    descriptionCellIndex = sectionNum;
    //if ()
    if (self.tourPicList && self.tourPicList.count > 0) {
        sectionNum ++;
        tourPicInfoCellIndex = sectionNum;
    } else {
        tourPicInfoCellIndex = -1;
    }
    if (!self.isInSameCity) {
        sectionNum ++;
        tourPlanCellIndex = sectionNum;
        sectionNum ++;
        gatherCellIndex = sectionNum;
    } else {
        tourPlanCellIndex = -1;
        gatherCellIndex = -1;
    }
    if ([LCStringUtil isNotNullString:self.plan.planTips]) {
        sectionNum ++;
        planTipCellIndex = sectionNum;
    } else {
        planTipCellIndex = -1;
    }
    sectionNum ++;
    //textThreePhotoCellIndex = firstSectionCellNum++;
    arrangeCellIndex = sectionNum;
    
    sectionNum += 1;
}


#pragma mark UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    [self updateTableViewCellIndex];
    return sectionNum;
//    NSInteger numberOfSection;
//    if (!self.isInSameCity) {
//        numberOfSection = 6;
//        //return 5;
//    } else {
//        numberOfSection = 4;
//        //return 3;
//    }
//    if ([LCStringUtil isNotNullString:self.plan.planTips]) {
//        numberOfSection += 1;
//    }
//    return numberOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    if (!self.tabView) {
//        self.tabView = [[LCTabView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, TabViewHeight)];
//        self.tabView.backgroundColor = [UIColor whiteColor];
//        self.tabView.delegate = self;
//        self.tabView.selectIndex = 0;
//        self.tabView.defaultButtonTitleColor = UIColorFromRGBA(0x2c2a28, 1);
//        self.tabView.highlightButtonTitleColor = UIColorFromRGBA(0xad7f2d, 1);
//        
//        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, TabViewHeight-2, tableView.frame.size.width, 2)];
//        bottomLine.backgroundColor = UIColorFromRGBA(0xe8e4dd, 1);
//        [self.tabView addSubview:bottomLine];
//        //        [self.tabView insertSubview:bottomLine atIndex:0];
//    }
//    if (section == 1) {
//        self.tabView.buttonTitles = @[@"活动简介",@"出行路线",@"用户评论"];
//        [self.tabView setVerticalLineHiden:NO];
//        return self.tabView;
//    } else {
//        return  nil;
//    }
//    
//    
//    
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == routeAndTimeCellIndex) {
        self.routeAndTimeCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanRouteAndTimeCell class]) forIndexPath:indexPath];
        self.routeAndTimeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.routeAndTimeCell bindWithData:self.plan];
        self.routeAndTimeCell.delegate = self;
        return self.routeAndTimeCell;
        
 
    } else if (indexPath.section == commentScoreIndex) {
        self.commentStarCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanCommentStarCell class]) forIndexPath:indexPath];
        self.commentStarCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.commentStarCell bindWithData:self.plan];
        return self.commentStarCell;
        
    } else if (indexPath.section == userInfoCellIndex) {
        
        self.userInfoCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCPlanDetailUsersCell class]) forIndexPath:indexPath];
        self.userInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.userInfoCell.delegate = self;
        [self.userInfoCell updateShowDetailUsers:self.plan];
        return self.userInfoCell;
        

    } else if (indexPath.section == planTipCellIndex) {
        self.joinIntroCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanJoinIntroCell class]) forIndexPath:indexPath];
        self.joinIntroCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.joinIntroCell bindWithData:self.plan];
        return self.joinIntroCell;
    } else if (indexPath.section == arrangeCellIndex) {
        self.arrangementCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanArrangementCell class]) forIndexPath:indexPath];
        self.arrangementCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.arrangementCell.delegate = self;
        [self.arrangementCell bindWithData:self.plan];
        return self.arrangementCell;
    } else if (indexPath.section == descriptionCellIndex) {
        
        self.descCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanDescptionCell class]) forIndexPath:indexPath];
        self.descCell.delegate = self;
        [self.descCell bindWithData:self.plan];
        self.descCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.descCell;
        
    }  else if (indexPath.section == tourPlanCellIndex) {
        
        self.tourPlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanTourPlanCell class]) forIndexPath:indexPath];
        self.tourPlanCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.tourPlanCell bindWithData:self.plan];
        self.tourPlanCell.delegate = self;
        return self.tourPlanCell;
       
    } else if (indexPath.section == gatherCellIndex) {
            //self.tourPlanCell
        self.getherCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanGetherCell class]) forIndexPath:indexPath];
        self.getherCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.getherCell bindWithData:self.plan];
        return self.getherCell;
    }  else if (indexPath.section == tourPicInfoCellIndex) {
        self.tourPicInfoCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCPlanDetailTourPicInfoCell class]) forIndexPath:indexPath];
        self.tourPicInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.tourPicInfoCell.delegate = self;
        [self.tourPicInfoCell bindWithData:self.tourPicList];
        return self.tourPicInfoCell;
    } else {
        return nil;
    }

    
}

- (void)planDetailUsersCellToViewMoreUsersDetail:(LCPlanDetailUsersCell *)cell {
    [MobClick event:Mob_PlanDetail_SeeMember];
    
    if ([self haveLogin]) {
        [LCViewSwitcher pushToShowPlanMemberVCForPlan:self.plan on:self.navigationController];
    } else {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
    }
}

- (void)planDetailUsersCellToViewUserDetail:(LCUserModel *)user {
    [LCViewSwitcher pushToShowUserInfoVCForUser:user on:self.navigationController];
}

- (void)costPlanRouteAndTimeChoosed:(LCPlanModel *)plan {
    self.orderHelper = [LCOrderHelper instanceWithNavVC:self.navigationController];
    [self.orderHelper startToOrderPlan:self.plan recmdUuid:self.recmdUuid];
}

#pragma mark - obsever delegate methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UITableView *senderTableView = (UITableView *)object;
    CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
    CGFloat offsetY = offset.y;
    CGPoint oldOffset = [change[NSKeyValueChangeOldKey] CGPointValue];
    CGFloat oldOffsetY = oldOffset.y;
    CGFloat deltaOffsetY = offset.y - oldOffsetY;
    
    if (![self.contentCell isTouchingTableView:senderTableView]) {
        return;
    }
    
    CGFloat tableViewContentOffsetY = self.tableView.contentOffset.y + deltaOffsetY;
    tableViewContentOffsetY = MIN(tableViewContentOffsetY, self.tableHeaderViewHeight);
    
    if (offsetY >= 0) {
        tableViewContentOffsetY = MAX(tableViewContentOffsetY, 0);
    }else{
        
    }
    
    self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, tableViewContentOffsetY);
}

#pragma mark CostPlanTabContentCell Delegate
- (void)costPlanTabContentCell:(LCCostPlanTabContentCell *)cell scrollViewDidScroll:(UIScrollView *)scrollView{
    
    /*对于评论列表
     当本页的section到顶之前，不显示footerrefresh，到顶之后，才显示footerrefresh
     
     如果一直有footerrefresh的话，由于当section到顶之前commentTableView的高度超出屏幕显示，显示footerRefresh时用户看不到，但还会加载更多
    */
    if (scrollView == self.contentCell.commentTableView) {
        static BOOL isCommentTableViewFooterThere = NO;
        if (self.tableView.contentOffset.y >= self.tableHeaderViewHeight) {
            // start to show footer refresh
            if (!isCommentTableViewFooterThere) {
                isCommentTableViewFooterThere = YES;
                [self.contentCell addCommentTableFooterRefresh];
            }
        }else{
            // remove footer refresh
            if (isCommentTableViewFooterThere) {
                isCommentTableViewFooterThere = NO;
                [self.contentCell removeCommentTableFooterRefresh];
            }
        }
    }
}

- (void)costPlanTabContentCell:(LCCostPlanTabContentCell *)cell scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.contentCell.scrollView) {
        LCLogInfo(@"%@",[[NSThread callStackSymbols] firstObject]);
        
        NSInteger tabIndex = [scrollView getCurrentPage];
        self.tabView.selectIndex = tabIndex;
        [self updateBottomBtnViewAppearance];
    }
}

- (void)costPlanTabContentCell:(LCCostPlanTabContentCell *)cell scrollViewWillBeginDrag:(UIScrollView *)scrollView{
    
}

- (void)costPlanTabContentCell:(LCCostPlanTabContentCell *)cell scrollViewWillEndDrag:(UIScrollView *)scrollView{
    
    //当用户在cell中的tableview中滑动，松开手指后，由于惯性引起的tableview的滚动，不再影响本VC中的tableview的滚动
    if (scrollView == self.contentCell.descTableView ||
        scrollView == self.contentCell.routeTableView ||
        scrollView == self.contentCell.commentTableView){
        
        if (self.tableView.contentOffset.y < 0) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.tableView.contentOffset = CGPointMake(0, 0);
            } completion:nil];
        }
    }
}

- (void)costPlanTabContentCell:(LCCostPlanTabContentCell *)cell didClickComment:(LCCommentModel *)comment{
    
    NSString *placeHolder = [NSString stringWithFormat:@"回复:%@:",comment.user.nick];
    NSInteger commentId = [LCStringUtil idToNSInteger:comment.commentId];
    
    [self showInputToolBarWithPlaceHolder:placeHolder withReplyCommentId:commentId];
}

- (void)costPlanTabContentCellCommentTableViewFooterRefreshAction:(LCCostPlanTabContentCell *)cell{
    NSString *orderStr = nil;
    if (self.commentArray.count > 0) {
        LCCommentModel *comment = [self.commentArray lastObject];
        orderStr = comment.orderStr;
    }
    [self requestPlanCommentFromOrderString:orderStr];
}

- (void)costPlanTabContentCell:(LCCostPlanTabContentCell *)cell didClickStage:(LCPartnerStageModel *)stage{
    if ([self.plan getPlanRelation] == LCPlanRelationCreater) {
        //edit stage
        if (stage.joinNumber > 1) {
            [self.addStageView showAsEditScaleForStage:stage plan:self.plan];
        }else{
            [self.addStageView showAsEditStageForStage:stage plan:self.plan];
        }
        [self showAddStageView];
    }else{
        //push to member vc
        [LCViewSwitcher pushToShowPlanMemberVCForPlan:self.plan on:[LCSharedFuncUtil getTopMostViewController].navigationController];
    }
}

- (IBAction)viewPhotosAction:(id)sender {
    NSMutableArray *imageModels = [[NSMutableArray alloc] initWithCapacity:0];
    if ([LCStringUtil isNotNullString:self.plan.firstPhotoUrl]) {
        LCImageModel *imageModel = [[LCImageModel alloc] init];
        imageModel.imageUrl = self.plan.firstPhotoUrl;
        imageModel.imageUrlThumb = self.plan.firstPhotoThumbUrl;
        [imageModels addObject:imageModel];
    }
    if ([LCStringUtil isNotNullString:self.plan.secondPhotoUrl]) {
        LCImageModel *imageModel = [[LCImageModel alloc] init];
        imageModel.imageUrl = self.plan.secondPhotoUrl;
        imageModel.imageUrlThumb = self.plan.secondPhotoThumbUrl;
        [imageModels addObject:imageModel];
    }
    if ([LCStringUtil isNotNullString:self.plan.thirdPhotoUrl]) {
        LCImageModel *imageModel = [[LCImageModel alloc] init];
        imageModel.imageUrl = self.plan.thirdPhotoUrl;
        imageModel.imageUrlThumb = self.plan.thirdPhotoThumbUrl;
        [imageModels addObject:imageModel];
    }
    
    if (imageModels.count > self.imageListCell.showingPageIndex) {
        LCPhotoScanner *photoScanner = [LCPhotoScanner createInstance];
        [photoScanner showImageModels:imageModels fromIndex:self.imageListCell.showingPageIndex];
        [[LCSharedFuncUtil getTopMostViewController] presentViewController:photoScanner animated:YES completion:nil];
    }
}

#pragma mark - LCInput Text View
- (void)addInputToolbar{
    if (!self.inputToolBar) {
        self.inputToolBar = [[LCTextMessageToolBar alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, [LCTextMessageToolBar defaultHeight])];
        self.inputToolBar.translatesAutoresizingMaskIntoConstraints = YES;
        self.inputToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        self.inputToolBar.inputTextView.placeHolder = COMMENT_BASE_PLACEHOLDER;
        
        self.inputToolBar.backgroundColor = [UIColor whiteColor];
        self.inputToolBar.inputTextView.backgroundColor = UIColorFromRGBA(LCViewBackGroundColor, 1);
        self.inputToolBar.inputTextView.layer.borderColor = UIColorFromRGBA(LCBottomLineColor, 1).CGColor;
        self.inputToolBar.inputTextView.layer.borderWidth = 0.5;
        self.inputToolBar.inputTextView.layer.cornerRadius = 4;
        self.inputToolBar.inputTextView.layer.masksToBounds = YES;
        self.inputToolBar.inputTextView.font = [UIFont fontWithName:FONT_LANTINGBLACK size:14];
        self.inputToolBar.inputTextView.textColor = UIColorFromRGBA(LCDarkTextColor, 1);
        self.inputToolBar.delegate = self;
    }
    [self.bottomCommentView addSubview:self.inputToolBar];
}
- (void)showInputToolBarWithPlaceHolder:(NSString *)placeHolder withReplyCommentId:(NSInteger)replyCommentId{
    self.replyCommentId = replyCommentId;
    
    self.inputToolBar.inputTextView.placeHolder = placeHolder;
    [self.inputToolBar.inputTextView becomeFirstResponder];
}
- (void)hideInputToolBar {
    if (self.inputToolBar) {
        [self.inputToolBar.inputTextView resignFirstResponder];
    }
}
- (void)didChangeFrameToHeight:(CGFloat)toHeight{
    LCLogInfo(@"%f",toHeight);
    self.bottomCommentViewHeight.constant = toHeight;
}
- (void)inputTextViewDidBeginEditing:(XHMessageTextView *)messageInputTextView{
    LCLogInfo(@"did begin edit");
}
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView{
    LCLogInfo(@"will begin edit");
}
- (void)didSendText:(NSString *)text{
    [self hideInputToolBar];
    LCLogInfo(@"did send %@",text);
        if (![self haveLogin]) {
            [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        }else{
            if ([self.inputToolBar.inputTextView.placeHolder isEqualToString:COMMENT_BASE_PLACEHOLDER]) {
                //直接评论，没回回复
                [LCNetRequester addCommentToPlan:self.plan.planGuid content:text replyToId:DefaultCommentReplyToId score:DefaultPlanCommentScore withType:PlanCommentTypePlan callBack:^(LCCommentModel *comment, NSError *error) {
                    if (error) {
                        [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
                    }else{
                        [YSAlertUtil tipOneMessage:@"留言成功!" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                    }
                    
                    [self refreshData];
                }];
            }else{
                //回复某人
                [LCNetRequester addCommentToPlan:self.plan.planGuid content:text replyToId:self.replyCommentId score:DefaultPlanCommentScore withType:PlanCommentTypePlan callBack:^(LCCommentModel *comment, NSError *error) {
                    if (error) {
                        [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
                    }else{
                        [YSAlertUtil tipOneMessage:@"留言成功!" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                    }
                    
                    [self refreshData];
                }];
            }
            self.inputToolBar.inputTextView.placeHolder = COMMENT_BASE_PLACEHOLDER;
        }
}

#pragma mark EditStage
#pragma mark Add Stage
- (KLCPopup *)addStagePopup{
    if (!_addStagePopup) {
        self.addStageView.delegate = self;
        _addStagePopup = [KLCPopup popupWithContentView:self.addStageView
                                               showType:KLCPopupShowTypeSlideInFromBottom
                                            dismissType:KLCPopupDismissTypeSlideOutToBottom
                                               maskType:KLCPopupMaskTypeDimmed
                               dismissOnBackgroundTouch:NO
                                  dismissOnContentTouch:NO];
    }
    return _addStagePopup;
}

- (LCPlanDetailAddStageView *)addStageView{
    if (!_addStageView) {
        _addStageView = [LCPlanDetailAddStageView createInstance];
    }
    return _addStageView;
}

- (void)showAddStageView{
    CGFloat centerY = DEVICE_HEIGHT - DEVICE_HEIGHT/2;
    [self.addStagePopup showAtCenter:CGPointMake(DEVICE_WIDTH/2, centerY) inView:nil];
}

#pragma mark LCPlanDetailAddStageView Delegate

- (void)addStageViewCanceled:(LCPlanDetailAddStageView *)stageView{
    [self.addStagePopup dismissPresentingPopup];
}
- (void)addStageView:(LCPlanDetailAddStageView *)stageView didChooseStartDate:(NSString *)startDateStr endDate:(NSString *)endDateStr{
    [self showAddStageView];
}
- (void)addStageView:(LCPlanDetailAddStageView *)stageView didAddOrUpdateStage:(LCPlanModel *)plan{
    self.plan = plan;
    [self updateShow];
    
    [self.addStagePopup dismissPresentingPopup];
}
- (void)addStageViewDidClickDeleteBtn:(LCPlanDetailAddStageView *)stageView{
    if (self.plan.stageArray.count == 1) {
        // delete plan
        [YSAlertUtil alertTwoButton:LCDeletePlanAlertConfirmBtnTitle btnTwo:LCDeletePlanAlertCancelBtnTitle withTitle:nil msg:LCDeletePlanAlertMsg callBack:^(NSInteger chooseIndex) {
            if (chooseIndex == 0){
                //delete
                //删除群
                //删除群的网络请求会导致本页面refreshData
                //当在本页面点删除群时，不需要刷新数据，因此取消掉一次自动刷新
                self.cancelAutoRefreshOnce = YES;
                [LCNetRequester deletePlan:self.plan.planGuid callBack:^(NSError *error) {
                    if (error) {
                        [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
                    }else{
                        [YSAlertUtil tipOneMessage:@"删除成功" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                        
                        [self.addStagePopup dismissPresentingPopup];
                        
                        //下线群聊
                        [[LCXMPPMessageHelper sharedInstance] getRoomOfflineWithRoomBareJid:self.plan.roomId];
                        
                        //删除聊天记录和通讯录和红点
                        NSString *bareJidStr = self.plan.roomId;
                        [LCXMPPUtil deleteChatMsg:bareJidStr];
                        [LCXMPPUtil deleteChatContact:bareJidStr];
                        [[LCDataManager sharedInstance] clearUnreadNumForBareJidStr:bareJidStr];
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }];
            }
        }];
    }else{
        // delete stage
        [YSAlertUtil alertTwoButton:@"取消" btnTwo:@"删除" withTitle:nil msg:@"确定删除该期邀约吗？" callBack:^(NSInteger chooseIndex) {
            if (chooseIndex == 1) {
                [YSAlertUtil showHudWithHint:nil];
                [LCNetRequester planStageRemove:stageView.stage.planGuid callBack:^(NSError *error) {
                    [YSAlertUtil hideHud];
                    if (error) {
                        [YSAlertUtil tipOneMessage:error.domain yoffset:TipAboveKeyboardYoffset delay:TipDefaultDelay];
                    }else{
                        for (LCPartnerStageModel *stage in self.plan.stageArray){
                            if ([stage.planGuid isEqualToString:stageView.stage.planGuid]) {
                                [self.plan.stageArray removeObject:stage];
                                break;
                            }
                        }
                        [self updateShow];
                        [self requestPlanDetailByPlanGuid:self.plan.stageMaster];
                        [self.addStagePopup dismissPresentingPopup];
                    }
                }];
            }
        }];
    }
}



#pragma mark - Action Sender
- (void)askQuestionAction {
    //聊天
    [MobClick event:Mob_UserInfo_Chat];
    LCUserModel * model = [self.plan.memberList objectAtIndex:0];
    if ([self haveLogin]) {
        [LCViewSwitcher pushToShowChatWithUserVC:model on:self.navigationController];
    } else {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
    }
}
- (void)favorAction {
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return ;
    }
    if (self.plan.isFavored == 0) {
        [self.thumbImageView setImage:[UIImage imageNamed:@"PlanDetailThumbDownIcon"]];
        self.plan.isFavored = 1;
        [LCNetRequester favorPlan:self.plan.planGuid withType:1 callBack:^(LCPlanModel *plan, NSError *error) {
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain];
            }
        }];
        
    } else {
        [self.thumbImageView setImage:[UIImage imageNamed:@"PlanDetailThumbUpIcon"]];
        self.plan.isFavored = 0;
        [LCNetRequester favorPlan:self.plan.planGuid withType:0 callBack:^(LCPlanModel *plan, NSError *error) {
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain];
            }
        }];
    }
    
}

- (void)buyAction {
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return;
    }
    if ([[LCDataManager sharedInstance].userInfo isMerchant]) {
        [YSAlertUtil tipOneMessage:@"商家账户不能购买，请注册一个非商家身份购买"];
        return;
    }
    //购买
    if ([self.plan getPlanRelation] == LCPlanRelationCreater) {
        [YSAlertUtil tipOneMessage:@"不能购买自己的邀约"];
        return;
    }
    
    self.orderHelper = [LCOrderHelper instanceWithNavVC:self.navigationController];
    [self.orderHelper startToOrderPlan:self.plan recmdUuid:self.recmdUuid];
}

#pragma mark - LCCostPlanDescptionCell Delegate
- (void)LCCostPlanDescptionDidChangedHeight {
    [self.tableView reloadData];
}

- (void)LCCostPlanDescptionCellToViewUserDetail:(LCUserModel *)user {
    [LCViewSwitcher pushToShowUserInfoVCForUser:user on:self.navigationController];
}


- (void)LCCostPlanArrangementDidChangedHeight {
    [self.tableView reloadData];
}
#pragma mark - LCCostPlanTourPlanCell Delegate

- (void)jumpToTourPlanDetail {
    LCUserRouteModel *route = self.plan.userRoute;
    [LCViewSwitcher pushToShowRouteDetailVCForRoute:route routeOwner:nil editable:NO showDayIndex:0 on:self.navigationController];
}

#pragma mark - LCPlanDetailTourPicInfoCell Delegate
- (void)didPressImageViewForMoreTourpics {
    LCTourpicLinkingPlanListVC * vc = [LCTourpicLinkingPlanListVC createInstance];
    vc.planGuid = self.plan.planGuid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didPressImageViewWithTourPlan:(LCTourpic *)tourpic {
    [LCViewSwitcher pushToShowTourPicDetail:tourpic withType:LCTourpicDetailVCViewType_Normal on:self.navigationController];
}
@end

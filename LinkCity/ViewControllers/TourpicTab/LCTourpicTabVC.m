//
//  LCTravelTableVC.m
//  LinkCity
//
//  Created by zzs on 2/6/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCTourpicTabVC.h"
#import "LCTabView.h"
#import "LCPickOneImageHelper.h"
#import "LCTourpicCell.h"
//#import "LCTourpicSquareCell.h"
#import "LCTourpicTableVC.h"
#import "MJRefresh.h"
#import "LCTourpicDetailVC.h"
#import "UIImageView+AFNetworking.h"
#import "LCTourpicNotifyVC.h"
#import "LCBlankContentView.h"
#import "LCSearchDestinationVC.h"
#import "LCPickMultiImageHelper.h"
#import "LinkCity-Swift.h"
#import "WechatShortVideoController.h"
#import "LCSendTourPicVCViewController.h"
//#import "LCTourpicSquareStreamCollectionCell.h"
//#import "LCTourpicSquareStreamCollectionCell.h"
#import "LCMainSearchPlanVC.h"
#import "LCSequareCollectionCell.h"
#import "WaterFallFlowLayout.h"
#import "UIScrollView+Page.h"
#import "LCSystemPermissionUtil.h"
@interface LCTourpicTabVC ()<LCTabViewDelegate, UITableViewDataSource, UITableViewDelegate, LCTourpicCellDelegate, LCShareViewDelegate,WechatShortVideoDelegate,UICollectionViewDelegate,UICollectionViewDataSource, LCSequareCollectionCellDelegate,UIScrollViewDelegate>
/// 界面上方功能选择按钮.

//@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBarButton;
@property (weak, nonatomic) IBOutlet UIView *tabBarView;
@property (nonatomic, strong) LCTabView *tabView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *popularTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *squareCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *focusTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTopConstraint;

@property (retain, nonatomic) NSArray *popularArr;
@property (retain, nonatomic) NSString *popularOrderStr;
@property (retain, nonatomic) NSArray *squareArr;
@property (retain, nonatomic) NSString *squareOrderStr;
@property (retain, nonatomic) NSArray *focusArr;
@property (retain, nonatomic) NSString *focusOrderStr;

@property (nonatomic, strong) LCBlankContentView *focusBlankView;
@property (retain, nonatomic) LCShareView *shareView;
@property (retain, nonatomic) NSString *filePath;
@property (nonatomic,strong) WaterFallFlowLayout *flowLayout;
@property (nonatomic,strong) NSMutableArray * leftArray;

@end


@implementation LCTourpicTabVC

#pragma mark - Public Interface.

+ (UINavigationController *)createNavInstance {
    return (UINavigationController *)[LCStoryboardManager viewControllerWithFileName:SBNameTourpicTab identifier:VCIDTourpicNav];
}

+ (instancetype)createInstance {
    return (LCTourpicTabVC *)[LCStoryboardManager viewControllerWithFileName:SBNameTourpicTab identifier:VCIDTourpicTabVC];
}

#pragma mark - Lifecycle.

- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化变量.
//    self.title = @"发现";
    [self initVariable];
    /// 初始化导航栏.
    [self initNavigationBar];
    /// 初始化上面的功能选择按钮.
    [self initUpperTabbar];
    /// 初始化左右滚动的视图
    [self initScrollView];
    /// 初始化热门旅图列表.
    [self initPopularTableView];
    /// 初始化广场旅图列表.
    [self initsquareCollectionView];
    /// 初始化附近旅图列表.
    [self initFocusTableView];
    /// 初始化空附近显示.
    [self initFocusBlankView];
    /// 初始化通知.
    [self initNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];

    if (self.isViewWillAppearCalledFirstTime) {
        [self getPopularTourpicList];
        if (nil == self.squareArr || 0 == self.squareArr.count) {
            [self.squareCollectionView headerBeginRefreshing];
        } else {
            [self getSquareTourpicList];
        }
        if ([self haveLogin]) {
            [self getFocusTourpicList];
        }
        [self updateShow];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.isViewWillAppearCalledFirstTime) {
        [self.scrollView scrollRectToVisible:CGRectMake(DEVICE_WIDTH, 0, DEVICE_WIDTH, 10) animated:NO];
    }
    [super viewDidAppear:animated];
}

#pragma mark - Init.

- (void)commonInit {
    [super commonInit];
    self.isHaveTabBar = YES;
}

- (void)initVariable {
    self.showingTab = LCTourpicTabVCTab_Square;
    
    self.popularOrderStr = @"";
    self.focusOrderStr = @"";
    self.squareOrderStr = @"";
    
    self.popularArr = [[NSArray alloc] init];
    self.focusArr = [[NSArray alloc] init];
    self.squareArr = [[NSArray alloc] init];
    self.leftArray = [[NSMutableArray alloc] init];
}

- (void)initNavigationBar{
//    self.searchBarButton.image = [[UIImage imageNamed:@"TourpicSearchIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)initScrollView {
    self.scrollView.scrollsToTop = NO;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.directionalLockEnabled = YES;
}

- (void)initUpperTabbar {
    LCTabView *tabView = [LCTabView createInstance];
    tabView.frame = CGRectMake(0, 0, DEVICE_WIDTH, LCTabViewHeight);
    [tabView updateButtons:@[@"热门", @"此刻", @"关注"] withMargin:0];
    tabView.delegate = self;
    tabView.selectIndex = LCTourpicTabVCTab_Square;
    self.tabView = tabView;
    [self.tabBarView addSubview:tabView];
}

- (void)initPopularTableView {
    self.popularTableView.delegate = self;
    self.popularTableView.dataSource = self;
    self.popularTableView.estimatedRowHeight = 180;
    self.popularTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.popularTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.popularTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTourpicCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCTourpicCell class])];
    [self.popularTableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.popularTableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
    self.popularArr = [LCDataManager sharedInstance].popularTourpicArray;
//    [self updatePopularScrollView];
}

- (void)initFocusTableView {
    self.focusTableView.delegate = self;
    self.focusTableView.dataSource = self;
    self.focusTableView.estimatedRowHeight = 180;
    self.focusTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.focusTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.focusTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTourpicCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCTourpicCell class])];
    [self.focusTableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.focusTableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
    self.focusArr = [LCDataManager sharedInstance].focusTourpicArr;
}

- (void)initsquareCollectionView {
    self.squareCollectionView.delegate = self;
    self.squareCollectionView.dataSource = self;
    self.flowLayout = [[WaterFallFlowLayout alloc] init];
    self.squareCollectionView.collectionViewLayout = self.flowLayout;
    [self.squareCollectionView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.squareCollectionView addFooterWithTarget:self action:@selector(footerRefreshAction)];
    self.squareArr = [LCDataManager sharedInstance].squareTourpicStreamArr;
    [self updateLeftArray];
}

- (void)initFocusBlankView {
    self.focusBlankView = [[LCBlankContentView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH * 2, 0, DEVICE_WIDTH, DEVICE_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - LCTabViewHeight) imageName:BlankContentImageA title:@"你还没有关注别人，\r\n看到感兴趣的人就关注Ta吧！" marginTop:BlankContentMarginTop];
    [self.focusTableView insertSubview:self.focusBlankView atIndex:0];
}

- (void)initNotification {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:NotificationRedDotNumDidChange object:nil];
    [self addObserveToNotificationNameToRefreshData:URL_TOURPIC_PUBLISH];
    [self addObserveToNotificationNameToRefreshData:URL_LOGIN];
    [self addObserveToNotificationNameToRefreshData:URL_QUIT_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_TOURPIC_LIKE];
    [self addObserveToNotificationNameToRefreshData:URL_TOURPIC_UNLIKE];
}

#pragma mark - Update.
- (void)updateTableViewDataSource {
    switch (self.showingTab) {
        case LCTourpicTabVCTab_Popular:
            [self getPopularTourpicList];
            break;
        case LCTourpicTabVCTab_Square:
            [self getSquareTourpicList];
            break;
        case LCTourpicTabVCTab_Focus:
            [self getFocusTourpicList];
            break;
        default:
            break;
    }
}

- (void)refreshData {
//    if ([self.refreshDataReason isEqualToString:@"viewWillAppear:"]) {
//        self.squareOrderStr = @"";
//        [self getSquareTourpicList];
//    }

    self.popularArr = [[LCDataBufferManager sharedInstance] refreshTourpicArr:self.popularArr];
    self.focusArr = [[LCDataBufferManager sharedInstance] refreshTourpicArr:self.focusArr];
    self.squareArr = [[LCDataBufferManager sharedInstance] refreshTourpicArr:self.squareArr];
    
    [self updateShow];
}

- (void)headerRefreshAction {
    self.popularOrderStr = @"";
    self.focusOrderStr = @"";
    self.squareOrderStr = @"";
    [self updateTableViewDataSource];
}

- (void)footerRefreshAction {
    [self updateTableViewDataSource];
}

#pragma mark NetRequest.

- (void)getPopularTourpicList {
    [LCNetRequester getPopularTourpic:self.popularOrderStr callBack:^(NSArray *tourpicList, NSString *orderStr, NSError *error) {
        [self.popularTableView headerEndRefreshing];
        [self.popularTableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:self.popularOrderStr]) {
                if (nil != tourpicList) {
                    self.popularArr = [LCSharedFuncUtil addFiltedArrayToArray:nil withUnfiltedArray:tourpicList];
                } else {
                    self.popularArr = [[NSArray alloc] init];
                }
            } else {
                if (nil != tourpicList) {
                    self.popularArr = [LCSharedFuncUtil addFiltedArrayToArray:self.popularArr withUnfiltedArray:tourpicList];
                }
            }
            self.popularOrderStr = orderStr;
            [self updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}

- (void)getFocusTourpicList {
    [LCNetRequester getFocusTourpicWithOrderString:self.focusOrderStr callBack:^(NSArray *tourpicList, NSString *orderStr, NSError *error) {
        [self.focusTableView headerEndRefreshing];
        [self.focusTableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:self.focusOrderStr]) {
                if (nil != tourpicList) {
                    self.focusArr = [LCSharedFuncUtil addFiltedArrayToArray:nil withUnfiltedArray:tourpicList];
                } else {
                    self.focusArr = [[NSArray alloc] init];
                }
            } else {
                if (nil != tourpicList) {
                    self.focusArr = [LCSharedFuncUtil addFiltedArrayToArray:self.focusArr withUnfiltedArray:tourpicList];
                }
            }
            self.focusOrderStr = orderStr;
            [self updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}

- (void)getSquareTourpicList {
    [LCNetRequester getSquareTourpic:self.squareOrderStr callBack:^(NSArray *tourpicList, NSString *orderStr, NSError *error) {
        [self.squareCollectionView headerEndRefreshing];
        [self.squareCollectionView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:self.squareOrderStr]) {
                if (nil != tourpicList) {
                    self.squareArr = [LCSharedFuncUtil addFiltedArrayToArray:nil withUnfiltedArray:tourpicList];
                } else {
                    self.squareArr = [[NSArray alloc] init];
                }
            } else {
                if (nil != tourpicList) {
                    self.squareArr = [LCSharedFuncUtil addFiltedArrayToArray:self.squareArr withUnfiltedArray:tourpicList];
                }
            }
            [self updateShow];
            self.squareOrderStr = orderStr;
        }
    }];
}


#pragma mark Configure Cell Appearance
- (LCTourpicCell *)configurePopularTourpicViewCell:(NSIndexPath *)indexPath {
    LCTourpicCell *cell = [self.popularTableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCTourpicCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    LCTourpic *tourpic = [self.popularArr objectAtIndex:indexPath.row];
    [cell updateTourpicCell:tourpic withType:LCTourpicCellViewType_Cell];
    return cell;
}

- (LCTourpicCell *)configureFocusTourpicViewCell:(NSIndexPath *)indexPath {
    LCTourpicCell *cell = [self.focusTableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCTourpicCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    LCTourpic *tourpic = [self.focusArr objectAtIndex:indexPath.row];
    [cell updateTourpicCell:tourpic withType:LCTourpicCellViewType_FocusCell];
    return cell;
}

- (void)showTourpicDetail:(LCTourpic *)tourpic withType:(LCTourpicDetailVCViewType)type {
    LCTourpicDetailVC *vc = [LCTourpicDetailVC createInstance];
    vc.tourpic = tourpic;
    vc.type = type;
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}

- (void)updateShow {
    switch (self.showingTab) {
        case LCTourpicTabVCTab_Popular: {
            [self.scrollView scrollRectToVisible:CGRectMake(0, 0, DEVICE_WIDTH, 10) animated:NO];
            [LCDataManager sharedInstance].popularTourpicArray = self.popularArr;
            [self.popularTableView reloadData];
        }
            break;
        case LCTourpicTabVCTab_Square: {
            [self.scrollView scrollRectToVisible:CGRectMake(DEVICE_WIDTH, 0, DEVICE_WIDTH, 10) animated:NO];
            [self updateLeftArray];
            [LCDataManager sharedInstance].squareTourpicStreamArr = self.squareArr;
            [self.squareCollectionView reloadData];
        }
            break;
        case LCTourpicTabVCTab_Focus: {
            [self.scrollView scrollRectToVisible:CGRectMake(DEVICE_WIDTH * 2, 0, DEVICE_WIDTH, 10) animated:NO];
            if (self.focusArr && self.focusArr.count > 0) {
                self.focusBlankView.hidden = YES;
            } else {
                self.focusBlankView.hidden = NO;
            }
            [LCDataManager sharedInstance].focusTourpicArr = self.focusArr;
            [self.focusTableView reloadData];
        }
            break;
    }
}

- (void)updatePopularScrollView {
    self.popularTableView.scrollsToTop = YES;
    self.squareCollectionView.scrollsToTop = NO;
    self.focusTableView.scrollsToTop = NO;
}

- (void)updateFocusScrollView {
    self.popularTableView.scrollsToTop = NO;
    self.squareCollectionView.scrollsToTop = NO;
    self.focusTableView.scrollsToTop = YES;
}

- (void)updateSquareScrollView {
    self.popularTableView.scrollsToTop = NO;
    self.squareCollectionView.scrollsToTop = YES;
    self.focusTableView.scrollsToTop = NO;
}

#pragma mark Button Actions
- (IBAction)searchBarButtonAction:(id)sender {
    [MobClick event:Mob_TourPicTab_Search];
//    LCSearchDestinationVC *controller = [LCSearchDestinationVC createInstance];
////    controller.searchType = LCSearchDestinationVCType_Tourpic;
//    [self.navigationController pushViewController:controller animated:YES];
    
    LCTourpicTableVC *vc = [LCTourpicTableVC createInstance];
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}

- (IBAction)pickOneImageAction:(id)sender {
    [MobClick event:Mob_PublishTourPic];
    
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
    } else {
        [YSAlertUtil showActionSheetWithCallBack:^(NSInteger selectIndex) {
            if (selectIndex == 0) {
            } else if (selectIndex == 1) {
                [self checkPermissionOfSystem];
            } else if (selectIndex == 2) {
                [[LCPickMultiImageHelper sharedInstance] pickImageWithMaxNum:9 completion:^(NSArray *pickedImageArray) {
                    [self sendTourPicWithImageArray:pickedImageArray];
                } ];
            } else if (selectIndex == 3) {
                [[LCPickOneImageHelper sharedInstance] pickImageFromAlbum:NO camera:YES allowEdit:NO completion:^(UIImage *image) {
                    if (image) {
                        [self sendTourPicWithImageArray:@[image]];
                    }
                }];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@[@"拍摄视频",@"选择照片",@"拍摄照片"]];
    }
}

- (void)sendTourPicWithImageArray:(NSArray *)imageArray{
    if (imageArray && imageArray.count>0) {
        
        LCSendTourPicVCViewController *sendTourPicVC = [LCSendTourPicVCViewController createInstance];
        sendTourPicVC.type = LCTourpicType_Photo;
        sendTourPicVC.photoArray = [NSMutableArray arrayWithArray:imageArray];

        [self.navigationController pushViewController:sendTourPicVC animated:APP_ANIMATION];
    }
}

- (void)cellLikedAction:(LCTourpic *)tourpic {
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return ;
    }
    if (LCTourpicLike_IsLike == tourpic.isLike) {
        tourpic.isLike = LCTourpicLike_IsUnlike;
        if (tourpic.likeNum - 1 >= 0) {
            tourpic.likeNum -= 1;
        }
        [LCNetRequester unlikeTourpic:tourpic.guid callBack:^(NSInteger likeNum, NSInteger isLike, NSError *error) {
            if (!error) {
                tourpic.likeNum = likeNum;
                tourpic.isLike = isLike;
            } else {
                [YSAlertUtil tipOneMessage:error.domain];
            }
        }];
    } else {
        tourpic.isLike = LCTourpicLike_IsLike;
        tourpic.likeNum += 1;
        // 1为点赞，2为转发
        [LCNetRequester likeTourpic:tourpic.guid withType:@"1" callBack:^(NSInteger likeNum, NSInteger forwardNum, NSInteger isLike, NSError *error) {
            if (!error) {
                tourpic.likeNum = likeNum;
                tourpic.forwardNum = forwardNum;
                tourpic.isLike = isLike;
            } else {
                [YSAlertUtil tipOneMessage:error.domain];
            }
        }];
    }
    [self updateShow];
}

#pragma mark - LCSequareCollectionCellDelegate Delegate
- (void)squareCellLikeSelected:(LCSequareCollectionCell *)cell {
    [self cellLikedAction:cell.tourpic];
}

//#pragma mark - LCTourpicCell Delegate
//- (void)tourpicLikeSelected:(LCTourpicCell *)cell {
//    [self cellLikedAction:cell.tourpic];
//}

- (void)tourpicFocusSelected:(LCTourpicCell *)cell {
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return ;
    }
    LCTourpic *tourpic = cell.tourpic;
    LCUserModel *user = tourpic.user;
    
    if (1 == user.isFavored) {
        user.isFavored = 0;
        [LCNetRequester unfollowUser:user.uUID callBack:^(LCUserModel *user, NSError *error) {
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            } else {
                user.isFavored = 0;
            }
        }];
    } else {
        user.isFavored = 1;
        [LCNetRequester followUser:@[user.uUID] callBack:^(NSError *error) {
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            } else {
                user.isFavored = 1;
            }
        }];
    }
    [self updateShow];
}

- (void)tourpicCommentSelected:(LCTourpicCell *)cell {
    [MobClick event:Mob_TourPicList_Comment];
    [LCViewSwitcher pushToShowTourPicDetail:cell.tourpic withType:LCTourpicDetailVCViewType_Comment on:self.navigationController];
}

- (void)forwardTourpic:(LCTourpicCell *)cell {
    [MobClick event:Mob_TourPicList_Share];
    if (!self.shareView) {
        self.shareView = [LCShareView createInstance];
    }
    self.shareView.delegate = self;
    self.tabBarController.tabBar.hidden = YES;
    [LCShareView showShareView:self.shareView onViewController:self forTourpic:cell.tourpic];
    //[LCShareUtil shareTourpicWeixinAction:cell.tourpic presentedController:self];
}

- (void)viewTourpicPhoto:(LCTourpicCell *)cell{
    NSMutableArray *imageModels = [[NSMutableArray alloc] init];
    NSInteger imageIndex = 0;
    if (self.showingTab == LCTourpicTabVCTab_Focus) {
        for(LCTourpic *tourpic in self.focusArr){
            LCImageModel *model = [[LCImageModel alloc] init];
            model.imageUrl = tourpic.picUrl;
            model.imageUrlThumb = tourpic.thumbPicUrl;
            [imageModels addObject:model];
        }
        
        NSIndexPath *indexPath = [self.focusTableView indexPathForCell:cell];
        imageIndex = indexPath.row;
    }else if(self.showingTab == LCTourpicTabVCTab_Popular) {
        for(LCTourpic *tourpic in self.popularArr){
            LCImageModel *model = [[LCImageModel alloc] init];
            model.imageUrl = tourpic.picUrl;
            model.imageUrlThumb = tourpic.thumbPicUrl;
            [imageModels addObject:model];
        }
        
        NSIndexPath *indexPath = [self.popularTableView indexPathForCell:cell];
        imageIndex = indexPath.row;
    }
    
    LCPhotoScanner *photoScanner = [LCPhotoScanner createInstance];
    [photoScanner showImageModels:imageModels fromIndex:imageIndex];
    [[LCSharedFuncUtil getTopMostViewController] presentViewController:photoScanner animated:YES completion:nil];
}

#pragma mark LCShareView Delegate
- (void)cancelShareAction {
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        self.tabBarController.tabBar.hidden = NO;
    }];
}

- (void)shareTourpicWeixin:(LCTourpic *)tourpic {
    ZLog(@"shareTourpicWeixin");
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        self.tabBarController.tabBar.hidden = NO;
        [LCShareUtil shareTourpicWeixinAction:tourpic presentedController:self callBack:^(NSInteger forwardNum, NSError *error) {
            if (!error) {
                tourpic.forwardNum = forwardNum;
                [self updateShow];
            }
        }];
    }];
}

- (void)shareTourpicWeixinTimeLine:(LCTourpic *)tourpic {
    ZLog(@"shareTourpicWeixinTimeLine");
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        self.tabBarController.tabBar.hidden = NO;
        [LCShareUtil shareTourpicWeixinTimeLine:tourpic presentedController:self callBack:^(NSInteger forwardNum, NSError *error) {
            if (!error) {
                tourpic.forwardNum = forwardNum;
                [self updateShow];
            }
        }];
    }];
}

- (void)shareTourpicWeibo:(LCTourpic *)tourpic {
    ZLog(@"shareTourpicWeibo");
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        self.tabBarController.tabBar.hidden = NO;
        [LCShareUtil shareTourpicWeibo:tourpic presentedController:self callBack:^(NSInteger forwardNum, NSError *error) {
            if (!error) {
                tourpic.forwardNum = forwardNum;
                [self updateShow];
            }
        }];
    }];
}

- (void)shareTourpicQQ:(LCTourpic *)tourpic {
    ZLog(@"shareTourpicQQ");
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^{
        self.tabBarController.tabBar.hidden = NO;
        [LCShareUtil shareTourpicQQ:tourpic presentedController:self callBack:^(NSInteger forwardNum, NSError *error) {
            if (!error) {
                tourpic.forwardNum = forwardNum;
                [self updateShow];
            }
        }];
    }];
}

#pragma mark LCTabView Delegate
- (void)tabView:(LCTabView *)tabView didSelectIndex:(NSInteger)index {
    self.showingTab = index;
    switch (index) {
        case LCTourpicTabVCTab_Popular:
            [self updatePopularScrollView];
            break;
        case LCTourpicTabVCTab_Square:
            [self updateSquareScrollView];
            break;
        case LCTourpicTabVCTab_Focus:
            [self updateFocusScrollView];
            break;
        default:
            break;
    }
    [self updateShow];
}

#pragma mark UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (tableView == self.popularTableView) {
        cell = [self configurePopularTourpicViewCell:indexPath];
    } else if (tableView == self.focusTableView) {
        cell = [self configureFocusTourpicViewCell:indexPath];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.popularTableView) {
        return self.popularArr.count;
    } else if(tableView == self.focusTableView) {
        return self.focusArr.count;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.popularTableView) {
        if (indexPath.row < self.popularArr.count) {
            LCTourpic *tourpic = [self.popularArr objectAtIndex:indexPath.row];
            [LCViewSwitcher pushToShowTourPicDetail:tourpic withType:LCTourpicDetailVCViewType_Normal on:self.navigationController];
        }
    } else if (tableView == self.focusTableView) {
        if (indexPath.row < self.focusArr.count) {
            LCTourpic *tourpic = [self.focusArr objectAtIndex:indexPath.row];
            [LCViewSwitcher pushToShowTourPicDetail:tourpic withType:LCTourpicDetailVCViewType_Normal on:self.navigationController];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:APP_ANIMATION];
}

- (void)showTabIndex:(NSInteger)index{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (index >= 0 && index <3) {
            self.tabView.selectIndex = index;
            [self tabView:self.tabView didSelectIndex:index];
        }
    });
}

#pragma mark - WechatShortVideoDelegate
- (void)finishWechatShortVideoCapture:(NSString *)filePath {
    self.filePath = filePath;
}

- (void)finishWechatShortVideoCaptureWithAsset:(AVAsset *)asset {
    LCSendTourPicVCViewController *sendTourPicVC = [LCSendTourPicVCViewController createInstance];
    sendTourPicVC.type = LCTourpicType_Video;
    sendTourPicVC.filePath = self.filePath;
    [sendTourPicVC setVideoPath:asset];
    [self.navigationController pushViewController:sendTourPicVC animated:APP_ANIMATION];
}

- (void)sendTourPic {
    [self pickOneImageAction:nil];
}


#pragma mark - UICollectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.squareArr count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCSequareCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SequareCollectionCell" forIndexPath:indexPath];
    cell.delegate = self;
    LCTourpic *tourpic = [self.squareArr objectAtIndex:indexPath.row];
    [cell updateCollectionCell:tourpic];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LCTourpic *tourpic = [self.squareArr objectAtIndex:indexPath.row];
    [self showTourpicDetail:tourpic withType:LCTourpicDetailVCViewType_Normal];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    LCTourpic * tourpic = [self.squareArr objectAtIndex:indexPath.item];
    float height = (DEVICE_WIDTH - 2.0f) * tourpic.coverHeight / (2.0f * tourpic.coverWidth);
    
    return CGSizeMake((DEVICE_WIDTH - 2.0f) / 2.0f, height);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if ([self.leftArray indexOfObject:[NSNumber numberWithInteger:section]] != NSNotFound) {
        return UIEdgeInsetsMake(1, 0, 1, 1);
    } else {
        return UIEdgeInsetsMake(1, 1, 1, 0);
    }
}
#pragma mark - ScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return ;
    }
    
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        return ;
    }
    
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    switch (index) {
        case 0:
            self.showingTab = LCTourpicTabVCTab_Popular;
            break;
        case 1:
            self.showingTab = LCTourpicTabVCTab_Square;
            break;
        case 2:
            self.showingTab = LCTourpicTabVCTab_Focus;
            break;
        default:
            break;
    }
    [self.tabView setSelectIndex:self.showingTab];
    [self tabView:self.tabView didSelectIndex:self.showingTab];
    [self.scrollView setContentOffset:CGPointMake(index * DEVICE_WIDTH, 0.0f) animated:YES];
}

- (void)updateLeftArray {
    CGFloat leftHeight = 0;
    CGFloat rightHeight = 0;
    [self.leftArray removeAllObjects];

    for (NSInteger i = 0; i < self.squareArr.count; i++) {
        
        LCTourpic * tourpic = self.squareArr[i];
        CGFloat cellHeight = (DEVICE_WIDTH - 2.0f) * tourpic.coverHeight / (2.0f * tourpic.coverWidth);
        if (i == 0) {
            leftHeight += cellHeight;
            [self.leftArray addObject:[NSNumber numberWithInteger:i]];
        } else {
            if (rightHeight - leftHeight > - 0.0001) {
                leftHeight += cellHeight;
                [self.leftArray addObject:[NSNumber numberWithInteger:i]];
            } else {
                rightHeight += cellHeight;
            }
        }
        
    }
}

//#pragma mark - Setup Location Sevice
//- (void)setUpUserLocation:(BOOL)isSettingURL {
//    [YSAlertUtil alertTwoButton:@"取消" btnTwo:@"开启定位" withTitle:@"定位服务未开启" msg:@"定位服务开启后才能看到附近用户发的旅图" callBack:^(NSInteger chooseIndex) {
//        if (chooseIndex == 0 ){
//            return ;
//        } else if (chooseIndex == 1) {
//            if (isSettingURL) {
//                [[UIApplication sharedApplication] openURL:[ NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
//            } else {
//                [[UIApplication sharedApplication] openURL:[ NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//            }
//        }
//    }];
//}

- (void)checkPermissionOfSystem {
    if (![LCSystemPermissionUtil isHaveCameraPermission]) {
        return ;
    }
    if (![LCSystemPermissionUtil isHaveAlbumPermission]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [LCSystemPermissionUtil isHaveVoicePermission:^(BOOL isHavePermission) {
        if (isHavePermission) {
            //可以拍摄视频
            WechatShortVideoController *wechatShortVideoController = [[WechatShortVideoController alloc] init];
            wechatShortVideoController.delegate = weakSelf;
            [weakSelf presentViewController:wechatShortVideoController animated:YES completion:^{}];
        }
    }];
}

@end

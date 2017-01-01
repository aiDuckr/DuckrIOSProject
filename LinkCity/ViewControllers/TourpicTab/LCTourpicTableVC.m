//
//  LCTourpicTableVC.m
//  LinkCity
//
//  Created by roy on 5/10/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCTourpicTableVC.h"
#import "LCPickOneImageHelper.h"
//#import "LCTourpicDescVC.h"
#import "LCTourpicCell.h"
#import "LCShareView.h"
#import "LCBlankContentView.h"
#import "LCPickMultiImageHelper.h"
#import "WechatShortVideoController.h"
#import "LCSendTourPicVCViewController.h"
#import "LCPlaceSearchHistoryInfoCell.h"

@interface LCTourpicTableVC ()<UITableViewDataSource,UITableViewDelegate,LCTourpicCellDelegate,LCShareViewDelegate, UISearchBarDelegate, WechatShortVideoDelegate>
@property (retain, nonatomic) LCSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

@property (nonatomic, strong) NSArray *tourpicArray;
@property (nonatomic, strong) NSString *tourpicOrderStr;
@property (strong, nonatomic) NSArray *searchResArr;
@property (retain, nonatomic) LCShareView *shareView;

@property (nonatomic, strong) LCBlankContentView *tourpicBlankView;
@property (nonatomic, assign) BOOL haveDoneFirstTimeNetRequest;
@property (nonatomic, retain) NSString *filePath;
@end

@implementation LCTourpicTableVC

+ (instancetype)createInstance {
    return (LCTourpicTableVC *)[LCStoryboardManager viewControllerWithFileName:SBNameTourpicTab identifier:VCIDTourpicTableVC];
}

- (void)commonInit {
    [super commonInit];
    self.haveDoneFirstTimeNetRequest = NO;
    self.searchResArr = [[NSArray alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.tourpicTableType == LCTourpicTableType_Search) {
    [self initSearchBar];
    [self initSearchTableView];
    }
//    UIBarButtonItem *sendTourpicButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"TourpicCameraIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(sendTourpicButtonAction)];
//    self.navigationItem.rightBarButtonItem = sendTourpicButton;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 180;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTourpicCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCTourpicCell class])];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
    [self.tableView headerBeginRefreshing];
    
    
    [self addObserveToNotificationNameToRefreshData:URL_UNFOLLOW_USER];
//    [self addObserveToNotificationNameToRefreshData:URL_TOURPIC_LIKE];
//    [self addObserveToNotificationNameToRefreshData:URL_TOURPIC_UNLIKE];
    [self addObserveToNotificationNameToRefreshData:URL_FOLLOW_USER];
}

/// 初始化搜索框.
- (void)initSearchBar {
    self.searchBar = [[LCSearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, (DEVICE_WIDTH - 45.0f * 3), 44.0f)];
    self.searchBar.delegate = self;
    self.searchBar.text = @"";
    [self.searchBar setSearchTextFieldBackgroundColor:UIColorFromRGBA(0xf5f4f2, 1.0)];
    [self.searchBar setPlaceholder:@"搜索地点"];
    self.searchBar.showsCancelButton = NO;
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(45.0f, 0.0f, (DEVICE_WIDTH - 45.0f * 3), 44.0f)];
    [searchView addSubview:self.searchBar];
    self.navigationItem.titleView = searchView;
    
    self.tourpicBlankView = [[LCBlankContentView alloc] initWithFrame:CGRectMake(0, 44, DEVICE_WIDTH, DEVICE_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - LCTabViewHeight) imageName:BlankContentImageA title:@"这里还没有相关的旅图，\r\n先去别处看看吧！" marginTop:BlankContentMarginTop];
    [self.view insertSubview:self.tourpicBlankView atIndex:0];

}

- (void)initSearchTableView {
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    self.searchTableView.estimatedRowHeight = 180;
    self.searchTableView.rowHeight = UITableViewAutomaticDimension;
    self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.searchTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCPlaceSearchHistoryInfoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCPlaceSearchHistoryInfoCell class])];
//    [self.searchTableView addHeaderWithTarget:self action:@selector(headerSearchRefreshAction)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    [self updateShow];
    if (self.isViewWillAppearCalledFirstTime &&self.tourpicTableType == LCTourpicTableType_Search) {
        [self.searchBar becomeFirstResponder];
    }
}

- (void)updateShow {
    switch (self.tourpicTableType) {
        case LCTourpicTableType_Search:
            self.title = [LCStringUtil getNotNullStr:self.searchKeyWord];
            [self.searchTableView reloadData];
            break;
        case LCTourpicTableType_User:
            self.title = [NSString stringWithFormat:@"%@的旅图",self.user.nick];
            self.searchTableView.hidden = YES;
    }
    [self.tableView reloadData];

    if (!self.haveDoneFirstTimeNetRequest || (self.tourpicArray && self.tourpicArray.count > 0)) {
        self.tourpicBlankView.hidden = YES;
    } else {
        self.tourpicBlankView.hidden = NO;
    }
}

- (void)refreshData {
//    switch (self.tourpicTableType) {
//        case LCTourpicTableType_Search:
//            [self.searchTableView headerBeginRefreshing];
//            break;
//        case LCTourpicTableType_User:
//            [self.tableView headerBeginRefreshing];
//    }

    [self.tableView headerBeginRefreshing];
}

#pragma mark ButtonAction
- (void)sendTourpicButtonAction {
    [MobClick event:Mob_PublishTourPic];
    
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
    } else {
        [YSAlertUtil showActionSheetWithCallBack:^(NSInteger selectIndex) {
            if (selectIndex == 0) {
            } else if(selectIndex == 1) {
                WechatShortVideoController *wechatShortVideoController = [[WechatShortVideoController alloc] init];
                wechatShortVideoController.delegate = self;
                [self presentViewController:wechatShortVideoController animated:YES completion:^{}];
            } else if(selectIndex == 2) {
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
        sendTourPicVC.photoArray = [NSMutableArray arrayWithArray:imageArray];//[imageArray mutableCopy];
        [self.navigationController pushViewController:sendTourPicVC animated:APP_ANIMATION];
    }
}

- (void)showSearchResultView:(NSString *)text {
    [self.searchBar resignFirstResponder];
    self.searchBar.text = text;
    self.searchTableView.hidden = YES;
    self.searchKeyWord = text;
    [self.tableView headerBeginRefreshing];
}

- (void)dismissKeyboardAndHidesearchResultArr {
    [self.searchBar resignFirstResponder];
    self.searchTableView.hidden = YES;
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

#pragma mark NetRequest
- (void)searchTourpicWithOrderStr:(NSString *)orderStr{
    switch (self.tourpicTableType) {
        case LCTourpicTableType_Search: {
            [LCNetRequester getTourpicByPlaceName:self.searchKeyWord orderString:orderStr callBack:^(NSArray *tourpicList, NSString *orderStr, NSError *error) {
                self.haveDoneFirstTimeNetRequest = YES;
                [self.tableView headerEndRefreshing];
                [self.tableView footerEndRefreshing];
                if (error) {
                    [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
                } else {
                    if ([LCStringUtil isNullString:self.tourpicOrderStr]) {
                        //header refresh
                        if (tourpicList) {
                            self.tourpicArray = tourpicList;
                            [self updateShow];
                        } else {
                            self.tourpicArray = [[NSArray alloc] init];
                        }
                    } else {
                        //footer refresh
                        if (tourpicList) {
                            NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:self.tourpicArray];
                            [mutArr addObjectsFromArray:tourpicList];
                            self.tourpicArray = mutArr;
                            [self updateShow];
                        }
                    }
                    self.tourpicOrderStr = orderStr;
                }
            }];
        }
            break;
        case LCTourpicTableType_User: {
            [LCNetRequester getUserTourpics:self.user.uUID withOrderStr:orderStr callBack:^(NSArray *tourpicArr, NSString *orderStr, NSError *error) {
                self.haveDoneFirstTimeNetRequest = YES;
                [self.tableView headerEndRefreshing];
                [self.tableView footerEndRefreshing];
                if (error) {
                    [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
                } else {
                    if ([LCStringUtil isNullString:self.tourpicOrderStr]) {
                        //header refresh
                        if (tourpicArr) {
                            self.tourpicArray = tourpicArr;
                            [self updateShow];
                        } else {
                            self.tourpicArray = [[NSArray alloc] init];
                        }
                    } else {
                        //footer refresh
                        if (tourpicArr) {
                            NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:self.tourpicArray];
                            [mutArr addObjectsFromArray:tourpicArr];
                            self.tourpicArray = mutArr;
                            [self updateShow];
                        }
                    }
                    self.tourpicOrderStr = orderStr;
                }
            }];
        }
            break;
    }
}

- (void)tourpicFocusSelected:(LCTourpicCell *)cell {
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return ;
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LCTourpic *tourpic = cell.tourpic;
    LCUserModel *user = tourpic.user;
    
    if (nil != indexPath) {
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
}

- (void)clickPlaceBtn:(LCTourpicCell *)cell{
    [MobClick event:Mob_TourPicList_Place];
    if ([LCStringUtil isNotNullString:cell.tourpic.placeName]) {
        [LCViewSwitcher pushToShowTourPicTableVCForKeyWord:cell.tourpic.placeName on:self.navigationController];
    }
}

- (void)tourpicCommentSelected:(LCTourpicCell *)cell{
    [MobClick event:Mob_TourPicList_Comment];
    [self showTourpicDetail:cell.tourpic];
}

- (void)requestSearchText {
    [LCNetRequester searchRelatedPlaceFor:self.searchBar.text callBack:^(NSArray *placeArray, NSError *error) {
        if (error) {
            LCLogWarn(@"search related place error: %@",error);
        } else {
            self.searchResArr = placeArray;
            [self updateShow];
        }
    }];
}

#pragma mark LCTabView
- (void)headerRefreshAction {
    self.tourpicOrderStr = nil;
    [self searchTourpicWithOrderStr:self.tourpicOrderStr];
}

- (void)footerRefreshAction {
    [self searchTourpicWithOrderStr:self.tourpicOrderStr];
}



#pragma mark UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    if (tableView == self.tableView) {
        number = self.tourpicArray.count;
    } else if (tableView == self.searchTableView) {
        number = self.searchResArr.count;
    }
    return number;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (tableView == self.tableView) {
        LCTourpic *tourpic = [self.tourpicArray objectAtIndex:indexPath.row];
        
        LCTourpicCell *tourpicCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCTourpicCell class]) forIndexPath:indexPath];
        tourpicCell.delegate = self;
        [tourpicCell updateTourpicCell:tourpic withType:LCTourpicCellViewType_Cell];
        cell = tourpicCell;
    } else if (tableView == self.searchTableView) {
        LCRoutePlaceModel *model = (LCRoutePlaceModel *)[self.searchResArr objectAtIndex:indexPath.row];
        LCPlaceSearchHistoryInfoCell *textCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCPlaceSearchHistoryInfoCell class]) forIndexPath:indexPath];
        textCell.historyPlaceLabel.text = model.placeName;
        cell = textCell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:APP_ANIMATION];
    if (tableView == self.tableView) {
        [self showTourpicDetail:[self.tourpicArray objectAtIndex:indexPath.row]];
    } else {
        LCRoutePlaceModel *model = (LCRoutePlaceModel *)[self.searchResArr objectAtIndex:indexPath.row];
        [self showSearchResultView:model.placeName];
    }
}

#pragma mark LCTourpicCell Delegate

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

#pragma mark InnerFunc
- (void)showTourpicDetail:(LCTourpic *)tourpic {
    LCTourpicDetailVC *vc = [LCTourpicDetailVC createInstance];
    vc.tourpic = tourpic;
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}

#pragma mark - UISearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self showSearchResultView:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchTableView.hidden = NO;
    [self requestSearchText];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissKeyboardAndHidesearchResultArr];
}



@end

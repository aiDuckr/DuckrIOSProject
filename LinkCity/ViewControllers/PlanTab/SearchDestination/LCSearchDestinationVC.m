//  首页搜索框，跳转至的VC。点击键盘的“搜索按钮”并不跳转至一个新VC，而是就在本VC内呈现内容。
//  LCSearchDestinationVC.m
//  LinkCity
//
//  Created by 张宗硕 on 11/7/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCSearchDestinationVC.h"
#import "LCRoutePlaceModel.h"
#import "LCPlanTableVC.h"
#import "LCRouteThemeModel.h"
#import "LCTourpicTableVC.h"
#import "LCHotPlaceCollectionViewCell.h"
#import "LCPlaceSearchHistoryInfoCell.h"
#import "LCSearchPlaceThemeCell.h"
#import "LCFreePlanCell.h"
#import "LCCostPlanCell.h"
#import "LCSearchDestinationMoreVC.h"
#import "LCSharedFuncUtil.h"
#import "LCHeaderCell.h"
#import "LCFooterCell.h"


@interface LCSearchDestinationVC ()<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, UIScrollViewDelegate, LCSearchPlaceThemeCellDelegate, LCSharedFuncUtilForGrayview, LCFooterCellForPushVCDelegate>
@property (retain, nonatomic) LCSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;//搜索结果表
@property (weak, nonatomic) IBOutlet UITableView *hintTableView;
@property (weak, nonatomic) IBOutlet UIView *hintResultView;
@property (nonatomic, strong) UIView *grayView;

@property (strong, nonatomic) NSArray *hotThemeArr;//页面上的“热门主题”
@property (strong, nonatomic) NSArray *hotPlaceArr;//其实是页面上的“热门搜索”
@property (retain, nonatomic) NSArray *historyPlaceArray;//用户搜索历史。并非什么historyPlace
@property (retain, nonatomic) NSArray *searchCostPlanResultArr;//缓存
@property (retain, nonatomic) NSArray *searchFreePlanResultArr;
@property (assign, nonatomic) NSInteger activNumber;
@property (assign, nonatomic) NSInteger inviteNumber;

@property (retain, nonatomic) NSString *searchText;

//@property (strong, nonatomic) LCSearchDestinationMoreVC *moreVC;
@end

@implementation LCSearchDestinationVC

+ (instancetype)createInstance {
    return (LCSearchDestinationVC *)[LCStoryboardManager viewControllerWithFileName:SBNamePlanTab identifier:VCIDSearchDestination];
}

- (void)commonInit {
    [super commonInit];
    
//    self.searchType = LCSearchDestinationVCType_Plan;
    self.hotThemeArr = [LCDataManager sharedInstance].appInitData.hotThemeArr;
    self.hotPlaceArr = [LCDataManager sharedInstance].appInitData.hotPlaceArr;
    self.historyPlaceArray = [LCDataManager sharedInstance].historySearchArray;
    self.searchText = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGestureRecognizer];
    [self initSearchBar];
    [self initresultTableView];
    [self initHintTableView];
    
    //从缓存取数据
    //先从缓存里拿数据，回调之后再把这个数据替换掉
    LCDataManager *manager = [LCDataManager sharedInstance];
    self.searchFreePlanResultArr = manager.searchFreePlanResultArr;
    self.searchCostPlanResultArr = manager.searchCostPlanResultArr;
    [self.resultTableView reloadData];
    
}

//- (void)initNavigationBar {
//    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonAction)];
//    self.navigationItem.rightBarButtonItem = cancelBtn;
//}

- (void)initGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction)];
    pan.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:pan];
}

- (void)initHintTableView {
    self.hintTableView.delegate = self;
    self.hintTableView.dataSource = self;
    
    self.hintTableView.estimatedRowHeight = 120.0f;
    self.hintTableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.hintTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCSearchPlaceThemeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCSearchPlaceThemeCell class])];//热门主题，
    [self.hintTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCPlaceSearchHistoryInfoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCPlaceSearchHistoryInfoCell class])];//HistoryInfo
}

- (void)tapAction {
    [self.searchBar resignFirstResponder];
}

- (void)panAction {
    [self.searchBar resignFirstResponder];
}

- (void)initresultTableView {
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;
    self.resultTableView.hidden = YES;
    self.resultTableView.rowHeight = UITableViewAutomaticDimension;
    self.resultTableView.estimatedRowHeight = 72.0f;
    /*
     内容的大的cell分为三种：
         1.LCHomeRcmdCell这个长的和LCCostPlanCell非常像，只不过底下还有其他推荐，
         2.LCCostPlanCell就只有一个主活动cell  
         3.LCFreePlanCell
     
     搜索只呈现2、3两种cell
     */
    
    [self.resultTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.resultTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    [self.resultTableView registerClass:[LCHeaderCell class] forCellReuseIdentifier:NSStringFromClass([LCHeaderCell class])];
    [self.resultTableView registerClass:[LCFooterCell class] forCellReuseIdentifier:NSStringFromClass([LCFooterCell class])];
    [self.resultTableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

//    self.navigationController.navigationBar.hidden = NO;
//    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.isViewWillAppearCalledFirstTime) {
        [self.searchBar becomeFirstResponder];
    }
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

/// 初始化搜索框.
- (void)initSearchBar {
    self.searchBar = [[LCSearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, (DEVICE_WIDTH - 45.0f * 3), 44.0f)];
    [self.searchBar setSearchTextFieldBackgroundColor:UIColorFromRGBA(0xf5f4f2, 1.0)];

    self.searchBar.delegate = self;
    self.searchBar.text = @"";
    [self.searchBar setPlaceholder:@"搜索活动主题、名称、地点"];
    self.searchBar.showsCancelButton = NO;
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(45.0f, 0.0f, (DEVICE_WIDTH - 45.0f * 3), 44.0f)];
    [searchView addSubview:self.searchBar];
    self.navigationItem.titleView = searchView;
}


- (void)panGestureAction {
    [self.view endEditing:YES];
}

- (void)clearHistoryAction:(id)sender {
    self.historyPlaceArray = [[NSArray alloc] init];
    [self updateShow];
}




- (void)updateShow {
    [LCDataManager sharedInstance].historySearchArray = self.historyPlaceArray;
    
    [self.hintTableView reloadData];
    [self.resultTableView reloadData];
    
}

- (void)headerRefreshAction {
    [self requestSearchResults];
}


#pragma mark 获取搜索结果
- (void)requestSearchResults {
    __weak typeof(self) weakSelf = self;
    self.searchCostPlanResultArr = nil;
    self.searchFreePlanResultArr = nil;
    
    [LCNetRequester requestHomeSearchText:self.searchText withCallBack:^(NSArray *activList, NSArray *inviteList, NSNumber *activNumber, NSNumber *inviteNumber, NSError *error) {
        [weakSelf.resultTableView headerEndRefreshing];
        [weakSelf.resultTableView footerEndRefreshing];
        self.activNumber = [activNumber integerValue];
        self.inviteNumber = [inviteNumber integerValue];
        if (!error) {
            self.searchCostPlanResultArr = activList;
            self.searchFreePlanResultArr = inviteList;
            /// 有数据的时候隐藏没有找到相关活动视图.
            if ((nil == self.searchCostPlanResultArr || self.searchCostPlanResultArr.count <= 0) && (nil == self.searchFreePlanResultArr || self.searchFreePlanResultArr.count <= 0)) {
                self.hintResultView.hidden = NO;
            } else {
                self.hintResultView.hidden = YES;
            }
            [weakSelf updateShow];//更新一下列表。
            [self.resultTableView removeHeader];//请求下来数据就把可下拉刷新的header移除掉。
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }

    }];
    
}


- (void)recordSearchHistory:(NSString *)text {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:0];
    [mutableArray addObject:text];
    NSArray *array = [mutableArray arrayByAddingObjectsFromArray:self.historyPlaceArray];
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    
    for (unsigned i = 0; i < [array count]; i++) {
        if ([categoryArray containsObject:[array objectAtIndex:i]] == NO) {
            [categoryArray addObject:[array objectAtIndex:i]];
            if (categoryArray.count >= SearchHistoryMaxNum) {
                break ;
            }
        }
    }
    self.historyPlaceArray = categoryArray;
    [self updateShow];
}
#pragma mark 显示搜索结果的视图
- (void)showSearchResultView:(NSString *)text {
    self.searchBar.text = text;
    self.searchText = text;
    [self.resultTableView headerBeginRefreshing];
    self.resultTableView.hidden = NO;
    
    /// 缓存数据.
    LCDataManager *manager = [LCDataManager sharedInstance];
    manager.searchCostPlanResultArr = self.searchCostPlanResultArr;
    manager.searchFreePlanResultArr = self.searchFreePlanResultArr;
}

#pragma mark - LCSearchPlaceThemeCell Delegate
/// 这个代理将传过来的text值接受不了过来，然后进行搜索。主动方传值，被动方接收。
- (void)searchPlaceThemeDidSelected:(LCSearchPlaceThemeCell *)cell withText:(NSString *)text {
    [self showSearchResultView:text];//点击“热门主题”和“热门搜索（地点）”
    self.searchText = text;
}

#pragma mark - UITableView Delegate.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger number = 0;
    if (tableView == self.hintTableView) {
        return 3;//如果是未搜索的时候，分为3块（好像不对吧？）
    }else if (tableView == self.resultTableView){
        return 2;
    }
    return number;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNum = 0;
    
    if (tableView == self.resultTableView) {
        if (section == 0) {
            if (self.searchCostPlanResultArr.count > 0) {
                rowNum = self.searchCostPlanResultArr.count + 2;//每个section有最多3个数据。。。
            }
        } else if(section == 1){
            if (self.searchFreePlanResultArr.count > 0) {
                rowNum = self.searchFreePlanResultArr.count + 2;//每个section有最多3个数据。。。
            }
        }
        
    } else if (tableView == self.hintTableView) {
        if (0 == section) {
            if (nil != self.hotThemeArr && self.hotThemeArr.count > 0) {
                rowNum = 1;//一行！分两排显示？
            } else {
                rowNum = 0;
            }
        } else if (1 == section) {
            if (nil != self.hotPlaceArr && self.hotPlaceArr.count > 0) {
                rowNum = 1;
            } else {
                rowNum = 0;
            }
        } else if (2 == section) {
            rowNum = self.historyPlaceArray.count;
        }
    }
    
    return rowNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0f;
    if (tableView == self.hintTableView && 2 == section) {
        height = 34.0f;//热门主题cell和热门搜索cell只是cell
    } else if (tableView == self.resultTableView) {
//        if (0 == section && nil != self.searchCostPlanResultArr && self.searchCostPlanResultArr.count > 0) {
//            height = 40.0f;
//        }
//        if (1 == section && nil != self.searchFreePlanResultArr && self.searchFreePlanResultArr.count > 0) {
//            height = 40.0f;
//        }
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 0.0f;
    if (tableView == self.resultTableView) {
//        if (0 == section && nil != self.searchCostPlanResultArr && self.searchCostPlanResultArr.count > 0) {
//            height = 45.0f;
//        }
//        if (1 == section && nil != self.searchFreePlanResultArr && self.searchFreePlanResultArr.count > 0) {
//            height = 45.0f;
//        }
    }
    return height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = nil;
    if (tableView == self.hintTableView && 2 == section) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DEVICE_WIDTH, 80.0f)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 17.0f, 100.0f, 18.0f)];
        label.text = @"搜索历史";
        label.font = [UIFont fontWithName:APP_CHINESE_FONT size:15.0f];
        label.textColor = UIColorFromRGBA(0x2c2a28, 1.0);
        [view addSubview:label];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_WIDTH - 2 * 12.0f - 28.0f, 12.0f, 28.0f, 2 * 5.0f + 14.0f)];
        [btn setTitle:@"清空" forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGBA(0x2c2a28, 1.0f) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:APP_CHINESE_FONT size:14.0f];
        [btn addTarget:self action:@selector(clearHistoryAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    } else if (tableView == self.resultTableView){
//        view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DEVICE_WIDTH, 34.0f)];
//        view.backgroundColor = UIColorFromRGBA(0xf5f4f2, 1.0);
//        
//        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_WIDTH - 12.0f - 100.0f, 0.0f, 100.0f, 40.0f)];
//        label1.textAlignment = NSTextAlignmentRight;
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, 100.0f, 40.0f)];
//        label.font = [UIFont fontWithName:APP_CHINESE_FONT size:14.0f];
//        label.textColor = UIColorFromRGBA(0x7d7975, 1.0);
//        [view addSubview:label];
//        
//        label1.font = [UIFont fontWithName:APP_CHINESE_FONT size:14.0f];
//        label1.textColor = UIColorFromRGBA(0xaba7a2, 1.0);
//        [view addSubview:label1];
//        
//        if (0 == section && nil != self.searchCostPlanResultArr && self.searchCostPlanResultArr.count > 0) {
//            label.text = @"相关活动";
//            label1.text = [NSString stringWithFormat:@"%ld个结果",self.activNumber];
//        } else if (1 == section && nil != self.searchFreePlanResultArr && self.searchFreePlanResultArr.count > 0){
//            label.text = @"相关邀约";
//            label1.text = [NSString stringWithFormat:@"%ld个结果",self.inviteNumber];
//        } else {
//            view = [[UIView alloc] init];
//        }
    }
    
    return view;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] init];
//    if (tableView == self.resultTableView){
////        view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DEVICE_WIDTH, 45.0f)];
////        view.backgroundColor = [UIColor whiteColor];
////        
////        
////        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
////        button.frame = CGRectMake(0, 0, DEVICE_WIDTH, 45.0f);
////        button.titleLabel.font = [UIFont fontWithName:APP_CHINESE_FONT size:14.0f];
////        button.backgroundColor = [UIColor whiteColor];
////        [button setTitleColor:UIColorFromRGBA(0x7d7975, 1.0f) forState:UIControlStateNormal];
////        UIImage *imageArrow = [UIImage imageNamed:@"tiaozhuan_1"];
////        [button setImage:imageArrow forState:UIControlStateNormal];
////        
////        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageArrow.size.width, 0, imageArrow.size.width)];
////        [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.bounds.size.width + 179, 0, -button.titleLabel.bounds.size.width)];
////        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
////        [self.view addSubview:button];
////        
////        [button addTarget:self action:@selector(jumpToMore:) forControlEvents:UIControlEventTouchUpInside];//传只能传个uibutton过去。
////        
////        CALayer *line = [CALayer layer];
////        line.frame = CGRectMake(12, 0, DEVICE_WIDTH - 24, 1);
////        line.backgroundColor = UIColorFromRGBA(0xe8e4dd, 1.0f).CGColor;
////        [view.layer addSublayer:line];
////        [view addSubview:button];
////        if (0 == section && nil != self.searchCostPlanResultArr && self.searchCostPlanResultArr.count > 0) {
////            [button setTitle:NSLocalizedString(@"查看更多活动", nil) forState:UIControlStateNormal];
////            button.tag = 1;
////        } else if (1 == section && nil != self.searchFreePlanResultArr && self.searchFreePlanResultArr.count > 0){
////            [button setTitle:NSLocalizedString(@"查看更多邀约", nil) forState:UIControlStateNormal];
////            button.tag = 2;
////            return view;
////        } else {
////            view = [[UIView alloc] init];
////        }
//    }
//    
//    return view;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (tableView == self.resultTableView) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                LCHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCHeaderCell class])];
                if (nil == headerCell) {
                    headerCell = [[LCHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([LCHeaderCell class])];
                }
                [headerCell setLabelText1:@"相关活动" labelText2:[NSString stringWithFormat:@"%ld个结果",self.activNumber]];
                cell = headerCell;
            } else if (indexPath.row == self.searchCostPlanResultArr.count + 1){
                LCFooterCell *footerCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCFooterCell class])];
                if (nil == footerCell) {
                    footerCell = [[LCFooterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([LCFooterCell class])];
                }
                
                [footerCell setButtonTitleWithText:@"查看更多活动" searchText:self.searchText];
                footerCell.delegate = self;
                cell = footerCell;
            } else {
                LCCostPlanCell *costPlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanCell class]) forIndexPath:indexPath];
                [costPlanCell updateShowWithPlan:self.searchCostPlanResultArr[indexPath.row - 1]];
                cell = costPlanCell;
            }
            
        } else if (indexPath.section == 1){
            if (indexPath.row == 0) {
                LCHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCHeaderCell class])];
                if (nil == headerCell) {
                    headerCell = [[LCHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([LCHeaderCell class])];
                }
                [headerCell setLabelText1:@"相关邀约" labelText2:[NSString stringWithFormat:@"%ld个结果",self.inviteNumber]];
                cell = headerCell;
            } else if (indexPath.row == self.searchFreePlanResultArr.count + 1){
                LCFooterCell *footerCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCFooterCell class])];
                if (nil == footerCell) {
                    footerCell = [[LCFooterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([LCFooterCell class])];
                }
                
                [footerCell setButtonTitleWithText:@"查看更多邀约" searchText:self.searchText];
                footerCell.delegate = self;
                cell = footerCell;
            } else {
                LCFreePlanCell *freePlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCFreePlanCell class]) forIndexPath:indexPath];
                [freePlanCell updateShowWithPlan:self.searchFreePlanResultArr[indexPath.row - 1] hideThemeId:0 withSpaInset:YES];
                freePlanCell.delegate = [LCDelegateManager sharedInstance];
                cell = freePlanCell;
            }
        }
        
    } else if (tableView == self.hintTableView) {
        if (0 == indexPath.section) {
            LCSearchPlaceThemeCell *themeCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCSearchPlaceThemeCell class]) forIndexPath:indexPath];
            [themeCell updateSearchPlaceThemeCell:self.hotThemeArr];
            themeCell.delegate = self;
            cell = themeCell;
        } else if (1 == indexPath.section) {
            LCSearchPlaceThemeCell *placeCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCSearchPlaceThemeCell class]) forIndexPath:indexPath];
            [placeCell updateSearchPlaceThemeCell:self.hotPlaceArr];
            placeCell.delegate = self;
            cell = placeCell;
        } else if (2 == indexPath.section) {
            LCPlaceSearchHistoryInfoCell *historyPlaceCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCPlaceSearchHistoryInfoCell class]) forIndexPath:indexPath];
            historyPlaceCell.historyPlaceLabel.text = [self.historyPlaceArray objectAtIndex:indexPath.row];
            cell = historyPlaceCell;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.hintTableView && 2 == indexPath.section) {//section0、1、2。2指的是搜索历史那一行
        [self hideKeyboard];
        NSString *placeName = (NSString *)[self.historyPlaceArray objectAtIndex:indexPath.row];
        [self showSearchResultView:placeName];
    }
    if (tableView == self.resultTableView) {
        LCPlanModel *model = nil;
        if (indexPath.section == 0) {
            model = [self.searchCostPlanResultArr objectAtIndex:indexPath.row - 1];
        } else if(indexPath.section == 1){
            model = [self.searchFreePlanResultArr objectAtIndex:indexPath.row - 1];
        }
        
        [LCViewSwitcher pushToShowPlanDetailVCForPlan:model recmdUuid:@"" on:self.navigationController];
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    CGFloat height = 0.0f;
//    if (tableView == self.resultTableView) {
//        if (indexPath.section == 0) {
//            if (indexPath.row == 0) {
//                height = 40.0f;
//            } else if (indexPath.row == self.searchCostPlanResultArr.count + 1){
//                height = 45.0f;
//            } else {
//                height = 289.0f;
//            }
//            
//        } else if (indexPath.section == 1){
//            if (indexPath.row == 0) {
//                height = 40.0f;
//            } else if (indexPath.row == self.searchFreePlanResultArr.count + 1){
//                height = 45.0f;
//            } else {
//                height = 363.0f;
//            }
//        }
//    } else if (tableView == self.hintTableView) {
//        if (0 == indexPath.section) {
//            return 120.0f;
//        } else if (1 == indexPath.section) {
//            return 120.0f;
//        } else if (2 == indexPath.section) {
//            return 40.0f;
//        }
//    }
//    return height;
//}

#pragma mark - UISearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self hideKeyboard];
    [self recordSearchHistory:searchBar.text];
    [self showSearchResultView:searchBar.text];
    
    /*if ([LCStringUtil isNotNullString:searchBar.text]) {
     
        if (self.searchType == LCSearchDestinationVCType_Plan) {
            [LCViewSwitcher pushToShowPlaceSearchResultForPlace:searchBar.text isDepart:NO on:self.navigationController];
        } else if (self.searchType == LCSearchDestinationVCType_Tourpic) {
            [self pushToTourpicTableVCWithPlaceName:searchBar.text];
        }
    }*/
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if (_searchCostPlanResultArr.count > 0 || _searchFreePlanResultArr.count > 0) {
        LCSharedFuncUtil *sharedInstance = [LCSharedFuncUtil sharedInstance];
        sharedInstance.delegate = self;
        UIView *grayView = [sharedInstance getGrayView];
        [self.view addSubview:grayView];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [[LCSharedFuncUtil sharedInstance] removeGrayViewfromSuperview];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    /// 实时搜索地点.
//    LCLogInfo(@"searchInfo %@",searchText);
//    
//    [LCNetRequester searchRelatedPlaceFor:searchText callBack:^(NSArray *placeArray, NSError *error) {
//        if (error) {
//            LCLogWarn(@"search related place error: %@",error);
//        } else {
//            self.searchResultArr = placeArray;
//            self.resultTableView.hidden = NO;
//            [self.resultTableView reloadData];
//        }
//    }];
//}

#pragma mark - UIScrollView Delegate


//固定头部视图
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
    CGFloat sectionFooterHeight = 45;
    CGFloat ButtomHeight = scrollView.contentSize.height - self.resultTableView.frame.size.height;//似乎有多个section就没治了。。
    if (ButtomHeight - sectionFooterHeight <= scrollView.contentOffset.y && scrollView.contentSize.height > 0) {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, -(sectionFooterHeight), 0);
    }
}


#pragma mark LCFooterCellForPushVCDelegate
-(void)pushVC:(LCSearchDestinationMoreVC *)vc {
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark LCSharedFuncUtilForGrayview
- (void)hideKeyboard {
    [self.searchBar resignFirstResponder];
    [self.view endEditing:YES];
}

//- (void)pushToPlanTableVCWithPlaceName:(NSString *)placeName {
//    if ([LCStringUtil isNotNullString:placeName]) {
//        LCPlanTableVC *planTableVC = [LCPlanTableVC createInstance];
//        planTableVC.showingType = LCPlanTableForSearchDestination;
//        planTableVC.placeName = placeName;
//        
//        [self.navigationController pushViewController:planTableVC animated:APP_ANIMATION];
//    }
//}
//
//- (void)pushToTourpicTableVCWithPlaceName:(NSString *)placeName{
//    if ([LCStringUtil isNotNullString:placeName]) {
//        [LCViewSwitcher pushToShowTourPicTableVCForKeyWord:placeName on:self.navigationController];
//    }
//}

@end

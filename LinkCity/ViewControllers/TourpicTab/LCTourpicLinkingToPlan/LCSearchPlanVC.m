//
//  LCSearchPlanVC.m
//  LinkCity
//
//  Created by 张宗硕 on 5/9/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCSearchPlanVC.h"
#import "LCCostPlanCell.h"
#import "LCBlankContentView.h"

@interface LCSearchPlanVC ()<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, UIScrollViewDelegate, LCCostPlanCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) NSArray *planArr;
@property (retain, nonatomic) LCSearchBar *searchBar;
@property (retain, nonatomic) NSArray *searchResultArr;
@property (strong, nonatomic) NSString *orderStr;
@property (assign, nonatomic) NSInteger choosedIndex;
@property (nonatomic, strong) LCBlankContentView *blankView;
@property (nonatomic, strong) UIView *spaLineView;

@end

@implementation LCSearchPlanVC

+ (instancetype)createInstance {
    return (LCSearchPlanVC *)[LCStoryboardManager viewControllerWithFileName:SBNameTourpicTab identifier:VCIDSearchPlan];
}

- (void)commonInit {
    [super commonInit];
    self.orderStr = @"";
    self.choosedIndex = -1;
    self.confirmButton.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    [self initSearchBar];
    [self initTableView];
    [self initBlankView];
    [self initSpaLineView];
     [self addObserveToNotificationNameToRefreshData:URL_FAVOR_PLAN];
}

- (void)initSpaLineView {
    _spaLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.confirmButton.width, 0.5f)];
    _spaLineView.backgroundColor = DefaultSpalineColor;
    [self.confirmButton addSubview:_spaLineView];
}

- (void)initBlankView {
    self.blankView = [[LCBlankContentView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-LCTabViewHeight) imageName:@"BlankContentNotFound" title:@"没有找到相关活动~\r\n换个关键词试试吧" marginTop:200.0f];
    [self.tableView insertSubview:self.blankView atIndex:0];
    self.blankView.hidden = YES;
}

- (void)initNavigationBar {
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonAction)];
    self.navigationItem.rightBarButtonItem = cancelBtn;
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 40;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
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
    self.searchBar.delegate = self;
    self.searchBar.text = @"";
    [self.searchBar setPlaceholder:@"搜索关联活动目的地"];
    self.searchBar.showsCancelButton = NO;
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(45.0f, 0.0f, (DEVICE_WIDTH - 45.0f * 3), 44.0f)];
    [searchView addSubview:self.searchBar];
    self.navigationItem.titleView = searchView;
}

- (void)cancelButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)checkSelected {
    if (self.selectedPlan != nil) {
        for (LCPlanModel *model in self.planArr) {
            if ([model.planGuid isEqualToString:self.selectedPlan.planGuid]) {
                
                self.choosedIndex = [self.planArr indexOfObject:model];
                self.selectedPlan = nil;
                break;
            }
        }
    }
}

- (void)refreshData {
    [self updateShow];
}

- (void)updateShow {
    [self.tableView reloadData];
    if (-1 != self.choosedIndex) {
        self.confirmButton.hidden = NO;
    } else {
        self.confirmButton.hidden = YES;
    }
}

- (void)footerRefreshAction {
    [self getTourpicSearchPlans];
}

- (void)getTourpicSearchPlans {
    [LCNetRequester getTourpicCostPlans:self.searchBar.text withOrderStr:self.orderStr callBack:^(NSArray *planArr, NSString *orderStr, NSError *error) {
        [self.tableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:self.orderStr]) {
                if (nil != planArr) {
                    self.planArr = [LCPlanModel addAndFiltDuplicateStagePlanArr:planArr toOriginalPlanArr:nil];
                } else {
                    self.planArr = [[NSArray alloc] init];
                }
            } else {
                if (nil != planArr && planArr.count > 0) {
                    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:self.planArr];
                    self.planArr = [LCPlanModel addAndFiltDuplicateStagePlanArr:planArr toOriginalPlanArr:mutArr];
                } else {
                    [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                }
            }
            self.orderStr = orderStr;
            
            [self checkSelected];
            if (self.planArr && self.planArr.count > 0) {
                self.blankView.hidden = YES;
            } else {
                self.blankView.hidden = NO;
            }
            [self updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.planArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCCostPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    LCPlanModel *plan = [self.planArr objectAtIndex:indexPath.row];
    cell.type = LCCostPlanCellViewType_Tourpic;
    if (-1 != self.choosedIndex && indexPath.row == self.choosedIndex) {
        cell.isChoosed = YES;
    } else {
        cell.isChoosed = NO;
    }
    [cell updateShowWithPlan:plan];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCPlanModel *plan = [self.planArr objectAtIndex:indexPath.row];
    [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:nil on:self.navigationController];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)chooseUpperRightButton:(LCCostPlanCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (cell.isChoosed) {
        self.choosedIndex = indexPath.row;
    } else {
        self.choosedIndex = -1;
    }
    [self updateShow];
}

#pragma mark - UISearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    
    self.orderStr = @"";
    if ([LCStringUtil isNotNullString:searchBar.text]) {
        [self getTourpicSearchPlans];
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

- (IBAction)confirmButtonAction:(id)sender {
    LCPlanModel *plan = nil;
    if (-1 != self.choosedIndex && self.choosedIndex < self.planArr.count) {
        plan = [self.planArr objectAtIndex:self.choosedIndex];
    }
    [self.navigationController popViewControllerAnimated:NO];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChoosePlanWithPlan:)]) {
        [self.delegate didChoosePlanWithPlan:plan];
    }
}


@end

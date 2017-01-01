//
//  LCUserTableVC.m
//  LinkCity
//
//  Created by roy on 3/27/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserTableVC.h"
#import "LCUserTableViewCell.h"
#import "LCUserTableViewCellHelper.h"

@interface LCUserTableVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,LCUserTableViewCellDelegate>
//Data
@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) NSMutableArray *filteredUserArray;
@property (nonatomic, strong) NSString *orderStr;


//UI
@property (nonatomic, strong) UISearchBar *searchBar;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation LCUserTableVC

+ (instancetype)createInstance{
    return (LCUserTableVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUser identifier:VCIDUserTableVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCUserTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCUserTableViewCell class])];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
    
    [self updateShow];
}

- (void)refreshData{
    [self.tableView headerBeginRefreshing];
}

- (void)updateShow{
    switch (self.showingType) {
        case LCUserTableVCType_FavoredUser:{
            if ([LCStringUtil isNotNullString:self.user.nick]) {
                self.title = [NSString stringWithFormat:@"%@关注的人",self.user.nick];
            }else{
                self.title = @"关注的人";
            }
            [self addSearchBarToTableView];
        }
            break;
        case LCUserTableVCType_Fans:{
            if ([LCStringUtil isNotNullString:self.user.nick]) {
                self.title = [NSString stringWithFormat:@"%@的粉丝",self.user.nick];
            }else{
                self.title = @"粉丝列表";
            }
            [self addSearchBarToTableView];
        }
            break;
        case LCUserTableVCType_Duckr:{
            self.title = self.placeName;
            [self removeSearchBarToTableView];
        }
    }
    
    [self.tableView reloadData];
}

- (void)addSearchBarToTableView{
    if (!self.searchBar) {
        //为通讯录添加搜索栏
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 10, DEVICE_WIDTH, LCSearchBarHeight)];
        self.searchBar.barTintColor = UIColorFromRGBA(LCSearchBarBgColor, 1);
        self.searchBar.placeholder = @"搜索";
        self.searchBar.delegate = self;
        self.searchBar.layer.borderColor = UIColorFromRGBA(LCSearchBarBgColor, 1).CGColor;
        self.searchBar.layer.borderWidth = 1;
    }
    self.tableView.tableHeaderView = self.searchBar;
}
- (void)removeSearchBarToTableView{
    self.tableView.tableHeaderView = nil;
}

#pragma mark Net
- (void)requestUserArrayFromOrderString:(NSString *)orderStr{
    switch (self.showingType) {
        case LCUserTableVCType_FavoredUser:{
            [LCNetRequester getFavoredUserOfUserUuid:self.user.uUID callBack:^(NSArray *userArray, NSError *error) {
                [self didGetUserArray:userArray orderStr:nil error:error];
            }];
        }
            break;
        case LCUserTableVCType_Fans:{
            [LCNetRequester getFansListOfUser:self.user.uUID orderStr:orderStr callBack:^(NSArray *userArray, NSString *orderStr, NSError *error) {
                [self didGetUserArray:userArray orderStr:orderStr error:error];
            }];
        }
            break;
        case LCUserTableVCType_Duckr:{
            [LCNetRequester getUserListByPlaceName:self.placeName orderStr:orderStr callBack:^(NSArray *userArray, NSString *orderStr, NSError *error) {
                [self didGetUserArray:userArray orderStr:orderStr error:error];
            }];
        }
    }
}
- (void)didGetUserArray:(NSArray *)userArray orderStr:(NSString *)orderStr error:(NSError *)error{
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    
    if (error) {
        [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
    }else{
        if ([LCStringUtil isNullString:self.orderStr]) {
            //下拉刷新
            self.userArray = [NSMutableArray arrayWithArray:userArray];
        }else{
            //上拉加载更多
            if (!userArray || userArray.count<=0) {
                [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            }else{
                if (!self.userArray) {
                    self.userArray = [[NSMutableArray alloc] initWithCapacity:0];
                }
                [self.userArray addObjectsFromArray:userArray];
            }
        }
        self.orderStr = orderStr;
    }
    
    self.filteredUserArray = [[NSMutableArray alloc] initWithArray:self.userArray];
    [self updateShow];
}

#pragma mark -
#pragma mark Refresh
- (void)headerRereshing{
    self.searchBar.text = nil;
    
    self.orderStr = nil;
    [self requestUserArrayFromOrderString:nil];
}

- (void)footerRereshing{
    self.searchBar.text = nil;
    
    if (self.showingType == LCUserTableVCType_FavoredUser) {
        //如果是我关注的人列表，不支持下拉刷新
        [self.tableView footerEndRefreshing];
        //恢复筛选为所有人
        self.filteredUserArray = [[NSMutableArray alloc] initWithArray:self.userArray];
        [self updateShow];
    }else{
        [self requestUserArrayFromOrderString:self.orderStr];
    }
}

- (void)userTableViewCellDidClickAvatarButton:(LCUserTableViewCell *)userCell {
    NSIndexPath *path = [self.tableView indexPathForCell:userCell];
    LCUserModel *user = [self.userArray objectAtIndex:path.row];
    [LCViewSwitcher pushToShowUserInfoVCForUser:user on:self.navigationController];
}

#pragma mark UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.filteredUserArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCUserModel *user = [self.filteredUserArray objectAtIndex:indexPath.row];
    LCUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCUserTableViewCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    [LCUserTableViewCellHelper setUserTalbeViewCell:cell shownAsUserTableViewCell:user];
    return cell;
}
#pragma mark TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [LCUserTableViewCell getCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LCUserModel *user = [self.filteredUserArray objectAtIndex:indexPath.row];
    [LCViewSwitcher pushToShowUserInfoVCForUser:user on:self.navigationController];
}


#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        [self.view endEditing:YES];
    }
}

#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;{
    if ([LCStringUtil isNullString:searchText]) {
        self.filteredUserArray = [[NSMutableArray alloc] initWithArray:self.userArray];
    }else{
        [self.filteredUserArray removeAllObjects];
        for (LCUserModel *user in self.userArray) {
            if (NSNotFound != [user.nick rangeOfString:searchText options:NSCaseInsensitiveSearch].location ||
                NSNotFound != [user.telephone rangeOfString:searchText options:NSCaseInsensitiveSearch].location) {
                
                [self.filteredUserArray addObject:user];
            }
        }
    }
    
    [self updateShow];
}


@end

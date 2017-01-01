//
//  LCDuckrUserListVC.m
//  LinkCity
//
//  Created by lhr on 16/5/17.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCDuckrUserListVC.h"
#import "LCHomeUserCell.h"
@interface LCDuckrUserListVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *orderString;

@property (strong, nonatomic) NSMutableArray *userList;

@end

@implementation LCDuckrUserListVC

+ (instancetype)createInstance {
        return (LCDuckrUserListVC *)[LCStoryboardManager viewControllerWithFileName:SBNameLocationPlanTab identifier:VCIDDuckrUserListVC];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    //self.title = @"关联活动";
   // [self tableViewHeaderRereshing];
    if (self.userList == nil) {
        self.userList = [[NSMutableArray alloc] init];
    }
    self.orderString = [[NSString alloc] init];
    [self.tableView headerBeginRefreshing];
   
    //self.radioButtonArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}

- (void)commonInit {
    [super commonInit];
    self.userList = [NSMutableArray arrayWithArray:[[LCDataManager sharedInstance] duckrBoardListArr]];
}
- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 130;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCHomeUserCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCHomeUserCell class])];
    [self.tableView addHeaderWithTarget:self action:@selector(tableViewHeaderRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(tableViewFooterRereshing)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableViewHeaderRereshing {
    //Result
    [self requestDataFromServer:nil];
    
    
}


- (void)tableViewFooterRereshing {
    [self requestDataFromServer:self.orderString];
    
}
- (void)requestDataFromServer:(NSString *)OrderString {
    self.orderString = OrderString;
    //NSString *uuid = [[LCDataManager sharedInstance].userInfo uUID];
    __weak typeof(self) weakSelf = self;

    [LCNetRequester getHomepageDuckrBroadList:self.orderString callBack:^(NSArray *userList, NSString *orderStr, NSError *error){
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain];
            return;
        }
        if (orderStr != nil) {
            weakSelf.userList = [NSMutableArray arrayWithArray:[LCSharedFuncUtil addFiltedArrayToArray:weakSelf.userList withUnfiltedArray:userList]];
        } else {
            [weakSelf.userList removeAllObjects];
            [weakSelf.userList addObjectsFromArray:userList];
        }
        weakSelf.orderString = orderStr;
        [weakSelf.tableView reloadData];
        [LCDataManager sharedInstance].duckrBoardListArr = weakSelf.userList;
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
    }];
}

- (void)refreshData {
    [self.tableView headerBeginRefreshing];
}

#pragma mark - TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //return nil;
    LCHomeUserCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCHomeUserCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.cellType =  LCHomeUserCellViewType_HomeDuckrBoard;
    LCUserModel * model = [self.userList objectAtIndex:indexPath.row];
    [cell updateShowCell:model withIndex:indexPath.row withType:cell.cellType];
    //[cell layoutSubviews];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
      [LCViewSwitcher pushToShowUserInfoVCForUser:self.userList[indexPath.row] on:[LCSharedFuncUtil getTopMostNavigationController]];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

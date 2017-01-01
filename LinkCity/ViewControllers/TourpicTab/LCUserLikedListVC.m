//
//  LCUserLikedListVC.m
//  LinkCity
//
//  Created by 张宗硕 on 3/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserLikedListVC.h"
#import "MJRefresh.h"
#import "LCUserTableViewCell.h"
#import "LCUserTableViewCellHelper.h"

@interface LCUserLikedListVC ()<UITableViewDataSource, UITableViewDelegate, LCUserTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSArray *likedArr;
@property (nonatomic, retain) NSString *orderStr;

@end

@implementation LCUserLikedListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initVariable];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self headerRefreshAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)createInstance {
    return (LCUserLikedListVC *)[LCStoryboardManager viewControllerWithFileName:SBNameTourpicTab identifier:VCIDTourpicLikedListVC];
}

- (void)initVariable {
    if (nil == self.tourpic) {
        self.likedArr = [[NSArray alloc] init];
    } else {
        self.likedArr = self.tourpic.likedArr;
    }
    
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollsToTop = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCUserTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCUserTableViewCell class])];
}

- (void)updateLikedUsers {
    if (self.plan) {
        [self getPlanLikedUsers];
        self.title = @"喜欢的人";
    } else {
        [self getTourpicLikedUsers];
        self.title = @"赞";
    }
}

- (void)headerRefreshAction {
    self.orderStr = @"";
    [self updateLikedUsers];
}

- (void)footerRefreshAction {
    [self updateLikedUsers];
}

- (void)getPlanLikedUsers {
    [LCNetRequester getPlanLikedList:self.plan.planGuid withOrderStr:self.orderStr callBack:^(NSArray *likedArr, NSString *orderStr, NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:self.orderStr]) {
                if (nil != likedArr) {
                    self.likedArr = likedArr;
                    [self.tableView reloadData];
                } else {
                    self.likedArr = [[NSArray alloc] init];
                }
            } else {
                if (nil != likedArr) {
                    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:self.likedArr];
                    [mutArr addObjectsFromArray:likedArr];
                    self.likedArr = mutArr;
                    [self.tableView reloadData];
                }
            }
            self.orderStr = orderStr;
        }
    }];
}

- (void)getTourpicLikedUsers {
    [LCNetRequester getTourpicLikedList:self.tourpic.guid withOrderStr:self.orderStr callBack:^(NSArray *likedArr, NSString *orderStr, NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:self.orderStr]) {
                if (nil != likedArr) {
                    self.likedArr = likedArr;
                    [self.tableView reloadData];
                } else {
                    self.likedArr = [[NSArray alloc] init];
                }
            } else {
                if (nil != likedArr) {
                    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:self.likedArr];
                    [mutArr addObjectsFromArray:likedArr];
                    self.likedArr = mutArr;
                    [self.tableView reloadData];
                }
            }
            self.orderStr = orderStr;
        }
    }];
}

#pragma mark LCUserDetailTableCellDelegate
- (void)userTableViewCellDidClickRightTopButton:(LCUserTableViewCell *)userCell{
    //推荐的人的列表Cell被点
    NSIndexPath *indexPath = [self.tableView indexPathForCell:userCell];
    __block LCUserModel *user = [self.likedArr objectAtIndex:indexPath.row];
    if (!user.isFavored) {
        [LCNetRequester followUser:@[user.uUID] callBack:^(NSError *error) {
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            }else{
                user.isFavored = 1;
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)userTableViewCellDidClickAvatarButton:(LCUserTableViewCell *)userCell {
    LCUserModel *model = userCell.user;
    if (nil != model && [LCStringUtil isNotNullString:model.uUID]) {
        [LCViewSwitcher pushToShowUserInfoVCForUser:model on:self.navigationController];
    }
}

#pragma mark UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCUserModel *recommendedUser = [self.likedArr objectAtIndex:indexPath.row];
    LCUserTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCUserTableViewCell class]) forIndexPath:indexPath];
    [LCUserTableViewCellHelper setUserTableViewCell:cell shownAsAddRecommendedFriendWithUser:recommendedUser];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCUserModel *userModel = [self.likedArr objectAtIndex:indexPath.row];
    [LCViewSwitcher pushToShowUserInfoVCForUser:userModel on:self.navigationController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LCUserTableViewCell getCellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.likedArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end

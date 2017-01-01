//
//  LCChatAddFriendSearchVC.m
//  LinkCity
//
//  Created by godhangyu on 16/6/6.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCChatAddFriendSearchVC.h"
#import "LCHomeUserCell.h"
#import "UIImage+Create.h"

@interface LCChatAddFriendSearchVC ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

// UI
@property (nonatomic, strong) LCSearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *resultTableView;
@property (weak, nonatomic) IBOutlet UIView *emptyContainer;

// Data
@property (strong, nonatomic) NSArray *resultArray;

@end

@implementation LCChatAddFriendSearchVC

+ (instancetype)createInstance {
    return (LCChatAddFriendSearchVC *)[LCStoryboardManager viewControllerWithFileName:SBNameChatTab identifier:VCIDChatAddFriendSearchVC];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    [self initSearchBar];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.isViewWillAppearCalledFirstTime) {
        [self.searchBar becomeFirstResponder];
    }
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[LCUIConstants sharedInstance].navBarOpaqueImage forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Common Init

- (void)initNavigationBar {
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonAction)];
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:17],NSFontAttributeName,
                                    UIColorFromRGBA(0x2c2a28, 1), NSForegroundColorAttributeName,
                                    nil];
    [cancelButton setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = cancelButton;
    [self.navigationItem setHidesBackButton:YES];
}

- (void)initSearchBar {
    self.searchBar = [[LCSearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, (DEVICE_WIDTH - 70.0f), 44.0f)];
    self.searchBar.delegate = self;
    self.searchBar.text = @"";
    [self.searchBar setPlaceholder:@"搜索用户昵称、手机号"];
    [self.searchBar setSearchTextFieldBackgroundColor:UIColorFromRGBA(0xf5f4f2, 1)];
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(45.0f, 0.0f, (DEVICE_WIDTH - 45.0f), 44.0f)];
    [searchView addSubview:self.searchBar];
    self.navigationItem.titleView = searchView;
}

- (void)initTableView {
    self.emptyContainer.hidden = YES;
    
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;
    self.resultTableView.rowHeight = UITableViewAutomaticDimension;
    self.resultTableView.estimatedRowHeight = 180.0f;
    [self.resultTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCHomeUserCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCHomeUserCell class])];
}

- (void)updateShow {
    if (self.resultArray) {
        _emptyContainer.hidden = YES;
        _resultTableView.hidden = NO;
        [_resultTableView reloadData];
    } else {
        _emptyContainer.hidden = NO;
        _resultTableView.hidden = YES;
    }
}

#pragma mark - Net Request

- (void)requestSearchResult {
    __weak typeof(self) weakSelf = self;
    
    [LCNetRequester searchUserByKeyWord:self.searchBar.text callBack:^(NSArray *userArray, NSError *error) {
        if (!error) {
            if (nil != userArray && userArray.count > 0) {
                weakSelf.resultArray = userArray;
            } else {
                weakSelf.resultArray = nil;
            }
        } else {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        }
        [weakSelf updateShow];
    }];
}


#pragma mark - Actions

- (void)cancelButtonAction {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCUserModel *user = [self.resultArray objectAtIndex:indexPath.row];
    LCHomeUserCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCHomeUserCell class]) forIndexPath:indexPath];
    [cell updateShowCell:user withType:LCHomeUserCellViewType_ChatAddFriendSearch];
    [cell updateChatAddFriendSearchLabelWithKeyWord:self.searchBar.text];
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:APP_ANIMATION];
    LCUserModel *user = [self.resultArray objectAtIndex:indexPath.row];
    [LCViewSwitcher pushToShowUserInfoVCForUser:user on:self.navigationController];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

#pragma mark - UISearchBar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self requestSearchResult];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

@end

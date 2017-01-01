//
//  LCWithWhoVC.m
//  LinkCity
//
//  Created by 张宗硕 on 3/23/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCWithWhoVC.h"
#import "LCWithWhoCell.h"
#import "UIImageView+AFNetworking.h"
#import "LCPhoneUtil.h"
#import "MJRefresh.h"

@interface LCWithWhoVC ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
/// 显示列表.
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/// 关注的人列表.
@property (retain, nonatomic) NSArray *favorUserArr;
/// 手机通讯录朋友列表.
@property (retain, nonatomic) NSArray *contactUserArr;

/// 搜索过滤后，对应的数据
@property (nonatomic, strong) NSMutableArray *filteredFavorUserArr;
@property (nonatomic, strong) NSMutableArray *filteredContactUserArr;

/// UI
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation LCWithWhoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 初始化变量.
    [self initVariable];
    /// 初始化列表
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (YES == self.isViewWillAppearCalledFirstTime) {
        [self loadFavorUserList];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)createInstance {
    return (LCWithWhoVC *)[LCStoryboardManager viewControllerWithFileName:SBNameTourpicTab identifier:VCIDWithWhoVC];
}

- (void)initVariable {
    self.favorUserArr = [[NSArray alloc] init];
    self.contactUserArr = [LCPhoneUtil getPhoneContactList];
    for (LCPhoneContactorModel *aPhoneContactor in self.contactUserArr){
        aPhoneContactor.isSelected = NO;
    }
}

- (void)initTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollsToTop = YES;
    self.favorUserArr = [LCDataManager sharedInstance].favorUserArr;
    
    //添加搜索栏
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 10, DEVICE_WIDTH, LCSearchBarHeight)];
    self.searchBar.barTintColor = UIColorFromRGBA(LCSearchBarBgColor, 1);
    self.searchBar.placeholder = @"搜索";
    self.searchBar.delegate = self;
    self.searchBar.layer.borderColor = UIColorFromRGBA(LCSearchBarBgColor, 1).CGColor;
    self.searchBar.layer.borderWidth = 1;
    self.tableView.tableHeaderView = self.searchBar;
}

- (void)loadFavorUserList {
    [YSAlertUtil showHudWithHint:@"获取关注的人..."];
    [LCNetRequester getFavoredUserOfUserUuid:nil callBack:^(NSArray *userArray, NSError *error) {
        if (error) {
            LCLogWarn(@"getFavoredUserOfChatContactWithOrderString error:%@",error);
        } else {
            self.favorUserArr = userArray;
            [LCDataManager sharedInstance].favorUserArr = userArray;
            
            for (LCUserModel *aUser in self.favorUserArr){
                aUser.isSelected = NO;
            }
            
            [self updateContactArr];
            
            self.filteredContactUserArr = [NSMutableArray arrayWithArray:self.contactUserArr];
            self.filteredFavorUserArr = [NSMutableArray arrayWithArray:self.favorUserArr];
            
            [YSAlertUtil hideHud];
            if (0 == self.filteredFavorUserArr.count && 0 == self.filteredContactUserArr.count) {
                if (0 == self.filteredFavorUserArr.count) {
                    [YSAlertUtil tipOneMessage:@"您还没有关注的人"];
                } else if (0 == self.filteredContactUserArr.count) {
                    [YSAlertUtil tipOneMessage:@"您还没有上传通讯录！"];
                }
            }
            [self.tableView reloadData];
        }
    }];
}

- (void)updateContactArr {
    NSMutableArray *contactMutArr = [[NSMutableArray alloc] initWithArray:self.contactUserArr];
    for (LCUserModel *user in self.favorUserArr) {
        NSInteger favoredUserIndex = [[contactMutArr valueForKeyPath:@"phone"] indexOfObject:user.telephone];
        if (favoredUserIndex != NSNotFound &&
            contactMutArr.count > favoredUserIndex) {
            
            [contactMutArr removeObjectAtIndex:favoredUserIndex];
        }
    }
    
    self.contactUserArr = [[NSArray alloc] initWithArray:contactMutArr];
}

#pragma mark Actions
- (IBAction)finishAction:(id)sender {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableArray *userArr = [[NSMutableArray alloc] init];
    NSMutableArray *contactArr = [[NSMutableArray alloc] init];
    for (LCUserModel *aUser in self.favorUserArr){
        if (aUser.isSelected) {
            [arr addObject:aUser];
            [userArr addObject:aUser];
        }
    }
    
    for (LCPhoneContactorModel *aPhoneContactor in self.contactUserArr) {
        if (aPhoneContactor.isSelected) {
            [arr addObject:aPhoneContactor];
            [contactArr addObject:aPhoneContactor];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseFinished:)]) {
        [self.delegate chooseFinished:arr];
    } else {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseFinishedWithSwiftChoosedUserArr:ContactArr:)]) {
        [self.delegate chooseFinishedWithSwiftChoosedUserArr:userArr ContactArr:contactArr];
    }
    [self.navigationController popViewControllerAnimated:APP_ANIMATION];
}


#pragma mark UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"WithWhoCell";
    LCWithWhoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[LCWithWhoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    [cell.checkboxButton setImage:[UIImage imageNamed:@"TourpicFavorUncheck"] forState:UIControlStateNormal];
    
    if (0 == indexPath.section) {
        LCUserModel *user = [self.filteredFavorUserArr objectAtIndex:indexPath.row];
        cell.nameLabel.text = user.nick;
        [cell.avatarImageView setImageWithURL:[NSURL URLWithString:user.avatarThumbUrl]];
        if (user.isSelected) {
            [cell.checkboxButton setImage:[UIImage imageNamed:@"TourpicFavorCheck"] forState:UIControlStateNormal];
        }
    } else {
        LCPhoneContactorModel *phoneContactor = [self.filteredContactUserArr objectAtIndex:indexPath.row];
        cell.nameLabel.text = phoneContactor.name;
        [cell.avatarImageView setImageWithURL:[NSURL URLWithString:phoneContactor.avatarUrl] placeholderImage:[UIImage imageNamed:@"DefaultAvatar"]];
        if (phoneContactor.isSelected) {
            [cell.checkboxButton setImage:[UIImage imageNamed:@"TourpicFavorCheck"] forState:UIControlStateNormal];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Change the selected background view of the cell.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == indexPath.section) {
        LCUserModel *user = [self.filteredFavorUserArr objectAtIndex:indexPath.row];
        user.isSelected = !user.isSelected;
    }else{
        LCPhoneContactorModel *phoneContactor = [self.filteredContactUserArr objectAtIndex:indexPath.row];
        phoneContactor.isSelected = !phoneContactor.isSelected;
    }
    
    [self updateFilterData];
    
    [tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return self.filteredFavorUserArr.count;
    }
    return self.filteredContactUserArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DEVICE_WIDTH, 22.0f)];
    [view setBackgroundColor:UIColorFromR_G_B_A(247, 245, 243, 1.0)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 3.0f, 100.0f, 16.0f)];
    label.textColor = UIColorFromR_G_B_A(168, 164, 160, 1.0);
    label.font = [UIFont fontWithName:APP_CHINESE_FONT size:13.0];
    if (0 == section) {
        label.text = @"关注的人";
    } else {
        label.text = @"通讯录好友";
    }
    [view addSubview:label];
    return view;
}


#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        [self.view endEditing:YES];
    }
}

#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self updateFilterData];
    [self.tableView reloadData];
}

- (void)updateFilterData{
    NSString *searchText = self.searchBar.text;
    
    if ([LCStringUtil isNullString:searchText]) {
        self.filteredContactUserArr = [NSMutableArray arrayWithArray:self.contactUserArr];
        self.filteredFavorUserArr = [NSMutableArray arrayWithArray:self.favorUserArr];
    }else{
        [self.filteredContactUserArr removeAllObjects];
        for (int i=0; i<self.contactUserArr.count; i++){
            LCPhoneContactorModel *aPhoneContactor = self.contactUserArr[i];
            if (NSNotFound != [aPhoneContactor.name rangeOfString:searchText options:NSCaseInsensitiveSearch].location ||
                NSNotFound != [aPhoneContactor.phone rangeOfString:searchText options:NSCaseInsensitiveSearch].location) {
                [self.filteredContactUserArr addObject:self.contactUserArr[i]];
            }
        }
        
        [self.filteredFavorUserArr removeAllObjects];
        for (int i=0; i<self.favorUserArr.count; i++){
            LCUserModel *aUser = self.favorUserArr[i];
            if (NSNotFound != [aUser.nick rangeOfString:searchText options:NSCaseInsensitiveSearch].location ||
                NSNotFound != [aUser.nick rangeOfString:searchText options:NSCaseInsensitiveSearch].location) {
                [self.filteredFavorUserArr addObject:self.favorUserArr[i]];
            }
        }
    }
}

@end

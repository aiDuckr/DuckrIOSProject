//
//  LCRecommendUserVC.m
//  LinkCity
//
//  Created by roy on 3/30/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCRecommendUserVC.h"
#import "LCUserTableViewCell.h"
#import "LCUserTableViewCellHelper.h"

@interface LCRecommendUserVC ()<UITableViewDataSource,UITableViewDelegate,LCUserTableViewCellDelegate>
@property (nonatomic, strong) NSArray *recommendUserArray;  //array of LCUserModel
@property (nonatomic, strong) NSMutableArray *selectionArray;  //array of NSNumber of Bool

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *favorAllButton;
@end

@implementation LCRecommendUserVC

+ (instancetype)createInstance{
    return (LCRecommendUserVC *)[LCStoryboardManager viewControllerWithFileName:SBNameRecommendUser identifier:VCIDRecommendUser];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推荐关注";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCUserTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCUserTableViewCell class])];
    
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarButtonAction)];
    self.navigationItem.rightBarButtonItem = cancelBarButton;
    
    [[LCUIConstants sharedInstance] setButtonAsSubmitButtonEnableStyle:self.favorAllButton];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    if (self.tabBarController && self.tabBarController.tabBar) {
        self.tabBarController.tabBar.hidden = YES;
    }
    
    [self updateShow];
}

- (void)refreshData{
    [LCNetRequester getRecommendedUserListWithCallBack:^(NSArray *userArray, NSError *error) {
        if (error) {
            LCLogWarn(@"getRecommendedUserListWithCallBack error:%@",error);
        }else{
            self.recommendUserArray = userArray;
            self.selectionArray = [[NSMutableArray alloc] initWithCapacity:userArray.count];
            //默认全部选中的状态
            for (int i=0; i<userArray.count; i++){
                [self.selectionArray addObject:[NSNumber numberWithBool:YES]];
            }
            
            [self updateShow];
        }
    }];
}

- (void)updateShow{
    [self.tableView reloadData];
}


- (void)cancelBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)favorAllButtonAction:(id)sender {
    
    NSMutableArray *userUUIDArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<self.selectionArray.count; i++){
        NSNumber *selection = [self.selectionArray objectAtIndex:i];
        if ([selection boolValue]) {
            LCUserModel *selectedUser = [self.recommendUserArray objectAtIndex:i];
            [userUUIDArray addObject:selectedUser.uUID];
        }
    }
    
    if (userUUIDArray.count <= 0) {
        [YSAlertUtil tipOneMessage:@"请选择要关注的用户" yoffset:TipDefaultYoffset delay:TipErrorDelay];
    }else{
        [YSAlertUtil showHudWithHint:nil];
        [LCNetRequester followUser:userUUIDArray callBack:^(NSError *error) {
            [YSAlertUtil hideHud];
            
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recommendUserArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [LCUserTableViewCell getCellHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCUserTableViewCell *userCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCUserTableViewCell class]) forIndexPath:indexPath];
    userCell.selectionStyle = UITableViewCellSelectionStyleNone;
    userCell.delegate = self;
    LCUserModel *user = [self.recommendUserArray objectAtIndex:indexPath.row];
    [LCUserTableViewCellHelper setUserTableViewCell:userCell shownAsRecommendUserWhenRegister:user];
    NSNumber *selected = [self.selectionArray objectAtIndex:indexPath.row];
    [LCUserTableViewCellHelper setUserTableViewCell:userCell shownAsRecommendUserWhenRegisterSelected:[selected boolValue]];
    
    return userCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSNumber *formerSelection = [self.selectionArray objectAtIndex:indexPath.row];
    NSNumber *curSelection = [NSNumber numberWithBool:![formerSelection boolValue]];
    [self.selectionArray replaceObjectAtIndex:indexPath.row withObject:curSelection];
    
    LCUserTableViewCell *userCell = (LCUserTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [LCUserTableViewCellHelper setUserTableViewCell:userCell shownAsRecommendUserWhenRegisterSelected:[curSelection boolValue]];
}


#pragma mark LCUserTableViewCell Delegate
- (void)userTableViewCellDidClickAvatarButton:(LCUserTableViewCell *)userCell{
    if (userCell.user && [LCStringUtil isNotNullString:userCell.user.uUID]) {
        [LCViewSwitcher pushToShowUserInfoVCForUser:userCell.user on:self.navigationController];
    }
}


@end

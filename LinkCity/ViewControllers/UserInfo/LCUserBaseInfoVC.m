//
//  LCUserBaseInfoVC.m
//  LinkCity
//
//  Created by Roy on 8/28/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCUserBaseInfoVC.h"
#import "LCUserInfoBaseInfoCell.h"
#import "LCUserEvaluationTitleCell.h"
#import "LCEditUserInfoVC.h"

@interface LCUserBaseInfoVC ()<UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong) UIBarButtonItem *rightBarEditButton;

@end

@implementation LCUserBaseInfoVC

+ (instancetype)createInstance{
    return (LCUserBaseInfoVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUser identifier:NSStringFromClass([LCUserBaseInfoVC class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.rightBarEditButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editButtonAction:)];
    self.navigationItem.rightBarButtonItem = self.rightBarEditButton;
    
    self.title = @"个人信息";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.masksToBounds = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCUserInfoBaseInfoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCUserInfoBaseInfoCell class])];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Init navigationBar appearance
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    [self updateShow];
}

- (void)updateShow{
    [self.tableView reloadData];
}

#pragma mark ButtonAction
- (void)editButtonAction:(id)sender{
    LCEditUserInfoVC *editUserVC = [LCEditUserInfoVC createInstance];
    editUserVC.editingUser = self.user;
    [self.navigationController pushViewController:editUserVC animated:YES];
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        LCUserInfoBaseInfoCell *baseInfoCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCUserInfoBaseInfoCell class]) forIndexPath:indexPath];
        [baseInfoCell updateShowWithUser:self.user showBottomGap:YES];
        baseInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = baseInfoCell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = 0;
    
    if (indexPath.row == 0) {
        rowHeight = [LCUserInfoBaseInfoCell getCellHeightForUser:self.user showBottomGap:YES];
    }
    
    return rowHeight;
}

@end

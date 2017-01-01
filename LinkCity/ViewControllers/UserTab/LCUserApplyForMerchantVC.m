//
//  LCUserApplyForMerchantVC.m
//  LinkCity
//
//  Created by godhangyu on 16/6/29.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCUserApplyForMerchantVC.h"
#import "LCUserApplyForMerchantCell.h"
#import "LCMerchantIdentifyVC.h"

@interface LCUserApplyForMerchantVC ()<UITableViewDelegate, UITableViewDataSource>

// UI
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Data
@property (strong, nonatomic) NSArray *tableArray;

@end

@implementation LCUserApplyForMerchantVC

+ (instancetype)createInstance {
    return (LCUserApplyForMerchantVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDUserApplyForMerchantVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTableView];
}

#pragma mark - Common Init

- (void)initTableView {
    self.tableArray = @[@"旅行社/俱乐部", @"导游/领队", @"本地娱乐活动服务商"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.estimatedRowHeight = 45.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCUserApplyForMerchantCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCUserApplyForMerchantCell class])];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCUserApplyForMerchantCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCUserApplyForMerchantCell class]) forIndexPath:indexPath];
    if (indexPath.row != ([tableView numberOfRowsInSection:indexPath.section] - 1)) {
        [cell updateCell:[self.tableArray objectAtIndex:indexPath.row] isHaveSeparateLine:YES];
    } else {
        [cell updateCell:[self.tableArray objectAtIndex:indexPath.row] isHaveSeparateLine:NO];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCMerchantIdentifyVC *merchantIdentifyVC = [LCMerchantIdentifyVC createInstance];
    switch (indexPath.row) {
        case 0:
            merchantIdentifyVC.vcType = LCMerchantIdentifyType_TravelAgency;
            break;
        case 1:
            merchantIdentifyVC.vcType = LCMerchantIdentifyType_Guide;
            break;
        case 2:
            merchantIdentifyVC.vcType = LCMerchantIdentifyType_LocalEntertainment;
    }
    
    [self.navigationController pushViewController:merchantIdentifyVC animated:YES];
}


@end

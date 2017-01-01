//
//  LCCityPickerVC.m
//  LinkCity
//
//  Created by 张宗硕 on 05/20/16.
//  Copyright (c) 2016 linkcity. All rights reserved.
//

#import "LCCityPickerVC.h"
#import "LCStoryboardManager.h"
#import "LCCityModel.h"

#define CityPickerCellID @"CityPickerCell"
@interface LCCityPickerVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *contentArr;

@end

@implementation LCCityPickerVC
+ (instancetype)createInstance {
    return (LCCityPickerVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUser identifier:VCIDCityPickerVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择城市";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    
    self.contentArr = [[NSArray alloc] init];
    if (self.contentArr.count > 0) {
        [self headerRefreshAction];
    } else {
        [self.tableView headerBeginRefreshing];
    }
}

- (void)updateShow {
    [self.tableView reloadData];
}

#pragma mark - Server Request.
/// 下拉刷新.
- (void)headerRefreshAction {
    [self requestProvinces];
}

- (void)requestProvinces {
    [LCNetRequester getCitysByProvinceID:self.province.provinceID callBack:^(NSArray *contentArr, NSError *error) {
        [self.tableView headerEndRefreshing];
        if (nil == error) {
            self.contentArr = contentArr;
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
        [self updateShow];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - UITableView Delegate.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CityPickerCellID];
    LCCityModel *city = [self.contentArr objectAtIndex:indexPath.row];
    cell.textLabel.text = city.cityShortName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:NO];
    LCCityModel *city = [self.contentArr objectAtIndex:indexPath.row];
    if ([LCStringUtil isNotNullString:city.cityName] && self.delegate && [self.delegate respondsToSelector:@selector(cityPrcker:didSelectProvince:didSelectCity:)]) {
        [self.delegate cityPrcker:self didSelectProvince:self.province.provniceName didSelectCity:city];
    }
    
}
@end

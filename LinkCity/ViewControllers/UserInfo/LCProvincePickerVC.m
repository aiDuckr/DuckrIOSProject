//
//  LCProvincePickerVC.m
//  LinkCity
//
//  Created by 张宗硕 on 05/20/16.
//  Copyright (c) 2016 linkcity. All rights reserved.
//

#import "LCProvincePickerVC.h"
#import "LCLocationManager.h"
#import "LCStoryboardManager.h"
#import "LCCityPickerVC.h"
#import "LCProvinceModel.h"

#define ProvincePickerCellID @"ProvincePickerCell"

@interface LCProvincePickerVC ()<UITableViewDataSource,UITableViewDelegate, LCCityPickerVCDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *hotCityArr;
@property (strong, nonatomic) NSArray *provinceArr;
@property (nonatomic,strong) NSArray *locations;

@end

@implementation LCProvincePickerVC

+ (instancetype)createInstance {
    return (LCProvincePickerVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUser identifier:VCIDProvincePickerVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择城市";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    
    self.provinceArr = [LCDataManager sharedInstance].provinceArr;
    self.hotCityArr = [LCDataManager sharedInstance].hotCityArr;
    if (self.provinceArr.count > 0) {
        [self headerRefreshAction];
    } else {
        [self.tableView headerBeginRefreshing];
    }
}

- (void)updateShow {
    [LCDataManager sharedInstance].provinceArr = self.provinceArr;
    [LCDataManager sharedInstance].hotCityArr = self.hotCityArr;
    [self.tableView reloadData];
}

#pragma mark - Server Request.
/// 下拉刷新.
- (void)headerRefreshAction {
    [self requestProvinces];
}

- (void)requestProvinces {
    [LCNetRequester getHotCitysAndProvincesWithCallBack:^(NSArray *provinceArr, NSArray *hotCityArr, NSError *error) {
        [self.tableView headerEndRefreshing];
        if (nil == error) {
            self.provinceArr = provinceArr;
            self.hotCityArr = hotCityArr;
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

- (void)provincePicker:(LCProvincePickerVC *)provincePickerVC didSelectProvince:(NSString *)provinceName didSelectCity:(LCCityModel *)city {
    if (self.delegate && [self.delegate respondsToSelector:@selector(provincePicker:didSelectProvince:didSelectCity:)]) {
        [self.delegate provincePicker:self didSelectProvince:provinceName didSelectCity:city];
    }
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UITableView Delegate.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isChosingLocalCity) {
        return 3;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_isChosingLocalCity) {
        if (0 == section) {
            return @"当前定位";
        } else if (1 == section) {
            return @"热门城市";
        } else {
            return @"全国省份";
        }
    } else {
        if (0 == section) {
            return @"当前定位";
        } else {
            return @"全国省份";
        }
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isChosingLocalCity) {
        if (0 == section) {
            return 1;
        } else if (1 == section) {
            return self.hotCityArr.count;
        } else {
            return self.provinceArr.count;
        }
    } else {
        if (0 == section) {
            return 1;
        } else {
            return self.provinceArr.count;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProvincePickerCellID];
    
    if (_isChosingLocalCity) {
        if (0 == indexPath.section) {
            cell.textLabel.text = [LCDataManager sharedInstance].locationCity.cityShortName;
        } else if (1 == indexPath.section) {
            LCCityModel *hotCity = [self.hotCityArr objectAtIndex:indexPath.row];
            cell.textLabel.text = hotCity.cityShortName;
        } else {
            LCProvinceModel *province = [self.provinceArr objectAtIndex:indexPath.row];
            cell.textLabel.text = province.provniceName;
        }
    } else {
        if (0 == indexPath.section) {
            cell.textLabel.text = [LCDataManager sharedInstance].locationCity.cityShortName;
        } else {
            LCProvinceModel *province = [self.provinceArr objectAtIndex:indexPath.row];
            cell.textLabel.text = province.provniceName;
        }
    }


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_isChosingLocalCity) {
        if (0 == indexPath.section) {
            LCCityModel *currentCity = [LCDataManager sharedInstance].locationCity;
            if (self.delegate && [self.delegate respondsToSelector:@selector(provincePicker:didSelectProvince:didSelectCity:)]) {
                [self provincePicker:self didSelectProvince:currentCity.cityName didSelectCity:currentCity];
            }
        } else if (1 == indexPath.section) {
            LCCityModel *hotCity = [self.hotCityArr objectAtIndex:indexPath.row];
            if (self.delegate && [self.delegate respondsToSelector:@selector(provincePicker:didSelectProvince:didSelectCity:)]) {
                [self provincePicker:self didSelectProvince:hotCity.cityName didSelectCity:hotCity];
            }
        } else {
            LCProvinceModel *province = [self.provinceArr objectAtIndex:indexPath.row];
            if (nil != province.city && [LCStringUtil isNotNullString:province.city.cityName]) {
                // 没有二级地点，直接使用省、直辖市名
                if (self.delegate && [self.delegate respondsToSelector:@selector(provincePicker:didSelectProvince:didSelectCity:)]) {
                    [self provincePicker:self didSelectProvince:province.provniceName didSelectCity:province.city];
                }
            } else {
                // 显示城市列表
                LCCityPickerVC *cp = [LCCityPickerVC createInstance];
                cp.province = province;
                cp.delegate = self;
                [self.navigationController pushViewController:cp animated:YES];
            }
        }
    } else {
        if (0 == indexPath.section) {
            LCCityModel *currentCity = [LCDataManager sharedInstance].locationCity;
            if (self.delegate && [self.delegate respondsToSelector:@selector(provincePicker:didSelectProvince:didSelectCity:)]) {
                [self provincePicker:self didSelectProvince:currentCity.cityName didSelectCity:currentCity];
            }
        } else {
            LCProvinceModel *province = [self.provinceArr objectAtIndex:indexPath.row];
            if (nil != province.city && [LCStringUtil isNotNullString:province.city.cityName]) {
                // 没有二级地点，直接使用省、直辖市名
                if (self.delegate && [self.delegate respondsToSelector:@selector(provincePicker:didSelectProvince:didSelectCity:)]) {
                    [self provincePicker:self didSelectProvince:province.provniceName didSelectCity:province.city];
                }
            } else {
                // 显示城市列表
                LCCityPickerVC *cp = [LCCityPickerVC createInstance];
                cp.province = province;
                cp.delegate = self;
                [self.navigationController pushViewController:cp animated:YES];
            }
        }
    }
    


}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return self.provinceArr;
//}

#pragma mark - LCCityPickerVC Delegate.
- (void)cityPrcker:(LCCityPickerVC *)provincePickerVC didSelectProvince:(NSString *)provinceName didSelectCity:(LCCityModel *)city {
    [self provincePicker:self didSelectProvince:provinceName didSelectCity:city];
}
@end

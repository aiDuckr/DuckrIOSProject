//
//  LCLocationPickerVC.m
//  LinkCity
//
//  Created by roy on 11/29/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCProvincePickerVC.h"
#import "LCLocationManager.h"
#import "LCStoryboardManager.h"
#import "LCCityPicker.h"

#define ProvincePickerCellID @"ProvincePickerCell"
@interface LCProvincePickerVC ()<UITableViewDataSource,UITableViewDelegate,LCCityPickerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic,strong) NSArray *locations;
@end

@implementation LCProvincePickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.title = @"常在地";
    
    self.locations = [LCLocationManager getLocationsFromPlist];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+ (instancetype)createInstance{
    return (LCProvincePickerVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserinfo identifier:VCIDProvincePickerVC];
}
#pragma mark - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProvincePickerCellID];
    NSString *provinceName = [LCLocationManager getProvinceNameFromLocations:self.locations atIndex:indexPath.row];
    cell.textLabel.text = provinceName;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndexPath = indexPath;
    NSArray *cities = [LCLocationManager getCityArrayFromLocations:self.locations atIndex:indexPath.row];
    if (!cities || cities.count<=0) {
        //没有二级地点，直接使用省、直辖市名
        NSString *provinceName = [LCLocationManager getProvinceNameFromLocations:self.locations atIndex:indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(provincePrcker:didSelectCity:)]) {
            [self.delegate provincePrcker:self didSelectCity:provinceName];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        //显示城市列表
        LCCityPicker *cp = [LCCityPicker createInstance];
        cp.delegate = self;
        cp.cities = cities;
        [self.navigationController pushViewController:cp animated:YES];
    }
}

#pragma mark - LCCityPicker Delegate
- (void)cityPicker:(LCCityPicker *)cityPicker didSelectCity:(NSString *)cityName{
    if (self.delegate && [self.delegate respondsToSelector:@selector(provincePrcker:didSelectCity:)]) {
        NSString *provinceName = [LCLocationManager getProvinceNameFromLocations:self.locations atIndex:self.selectedIndexPath.row];
        [self.delegate provincePrcker:self didSelectCity:[NSString stringWithFormat:@"%@%@%@",provinceName,LOCATION_CITY_SEPARATER,cityName]];
    }
}
@end

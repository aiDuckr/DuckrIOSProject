//
//  LCAllCountryCityVC.m
//  LinkCity
//
//  Created by Roy on 12/17/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCAllCountryCityVC.h"
#import "LCLocationManager.h"

@interface LCAllCountryCityVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *cityDicArray;
@end

@implementation LCAllCountryCityVC

+ (instancetype)createInstance{
    return [[LCAllCountryCityVC alloc] initWithNibName:NSStringFromClass([LCAllCountryCityVC class]) bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:LCNavBarBackBarButtonImageName] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonAction)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    self.title = @"选择城市";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 40;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"defaultcell"];
    
}

#pragma mark Button Action
- (void)backBarButtonAction{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.alphaArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *cityArray = [self.arrayOfCityArray objectAtIndex:section];
    return cityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *cityArray = [self.arrayOfCityArray objectAtIndex:indexPath.section];
    NSDictionary *city = [cityArray objectAtIndex:indexPath.row];
    NSString *cityName = [city objectForKey:@"name"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultcell" forIndexPath:indexPath];
    cell.textLabel.text = cityName;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.alphaArray objectAtIndex:section];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.alphaArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *cityArray = [self.arrayOfCityArray objectAtIndex:indexPath.section];
    NSDictionary *city = [cityArray objectAtIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(allCountryCityVC:didSelectCityDic:)]) {
        [self.delegate allCountryCityVC:self didSelectCityDic:city];
    }
}





@end

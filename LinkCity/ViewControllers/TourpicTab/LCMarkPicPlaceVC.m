//
//  LCMarkPicPlaceVC.m
//  LinkCity
//
//  Created by 张宗硕 on 3/23/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCMarkPicPlaceVC.h"
#import "BMapKit.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "LCPoiPlaceCell.h"
#import "LCDialogInputter.h"
#import "LCChatSectionHeaderView.h"

@interface LCMarkPicPlaceVC ()<BMKPoiSearchDelegate, UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) BMKPoiSearch *searcher;
@property (retain, nonatomic) NSArray* poiInfoList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LCMarkPicPlaceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 初始化变量
    [self initVariable];
    /// 初始化附近景点查询.
    [self initPoiSearch];
    /// 初始化列表.
    [self initTableView];
}

/// 不使用时将delegate设置为nil.
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _searcher.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable {
    self.poiInfoList = [[NSArray alloc] init];
}

+ (instancetype)createInstance {
    return (LCMarkPicPlaceVC *)[LCStoryboardManager viewControllerWithFileName:SBNameTourpicTab identifier:VCIDMarkPicPlaceVC];
}

- (void)initPoiSearch {
    //初始化检索对象
    _searcher =[[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 50;
    CLLocationCoordinate2D coordinate = {[LCDataManager sharedInstance].userLocation.lat, [LCDataManager sharedInstance].userLocation.lng};
    option.location = coordinate;
    option.keyword = @"旅游景点";
    [YSAlertUtil showHudWithHint:@"获取附近地点..."];
    BOOL flag = [_searcher poiSearchNearBy:option];
    
    if(flag) {
        ZLog(@"周边检索发送成功");
    } else {
        ZLog(@"周边检索发送失败");
    }
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollsToTop = YES;
}

#pragma mark Actions
- (IBAction)customPlaceAction:(id)sender {
    [[LCDialogInputter sharedInstance] showInputterWithDefaultText:@"" placeHolder:@"请输入照片拍照地点" title:@"自定义地点" completion:^(NSString *destination) {
        [[LCDataManager sharedInstance] addLatestTourpicPlaceName:destination];
        [self.delegate choosePlaceName:destination];
        [self.navigationController popViewControllerAnimated:APP_ANIMATION];
    }];
}


#pragma mark BMKPoiSearch Delegate
/// 实现PoiSearchDeleage处理回调结果.
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error {
    [YSAlertUtil hideHud];
    if (error == BMK_SEARCH_NO_ERROR) {
        ZLog(@"get map location....");
        self.poiInfoList = poiResultList.poiInfoList;
        [self.tableView reloadData];
        //在此处理正常结果
    } else {
        [YSAlertUtil tipOneMessage:@"附近没有景点，请添加景点！"];
    }
}


#pragma mark UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PoiPlaceCell";
    LCPoiPlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[LCPoiPlaceCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    if ([LCDataManager sharedInstance].latestTourpicPlaceNameArr.count > 0 &&
        indexPath.section == 0) {
        // latest used place name
        if ([LCDataManager sharedInstance].latestTourpicPlaceNameArr.count > indexPath.row) {
            cell.poiName.text = [[LCDataManager sharedInstance].latestTourpicPlaceNameArr objectAtIndex:indexPath.row];
            cell.poiAddress.text = @"";
        }
    }else{
        // gps place
        BMKPoiInfo *poiInfo = [self.poiInfoList objectAtIndex:indexPath.row];
        cell.poiName.text = poiInfo.name;
        cell.poiAddress.text = poiInfo.address;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name = @"";
    
    if ([LCDataManager sharedInstance].latestTourpicPlaceNameArr.count > 0 &&
        indexPath.section == 0 ) {
        //latest used place name
        name = [[LCDataManager sharedInstance].latestTourpicPlaceNameArr objectAtIndex:indexPath.row];
    }else{
        //gps place
        BMKPoiInfo *poiInfo = [self.poiInfoList objectAtIndex:indexPath.row];
        name = poiInfo.name;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(choosePlaceName:)]) {
        [[LCDataManager sharedInstance] addLatestTourpicPlaceName:name];
        [self.delegate choosePlaceName:name];
        [self.navigationController popViewControllerAnimated:APP_ANIMATION];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNum = 0;
    
    if ([LCDataManager sharedInstance].latestTourpicPlaceNameArr.count > 0 &&
        section == 0) {
        // latest used place
        rowNum = [LCDataManager sharedInstance].latestTourpicPlaceNameArr.count;
    }else{
        // gps place
        rowNum = self.poiInfoList.count;
    }
    
    return rowNum;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sectionNum = 0;
    
    if ([LCDataManager sharedInstance].latestTourpicPlaceNameArr.count > 0) {
        sectionNum = 2;
    }else{
        sectionNum = 1;
    }
    
    return sectionNum;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCChatSectionHeaderView class]) bundle:nil];
    LCChatSectionHeaderView *sectionView = [[nib instantiateWithOwner:nil options:0] firstObject];
    sectionView.rightLabel.hidden = YES;
    
    if ([LCDataManager sharedInstance].latestTourpicPlaceNameArr.count > 0 &&
        section == 0) {
        //latest used place name
        sectionView.leftLabel.text = @"最近使用的位置";
    }else{
        // gps place
        sectionView.leftLabel.text = @"定位位置";
    }
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    height = [LCChatSectionHeaderView getHeaderViewHeight];
    return height;
}

@end

//
//  LCAddPlacesVC.m
//  LinkCity
//
//  Created by 张宗硕 on 11/12/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCAddPlacesVC.h"
#import "LCXMPPUtil.h"

@interface LCAddPlacesVC ()<UITableViewDelegate, UITableViewDataSource, LCAddOnePlaceVCDelegate, LCReceptionApiDelegate> {
    LCReceptionPlan *receptionPlan;
    NSMutableArray *routeList;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewConstraint;
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;
@property (weak, nonatomic) IBOutlet UIImageView *recommandImageView;
@property (nonatomic, retain) LCRouteInfo *routeInfo;
@end

@implementation LCAddPlacesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 初始化变量.
    [self initVariable];
    /// 初始化导航栏按钮.
//    [self initButtonItem];
    /// 初始化列表控件.
    [self initTableView];
    /// 更新经典列表控件高度显示.
    [self updateTableViewCellNumber];
    /// 初始化发布按钮.
    [self initPublishBtn];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

/// 初始化变量.
- (void)initVariable {
    receptionPlan = [LCDataManager sharedInstance].receptionPlan;
    routeList = [[NSMutableArray alloc] initWithArray:receptionPlan.routes];
}

/// 初始化导航栏按钮.
- (void)initButtonItem {
    /// 使用资源原图片.
    UIImage *backImage = [[UIImage imageNamed:@"NavigationBackBG"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.backButtonItem setImage:backImage];
}

/// 初始化发布按钮.
- (void)initPublishBtn {
    self.publishBtn.layer.borderWidth = 0.5f;
    self.publishBtn.layer.borderColor = [UIColorFromRGBA(APP_COLOR, 1.0f) CGColor];
}

/// 初始化列表控件.
- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    routeList = [[NSMutableArray alloc] init];
    if ([LCStringUtil isNotNullString:receptionPlan.routes]) {
        routeList = [[NSMutableArray alloc] initWithArray:receptionPlan.routes];
    }
}

/// 更新经典列表控件高度显示.
- (void)updateTableViewCellNumber {
    CGFloat maxHeight = DEVICE_HEIGHT - APP_NAVIGATION_HEIGHT - APP_NAVIGATION_STATUS_HEIGHT - 47.0f - 57.0f + 5.0f;
    NSInteger number = maxHeight / 105.0f;
    if (number <= routeList.count) {
        self.tableViewConstraint.constant = number * 105.0f;
    } else {
        self.tableViewConstraint.constant = routeList.count * 105.0f;
    }
}

#pragma mark - Actions
/// 添加景点.
- (IBAction)addPlaceAction:(id)sender {
    LCAddOnePlaceVC *controller = (LCAddOnePlaceVC *)[LCStoryboardManager viewControllerWithFileName:SBNameReceptionPlan identifier:VCIDAddOnePlace];
    controller.delegate = self;
    controller.modiRouteInfo = nil;
    [self.navigationController pushViewController:controller animated:APP_ANIMATION];
}

/// 发布招待计划.
- (IBAction)publishAction:(id)sender {
    NSMutableDictionary *planDic = [[NSMutableDictionary alloc] init];
    [planDic setValue:[LCStringUtil getNotNullStr:receptionPlan.destinationId] forKey:@"DestinationId"];
    [planDic setValue:[LCStringUtil getNotNullStr:receptionPlan.destinationName] forKey:@"DestinationName"];
    [planDic setValue:[LCStringUtil getNotNullStr:receptionPlan.declaration] forKey:@"Declaration"];
    [planDic setValue:[LCStringUtil getNotNullStr:receptionPlan.descriptionStr] forKey:@"Description"];
    [planDic setObject:[LCStringUtil getNotNullStr:receptionPlan.startTime] forKey:@"StartTime"];
    [planDic setObject:[LCStringUtil getNotNullStr:receptionPlan.endTime] forKey:@"EndTime"];
    [planDic setValue:[NSString stringWithFormat:@"%ld", (long)receptionPlan.scaleMax] forKey:@"ScaleMax"];
    [planDic setValue:[NSString stringWithFormat:@"%ld", (long)receptionPlan.serviceAccompany] forKey:@"ServiceAccompany"];
    [planDic setValue:[NSString stringWithFormat:@"%ld", (long)receptionPlan.serviceDinner] forKey:@"ServiceDinner"];
    [planDic setValue:[NSString stringWithFormat:@"%ld", (long)receptionPlan.serviceHotel] forKey:@"ServiceHotel"];
    [planDic setValue:[NSString stringWithFormat:@"%ld", (long)receptionPlan.serviceCar] forKey:@"ServiceCar"];
    [planDic setValue:[LCStringUtil getNotNullStr:receptionPlan.serviceDesc] forKey:@"ServiceDesc"];
    [planDic setObject:[LCStringUtil getNotNullStr:receptionPlan.imageCover] forKey:@"ImageCover"];
    [planDic setObject:[LCStringUtil getNotNullStr:receptionPlan.coverColor] forKey:@"CoverColor"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (LCRouteInfo *info in routeList) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[LCStringUtil getNotNullStr:info.placeId] forKey:@"PlaceId"];
        [dic setObject:[LCStringUtil getNotNullStr:info.placeName] forKey:@"PlaceName"];
        [dic setObject:[LCStringUtil getNotNullStr:info.image] forKey:@"Image"];
        [dic setObject:[LCStringUtil getNotNullStr:info.descriptionStr] forKey:@"Description"];
        [arr addObject:dic];
    }
    NSString *str = [LCStringUtil getJsonStrFromArray:arr];
    [planDic setObject:str forKey:@"Routes"];
    if ([LCStringUtil isNotNullString:receptionPlan.planGuid]) {
        [planDic setObject:receptionPlan.planGuid forKey:@"PlanGuid"];
        [self showHudInView:self.view hint:@"正在修改招待..."];
    } else {
        [self showHudInView:self.view hint:@"正在发布招待..."];
    }
    
    LCReceptionApi *api = [[LCReceptionApi alloc] init];
    api.delegate = self;
    [api publishReception:planDic];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:APP_ANIMATION];
}

#pragma mark - LCReceptionPlan Api
- (void)receptionApi:(LCReceptionApi *)api didPublishNewReception:(LCReceptionPlan *)plan withError:(NSError *)error {
    [self hideHudInView];
    if (!error) {
        [LCXMPPUtil saveChatPlanGroup:plan];
        if (nil != receptionPlan && [LCStringUtil isNullString:receptionPlan.planGuid]) {
            [self showHint:@"发布招待成功！"];
        } else {
            [self showHint:@"修改招待成功！"];
        }
        if (nil != receptionPlan && [LCStringUtil isNotNullString:receptionPlan.planGuid]) {
            [LCDataManager sharedInstance].isAutoScrollToLastestPlan = NO;
        } else {
            [LCDataManager sharedInstance].isAutoScrollToLastestPlan = YES;
        }
        [self.navigationController popToRootViewControllerAnimated:APP_ANIMATION];
    } else {
        [YSAlertUtil alertOneMessage:error.domain];
    }
}

#pragma mark - LCAddOnePlaceVC
- (void)addOnePlaceFinished:(LCAddOnePlaceVC *)addOnePlaceVC {
    self.routeInfo = addOnePlaceVC.routeInfo;
    if (nil == addOnePlaceVC.modiRouteInfo) {
        for (LCRouteInfo *info in routeList) {
            if ([info.placeId isEqualToString:addOnePlaceVC.routeInfo.placeId]) {
                [self showHint:@"不能添加同样的景点！"];
                return ;
            }
        }
        [routeList insertObject:addOnePlaceVC.routeInfo atIndex:0];
    }
    [self updateTableViewCellNumber];
    [LCDataManager sharedInstance].receptionPlan.routes = routeList;
    [self.tableView reloadData];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (routeList.count > 0) {
        self.recommandImageView.image = [UIImage imageNamed:@"ReceptionRecommandIconHL"];
    } else {
        self.recommandImageView.image = [UIImage imageNamed:@"ReceptionRecommandIcon"];
    }
    return routeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"AddPlacesCell";
    LCAddPlacesCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (nil == cell) {
        cell = [[LCAddPlacesCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    LCRouteInfo *routeInfo = [routeList objectAtIndex:indexPath.row];
    cell.placeTitleLabel.text = routeInfo.placeName;
    cell.placeImageView.imageURL = [NSURL URLWithString:routeInfo.image];
    cell.placeIntroLabel.text = routeInfo.descriptionStr;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    LCAddOnePlaceVC *controller = (LCAddOnePlaceVC *)[LCStoryboardManager viewControllerWithFileName:SBNameReceptionPlan identifier:VCIDAddOnePlace];
    controller.delegate = self;
    LCRouteInfo *routeInfo = (LCRouteInfo *)[routeList objectAtIndex:indexPath.row];
    controller.modiRouteInfo = routeInfo;
    [self.navigationController pushViewController:controller animated:APP_ANIMATION];
}

- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [routeList removeObjectAtIndex:indexPath.row];
        tableView.editing = NO;
        [tableView reloadData];
        [self updateTableViewCellNumber];
    }
}

@end

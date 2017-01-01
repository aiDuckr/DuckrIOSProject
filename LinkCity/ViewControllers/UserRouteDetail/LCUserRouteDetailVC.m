//
//  LCUserRouteDetailVC.m
//  LinkCity
//
//  Created by roy on 3/8/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserRouteDetailVC.h"
#import "LCRoutePlaceCell.h"
#import "LCRoutePlaceDayHeaderView.h"
#import "LCPlanDetailChargeIntroCell.h"
#import "LCImageModel.h"
#import "LCPhotoScanner.h"
#import "LCPlanTableVC.h"
#import "LCRouteTitleCell.h"
#import "LCRouteContentTextCell.h"
#import "LCRouteContentTextImageCell.h"
#import "LCRouteTitleView.h"

@interface LCUserRouteDetailVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIBarButtonItem *chooseBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UIButton *relatedPlanButton;
@property (weak, nonatomic) IBOutlet UIView *buttonsCenterLine;


@property (nonatomic, assign) NSInteger dayNum;
//每个元素是一天，也是数据，
@property (nonatomic, strong) NSMutableArray *daysPlaceArray;
@property (nonatomic, strong) NSMutableArray *daysTitleArray;

@end

@implementation LCUserRouteDetailVC

+ (instancetype)createInstance{
    LCUserRouteDetailVC *userRouteDetailVC = (LCUserRouteDetailVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserRoute identifier:VCIDUserRouteDetailVC];
    userRouteDetailVC.gonaShowDayIndex = -1;
    return userRouteDetailVC;
}

- (void)commonInit{
    [super commonInit];
    self.editable = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chooseBtn = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(chooseBtnAction:)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCRouteTitleCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCRouteTitleCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCRouteContentTextCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCRouteContentTextCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCRouteContentTextImageCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCRouteContentTextImageCell class])];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    [self updateShow];
    
    if ([LCDataManager sharedInstance].userInfo) {
        //路线创建者是当前用户
        if ([[LCDataManager sharedInstance].userInfo.uUID isEqualToString:self.routeOwner.uUID]) {
            self.buttonsCenterLine.hidden = YES;
        }else{
            self.buttonsCenterLine.hidden = NO;
        }
    }
    
    if (self.gonaShowDayIndex > 0) {
        [self showDayIndex:self.gonaShowDayIndex withAnimation:NO];
        self.gonaShowDayIndex = -1;
    }
}

- (void)setUserRoute:(LCUserRouteModel *)userRoute{
    _userRoute = userRoute;
    
    self.dayNum = [userRoute getRouteDayNum];
    
    self.daysPlaceArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.daysTitleArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<self.dayNum; i++){
        NSMutableArray *placeArrayForOneDay = [[NSMutableArray alloc] initWithCapacity:0];
        [self.daysPlaceArray addObject:placeArrayForOneDay];
        
        [self.daysTitleArray addObject:[userRoute getRoutePlaceStringForDay:i+1 withSeparator:@"-"]];
    }
    
    for (LCRoutePlaceModel *place in userRoute.routePlaces){
        NSInteger dayIndex = place.routeDay-1;
        NSMutableArray *placeArrayForOneDay = [self.daysPlaceArray objectAtIndex:dayIndex];
        [placeArrayForOneDay addObject:place];
    }
}

- (void)showDayIndex:(NSInteger)dayIndex withAnimation:(BOOL)animation{
    if (dayIndex < self.dayNum) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:dayIndex] atScrollPosition:UITableViewScrollPositionTop animated:animation];
    }
}

- (void)updateShow{
    self.title = [LCStringUtil getNotNullStr:self.userRoute.routeTitle];
    
    if (self.chooseCallBack) {
        self.navigationItem.rightBarButtonItem = self.chooseBtn;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self.tableView reloadData];
}


#pragma mark UIButton Action

- (void)chooseBtnAction:(id)sender{
    if (self.chooseCallBack) {
        self.chooseCallBack(YES);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)relatedButtonAction:(id)sender {
    LCPlanTableVC *planTableVC = [LCPlanTableVC createInstance];
    planTableVC.showingType = LCPlanTableForRouteRelevant;
    planTableVC.userRouteModel = self.userRoute;
    [self.navigationController pushViewController:planTableVC animated:YES];
}

#pragma mark -
#pragma mark UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dayNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNum = 0;
    NSArray *placesForOneDay = [self.daysPlaceArray objectAtIndex:section];
    rowNum = placesForOneDay.count;
    
    return rowNum;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    LCRouteTitleView *titleView = [LCRouteTitleView createInstance];
    titleView.dayNumLabel.text = [NSString stringWithFormat:@"DAY%ld",(long)(section+1)];
    titleView.placesLabel.text = [self.userRoute getRoutePlaceStringForDay:(section+1) withSeparator:@"-"];
    
    return titleView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 10)];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    // route place cell
    NSMutableArray *placeArrayForOneDay = [self.daysPlaceArray objectAtIndex:indexPath.section];
    LCRoutePlaceModel *placeModel = [placeArrayForOneDay objectAtIndex:indexPath.row];
    
    if ([LCStringUtil isNullString:placeModel.placeCoverUrl]) {
        // content text cell
        LCRouteContentTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCRouteContentTextCell class]) forIndexPath:indexPath];
        textCell.contentLabel.text = [LCStringUtil getNotNullStr:placeModel.descriptionStr];
        
        cell = textCell;
    }else{
        // content text and image cell
        LCRouteContentTextImageCell *textAndImageCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCRouteContentTextImageCell class]) forIndexPath:indexPath];
        textAndImageCell.contentLabel.text = [LCStringUtil getNotNullStr:placeModel.descriptionStr];
        [textAndImageCell.imgBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:placeModel.placeCoverUrl] placeholderImage:nil];
        
        cell = textAndImageCell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [LCRouteTitleView getCellHeight];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *imageModels = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSInteger imageIndex = -1;  //所点击的Cell中的图片，在所有图片中的位置
    NSInteger lastDayIndex = -1;    //上一个LCRoutePlaceModel是第几天
    NSInteger placeIndexInADay = 0; //当前LCRoutePlaceModel是一天中的第几个Place
    for (LCRoutePlaceModel *aPlace in self.userRoute.routePlaces){
        NSInteger curDayIndex = aPlace.routeDay-1;
        if (curDayIndex > lastDayIndex) {
            placeIndexInADay = 0;
            lastDayIndex = curDayIndex;
        }else{
            placeIndexInADay ++;
        }
        
        if ([LCStringUtil isNotNullString:aPlace.placeCoverUrl]) {
            LCImageModel *imageModel = [[LCImageModel alloc] init];
            imageModel.imageUrl = aPlace.placeCoverUrl;
            imageModel.imageUrlThumb = aPlace.placeCoverThumbUrl;
            [imageModels addObject:imageModel];
            
            if (indexPath.section == curDayIndex && indexPath.row == placeIndexInADay) {
                imageIndex = imageModels.count-1;
            }
        }
        
    }
    
    if (imageIndex >= 0) {
        LCPhotoScanner *photoScanner = [LCPhotoScanner createInstance];
        [photoScanner showImageModels:imageModels fromIndex:imageIndex];
        [self presentViewController:photoScanner animated:YES completion:nil];
    }
}

@end

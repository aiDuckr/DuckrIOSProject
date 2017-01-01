//
//  LCPlaceSearchResultVC.m
//  LinkCity
//
//  Created by roy on 6/2/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlaceSearchResultVC.h"
#import "LCPlaceSearchWeatherCell.h"
#import "LCPlaceSearchRouteCell.h"
#import "LCPlaceSearchTourpicCell.h"
#import "LCFreePlanCell.h"
#import "LCCostPlanCell.h"
#import "LCWebPlanCell.h"
#import "LCBlankContentView.h"

@interface LCPlaceSearchResultVC ()<UITableViewDataSource, UITableViewDelegate, LCPlaceSearchTourpicCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSArray *weatherArray;
@property (retain, nonatomic) NSArray *routeArray;
@property (retain, nonatomic) NSArray *tourpicArray;
@property (retain, nonatomic) NSArray *planArray;
@property (assign, nonatomic) BOOL isHaveWeather;
@property (retain, nonatomic) UIButton *moreTourpicButton;
@property (retain, nonatomic) UIButton *morePlanButton;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (retain, nonatomic) LCDestinationPlaceModel *place;
@property (nonatomic, strong) UIImage *formerNavigationBarShadowImage;
@property (nonatomic, strong) LCBlankContentView *searchResultBlankView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) UIView *routeHeaderView;
@property (retain, nonatomic) UIView *tourpicHeaderView;
@property (retain, nonatomic) UIView *planHeaderView;

@end

@implementation LCPlaceSearchResultVC

+ (instancetype)createInstance {
    return (LCPlaceSearchResultVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSearchResult identifier:VCIDPlaceSearchResultVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self initTableView];
    [self initBlankView];
    [self updateShow];
     [self addObserveToNotificationNameToRefreshData:URL_FAVOR_PLAN];
}

- (void)initVariable {
    self.isHaveWeather = false;
    self.weatherArray = [[NSArray alloc] init];;
    self.routeArray = [[NSArray alloc] init];;
    self.tourpicArray = [[NSArray alloc] init];;
    self.planArray = [[NSArray alloc] init];;
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 90.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCPlaceSearchTourpicCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCPlaceSearchTourpicCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCWebPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCWebPlanCell class])];
}

- (void)initBlankView {
    self.searchResultBlankView = [[LCBlankContentView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-LCTabViewHeight) imageName:@"BlankContentIconSearch" title:@"还没这个城市的相关信息哦~\r\n可以尝试搜索热门城市" marginTop:200.0f];
    [self.tableView insertSubview:self.searchResultBlankView atIndex:0];
    self.searchResultBlankView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self updateShow];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //如果有正在显示的hud，去掉
    [YSAlertUtil hideHud];
}

- (void)updateShow {
    self.title = self.placeName;
    NSInteger weatherNum = self.weatherArray.count;
    if (3 == weatherNum) {
        self.isHaveWeather = true;
    } else {
        self.isHaveWeather = false;
    }
    if (nil != self.place && self.place.placeThumbImage) {
        [self.topImageView setImageWithURL:[NSURL URLWithString:self.place.placeThumbImage]];
    }
    
    [self.tableView reloadData];
}

- (void)refreshData {
    [self searchMixPlanByPlaceName:self.placeName];
}

#pragma mark LCPlaceSearchTourpicCell Delegate

- (void)likeTourpicButtonAction:(LCPlaceSearchTourpicCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (nil != indexPath) {
        cell.likeButton.enabled = NO;
        LCTourpic *tourpic = [self.tourpicArray objectAtIndex:indexPath.row];
        [LCNetRequester likeTourpic:tourpic.guid withType:@"1" callBack:^(NSInteger likeNum, NSInteger forwardNum, NSInteger isLike, NSError *error) {
            if (!error) {
                cell.likeButton.enabled = YES;
                
                tourpic.likeNum = likeNum;
                tourpic.isLike = isLike;
                [self.tableView reloadData];
            } else {
                [YSAlertUtil tipOneMessage:error.domain];
            }
        }];
    }
}

- (void)unLikeTourpicButtonAction:(LCPlaceSearchTourpicCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (nil != indexPath) {
        cell.likeButton.enabled = NO;
        LCTourpic *tourpic = [self.tourpicArray objectAtIndex:indexPath.row];
        [LCNetRequester unlikeTourpic:tourpic.guid callBack:^(NSInteger likeNum, NSInteger isLike, NSError *error) {
            if (!error) {
                cell.likeButton.enabled = YES;
                
                tourpic.likeNum = likeNum;
                tourpic.isLike = isLike;
                [self.tableView reloadData];
            } else {
                [YSAlertUtil tipOneMessage:error.domain];
            }
        }];
    }
}

- (void)avatarSelectedButtonAction:(LCPlaceSearchTourpicCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (nil != indexPath) {
        LCTourpic *tourpic = [self.tourpicArray objectAtIndex:indexPath.row];
        LCUserModel *user = tourpic.user;
        [LCViewSwitcher pushToShowUserInfoVCForUser:user on:self.navigationController];
    }
}

#pragma mark NetRequest
- (void)searchMixPlanByPlaceName:(NSString *)placeName {
    [YSAlertUtil showHudWithHint:@"搜索信息中..."];
    [LCNetRequester searchDestinationFromHomePage:self.placeName callBack:^(NSArray *weatherArray, NSArray *routeArray, NSArray *tourpicArray, NSArray *planArray, LCDestinationPlaceModel *place, NSError *error) {
        [self.tableView headerEndRefreshing];
        [YSAlertUtil hideHud];
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        } else {
            self.place = place;
            if (nil == self.place || self.place.placeThumbImage) {
                self.topImageView.image = [UIImage imageNamed:@"DefaultSearchResultTopBG"];
            }
            self.weatherArray = weatherArray;
            self.routeArray = routeArray;
            self.tourpicArray = tourpicArray;
            self.planArray = [LCPlanModel addAndFiltDuplicateStagePlanArr:planArray toOriginalPlanArr:nil];
            if (!self.isHaveWeather && self.routeArray.count <= 0 && self.planArray.count <= 0 && self.tourpicArray.count <= 0) {
                self.searchResultBlankView.hidden = NO;
                self.view.backgroundColor = UIColorFromRGBA(0xfaf9f8, 1.0f);
                self.headerView.hidden = YES;
            } else {
                self.searchResultBlankView.hidden = YES;
                self.view.backgroundColor = UIColorFromRGBA(0xf1f1ec, 1.0f);
                self.headerView.hidden = NO;
            }
        }
        [self updateShow];
    }];
}

- (void)moreTourpicButtonAction:(id)sender {
    if ([LCStringUtil isNotNullString:self.placeName]) {
        [LCViewSwitcher pushToShowTourPicTableVCForKeyWord:self.placeName on:self.navigationController];
    }
}

- (void)morePlanButtonAction:(id)sender {
    if ([LCStringUtil isNotNullString:self.placeName]) {
        [LCViewSwitcher pushToShowPlaceSearchMorePlan:self.placeName on:self.navigationController];
    }
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNum = 0;
    if (0 == section && self.isHaveWeather) {
        rowNum = 1;
    } else if (1 == section) {
        rowNum = self.routeArray.count;
    } else if (2 == section) {
        rowNum = self.tourpicArray.count;
    } else if (3 == section) {
        rowNum = self.planArray.count;
    }
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (0 == indexPath.section && self.isHaveWeather) {
        LCPlaceSearchWeatherCell *weatherCell = [tableView dequeueReusableCellWithIdentifier:@"PlaceSearchWeatherCell" forIndexPath:indexPath];
        [weatherCell updateShowWeather:self.weatherArray];
        cell = weatherCell;
    } else if (1 == indexPath.section) {
        LCPlaceSearchRouteCell *routeCell = [tableView dequeueReusableCellWithIdentifier:@"PlaceSearchRouteCell" forIndexPath:indexPath];
        LCUserRouteModel *route = [self.routeArray objectAtIndex:indexPath.row];
        if (indexPath.row == self.routeArray.count - 1) {
            [routeCell updateShowRouteView:route.routeTitle isLastOne:true];
        } else {
            [routeCell updateShowRouteView:route.routeTitle isLastOne:false];
        }
        cell = routeCell;
    } else if (2 == indexPath.section) {
        LCTourpic *tourpic = [self.tourpicArray objectAtIndex:indexPath.row];
        LCPlaceSearchTourpicCell *tourpicCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCPlaceSearchTourpicCell class]) forIndexPath:indexPath];
        [tourpicCell updateShowPlaceSearchTourpic:tourpic];
        tourpicCell.delegate = self;
        cell = tourpicCell;
    } else if (3 == indexPath.section) {
        id plan = [self.planArray objectAtIndex:indexPath.row];
        if ([plan isKindOfClass:[LCPlanModel class]]) {
            LCPlanModel *normalPlan = (LCPlanModel *)plan;
            if ([normalPlan isMerchantCostPlan]) {
                LCCostPlanCell *costPlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanCell class]) forIndexPath:indexPath];
                [costPlanCell updateShowWithPlan:normalPlan];
                cell = costPlanCell;
            } else {
                LCFreePlanCell *freePlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCFreePlanCell class]) forIndexPath:indexPath];
                if (indexPath.row != ([tableView numberOfRowsInSection:indexPath.section] - 1))
                    [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:YES];
                else
                    [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:NO];
                cell = freePlanCell;
            }
        } else if([plan isKindOfClass:[LCWebPlanModel class]]) {
            LCWebPlanModel *webPlan = (LCWebPlanModel *)plan;
            LCWebPlanCell *planCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCWebPlanCell class]) forIndexPath:indexPath];
            [planCell updateShowWebPlan:webPlan];
            cell = planCell;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (1 == indexPath.section) {
        LCUserRouteModel *route = [self.routeArray objectAtIndex:indexPath.row];
        [LCViewSwitcher pushToShowRouteDetailVCForRoute:route routeOwner:nil editable:NO showDayIndex:0 on:self.navigationController];
    } else if (2 == indexPath.section) {
        LCTourpic *tourpic = [self.tourpicArray objectAtIndex:indexPath.row];
        [LCViewSwitcher pushToShowTourPicDetail:tourpic withType:LCTourpicDetailVCViewType_Normal on:self.navigationController];
    } else if (3 == indexPath.section) {
        id plan = [self.planArray objectAtIndex:indexPath.row];
        if ([plan isKindOfClass:[LCPlanModel class]]) {
            LCPlanModel *normalPlan = (LCPlanModel *)plan;
            [LCViewSwitcher pushToShowPlanDetailVCForPlan:normalPlan recmdUuid:nil on:self.navigationController];
        } else if([plan isKindOfClass:[LCWebPlanModel class]]) {
            LCWebPlanModel *webPlan = (LCWebPlanModel *)plan;
            [LCViewSwitcher pushWebVCtoShowURL:webPlan.planUrl withTitle:webPlan.title on:self.navigationController];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat sectionHeight = 0;
    if (1 == section && self.routeArray.count > 0) {
        sectionHeight = 40.0f;
    } else if (2 == section && self.tourpicArray.count > 0) {
        sectionHeight = 40.0f;
    } else if (3 == section && self.planArray.count > 0) {
        sectionHeight = 40.0f;
    }
    return sectionHeight;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat sectionHeaderHeight = 40;
//    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//}

- (UIView *)routeHeaderView {
    if (!_routeHeaderView) {
        _routeHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DEVICE_WIDTH, 40.0f)];
        _routeHeaderView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 12.0f, 200.0f, 16.0f)];
        label.textColor = UIColorFromRGBA(0x2c2a28, 1.0f);
        label.text = [NSString stringWithFormat:@"%@路线", self.placeName];
        [_routeHeaderView addSubview:label];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 39.5f, DEVICE_WIDTH, 0.5f)];
        bottomView.backgroundColor = DefaultSpalineColor;
        [_routeHeaderView addSubview:bottomView];
    }
    return _routeHeaderView;
}

- (UIView *)tourpicHeaderView {
    if (!_tourpicHeaderView) {
        _tourpicHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DEVICE_WIDTH, 40.0f)];
        _tourpicHeaderView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 12.0f, 200.0f, 16.0f)];
        label.textColor = UIColorFromRGBA(0x2c2a28, 1.0f);
        label.text = [NSString stringWithFormat:@"%@旅图", self.placeName];
        [_tourpicHeaderView addSubview:label];
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_WIDTH - 76.0f, 14.0f, 52.0f, 12.0f)];
        rightLabel.textColor = UIColorFromRGBA(0xaba7a2, 1.0f);
        rightLabel.text = @"更多旅图";
        rightLabel.font = [UIFont fontWithName:APP_CHINESE_FONT size:13.0f];
        [_tourpicHeaderView addSubview:rightLabel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH - 18.0f, 13.5f, 8.0f, 13.0f)];
        imageView.image = [UIImage imageNamed:@"PlanDetailViewMoreIcon"];
        [_tourpicHeaderView addSubview:imageView];
        
        self.moreTourpicButton = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_WIDTH - 76.0f, 10.0f, 70.0f, 20.0f)];
        [self.moreTourpicButton addTarget:self action:@selector(moreTourpicButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_tourpicHeaderView addSubview:self.moreTourpicButton];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 39.5f, DEVICE_WIDTH, 0.5f)];
        bottomView.backgroundColor = DefaultSpalineColor;
        [_tourpicHeaderView addSubview:bottomView];
    }
    return _tourpicHeaderView;
}

- (UIView *)planHeaderView {
    if (!_planHeaderView) {
        _planHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DEVICE_WIDTH, 40.0f)];
        _planHeaderView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 12.0f, 200.0f, 16.0f)];
        label.textColor = UIColorFromRGBA(0x2c2a28, 1.0f);
        label.text = [NSString stringWithFormat:@"%@邀约", self.placeName];
        [_planHeaderView addSubview:label];
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_WIDTH - 76.0f, 14.0f, 52.0f, 12.0f)];
        rightLabel.textColor = UIColorFromRGBA(0xaba7a2, 1.0f);
        rightLabel.text = @"更多邀约";
        rightLabel.font = [UIFont fontWithName:APP_CHINESE_FONT size:13.0f];
        [_planHeaderView addSubview:rightLabel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH - 18.0f, 13.5f, 8.0f, 13.0f)];
        imageView.image = [UIImage imageNamed:@"PlanDetailViewMoreIcon"];
        [_planHeaderView addSubview:imageView];
        
        self.morePlanButton = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_WIDTH - 76.0f, 10.0f, 70.0f, 20.0f)];
        [self.morePlanButton addTarget:self action:@selector(morePlanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_planHeaderView addSubview:self.morePlanButton];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 39.5f, DEVICE_WIDTH, 0.5f)];
        bottomView.backgroundColor = DefaultSpalineColor;
        [_planHeaderView addSubview:bottomView];
    }
    return _planHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (1 == section && self.routeArray.count > 0) {
        return self.routeHeaderView;
    } else if (2 == section && self.tourpicArray.count > 0) {
        return self.tourpicHeaderView;
    } else if (3 == section && self.planArray.count > 0) {
        return self.planHeaderView;
    }
    return [[UIView alloc] init];;
}
@end

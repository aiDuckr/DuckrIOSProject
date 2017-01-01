//
//  LCSearchDestinationVC.m
//  LinkCity
//
//  Created by 张宗硕 on 11/7/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCSearchDestinationVC.h"
#import "LCCommonApi.h"
#import "LCFilterResultVC.h"

@interface LCSearchDestinationVC ()<LCCommonApiDelegate>
@property (weak, nonatomic) IBOutlet UITableView *destinationTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *destinationCollectionView;
@property (weak, nonatomic) IBOutlet UIView *collectionHeaderView;

@end

@implementation LCSearchDestinationVC

+ (instancetype)createInstance {
    return (LCSearchDestinationVC *)[LCStoryboardManager viewControllerWithFileName:SBNamePartnerPlan identifier:VCIDSearchDestination];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 初始化导航栏按钮.
    [self initNavigationItem];
    /// 初始化搜索框.
    [self initSearchBar];
    /// 初始化搜索结果列表控件.
    [self initDestinationTableView];
    /// 初始化热门目的地集合.
    [self initDestinationCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    mySearchBar.text = @"";
    destinationList = [[NSArray alloc] init];
    if (SEARCH_DESTINATION_PARTNER == self.searchType
        || SEARCH_DESTINATION_HOMEPAGE == self.searchType
        || SEARCH_DESTINATION_FILTER == self.searchType) {
        self.destinationTableView.hidden = YES;
        self.destinationCollectionView.hidden = NO;
        self.collectionHeaderView.hidden = NO;
        mySearchBar.placeholder = @"搜索目的地";
    }
    
    if (SEARCH_DESTINATION_RECEPTION == self.searchType) {
        self.destinationTableView.hidden = NO;
        self.destinationCollectionView.hidden = YES;
        self.collectionHeaderView.hidden = YES;
        mySearchBar.placeholder = @"请输入招待城市";
    }
    
    if (SEARCH_DESTINATION_ADD_PLACE == self.searchType) {
        self.destinationTableView.hidden = NO;
        self.destinationCollectionView.hidden = YES;
        self.collectionHeaderView.hidden = YES;
        mySearchBar.placeholder = @"请输入添加景点";
    }
    [self.destinationTableView reloadData];
    [mySearchBar becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateHotPlacesFromServer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [mySearchBar resignFirstResponder];
}

/// 初始化导航栏按钮.
- (void)initNavigationItem {
    self.navigationItem.hidesBackButton = YES;
}

/// 初始化搜索框.
- (void)initSearchBar {
    mySearchBar = [[YSSearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, (DEVICE_WIDTH - 15.0f * 2), 44.0f)];
    mySearchBar.delegate = self;
    [mySearchBar setPlaceholder:@"搜索目的地"];
    mySearchBar.showsCancelButton = YES;
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(15.0f, 0.0f, (DEVICE_WIDTH - 15.0f * 2), 44.0f)];
    [searchView addSubview:mySearchBar];
    self.navigationItem.titleView = searchView;
}

/// 初始化搜索结果列表控件.
- (void)initDestinationTableView {
    self.destinationTableView.delegate = self;
    self.destinationTableView.dataSource = self;
}

/// 初始化热门目的地集合.
- (void)initDestinationCollectionView {
    self.destinationCollectionView.delegate = self;
    self.destinationCollectionView.dataSource = self;
}

/// 从后台更新热门景点
- (void)updateHotPlacesFromServer {
    hotDestinationList = [LCDataManager sharedInstance].hotDestinationList;
    [self.destinationCollectionView reloadData];

    LCCommonApi *api = [[LCCommonApi alloc] initWithDelegate:self];
    [api getHotDestinationList];
}

/// 根据输入搜索地点.
- (void)searchDestinationText:(NSString *)text {
    if ([LCStringUtil isNotNullString:text]) {
        LCCommonApi *api = [[LCCommonApi alloc] initWithDelegate:self];
        NSString *type = @"All";
        if (SEARCH_DESTINATION_RECEPTION == self.searchType) {
            type = @"City";
        } else if (SEARCH_DESTINATION_ADD_PLACE == self.searchType) {
            type = @"Place";
        }
        [api searchDestinationList:text withType:type];
    }
}

/// 点击搜索的地点.
- (void)selectOnePlace:(LCPlaceInfo *)info {
    if (nil != info) {
        if (SEARCH_DESTINATION_PARTNER == self.searchType) {
            LCNewPartnerPlanVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:VCIDNewPartnerPlan];
            LCPartnerPlan *partnerPlan = [LCDataManager sharedInstance].partnerPlan;
            if (nil == partnerPlan || [LCStringUtil isNotNullString:[LCDataManager sharedInstance].partnerPlan.planGuid]) {
                [LCDataManager sharedInstance].partnerPlan = [[LCPartnerPlan alloc] init];
            }
            [LCDataManager sharedInstance].partnerPlan.destinationId = info.placeID;
            [LCDataManager sharedInstance].partnerPlan.destinationName = info.placeName;
            controller.type = NPT_NEW_PARTNER;
            [self.navigationController pushViewController:controller animated:APP_ANIMATION];
        }
        if (SEARCH_DESTINATION_RECEPTION == self.searchType) {
            LCNewReceptionPlanVC *controller = (LCNewReceptionPlanVC *)[LCStoryboardManager viewControllerWithFileName:SBNameReceptionPlan identifier:VCIDNewReceptionPlan];
            
            LCReceptionPlan *receptionPlan = [LCDataManager sharedInstance].receptionPlan;
            if (nil == receptionPlan || [LCStringUtil isNotNullString:[LCDataManager sharedInstance].receptionPlan.planGuid]) {
                [LCDataManager sharedInstance].receptionPlan = [[LCReceptionPlan alloc] init];
            }
            [LCDataManager sharedInstance].receptionPlan.destinationId = info.placeID;
            [LCDataManager sharedInstance].receptionPlan.destinationName = info.placeName;
            controller.type = NRT_NEW_RECEPTION;
            [self.navigationController pushViewController:controller animated:APP_ANIMATION];
        }
        if (SEARCH_DESTINATION_ADD_PLACE == self.searchType) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(searchDestinationFinished:)]) {
                self.placeInfo = info;
                [self.delegate searchDestinationFinished:self];
                [self.navigationController popViewControllerAnimated:APP_ANIMATION];
            }
        }
        if (SEARCH_DESTINATION_HOMEPAGE == self.searchType) {
            self.placeInfo = info;
            LCFilterResultVC *vc = (LCFilterResultVC *)[LCStoryboardManager viewControllerWithFileName:SBNameHomePage identifier:VCIDFilterResultVC];
            vc.placeId = self.placeInfo.placeID;
            vc.scaleMax = PLAN_MAX_SCALE;
            vc.startDate = @"";
            vc.endDate = @"";
            vc.planType = @"";
            [self.navigationController pushViewController:vc animated:APP_ANIMATION];
        }
        
        if (SEARCH_DESTINATION_FILTER == self.searchType) {
            self.placeInfo = info;
            [self.delegate searchDestinationFinished:self];
            [self.navigationController popViewControllerAnimated:APP_ANIMATION];
        }
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return destinationList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SearchDestinationCell";
    LCSearchDestinationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[LCSearchDestinationCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    LCPlaceInfo *info = [destinationList objectAtIndex:indexPath.row];
    cell.destinationLabel.text = info.placeName;
    cell.addressLabel.text = info.placeAddress;
    cell.distanceLabel.text = info.distance;
    /*UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = cell.frame.size;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 0.0;
    self.destinationCollectionView.collectionViewLayout = layout;*/
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCPlaceInfo *info = [destinationList objectAtIndex:indexPath.row];
    [self selectOnePlace:info];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

#pragma mark - UISearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchDestinationText:searchBar.text];
    [mySearchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.navigationController popViewControllerAnimated:APP_ANIMATION];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    /// 实时搜索地点.
    [self searchDestinationText:searchText];
}

#pragma mark - UICollectionView Delegate
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    float cellSize = collectionView.frame.size.width/ITEMNUM_PER_LINE;
//    return CGSizeMake(cellSize,cellSize);
//}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return hotDestinationList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCDestinationCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DestinationCollectionCell"
                                                                                  forIndexPath:indexPath];
    LCPlaceInfo *info = [hotDestinationList objectAtIndex:indexPath.row];
    cell.destinationLabel.text = info.placeName;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LCPlaceInfo *info = [hotDestinationList objectAtIndex:indexPath.row];
    [self selectOnePlace:info];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [mySearchBar resignFirstResponder];
}

#pragma mark - LCCommonApi Delegate
- (void)commonApi:(LCCommonApi *)api didGetHotDestinationList:(NSArray *)placeList withError:(NSError *)error {
    if (!error) {
        hotDestinationList = placeList;
        [LCDataManager sharedInstance].hotDestinationList = placeList;
        [self.destinationCollectionView reloadData];
    }
}

- (void)commonApi:(LCCommonApi *)api didSearchDestinationList:(NSArray *)planArr withError:(NSError *)error {
    destinationList = planArr;
    self.destinationTableView.hidden = NO;
    [self.destinationTableView reloadData];
}

@end

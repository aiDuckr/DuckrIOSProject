//
//  LCSendPlanInSameCityVC.m
//  LinkCity
//
//  Created by lhr on 16/4/14.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCSendPlanInSameCityVC.h"
#import "LCSendPlanDetailVC.h"
#import "LCSendFreePlanDestVC.h"
#import "LCSystemPermissionUtil.h"
#import "LCSendPlanTourThemeCell.h"

@interface LCSendPlanInSameCityVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) NSArray *inviteThemeArr;
@property (strong, nonatomic) NSMutableArray * tagViewArray;
@property (strong, nonatomic) LCRouteThemeModel *selectedItemModel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation LCSendPlanInSameCityVC

+ (instancetype)createInstance {
     return (LCSendPlanInSameCityVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSendPlan identifier:NSStringFromClass([LCSendPlanInSameCityVC class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCollectionsView];
    
    if (nil != self.curPlan.selectedThemeArr && self.curPlan.selectedThemeArr.count > 0) {
        self.selectedItemModel = self.curPlan.selectedThemeArr[0];
    }
    
    self.inviteThemeArr = [LCDataManager sharedInstance].appInitData.inviteThemes;
    
    /// Cell可点击.
    NSArray *gestureArray = [self.view gestureRecognizers];
    for (UIGestureRecognizer *gesture in gestureArray) {
        [self.view removeGestureRecognizer:gesture];
    }
}

- (void)initCollectionsView {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.estimatedItemSize = CGSizeMake(55.0f, 50.0f);
    self.collectionView.collectionViewLayout = layout;
}

- (void)nextAction {
    if (nil == self.selectedItemModel) {
        [YSAlertUtil tipOneMessage:@"没有选择主题"];
        return ;
    }
    self.curPlan.selectedThemeArr = @[self.selectedItemModel];
    
    if (self.isInSameCity == NO) {
        LCSendFreePlanDestVC *destVC = [LCSendFreePlanDestVC createInstance];
        self.curPlan.routeType = LCRouteTypeFreePlanCommon;
        destVC.curPlan = self.curPlan;
        destVC.isSendingPlan = self.isSendingPlan;
        [self.navigationController pushViewController:destVC animated:YES];
    } else {
        if ([LCStringUtil isNullString:self.curPlan.departName]) {
            if (![CLLocationManager locationServicesEnabled]) {
                [LCSystemPermissionUtil isHaveLocationServicePermission:YES withText:@"定位服务开启后才能发同城邀约哦~"];
            } else {
                if (kCLAuthorizationStatusDenied == [CLLocationManager authorizationStatus]) {
                    [LCSystemPermissionUtil isHaveLocationServicePermission:NO withText:@"定位服务开启后才能发同城邀约哦~"];
                } else {
                    self.curPlan.departName = [LCStringUtil getNotNullStr:[LCDataManager sharedInstance].currentCity.cityName];
                    LCSendPlanDetailVC *vc = [LCSendPlanDetailVC createInstance];
                    self.curPlan.routeType = LCRouteTypeFreePlanSameCity;
                    self.curPlan.daysLong = 1;
                    vc.curPlan = self.curPlan;
                    vc.isInSameCity = YES;
                    vc.isSendingPlan = self.isSendingPlan;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            
            return;
        }
        LCSendPlanDetailVC *vc = [LCSendPlanDetailVC createInstance];
        vc.curPlan = self.curPlan;
        vc.isInSameCity = self.isInSameCity;
        vc.isSendingPlan = self.isSendingPlan;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:APP_ANIMATION];
}

#pragma mark - UICollectionView Delegate.
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 7.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 9.0f;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger num = 0;
    if (nil != self.inviteThemeArr) {
        num = self.inviteThemeArr.count;
    }
    return num;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCSendPlanTourThemeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCSendPlanTourThemeCell class]) forIndexPath:indexPath];
    NSLog(@"%ld",(long)indexPath.row);
    if (nil != self.inviteThemeArr) {
        LCRouteThemeModel *model = [self.inviteThemeArr objectAtIndex:indexPath.row];
        [cell updateShowSendPlanTourThemeCell:model];
    }
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LCRouteThemeModel *model = [self.inviteThemeArr objectAtIndex:indexPath.row];
    if (TourOutdoorThemeId == model.tourThemeId) {
        self.isInSameCity = NO;
    } else {
        self.isInSameCity = YES;
    }
    self.selectedItemModel = model;
    if(self.curPlan.tourThemeId == 0) {
        self.curPlan.tourThemeId = model.tourThemeId;
    }
    else if (model.tourThemeId != self.curPlan.tourThemeId) {
        self.curPlan = [LCPlanModel createEmptyPlanForEdit];
    }
    [self nextAction];
}
@end

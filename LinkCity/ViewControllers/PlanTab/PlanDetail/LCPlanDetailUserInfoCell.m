//
//  LCPlanDetailUserInfoCell.m
//  LinkCity
//
//  Created by 张宗硕 on 12/13/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCPlanDetailUserInfoCell.h"
#import "LCPlanDetailBaseInfoCell.h"
#import "LCPlanDetailThemeCollectionLayout.h"
#import "LCPlanDetailPlaceCell.h"

@interface LCPlanDetailUserInfoCell()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *memberAvatarButtons;
@property (nonatomic, strong) NSArray *destArray;
@end

@implementation LCPlanDetailUserInfoCell

- (void)awakeFromNib {
    [self initCollectionView];
}

+ (NSArray *)getDestStringArrayOfPlan:(LCPlanModel *)plan {
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    if ([LCStringUtil isNotNullString:plan.departName]) {
        [mutArray addObject:plan.departName];
        [mutArray addObject:@"-"];
    }

    if ([plan isUrbanPlan]) {
        //同城邀约，显示主题们
        //e.g.北京市-海淀区 - 看电影 - 爬山
        for(int i = 0; i < plan.tourThemes.count; i++){
            LCRouteThemeModel *theme = plan.tourThemes[i];
            
            if (UrbanThemeId == theme.tourThemeId) {
                continue;
            }
            
            [mutArray addObject:theme.title];
            [mutArray addObject:@"-"];
        }
    } else {
        //其它邀约，显示目的地们
        //e.g.北京市-海淀区 - 昆明 - 大理
        for(int i = 0; i < plan.destinationNames.count; i++) {
            NSString *destName = plan.destinationNames[i];
            [mutArray addObject:destName];
            [mutArray addObject:@"-"];
        }
    }
    [mutArray removeLastObject];
    return mutArray;
}

- (void)updateShowUserInfo:(LCPlanModel *)plan {
    self.plan = plan;
    if (self.plan.memberList && self.plan.memberList.count>0) {
        LCUserModel *user = [self.plan.memberList firstObject];
        [self.avatarImage setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
        self.nickLabel.text = user.nick;
        self.ageLabel.text = [user getUserAgeString];
        
        if ([user getUserSex] == UserSex_Male) {
            self.sexImageView.image = [UIImage imageNamed:LCSexMaleImageName];
        } else {
            self.sexImageView.image = [UIImage imageNamed:LCSexFemaleImageName];
        }
    }
    
    self.destArray = [LCPlanDetailUserInfoCell getDestStringArrayOfPlan:plan];
    [self.routeCollection reloadData];
    [self.routeCollection setNeedsLayout];
    [self.routeCollection layoutIfNeeded];
    self.routeCollectionHeight.constant = [self getDestinationCollectionViewHeightForPlan:self.plan];
    
    self.startDateLabel.text = [NSString stringWithFormat:@"%@", plan.startTime];
    if (plan.daysLong == 0) {
        plan.daysLong = 1;
    }
    self.daysLabel.text = [NSString stringWithFormat:@"全程%ld天", (long)plan.daysLong];

}

- (void)initCollectionView {
    self.routeCollection.delegate = self;
    self.routeCollection.dataSource = self;
    self.routeCollection.scrollEnabled = NO;
    UICollectionViewFlowLayout *layout = [[LCPlanDetailThemeCollectionLayout alloc] init];
    self.routeCollection.collectionViewLayout = layout;
}

- (IBAction)avatarImageViewDidSelected:(id)sender {
    if ([self.delegate respondsToSelector:@selector(planDetailUserInfoCellToViewUserDetail:)]) {
        [self.delegate planDetailUserInfoCellToViewUserDetail:self];
    }
}

#pragma mark UICollectionView Delegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0f;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger num = 0;
    if (nil != self.destArray) {
        num = self.destArray.count;
    }
    return num;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCPlanDetailPlaceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCPlanDetailPlaceCell class]) forIndexPath:indexPath];
    if (nil != self.destArray && indexPath.row < self.destArray.count) {
        NSString *placeName = [self.destArray objectAtIndex:indexPath.row];
        [cell updateShowPlaceName:placeName];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(0, 0);
    
    if (nil != self.destArray && indexPath.row < self.destArray.count) {
        NSString *placeName = [self.destArray objectAtIndex:indexPath.row];
        size = CGSizeMake([LCPlanDetailPlaceCell cellWidthForPlaceName:placeName], [LCPlanDetailPlaceCell cellHeight]);
    }
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (nil != self.destArray && indexPath.row < self.destArray.count) {
        NSString *placeName = [self.destArray objectAtIndex:indexPath.row];
        if (![placeName isEqualToString:@"-"]) {
            if ([self.delegate respondsToSelector:@selector(planDetailUserInfoCellToViewPlace:isDepart:)]) {
                [self.delegate planDetailUserInfoCellToViewPlace:placeName isDepart:(indexPath.item == 0)];
            }
        }
    }
}

- (CGFloat)getDestinationCollectionViewHeightForPlan:(LCPlanModel *)plan{
    CGFloat destCollectionViewWidth = DEVICE_WIDTH - 20 - 90 - 0;
    CGFloat tempWidth = 0;
    CGFloat rowNum = 0;
    NSInteger destIndex = 0;
    if (self.destArray.count>0) {
        rowNum = 1;
        for (NSString *aDest in self.destArray){
            CGSize cellSize = CGSizeMake([LCPlanDetailPlaceCell cellWidthForPlaceName:aDest], [LCPlanDetailPlaceCell cellHeight]);
            tempWidth += cellSize.width;
            if (tempWidth > destCollectionViewWidth) {
                //换行
                tempWidth = cellSize.width;
                rowNum ++;
            }
            
            destIndex++;
        }
    }
    CGFloat destCollectionViewHeight = rowNum * [LCPlanDetailPlaceCell cellHeight] + (rowNum - 1) * 8.0;
    
    if (rowNum > 1) {
        destCollectionViewHeight += 8.0;
    }
    
    return destCollectionViewHeight;
}

@end

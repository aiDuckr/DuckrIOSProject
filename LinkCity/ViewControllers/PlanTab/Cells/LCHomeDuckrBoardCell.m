//
//  LCHomeDuckrBoardCell.m
//  LinkCity
//
//  Created by 张宗硕 on 5/18/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCHomeDuckrBoardCell.h"
#import "LCHomeDuckrBoardUserCell.h"
#import "LCDuckrUserListVC.h"
@interface LCHomeDuckrBoardCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation LCHomeDuckrBoardCell

#pragma mark - LifeCycle.
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initCollectionsView];
}

#pragma mark - Common Init.
- (void)initCollectionsView {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.estimatedItemSize = CGSizeMake(83, 83);
    self.collectionView.collectionViewLayout = layout;
}

/// 更新Cell数据和界面.
- (void)updateShowCell:(NSArray *)userArr {
    self.userArr = userArr;
    [self.collectionView reloadData];
}

/// 查看更多达客榜.
- (IBAction)viewMoreAction:(id)sender {
    LCDuckrUserListVC * vc = [LCDuckrUserListVC createInstance];
    [[LCSharedFuncUtil getTopMostNavigationController] pushViewController:vc animated:YES];
    
}

#pragma mark - UICollectionView Delegate.
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20.0f;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger num = 0;
    if (nil != self.userArr) {
        num = self.userArr.count;
    }
    return num;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCHomeDuckrBoardUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCHomeDuckrBoardUserCell class]) forIndexPath:indexPath];
    if (nil != self.userArr && indexPath.row < self.userArr.count) {
        LCUserModel *user = [self.userArr objectAtIndex:indexPath.row];
        [cell updateShowCell:user];
    }
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
        return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    CGSize size = CGSizeMake(110.0f, 110.0f);
//    return size;
//}
@end

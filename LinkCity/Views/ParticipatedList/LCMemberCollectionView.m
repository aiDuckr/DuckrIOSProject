//
//  LCMemberCollectionView.m
//  LinkCity
//
//  Created by roy on 11/13/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCMemberCollectionView.h"
#import "LCMemberCollectionCell.h"

#define ITEM_PER_LINE 5
#define HEIGHT_PER_LINE 62
#define SPACE_BETWEEN_LINE 23

@interface LCMemberCollectionView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end


@implementation LCMemberCollectionView
const NSInteger USER_PER_LINE = 5;

- (void)setUsers:(NSMutableArray *)users {
    _users = users;
    self.delegate = self;
    self.dataSource = self;
    
    self.scrollEnabled = NO;
    [self invalidateIntrinsicContentSize];
    [self reloadData];
}

- (CGSize)intrinsicContentSize {
    if (self.users && self.users.count > 0) {
        NSInteger lineNumber = (self.users.count-1)/ITEM_PER_LINE+1;
        return CGSizeMake(0, HEIGHT_PER_LINE * lineNumber + SPACE_BETWEEN_LINE*(lineNumber-1));
    }else{
        return CGSizeMake(0, 0);
    }
}


#pragma mark - CollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger sectionNumber = self.users.count/ITEM_PER_LINE;
//    NSInteger itemNumber = 0;
//    if (section < sectionNumber) {
//        itemNumber = ITEM_PER_LINE;
//    } else {
//        itemNumber = self.users.count%ITEM_PER_LINE;
//    }
//    RLog(@"number of items in section:%ld, return:%lu",(long)section,(long)itemNumber);
    return ITEM_PER_LINE;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSInteger numberOfSection = (self.users.count - 1)/ITEM_PER_LINE +1;
    RLog(@"number of section :%lu",(long)numberOfSection);
    return numberOfSection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCMemberCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReuseMemberColletionCell" forIndexPath:indexPath];
//    UIView *selectBgView = [[UIView alloc]init];
//    selectBgView.backgroundColor = [UIColor lightGrayColor];
//    selectBgView.alpha = 0.1;
//    cell.selectedBackgroundView = selectBgView;
    NSInteger userIndex = indexPath.section*ITEM_PER_LINE + indexPath.item;
    //RLog(@"cellForSection:%ld,item:%ld, userIndex:%ld",indexPath.section,indexPath.item,userIndex);
    if (userIndex >= self.users.count) {
        cell.userInfo = nil;
    }else{
        cell.userInfo = [self.users objectAtIndex:userIndex];
    }
    //RLog(@"cell for item at indexpath");
    return cell;
}


#pragma mark - CollectionViewDelegateLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //return CGSizeMake(self.frame.size.width/ITEM_PER_LINE, HEIGHT_PER_LINE);
    return CGSizeMake(self.frame.size.width/ITEM_PER_LINE-2, HEIGHT_PER_LINE);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, SPACE_BETWEEN_LINE, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    RLog(@"selectItem: %ld, %ld",(long)indexPath.section,(long)indexPath.item);
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.memberCollectionViewDelegate && [self.memberCollectionViewDelegate respondsToSelector:@selector(memberCollectionView:didSelectIndex:)]) {
        [self.memberCollectionViewDelegate memberCollectionView:self didSelectIndex:(indexPath.section*ITEM_PER_LINE + indexPath.item)];
    }
}
@end

//
//  LCSearchPlaceThemeCell.m
//  LinkCity
//
//  Created by 张宗硕 on 8/3/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCSearchPlaceThemeCell.h"
#import "LCSearchPlaceThemeButtonCell.h"

@interface LCSearchPlaceThemeCell() <UICollectionViewDelegate, UICollectionViewDataSource, LCSearchPlaceThemeButtonCellDelegate>

@end

@implementation LCSearchPlaceThemeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initCollectionView];
}

- (void)initCollectionView {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCSearchPlaceThemeButtonCell class]) bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([LCSearchPlaceThemeButtonCell class])];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.estimatedItemSize = CGSizeMake(39.0f, 15.0f);//collectionView显示问题
    self.collectionView.collectionViewLayout = layout;
}

- (void)updateSearchPlaceThemeCell:(NSArray *)themeCategoryArr {
    self.themeCategoryArr = themeCategoryArr;
    if (nil != self.themeCategoryArr && self.themeCategoryArr.count > 0) {
        id obj = [self.themeCategoryArr objectAtIndex:0];
        if ([obj isKindOfClass:[LCHomeCategoryModel class]]) {
            self.titleLabel.text = @"热门搜索";//LCHomeCategoryModel???
        } else {
            self.titleLabel.text = @"热门主题";
        }
        //cell上面放了一个collectionview。显示为一个个的tag一样的方框，方便用户进行搜索时点击。
        NSInteger number = (self.themeCategoryArr.count - 1) / 4 + 1;
        self.collectionHeightConstraint.constant =  30.0f * number + 15.0f * (number - 1);
    }
}

#pragma mark collectionCell上的button呗点击了，传递自己和text值过去。（其实不用传自己吧？？？）
- (void)searchPlaceThemeButtonDidClick:(NSString *)text {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchPlaceThemeDidSelected:withText:)]) {
        [self.delegate searchPlaceThemeDidSelected:self withText:text];
    }
}

#pragma mark - UICollectionView Delegate.
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15.0f;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger num = 0;
    if (nil != self.themeCategoryArr) {
        num = self.themeCategoryArr.count;
    }
    return num;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCSearchPlaceThemeButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCSearchPlaceThemeButtonCell class]) forIndexPath:indexPath];//collectionview的cell上放的button。
    if (nil != self.themeCategoryArr) {
        id obj = [self.themeCategoryArr objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[LCHomeCategoryModel class]]) {
            LCHomeCategoryModel *model = (LCHomeCategoryModel *)obj;
            [cell updateShowSearchPlaceThemeButtonCell:model.title];
        } else {
            LCRouteThemeModel *model = (LCRouteThemeModel *)obj;
            [cell updateShowSearchPlaceThemeButtonCell:model.title];
        }
    }
    cell.delegate = self;
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

@end

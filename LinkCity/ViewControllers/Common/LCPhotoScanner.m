//
//  LCPhotoScanner.m
//  LinkCity
//
//  Created by roy on 11/27/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCPhotoScanner.h"
#import "LCPhotoScannerCell.h"
#import "LCStoryboardManager.h"

@interface LCPhotoScanner ()<LCPhotoScannerCellDelegate>
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, assign) NSInteger jumpToIndex;
@property (nonatomic, strong) NSArray *imageSourceArray;
@end

@implementation LCPhotoScanner

static NSString * const reuseIdentifier = @"PhotoScannerCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - LCPhotoScannerCell Delegate
- (void)dissmissPhotoView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //scroll collection to a cell, need the collection has loaded cells.
    //have to do this after some time...
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSIndexPath *ip = [NSIndexPath indexPathForItem:self.jumpToIndex inSection:0];
        NSLog(@"%lu,%lu",(long)ip.section,(long)ip.item);
        [self.collectionView selectItemAtIndexPath:ip  animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    });
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
#pragma mark - Public Interfaces
+ (instancetype)createInstance{
    return (LCPhotoScanner *)[LCStoryboardManager viewControllerWithFileName:SBNameCommon identifier:VCIDPhotoScanner];
}
- (void)showImageModels:(NSArray *)imageModels fromIndex:(NSInteger)index{
    //NSLog(@"showimage");
    _jumpToIndex = index;
    _imageModels = imageModels;
    [self.collectionView reloadData];
}

- (void)showImage:(NSArray *)imageArray fromIndex:(NSInteger)index {
    _jumpToIndex = index;
    _imageSourceArray = imageArray;
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.imageSourceArray) {
        return self.imageSourceArray.count;
    } else {
        return self.imageModels.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCPhotoScannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell restoreInitState];
    cell.delegate = self;
    NSInteger index = indexPath.item;
    if (index < self.imageModels.count) {
        cell.imageModel = [self.imageModels objectAtIndex:(indexPath.item)];
    }
    if (self.imageSourceArray && index < self.imageSourceArray.count) {
        LCImageUnit * unit = [self.imageSourceArray objectAtIndex:indexPath.item];
        cell.imageSource = unit.image;
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate Layout>
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
}

@end

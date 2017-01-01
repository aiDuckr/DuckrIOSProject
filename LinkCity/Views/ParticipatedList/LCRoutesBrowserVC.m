//
//  LCRoutesBrowserVC.m
//  LinkCity
//
//  Created by roy on 11/15/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCRoutesBrowserVC.h"
#import "LCRoutesBrowserCollectionCell.h"

@interface LCRoutesBrowserVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


@end

@implementation LCRoutesBrowserVC

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self updateShow];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)printConstraint:(UIView *)v{
    NSArray *arr = [self.view constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal];
    NSLog(@"%@\r\n______________End\r\n",arr);
    for (UIView *a in v.subviews){
        [self printConstraint:a];
    }
}

#pragma mark - Interface
- (void)showRoutes:(NSArray *)routes atIndex:(NSInteger)routeIndex{
    _routes = routes;
    _routeIndexShouldShow = routeIndex;
    [self updateShow];
}

- (void)updateShow{
    NSLog(@"update show %@, \r\n routeIndex:%lu",self.routes,(long)self.routeIndexShouldShow);
    if (self.bgImage) {
        self.bgImageView.image = self.bgImage;
    }
    self.pageControl.numberOfPages = self.routes.count;
    if (self.routeIndexShouldShow < self.routes.count) {
        self.pageControl.currentPage = self.routeIndexShouldShow;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSIndexPath *ip = [NSIndexPath indexPathForItem:self.routeIndexShouldShow inSection:0];
//            [self.collectionView selectItemAtIndexPath:ip  animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
//        });
        
        NSIndexPath *ip = [NSIndexPath indexPathForItem:self.routeIndexShouldShow inSection:0];
        [self.collectionView selectItemAtIndexPath:ip  animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
    
    [self.collectionView reloadData];
}

- (IBAction)closeButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.view removeFromSuperview];
}


#pragma mark - UICollectionView DelegateLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size;
}

#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.routes.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCRoutesBrowserCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RoutesBrowserCollectionCell" forIndexPath:indexPath];
    cell.route = [self.routes objectAtIndex:indexPath.item];
    return cell;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float offsetX = self.collectionView.contentOffset.x;
    NSInteger routeIndex = (offsetX + 10)/self.collectionView.frame.size.width;
    self.pageControl.currentPage = routeIndex;
}
@end

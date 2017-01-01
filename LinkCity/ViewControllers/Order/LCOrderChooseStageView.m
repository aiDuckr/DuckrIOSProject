//
//  LCOrderChooseStageView.m
//  LinkCity
//
//  Created by Roy on 12/22/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCOrderChooseStageView.h"
#import "LCOrderChooseStageCell.h"

@interface LCOrderChooseStageView()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *selectableStageArray;
@end
@implementation LCOrderChooseStageView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCOrderChooseStageView class]) bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCOrderChooseStageView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            return (LCOrderChooseStageView *)v;
        }
    }
    
    return nil;
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(DEVICE_WIDTH, 340);
}

- (void)awakeFromNib{
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(24, 18, 24, 18);
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LCOrderChooseStageCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LCOrderChooseStageCell class])];
}

- (void)updateShowWithPlan:(LCPlanModel *)plan{
    self.plan = plan;
    
    self.selectableStageArray = [[NSMutableArray alloc] init];
    for (LCPartnerStageModel *stage in self.plan.stageArray){
        NSDate *startTime = [LCDateUtil dateFromString:stage.startTime];
        
        BOOL canBuy = NO;
        if (startTime &&
            [startTime timeIntervalSinceNow] > 0-SEC_PER_DAY &&
            stage.joinNumber < stage.totalNumber) {
            
            canBuy = YES;
        }
        
        if (canBuy) {
            [self.selectableStageArray addObject:stage];
        }
    }
    
    [self.collectionView reloadData];
}

- (IBAction)cancelBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(orderChooseStageViewDidCancel:)]) {
        [self.delegate orderChooseStageViewDidCancel:self];
    }
}

#pragma mark UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.selectableStageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCOrderChooseStageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCOrderChooseStageCell class]) forIndexPath:indexPath];
    LCPartnerStageModel *stage = [self.selectableStageArray objectAtIndex:indexPath.item];
    
    [cell updateShowWithStage:stage];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 18;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 24;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(95, 100);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(orderChooseStageView:didChooseStage:)]) {
        LCPartnerStageModel *stage = [self.selectableStageArray objectAtIndex:indexPath.item];
        [self.delegate orderChooseStageView:self didChooseStage:stage];
    }
}



@end

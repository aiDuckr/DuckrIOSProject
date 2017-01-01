//
//  LCRecommendUsersOfPlanView.m
//  LinkCity
//
//  Created by roy on 6/1/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCRecommendUsersOfPlanView.h"
#import "LCRecommendUserOfPlanCell.h"


#define NumPerRow (3)
#define UserCellHeight (118)
@interface LCRecommendUsersOfPlanView()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end
@implementation LCRecommendUsersOfPlanView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:@"LCRecommendUsersOfPlanView" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCRecommendUsersOfPlanView class]]) {
            LCRecommendUsersOfPlanView *recommmendView = (LCRecommendUsersOfPlanView *)v;
            [recommmendView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
            return recommmendView;
        }
    }
    
    return nil;
}
+ (CGFloat)getViewHeightWithUsers:(NSArray *)userArray{
    return 500;
}



- (void)awakeFromNib{
    [super awakeFromNib];
    
    [[LCUIConstants sharedInstance] setViewAsInputBg:self.userViewInnerBorder];
    
    self.userCollectionView.delegate = self;
    self.userCollectionView.dataSource = self;
    self.userCollectionView.scrollEnabled = NO;
    [self.userCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LCRecommendUserOfPlanCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LCRecommendUserOfPlanCell class])];
    
    
    [self updateShow];
}

- (void)setUserArray:(NSArray *)userArray{
    _userArray = userArray;
    
    self.userSelectionArray = [[NSMutableArray alloc] initWithCapacity:userArray.count];
    for (int i=0; i<userArray.count; i++){
        [self.userSelectionArray addObject:[NSNumber numberWithBool:YES]];
    }
    
    [self updateShow];
}

- (void)updateShow{
    if (self.userArray && self.userArray.count>3) {
        self.userViewHolder.hidden = NO;
        self.userCollectionViewHeight.constant = UserCellHeight * 2 + 2;
        self.planSectionViewTop.constant = 450;
    }else if(self.userArray && self.userArray.count>0) {
        self.userViewHolder.hidden = NO;
        self.userCollectionViewHeight.constant = UserCellHeight +2;
        self.planSectionViewTop.constant = 450 - UserCellHeight;
    }else{
        self.userViewHolder.hidden = YES;
        self.planSectionViewTop.constant = 60;
    }
    
    
    [self.userCollectionView reloadData];
}

#pragma mark Button Action
- (IBAction)seePlanDetailAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(recommendUsersOfPlanViewDidClickSeePlanDetail:)]) {
        [self.delegate recommendUsersOfPlanViewDidClickSeePlanDetail:self];
    }
}
- (IBAction)inviteButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(recommendUsersOfPlanViewDidClickInvite:)]) {
        [self.delegate recommendUsersOfPlanViewDidClickInvite:self];
    }
}


#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.userArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCRecommendUserOfPlanCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCRecommendUserOfPlanCell class]) forIndexPath:indexPath];
    LCUserModel *user = [self.userArray objectAtIndex:indexPath.item];
    cell.user = user;
    cell.selected = [[self.userSelectionArray objectAtIndex:indexPath.item] boolValue];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    BOOL formerSelection = [[self.userSelectionArray objectAtIndex:indexPath.item] boolValue];
    [self.userSelectionArray replaceObjectAtIndex:indexPath.item withObject:[NSNumber numberWithBool:!formerSelection]];
    LCRecommendUserOfPlanCell *cell = (LCRecommendUserOfPlanCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.isSelected = !formerSelection;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(collectionView.frame.size.width/NumPerRow-1, UserCellHeight);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}



















@end



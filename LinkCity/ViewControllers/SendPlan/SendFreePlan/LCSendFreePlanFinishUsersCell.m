//
//  LCSendFreePlanFinishUsersCell.m
//  LinkCity
//
//  Created by Roy on 12/14/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCSendFreePlanFinishUsersCell.h"
#import "LCSendFreePlanFinishAUserCell.h"


#define UserCellWidth ((DEVICE_WIDTH - UserCellMarginLeft) / 4.5f )
@interface LCSendFreePlanFinishUsersCell()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation LCSendFreePlanFinishUsersCell



- (void)awakeFromNib {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, UserCellMarginLeft, 0, UserCellMarginLeft);
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LCSendFreePlanFinishAUserCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LCSendFreePlanFinishAUserCell class])];
    
}

- (void)setUserArray:(NSArray *)userArray{
    _userArray = userArray;
    self.selectionArray = [[NSMutableArray alloc] init];
    for (int i=0; i<userArray.count; i++){
        [self.selectionArray addObject:[NSNumber numberWithBool:YES]];
    }
    
    [self updateShow];
}

- (void)updateShow{
    
    [self.collectionView reloadData];
    [self.collectionView setNeedsLayout];
    [self.collectionView layoutIfNeeded];
}

- (IBAction)inviteBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sendFreePlanFinishUsersCellDidClickInvite:)]) {
        [self.delegate sendFreePlanFinishUsersCellDidClickInvite:self];
    }
}



#pragma mark -
#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.userArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCSendFreePlanFinishAUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCSendFreePlanFinishAUserCell class]) forIndexPath:indexPath];
    
    BOOL selected = [[self.selectionArray objectAtIndex:indexPath.item] boolValue];
    LCUserModel *user = [self.userArray objectAtIndex:indexPath.item];
    
    [cell updateShowWithUser:user selected:selected];

    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return cell;
}
#pragma mark UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    BOOL formerSelection = [[self.selectionArray objectAtIndex:indexPath.item] boolValue];
    [self.selectionArray replaceObjectAtIndex:indexPath.item withObject:[NSNumber numberWithBool:!formerSelection]];
    LCSendFreePlanFinishAUserCell *cell = (LCSendFreePlanFinishAUserCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell updateShowWithUser:[self.userArray objectAtIndex:indexPath.item] selected:!formerSelection];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(UserCellWidth, 118);
}


@end

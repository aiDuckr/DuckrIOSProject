//
//  LCCostPlanDescCell.m
//  LinkCity
//
//  Created by Roy on 12/21/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCCostPlanDescCell.h"
#import "LCPlanDetailStageLayout.h"
#import "LCCostPlanStageCell.h"

#define StageCellGap 12
#define StageCellMarginLeft 12
#define StageCellHeight 100
#define StageCellWidth ( DEVICE_WIDTH - StageCellMarginLeft - StageCellGap * 3 ) / 3.5

@interface LCCostPlanDescCell()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@end
@implementation LCCostPlanDescCell

- (void)awakeFromNib {
    self.stageCollectionView.delegate = self;
    self.stageCollectionView.dataSource = self;
    LCPlanDetailStageLayout *layout = [LCPlanDetailStageLayout new];
    [self.stageCollectionView setCollectionViewLayout: layout];
    self.stageCollectionView.contentInset = UIEdgeInsetsMake(0, StageCellMarginLeft, 0, StageCellMarginLeft);
    self.stageCollectionView.showsHorizontalScrollIndicator = NO;
    self.stageCollectionView.backgroundColor = UIColorFromRGBA(0xfafaf7, 1);
    [self.stageCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanStageCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LCCostPlanStageCell class])];
}

- (void)updateShowWithPlan:(LCPlanModel *)plan{
    self.plan = plan;
    
    //depart and dest label
    [self.departAndDestLabel setText:[self.plan getDepartAndDestString] withLineSpace:LCTextFieldLineSpace];
    
    //time label
    if (self.plan.daysLong == 0) {
        self.plan.daysLong = 1;
    }
    NSString *timeStr = [NSString stringWithFormat:@"%@   全程%ld天",
                         [LCDateUtil getDotDateFromHorizontalLineStr:self.plan.startTime],
                         (long)self.plan.daysLong];
    self.timeLabel.text = timeStr;
    
    self.numLabel.text = [NSString stringWithFormat:@"邀约%ld人",(long)self.plan.scaleMax];
    
    [self.stageCollectionView reloadData];
    
    //creater info
    if (self.plan.memberList.count > 0) {
        LCUserModel *creater = [self.plan.memberList objectAtIndex:0];
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:creater.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
        self.nickLabel.text = creater.nick;
    }
    
    [self.descLabel setText:[LCStringUtil getNotNullStr:self.plan.descriptionStr] withLineSpace:LCTextFieldLineSpace];
    [self.includeLabel setText:[LCStringUtil getNotNullStr:self.plan.costInclude] withLineSpace:LCTextFieldLineSpace];
    [self.excludeLabel setText:[LCStringUtil getNotNullStr:self.plan.costExclude] withLineSpace:LCTextFieldLineSpace];
    [self.refundLabel setText:[LCStringUtil getNotNullStr:[LCDataManager sharedInstance].orderRule.refundDescription] withLineSpace:LCTextFieldLineSpace];
    
}

#pragma mark ButtonAction
- (IBAction)createrBtnAction:(id)sender {
    if (self.plan.memberList.count>0) {
        LCUserModel *creater = [self.plan.memberList firstObject];
        [LCViewSwitcher pushToShowUserInfoVCForUser:creater on:[LCSharedFuncUtil getTopMostViewController].navigationController];
    }
}


#pragma mark UICollectionView 
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.plan.stageArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCCostPlanStageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCCostPlanStageCell class]) forIndexPath:indexPath];
    LCPartnerStageModel *stage = [self.plan.stageArray objectAtIndex:indexPath.item];
    BOOL isCreater = [self.plan getPlanRelation] == LCPlanRelationCreater;
    [cell updateShowWithStage:stage isCreater:isCreater];
    
    return cell;
}
#pragma mark UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    if ([self.delegate respondsToSelector:@selector(costPlanDescCell:didClickStage:)]) {
        LCPartnerStageModel *stage = [self.plan.stageArray objectAtIndex:indexPath.item];
        [self.delegate costPlanDescCell:self didClickStage:stage];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(95, StageCellHeight);
}




@end

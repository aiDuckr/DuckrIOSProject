//
//  LCSendPlanDetailTagCell.h
//  LinkCity
//
//  Created by lhr on 16/4/16.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCSendFreePlanDetailTagCellDeleagte <NSObject>

- (void)didSelectTag;

@end

@interface LCSendPlanDetailTagCell : UITableViewCell

@property (nonatomic,strong) NSArray *tagItemArray;

@property (nonatomic,strong) NSArray *selectedItemArrStr;

@property (nonatomic,assign) BOOL isInTheSameCity;

@property (nonatomic,weak) id <LCSendFreePlanDetailTagCellDeleagte> delegate;
- (void)updateShowWithPlan:(LCPlanModel *)plan;
@end

//
//  LCPlanDetailTourPicInfoCell.h
//  LinkCity
//
//  Created by lhr on 16/5/9.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCPlanDetailTourPicInfoCellDelegate <NSObject>

- (void)didPressImageViewWithTourPlan:(LCTourpic *)tourpic;

- (void)didPressImageViewForMoreTourpics;

@end

@interface LCPlanDetailTourPicInfoCell : UITableViewCell

@property (weak, nonatomic) id <LCPlanDetailTourPicInfoCellDelegate> delegate;

- (void)bindWithData:(NSArray *)tourPicList;


@end

//
//  LCPlanDetailQuitCell.h
//  LinkCity
//
//  Created by roy on 3/1/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPlanDetailBaseCell.h"

@protocol LCPlanDetailQuitCellDelegate;
@interface LCPlanDetailQuitCell : LCPlanDetailBaseCell
//Data
@property (nonatomic, weak) id<LCPlanDetailQuitCellDelegate> delegate;
//UI
@property (weak, nonatomic) IBOutlet UIButton *quitButton;



@end


@protocol LCPlanDetailQuitCellDelegate <NSObject>

- (void)planDetailQuitCellDidClickQuit:(LCPlanDetailQuitCell *)quitCell;

@end
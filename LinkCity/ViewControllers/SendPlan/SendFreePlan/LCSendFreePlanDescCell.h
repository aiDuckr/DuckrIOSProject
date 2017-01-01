//
//  LCSendFreePlanImageTopCell.h
//  LinkCity
//
//  Created by Roy on 12/13/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextView.h"

@protocol LCSendFreePlanDescCellDelegate;
@interface LCSendFreePlanDescCell : UITableViewCell
@property (nonatomic, weak) id<LCSendFreePlanDescCellDelegate> delegate;
@property (nonatomic, strong) LCPlanModel *plan;
@property (nonatomic, assign) NSInteger uploadingImageNum;
@property (weak, nonatomic) IBOutlet SZTextView *descTextView;

//+ (instancetype)createInstance;
- (void)updateShowWithPlan:(LCPlanModel *)plan;

@end

@protocol LCSendFreePlanDescCellDelegate <NSObject>
@optional

- (void)sendFreePlanImageAndDescCellDidEndInputDescription:(LCSendFreePlanDescCell *)topCell;


@end

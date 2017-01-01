//
//  LCPlanDetailRouteCell.h
//  LinkCity
//
//  Created by roy on 2/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPlanDetailBaseCell.h"

@protocol LCPlanDetailRouteCellDelegate;
@interface LCPlanDetailRouteCell : LCPlanDetailBaseCell

//Data
@property (nonatomic,weak) id<LCPlanDetailRouteCellDelegate> delegate;

//UI
@property (weak, nonatomic) IBOutlet UIImageView *topBg;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBg;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@protocol LCPlanDetailRouteCellDelegate <NSObject>

- (void)planDetailRouteCell:(LCPlanDetailRouteCell *)routeCell didSelectDayIndex:(NSInteger)index;

@end
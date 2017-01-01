//
//  LCUserInfoPagePlansTableCell.h
//  LinkCity
//
//  Created by roy on 11/23/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPlan.h"

@interface LCUserInfoPagePlansTableCell : UITableViewCell
@property (nonatomic,strong) LCPlan *plan;

- (void)showPlan:(LCPlan *)plan asFirstCell:(BOOL)isFirstCell asLastCell:(BOOL)isLastCell;
@end

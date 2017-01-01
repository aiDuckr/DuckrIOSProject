//
//  LCParticipatedTableCell.h
//  LinkCity
//
//  Created by roy on 11/19/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCReceptionPlan.h"
#import "LCPartnerPlan.h"

@interface LCParticipatedTableCell : UITableViewCell
@property (nonatomic,strong) LCPlan *plan;

- (void)showPlan:(LCPlan *)plan asLastCell:(BOOL)lastCell asFirstCell:(BOOL)firstCell;
@end


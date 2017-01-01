//
//  LCFavorTableCell.h
//  LinkCity
//
//  Created by roy on 11/20/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCReceptionPlan.h"
#import "LCPartnerPlan.h"

@interface LCFavorTableCell : UITableViewCell
@property (nonatomic,strong) LCReceptionPlan *receptionPlan;
@property (nonatomic,strong) LCPartnerPlan *partnerPlan;
@end

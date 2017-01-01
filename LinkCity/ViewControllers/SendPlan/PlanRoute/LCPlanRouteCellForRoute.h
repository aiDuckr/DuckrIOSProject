//
//  LCPlanRouteCellForRoute.h
//  LinkCity
//
//  Created by roy on 2/10/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCRoutePlaceModel.h"

@interface LCPlanRouteCellForRoute : UITableViewCell
@property (nonatomic, strong) LCRoutePlaceModel *routePlace;

@property (weak, nonatomic) IBOutlet UIImageView *routeImageView;
@property (weak, nonatomic) IBOutlet UILabel *routeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeDetailLabel;
@end

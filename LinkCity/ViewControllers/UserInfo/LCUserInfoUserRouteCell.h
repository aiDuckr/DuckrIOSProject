//
//  LCUserInfoUserRouteCell.h
//  LinkCity
//
//  Created by roy on 3/7/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUserRouteModel.h"

@interface LCUserInfoUserRouteCell : UITableViewCell
@property (nonatomic, strong) LCUserRouteModel *userRoute;


@property (weak, nonatomic) IBOutlet UIImageView *routeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *routeMaskImageView;

@property (weak, nonatomic) IBOutlet UILabel *routeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeDayNumLabel;


@property (weak, nonatomic) IBOutlet UILabel *routeLabelOne;
@property (weak, nonatomic) IBOutlet UILabel *routeLabelTwo;
@property (weak, nonatomic) IBOutlet UILabel *routeLabelThree;
@property (weak, nonatomic) IBOutlet UILabel *routeLabelFour;


+ (CGFloat)getCellHeightForUserRoute:(LCUserRouteModel *)userRoute;
@end

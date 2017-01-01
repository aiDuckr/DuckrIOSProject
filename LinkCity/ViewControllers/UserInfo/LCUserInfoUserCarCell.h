//
//  LCUserInfoUserCarCell.h
//  LinkCity
//
//  Created by roy on 3/7/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCarIdentityModel.h"

@interface LCUserInfoUserCarCell : UITableViewCell
@property (nonatomic, strong) LCCarIdentityModel *userCar;

@property (weak, nonatomic) IBOutlet UIImageView *topBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;

@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UILabel *carBrandLabel;

@property (weak, nonatomic) IBOutlet UILabel *drivingYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *carYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *seatLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *carAreaLabel;



+ (CGFloat)getCellHeight;
@end

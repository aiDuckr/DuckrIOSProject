//
//  LCNearbyUserCell.h
//  LinkCity
//
//  Created by roy on 3/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUserModel.h"

@interface LCNearbyUserCell : UITableViewCell
@property (nonatomic, strong) LCUserModel *user;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *identifiedImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *livingPlace;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@property (weak, nonatomic) IBOutlet UIImageView *professionImageView;

@property (weak, nonatomic) IBOutlet UIImageView *serviceOneImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serviceOneImageLeading;


@property (weak, nonatomic) IBOutlet UIImageView *serviceTwoImageView;

@property (weak, nonatomic) IBOutlet UILabel *slogonLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;


+ (CGFloat)getCellHeight;
@end

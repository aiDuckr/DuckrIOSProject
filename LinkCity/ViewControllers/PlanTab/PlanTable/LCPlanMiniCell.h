//
//  LCPlanMiniCell.h
//  LinkCity
//
//  Created by roy on 6/1/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPlanModel.h"

@interface LCPlanMiniCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *holderWithBorderView;
@property (weak, nonatomic) IBOutlet UIImageView *planImageView;

@property (weak, nonatomic) IBOutlet UIImageView *labelMaskView;
@property (weak, nonatomic) IBOutlet UILabel *createrLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;


@property (nonatomic, strong) LCPlanModel *plan;

+ (CGFloat)getCellHeight;

@end

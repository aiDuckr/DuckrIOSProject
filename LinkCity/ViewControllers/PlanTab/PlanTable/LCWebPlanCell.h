//
//  LCWebPlanCell.h
//  LinkCity
//
//  Created by roy on 6/1/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCWebPlanModel.h"

@interface LCWebPlanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *planImageView;
@property (weak, nonatomic) IBOutlet UILabel *routeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *createrNickLabel;
@property (weak, nonatomic) IBOutlet UIButton *createrContactButton;
@property (weak, nonatomic) IBOutlet UILabel *fromWhereLabel;
@property (nonatomic, strong) LCWebPlanModel *webPlanModel;

- (void)updateShowWebPlan:(LCWebPlanModel *)webPlanModel;

@end

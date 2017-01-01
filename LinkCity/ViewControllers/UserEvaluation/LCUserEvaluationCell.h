//
//  LCUserInfoEvaluationCell.h
//  LinkCity
//
//  Created by roy on 3/3/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUserEvaluationModel.h"
#import "LCLabel.h"

@interface LCUserEvaluationCell : UITableViewCell
@property (nonatomic, strong) LCUserEvaluationModel *userEvaluation;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeight;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagLabelHeight;
@property (weak, nonatomic) IBOutlet LCLabel *tagOneLabel;
@property (weak, nonatomic) IBOutlet LCLabel *tagTwoLabel;
@property (weak, nonatomic) IBOutlet LCLabel *tagThreeLabel;
@property (weak, nonatomic) IBOutlet LCLabel *tagFourLabel;




+ (CGFloat)getCellHeightForEvaluation:(LCUserEvaluationModel *)userEvaluation;
@end

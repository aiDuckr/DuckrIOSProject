//
//  LCRecommendUserOfPlanCell.h
//  LinkCity
//
//  Created by roy on 6/1/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUserModel.h"

@interface LCRecommendUserOfPlanCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectionImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) LCUserModel *user;
@end

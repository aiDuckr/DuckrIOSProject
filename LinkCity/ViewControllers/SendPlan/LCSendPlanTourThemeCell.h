//
//  LCSendPlanTourThemeCell.h
//  LinkCity
//
//  Created by 张宗硕 on 8/3/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCSendPlanTourThemeCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

- (void)updateShowSendPlanTourThemeCell:(LCRouteThemeModel *)theme;
@end

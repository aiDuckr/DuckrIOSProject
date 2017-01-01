//
//  LCUserInfoEvaluationTitleCell.h
//  LinkCity
//
//  Created by roy on 3/3/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCUserEvaluationTitleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


+ (CGFloat)getCellHeightWithTopSpace:(CGFloat)topSpace;
- (void)setUserEvaluationNum:(NSInteger)evaluationNum;

@end

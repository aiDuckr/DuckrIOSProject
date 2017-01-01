//
//  LCPlanRouteCellForDay.h
//  LinkCity
//
//  Created by roy on 2/10/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCPlanRouteCellForDay : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dayTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;


- (void)setFolded:(BOOL)folded;
- (void)animateToFolded;
- (void)animateToUnfolded;
@end

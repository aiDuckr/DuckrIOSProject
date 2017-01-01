//
//  LCHomeVCSectionFooterCell.h
//  LinkCity
//
//  Created by Roy on 8/21/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCHomeVCSectionFooterCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



+ (CGFloat)getCellHeight;
- (void)updateShowForSeeMorePlan;
- (void)updateShowForSeeMoreUser;
@end

//
//  LCUserInfoSectionHeaderCell.h
//  LinkCity
//
//  Created by Roy on 8/26/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCUserInfoSectionHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



+ (CGFloat)getCellHeight;
@end

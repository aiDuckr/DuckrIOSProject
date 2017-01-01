//
//  LCPublishNewItemCell.h
//  LinkCity
//
//  Created by Roy on 6/7/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCPublishNewItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *publishButton;

+ (CGFloat)getCellHeight;
@end

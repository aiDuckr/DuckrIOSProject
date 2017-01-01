//
//  LCBillTitleCell.h
//  LinkCity
//
//  Created by Roy on 6/25/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCBillTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *borderBg;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


+ (CGFloat)getCellHeight;
@end

//
//  LCDepositIntroCell.h
//  LinkCity
//
//  Created by Roy on 6/25/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCDepositIntroCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


+ (CGFloat)getCellHeight;
@end

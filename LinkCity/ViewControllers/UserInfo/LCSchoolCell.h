//
//  LCSchoolCell.h
//  LinkCity
//
//  Created by roy on 5/31/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCSchoolCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;


+ (CGFloat)getCellHeight;
@end

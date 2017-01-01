//
//  LCMoreButtonCell.h
//  LinkCity
//
//  Created by roy on 6/4/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCMoreButtonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

+ (CGFloat)getCellHeight;
@end

//
//  LCReportUserCell.h
//  LinkCity
//
//  Created by godhangyu on 16/6/13.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCReportUserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *reportReason;
@property (weak, nonatomic) IBOutlet UIImageView *reportSelectedIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separateLineHeight;


- (void)updateCellWithReason:(NSString *)reason isHaveSeparateLine:(BOOL)separateLine;

@end

//
//  LCIconTextArrowCell.h
//  LinkCity
//
//  Created by 张宗硕 on 12/14/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCIconTextArrowCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *middleTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

- (void)updateShowIconText:(NSString *)textStr withIconImageName:(NSString *)imageNameStr;
@end

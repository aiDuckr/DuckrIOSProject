//
//  LCHomeHotThemeCell.h
//  LinkCity
//
//  Created by 张宗硕 on 7/28/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCHomeHotThemeCell : UITableViewCell
@property (strong, nonatomic) LCHomeRcmd *homeRcmd;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *themeContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *themeContentWidthConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (void)updateHomeHotThemeCell:(LCHomeRcmd *)homeRcmd;
@end

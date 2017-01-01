//
//  LCHomeRcmdCell.h
//  LinkCity
//
//  Created by 张宗硕 on 7/27/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCHomeRcmdCell;
@protocol LCHomeRcmdCellDelegate <NSObject>
- (void)chooseUpperRightButton:(LCHomeRcmdCell *)cell;

@end

@interface LCHomeRcmdCell : UITableViewCell
@property (nonatomic, strong) LCHomeRcmd *homeRcmd;
@property (assign, nonatomic) BOOL isChoosed;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *departDestLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIButton *upperRightButton;
@property (weak, nonatomic) IBOutlet UIButton *themeButton;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelGapConstraint;
@property (weak, nonatomic) IBOutlet UIView *usersView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usersViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *likeOrBuyLabel;
@property (weak, nonatomic) IBOutlet UILabel *editSelectLabel;
@property (weak, nonatomic) IBOutlet UIView *otherView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;


@property (strong, nonatomic) id<LCHomeRcmdCellDelegate> delegate;

- (void)updateHomeRcmdCell:(LCHomeRcmd *)homeRcmd;
- (void)updateUpperRightButton:(BOOL)isChoosed;

@end
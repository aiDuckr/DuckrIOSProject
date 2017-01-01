//
//  LCWithWhoCell.h
//  LinkCity
//
//  Created by 张宗硕 on 3/23/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCWithWhoCell : UITableViewCell
///UI
/// 头像.
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
/// 姓名.
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/// 是否已经选择的图标显示.
@property (weak, nonatomic) IBOutlet UIButton *checkboxButton;

@end

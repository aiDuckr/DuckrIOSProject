//
//  LCLocalFreetimeCell.h
//  LinkCity
//
//  Created by linkcity on 16/7/29.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCLocalFreetimeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIView *sexView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *constellationLabel;//星座(改为职业)
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;//主题标签
@property (weak, nonatomic) IBOutlet UILabel *timeanddistanceLabel;//时间距离标签

@property (strong, nonatomic) LCUserModel *user;//数据

- (void)updateShowCell:(LCUserModel *)user;

@end

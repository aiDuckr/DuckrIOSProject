//
//  LCHomeBannerCell.h
//  LinkCity
//
//  Created by 张宗硕 on 7/28/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCHomeBannerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (strong, nonatomic) LCHomeRcmd *homeRcmd;

- (void)updateHomeBannerCell:(LCHomeRcmd *)homeRcmd;
@end

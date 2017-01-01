//
//  LCHomeLocalPlaceCell.h
//  LinkCity
//
//  Created by 张宗硕 on 5/17/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCHomeLocalPlaceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *weatherNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherWindLabel;

- (void)updateShowCell:(LCCityModel *)cityObj withWeatherDay:(LCWeatherDay *)weatherDay;
@end

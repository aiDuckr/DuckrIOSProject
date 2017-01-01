//
//  LCPlaceSearchWeatherCell.h
//  LinkCity
//
//  Created by 张宗硕 on 12/18/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCPlaceSearchWeatherCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *todayViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tomorrowWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *dayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *tDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tWeatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *tDayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *afDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *afWeatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *afDayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *afTemperatureLabel;

- (void)updateShowWeather:(NSArray *)weaterArray;
@end
